if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

local mgl = require("MGL")
local Camera = require("Camera")
local camera = Camera:new()

local Sketch = require("Sketcher")
sketch = Sketch:new()

package.cpath = package.cpath .. ";?.dll"
local imgui = require "cimgui"
local io = imgui.GetIO()
print(jit.os)
local ffi = require "ffi"
local show = {
    gridShow = ffi.new("bool[1]", true),
    test = ffi.new("bool[1]", true),
    style = ffi.new("bool[1]", false),
    metrics = ffi.new("bool[1]", false)
}

local mouseLoc = mgl.vec2(1)
function love.load()
    love.window.setMode(1200, 900, {resizable = true})
    camera:translate(love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5)
    imgui.Init()
end

function love.mousepressed(x, y, button, istouch)
    imgui.MousePressed(button)
    if not imgui.GetWantCaptureMouse() then
    -- your code here
    end
    camera:mousepressed(x, y, button, istouch)
    sketch:mousepressed(x, love.graphics.getHeight() - y, button, istouch)
end

function love.mousereleased(x, y, button, istouch)
    imgui.MouseReleased(button)
    if not imgui.GetWantCaptureMouse() then
    -- your code here
    end
    camera:mousereleased(x, y, button, istouch)
    sketch:mousereleased(x, love.graphics.getHeight() - y, button, istouch)
end

function love.wheelmoved(x, y)
    imgui.WheelMoved(x, y)
    if not imgui.GetWantCaptureMouse() then
    -- your code here
    end
    camera:wheelmoved(x, y)
end

function love.mousemoved(x, y, dx, dy, istouch)
    imgui.MouseMoved(x, y)
    if not imgui.GetWantCaptureMouse() then
    -- your code here
    end
    camera:mousemoved(x, y, dx, dy, istouch)
    sketch:mousemoved(x, love.graphics.getHeight() - y, dx, -dy, istouch)
end

function love.keypressed(key)
    imgui.KeyPressed(key)
    if not imgui.GetWantCaptureKeyboard() then
    -- your code here
    end
end

function love.keyreleased(key)
    imgui.KeyReleased(key)
    if not imgui.GetWantCaptureKeyboard() then
    -- your code here
    end

    if key == "escape" then
        love.event.quit()
    end

    if key == "l" then
        local line = sketch:newLine()
        local v = camera:screenToWorld()
        if true then
            --TODO grid size. 10
            v[1] = math.floor((v[1] / 10) + 0.5) * 10
            v[2] = math.floor((v[2] / 10) + 0.5) * 10
        end
        table.insert(line.points, v)
        local v = camera:screenToWorld()
        if true then
            --TODO grid size. 10
            v[1] = math.floor((v[1] / 10) + 0.5) * 10
            v[2] = math.floor((v[2] / 10) + 0.5) * 10
        end
        table.insert(line.points, v)
        selectedNode = line.points[2]
    end
    if key == "o" then
        selectedNode = nil
    end
end

function drawAxisSystem()
    local e1 = camera.transform:getMatrix()
    --TODO think beter way to get scale , because this function does not works when camrea rotation changed.
    e1 = math.min(e1, 1)
    love.graphics.setLineStyle("smooth")
    love.graphics.setLineWidth(1)
    love.graphics.setColor(1, 0, 0)
    love.graphics.line(0, 0, 25.0 / e1, 0)
    love.graphics.setColor(0, 1, 0)
    love.graphics.line(0, 0, 0, 25.0 / e1)
end

function drawGrid()
    if show.gridShow[0] == false then
        return
    end
    love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
    love.graphics.setLineStyle("smooth") -- smooth and rough.
    love.graphics.setLineWidth(0.1)
    for i = 0, 200, 10 do
        love.graphics.line(-100, -100 + i, 100, -100 + i)
    end
    for i = 0, 200, 10 do
        love.graphics.line(-100 + i, -100, -100 + i, 100)
    end
