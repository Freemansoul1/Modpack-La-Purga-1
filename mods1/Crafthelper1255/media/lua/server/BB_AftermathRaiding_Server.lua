-- ************************************************************************
-- **        ██████  ██████   █████  ██    ██ ███████ ███    ██          **
-- **        ██   ██ ██   ██ ██   ██ ██    ██ ██      ████   ██          **
-- **        ██████  ██████  ███████ ██    ██ █████   ██ ██  ██          **
-- **        ██   ██ ██   ██ ██   ██  ██  ██  ██      ██  ██ ██          **
-- **        ██████  ██   ██ ██   ██   ████   ███████ ██   ████          **
-- ************************************************************************
-- ** All rights reserved. This content is protected by © Copyright law. **
-- ************************************************************************

local function updateClients(command, args)
    local onlinePlayers = getOnlinePlayers()
    for i = 1, onlinePlayers:size() do
        local player = onlinePlayers:get(i - 1)
        if player then
            sendServerCommand(player, "crafthelper1255", command, args)
        end
    end
end

local function getTimeDiff(timeA, timeB)
    local differenceInSeconds = math.abs(timeA - timeB)
    local differenceInMinutes = differenceInSeconds / 60
    return differenceInMinutes
end

local function destroyObj(square, obj)
    sledgeDestroy(obj)
    square:transmitRemoveItemFromSquare(obj)
end

local function damageObj(obj, currHealth, square)
   if (getServerOptions():getBoolean("SafehouseAllowLoot") == true and getServerOptions():getBoolean("SafehouseAllowTrepass") == true) then
        obj:setHealth(currHealth - SandboxVars.crafthelper1255.RaidAxeDamage)
        if obj:getHealth() < 0 then
            destroyObj(square, obj)
        end
    end
end

local function damageObj1(obj, currHealth, square)
    obj:setHealth(currHealth - SandboxVars.crafthelper1255.C4TileDamage)
    if obj:getHealth() < 0 then
        destroyObj(square, obj)
    end
end

local function handleWrongfulDamage(obj, weaponDmg, currHealth, maxHealth)
    if (getServerOptions():getBoolean("SafehouseAllowLoot") == true and getServerOptions():getBoolean("SafehouseAllowTrepass") == true) then
        if obj:getModData().lastTs then
            obj:getModData().lastTs = nil
            obj:getModData().lastHP = nil
        end

        if currHealth < maxHealth then
            obj:setHealth(maxHealth)
        end
    end
end

local function repairWindow(obj, coordinates)
    obj:setSmashed(false)
    local args = { X = coordinates.X, Y = coordinates.Y }
    updateClients("RepairWindow", args)
end

local function damageVehicle(vehicle, damage)
    if not vehicle:getModData().raidHealth then
        vehicle:getModData().raidHealth = SandboxVars.crafthelper1255.VehicleHealth
    end

    vehicle:getModData().raidHealth = vehicle:getModData().raidHealth - damage

    local numParts = vehicle:getPartCount()
    local threshold = math.floor(SandboxVars.crafthelper1255.VehicleHealth / numParts)
    local totalDamage = SandboxVars.crafthelper1255.VehicleHealth - vehicle:getModData().raidHealth

    while totalDamage > 0 do
        local destroyedParts = 0
        for i = 0, numParts - 1 do
            local part = vehicle:getPartByIndex(i)
            local condition = part:getCondition()
            if condition and condition > 0 then
                if not part:getModData().droppedRaidLoot then
                    local square = vehicle:getSquare()
                    local partItem = part:getInventoryItem()

                    if partItem then
                        square:AddWorldInventoryItem(partItem, 0.0, 0.0, 0.0)
                    end

                    local partContainer = part:getItemContainer()
                    if partContainer then
                        local items = partContainer:getItems()
                        for index = 1, items:size() do
                            local item = items:get(index - 1)
                            square:AddWorldInventoryItem(item, 0.0, 0.0, 0.0)
                        end
                    end

                    part:setInventoryItem(nil)
                    part:getModData().droppedRaidLoot = true
                    vehicle:transmitPartItem(part)
                end

                totalDamage = totalDamage - threshold
            else
                totalDamage = totalDamage - threshold
            end

            if totalDamage <= 0 then
                break
            end
        end

        if destroyedParts == numParts then
            break
        end
    end

    if vehicle:getModData().raidHealth <= 0 then
        local maxPassengers = vehicle:getMaxPassengers()
        for j=1, maxPassengers do
            local passenger = vehicle:getCharacter(j - 1)
            if passenger then
                sendServerCommand(passenger, "crafthelper1255", "ExitVehicle", {})
            end
        end

        vehicle:permanentlyRemove()
    end
