
Utility = {}
local mgl = require("MGL")

function Utility.fuzzyCompare(t1,t2)
    local resolution = 0.01
    if math.abs(t2-t1) < resolution then
        return true
    else
        return false
    end
end

function Utility.fuzzyCompareVec2(v1,v2)
    if fuzzyCompare(v1[1],v2[1]) == false then 
        return false 
    end 
    if fuzzyCompare(v1[2],v2[2]) == false then 
        return false 
    end 
    return true
end

function Utility.vectorFix(vec)
	for i, e in ipairs(vec) do
		if math.abs(e) < 0.000000001 then
			vec[i] = 0
		end
	end
	return vec
end

function Utility.rotateVector2d(vec, d)
	local v = mgl.rotate(mgl.vec3(0, 0, 1), d * DEGTORAD)
	local te = v * mgl.vec4(vec[1], vec[2], 0, 1)
	return Utility.vectorFix(mgl.vec2(te[1], te[2]))
	--return mgl.vec2(vec[1] * math.cos(d * DEGTORAD) - vec[2] * math.sin(d * DEGTORAD), vec[1] * math.sin(d * DEGTORAD) + vec[2] * math.cos(d * DEGTORAD))
end

function linelineIntersec(l1,l2,r1,r2)
    local flag , intersection = Utility.linelineIntersection(l1[1],l1[2],l2[1],l2[2],r1[1],r1[2],r2[1],r2[2])
    if flag == true then
        return intersection
    else
        return nil
    end
end

function Utility.linelineIntersection(l1x,l1y,l2x,l2y,r1x,r1y,r2x,r2y)
    local l1 = mgl.vec2(l1x,l1y)
    local l2 = mgl.vec2(l2x,l2y)
    local delta = l2 - l1
    delta = mgl.normalize(delta)
    local M = mgl.mat3(1)
    local deltaPerpentecular = Utility.rotateVector2d(delta, 90)
    M = M * mgl.translate(l1)
    --M[3] = l1[1]
    --M[6] = l1[2]
    M[1] = delta[1]
    M[4] = delta[2]
    M[2] = deltaPerpentecular[1]
    M[5] = deltaPerpentecular[2]
    local Minv = mgl.inverse(M)
    local locl2 = Utility.vectorFix(Minv * mgl.vec3(l2, 1))
    local r1 = mgl.vec2(r1x,r1y)
    local r2 = mgl.vec2(r2x,r2y)
    local locr1 = Utility.vectorFix(Minv * mgl.vec3(r1, 1))
    local locr2 = Utility.vectorFix(Minv * mgl.vec3(r2, 1))
    local signr1 = Utility.fuzzyCompare(0,locr1[2]) and 0 or (locr1[2]/math.abs(locr1[2]))
    local signr2 = Utility.fuzzyCompare(0,locr2[2]) and 0 or (locr2[2]/math.abs(locr2[2]))
    local perpentecularity = Utility.fuzzyCompare(locr1[2],locr2[2])
    local locIntersection = nil
    if signr1 == 0 then
        locIntersection = mgl.vec2(locr1[1],0)
    elseif signr2 == 0 then
        locIntersection = mgl.vec2(locr2[1],0)
    elseif perpentecularity == true then
        locIntersection = mgl.vec2(locr2[1],0)
    elseif signr1 ~= signr2 then
        local a = (locr2[2] * (locr2[1] - locr1[1])) / (locr2[2] - locr1[2]) -- sıfıra bölüm perpentucalrity den kurtuluyor
        locIntersection = mgl.vec2(locr2[1] - a ,0)
    else
        return false,nil
    end
    
    local intercetion = Utility.vectorFix(M * mgl.vec3(locIntersection, 1))
    intercetion = mgl.vec2(intercetion[1],intercetion[2])
    if (locIntersection[1] < 0) and (locIntersection[1] >  locl2[1]) then
        return false , intercetion
    end
    return true , intercetion
end

function Utility.isPointInsideRectangle(p, min, max)
    if p[1] < min[1] then
        return false
    elseif p[2] < min[2] then
        return false
    elseif p[1] > max[1] then
        return false
    elseif p[2] > max[2] then
        return false
    end
    return true
end

