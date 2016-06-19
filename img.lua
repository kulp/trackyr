local lib = { }

function lib.display(img,w,h)

    h = h or #img
    w = w or #img[1]
    for y = 1,h do
        for x = 1,w do
            if img[x] ~= nil and img[x][y] ~= nil then
                io.write(string.format("%03d", img[x][y]))
            else
                io.write(' . ')
            end
        end
        io.write('\n')
    end

end

function lib.contrast(img,normalize)

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
            if normalize then
                -- TODO this is not correct at edges of image
                out[x][y] = out[x][y] / 8
            end
        end
    end
    return out

end

function lib.threshold(img,n)

    local out = { }
    lib.image_each(img, function (v,x,y)
        out[x] = out[x] or { }
        out[x][y] = v < n and 0 or v
    end)

    return out

end

function lib.image_each(img,celldone,rowdone)

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

function lib.to_points(img)

    local out = { }
    lib.image_each(img,
            function(v,x,y)
                if v > 0 then
                    table.insert(out, { x=x, y=y, v=v })
                end
            end
        )

    return out

end

function lib.from_points(points)

    local img = { }
    for _,v in ipairs(points) do
        img[v.x] = img[v.x] or { }
        img[v.x][v.y] = v.v
    end

    return img

end

function lib.from_array(arr,w,h)

    local out = { }
    for x = 0,w-1 do
        out[x+1] = { }
        for y = 0,h-1 do
            out[x+1][y+1] = arr[x + y * w]
        end
    end

    return out

end

function lib.from_pgm(pgm)

    return lib.from_array(pgm.data, pgm.width, pgm.height)

end

return lib
