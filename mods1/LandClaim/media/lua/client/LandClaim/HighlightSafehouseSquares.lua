require "lua_timers"

local HighlightSafehouse = {}
HighlightSafehouse.color = ColorInfo.new(1.0, 0.0, 0.0, 1.0)
HighlightSafehouse.duration = 100

--- Highlight all squares of a safehouse
---@param safehouse Safehouse
---@param duration Number (Optional)
---@param color ColorInfo (Optional)
HighlightSafehouse.Highlight = function(safehouse, duration, color)
    if not safehouse then return end
    local x1 = safehouse:getX()
    local y1 = safehouse:getY()
    local x2 = safehouse:getX2()
    local y2 = safehouse:getY2()
    local cell = getCell()

    duration = duration or HighlightSafehouse.duration
    color = color or HighlightSafehouse.color

    for x = x1, x2-1 do
        for y = y1, y2-1 do
            local timerName = "highlightsafehousesq"..x..y
            if timer:Exists(timerName) then
                timer:Remove(timerName)
            end
            timer:Create(timerName, 0, duration, function()
                local sq = cell:getOrCreateGridSquare(x,y,0)
                
                if not sq or not sq:getFloor() then return end

                sq:getFloor():setHighlighted(true)            
                sq:getFloor():setHighlightColor(color)
            end)
        end
    end
end

return HighlightSafehouse