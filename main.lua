if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

local util = require("utility")
local dxf = require("dxf")

dxf:load("M:/Source Personel/loveCAD/H50_06.dxf")

entities = dxf:getModelSpaceEntities()
local lep1 =  dxf.convertLWPOLYLINEVertexiesToTable(entities[1])

--local clipper = require "clipper"
--path = clipper.Path(3) -- initialise vector of size 3
--path[0] = clipper.IntPoint(2, 3) -- specify first IntPoint in vector
function adeSplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	i = 1
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end
function beginDXFHeader()
	local out = ""
	out = out .. "999"
	out = out .. "\nDXF created from AdekoCAM DXF Export PostProcessor"
	out = out .. "\n0"
	out = out .. "\nSECTION"
	out = out .. "\n2"
	out = out .. "\nHEADER"
	out = out .. "\n9"
	out = out .. "\n$ACADVER"
	out = out .. "\n1"
	out = out .. "\nAC1006"
	out = out .. "\n9"
	out = out .. "\n$INSBASE"
	out = out .. "\n10"
	out = out .. "\n0.0"
	out = out .. "\n20"
	out = out .. "\n0.0"
	out = out .. "\n30"
	out = out .. "\n0.0"
	out = out .. "\n9"
	out = out .. "\n$EXTMIN"
	out = out .. "\n10"
	out = out .. "\n0.0"
	out = out .. "\n20"
	out = out .. "\n0.0"
	out = out .. "\n9"
	out = out .. "\n$EXTMAX"
	out = out .. "\n10"
	out = out .. "\n1000.0"
	out = out .. "\n20"
	out = out .. "\n1000.0"
	out = out .. "\n0"
	out = out .. "\nENDSEC"
	out = out .. "\n0"
	out = out .. "\nTABLE"
	out = out .. "\n2"
	out = out .. "\nLAYER"
	out = out .. "\n70"
	out = out .. "\n6"
	out = out .. "\n0"
	out = out .. "\nLAYER"
	out = out .. "\n2"
	out = out .. "\n1"
	out = out .. "\n70"
	out = out .. "\n64"
	out = out .. "\n62"
	out = out .. "\n7"
	out = out .. "\n6"
	out = out .. "\nCONTINUOUS"
	out = out .. "\n0"
	out = out .. "\nLAYER"
	out = out .. "\n2"
	out = out .. "\n2"
	out = out .. "\n70"
	out = out .. "\n64"
	out = out .. "\n62"
	out = out .. "\n7"
	out = out .. "\n6"
	out = out .. "\nCONTINUOUS"
	out = out .. "\n0"
	out = out .. "\nENDTAB"
	out = out .. "\n0"
	out = out .. "\nTABLE"
	out = out .. "\n2"
	out = out .. "\nSTYLE"
	out = out .. "\n70"
	out = out .. "\n0"
	out = out .. "\n0"
	out = out .. "\nENDTAB"
	out = out .. "\n0"
	out = out .. "\nENDSEC"
	out = out .. "\n0"
	out = out .. "\nSECTION"
	out = out .. "\n2"
	out = out .. "\nBLOCKS"
	out = out .. "\n0"
	out = out .. "\nENDSEC"
	out = out .. "\n0"
	out = out .. "\nSECTION"
	out = out .. "\n2"
	out = out .. "\nENTITIES"
	return out
end
function endDXFFooter()
	local out = ""
	out = out .. "\n0"
	out = out .. "\nENDSEC"
	out = out .. "\n0"
	out = out .. "\nEOF"
	return out
