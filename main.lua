#!/usr/bin/luajit
local img = require 'img'
local hull = require 'hull'
local pgm = require 'pgm'

w = 80
h = 60

local qq = pgm.read(arg[1])
local rr = img.from_pgm(qq)
img.display(rr,w,h)
local ss = img.threshold(img.contrast(rr,true),256/8)
img.display(ss,w,h)
rs = img.to_points(ss)
xp = hull.graham_scan(rs)
local copy = hull.copy_with_hull(rr,xp,false)
img.display(copy,w,h)

local box = hull.box_around(xp)
copy = hull.copy_with_hull(rr,box,false)
img.display(copy,w,h)

