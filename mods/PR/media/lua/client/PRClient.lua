-- ╔════════════════════════════════════════════════════════════════════════════╗ --
-- ║                                                                            ║ --
-- ║                        ██████╗  ███████╗ ██╗      ██╗                      ║ --
-- ║                        ██╔══██╗ ██╔════╝ ██║      ██║                      ║ --
-- ║                        ██║  ██║ █████╗   ██║      ██║                      ║ --
-- ║                        ██║  ██║ ██╔══╝   ██║      ██║                      ║ --
-- ║                        ██████╔╝ ███████╗ ███████╗ ██║                      ║ --
-- ║                        ╚═════╝  ╚══════╝ ╚══════╝ ╚═╝                      ║ --
-- ║    ═══════════════════════════════════════════════════════════════════     ║ --
-- ║     All rights reserved. This content is protected by © Copyright law.     ║ --
-- ║      Reproduction, distribution, or modification without the express       ║ --
-- ║            authorization of the author is strictly prohibited.             ║ --
-- ╚════════════════════════════════════════════════════════════════════════════╝ --

require "SSRTimer"

if not isClient() then
    return
end

---@type SafeHouse

function OnServerCommandPurgaRaid(module, command, params)
    if SandboxVars.PurgaRaids.Enabled then

        if module ~= "PurgaRaids" then
            return
        end

        if command == "RaidActivada" then
            local playerName, SFid, thisowner = params[1], params[2], params[3]
            local player = GetPlayerByUsername(playerName)
            if player then
                local sq = player:getCurrentSquare()
                if sq == nil then
                    return false
                end
                local safehouses = SafeHouse.getSafehouseList();
                for i=0,safehouses:size()-1 do
                    local safehouse = safehouses:get(i);
                    local owner = safehouse:getOwner()
                    if safehouse and owner == thisowner then
                        player:setHaloNote(getText("IGUI_RAID_RaidActivada"), 0, 255, 213, 200);
                    end
                end
            end
        end

        if command == "RaiderAceptado" then
            local playerName = params[1]
            local player = GetPlayerByUsername(playerName)
            if player then
                player:setHaloNote(getText("IGUI_RAID_RaiderIncluido"), 0, 255, 140, 200);
            end
        end
        
        if command == "NotificarSafehouseProtegida" then 
            local playerName, x, y, x2, y2, thisowner = params[1], params[2], params[3], params[4], params[5], params[6]
            local player = GetPlayerByUsername(playerName)
            if player then
                local sq = player:getCurrentSquare()
                if sq == nil then
                    return false
                end
                local safehouses = SafeHouse.getSafehouseList();
                for i=0,safehouses:size()-1 do
                    local safehouse = safehouses:get(i);
                    local owner = safehouse:getOwner()
                    if safehouse and owner == thisowner then
                        player:setHaloNote(getText("IGUI_RAID_SfProtegida"), 255, 0, 0, 300);
                        SafeKickOut(x, y, x2, y2, thisowner)
                    end
                end
            end
        end

        if command == "RaiderActivo" then
            local x, y, otherRaiders, playerName = params[1], params[2], params[3], params[4]
        end

        if command == "RaidFinalizado" then
            local playerName, x, y, x2, y2, thisowner = params[1], params[2], params[3], params[4], params[5], params[6]
            local player = GetPlayerByUsername(playerName)
            if player then
                SafeKickOut(playerName, x, y, x2, y2, thisowner)
                player:setHaloNote(getText("IGUI_RAID_RaidCompletada"), 9, 255, 0, 200);
            end
        end

        if command == "RaiderFinalizado" then
            local playerName, x, y = params[1], params[2], params[3]
        end

        if command == "SafehouseProtegida" then 
            local playerName, thisowner, x, y, x2, y2 = params[1],  params[2], params[3], params[4], params[5], params[6]
            local SFid = x .. "," .. y .. "/" .. x2 .. "," .. y2
            SafeKickOut(playerName, x, y, x2, y2, thisowner)
        end

        if command == "SafehouseProtegida_FIN" then 
            local SFid = params[1]
        end

        if command == "ProhibicionExRaider" then
            local playerName, x, y, x2, y2 = params[1], params[2], params[3], params[4], params[5]
            local player = GetPlayerByUsername(playerName)
            if player then
                player:setHaloNote(getText("IGUI_RAID_CooldownRaider"), 255, 0, 0, 300);
                SafeKickOutExraider(playerName)
            end
        end

        if command == "MaximoRaiders" then
            local playerName, x, y, x2, y2 = params[1], params[2], params[3], params[4], params[5]
            local player = GetPlayerByUsername(playerName)
            if player then
                player:setHaloNote(getText("IGUI_RAID_MaxRaiders"), 255, 0, 0, 300);
                SafeKickOutExraider(playerName)
            end
        end

        if command == "ProhibicionExRaider_FIN" then
            local playerName, x, y = params[1], params[2], params[3]
            local player = GetPlayerByUsername(playerName)
            if player then
                player:setHaloNote(getText("IGUI_RAID_CooldownRaiderTerminado"), 9, 255, 0, 300);
            end
        end

        if command == "RechazoRaiderActivo" then
            local playerName, x, y = params[1], params[2], params[3]
            cannotraidActive()
        end

        if command == "ResetModData" then 
            PurgaRaidClientState = {}
        end        

        if command == "NotificacionRaiders5m" then
            local playerName = params[1]
            local player = GetPlayerByUsername(playerName)
            if player then
                player:setHaloNote(getText("IGUI_RAID_5min"), 255, 179, 0, 200);
            end
        end
        if command == "NotificacionRaiders3m" then
            local playerName = params[1]
            local player = GetPlayerByUsername(playerName)
            if player then
                player:setHaloNote(getText("IGUI_RAID_3min"), 255, 115, 0, 200);
            end
        end
        if command == "NotificacionRaiders2m" then
            local playerName = params[1]
            local player = GetPlayerByUsername(playerName)
            if player then
                player:setHaloNote(getText("IGUI_RAID_2min"), 255, 64, 0, 200);
            end
        end
        if command == "NotificacionRaiders1m" then
            local playerName = params[1]
            local player = GetPlayerByUsername(playerName)
            if player then
                player:setHaloNote(getText("IGUI_RAID_1min"), 255, 0, 0, 200);
            end
        end
    end