end

local function destroyLandClaimSafehouse(safehouse)
    local playerObj = getPlayerFromUsername(safehouse:getOwner())
    safehouse:removeSafeHouse(playerObj)
end

local function tryDamageThump(sqCoordinates, playerZ, isRaidTool, weaponDmg)
    for _,coordinates in ipairs(sqCoordinates) do
        local square = getCell():getGridSquare(coordinates.X, coordinates.Y, playerZ)
        if square then
            local objs = square:getObjects()
            local size = objs:size()
            for i = size, 1, -1 do
                local obj = objs:get(i-1)
                local isInSafehouse = BB_AFTMRaid_Utils.IsInSafehouse(square, true)
                if obj and instanceof(obj, "IsoObject") then

                    if instanceof(obj, "IsoThumpable") or instanceof(obj, "IsoDoor") and (getServerOptions():getBoolean("SafehouseAllowLoot") == true and getServerOptions():getBoolean("SafehouseAllowTrepass") == true) then
                        local currHealth = obj:getHealth()
                        local maxHealth = obj:getMaxHealth()

                        if currHealth and maxHealth then
                            if not isRaidTool then
                                handleWrongfulDamage(obj, weaponDmg, currHealth, maxHealth)
                            elseif isInSafehouse then
                                local objName = obj:getName()
                                if instanceof(obj, "IsoDoor") or (objName and string.find(objName:lower(), "wood") and getServerOptions():getBoolean("SafehouseAllowLoot") == true and getServerOptions():getBoolean("SafehouseAllowTrepass") == true) or (objName and string.find(objName:lower(), "stone") and getServerOptions():getBoolean("SafehouseAllowLoot") == true and getServerOptions():getBoolean("SafehouseAllowTrepass") == true) or (objName and string.find(objName:lower(), "metal") and getServerOptions():getBoolean("SafehouseAllowLoot") == true and getServerOptions():getBoolean("SafehouseAllowTrepass") == true) or (objName and string.find(objName:lower(), "log") and getServerOptions():getBoolean("SafehouseAllowLoot") == true and getServerOptions():getBoolean("SafehouseAllowTrepass") == true) then
                                    damageObj(obj, currHealth, square)
                                else
                                    handleWrongfulDamage(obj, weaponDmg, currHealth, maxHealth)
                                end
                            else
                                handleWrongfulDamage(obj, weaponDmg, currHealth, maxHealth)
                            end
                        end
                    elseif isRaidTool then
                        if isInSafehouse then
                            local props = obj:getProperties()
                            if props and (props:Is(IsoFlagType.solid) or props:Is(IsoFlagType.solidtrans)) then
                                local objContainer = obj:getContainer()
                                if objContainer then
                                    local items = objContainer:getItems()
                                    for index = 1, items:size() do
                                        local item = items:get(index - 1)
                                        square:AddWorldInventoryItem(item, 0.0, 0.0, 0.0)
                                    end
                                end

                                destroyObj(square, obj)
                            end
                        elseif instanceof(obj, "IsoWindow") then
                            repairWindow(obj, coordinates)
                        end
                    else
                        if instanceof(obj, "IsoWindow") then
                            repairWindow(obj, coordinates)
                        end
                    end
                end

                if isInSafehouse and isRaidTool then
                    local vehicle = square:getVehicleContainer()
                    if vehicle then
                        damageVehicle(vehicle, SandboxVars.crafthelper1255.RaidAxeDamage)
                    end

                    local sprite =  obj:getSprite()
                    if sprite then
                        local spriteName = sprite:getName()
                        if spriteName == "fears_storage_tiles_8" then
                            local safehouse = SafeHouse.getSafeHouse(square)
                            if safehouse then
                                destroyLandClaimSafehouse(safehouse)
                                destroyObj(square, obj)
                            end
                        end
                    end
                end
            end
        end
    end
