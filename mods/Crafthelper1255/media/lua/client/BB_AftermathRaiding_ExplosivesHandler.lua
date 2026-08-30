-- ************************************************************************
-- **        ██████  ██████   █████  ██    ██ ███████ ███    ██          **
-- **        ██   ██ ██   ██ ██   ██ ██    ██ ██      ████   ██          **
-- **        ██████  ██████  ███████ ██    ██ █████   ██ ██  ██          **
-- **        ██   ██ ██   ██ ██   ██  ██  ██  ██      ██  ██ ██          **
-- **        ██████  ██   ██ ██   ██   ████   ███████ ██   ████          **
-- ************************************************************************
-- ** All rights reserved. This content is protected by © Copyright law. **
-- ************************************************************************

local function handleWeaponActivation(weapons)
    for _, weapon in ipairs(weapons) do
        if weapon:IsWeapon() and not BB_AFTMRaid_Utils.IsRaidTool(weapon:getType()) then
            if weapon:getExplosionPower() ~= 0 or weapon:getFirePower() ~= 0 then
                if weapon:isEquipped() then
                    ISTimedActionQueue.add(ISUnequipAction:new(getPlayer(), weapon, 0))
                end
            end
        end
    end
end

local function checkIfNearSafehouse()
    local safehouseNearby = nil
    local safezoneRadius = SandboxVars.crafthelper1255.SafezoneRadius

    local playerObj = getPlayer()
    local playerSq = playerObj:getSquare(); if not playerSq then return end
    local x,y,z = playerSq:getX(), playerSq:getY(), playerSq:getZ()
    local nearbySafehouse = nil

    for dx = -safezoneRadius, safezoneRadius do
        for dy = -safezoneRadius, safezoneRadius do
            local coordX = x + dx
            local coordY = y + dy
            local sq = getCell():getGridSquare(coordX, coordY, z)
            if sq then
                safehouseNearby = SafeHouse.getSafeHouse(sq)
                if safehouseNearby then
                    local distance = BB_AFTMRaid_Utils.DistanceBetween(playerSq, sq) or 0
                    if distance <= safezoneRadius then
                        nearbySafehouse = safehouseNearby
                        break
                    end
                end
            end
        end
    end

    local weapons = {}
    local primaryWpn = playerObj:getPrimaryHandItem(); if primaryWpn then table.insert(weapons, primaryWpn) end
    local secondaryWpn = playerObj:getSecondaryHandItem(); if secondaryWpn then table.insert(weapons, secondaryWpn) end

    if nearbySafehouse and #weapons > 0 then
        handleWeaponActivation(weapons)
    end
end

local tickCounter = 0

local function onTick()
    tickCounter = tickCounter + 1
    if tickCounter >= SandboxVars.crafthelper1255.ExplosivesHandlerFrequency then
        checkIfNearSafehouse()
        tickCounter = 0
    end
end

Events.OnTick.Add(onTick)