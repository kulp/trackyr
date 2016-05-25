#!/usr/bin/luajit
local ffi = require 'ffi'
local C = ffi.C

require 'img'
require 'hull'
local pgm = require 'pgm'

img = { }

x = 20
y = 15

for i = 1,40 do
    img[i] = { }
    for j = 1,30 do
        if dist(i,j,x,y) < 7 then
            img[i][j] = 1
        else
            img[i][j] = 0
        end
    end
end

display(img)
c = contrast(img)
display(c)
t = threshold(c,4)

x = to_points(t)
xx = graham_scan(x)
im = from_points(xx)
display(im)

local copy = { }
image_each(c,
    function (v,x,y)
        copy[x] = copy[x] or { }
        if inside_ccw_hull({x=x,y=y}, xx) then
            copy[x][y] = v
        end
    end)

display(copy)

local qq = pgm.read("oval000.pgm")
qq.data[15] = 255
pgm.write("oval111.pgm", qq)
local rr = from_pgm(qq)
display(rr)

