import GL
import GLFW

include("bsp.jl")

const vertex_shader_src = "
#version 420

uniform mat4 ModelMatrix;
uniform mat4 ViewMatrix;
uniform mat4 ProjMatrix;

uniform vec4 TexU;
uniform vec4 TexV;

uniform vec3 Light1Position;

in vec3 VertexPosition;

out vec3 FragPosition;
out vec3 Light1Direction;
out float Light1Distance;

void main()
{
	FragPosition = VertexPosition;
	Light1Direction = normalize(Light1Position - VertexPosition);
	Light1Distance = distance(Light1Position, VertexPosition);
	const vec4 pos = vec4(VertexPosition, 1.0);
	gl_Position = ProjMatrix * ViewMatrix * ModelMatrix * pos;
}
"

const fragment_shader_src = "
#version 420

uniform vec3 FaceNormal;

uniform vec3 Light1Position;
uniform vec3 Light1Color;
uniform float Light1Power;

in vec3 FragPosition;
in vec3 Light1Direction;
in float Light1Distance;

out vec4 FragColor;

void main()
{
	float dirMod = dot(FaceNormal, normalize(Light1Position - FragPosition)); // -1 to 1
	dirMod = max(0.3 + 0.6 * dirMod, 0);
	float distMod = (Light1Power - distance(Light1Position, FragPosition)) / Light1Power;
	const vec3 LightColor = Light1Color * dirMod * pow(clamp(distMod, 0.0, 1.0), 2);
	FragColor = vec4(LightColor, 1.0);
}
"

const near = 4
const far = 16384
projMatrix = float32(eye(4))
fov = 90.0

function translationMatrix(x::Number, y::Number, z::Number)
	T = float32(eye(4))
	T[13] = float32(x)
	T[14] = float32(y)
	T[15] = float32(z)
	return T
end

modelMatrix = translationMatrix(0, 0, 0)

function updateProjMatrix(width::Cint, height::Cint)
	GL.Viewport(width, height)

	aspect = width / height
	ymax = near * tan(fov * pi / 360)
	ymin = -ymax
	xmin = ymin * aspect
	xmax = ymax * aspect

	x = (2*near) / (xmax-xmin)
	y = (2*near) / (ymax-ymin)
	a = (xmax+xmin) / (xmax-xmin)
	b = (ymax+ymin) / (ymax-ymin)
	c = -(far+near) / (far-near)
	d = -(2*far*near) / (far-near)

	projMatrix[1,1] = x
	projMatrix[1,3] = a
	projMatrix[2,2] = y
	projMatrix[2,3] = b
	projMatrix[3,3] = c
	projMatrix[3,4] = d
	projMatrix[4,3] = -1
	projMatrix[4,4] = 0

	return
end

bspFile = open(ARGS[1])
bsp = bspRead(bspFile)
close(bspFile)

GLFW.Init()
GLFW.OpenWindowHint(GLFW.OPENGL_VERSION_MAJOR, 4)
GLFW.OpenWindowHint(GLFW.OPENGL_VERSION_MINOR, 2)
GLFW.OpenWindowHint(GLFW.OPENGL_PROFILE, GLFW.OPENGL_CORE_PROFILE)
GLFW.OpenWindowHint(GLFW.OPENGL_FORWARD_COMPAT, 1)
GLFW.OpenWindow(0, 0, 0, 0, 0, 0, 0, 0, GLFW.WINDOW)
GLFW.SetWindowTitle("Quake 2.jl")
GLFW.SetWindowSizeCallback(updateProjMatrix)
GLFW.SwapInterval(0)

println("Red bits:     ", GLFW.GetWindowParam(GLFW.RED_BITS))
println("Green bits:   ", GLFW.GetWindowParam(GLFW.GREEN_BITS))
println("Blue bits:    ", GLFW.GetWindowParam(GLFW.BLUE_BITS))
println("Alpha bits:   ", GLFW.GetWindowParam(GLFW.ALPHA_BITS))
println("Depth bits:   ", GLFW.GetWindowParam(GLFW.DEPTH_BITS))
println("Stencil bits: ", GLFW.GetWindowParam(GLFW.STENCIL_BITS))

GL.Enable(GL.CULL_FACE)
GL.Enable(GL.DEPTH_TEST)

println("Vendor:   ", GL.GetString(GL.VENDOR))
println("Renderer: ", GL.GetString(GL.RENDERER))
println("Version:  ", GL.GetString(GL.VERSION))
println("GLSL:     ", GL.GetString(GL.SHADING_LANGUAGE_VERSION))

vertex_shader = GL.CreateShader(GL.VERTEX_SHADER)
GL.ShaderSource(vertex_shader, vertex_shader_src)
GL.CompileShader(vertex_shader)

fragment_shader = GL.CreateShader(GL.FRAGMENT_SHADER)
GL.ShaderSource(fragment_shader, fragment_shader_src)
GL.CompileShader(fragment_shader)

prog = GL.CreateProgram()
GL.AttachShader(prog, vertex_shader)
GL.AttachShader(prog, fragment_shader)
GL.LinkProgram(prog)

uModel = GL.Uniform(prog, "ModelMatrix")
uView = GL.Uniform(prog, "ViewMatrix")
uProj = GL.Uniform(prog, "ProjMatrix")

uNormal = GL.Uniform(prog, "FaceNormal")

#uTexU = GL.Uniform(prog, "TexU")
#uTexV = GL.Uniform(prog, "TexV")

aPosition = GL.GetAttribLocation(prog, "VertexPosition")

vao = GL.GenVertexArray()
GL.BindVertexArray(vao)

