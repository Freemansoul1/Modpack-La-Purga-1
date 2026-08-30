local followerInventoryItem = nil

local function StartFollowing(item)
    local md = item:getModData()
    md.WPF_Following = true
    md.WPF_Following_Player = getPlayer():getUsername()
    followerInventoryItem = item
    getPlayer():setHaloNote("Hold right shift + L/R arrows to rotate, Hold right ctrl + L/R/U/D arrows to offset", 0, 255, 0, 500)
end

local function StopFollowing(item)
    local md = item:getModData()
    md.WPF_Following = false

    if not followerInventoryItem or not followerInventoryItem.getWorldItem then
        followerInventoryItem = false
        return
    end

    local worldItem = followerInventoryItem:getWorldItem()
    if not worldItem then
        return
    end
    local square = worldItem:getSquare()
    if not square then
        return
    end
    local player = getPlayer()
    if md.WPF_Following_Player ~= player:getUsername() then
        return
    end

    square:transmitRemoveItemFromSquare(followerInventoryItem:getWorldItem())
    square:removeWorldObject(followerInventoryItem:getWorldItem())
    followerInventoryItem:setWorldItem(nil)
    player:getInventory():AddItem(followerInventoryItem)

    followerInventoryItem = false
end

local function OnFillInventoryObjectContextMenu(player, context, items)
    if isClient() and not (isAdmin() or getAccessLevel() == "gm" or getAccessLevel() == "overseer"
            or getAccessLevel() == "moderator") then
        return
    end

	local firstItem = items[1]
	if firstItem == nil or firstItem.items == nil then return end
    local item = firstItem.items[1]
    if item == nil then return end

    if followerInventoryItem == item then
        context:addOption("Stop Following", item, StopFollowing)
    else
        context:addOption("Follow Me", item, StartFollowing)
    end
end

local function getSurface(square)
    local surface = 0
    for i=1,square:getObjects():size() do
        local object = square:getObjects():get(i-1)
        if object:getSurfaceOffsetNoTable() > 0 then
            local newSurf = (object:getSurfaceOffsetNoTable() / 96)
            if newSurf > surface then
                surface = newSurf
            end
        end
    end
    return surface
end

local tickCooldown = 0
local lastXPos = 0
local lastYPos = 0
local lastZPos = 0
local lastRot = 0
local rotationDelta = -90 -- Sane default as most props seems to be rotated 90 degrees
local offsetXDelta = 0
local offsetYDelta = 0
local function Error(player)
    HaloTextHelper.addText(player, "Error in Follow")
    followerInventoryItem = nil
    tickCooldown = 0
end
local function OnTick()
    if not followerInventoryItem then return end

    if tickCooldown > 0 then
        tickCooldown = tickCooldown - 1
        return
    end

    tickCooldown = 30

    local forceReplace = false
    if isKeyDown(Keyboard.KEY_RSHIFT) then
        if isKeyDown(Keyboard.KEY_RIGHT) then
            rotationDelta = rotationDelta + 10
            forceReplace = true
            if rotationDelta > 360 then rotationDelta = rotationDelta - 360 end
            tickCooldown = 15
        end
        if isKeyDown(Keyboard.KEY_LEFT) then
            rotationDelta = rotationDelta - 10
            forceReplace = true
            if rotationDelta < 0 then rotationDelta = rotationDelta + 360 end
            tickCooldown = 15
        end
    end
    if isKeyDown(Keyboard.KEY_RCONTROL) then
        if isKeyDown(Keyboard.KEY_RIGHT) then
            offsetXDelta = math.min(offsetXDelta + 0.1, 5)
            forceReplace = true
            tickCooldown = 15
        end
        if isKeyDown(Keyboard.KEY_LEFT) then
            offsetXDelta = math.max(offsetXDelta - 0.1, -5)
            forceReplace = true
            tickCooldown = 15
        end
        if isKeyDown(Keyboard.KEY_UP) then
            offsetYDelta = math.max(offsetYDelta - 0.1, -5)
            forceReplace = true
            tickCooldown = 15
        end
        if isKeyDown(Keyboard.KEY_DOWN) then
            offsetYDelta = math.min(offsetYDelta + 0.1, 5)
            forceReplace = true
            tickCooldown = 15
        end
    end

    local player = getPlayer()
    if not player then return end
    local playerSquare = player:getSquare()
    if not playerSquare then return end

    local xPos = player:getX() - math.floor(player:getX()) + offsetXDelta
    local yPos = player:getY() - math.floor(player:getY()) + offsetYDelta
    local zPos = getSurface(playerSquare)
    if playerSquare:HasStairs() then
        zPos = player:getZ() - math.floor(player:getZ())
    end

    local rot = player:getDirectionAngle() + rotationDelta

    while rot < 0 do rot = rot + 360 end
    while rot > 360 do rot = rot - 360 end

    if not forceReplace and xPos == lastXPos and yPos == lastYPos and zPos == lastZPos and rot == lastRot then return end
    lastXPos = xPos
    lastYPos = yPos
    lastZPos = zPos
    lastRot = rot

    if followerInventoryItem:getContainer() == player:getInventory() then
        local place = ISDropWorldItemAction:new(player, followerInventoryItem, playerSquare, xPos, yPos, zPos, rot, false)
        place.maxTime = 1
        place.stopOnWalk = false
        place.stopOnRun = false
        place.isValid = function () return true end
        ISTimedActionQueue.add(place)
        return
    end

    if not followerInventoryItem.getWorldItem then return end

    local worldItem = followerInventoryItem:getWorldItem()
    if not worldItem then
        Error(player)
        return
    end
    local square = worldItem:getSquare()
    if not square then
        Error(player)
        return
    end

    local md = followerInventoryItem:getModData()
    if md.WPF_Following_Player ~= player:getUsername() then
        Error(player)
        return
    end

    square:transmitRemoveItemFromSquare(followerInventoryItem:getWorldItem())
    square:removeWorldObject(followerInventoryItem:getWorldItem())
    followerInventoryItem:setWorldItem(nil)
    player:getInventory():AddItem(followerInventoryItem)

    local place = ISDropWorldItemAction:new(player, followerInventoryItem, playerSquare, xPos, yPos, zPos, rot, false)
    place.maxTime = 1
    place.stopOnWalk = false
    place.stopOnRun = false
    place.isValid = function () return true end
    ISTimedActionQueue.add(place)

    -- local mv = ISInventoryTransferAction:new(player, followerInventoryItem, followerInventoryItem:getContainer(), player:getInventory())
    -- mv.maxTime = 1
    -- mv.stopOnWalk = false
    -- mv.stopOnRun = false
    -- mv.isValid = function () return true end
    -- local place = ISDropWorldItemAction:new(player, followerInventoryItem, playerSquare, xPos, yPos, zPos, rot, false)
    -- place.maxTime = 1
    -- place.stopOnWalk = false
    -- place.stopOnRun = false
    -- place.isValid = function () return true end
    -- ISTimedActionQueue.add(mv)
    -- ISTimedActionQueue.add(place)
end

Events.OnFillInventoryObjectContextMenu.Add(OnFillInventoryObjectContextMenu)
Events.OnTick.Add(OnTick)