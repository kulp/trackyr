#!/usr/bin/luajit
local ffi = require 'ffi'
local C = ffi.C

img = { }

x = 20
y = 15

function dist(x1,y1,x2,y2)

    local xd = (x1 - x2)
    local yd = (y1 - y2)
    return math.sqrt(xd * xd + yd * yd)

end

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

function display(img)

    for i = 1,40 do
        for j = 1,30 do
            if img[i] ~= nil and img[i][j] ~= nil then
                io.write(img[i][j])
            else
                io.write('.')
            end
        end
        io.write('\n')
    end

end

function contrast(img,w,h)

    local out = { }
    for x = 2,w-1 do
        out[x] = { }
        for y = 2,h-1 do
            out[x][y] = 0
            for i = -1,1 do
                for j = -1,1 do
                    out[x][y] = out[x][y] + math.abs(img[x+i][y+j] - img[x][y])
                end
            end
        end
    end
    return out

end

display(img)
display(contrast(img,40,30))
