#!/usr/bin/luajit
local ffi = require "ffi"
local C = ffi.C

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
]]

local pgm = ffi.load("./libpgm.so")
local val = ffi.new("struct pgm_image*[1]");
print("val = " .. tostring(val))
local x = pgm.pgm_read(io.open("oval000.pgm"), val)
val = ffi.gc(val, pgm.pgm_free);
print("x = " .. x)
print("val = " .. tostring(val))
print("val[1] = " .. tostring(val[0]))
local x = pgm.pgm_write(io.open("oval000.pgm.out", "w"), val[0])
