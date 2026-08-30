--***********************************************************
--**                       BitBraven                       **
--***********************************************************

local variables = {
    escapeRopeSquare = nil,
    thumpableWindow = nil,
    hoppableObject = nil,
    thump = nil,
    invincibleWindow = false,
    window = nil,
    windowFrame = nil,
    hoppableN = nil,
    hoppableW = nil,
    ledgeSquare = nil,
    emptySquare = nil,
    clickedSquare = nil,
}

local onAddEscapeRope = function(worldobjects, entity, playerObj)
    if not variables.emptySquare then return end
	local playerInv = playerObj:getInventory()
    local square = nil
    local squareX = variables.emptySquare:getX()
    local squareY = variables.emptySquare:getY()

    if instanceof(entity,"IsoGridSquare") then
        square = entity
    else
        square = entity:getSquare()
    end

    if not square then return end
	if luautils.walkAdjWindowOrDoor(playerObj, square, entity) then
		local items = playerInv:getSomeTypeRecurse(BB_Escape_Rope.itemName, 1)
		if items:size() < 1 then return end
        ISWorldObjectContextMenu.transferIfNeeded(playerObj, items:get(0))
		ISTimedActionQueue.add(BB_Escape_Rope_ISTimedAction:AddRope(playerObj, entity, squareX, squareY, variables.emptySquare))
	end
end

local onRemoveEscapeRope = function(worldobjects, entity, playerObj)
    if not entity then return end
    local square = nil
    local squareX = variables.emptySquare:getX()
    local squareY = variables.emptySquare:getY()

    if instanceof(entity,"IsoGridSquare") then
        square = entity
    else
        square = entity:getSquare()
    end

    if not square then return end
	if luautils.walkAdjWindowOrDoor(playerObj, square, entity) then
		ISTimedActionQueue.add(BB_Escape_Rope_ISTimedAction:RemoveRope(playerObj, entity, squareX, squareY, variables.emptySquare, false))
	end
end

local onRemoveEscapeRopeBelow = function(worldobjects, entity, playerObj)
    if not entity then return end
    local square = nil
    local squareX = variables.emptySquare:getX()
    local squareY = variables.emptySquare:getY()

    if instanceof(entity,"IsoGridSquare") then
        square = entity
    else
        square = entity:getSquare()
    end

    if not square then return end
	if luautils.walkAdjWindowOrDoor(playerObj, square, entity) then
		ISTimedActionQueue.add(BB_Escape_Rope_ISTimedAction:RemoveRope(playerObj, entity, squareX, squareY, variables.emptySquare, true))
	end
end

local onClimbSheetRope = function(worldobjects, square, playerObj)
	if square then
        local squareX = variables.emptySquare:getX()
        local squareY = variables.emptySquare:getY()
		ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, square))
		ISTimedActionQueue.add(BB_Escape_Rope_ISTimedAction:ClimbRope(playerObj, square, squareX, squareY, variables.emptySquare, false))
	end
end

local onClimbSheetRopeBelow = function(worldobjects, square, playerObj)
	if square then
        local squareX = variables.emptySquare:getX()
        local squareY = variables.emptySquare:getY()
		ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, square))
		ISTimedActionQueue.add(BB_Escape_Rope_ISTimedAction:ClimbRope(playerObj, square, squareX, squareY, variables.emptySquare, true))
	end
end

local tryFetch = function(v, playerObj, doSquare)

    local square = v:getSquare()
    local sprite = v:getSprite()
    local spriteProperties = nil

    if square then
        local squareX = square:getX()
        local squareY = square:getY()
        local squareZ = square:getZ()
        local sqs = {}
        local cell = getCell()
        sqs[1] = cell:getGridSquare(squareX + 1, squareY, squareZ)
        sqs[2] = cell:getGridSquare(squareX - 1, squareY, squareZ)
        sqs[3] = cell:getGridSquare(squareX, squareY + 1, squareZ)
        sqs[4] = cell:getGridSquare(squareX, squareY - 1, squareZ)

        for i, sq in pairs(sqs) do
            if not sq:isSolidFloor() then
                if sq:isBlockedTo(playerObj:getSquare()) == false then
                    variables.ledgeSquare = square
                end
                variables.emptySquare = sq
            end
        end

        variables.clickedSquare = square
    end

    if sprite then
        spriteProperties = sprite:getProperties()
    end

	if square and square:getModData().hasEscapeRope then
        variables.escapeRopeSquare = square
    end

	if sprite and spriteProperties and spriteProperties:Is(IsoFlagType.HoppableN) then
		variables.hoppableN = v
	end
	if sprite and spriteProperties and spriteProperties:Is(IsoFlagType.HoppableW) then
		variables.hoppableW = v
	end

	if variables.hoppableN ~= nil then
		variables.hoppableObject = variables.hoppableN
	elseif variables.hoppableW ~= nil then
		variables.hoppableObject = variables.hoppableW
	end

	if instanceof(v, "IsoThumpable") and not v:isDoor() then
        if v:isWindow() then
            variables.thumpableWindow = v
        end
	end

	if not variables.hoppableObject and variables.thumpableWindow then
		variables.hoppableObject = variables.thumpableWindow
	end

    if instanceof(v, "IsoObject") and sprite and spriteProperties and spriteProperties:Is(IsoFlagType.makeWindowInvincible) then
        variables.invincibleWindow = true
    end

	if instanceof(v, "IsoWindow") then
		variables.window = v
	end

    if IsoWindowFrame.isWindowFrame(v) and not variables.window then
        variables.windowFrame = v
    end
