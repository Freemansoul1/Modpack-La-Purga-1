-- ************************************************************************
-- **        ██████  ██████   █████  ██    ██ ███████ ███    ██          **
-- **        ██   ██ ██   ██ ██   ██ ██    ██ ██      ████   ██          **
-- **        ██████  ██████  ███████ ██    ██ █████   ██ ██  ██          **
-- **        ██   ██ ██   ██ ██   ██  ██  ██  ██      ██  ██ ██          **
-- **        ██████  ██   ██ ██   ██   ████   ███████ ██   ████          **
-- ************************************************************************
-- ** All rights reserved. This content is protected by © Copyright law. **
-- ************************************************************************

BB_AFTMRaid_Utils = {}

BB_AFTMRaid_Utils.IsRaidTool = function(weaponType)
    if weaponType == "RaidAxe" or weaponType == "RaidC4" and getServerOptions():getBoolean("SafehouseAllowLoot") and getServerOptions():getBoolean("SafehouseAllowTrepass") then
        return true
    else
        return false
    end
end

BB_AFTMRaid_Utils.FetchSquaresInLine = function(playerObj, range)

    local px = playerObj:getX()
    local py = playerObj:getY()
    local pz = playerObj:getZ()
    local dir = playerObj:getDir()
    local squares = {}

    local square = getCell():getGridSquare(px, py, pz)
    if square then table.insert(squares, square) end

    for i = 1, range do

        if (dir == IsoDirections.N) then        square = getCell():getGridSquare(px, py - i, pz)
        elseif (dir == IsoDirections.NE) then   square = getCell():getGridSquare(px + i, py - i, pz)
        elseif (dir == IsoDirections.E) then    square = getCell():getGridSquare(px + i, py, pz)
        elseif (dir == IsoDirections.SE) then   square = getCell():getGridSquare(px + i, py + i, pz)
        elseif (dir == IsoDirections.S) then    square = getCell():getGridSquare(px, py + i, pz)
        elseif (dir == IsoDirections.SW) then   square = getCell():getGridSquare(px - i, py + i, pz)
        elseif (dir == IsoDirections.W) then    square = getCell():getGridSquare(px - i, py, pz)
        elseif (dir == IsoDirections.NW) then   square = getCell():getGridSquare(px - i, py - i, pz)
        end

        if square then
            table.insert(squares, square)
        end
    end

    return squares
end

BB_AFTMRaid_Utils.DistanceBetween = function(firstObj, secondObj)
    local x1, y1 = firstObj:getX(), firstObj:getY()
    local x2, y2 = secondObj:getX(), secondObj:getY()

    local dx = x1 - x2
    local dy = y1 - y2

    local distance = math.sqrt(dx * dx + dy * dy)
    return distance
end

BB_AFTMRaid_Utils.DelayFunction = function(func, delay)
    delay = delay or 1
    local ticks = 0
    local canceled = false
    local tickRate = 60
    local lastTickTime = os.time()

    local function onTick()
        local currentTime = os.time()
        local deltaTime = currentTime - lastTickTime
        lastTickTime = currentTime

        ticks = ticks + deltaTime * tickRate

        if not canceled and ticks >= delay then
            ticks = 0
            Events.OnTick.Remove(onTick)
            if not canceled then func() end
        end
    end

    Events.OnTick.Add(onTick)

    return function()
        canceled = true
    end
end

BB_AFTMRaid_Utils.IsInSafehouse = function(square, ignoreRegular)
    local safehouse = SafeHouse.getSafeHouse(square)

    if safehouse then
        local owner = safehouse:getOwner()
        if not owner then return false end

        local whitelist = SandboxVars.crafthelper1255.Whitelist or ""
        local usernames = {}
        for username in whitelist:gmatch("[^,]+") do
            table.insert(usernames, username:lower())
        end

        owner = owner:lower()
        for _, username in ipairs(usernames) do
            if owner == username then
                return false
            end
        end
    elseif not ignoreRegular then
        return false
    end

    return true
end