end
function gibenSizingMachineFDTFile()
    local fdtFile = io.open([[M:/Source/SIZING MACHINE GIBEN/abies beyaz.fdt]],"r")
    local content = fdtFile:read("*a")
    fdtFile:close()
    local lines = adeSplit(content, "\n")
    local newLines = ""
    local tabs = 0
    for i,r in ipairs(lines) do
        if r:find("End") then tabs = tabs - 1 end
        local newRow = ""
        for i = tabs,1,-1 do 
            newRow = newRow .. "    " 
        end
        newRow = newRow .. r
        newLines = newLines .. "\n" .. newRow
        if r:find("Start") then tabs = tabs + 1 end
    end
    local outFile = io.open([[M:/Source/SIZING MACHINE GIBEN/abies beyaz_generated.fdt]],"w")
    outFile:write(newLines)
    outFile:close()


    local panels = {}
    local panel = {}
    local XANGINF , YANGINF , XANGSUP , YANGSUP = 0,0,0,0
    local TIPOTG,TGUTENTE,PADRE,FIGLIO,FRATELLO,PEZZOSTACCATO = 0,0,0,0,0,0
    local SIDP = ""
    for i,row in ipairs(lines) do
        if row:find("XANGINF") then
            local rowItem = adeSplit(row,"=")
            XANGINF = tonumber(rowItem[2])* 0.001
        end
        if row:find("YANGINF") then
            local rowItem = adeSplit(row,"=")
            YANGINF = tonumber(rowItem[2])* 0.001
        end
        if row:find("XANGSUP") then
            local rowItem = adeSplit(row,"=")
            XANGSUP = tonumber(rowItem[2])* 0.001
        end
        if row:find("YANGSUP") then
            local rowItem = adeSplit(row,"=")
            YANGSUP = tonumber(rowItem[2]) * 0.001
        end

        if row:find("TIPOTG") then
            local rowItem = adeSplit(row,"=")
            TIPOTG = tonumber(rowItem[2]) 
        end
        if row:find("TGUTENTE") then
            local rowItem = adeSplit(row,"=")
            TGUTENTE = tonumber(rowItem[2]) 
        end
        if row:find("PADRE") then
            local rowItem = adeSplit(row,"=")
            PADRE = tonumber(rowItem[2]) 
        end
        if row:find("FIGLIO") then
            local rowItem = adeSplit(row,"=")
            FIGLIO = tonumber(rowItem[2]) 
        end
        if row:find("FRATELLO") then
            local rowItem = adeSplit(row,"=")
            FRATELLO = tonumber(rowItem[2]) 
        end
        if row:find("PEZZOSTACCATO") then
            local rowItem = adeSplit(row,"=")
            PEZZOSTACCATO = tonumber(rowItem[2]) 
        end

        
        if row:find("SIDP") then
            local rowItem = adeSplit(row,"=")
            SIDP = rowItem[2]
        end


        if row:find("EndDatiElementoFDS") then
            if panel[1] == nil then panel[1] = {} end
            table.insert(panel[1],{XANGINF , YANGINF , XANGSUP , YANGSUP,SIDP})
        end
        if row:find("EndTaglio") then
            if panel[2] == nil then panel[2] = {} end
            table.insert(panel[2],{XANGINF , YANGINF , XANGSUP , YANGSUP , TIPOTG , TGUTENTE , PADRE , FIGLIO , FRATELLO , PEZZOSTACCATO})
        end
        if row:find("EndPannelloFDS") then
            table.insert(panels,panel)
            panel = {}
        end
    end


    --craete dxf
    local dxf = beginDXFHeader()
    for i,pnl in ipairs(panels) do
        -- dxf header
        local offsetXXX = (i-1) * 4000
        for j,prt in ipairs(pnl[1]) do
            dxf = dxf .. "\n  0";
	        dxf = dxf .. "\nLWPOLYLINE";
	        dxf = dxf .. "\n  8";
	        dxf = dxf .. "\n" .. "PRT";
	        dxf = dxf .. "\n  90";
	        dxf = dxf .. "\n5";
	        dxf = dxf .. "\n  70";
	        dxf = dxf .. "\n0";
	        dxf = dxf .. "\n  43";
	        dxf = dxf .. "\n0.0";
	        dxf = dxf .. "\n  38";
	        dxf = dxf .. string.format("\n%.5f",0.0);
	        dxf = dxf .. "\n  39";
	        dxf = dxf .. string.format("\n%.5f",0.0);
	        dxf = dxf .. "\n  62";
	        dxf = dxf .. "\n0";
	        dxf = dxf .. string.format("\n  10\n%.5f\n  20\n%.5f\n  42\n0.0",offsetXXX + prt[1],prt[2]);
	        dxf = dxf .. string.format("\n  10\n%.5f\n  20\n%.5f\n  42\n0.0",offsetXXX + prt[3],prt[2]);
	        dxf = dxf .. string.format("\n  10\n%.5f\n  20\n%.5f\n  42\n0.0",offsetXXX + prt[3],prt[4]);
	        dxf = dxf .. string.format("\n  10\n%.5f\n  20\n%.5f\n  42\n0.0",offsetXXX + prt[1],prt[4]);
	        dxf = dxf .. string.format("\n  10\n%.5f\n  20\n%.5f\n  42\n0.0",offsetXXX + prt[1],prt[2]);
            dxf = dxf .. "\n0"
		    dxf = dxf .. "\nTEXT"
            dxf = dxf .. "\n  8"
            dxf = dxf .. "\n0"
            dxf = dxf .. "\n 10"
            local textPos = { x = (prt[1] + prt[3]) * 0.5 ,y = (prt[2] + prt[4]) * 0.5  }
		    dxf = dxf .. string.format("\n%f",offsetXXX + textPos.x)
		    dxf = dxf .. "\n 20"
		    dxf = dxf .. string.format("\n%f",textPos.y)
		    dxf = dxf .. "\n 30"
		    dxf = dxf .. "\n0.0"
		    dxf = dxf .. "\n 40"
		    dxf = dxf .. "\n14.0"
		    dxf = dxf .. "\n  1"
		    dxf = dxf .. string.format("\n%d/%s",j,prt[5])
		    local textAngle = "90"
		    if (util.fuzzyCompare(prt[1], prt[3]) == true) then
		    	textAngle = "0"
		    end
		    dxf = dxf .. "\n 50"
		    dxf = dxf .. "\n" .. textAngle
        end
        for j,prt in ipairs(pnl[2]) do
            dxf = dxf .. "\n  0";
	        dxf = dxf .. "\nLWPOLYLINE";
	        dxf = dxf .. "\n  8";
	        dxf = dxf .. "\n" .. "PRT";
	        dxf = dxf .. "\n  90";
	        dxf = dxf .. "\n5";
	        dxf = dxf .. "\n  70";
	        dxf = dxf .. "\n0";
	        dxf = dxf .. "\n  43";
	        dxf = dxf .. "\n0.0";
	        dxf = dxf .. "\n  38";
	        dxf = dxf .. string.format("\n%.5f",0.0);
	        dxf = dxf .. "\n  39";
	        dxf = dxf .. string.format("\n%.5f",0.0);
	        dxf = dxf .. "\n  62";
	        dxf = dxf .. "\n1";
	        dxf = dxf .. string.format("\n  10\n%.5f\n  20\n%.5f\n  42\n0.0",offsetXXX + prt[1],prt[2]);
	        dxf = dxf .. string.format("\n  10\n%.5f\n  20\n%.5f\n  42\n0.0",offsetXXX + prt[3],prt[4]);
            dxf = dxf .. "\n0"
		    dxf = dxf .. "\nTEXT"
            dxf = dxf .. "\n  8"
            dxf = dxf .. "\n0"
            dxf = dxf .. "\n 10"
            local textPos = { x = (prt[1] + prt[3]) * 0.5 ,y = (prt[2] + prt[4]) * 0.5  }
		    dxf = dxf .. string.format("\n%f",offsetXXX + textPos.x)
		    dxf = dxf .. "\n 20"
		    dxf = dxf .. string.format("\n%f",textPos.y)
		    dxf = dxf .. "\n 30"
		    dxf = dxf .. "\n0.0"
		    dxf = dxf .. "\n 40"
		    dxf = dxf .. "\n14.0"
		    dxf = dxf .. "\n  1"
		    dxf = dxf .. string.format("\n%d/%d/%d/%d/%d/%d",prt[5],prt[6],prt[7],prt[8],prt[9],prt[10])
		    local textAngle = "90"
		    if (util.fuzzyCompare(prt[1], prt[3]) == true) then
		    	textAngle = "0"
		    end
		    dxf = dxf .. "\n 50"
		    dxf = dxf .. "\n" .. textAngle

        end
    end
    --dxf footer
    dxf = dxf .. endDXFFooter()
    --dxf save
    local dxfFileName = string.format([[M:/Source/SIZING MACHINE GIBEN/%d.dxf]],#panels)
    local outFile = io.open(dxfFileName,"w")
    outFile:write(dxf)
    outFile:close()


print("durrr")



end

gibenSizingMachineFDTFile()




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
--local nfd = require "nfd"
--local filePath = nfd.open(nil, ".png")
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
