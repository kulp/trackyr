#!/usr/bin/luajit
require 'img'
require 'hull'
local pgm = require 'pgm'

w = 40
h = 30

local qq = pgm.read(arg[1])
local rr = from_pgm(qq)
display(rr,w,h)
rs = to_points(rr)
xp = graham_scan(rs)
local copy = copy_with_hull(rr,xp,false)
display(copy,w,h)

local box = box_around(xp)
copy = copy_with_hull(rr,box,false)
display(copy,w,h)