end

local function tryExplodeThump(sqCoordinates, playerZ)
    for _,coordinates in ipairs(sqCoordinates) do

        local square = getCell():getGridSquare(coordinates.X, coordinates.Y, playerZ)
        if square then
            local objs = square:getObjects()
            local size = objs:size()
            local hasAsh = false
            local exploded = false
            for i = size, 1, -1 do
                local obj = objs:get(i-1)
                local isInSafehouse = BB_AFTMRaid_Utils.IsInSafehouse(square)


                if obj and (instanceof(obj, "IsoObject")
                or instanceof(obj, "IsoThumpable")
                or instanceof(obj, "IsoDoor")) then

                    local isInvalid = false
                    if not (instanceof(obj, "IsoThumpable") or instanceof(obj, "IsoDoor")) then
                        local sqFloor = square:getFloor()
                        if sqFloor == obj then isInvalid = true end

                        local props = obj:getProperties()
                        if props and (props:Is("WallN") or props:Is("WallW") or props:Is("DoorWallN") or props:Is("DoorWallW")) then
                            isInvalid = true
                        end

                        local sprite =  obj:getSprite()
                        if sprite and not isInvalid then
                            local spriteType = sprite:getType()
                            if spriteType then
                                spriteType = spriteType:toString():lower()
                                if string.find(spriteType, "wall") then
                                    isInvalid = true
                                end
                            end

                            local spriteName = sprite:getName()
                            if spriteName and not isInvalid then
                                spriteName = spriteName:lower()
                                if string.find(spriteName, "wall") then
                                    isInvalid = true
                                end
                            end
                        end
                    end

                    if not isInSafehouse then
                        isInvalid = true
                    elseif not isInvalid then
                        local objContainer = obj:getContainer()
                        if objContainer then
                            local items = objContainer:getItems()
                            for index = 1, items:size() do
                                local item = items:get(index - 1)
                                square:AddWorldInventoryItem(item, 0.0, 0.0, 0.0)
                            end
                        end
                    end

                    if not isInvalid then
                        destroyObj(square, obj)
                        exploded = true
                    end
                end

                if isInSafehouse then
                    local vehicle = square:getVehicleContainer()
                    if vehicle then
                        damageVehicle(vehicle, 999)
                    end

                    local sprite =  obj:getSprite()
                    if sprite then
                        local spriteName = sprite:getName()
                        if spriteName then
                            local objName = obj:getName()
                            if instanceof(obj, "IsoDoor") or (objName and string.find(objName:lower(), "wood")) or (objName and string.find(objName:lower(), "stone")) or (objName and string.find(objName:lower(), "metal")) then
                                destroyObj(square, obj)
                                exploded = true
                            end

                            if spriteName == "fears_storage_tiles_8" then
                                local safehouse = SafeHouse.getSafeHouse(square)
                                if safehouse then
                                    destroyLandClaimSafehouse(safehouse)
                                    exploded = true
                                end
                            end

                            if spriteName == "floors_burnt_01_2" then
                                hasAsh = true
                            end
                        end
                    end
                end

                local sqPlayer = square:getPlayer()
                if sqPlayer then
                    sendServerCommand(sqPlayer, "crafthelper1255", "TakeDamage", { amount = SandboxVars.crafthelper1255.C4PlayerDamage })
                end
            end

            if exploded and not hasAsh then
                local ashChance = ZombRand(0, 100)
                if ashChance <= 60 then
                    local ash = IsoObject.new(square, "floors_burnt_01_2", "", false)
                    square:AddTileObject(ash)
                    ash:transmitCompleteItemToClients()
                    hasAsh = true
                end
            end
        end
    end
end

local onClientCommand = function(module, command, playerObj, args)
    if module ~= "crafthelper1255" then return end

    if command == "TryDamageThump" then
        tryDamageThump(args.squares, args.playerZ, args.isRaidTool, args.weaponDmg)
    end

    if command == "TryExplodeThump" then
        tryExplodeThump(args.squares, args.playerZ)
    end
end

Events.OnClientCommand.Add(onClientCommand)