local playerData = {}
local session = false

local function AddReputation(perk, amount)
    if getPlayer():HasTrait("FastLearner") then
        amount = amount / 1.3
    end
    if getPlayer():HasTrait("SlowLearner") then
        amount = amount / 0.7
    end
    getPlayer():getXp():AddXP(perk, amount * 4)
end

SaveReputationClient = {}

SaveReputationClient.onDeath = function()
    session = true
    table.insert(playerData, math.ceil(getPlayer():getXp():getXP(Perks.RepDoc) * 100) / 100)
    table.insert(playerData, math.ceil(getPlayer():getXp():getXP(Perks.RepArmy) * 100) / 100)
    table.insert(playerData, math.ceil(getPlayer():getXp():getXP(Perks.RepCrafts) * 100) / 100)
    sendClientCommand(getPlayer(), "client", "saveReputation", { steamid = getCurrentUserSteamID(), playerData = playerData })
    Events.OnCreatePlayer.Add(SaveReputationClient.onRespawn)
    print("[SaveReputationSystem] Player is dead!")
end

SaveReputationClient.onRespawn = function()
    local tickCount = 0
    local function Respawn()
        if tickCount < 10 then
            tickCount = tickCount + 1
            return
        end
        AddReputation(Perks.RepDoc, playerData[1])
        AddReputation(Perks.RepArmy, playerData[2])
        AddReputation(Perks.RepCrafts, playerData[3])
        playerData = {}
        sendClientCommand(getPlayer(), "client", "dropReputation", { steamid = getCurrentUserSteamID() })
        Events.OnPlayerUpdate.Remove(Respawn)
    end
    Events.OnPlayerUpdate.Add(Respawn)
    Events.OnCreatePlayer.Remove(SaveReputationClient.onRespawn)
    print("[SaveReputationSystem] Player is successfully respawned!")
end

SaveReputationClient.onReceive = function(data)
    if not session then
        if #data.playerData == 3 then
            AddReputation(Perks.RepDoc, data.playerData[1])
            AddReputation(Perks.RepArmy, data.playerData[2])
            AddReputation(Perks.RepCrafts, data.playerData[3])
            sendClientCommand(getPlayer(), "client", "dropReputation", { steamid = getCurrentUserSteamID() })
            print("[SaveReputationSystem] Data received & dropped from server!")
        else
            print("[SaveReputationSystem] No data received!")
        end
    end
end

function SaveReputationClient:onServerCommand(command, data)
    if SaveReputationClient[command] then
        SaveReputationClient[command](data)
    end
end

if isClient() then
    Events.OnServerCommand.Add(SaveReputationClient.onServerCommand)
    Events.OnPlayerDeath.Add(SaveReputationClient.onDeath)
end