function Utility.isPointOnTheLine(p,startP,endP)
    local delta = endP - startP
    delta = mgl.normalize(delta)
    local M = mgl.mat3(1)
    local deltaPerpentecular = Utility.rotateVector2d(delta, 90)
    M = M * mgl.translate(mgl.vec2(startP[1],startP[2]))
    --M[3] = l1[1]
    --M[6] = l1[2]
    M[1] = delta[1]
    M[4] = delta[2]
    M[2] = deltaPerpentecular[1]
    M[5] = deltaPerpentecular[2]
    local Minv = mgl.inverse(M)
    local locl2 = Utility.vectorFix(Minv * mgl.vec3(endP, 1))
    local locP = Utility.vectorFix(Minv * mgl.vec3(p, 1))
    if Utility.fuzzyCompare(locP[2],0) ~= true then
        return false
    end
    if (locP[1] < 0) or (locl2[1] < locP[1]) then
        return false
    end
    return true
end

function Utility.isLineIntersectRectangle(p1,p2,min,max)
    local minRight = mgl.vec2(max[1],min[2])
    local maxLeft = mgl.vec2(min[1],max[2])
    local delta = minRight - min
    delta = mgl.normalize(delta)
    local M = mgl.mat3(1)
    local deltaPerpentecular = Utility.rotateVector2d(delta, 90)
    M = M * mgl.translate(min)
    M[1] = delta[1]
    M[4] = delta[2]
    M[2] = deltaPerpentecular[1]
    M[5] = deltaPerpentecular[2]
    local Minv = mgl.inverse(M)
    local lp1 = Utility.vectorFix(Minv * mgl.vec3(p1, 1))
    local lp2 = Utility.vectorFix(Minv * mgl.vec3(p2, 1))
    local lmax = Utility.vectorFix(Minv * mgl.vec3(max, 1))
    
    if Utility.fuzzyCompare(lp1[1],lp2[1]) then -- line perpendecular x axis
        -- not intersected cases
        if (lp1[1] < 0) or (lmax[1] < lp1[1]) then return false end
        if (lp1[2] < 0) and (lp2[2] <0) then return false end
        if (lp1[2] > lmax[2]) and (lp2[2] > lmax[2]) then return false end
        -- intersected
        return true

    elseif Utility.fuzzyCompare(lp1[2],lp2[2]) then -- line perpendecular y axis
        -- not intersected cases
        if (lp1[2] < 0) or (lmax[2] < lp1[2]) then return false end
        if (lp1[1] < 0) and (lp2[1] <0) then return false end
        if (lp1[1] > lmax[1]) and (lp2[1] > lmax[1]) then return false end
         -- intersected
         return true
    else
        --inclined line rectangle not supported yet
        print("inclined line rectangle not supported yet")
        return nil
    end
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function Utility.convertTrimCuts(cuts,parts,trim)
    local oParts = {}
    local halfGap = trim.gap * 0.5
    local gap = trim.gap
    for i, p in ipairs(parts) do
        local newOPart = {}
        newOPart.min = mgl.vec2(p.min[1] - halfGap, p.min[2] - halfGap)
        newOPart.width = p.width + gap
        newOPart.height = p.height + gap
        newOPart.max = newOPart.min + mgl.vec2(newOPart.width,newOPart.height)
        table.insert(oParts,newOPart)
    end

    local currentTrimCut = {}
    for i,c in ipairs(cuts) do
        if (c.level == 0) then
            table.insert(currentTrimCut , c)
        end
    end

    for i,c in ipairs(currentTrimCut) do
        local isIntersec = false
        for j,p in ipairs(oParts) do
            if Utility.isLineIntersectRectangle(c.startP,c.endP,p.min,p.max) then
                isIntersec = true 
                break -- find then out
            end
        end
        c.intersect = isIntersec
    end

    print("dur")


end

colorPalette = {
    {1, 0, 0},
    {0, 1, 0},
    {0, 0, 1},
    {1, 1, 0},
    {0, 1, 1},
    {1, 0, 1},
    {1, 0, 0},
    {0, 1, 0},
    {0, 0, 1},
    {1, 1, 0},
    {0, 1, 1},
    {1, 0, 1},
    {1, 0, 0},
    {0, 1, 0},
    {0, 0, 1},
    {1, 1, 0},
    {0, 1, 1},
    {1, 0, 1},
    {1, 0, 0},
    {0, 1, 0},
    {0, 0, 1},
    {1, 1, 0},
    {0, 1, 1},
    {1, 0, 1},
    {1, 0, 0},
    {0, 1, 0},
    {0, 0, 1},
    {1, 1, 0},
    {0, 1, 1},
    {1, 0, 1},
    {1, 0, 0},
    {0, 1, 0},
    {0, 0, 1},
    {1, 1, 0},
    {0, 1, 1},
    {1, 0, 1},
    {1, 0, 0},
    {0, 1, 0},
    {0, 0, 1},
    {1, 1, 0},
    {0, 1, 1},
    {1, 0, 1}
}

return Utility
