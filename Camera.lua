Camera = {}

local mgl = require("MGL")

function Camera:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.transform = love.math.newTransform()
    self.mode = ""
    self.winPos = mgl.vec2(1)
    return o
end

function Camera:mousepressed(x, y, button, istouch)
    if button == 2 then self.mode = "pan" end
    if button == 1 then

        local m = self:getMatrix()
        local camWPos = mgl.inverse(m) *
                            mgl.vec4(self.winPos[1],love.graphics.getHeight()- self.winPos[2], 0.0, 1.0)
    end
end

function Camera:mousereleased(x, y, button, istouch, presses)
    if button == 2 then self.mode = "" end
end

function Camera:screenToWorld(v)
    local lv 
    if v then
        lv = mgl.vec4(v[1], v[2], 0.0, 1.0)
    else
        lv = mgl.vec4(self.winPos[1], love.graphics.getHeight()- self.winPos[2], 0.0, 1.0)
    end
    local m = self:getMatrix()
    local camWPos = mgl.inverse(m) * lv 
    return camWPos
end

function Camera:worldToScreen(v)
    local m = self:getMatrix()
    local camWPos = m * mgl.vec4(v[1], v[2], 0.0, 1.0)
    return camWPos
end

function Camera:wheelmoved(x, y)
    local sc = 1 + 1 / (y * -10)
    local m = self:getMatrix()
    --screen to world
    local wpos = self:screenToWorld()
    self.transform:scale(sc, sc)
    local wpos2 = self:worldToScreen(wpos)
    wpos2 = wpos2 - mgl.vec4(self.winPos[1], love.graphics.getHeight()- self.winPos[2], 0.0, 1.0)
    self:translate(-wpos2[1],- wpos2[2])
end

function Camera:mousemoved(x, y, dx, dy, istouch)
    self.winPos[1] = x
    self.winPos[2] = y

    if self.mode == "pan" then self:translate(dx, -dy) end
end

function Camera:translate(dx, dy)
    local e1 = self.transform:getMatrix()
    self.transform:translate(dx / e1, dy / e1)
end

function Camera:getLoveMatrix()
    local r1, r2, r3, r4, rr1, rr2, rr3, rr4, rrr1, rrr2, rrr3, rrr4, rrrr1,
          rrrr2, rrrr3, rrrr4 = self.transform:getMatrix()
    return {
        r1, r2, r3, r4, rr1, rr2, rr3, rr4, rrr1, rrr2, rrr3, rrr4, rrrr1,
        rrrr2, rrrr3, rrrr4
    }
end

function Camera:getMatrix()
    local m = mgl.mat4(1)
    for i, v in pairs(self:getLoveMatrix()) do m[i] = v end
    return m
end

function Camera:setMatrix(m)
    self.transform:setMatrix(m[1],m[2],m[3],m[4],
    m[5],m[6],m[7],m[8],
    m[9],m[10],m[11],m[12],
    m[13],m[14],m[15],m[16])
end

function Camera:fit(sw,sh,min,max)
    local sr = sw/sh
    local d = max-min
    local fr = d[1]/d[2]
    local scale = 1
    if fr >= sr then
        scale = d[1] / sw
    else
        scale = d[2] / sh
    end
    local mid = (max + min) / 2
    print(scale)
    local m = mgl.mat4(1)
    m[1] = m[1] / scale
    m[6] = m[6] / scale
    local locWH = mgl.inverse(m) * mgl.vec4(sw,sh,0,1)
    locWH = mgl.vec2(locWH[1],locWH[2])
    local locWHmid = locWH/2
    local dddd = locWHmid - mid
    dddd = m * mgl.vec4(dddd[1],dddd[2],0,1)
    m[4] = dddd[1]
    m[8] = dddd[2]
    self:setMatrix(m)
end

return Camera
