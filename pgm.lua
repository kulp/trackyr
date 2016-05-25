local ffi = require "ffi"

ffi.cdef[[
typedef void FILE;
struct pgm_image {
    char magic[2];
    int width, height;
	int max;
    char data[];
};

int pgm_read(FILE *stream, struct pgm_image **out);
int pgm_write(FILE *stream, struct pgm_image *out);
void pgm_free(struct pgm_image *out);

void *calloc(size_t nelem, size_t size);
]]

local cpgm = ffi.load("./libpgm.so")
local pgm = { }

function pgm.create(w,h)

    local img = ffi.cast("struct pgm_image*", ffi.C.calloc(1, ffi.sizeof("struct pgm_image") + w * h))
    img.magic = 'P5'
    img.width = w
    img.height = h
    img.max = 255

    return img

end

function pgm.read(filename)

    local val = ffi.new("struct pgm_image*[1]");
    local rc = cpgm.pgm_read(io.open(filename), val)
    if rc ~= 0 then
        return nil
    end
    val[0] = ffi.gc(val[0], cpgm.pgm_free);

    return val[0][0]

end

function pgm.write(filename,pgm)

    local rc = cpgm.pgm_write(io.open(filename, "w"), pgm)
    return rc == 0

end

return pgm
