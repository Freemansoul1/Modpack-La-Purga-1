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

if isClient() then
    return
end

local GetTime = function()
    local now = os.time()
    local fecha = os.date("[%d|%m|%Y %H:%M:%S]", now)
    return fecha
end

local RaidsLog = "PurgaRaids_log.txt"

local function saveToLogFile(...)
    local txt = ""
    local args = {...}
    for i,v in ipairs(args) do
        txt = txt .. " " .. tostring(v)
    end
			   
    local WriteFile = getFileWriter(RaidsLog, true, true)
    WriteFile:write(txt .. " \n")
    WriteFile:close()
end

local function getExRaiders()
    return getGameTime():getModData().PurgaExRaiders
end

local function getExRaider(SFid)
    return getGameTime():getModData().PurgaExRaiders[SFid]
end

local function removeExRaider(playerName)
    getGameTime():getModData().PurgaExRaiders[playerName] = nil
end

local function addRaidedToExRaider(playerName, x, y, x2, y2)
    local raided = x .. "," .. y .. "/" .. x2 .. "," .. y2
    getGameTime():getModData().PurgaExRaiders[playerName].raided[raided] = {
        remainingTime = SandboxVars.PurgaRaids["ExRaidingTime"],
        startTime = getTimestamp(),
        x = x,
        y = y,
        x2 = x2,
        y2 = y2,
    }
end

local function removeRaidedFromExRaider(playerName, x, y, x2, y2)
    local exRaider = getExRaider(playerName)
    local raided = exRaider.raided
    if #raided < 1 then
        removeExRaider(playerName)
    end
end

local function createExRaider(playerName, x, y, x2, y2)
    local raider = getExRaider(playerName)
    if not raider then
        raider = {}
        raider.raided = {}
        getGameTime():getModData().PurgaExRaiders[playerName] = raider
    end
    addRaidedToExRaider(playerName, x, y, x2, y2)
end

local function getActiveRaiders()
    return getGameTime():getModData().PurgaActiveRaiders
end

local function getActiveRaider(playerName)
    local activeRaids = getGameTime():getModData().PurgaActiveRaids
    for SFid, raidData in pairs(activeRaids) do
        if raidData.raiders then
            for _, raiderName in ipairs(raidData.raiders) do
                if raiderName == playerName then
                    return true
                end
            end
        end
    end
    return false
end

local function createActiveRaider(playerName, x, y, x2, y2, thisowner)
    local SFid = x .. "," .. y .. "/" .. x2 .. "," .. y2
    getGameTime():getModData().PurgaActiveRaiders[playerName] = {}
    getGameTime():getModData().PurgaActiveRaiders[playerName].x = x
    getGameTime():getModData().PurgaActiveRaiders[playerName].y = y
    getGameTime():getModData().PurgaActiveRaiders[playerName].x2 = x2
    getGameTime():getModData().PurgaActiveRaiders[playerName].y2 = y2
    local PurgaActiveRaidsData = getGameTime():getModData().PurgaActiveRaids[SFid].raiders
    table.insert(PurgaActiveRaidsData, playerName)
end

local function removeActiveRaider(playerName)
    getGameTime():getModData().PurgaActiveRaiders[playerName] = nil
end

local function getActiveRaid(x, y, x2, y2, thisowner, safehouseKey)
    local raidsActivas = getGameTime():getModData().PurgaActiveRaids
    for SFid, activeRaidData in pairs(raidsActivas) do
        if activeRaidData.activa and activeRaidData.x == x and activeRaidData.y == y  and activeRaidData.x2 == x2 and activeRaidData.y2 == y2 then
            return true
        end
    end
    return false
end

local function createActiveRaid(playerName, x, y, x2, y2, thisowner)
    local SFid = x .. "," .. y .. "/" .. x2 .. "," .. y2
    getGameTime():getModData().PurgaActiveRaids[SFid] = {
        remainingTime = SandboxVars.PurgaRaids["RaidingTime"],
        startTime = getTimestamp(),
        x = x,
        y = y,
        x2 = x2,
        y2 = y2,
        count = 0,
        owner = thisowner,
        raiders = {},
        activa = true,
    }
    sendServerCommand("PurgaRaids", "RaidActivada", {playerName, SFid, thisowner})
    saveToLogFile(GetTime(), "RAID COMENZADO por:", playerName, "[Safehouse:", SFid, "][Owner:", thisowner, "]")
end

local function removeActiveRaid(x, y, x2, y2)
    local SFid = x .. "," .. y .. "/" .. x2 .. "," .. y2
    getGameTime():getModData().PurgaActiveRaids[SFid] = nil
end

local function getActiveRaids()
    return getGameTime():getModData().PurgaActiveRaids
end

