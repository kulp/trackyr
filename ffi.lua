--local ffi = require "ffi"
--local C = ffi.C

ffi.cdef[[
int puts(const char *);
int do_a_thing(const char *);
]]

ffi.C.puts("hi")
ffi.C.do_a_thing("there")
