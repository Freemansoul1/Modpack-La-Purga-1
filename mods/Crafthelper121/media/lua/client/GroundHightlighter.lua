--- @class Bounds
--- @field x1 number
--- @field y1 number
--- @field x2 number
--- @field y2 number
--- @field z1 number
--- @field z2 number
---
--- @class Color
--- @field r number
--- @field g number
--- @field b number
--- @field a number
---
--- @class Center
--- @field x number
--- @field y number
--- @field z number
---
--- @class GroundHightlighter
--- @field type string none | square | circle | circle_manhattan
--- @field bounds Bounds
--- @field radius number
--- @field center Center
--- @field color table<number, Color>
--- @field xray boolean
GroundHightlighter = {}

--- @return GroundHightlighter
function GroundHightlighter:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.type = "none"
    o.bounds = {x1 = 0, y1 = 0, x2 = 0, y2 = 0, z1 = 0, z2 = 0}
    o.radius = 0
    o.center = {x = 0, y = 0, z = 0}
    o.color = {
        [0] = {r = 0.0, g = 1.0, b = 0, a = 1.0}
    }
    o.xray = false
    return o
end

function GroundHightlighter:getColor(x, y)
    local dist = 0
    if self.type == "circle_manhattan" then
        local dx = math.abs(x - self.center.x)
        local dy = math.abs(y - self.center.y)
        dist = math.floor(dx + dy)
    else
        local dx = x - self.center.x
        local dy = y - self.center.y
        dist = math.floor(math.sqrt((dx * dx) + (dy * dy)))
    end
    for i = dist, 0, -1 do
        if self.color[i] then
            return self.color[i]
        end
    end
end

function GroundHightlighter:isPointInRadius(x, y)
    local dx = x - self.center.x
    local dy = y - self.center.y
    return (dx * dx) + (dy * dy) <= (self.radius * self.radius)
end

function GroundHightlighter:isPointInManhattenRadius(x, y)
    local dx = math.abs(x - self.center.x)
    local dy = math.abs(y - self.center.y)
    return dx + dy <= self.radius
end

function GroundHightlighter:isVisible(x, y, z)
    if self.type == "square" then
        return x >= self.bounds.x1 and x <= self.bounds.x2 and y >= self.bounds.y1 and y <= self.bounds.y2
    end
    if self.type == "circle_edge" then
        -- should only highlight the edge of the circle
        local dx = x - self.center.x
        local dy = y - self.center.y
        local dist = (dx * dx) + (dy * dy)
        local r2 = self.radius * self.radius
        return dist >= r2 - 1.5 and dist <= r2 + 1.5
    end
    if self.type == "circle_manhattan" then
        return self:isPointInManhattenRadius(x, y)
    end
    return self:isPointInRadius(x, y)
end

function GroundHightlighter:tryHighlightWorldSquare(sq, enabled)
    if enabled and not self:isVisible(sq:getX(), sq:getY()) then
        return
    end
    local color = self:getColor(sq:getX(), sq:getY())

    local objs = sq:getObjects()
    for i = 0, objs:size() - 1 do
        local obj = objs:get(i)
        if (obj:isFloor() or self.xray or not enabled) and obj:getType() ~= IsoObjectType.tree then
            obj:setHighlighted(enabled, false)
            if enabled then
                obj:setHighlightColor(color.r, color.g, color.b, color.a)
            end
        end
    end
    objs = sq:getSpecialObjects()
    for i = 0, objs:size() - 1 do
        local obj = objs:get(i)
        if obj:isFloor() or self.xray or not enabled then
            obj:setHighlighted(enabled, false)
            if enabled then
                obj:setHighlightColor(color.r, color.g, color.b, color.a)
            end
        end
    end
end

function GroundHightlighter:setHightlighted(enabled)
    local cell = getCell()
    if enabled and self.removeSnow then
        getSandboxOptions():getOptionByName("EnableSnowOnGround"):setValue(false)
    elseif not enabled and self.removeSnow then
        getSandboxOptions():getOptionByName("EnableSnowOnGround"):setValue(true)
    end
    for x = self.bounds.x1, self.bounds.x2 do
        for y = self.bounds.y1, self.bounds.y2 do
            for z = self.bounds.z1, self.bounds.z2 do
                local sq = cell:getGridSquare(x, y, z)
                if sq then
                    self:tryHighlightWorldSquare(sq, enabled)
                end
            end
        end
    end