positionBuf = GL.GenBuffer()
GL.BindBuffer(GL.ARRAY_BUFFER, positionBuf)
GL.BufferData(GL.ARRAY_BUFFER, bsp.vertices, GL.STATIC_DRAW)
GL.EnableVertexAttribArray(aPosition)
GL.VertexAttribPointer(aPosition, 3, GL.FLOAT, false, 0, 0)
GL.BindBuffer(GL.ARRAY_BUFFER, 0)

GL.BindVertexArray(0)

frames = 0
tic()
tic()

cam_speed = 200 # unit/sec
cam_pos = GL.Vec3(0, 0, 0)

m_captured = false
function m_capture(capture::Bool)
	if capture
		GLFW.Disable(GLFW.MOUSE_CURSOR)
		GLFW.SetMousePos(0, 0)
		global m_captured = true
	else
		GLFW.Enable(GLFW.MOUSE_CURSOR)
		global m_captured = false
	end
end
m_capture() = m_captured

# cursor xy to degree ratio
const m_pitch = 0.05
const m_yaw = 0.05

cam_yaw = 0
cam_pitch = 0

function mouseToSphere(xdelta::Real, ydelta::Real)
	global cam_yaw -= m_yaw * xdelta
	global cam_pitch -= m_pitch * ydelta
	global cam_pitch = clamp(cam_pitch, -89, 89)
	return (cam_yaw, cam_pitch)
end

function sphereToCartesian(yaw::Real, pitch::Real)
	# convert to radians
	yaw *= (pi / 180)
	pitch *= (pi / 180)

	x = cos(yaw)*cos(pitch)
	y = sin(yaw)*cos(pitch)
	z = sin(pitch)
	return GL.Vec3(x, y, z)
end

function rotationMatrix{T<:Real}(eyeDir::AbstractVector{T}, upDir::AbstractVector{T})
	rightDir = cross(eyeDir, upDir)
	rightDir /= norm(rightDir)
	upDir = cross(rightDir, eyeDir)

	rotMat = eye(T, 4)
	rotMat[1,1:3] = rightDir
	rotMat[2,1:3] = upDir
	rotMat[3,1:3] = -eyeDir

	return rotMat
end

light1position = GL.Uniform(prog, "Light1Position")
light1color = GL.Uniform(prog, "Light1Color")
light1power = GL.Uniform(prog, "Light1Power")

GL.UseProgram(prog)

light1_pos = GL.Vec3(250, 0, 55)
light1_pow = float32(500)
write(light1color, GL.Vec3(1.0, 0.8, 0.5))

function mouse_wheel_cb(pos::Cint)
	global light1_pow += pos * 10
	global light1_pow = max(light1_pow, 10)
	GLFW.SetMouseWheel(0)
	return
end
GLFW.SetMouseWheelCallback(mouse_wheel_cb)

while GLFW.GetWindowParam(GLFW.OPENED)
	if m_capture()
		mouseToSphere(GLFW.GetMousePos()...)
		GLFW.SetMousePos(0, 0)
	end
	eyeDir = sphereToCartesian(cam_yaw, cam_pitch)
	rightDir = cross(eyeDir, GL.Vec3(0, 0, 1))
	rightDir /= norm(rightDir)
	rotMat = rotationMatrix(eyeDir, float32([0, 0, 1]))
	dist = cam_speed * toq()
	if m_capture()
		if GLFW.GetKey(GLFW.KEY_LSHIFT)
			dist *= 3
		end
		if GLFW.GetKey(',')
			cam_pos += dist * eyeDir
		end
		if GLFW.GetKey('A')
			cam_pos -= dist * rightDir
		end
		if GLFW.GetKey('O')
			cam_pos -= dist * eyeDir
		end
		if GLFW.GetKey('E')
			cam_pos += dist * rightDir
		end
		if GLFW.GetKey(' ')
			println(typeof(dist))
			println(dist)
			
			println(typeof(GL.Vec3(0.0f, 0.0f, dist)))
			GL.GLSLType3{Float32}(0.0f, 0.0f, float32(dist))

			println("aoeuaoeu")
			velocity = GL.Vec3(0, 0, dist)
			println(typeof(velocity))
			println(GL.Vec3(0, 0, dist))

			println(cam_pos + GL.Vec3(0, 0, dist))
			cam_pos += GL.Vec3(0, 0, dist)
			println("yay")
		end
		if GLFW.GetKey(GLFW.KEY_LCTRL)
			cam_pos -= GL.Vec3(0, 0, dist)
		end
	end
	if GLFW.GetMouseButton(GLFW.MOUSE_BUTTON_LEFT)
		m_capture(true)
		light1_pos = cam_pos
	end
	if GLFW.GetKey(GLFW.KEY_ESC)
		m_capture(false)
	end
	tic()

	GL.Clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT)

	GL.UniformMatrix4fv(uModel, modelMatrix)
	transMat = translationMatrix(-cam_pos[1], -cam_pos[2], -cam_pos[3])
	viewMat = rotMat * transMat
	GL.UniformMatrix4fv(uView, viewMat)
	GL.UniformMatrix4fv(uProj, projMatrix)

	write(light1position, light1_pos)
	write(light1power, light1_pow)

	GL.BindVertexArray(vao)

	for face = bsp.faces
		#GL.Uniform4f(uTexU, face.tex_u)
		#GL.Uniform4f(uTexV, face.tex_v)
		write(uNormal, face.normal)
		GL.DrawElements(GL.TRIANGLES, face.indices)
		GL.GetError()
	end

	GL.BindVertexArray(0)

	GLFW.SwapBuffers()
	frames += 1
end

toq()
seconds = toc()
println(frames / seconds, " FPS")

GLFW.Terminate()