end

function love.draw()
    love.graphics.push()
    love.graphics.translate(0, love.graphics.getHeight())
    love.graphics.scale(1, -1)
    love.graphics.setBackgroundColor(0.9, 0.9, 0.9, 0.5)
    love.graphics.applyTransform(camera.transform)
    --Draw grid
    drawGrid()

    sketch:draw()
    --love.graphics.setColor(0,1,0)
    --love.graphics.circle("line",100,100,10)

    love.graphics.setColor(1, 1, 0)
    local v = camera:screenToWorld()
    if true then
        --TODO grid size. 10
        v[1] = math.floor((v[1] / 10) + 0.5) * 10
        v[2] = math.floor((v[2] / 10) + 0.5) * 10
    end
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.circle("line", v[1], v[2], 1)
    --Draw axis system
    drawAxisSystem()
    love.graphics.pop()

    imgui.ShowDemoWindow()

    if imgui.BeginMainMenuBar() then
        if imgui.BeginMenu("File") then
            if imgui.MenuItem_Bool("Quit") then
                love.event.quit()
            end
            imgui.EndMenu()
        end
        if imgui.BeginMenu("View") then
            imgui.MenuItem_BoolPtr("Show/hide grid", nil, show.gridShow)
            if imgui.BeginMenu("Dear ImGui windows") then
                imgui.MenuItem_BoolPtr("Show demo window", nil, show.test)

                if imgui.CollapsingHeader_TreeNodeFlags("Options") then
                    p = ffi.new("bool[1]", love.window.getVSync() == 1)
                    if imgui.Checkbox("Enable vsync", p) then
                        love.window.setVSync(p[0] and 1 or 0)
                    end
                end

                --imgui.MenuItem_BoolPtr("Show style editor", nil, gridShow)
                --imgui.MenuItem_BoolPtr("Show metrics window", nil, gridShow)
                imgui.EndMenu()
            end
            imgui.EndMenu()
        end
        imgui.EndMainMenuBar()
    end

    if show.test[0] then
        if imgui.Begin("Test window", show.test) then
            if (imgui.Button("Line")) then
                print("Line")
            end
            imgui.SameLine()
            if (imgui.Button("Arc")) then
                print("Arc")
            end 
            imgui.SameLine()
            if (imgui.Button("Circle")) then
                print("Circle")
            end
            imgui.End()
        end
    end

    imgui.Render()
    imgui.RenderDrawLists()
end

function love.update(dt)
    if love.keyboard.isDown("n") then
        print("n'ye basıldı...")
    end
    --[[
    if love.keyboard.isDown("l") then
        local line = sketch:newLine()
        local v = camera:screenToWorld()
        if true then
            --TODO grid size. 10
            v[1] = math.floor((v[1] / 10) + 0.5) * 10
            v[2] = math.floor((v[2] / 10) + 0.5) * 10
        end
        table.insert(line.points,v)
        local v = camera:screenToWorld()
        if true then
            --TODO grid size. 10
            v[1] = math.floor((v[1] / 10) + 0.5) * 10
            v[2] = math.floor((v[2] / 10) + 0.5) * 10
        end
        table.insert(line.points,v)
        selectedNode = line.points[2]
    end
    if love.keyboard.isDown("o") then
        selectedNode=nil
    end
    ]]
    if selectedNode then
        local v = camera:screenToWorld()
        if true then
            --TODO grid size. 10
            v[1] = math.floor((v[1] / 10) + 0.5) * 10
            v[2] = math.floor((v[2] / 10) + 0.5) * 10
        end
        selectedNode[1] = v[1]
        selectedNode[2] = v[2]
    end

    --imgui
    imgui.Update(dt)
    imgui.NewFrame()
end

function love.textinput(t)
    imgui.TextInput(t)
    if not imgui.GetWantCaptureKeyboard() then
    -- your code here
    end
end

function love.quit()
    return imgui.Shutdown()
end