local function increaseRaiderCount(x, y, x2, y2)
    local SFid = x .. "," .. y .. "/" .. x2 .. "," .. y2
    local current = getGameTime():getModData().PurgaActiveRaids[SFid].count
    getGameTime():getModData().PurgaActiveRaids[SFid].count = current + 1
end

local function getRaiderCount(x, y, x2, y2)
    local SFid = x .. "," .. y .. "/" .. x2 .. "," .. y2
    local raid = getGameTime():getModData().PurgaActiveRaids[SFid]
    if raid then
        return getGameTime():getModData().PurgaActiveRaids[SFid].count
    else
        return 0
    end
end

local function IsProtected(x, y, x2, y2)
    local protectedSF = getGameTime():getModData().PurgaRaidProtectedSafehouses
    for SFid, protected in pairs(protectedSF) do
        if protected.protected and protected.position[1] == x and protected.position[2] == y  and protected.position[3] == x2 and protected.position[4] == y2 then
            return true
        end
    end
    return false
end

local function InitModData()
    if SandboxVars.PurgaRaids.Enabled then
        getServerOptions():changeOption("SafehouseAllowTrepass", "true")
        getServerOptions():changeOption("SafehouseAllowLoot", "true")
        getServerOptions():init()
    else
        getServerOptions():changeOption("SafehouseAllowTrepass", "false")
        getServerOptions():changeOption("SafehouseAllowLoot", "false")
        getServerOptions():init()
    end

    local activeRaids = getGameTime():getModData().PurgaActiveRaids
    if activeRaids == nil then
        getGameTime():getModData().PurgaActiveRaids = {}
    end

    local exRaiders = getGameTime():getModData().PurgaExRaiders

    if exRaiders == nil then
        getGameTime():getModData().PurgaExRaiders = {}
    end

    local activeRaiders = getGameTime():getModData().PurgaActiveRaiders
    if activeRaiders == nil then
        getGameTime():getModData().PurgaActiveRaiders = {}
    end

    local protected = getGameTime():getModData().PurgaRaidProtectedSafehouses
    if protected == nil  then
        getGameTime():getModData().PurgaRaidProtectedSafehouses = {}
    end
end

local function ResetModData()
    getGameTime():getModData().PurgaActiveRaids = {}
    getGameTime():getModData().PurgaActiveRaiders = {}
    getGameTime():getModData().PurgaRaidProtectedSafehouses = {}
    getGameTime():getModData().PurgaExRaiders = {}													  
end

local function getSafeHouseRaiders(x, y, x2, y2)
    local p = 1
    local result = {}
    local _raiders = getActiveRaiders()

    for raider,data in pairs(_raiders) do
        if data then
            if data.x == x and data.y == y and data.x2 == x2 and data.y2 == y2 then
                result[p] = raider
                p = p + 1
            end
        end
    end
    return result
end

local function finishRaiders(player, x, y, x2, y2, SFowner)
    local SFid = x .. "," .. y .. "/" .. x2 .. "," .. y2
    local this_raiders = getSafeHouseRaiders(x, y, x2, y2)

    local _raiders = getActiveRaiders()

    for raiderName,raidData in pairs(_raiders) do
        if raidData.x == x and raidData.y == y and raidData.x2 == x2 and raidData.y2 == y2 then
            saveToLogFile(GetTime(), "JUGADOR FINALIZADO:", raiderName)

            createExRaider(raiderName, x, y, x2, y2)
            removeActiveRaider(raiderName)

            sendServerCommand("PurgaRaids", "RaidFinalizado", {raiderName, x, y, x2, y2, SFowner})
        end
    end
end

local function notifyRaiders5min(player, x, y, x2, y2, raiderName)
    local _raiders = getActiveRaiders()
    for raiderName,raidData in pairs(_raiders) do
        if raidData.x == x and raidData.y and raidData.x2 == x2 and raidData.y2 == y2 then
            sendServerCommand("PurgaRaids", "NotificacionRaiders5m", {raiderName})  
        end
    end
end

local function notifyRaiders3min(player, x, y, x2, y2, raiderName)
    local _raiders = getActiveRaiders()
    for raiderName,raidData in pairs(_raiders) do
        if raidData.x == x and raidData.y and raidData.x2 == x2 and raidData.y2 == y2 then
            sendServerCommand("PurgaRaids", "NotificacionRaiders3m", {raiderName})  
        end
    end	
end

local function notifyRaiders2min(player, x, y, x2, y2, raiderName)
    local _raiders = getActiveRaiders()
    for raiderName,raidData in pairs(_raiders) do
        if raidData.x == x and raidData.y and raidData.x2 == x2 and raidData.y2 == y2 then
            sendServerCommand("PurgaRaids", "NotificacionRaiders2m", {raiderName})  
        end
    end
end

