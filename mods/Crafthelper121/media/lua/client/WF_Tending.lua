if WFTending then
    Events.OnPreFillWorldObjectContextMenu.Remove(WFTending.OnPreFillWorldObjectContextMenu)
end

WFTending = {}

local function predicateNotBroken(item)
    return not item:isBroken()
end

function WFTending.isTendablePlant(square)
    local plant = CFarmingSystem.instance:getLuaObjectOnSquare(square)
    if not plant then return false end
    if not plant:isAlive() then return false end
    if not plant.lastTendHour then return true end
    if ISFarmingMenu.cheat then return true end
    if plant.lastTendHour + 22 > CFarmingSystem.instance.hoursElapsed then return false end
    return true
end

WFTending.TendAction = ISBaseTimedAction:derive("WFTending.TendAction")

function WFTending.TendAction:isValid()
    return WFTending.isTendablePlant(self.sq)
end

function WFTending.TendAction:waitToStart()
	self.character:faceLocation(self.sq:getX(), self.sq:getY())
	return self.character:shouldBeTurning()
end

function WFTending.TendAction:update()
	self.character:faceLocation(self.sq:getX(), self.sq:getY())
    self.character:setMetabolicTarget(Metabolics.LightWork)
end

function WFTending.TendAction:start()
	self:setActionAnim(CharacterActionAnims.Dig)
end

function WFTending.TendAction:perform()
    local args = { x = self.sq:getX(), y = self.sq:getY(), z = self.sq:getZ() }
    sendClientCommand(self.character, 'farming', 'tend', args)
    self.character:getXp():AddXP(Perks.Farming, 0.5)
    if ZombRand(40) == 0 then
        self.scissors:setCondition(self.scissors:getCondition() - 1)
        ISWorldObjectContextMenu.checkWeapon(self.character)
    end
    -- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)

    if self.field and #self.field > 0 then
        local scissors = self.character:getInventory():getFirstTypeEvalRecurse("Scissors", predicateNotBroken)
        if scissors and luautils.walkAdj(self.character, self.field[1]) then
            ISWorldObjectContextMenu.equip(self.character, self.character:getPrimaryHandItem(), scissors, true)
            ISTimedActionQueue.add(ISPlantInfoAction:new(self.character, CFarmingSystem.instance:getLuaObjectOnSquare(self.field[1])))
            ISTimedActionQueue.add(WFTending.TendAction:new(self.character, self.field, scissors))
        end
    end
end

function WFTending.TendAction:new(character, sqOrSquares, scissors)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
    o.scissors = scissors
	o.stopOnWalk = true
	o.stopOnRun = true
	o.maxTime = 150
	if character:isTimedActionInstant() then
		o.maxTime = 1
	end
    -- if sqOrSquares is a table, it's a field
    if type(sqOrSquares) == "table" then
        o.sq = table.remove(sqOrSquares, 1)
        o.field = sqOrSquares
    else
        o.sq = sqOrSquares
    end
	return o
end

local function createCursor(playerObj, square)
    local x = square:getX()
    local y = square:getY()
    local z = square:getZ()
    local cursor = WFTendCursor:new(playerObj)
    getCell():setDrag(cursor, playerObj:getPlayerNum())
    if cursor:isValid(square) then
        cursor:create(x, y, z)
    end
end

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
        if not WFTending.isTendablePlant(sq) then return end
        if visited[sq] then return end
        visited[sq] = true
        table.insert(field, sq)
        table.insert(queue, sq)
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

function WFTending.OnPreFillWorldObjectContextMenu(playerIdx, context, worldobjects, test)
    if test then return end
    local square = worldobjects[1]:getSquare()
    if not square then return end
    if not WFTending.isTendablePlant(square) then return end
    local playerObj = getSpecificPlayer(playerIdx)
    local opt = context:addOption("Tend Plants", playerObj, createCursor, square)
    local scissors = playerObj:getInventory():getFirstTypeEvalRecurse("Scissors", predicateNotBroken)
    if not scissors then
        opt.notAvailable = true
        opt.toolTip = ISInventoryPaneContextMenu.addToolTip()
        opt.toolTip.description = "Scissors"
        opt.toolTip:setName(getText("ContextMenu_MissingTools"))
        opt.toolTip:setVisible(false)
    end
    if scissors then
        local field = scanForField(square)
        if #field > 1 then
            context:addOption("Tend Field", playerObj, function ()
                if luautils.walkAdj(playerObj, field[1]) then
                    ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), scissors, true)
                    ISTimedActionQueue.add(ISPlantInfoAction:new(playerObj, CFarmingSystem.instance:getLuaObjectOnSquare(field[1])))
                    ISTimedActionQueue.add(WFTending.TendAction:new(playerObj, field, scissors))
                end
            end)
        end
    end
end

Events.OnPreFillWorldObjectContextMenu.Add(WFTending.OnPreFillWorldObjectContextMenu)