-- ************************************************************************
-- **        ██████  ██████   █████  ██    ██ ███████ ███    ██          **
-- **        ██   ██ ██   ██ ██   ██ ██    ██ ██      ████   ██          **
-- **        ██████  ██████  ███████ ██    ██ █████   ██ ██  ██          **
-- **        ██   ██ ██   ██ ██   ██  ██  ██  ██      ██  ██ ██          **
-- **        ██████  ██   ██ ██   ██   ████   ███████ ██   ████          **
-- ************************************************************************
-- ** All rights reserved. This content is protected by © Copyright law. **
-- ************************************************************************

RespawnableSBags = { }
local serverCachedList = { }

local function onLoadCharacter()
	if not getWorld():getGameMode() == "Multiplayer" then return end

    local playerObj = getPlayer()

	BB_RSBags_Utils.DelayFunction(function()
        sendClientCommand(playerObj, "RespawnableSBags", "UpdatePlayerCache", { })
	end, 25)

    if playerObj:getHoursSurvived() > 1 then return end
    if playerObj:getModData().respawnedInSBag then return end

	BB_RSBags_Utils.DelayFunction(function()
        if not RespawnableSBags then return end
        if not RespawnableSBags.respawnPoint or RespawnableSBags.respawnPoint == -1 then return end
        if RespawnableSBags.cooldown > 0 then return end

        BB_RSBags_Utils.TeleportTo(playerObj, RespawnableSBags.respawnX, RespawnableSBags.respawnY, RespawnableSBags.respawnZ)
        playerObj:getModData().respawnedInSBag = true

        RespawnableSBags.cooldown = SandboxVars.RespawnableSBags.Cooldown
        RespawnableSBags.respawnPoint = -1
        RespawnableSBags.respawnX, RespawnableSBags.respawnY, RespawnableSBags.respawnZ = 0, 0, 0

	end, SandboxVars.RespawnableSBags.TpDelay)
end

Events.OnCreatePlayer.Add(onLoadCharacter)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

RespawnableSBags_Client = { }

RespawnableSBags_Client.AddRespawnPoint = function(respawnX, respawnY, respawnZ)
    if not RespawnableSBags.respawnPoints then
        RespawnableSBags.respawnPoints = {}
    end

    local newRespawnPoint = {
        x = respawnX,
        y = respawnY,
        z = respawnZ,
    }

    table.insert(RespawnableSBags.respawnPoints, newRespawnPoint)

    local maxSlots = SandboxVars.RespawnableSBags.MaxSlots
    while #RespawnableSBags.respawnPoints > maxSlots do
        table.remove(RespawnableSBags.respawnPoints, 1)
    end
end

RespawnableSBags_Client.RemoveRespawnPoint = function(x, y, z, index)
    if not RespawnableSBags.respawnPoints then return end
    if #RespawnableSBags.respawnPoints == 0 then return end

    for i, point in ipairs(RespawnableSBags.respawnPoints) do
        if math.abs(x - point.x) <= 1 and math.abs(y - point.y) <= 1 and z == point.z then
            table.remove(RespawnableSBags.respawnPoints, i)

            local playerObj = getPlayer()
            if playerObj then
                BB_RSBags_Utils.DelayFunction(function()
                    local args = { index = index }
                    sendClientCommand(playerObj, "RespawnableSBags", "ClearIndex", args)
                end, 100)
                playerObj:Say("Respawn Point Removed")
            end
        end
    end
end

local everyMinute = function()
    if not RespawnableSBags.respawnPoints then return end
    if #RespawnableSBags.respawnPoints == 0 then return end
    if not RespawnableSBags.cooldown then RespawnableSBags.cooldown = SandboxVars.RespawnableSBags.Cooldown end

    if RespawnableSBags.cooldown > 0 then
        RespawnableSBags.cooldown = RespawnableSBags.cooldown - 1
    end

    local dayInfo = getClimateManager():getCurrentDay()
    RespawnableSBags.lastDate = dayInfo:getDay() .. "/" .. dayInfo:getMonth() .. "/" .. dayInfo:getYear()
end

Events.EveryOneMinute.Add(everyMinute)

local function updateCachedList(data)
    serverCachedList = data
    if serverCachedList then
        for i, point in ipairs(serverCachedList) do
            RespawnableSBags_Client.RemoveRespawnPoint(point.spawnPointX, point.spawnPointY, point.spawnPointZ, i)
        end
    end
end

local function onServerCommand(module, command, args)
    if module ~= "RespawnableSBags" then return end

    if command == "RemoveSBag" then
        RespawnableSBags_Client.RemoveRespawnPoint(args.spawnPointX, args.spawnPointY, args.spawnPointZ, args.index)
    end

    if command == "UpdateCachedList" then
        updateCachedList(args)
    end
end

Events.OnServerCommand.Add(onServerCommand)

local function onInitGlobalModData()
    RespawnableSBags = ModData.get("RespawnableSBags")

    if RespawnableSBags then
        if not RespawnableSBags.version or (RespawnableSBags.version and RespawnableSBags.version ~= "1.0.8") then
            RespawnableSBags.respawnPoint = -1
            RespawnableSBags.respawnPoints = {}
            RespawnableSBags.respawnX = nil
            RespawnableSBags.respawnY = nil
            RespawnableSBags.respawnZ = nil
            RespawnableSBags.lastDate = nil
            RespawnableSBags.cooldown = 72
            RespawnableSBags.version = "1.0.8"
            return
        else
            return
        end
    end

    RespawnableSBags = ModData.create("RespawnableSBags")
end

Events.OnInitGlobalModData.Add(onInitGlobalModData)

local function onGameStart()
    if not RespawnableSBags then return end

    local dayInfo = getClimateManager():getCurrentDay()

    if RespawnableSBags.lastDate then

      local lastDay, lastMonth, lastYear = RespawnableSBags.lastDate:match("(%d+)/(%d+)/(%d+)")
      if not (lastDay or lastMonth or lastYear) then return end

      local lastDateValue = lastYear * 365 + (lastMonth - 1) * 30 + lastDay
      local currentDayValue = dayInfo:getYear() * 365 + (dayInfo:getMonth() - 1) * 30 + dayInfo:getDay()

      print("VERIFY")
      print(lastDateValue)
      print(currentDayValue)
      print("________________")

      if currentDayValue < lastDateValue then
        RespawnableSBags.respawnPoint = -1
        RespawnableSBags.respawnX = nil
        RespawnableSBags.respawnY = nil
        RespawnableSBags.respawnZ = nil
        RespawnableSBags.cooldown = 72
      end
    end

    RespawnableSBags.lastDate = dayInfo:getDay() .. "/" .. dayInfo:getMonth() .. "/" .. dayInfo:getYear()
  end

Events.OnGameStart.Add(onGameStart)