local function notifyRaiders1min(player, x, y, x2, y2, raiderName)
    local _raiders = getActiveRaiders()
    for raiderName,raidData in pairs(_raiders) do
        if raidData.x == x and raidData.y and raidData.x2 == x2 and raidData.y2 == y2 then
            sendServerCommand("PurgaRaids", "NotificacionRaiders1m", {raiderName})  
        end
    end
end

local function sendActiveRaider()
    local _activeRaiders = getActiveRaiders()
    local _activeRaids = getActiveRaids()
    local _raidersInRaids = {}

    for coord,raid in pairs(_activeRaids) do
        _raidersInRaids[coord] = getSafeHouseRaiders(raid.x, raid.y)
    end

    for raiderName,raidData in pairs(_activeRaiders) do
        local otherRaiders = getSafeHouseRaiders(raidData.x, raidData.y)
        sendServerCommand("PurgaRaids", "RaiderActivo", {raidData.x, raidData.y, otherRaiders, raiderName})
    end
end

local function requestRaid(player, x, y, x2, y2, playerName, thisowner, sq)
    local safehouseKey = x .. "," .. y .. "/" .. x2 .. "," .. y2
    local safehouse = PurgaRaidsUtils.GetSafeHouse(x, y, x2, y2)

    local activeRaid = getActiveRaid(x, y, x2, y2, thisowner, safehouseKey)
    local activeRaider = getActiveRaider(playerName)
    local isProtected = IsProtected(x, y, x2, y2)

    local Exraider = getExRaider(playerName)
    if Exraider and not activeRaider then		  
        saveToLogFile(GetTime(), "EXRAIDER DENEGADO:", playerName, "(Aun no puede raidear)")
        sendServerCommand("PurgaRaids", "ProhibicionExRaider", {playerName, x, y, x2, y2, thisowner})
        return
    end

    local raiderCount = getRaiderCount(x, y, x2, y2)
    local maxRaiders = SandboxVars.PurgaRaids["MaxRaiders"]
    if raiderCount >= maxRaiders and not activeRaider then
        saveToLogFile(GetTime(), "RAIDER DENEGADO:", playerName, "(Maximo de raiders alcanzado)")
        sendServerCommand("PurgaRaids", "MaximoRaiders", {playerName, x, y, x2, y2, thisowner})
        return
    end

    if isProtected then
        saveToLogFile(GetTime(), "RAID rechazada. La casa esta protegida. [Safehouse:", safehouseKey, "][Owner:", thisowner, "]")
        sendServerCommand(player, "PurgaRaids", "SafehouseProtegida", {playerName, thisowner, x, y, x2, y2})
        sendServerCommand("PurgaRaids", "NotificarSafehouseProtegida", {playerName, x, y, x2, y2, thisowner})
        return
    else
        if not activeRaider then
            if not activeRaid then
                createActiveRaid(playerName, x, y, x2, y2, thisowner)
            else
                saveToLogFile(GetTime(), "Se incluye a:", playerName, "al raid. [Safehouse:", safehouseKey, "][Owner:", thisowner, "]")   
                sendServerCommand("PurgaRaids", "RaiderAceptado", {playerName})                       
            end

            createActiveRaider(playerName, x, y, x2, y2, thisowner)
            increaseRaiderCount(x, y, x2, y2)
            local contadorRaiders = getRaiderCount(x, y, x2, y2)
            saveToLogFile(GetTime(), "Raiders actuales:", contadorRaiders, "/ max", maxRaiders, "[Safehouse:", safehouseKey, "][Owner:", thisowner, "]")
            sendActiveRaider()
        end
    end
end

local function addProtection(x, y, x2, y2, SFowner)
    local SFid = x .. "," .. y .. "/" .. x2 .. "," .. y2  
    getGameTime():getModData().PurgaRaidProtectedSafehouses[SFid] = {
        remainingTime = SandboxVars.PurgaRaids["ProtectionTime"],
        startTime = getTimestamp(),
        position = {x, y, x2, y2},
        owner = SFowner,
        protected = true,
    }
end

