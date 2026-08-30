ConnectedPlayersStore = {}

LuaEventManager.AddEvent("LC_ConnectedPlayersStoreUpdate")

local function triggerEventStoreUpdate()
    --todo subscribe to this to refresh UI
	triggerEvent("LC_ConnectedPlayersStoreUpdate")
end

function ConnectedPlayersStore.OnScoreboardUpdate(usernames, displayNames, steamIDs)
    if ConnectedPlayersStore then
        ConnectedPlayersStore.scoreboard = {}
        ConnectedPlayersStore.scoreboard.usernames = usernames
        ConnectedPlayersStore.scoreboard.displayNames = displayNames
        ConnectedPlayersStore.scoreboard.steamIDs = steamIDs
        triggerEventStoreUpdate()
    end
end

function ConnectedPlayersStore.getConnectedPlayersForSafehouse(safehouse)
    local playerList = {}

    if not ConnectedPlayersStore.scoreboard then return end
    for i=1,ConnectedPlayersStore.scoreboard.usernames:size() do
        local username = ConnectedPlayersStore.scoreboard.usernames:get(i-1)
        local displayName = ConnectedPlayersStore.scoreboard.displayNames:get(i-1)
        if safehouse:getOwner() ~= username then
            local newPlayer = {};
            newPlayer.username = username;
            local alreadySafe = safehouse:alreadyHaveSafehouse(username);
            if alreadySafe and alreadySafe ~= safehouse then
                if alreadySafe:getTitle() ~= "Safehouse" then
                    displayName = displayName .. " " .. getText("IGUI_LandClaimUI_AlreadyHaveSafehouse", "(" .. alreadySafe:getTitle() .. ")");
                else
                    newPlayer.tooltip = displayName .. " " .. getText("IGUI_LandClaimUI_AlreadyHaveSafehouse" , "");
                end
            end
            playerList[displayName] = newPlayer
        end
    end
end

Events.OnScoreboardUpdate.Add(ConnectedPlayersStore.OnScoreboardUpdate)
Events.AcceptedSafehouseInvite.Add(triggerEventStoreUpdate)
Events.OnSafehousesChanged.Add(triggerEventStoreUpdate)