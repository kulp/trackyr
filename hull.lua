function ccw(p1, p2, p3)
    return (p2.x - p1.x) * (p3.y - p1.y) -
           (p2.y - p1.y) * (p3.x - p1.x)
end

function slope(a,b)
    return (b.x - a.x) / (b.y - a.y);
end

function graham_scan(ps)

    local points = ps
    local min_y = { x=0, y=1000000 }
    for k,v in ipairs(points) do
        if v.y < min_y.y or (v.y == min_y.y and v.x < min_y.x) then
            min_y = v
            min_y.i = k
        end
    end

    function by_slope(a,b)
        return slope(min_y, a) > slope(min_y, b)
    end

    table.remove(points, min_y.i)
    table.sort(points, by_slope)
    table.insert(points, 1, min_y)

    points[0] = points[#points]

    local M = 1
    for i = 2,#points do
        while ccw(points[M-1], points[M], points[i]) <= 0 do
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

    return points, M

end