local function checkRaidsTime(safehouse, player)
    local _raiders = getActiveRaiders()
    local _raids = getActiveRaids()
					 
    if #_raiders > 0 then
        saveToLogFile("Raids actuales:", #_raids)
    end

    for SFid, raidData in pairs(_raids) do
        if raidData then
            

            local raidStartTime = raidData.startTime or 0
            local elapsed = getTimestamp() - raidStartTime
            local raidDuration = raidData.remainingTime
            if elapsed >= raidDuration then
                local raiders = raidData.raiders
                local safehouseKey = raidData.x .. "," .. raidData.y .. "/" .. raidData.x2 .. "," .. raidData.y2

                saveToLogFile(GetTime(), "FINALIZA RAID [", safehouseKey, "][Owner:", raidData.owner, "]")
                finishRaiders(player, raidData.x, raidData.y, raidData.x2, raidData.y2, raidData.owner)
                removeActiveRaid(raidData.x, raidData.y, raidData.x2, raidData.y2)
                addProtection(raidData.x, raidData.y, raidData.x2, raidData.y2, raidData.owner)
            else
                local remainingTime = raidDuration - elapsed
                local raiders = raidData.raiders
                local minutos = math.floor(remainingTime / 60)
                local segundos = remainingTime % 60
                print(string.format("remainingTime: %02d:%02d", minutos, segundos))
                sendActiveRaider()
                if minutos == 5 then
                    notifyRaiders5min(player, raidData.x, raidData.y, raidData.x2, raidData.y2, raidData.raiders)
                elseif minutos == 3 then
                    notifyRaiders3min(player, raidData.x, raidData.y, raidData.x2, raidData.y2, raidData.raiders)
                elseif minutos == 2 then
                    notifyRaiders2min(player, raidData.x, raidData.y, raidData.x2, raidData.y2, raidData.raiders)
                elseif minutos == 1 then
                    notifyRaiders1min(player, raidData.x, raidData.y, raidData.x2, raidData.y2, raidData.raiders)
                end
            end
        end
    end
end

local function checkProtectionTime()
    local protectedSafeHouses = getGameTime():getModData().PurgaRaidProtectedSafehouses
    for SFid, protected in pairs(protectedSafeHouses) do
        local protectionStartTime = protected.startTime or 0
        local protectionelapsed = getTimestamp() - protectionStartTime
        local  _remtime = protected.remainingTime
																						   
        if protected then
            if protectionelapsed >= _remtime then
                saveToLogFile(GetTime(), "PROTECCION SAFEHOUSE FINALIZADA [", SFid, "][Owner:", protected.owner, "]")
                getGameTime():getModData().PurgaRaidProtectedSafehouses[SFid] = nil
                sendServerCommand("PurgaRaids", "SafehouseProtegida_FIN", {SFid})  
                return	
            end
            local remainingTime = _remtime - protectionelapsed
        end
    end
end

local function checkExRaiders()
    local exraiders = getExRaiders()
    for raiderName,data in pairs(exraiders) do
        if data then
            for key,raid in pairs(data.raided) do
                local exraiderStartTime = raid.startTime or 0
                local exraiderelapsed = getTimestamp() - exraiderStartTime
                local  _remtime = raid.remainingTime
                if exraiderelapsed >= _remtime then
                    removeRaidedFromExRaider(raiderName, raid.x, raid.y, raid.x2, raid.y2)
                    saveToLogFile(GetTime(), "EXRAIDER " .. raiderName .. " ya puede raidear.")
                    sendServerCommand("PurgaRaids", "ProhibicionExRaider_FIN", {raiderName, raid.x, raid.y, raid.x2, raid.y2})
                    return
                else																	
                end
                local remainingTime = _remtime - exraiderelapsed
            end
        end
    end
end

local function CheckProtectionPerMinute()
    if SandboxVars.PurgaRaids.Enabled then
        checkProtectionTime()
    end
end

local function CheckRaidersPerMinute()
    if SandboxVars.PurgaRaids.Enabled then
        checkRaidsTime()
    end
end

local function CheckExRaidersPerMinute()
    if SandboxVars.PurgaRaids.Enabled then
        checkExRaiders()
    end
end

local function CheckResetModData(player, x, y, x2, y2)
    if SandboxVars.PurgaRaids.ResetRaids then
        saveToLogFile(GetTime(), "DATA RAIDEOS RESETEADA!")
        sendServerCommand(player, "PurgaRaids", "ResetModData", {x, y, x2, y2})
        ResetModData()
        SandboxVars.PurgaRaids["ResetRaids"] = false
    end
end

SSRTimer.add_ms(CheckProtectionPerMinute, 3000, true) 
SSRTimer.add_ms(CheckRaidersPerMinute, 3000, true) 
SSRTimer.add_ms(CheckExRaidersPerMinute, 3000, true) 

Events.OnServerStarted.Add(InitModData)
Events.EveryOneMinute.Add(CheckResetModData)

function OnClientCommandPurgaRaid(module, command, player, params)
    if SandboxVars.PurgaRaids.Enabled then
        if module ~= "PurgaRaids" then
            return
        end
        if command == "RaidRequest" then
            requestRaid(player, params[1], params[2], params[3], params[4], params[5], params[6], params[7])
        end

        if command == "PveZone" then
            local playerX, playerY, playerName, owner = params[1], params[2], params[3], params[4]
            saveToLogFile(GetTime(), "Jugador en PVE: ", playerName, "[Safehouse: ", playerX, "-", playerY, "][Owner:", owner, "]")
        end
    end
end

Events.OnClientCommand.Add(OnClientCommandPurgaRaid)