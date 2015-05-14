module Textures

using Images

const WalPalette = (
	(0x00, 0x00, 0x00), (0x1f, 0x1f, 0x1f),
	(0x3f, 0x3f, 0x3f), (0x5b, 0x5b, 0x5b),
	(0x7b, 0x7b, 0x7b), (0x9b, 0x9b, 0x9b),
	(0xbb, 0xbb, 0xbb), (0xdb, 0xdb, 0xdb),
	(0xff, 0xff, 0xff), (0xff, 0xff, 0xff),
	(0xff, 0xff, 0xff), (0xff, 0xff, 0xff),
	(0xff, 0xff, 0xff), (0xff, 0xff, 0xff),
	(0xff, 0xff, 0xff), (0xff, 0xff, 0xff),
	(0xcf, 0x97, 0x4b), (0xa7, 0x7b, 0x3b),
	(0xa7, 0x7b, 0x3b), (0xa7, 0x7b, 0x3b),
	(0x8b, 0x67, 0x2f), (0x8b, 0x67, 0x2f),
	(0x6f, 0x53, 0x27), (0x63, 0x4b, 0x23),
	(0x63, 0x4b, 0x23), (0x53, 0x3f, 0x1f),
	(0x4f, 0x3b, 0x1b), (0x43, 0x2b, 0x17),
	(0x33, 0x27, 0x13), (0x2b, 0x1f, 0x13),
	(0x27, 0x1b, 0x0f), (0x1f, 0x17, 0x0f),
	(0xb3, 0xc7, 0xd3), (0xb3, 0xc7, 0xd3),
	(0xbb, 0xbb, 0xbb), (0xab, 0xab, 0xab),
	(0x9b, 0x9b, 0x9b), (0x9b, 0x9b, 0x9b),
	(0x8b, 0x8b, 0x8b), (0x7b, 0x7b, 0x7b),
	(0x6b, 0x6b, 0x6b), (0x5b, 0x5b, 0x5b),
	(0x5b, 0x5b, 0x5b), (0x4b, 0x4b, 0x4b),
	(0x47, 0x3f, 0x43), (0x3b, 0x37, 0x37),
	(0x2f, 0x2f, 0x2f), (0x27, 0x27, 0x27),
	(0xff, 0xff, 0xa7), (0xeb, 0x97, 0x7f),
	(0xeb, 0x97, 0x7f), (0xcf, 0x97, 0x4b),
	(0xff, 0xff, 0xa7), (0xff, 0xff, 0x7f),
	(0xff, 0xff, 0x53), (0xcf, 0x97, 0x4b),
	(0xff, 0xff, 0x53), (0xff, 0xff, 0x53),
	(0xff, 0xff, 0x53), (0xff, 0xd7, 0x17),
	(0xeb, 0x9f, 0x27), (0xaf, 0x77, 0x1f),
	(0x77, 0x4f, 0x17), (0x43, 0x2b, 0x17),
	(0xeb, 0x97, 0x7f), (0xff, 0x93, 0x00),
	(0xef, 0x7f, 0x00), (0xe3, 0x6b, 0x00),
	(0xd3, 0x57, 0x00), (0xc7, 0x47, 0x00),
	(0xc7, 0x47, 0x00), (0xab, 0x2b, 0x00),
	(0x9b, 0x1f, 0x00), (0x8f, 0x17, 0x00),
	(0x73, 0x17, 0x0b), (0x67, 0x17, 0x07),
	(0x57, 0x13, 0x00), (0x43, 0x0f, 0x00),
	(0x33, 0x0b, 0x00), (0x23, 0x0b, 0x00),
	(0xd7, 0xbb, 0xb7), (0xeb, 0x97, 0x7f),
	(0xeb, 0x97, 0x7f), (0xcb, 0x9b, 0x93),
	(0xbf, 0x7b, 0x6f), (0xa7, 0x8b, 0x77),
	(0x8f, 0x77, 0x53), (0x8f, 0x77, 0x53),
	(0x87, 0x6b, 0x57), (0x7b, 0x5f, 0x4b),
	(0x67, 0x4f, 0x3b), (0x5f, 0x47, 0x37),
	(0x4b, 0x37, 0x2b), (0x3f, 0x2f, 0x23),
	(0x2b, 0x1f, 0x13), (0x1f, 0x17, 0x0f),
	(0xcb, 0x8b, 0x23), (0xaf, 0x77, 0x1f),
	(0x9f, 0x57, 0x33), (0x8b, 0x67, 0x2f),
	(0x63, 0x4b, 0x23), (0x4f, 0x3b, 0x1b),
	(0x33, 0x27, 0x13), (0x1f, 0x17, 0x0f),
	(0xff, 0xff, 0xa7), (0xff, 0xff, 0xd3),
	(0xff, 0xff, 0xff), (0xff, 0xff, 0xff),
	(0xff, 0xff, 0xff), (0xff, 0xff, 0xff),
	(0xff, 0xff, 0xff), (0xff, 0xff, 0xff),
	(0xff, 0xff, 0xff), (0xff, 0xff, 0xff),
	(0xcb, 0xd7, 0xdf), (0x9f, 0xb7, 0xc3),
	(0x77, 0x7b, 0xcf), (0x5b, 0x87, 0x9b),
	(0x47, 0x77, 0x8b), (0x2f, 0x67, 0x7f),
	(0x2f, 0x67, 0x7f), (0x17, 0x53, 0x6f),
	(0x13, 0x4b, 0x67), (0x0b, 0x3f, 0x53),
	(0x07, 0x2f, 0x3f), (0x00, 0x1f, 0x2b),
	(0x00, 0x0f, 0x13), (0x00, 0x00, 0x00),
	(0xeb, 0xd3, 0xc7), (0xeb, 0x97, 0x7f),
	(0xeb, 0x97, 0x7f), (0xeb, 0x97, 0x7f),
	(0xbf, 0x7b, 0x6f), (0xc3, 0x73, 0x53),
	(0xb3, 0x5b, 0x4f), (0xb3, 0x5b, 0x4f),
	(0x9f, 0x4b, 0x3f), (0x7b, 0x47, 0x47),
	(0x63, 0x33, 0x33), (0x57, 0x2b, 0x2b),
	(0x3f, 0x1f, 0x1f), (0x27, 0x1b, 0x13),
	(0x17, 0x0f, 0x0b), (0x00, 0x00, 0x00),
	(0xff, 0xff, 0xff), (0xff, 0xff, 0xd3),
	(0xff, 0xff, 0xd3), (0xff, 0xff, 0xd3),
	(0xff, 0xff, 0xd3), (0xeb, 0xd3, 0xc7),
	(0xd7, 0xbb, 0xb7), (0xc7, 0xab, 0x9b),
	(0xc7, 0xab, 0x9b), (0x97, 0x9f, 0x7b),
	(0x87, 0x8b, 0x6b), (0x73, 0x73, 0x57),
	(0x5b, 0x5b, 0x43), (0x43, 0x43, 0x33),
	(0x2f, 0x2f, 0x23), (0x1b, 0x1b, 0x17),
	(0xeb, 0x97, 0x7f), (0xeb, 0x97, 0x7f),
	(0xeb, 0x97, 0x7f), (0xc3, 0x73, 0x53),
	(0xc3, 0x73, 0x53), (0xb3, 0x5b, 0x4f),
	(0xa7, 0x3b, 0x2b), (0xa7, 0x3b, 0x2b),
	(0x9f, 0x2f, 0x23), (0x8b, 0x27, 0x13),
	(0x6b, 0x2b, 0x1b), (0x57, 0x1f, 0x13),
	(0x43, 0x17, 0x0b), (0x2b, 0x0b, 0x00),
	(0x1b, 0x00, 0x00), (0x00, 0x00, 0x00),
	(0xff, 0xff, 0xff), (0xff, 0xff, 0xff),
	(0xff, 0xff, 0xff), (0xeb, 0xeb, 0xeb),
	(0xcb, 0xd7, 0xdf), (0xb3, 0xc7, 0xd3),
	(0x9f, 0xb7, 0xc3), (0x77, 0x7b, 0xcf),
	(0x77, 0x7b, 0xcf), (0x67, 0x6b, 0xb7),
	(0x5b, 0x5b, 0x9b), (0x4b, 0x4f, 0x7f),
	(0x3f, 0x3f, 0x67), (0x2f, 0x2f, 0x4b),
	(0x23, 0x1f, 0x2f), (0x17, 0x0f, 0x0b),
	(0xff, 0xff, 0xff), (0xff, 0xff, 0xd3),
	(0xff, 0xff, 0xd3), (0xff, 0xff, 0xa7),
	(0xff, 0xff, 0xa7), (0xff, 0xff, 0x7f),
	(0x9b, 0xab, 0x7b), (0x9b, 0xab, 0x7b),
	(0x87, 0x97, 0x63), (0x5f, 0xa7, 0x2f),
	(0x5f, 0x8f, 0x33), (0x5f, 0x7b, 0x33),
	(0x3f, 0x4f, 0x1b), (0x2f, 0x3b, 0x0b),
	(0x23, 0x2f, 0x07), (0x1b, 0x23, 0x00),
	(0x00, 0xff, 0x00), (0x00, 0xff, 0x00),
	(0xff, 0xff, 0x27), (0xff, 0xff, 0x53),
	(0xff, 0xff, 0x53), (0xff, 0xff, 0x53),
	(0xff, 0xff, 0x53), (0xff, 0xff, 0xff),
	(0xff, 0xff, 0xff), (0xff, 0xff, 0xff),
	(0xff, 0xff, 0xff), (0xff, 0xff, 0xa7),
	(0xff, 0xff, 0x53), (0xff, 0xff, 0x53),
	(0xff, 0xff, 0x27), (0xff, 0xff, 0x27),
	(0xff, 0xff, 0x27), (0xff, 0xff, 0x27),
	(0xff, 0xeb, 0x1f), (0xff, 0xd7, 0x17),
	(0xff, 0xab, 0x07), (0xff, 0x93, 0x00),
	(0xff, 0x93, 0x00), (0xff, 0x93, 0x00),
	(0xff, 0x00, 0x00), (0xff, 0x00, 0x00),
	(0xff, 0x00, 0x00), (0xef, 0x00, 0x00),
	(0x9b, 0x1f, 0x00), (0x7f, 0x0f, 0x00),
	(0x5f, 0x00, 0x00), (0x2f, 0x00, 0x00),
	(0xff, 0x00, 0x00), (0x37, 0x37, 0xff),
	(0xff, 0x00, 0x00), (0x00, 0x00, 0xff),
	(0x5b, 0x5b, 0x43), (0x37, 0x37, 0x2b),
	(0x23, 0x23, 0x1b), (0xff, 0xff, 0xff),
	(0xff, 0xff, 0xa7), (0xeb, 0x97, 0x7f),
	(0xeb, 0x9f, 0x27), (0xff, 0xff, 0xff),
	(0xff, 0xff, 0xff), (0xff, 0xff, 0xff),
	(0xeb, 0xd3, 0xc7), (0x9f, 0x5b, 0x53),
)

type WAL <: Images.ImageFileType end

# FIXME: https://github.com/timholy/Images.jl/issues/10
# add_image_file_format(".wal", b"", WAL)

import Images.imread
function imread{S<:IO}(io::S, ::Type{WAL})
	# name of texture
	seek(io, 0)
	name = lowercase(rstrip(bytestring(read(io, Uint8, 32)),'\0'))

	# size
	width = read(io, Uint32)
	height = read(io, Uint32)

	# mipmap byte offsets
	offset = read(io, Int32, 4)

	# name of next texture (if animated)
	next_name = lowercase(rstrip(bytestring(read(io, Uint8, 32)),'\0'))

	flags = read(io, Uint32)
	contents = read(io, Uint32)
	value = read(io, Uint32)

	# decode image data
	seek(io, offset[1])
	pixels = Array(Uint8, 3, width, height)
	i = 1
	while i < length(pixels)
		c = read(io, Uint8)+1
		pixels[i]   = WalPalette[c][1]
		pixels[i+1] = WalPalette[c][2]
		pixels[i+2] = WalPalette[c][3]
		i += 3
	end

	prop = Dict("colorspace" => "RGB")
	Image(pixels, prop)
end

end
