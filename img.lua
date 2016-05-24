function dist(x1,y1,x2,y2)

    local xd = (x1 - x2)
    local yd = (y1 - y2)
    return math.sqrt(xd * xd + yd * yd)

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

function contrast(img)

    local out = { }
    local w = #img
    for x = 1,w do
        out[x] = { }
        local h = #img[x]
        for y = 1,h do
            out[x][y] = 0
            for i = -1,1 do
                for j = -1,1 do
                    if x+i > 0 and y+j > 0 and x+i < w and y+j < h then
                        out[x][y] = out[x][y] + math.abs(img[x+i][y+j] - img[x][y])
                    else
                        out[x][y] = 0
                    end
                end
            end
        end
    end
    return out

end

function threshold(img,n)

    local out = { }
    image_each(img, function (v,x,y)
        out[x] = out[x] or { }
        out[x][y] = v < n and 0 or v
    end)

    return out

end

function image_each(img,celldone,rowdone)

    for x = 1, #img do
        for y = 1, #img[x] do
            if celldone then
                celldone(img[x][y],x,y)
            end
        end
        if rowdone then
            rowdone(img[x],x)
        end
    end

end

