function widget:GetInfo()
    return {
        name      = "Radar Ranges",
        desc      = "Draws radar ranges on the map when radar units are selected.",
        author    = "Nixtux", --Rework of version by AF
        date      = "28/07/2007",
        license   = "GNU GPL, v2 or later",
        layer     = 5,
        enabled   = true  --  loaded by default?
    }
end

local units = {}
local unitstodraw = {}
local unitstodrawlength = 0

function widget:Update()
    units = {}
    unitstodraw = {}
    units = Spring.GetSelectedUnits()
    
    for _,uid in ipairs(units) do
        local udid = Spring.GetUnitDefID(uid)
        local ud = udid and UnitDefs[udid] or nil
        if (ud and (ud.radarRadius > 400)) then
            local x, y, z = Spring.GetUnitBasePosition(uid)
            if (x) then
                 unitstodraw[uid] = {pos = {x,y,z}, range = ud.radarRadius, colormap = {0.5, 0.5, 1, 0.5}}
            end
        end
        if (ud and (ud.jammerRadius > 200)) then
            local x, y, z = Spring.GetUnitBasePosition(uid)
            if (x) then
	        unitstodraw[uid] = {pos = {x,y,z}, range = ud.jammerRadius,  colormap = {1, 0, 0, 0.5}}
            end
        end
    end
    unitstodrawlength = #unitstodraw
end

function widget:DrawWorldPreUnit()
    gl.LineWidth(5)
    for i=1, unitstodrawlength do
        local pos = unitstodraw[i].pos
        local radarRadius = unitstodraw[i].range
        local color = unitstodraw[i].colormap
        gl.Color(color[1], color[2], color[3], color[4])
        gl.DrawGroundCircle(pos[1], pos[2], pos[3], radarRadius, 48)
    end
    gl.Color(1,1,1,1)
    gl.LineWidth(1)
end
