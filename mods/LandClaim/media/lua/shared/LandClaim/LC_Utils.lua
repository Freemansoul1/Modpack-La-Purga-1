LC_Utils = {}

local MAX_X = 150
local MAX_Y = 150

function LC_Utils.GetDistanceSquared(x1, y1, x2, y2)
    local dx = math.abs(x2 - x1)
    local dy = math.abs(y2 - y1)
    return dx * dx + dy * dy
end

function LC_Utils.CalculateCellCoordinates(x, y)    
    local cellX = math.floor(x / 300)
    local cellY = math.floor(y / 300)
    return {x = cellX, y = cellY}
end

function LC_Utils.GetSurroundingCoordinates(x, y, radius, includeSelf)
    local surroundingCoordinates = {}

    radius = radius or 1

    for i = math.max(0, x - radius), math.min(x + radius, MAX_X) do
        for j = math.max(0, y - radius), math.min(y + radius, MAX_Y) do
            if i ~= x or j ~= y then
                table.insert(surroundingCoordinates, {x = i, y = j})
            end
        end
    end

    if includeSelf then
        table.insert(surroundingCoordinates, {x = x, y = y})
    end

    return surroundingCoordinates
end

function LC_Utils.CalculateSquareCoordinates(cx, cy, width, height)
    local halfWidth = width / 2
    local halfHeight = height / 2

    local x1 = cx - halfWidth
    local y1 = cy - halfHeight

    local x2 = cx + halfWidth
    local y2 = cy + halfHeight

    return {x1= x1, y1= y1}
end

function LC_Utils.GetSafehouseId(safehouse)
    if not safehouse then return "" end
    return safehouse:getTitle()
end