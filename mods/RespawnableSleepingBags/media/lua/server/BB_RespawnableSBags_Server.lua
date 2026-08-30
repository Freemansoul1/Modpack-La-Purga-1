-- ************************************************************************
-- **        ██████  ██████   █████  ██    ██ ███████ ███    ██          **
-- **        ██   ██ ██   ██ ██   ██ ██    ██ ██      ████   ██          **
-- **        ██████  ██████  ███████ ██    ██ █████   ██ ██  ██          **
-- **        ██   ██ ██   ██ ██   ██  ██  ██  ██      ██  ██ ██          **
-- **        ██████  ██   ██ ██   ██   ████   ███████ ██   ████          **
-- ************************************************************************
-- ** All rights reserved. This content is protected by © Copyright law. **
-- ************************************************************************

RespawnableSBags_Cached = {}

local function onInitGlobalModData()
    if not isServer() then return end
    RespawnableSBags_Cached = ModData.get("RespawnableSBags_S")

    if RespawnableSBags_Cached then
        if not RespawnableSBags_Cached.version or RespawnableSBags_Cached.version and RespawnableSBags_Cached.version ~= "1.0.6A" then
            RespawnableSBags_Cached = {}
            RespawnableSBags_Cached.version = "1.0.6A"
            return
        else
            return
        end
    end

    RespawnableSBags_Cached = ModData.create("RespawnableSBags_S")
end

Events.OnInitGlobalModData.Add(onInitGlobalModData)

local function updateClients(command, args)
    local onlinePlayers = getOnlinePlayers()
    for i = 1, onlinePlayers:size() do
        local player = onlinePlayers:get(i - 1)

        if player then
            sendServerCommand(player, "RespawnableSBags", command, args)
        end
    end
end

local onClientCommand = function(module, command, playerObj, args)
    if module ~= "RespawnableSBags" then return end
    if not RespawnableSBags_Cached then return end

    if command == "RemoveSBag" then
        table.insert(RespawnableSBags_Cached, args)
        updateClients("UpdateCachedList", RespawnableSBags_Cached)
    end

    if command == "ClearIndex" then
        table.remove(RespawnableSBags_Cached, args.index)
    end

    if command == "UpdatePlayerCache" then
        sendServerCommand(playerObj, "RespawnableSBags", "UpdateCachedList", RespawnableSBags_Cached)
    end
end

Events.OnClientCommand.Add(onClientCommand)