DXF = {}

DXF.file = ""
DXF.entities = {}

function DXF:load(mfile)
    self.file = file
    local file = io.open(mfile, "r")
    local lines = {}
    for l in io.lines(mfile) do
        table.insert(lines,l)
    end
    file:close()
    self:readEntities(lines)

end

function DXF:readEntities(lines)
    local kostur = true
    local i = 1
    while kostur do
        local key = lines[i]
        local value = lines[i+1]
        if (tonumber(key) == 0) and (value == "SECTION") then
            i = i +2
            key = lines[i]
            value = lines[i+1]
            if (tonumber(key) == 2) and (value == "ENTITIES") then
                while not((tonumber(key) == 0) and (value == "ENDSEC")) do
                    i = i +2
                    key = lines[i]
                    value = lines[i+1]

                    if (tonumber(key) == 0)  and not (value == "ENDSEC") then
                        table.insert(self.entities,{ dxfEntityType = value })
                        self.entities[#self.entities].layout = 0
                    end
                    
                    if (tonumber(key) == 1) then
                        if self.entities[#self.entities].dxfEntityType == "TEXT" then
                            self.entities[#self.entities].text = value --Text rotation (optional; default = 0)
                        end
                    end

                    if (tonumber(key) == 7) then
                        if self.entities[#self.entities].dxfEntityType == "TEXT" then
                            self.entities[#self.entities].textStyle = tonumber(value) --Text style name (optional, default = STANDARD)
                        end
                    end

                    if (tonumber(key) == 8) then
                        self.entities[#self.entities].layer = value
                    end

                    if (tonumber(key) == 90) then
                        self.entities[#self.entities].vertexCount = tonumber(value)
                    end

                    if (tonumber(key) == 70) then
                        self.entities[#self.entities].closed = tonumber(value) 
                    end

                    if (tonumber(key) == 43) then
                        self.entities[#self.entities].width = tonumber(value) 
                    end

                    if (tonumber(key) == 38) then
                        self.entities[#self.entities].elevation = tonumber(value) 
                    end

                    if (tonumber(key) == 39) then
                        self.entities[#self.entities].thickness = tonumber(value) 
                    end

                    if (tonumber(key) == 40) then
                        if self.entities[#self.entities].dxfEntityType == "ARC" or  
                             self.entities[#self.entities].dxfEntityType == "CIRCLE" then  
                            self.entities[#self.entities].radius = tonumber(value) 
                             elseif self.entities[#self.entities].dxfEntityType == "ELLIPSE" then
                                self.entities[#self.entities].ratioMinToMaj = tonumber(value)   --Ratio of minor axis to major axis
                            elseif self.entities[#self.entities].dxfEntityType == "TEXT" then
                                self.entities[#self.entities].textHeight = tonumber(value) --Text height
                        end
                    end

                    if (tonumber(key) == 41) then
                        if self.entities[#self.entities].dxfEntityType == "ELLIPSE" then
                            self.entities[#self.entities].startPar = tonumber(value)   --Ratio of minor axis to major axis
                        elseif self.entities[#self.entities].dxfEntityType == "TEXT" then
                            self.entities[#self.entities].scale = tonumber(value) --Relative X scale factor—width (optional; default = 1)   This value is also adjusted when fit-type text is used
                        end
                    end

                    if (tonumber(key) == 42) then
                        if self.entities[#self.entities].dxfEntityType == "ELLIPSE" then
                            self.entities[#self.entities].endPar = tonumber(value)   --Ratio of minor axis to major axis
                        end
                    end

                    if (tonumber(key) == 50) then
                        if self.entities[#self.entities].dxfEntityType == "ARC" then
                            self.entities[#self.entities].startAngle = tonumber(value) 
                        elseif self.entities[#self.entities].dxfEntityType == "TEXT" then
                            self.entities[#self.entities].textRotation = tonumber(value) --Text rotation (optional; default = 0)
                        end
                    end

                    if (tonumber(key) == 51) then
                        if self.entities[#self.entities].dxfEntityType == "ARC" then
                            self.entities[#self.entities].endAngle = tonumber(value) 
                        end
                    end

                    if (tonumber(key) == 67) then                       
                        self.entities[#self.entities].layout = tonumber(value) 
                    end

                    if (tonumber(key) == 10) then
                        if self.entities[#self.entities].dxfEntityType == "LWPOLYLINE" then
                            local x = tonumber(value)
                            i = i +2
                            key = lines[i]
                            value = lines[i+1]
                            local y = tonumber(value)
                            i = i +2
                            key = lines[i]
                            value = lines[i+1]
                            local b = 0
                            if tonumber(key) == 42 then
                                b = tonumber(value)
                            else
                                i = i -2
                            end
                            if self.entities[#self.entities].vertexies == nil then
                                self.entities[#self.entities].vertexies = {}
                            end
                            table.insert(self.entities[#self.entities].vertexies, { x, y, b})
                        else
                            local x = tonumber(value)
                            i = i +2
                            key = lines[i]
                            value = lines[i+1]
                            local y = tonumber(value)
                            i = i +2
                            key = lines[i]
                            value = lines[i+1]
                            local z = tonumber(value)
                            if self.entities[#self.entities].vertexies == nil then
                                self.entities[#self.entities].vertexies = {}
                            end
                            table.insert(self.entities[#self.entities].vertexies, { x, y, z})
                        end
                    end

                    if (tonumber(key) == 11) then
                        if self.entities[#self.entities].dxfEntityType == "LINE" then
                            local x = tonumber(value)
                            i = i +2
                            key = lines[i]
                            value = lines[i+1]
                            local y = tonumber(value)
                            i = i +2
                            key = lines[i]
                            value = lines[i+1]
                            local z = tonumber(value)
                            if self.entities[#self.entities].vertexies == nil then
                                self.entities[#self.entities].vertexies = {}
                            end
                            table.insert(self.entities[#self.entities].vertexies, { x, y, z})
                        end
                    end

                    if (tonumber(key) == 210) then
                        local x = tonumber(value)
                        i = i +2
                        key = lines[i]
                        value = lines[i+1]
                        local y = tonumber(value)
                        i = i +2
                        key = lines[i]
                        value = lines[i+1]
                        local z = tonumber(value)
                        self.entities[#self.entities].extrusionDir = { x, y, z}
                    end

                end
                kostur = false
            end
        end

        i = i +2
        if i > # lines then
            kostur = false
        end
    end
end

-- if layerName not defined , returns all entities
function DXF:getModelSpaceEntities(layerName)
    local entities = {}
    for i,v in ipairs(self.entities) do
        if layerName then
            if v.layout and v.layout == 0 and (v.layer == layerName) then
                table.insert(entities,v)
            end
        else
            if v.layout and v.layout == 0 then
                table.insert(entities,v)
            end
        end
    end
    return entities
end




return DXF