end

function GroundHightlighter:remove()
    if self.type ~= "none" then
        self:setHightlighted(false)
        self.type = "none"
        self.bounds.x1 = 0
        self.bounds.y1 = 0
        self.bounds.x2 = 0
        self.bounds.y2 = 0
        self.bounds.z1 = 0
        self.bounds.z2 = 0
    end
end

function GroundHightlighter:setColor(r, g, b, a)
    self.color = { [0] = {r = r, g = g, b = b, a = a or 1.0} }
    if self.type ~= "none" then
        self:setHightlighted(false)
        self:setHightlighted(true)
    end
end

function GroundHightlighter:resetColor()
    self.color = { [0] = {r = 0.0, g = 1.0, b = 0, a = 1.0} }
    if self.type ~= "none" then
        self:setHightlighted(false)
        self:setHightlighted(true)
    end
end

function GroundHightlighter:addColorStop(d, r, g, b, a)
    self.color[d] = {r = r, g = g, b = b, a = a or 1.0}
    if self.type ~= "none" then
        self:setHightlighted(false)
        self:setHightlighted(true)
    end
end

function GroundHightlighter:enableXray(enabled, removeSnow)
    if self.type ~= "none" then
        self:remove()
    end
    self.xray = enabled
    self.removeSnow = removeSnow or false
    if self.type ~= "none" then
        self:setHightlighted(true)
    end
end

function GroundHightlighter:highlightSquare(x1, y1, x2, y2, z)
    self:remove()
    self.type = "square"
    self.bounds.x1 = math.floor(x1)
    self.bounds.y1 = math.floor(y1)
    self.bounds.x2 = math.floor(x2)
    self.bounds.y2 = math.floor(y2)
    self.bounds.z1 = z or 0
    self.bounds.z2 = z or 0
    self.center.x = math.floor((x1 + x2) / 2)
    self.center.y = math.floor((y1 + y2) / 2)
    self.center.z = z or 0
    self:setHightlighted(true)
end

function GroundHightlighter:highlightCube(x1, y1, x2, y2, z1, z2)
    self:remove()
    self.type = "square"
    self.bounds.x1 = math.floor(x1)
    self.bounds.y1 = math.floor(y1)
    self.bounds.x2 = math.floor(x2)
    self.bounds.y2 = math.floor(y2)
    self.bounds.z1 = math.floor(z1)
    self.bounds.z2 = math.floor(z2)
    self.center.x = math.floor((x1 + x2) / 2)
    self.center.y = math.floor((y1 + y2) / 2)
    self.center.z = math.floor((z1 + z2) / 2)
    self:setHightlighted(true)
end

function GroundHightlighter:highlightCircle(x, y, radius, z)
    self:remove()
    self.type = "circle"
    self.radius = radius
    self.center.x = math.floor(x)
    self.center.y = math.floor(y)
    self.center.z = z or 0
    self.bounds.x1 = math.floor(x - radius)
    self.bounds.y1 = math.floor(y - radius)
    self.bounds.x2 = math.floor(x + radius)
    self.bounds.y2 = math.floor(y + radius)
    self.bounds.z1 = z or 0
    self.bounds.z2 = z or 0
    self:setHightlighted(true)
end

function GroundHightlighter:highlightCircleManhattan(x, y, radius, z1, z2)
    self:remove()
    self.type = "circle_manhattan"
    self.radius = radius
    self.center.x = math.floor(x)
    self.center.y = math.floor(y)
    self.center.z = z1 or 0
    self.bounds.x1 = math.floor(x - radius)
    self.bounds.y1 = math.floor(y - radius)
    self.bounds.x2 = math.floor(x + radius)
    self.bounds.y2 = math.floor(y + radius)
    self.bounds.z1 = z1 or 0
    self.bounds.z2 = z2 or 0
    self:setHightlighted(true)
end

--- this is broken.. do not use yet
-- function GroundHightlighter:highlightCircleEdge(x, y, radius, z)
--     self:remove()
--     self.type = "circle_edge"
--     self.radius = radius
--     self.center.x = math.floor(x)
--     self.center.y = math.floor(y)
--     self.center.z = z or 0
--     self.bounds.x1 = math.floor(x - radius)
--     self.bounds.y1 = math.floor(y - radius)
--     self.bounds.x2 = math.floor(x + radius)
--     self.bounds.y2 = math.floor(y + radius)
--     self:setHightlighted(true)
-- end