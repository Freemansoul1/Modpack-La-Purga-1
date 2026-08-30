-- ************************************************************************
-- **        ██████  ██████   █████  ██    ██ ███████ ███    ██          **
-- **        ██   ██ ██   ██ ██   ██ ██    ██ ██      ████   ██          **
-- **        ██████  ██████  ███████ ██    ██ █████   ██ ██  ██          **
-- **        ██   ██ ██   ██ ██   ██  ██  ██  ██      ██  ██ ██          **
-- **        ██████  ██   ██ ██   ██   ████   ███████ ██   ████          **
-- ************************************************************************
-- ** All rights reserved. This content is protected by © Copyright law. **
-- ************************************************************************

local function onPlayerAttackFinished(playerObj, weapon)
    local allowLoot = getServerOptions():getBoolean("SafehouseAllowLoot")
    local allowTrepass = getServerOptions():getBoolean("SafehouseAllowTrepass")

	if not playerObj or playerObj:isDead() then return end
    if not weapon then return end

    local isRaidTool = BB_AFTMRaid_Utils.IsRaidTool(weapon:getType())
    local safehouse = SafeHouse.getSafeHouse(playerObj:getSquare())
    if not (safehouse or isRaidTool) then return end

    local wpnRange = weapon:getMaxRange(playerObj); if wpnRange < 0 then wpnRange = 1 end
    local wpnDmg = weapon:getMaxDamage(); if wpnDmg < 0 then wpnDmg = 1 end
    local squares = BB_AFTMRaid_Utils.FetchSquaresInLine(playerObj, wpnRange)

    local playerZ = playerObj:getZ()
    local squareCoordinates = {}

    for _, square in ipairs(squares) do
        local squareX = square:getX()
        local squareY = square:getY()
        table.insert(squareCoordinates, { X = squareX, Y = squareY })
    end

    local args = {
        isRaidTool = isRaidTool,
        squares = squareCoordinates,
        playerZ = playerZ,
        weaponDmg = wpnDmg,
    }
    if allowLoot == true and allowTrepass == true and not isNonPvpZone then
        sendClientCommand(playerObj, "crafthelper1255", "TryDamageThump", args)
    end
end

Events.OnPlayerAttackFinished.Add(onPlayerAttackFinished)

local function tryFixWindow(coordinates)
    local playerObj = getPlayer(); if not playerObj then return end
    local playerZ = playerObj:getZ(); if not playerZ then return end
    local square = getCell():getGridSquare(coordinates.X, coordinates.Y, playerZ)
    if square then
        local objs = square:getObjects()
        local size = objs:size()
        for i = size, 1, -1 do
            local obj = objs:get(i-1)
            if instanceof(obj, "IsoWindow") and obj:isSmashed() then
                obj:setSmashed(false)
            end
        end
    end
end

local function onServerCommand(module, command, args)
    if module ~= "crafthelper1255" then return end

    if command == "RepairWindow" then
        tryFixWindow(args)
    end

    if command == "ExitVehicle" then
        getPlayerVehicleDashboard(getPlayer():getPlayerNum()):setVehicle(nil)
    end

    if command == "TakeDamage" then
        local bodyDamage = getPlayer():getBodyDamage()
        bodyDamage:ReduceGeneralHealth(bodyDamage:getOverallBodyHealth() - (args.amount / 10))
    end
end

Events.OnServerCommand.Add(onServerCommand)