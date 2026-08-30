require "LandClaim/ServerData"

local MODULE = 'LandClaim_Server'

local ClientCommands = {}

ClientCommands.AddPlayerToSafehouse = function(player, data)
    local globalModData = ServerData.GetLandClaimSafehouses()
    local safehouseId = data.safehouseId
    local safehouseData = globalModData[safehouseId]

    if not safehouseData then
        print("Safehouse with ID: " .. safehouseId .. " doesn't exist in the Server Data.")
        return
    end

    local playersList = safehouseData.Players
    local rank = LandClaimConfig.MinimumMemberRankLevel
    if data.isOwner then
        rank = 999
    end

    playersList[data.username] = { IsOwner = data.isOwner, RankLevel = rank }

    ServerData.SetLandClaimSafehouses(globalModData)
end

ClientCommands.RemovePlayerToSafehouse = function(player, data)
    local globalModData = ServerData.GetLandClaimSafehouses()
    local safehouseId = data.safehouseId
    local safehouseData = globalModData[safehouseId]

    if not safehouseData then
        print("Safehouse with ID: " .. safehouseId .. " doesn't exist in the Server Data.")
        return
    end

    local playersList = safehouseData.Players
    playersList[data.username] = nil

    ServerData.SetLandClaimSafehouses(globalModData)
end

ClientCommands.UpdatePlayerRankOfSafehouse = function(player, data)
    local globalModData = ServerData.GetLandClaimSafehouses()
    local safehouseId = data.safehouseId
    local safehouseData = globalModData[safehouseId]

    if not safehouseData then
        print("Safehouse with ID: " .. safehouseId .. " doesn't exist in the Server Data.")
        return
    end

    local playersList = safehouseData.Players
    local playerData = playersList[data.username]

    if not playerData then
        print("Safehouse with ID: " .. safehouseId .. " doesn't have player with username: ".. data.username .. ".")
        return
    end

    if data.promote then
        playerData.RankLevel = math.min(playerData.RankLevel + 1, LandClaimConfig.MaximumMemberRankLevel)
    elseif data.demote then
        playerData.RankLevel = math.max(playerData.RankLevel - 1, LandClaimConfig.MinimumMemberRankLevel)
    end    

    ServerData.SetLandClaimSafehouses(globalModData)
end

ClientCommands.UpdateSafehouseLevel = function(player, data)
    local globalModData = ServerData.GetLandClaimSafehouses()
    local safehouseData = globalModData[data.safehouseId]
    if not safehouseData then
        return
    end

    if data.upgrade then
        safehouseData.Level = math.min(safehouseData.Level + 1, LandClaimConfig.MaximumSafehouseLevel)
    elseif data.downgrade then
        safehouseData.Level = math.max(safehouseData.Level - 1, LandClaimConfig.MinimumSafehouseLevel)
    end

    ServerData.SetLandClaimSafehouses(globalModData)
end

ClientCommands.CreateSafehouse = function(player, data)
    local globalModData = ServerData.GetLandClaimSafehouses()
    globalModData[data.safehouseId] = {
        Level = LandClaimConfig.MinimumSafehouseLevel,
        Players = {
            [player:getUsername()] = {IsOwner = true, Rank = 999}
        },
        Center = {
            X = data.x,
            Y = data.y,
            Z = data.z,
        }
    }

    ServerData.SetLandClaimSafehouses(globalModData)
end

ClientCommands.DeleteSafehouse = function(player, data)
    local globalModData = ServerData.GetLandClaimSafehouses()
    globalModData[data.safehouseId] = nil
    ServerData.SetLandClaimSafehouses(globalModData)
end

local OnClientCommand = function(module, command, playerObj, args)
    if LandClaimConfig.Validated and module == MODULE and ClientCommands[command] then
        ClientCommands[command](playerObj, args)
    end
end

Events.OnClientCommand.Add(OnClientCommand)
