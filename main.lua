#!/usr/bin/luajit
local img = require 'img'
require 'hull'
local pgm = require 'pgm'

w = 40
h = 30

local qq = pgm.read(arg[1])
local rr = img.from_pgm(qq)
img.display(rr,w,h)
rs = img.to_points(rr)
xp = graham_scan(rs)
local copy = copy_with_hull(rr,xp,false)
img.display(copy,w,h)

local box = box_around(xp)
copy = copy_with_hull(rr,box,false)
img.display(copy,w,h)

