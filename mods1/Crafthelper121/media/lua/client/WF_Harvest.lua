local function sortSquares(a, b)
    if a:getX() == b:getX() then
        if a:getX() % 2 == 1 then
            return a:getY() > b:getY()
        else
            return a:getY() < b:getY()
        end
    end
    return a:getX() < b:getX()
end

local fieldMaxRange = 20
local function scanForField(square)
    -- finds all connected squares which is tendable and returns as a list
    local field = {}
    local visited = {}
    local queue = {}
    local function addSquare(sq)
        if visited[sq] then return end
        visited[sq] = true

        local plant = CFarmingSystem.instance:getLuaObjectOnSquare(sq)
        if plant and plant:canHarvest() then
            table.insert(field, sq)
            table.insert(queue, sq)
        end
    end
    addSquare(square)
    while #queue > 0 do
        local sq = table.remove(queue, 1)
        local x = sq:getX()
        local y = sq:getY()
        local z = sq:getZ()
        for dx = -1, 1 do
            for dy = -1, 1 do
                if dx ~= 0 or dy ~= 0 then
                    local nx = x + dx
                    local ny = y + dy
                    local nsq = getCell():getGridSquare(nx, ny, z)
                    if nsq and not visited[nsq] and nsq:DistTo(square) < fieldMaxRange then
                        addSquare(nsq)
                    end
                end
            end
        end
    end
    table.sort(field, sortSquares)
    return field
end

local HarvestField = ISBaseTimedAction:derive("HarvestField")

function HarvestField:new(character, field)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.field = field
    o.maxTime = 1
    o.stopOnWalk = true
    return o
end

function HarvestField:isValid()
    return #self.field > 0
end

function HarvestField:perform()
    local next = table.remove(self.field, 1)
    local plant = CFarmingSystem.instance:getLuaObjectOnSquare(next)
    if not plant then
	    ISBaseTimedAction.perform(self)
        return
    end
    ISFarmingMenu.onHarvest(nil, plant, next, self.character)
    if #self.field > 0 then
        ISTimedActionQueue.add(HarvestField:new(self.character, self.field))
    end
	ISBaseTimedAction.perform(self)
end

function OnPreFillWorldObjectContextMenu(playerIdx, context, worldobjects, test)
    if test then return end
    local square = worldobjects[1]:getSquare()
    if not square then return end
    local plant = CFarmingSystem.instance:getLuaObjectOnSquare(square)
    if not plant then return end
    if not plant:isAlive() then return end
    if not plant:canHarvest() then return end

    local playerObj = getSpecificPlayer(playerIdx)

    local field = scanForField(square)
    if #field > 1 then
        context:addOption("Harvest Field", nil, function()
            ISTimedActionQueue.add(HarvestField:new(playerObj, field))
        end)
    end
end

Events.OnPreFillWorldObjectContextMenu.Add(OnPreFillWorldObjectContextMenu)