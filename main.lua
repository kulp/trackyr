#!/usr/bin/luajit
local ffi = require 'ffi'
local C = ffi.C

require 'img'

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
t = threshold(c,3)
display(t)