end

local onFillWorldObjectContextMenu = function(player, context, worldobjects, test)
    if not worldobjects then return end
	local playerObj = getSpecificPlayer(player)
    local playerZ = playerObj:getZ()
    local worksBothWays = SandboxVars.RappelKit.WorksBothWays
    if (playerZ < 1 or playerZ > SandboxVars.RappelKit.MaxFloor) and worksBothWays == false then return end
	local playerInv = playerObj:getInventory()
    variables = {}
    for i,v in ipairs(worldobjects) do
		tryFetch(v, playerObj, true)
    end

    local ropeStartSq = variables.emptySquare or variables.clickedSquare
	if ropeStartSq ~= nil and (ropeStartSq:getModData().hasEscapeRope or ropeStartSq:getModData().isERGroundFloor) then

        local canClimb = false
        if (not variables.window and not variables.windowFrame)
        or (variables.window ~= nil and variables.window:IsOpen() == true and not variables.window:isBarricaded())
        or (variables.windowFrame ~= nil and IsoWindowFrame.canAddSheetRope(variables.windowFrame)) then
            canClimb = true
        end

        if ropeStartSq:getModData().hasEscapeRope then
            context:addOptionOnTop(getText("ContextMenu_Remove_Escape_Rope"), worldobjects, onRemoveEscapeRope, variables.ledgeSquare or variables.clickedSquare, playerObj)

            if canClimb then
                context:addOptionOnTop(getText("ContextMenu_Climb_Escape_Rope"), worldobjects, onClimbSheetRope, variables.ledgeSquare or variables.clickedSquare, playerObj)
            end
        elseif ropeStartSq:getModData().isERGroundFloor then
            variables.emptySquare = ropeStartSq
            context:addOptionOnTop(getText("ContextMenu_Remove_Escape_Rope"), worldobjects, onRemoveEscapeRopeBelow, variables.ledgeSquare or variables.clickedSquare, playerObj)
            context:addOptionOnTop(getText("ContextMenu_Climb_Escape_Rope"), worldobjects, onClimbSheetRopeBelow, variables.ledgeSquare or variables.clickedSquare, playerObj)
        end

        return
	end

    if playerInv:getItemCountRecurse(BB_Escape_Rope.itemName) <= 0 then return end
    if playerZ < 1 and worksBothWays == true then return end

    if variables.emptySquare then
        local objs = variables.emptySquare:getObjects()
        for n = objs:size() -1, 0, -1 do
            local obj = objs:get(n)
            if instanceof(obj, "IsoObject") and obj:getModData().isEscapeRope then
                return
            end
        end
    end

	if variables.hoppableObject ~= nil and (not variables.invincibleWindow) and (not variables.window) then
		if variables.hoppableObject:canAddSheetRope() and playerObj:getCurrentSquare():getZ() > 0 then
            context:addOptionOnTop(getText("ContextMenu_Add_Escape_Rope"), worldobjects, onAddEscapeRope, variables.hoppableObject, playerObj)
            return
		end
	end

	if variables.window ~= nil and (not variables.invincibleWindow) and variables.window:IsOpen() == true then
		if variables.window:canAddSheetRope() and playerObj:getCurrentSquare():getZ() > 0 and not variables.window:isBarricaded() then
            context:addOptionOnTop(getText("ContextMenu_Add_Escape_Rope"), worldobjects, onAddEscapeRope, variables.window, playerObj)
            return
		end
	end

	if variables.windowFrame ~= nil and (not variables.thumpableWindow) then
		if IsoWindowFrame.canAddSheetRope(variables.windowFrame) and playerObj:getCurrentSquare():getZ() > 0 then
            context:addOptionOnTop(getText("ContextMenu_Add_Escape_Rope"), worldobjects, onAddEscapeRope, variables.windowFrame, playerObj)
            return
		end
	end

	if variables.ledgeSquare ~= nil and (not variables.hoppableObject) and (not variables.windowFrame) and (not variables.window) and (not variables.emptySquare:getModData().hasEscapeRope) then
        context:addOptionOnTop(getText("ContextMenu_Add_Escape_Rope"), worldobjects, onAddEscapeRope, variables.ledgeSquare, playerObj)
        return
	end
end

Events.OnFillWorldObjectContextMenu.Add(onFillWorldObjectContextMenu)