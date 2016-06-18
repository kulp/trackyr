#!/usr/bin/luajit
local img = require 'img'
local hull = require 'hull'
local pgm = require 'pgm'
local SDL = require 'SDL'

local bit32 = require 'bit'

local screen_w = 80
local screen_h = 60

local ret, err = SDL.init { SDL.flags.Video }
if not ret then
    error(err)
end

local win, err = SDL.createWindow {
    title   = "tracker",
    width   = 800,
    height  = 600,
    flags   = { SDL.window.Desktop }
}
if not win then
    error(err)
end

local rdr, err = SDL.createRenderer(win, 0, 0)
if not rdr then
    error(err)
end

rdr:setLogicalSize(screen_w,screen_h)

local qq = pgm.read(arg[1])
local rr = img.from_pgm(qq)
img.display(rr,screen_w,screen_h)
local ss = img.threshold(img.contrast(rr,true),256/16)
img.display(ss,screen_w,screen_h)
rs = img.to_points(ss)
xp = hull.graham_scan(rs)
local copy = hull.copy_with_hull(rr,xp,false)
img.display(copy,screen_w,screen_h)

local box = hull.box_around(xp)
copy = hull.copy_with_hull(rr,box,false)
img.display(copy,screen_w,screen_h)

function grey(v)

    v = v or 0
    local w = bit32.band(v,255)
    return bit32.lshift(w,16) + bit32.lshift(w,8) + w

end

rdr:setDrawColor(0xFFFFFF)
rdr:clear()
img.image_each(rr,function(v,x,y)
        rdr:setDrawColor(grey(v))
        rdr:drawPoint({x=x-1,y=y-1})
    end)
rdr:present()

SDL.delay(50000)