end


function GetPlayerByUsername(playerName)
    local onlinePlayers = getOnlinePlayers()
    for p=0, onlinePlayers:size() - 1, 1 do
        local _player = onlinePlayers:get(p)
        if _player:getUsername() == playerName then
            return _player
        end
    end
end

function SafeKickOutExraider(playerName)
    local playerObj = GetPlayerByUsername(playerName)

    if playerObj == nil then
        return nil;
    else
    end

    local sq = playerObj:getCurrentSquare()
    if sq == nil then
        return false
    end

    local safehouses = SafeHouse.getSafehouseList();
    for i=0,safehouses:size()-1 do
        local safehouse = safehouses:get(i);
        local owner = safehouse:getOwner()
        if safehouse then
            local x, y = sq:getX(), sq:getY()
            local x1,y1,x2,y2 = safehouse:getX(), safehouse:getY(), safehouse:getX2(), safehouse:getY2()

            if x >= x1 and x <= x2 and y >= y1 and y <= y2 then
                playerObj:setX(x1 - 2);
                playerObj:setY(y1 - 2);
                playerObj:setZ(0);
            end
        end
    end
end

function SafeKickOut(playerName, raidx, raidy, raidx2, raidy2, thisowner)
    local playerObj = GetPlayerByUsername(playerName)

    if playerObj == nil then
        return nil;
    else
    end

    local sq = playerObj:getCurrentSquare()
    if sq == nil then
        return false
    end

    local safehouses = SafeHouse.getSafehouseList();
    for i=0,safehouses:size()-1 do
        local safehouse = safehouses:get(i);
        local owner = safehouse:getOwner()
        if safehouse and owner == thisowner then
            local x, y = sq:getX(), sq:getY()
            local x1,y1,x2,y2 = safehouse:getX(), safehouse:getY(), safehouse:getX2(), safehouse:getY2()

            if x >= x1 and x <= x2 and y >= y1 and y <= y2 then
                playerObj:setX(x1 - 2);
                playerObj:setY(y1 - 2);
                playerObj:setZ(0);
            end
        end
    end
end


function CheckIfPlayerInsideSafe1(safehouse)
    
    local playerInside = false
    local playerObj = getSpecificPlayer(0)
    if playerObj == nil then
        return nil;
    else end

    local playersq = playerObj:getCurrentSquare()
    if playersq == nil then
        return false
    end

    if isAdmin() then return end
    
    local isSafeHouse = SafeHouse.isSafeHouse(playersq, nil, true)
    if isSafeHouse then
        local safehouse = SafeHouse.getSafeHouse(playersq)
        local x,y,x2,y2 = safehouse:getX(), safehouse:getY(), safehouse:getX2(), safehouse:getY2()
        local safehouseID = x .. "," .. y .. "/" .. x2 .. "," .. y2
        playerInside = true
        if playerInside then
            local owner = isSafeHouse:getOwner()
            local members = isSafeHouse:getPlayers()
            for i = 0, members:size() - 1 do
                local miembros = members:get(i)
            end
            local playerName = playerObj:getUsername()

            if owner ~= playerName and not members:contains(playerName) then
                local playerX = playersq:getX()
                local playerY = playersq:getY()
                local playerZ = playersq:getZ()

                local pvezone = ((playerX <= 13444 and playerX >= 12902) and (playerY <= 7451 and playerY >= 6937))
                if pvezone then
                    playerObj:setX(13052);
                    playerObj:setY(7047);
                    playerObj:setZ(0);
                    playerObj:setHaloNote(getText("IGUI_RAID_Pve"), 255, 0, 0, 200);
                    sendClientCommand("PurgaRaids", "PveZone", { playerX, playerY, playerName, owner})
                    return
                else
                    sendClientCommand("PurgaRaids", "RaidRequest", {x, y, x2, y2, playerName, owner, sq = { sqX = playerX, sqY = playerY, sqZ = playerZ }})
                end
            else
            end
        end
    else
        return false
    end
end

local function ActivarEvento()
    if SandboxVars.PurgaRaids.Enabled == true then
        SSRTimer.add_ms(CheckIfPlayerInsideSafe1, 3000, true)
    end
end

Events.OnConnected.Add(ActivarEvento)
Events.OnServerCommand.Add(OnServerCommandPurgaRaid)