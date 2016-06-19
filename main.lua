#!/usr/bin/luajit
local img = require 'img'
local hull = require 'hull'
local pgm = require 'pgm'
local SDL = require 'SDL'
local bit32 = require 'bit'
local ffi = require "ffi"

ffi.cdef[[
int set_up_spi(const char *device, unsigned int bits, unsigned int speed);
typedef unsigned int lepton_image[60][80];
int get_image(int fd, int hz, int bits, lepton_image img);
]]

local lepton = ffi.load("./liblepton.so")

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

SDL.setRelativeMouseMode(true)

function grey(v,bgnd)

    v = v == nil and bgnd or v
    local w = bit32.band(v,255)
    return bit32.lshift(w,16) + bit32.lshift(w,8) + w

end

function render_image(im,bgnd)
    img.image_each(im,function(v,x,y)
            rdr:setDrawColor(grey(v,bgnd))
            rdr:drawPoint({x=x-1,y=y-1})
        end)
end

function outline(rdr,box)

    local a = box[1]
    local b = box[3]
    local w = b.x - a.x
    local h = b.y - a.y

    rdr:setDrawColor({r=255,g=0,g=0})
    rdr:drawRect({x=a.x, y=a.y, w=w, h=h})

end

local image = ffi.new("lepton_image")
local hz = 16000000
local bits = 8
local fd = lepton.set_up_spi("/dev/spidev0.1", hz, bits)
local bgnd = 0x000001 -- if it's all zeros, we get no drawing ? or white ?
rdr:clear()
rdr:setDrawColor(bgnd)
rdr:fillRect({x=0,y=0,w=screen_w,h=screen_h})

while true do
    lepton.get_image(fd, hz, bits, image)

    local dd = ffi.cast("unsigned int*",image)
    local cc = img.from_array(dd, screen_w, screen_h)

    local rr = img.normalize(cc,256)

    local ss = img.threshold(img.contrast(rr,true),256/8)
    rs = img.to_points(ss)
    xp = hull.graham_scan(rs)
    local copy = hull.copy_with_hull(rr,xp,false)

    local box = hull.box_around(xp)
    copy = hull.copy_with_hull(rr,box,false)

    render_image(rr,bgnd)
    outline(rdr,box)
    rdr:present()
    SDL.delay(100)
end

