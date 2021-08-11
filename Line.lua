Line = {}
local mgl = require("MGL")

function Line:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Line:draw()
    if self.points then
        love.graphics.setLineStyle("smooth") -- smooth and rough.
        love.graphics.setLineWidth(0.1)
        love.graphics.setColor(self.color)
        love.graphics.line(self.points[1][1], self.points[1][2],
                           self.points[2][1], self.points[2][2])
        love.graphics.setColor(0, 1, 0, 1)
        love.graphics.circle("fill", self.points[1][1], self.points[1][2], 1)
        love.graphics.circle("fill", self.points[2][1], self.points[2][2], 1)
    end
end

return Line
