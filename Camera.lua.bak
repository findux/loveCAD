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

return Camera
