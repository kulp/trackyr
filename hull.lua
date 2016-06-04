local LARGE_VALUE = 1000000

local img = require 'img'

local lib = { }

function lib.ccw(p1, p2, p3)
    return (p2.x - p1.x) * (p3.y - p1.y) -
           (p2.y - p1.y) * (p3.x - p1.x)
end

function lib.slope(a,b)
    return (b.x - a.x) / (b.y - a.y);
end

function lib.graham_scan(ps)

    local points = ps
    local min_y = { x=0, y=LARGE_VALUE }
    for k,v in ipairs(points) do
        if v.y < min_y.y or (v.y == min_y.y and v.x < min_y.x) then
            min_y = v
            min_y.i = k
        end
    end

    function by_slope(a,b)
        return lib.slope(min_y, a) > lib.slope(min_y, b)
    end

    table.remove(points, min_y.i)
    table.sort(points, by_slope)
    table.insert(points, 1, min_y)

    points[0] = points[#points]

    local M = 1
    for i = 2,#points do
        while lib.ccw(points[M-1], points[M], points[i]) <= 0 do
            if M > 1 then
                M = M - 1
            elseif i == N then
                break
            else
                i = i + 1
            end
        end
        M = M + 1
        points[M], points[i] = points[i], points[M]
    end

    while #points > M do
        table.remove(points)
    end
    points[0] = nil -- remove temporary index 0
    return points

end

function lib.all_true(arr,func)

    for _,v in ipairs(arr) do
        if not func(v) then
            return false
        end
    end
    return true

end

function lib.inside_ccw_hull(pt,hull,strict)

    local angles = { }
    for k,v in ipairs(hull) do
        local m = (k % #hull) + 1;
        local w = hull[m]

        local px = v.x - pt.x
        local py = v.y - pt.y

        local qx = w.x - pt.x
        local qy = w.y - pt.y

        angles[k] = qx * py - px * qy;
    end

    function lt(x)  return x <  0 end
    function gt(x)  return x >  0 end
    function lte(x) return x <= 0 end
    function gte(x) return x >= 0 end

    return lib.all_true(angles, strict and lt or lte) or
           lib.all_true(angles, strict and gt or gte)

end

function lib.copy_with_hull(im,hull,strict)

    local copy = { }
    img.image_each(im,
        function (v,x,y)
            copy[x] = copy[x] or { }
            if lib.inside_ccw_hull({x=x,y=y}, hull, strict) then
                copy[x][y] = v
            end
        end)

    return copy

end

function lib.box_around(hull)

    local min_x = LARGE_VALUE
    local min_y = LARGE_VALUE
    local max_x = -1
    local max_y = -1

    for _,v in ipairs(hull) do
        if v.x < min_x then min_x = v.x end
        if v.x > max_x then max_x = v.x end
        if v.y < min_y then min_y = v.y end
        if v.y > max_y then max_y = v.y end
    end

    return { { x=min_x, y=min_y },
             { x=min_x, y=max_y },
             { x=max_x, y=max_y },
             { x=max_x, y=min_y } }

end

return lib
