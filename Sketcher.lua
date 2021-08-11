Sketch = {}

local mgl = require("MGL")
local Line = require("Line")

function Sketch:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Sketch:newLine()
    local l = Line:new()
    l.mode = ""
    l.color = mgl.vec4(1, 1, 1, 1)
    l.points = {}
    if self.geometries then
        table.insert(self.geometries, l)
    else
        self.geometries = {}
        table.insert(self.geometries, l)
    end
    return l
end

function Sketch:mousepressed(x, y, button, istouch) end

function Sketch:mousereleased(x, y, button, istouch) end

function Sketch:mousemoved(x, y, dx, dy, istouch) end

function Sketch:draw()
    if self.geometries then
        for i, g in pairs(self.geometries) do g:draw() end
    end
end

return Sketch
