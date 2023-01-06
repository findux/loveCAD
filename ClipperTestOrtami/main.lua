if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

local clipper = require "clipper"
path = clipper.Path(3) -- initialise vector of size 3
path[0] = clipper.IntPoint(2, 3) -- specify first IntPoint in vector


function love.draw()
    love.graphics.print('Hello World!', 400, 300)
end