-- If the player is playing solo or the script is running server-side, don't run this script
if isServer() or (not isServer() and not isClient()) then return end

Knockout = Knockout or {}

local upperLayerCreateMenu = ISWorldObjectContextMenu.createMenu

ISWorldObjectContextMenu.createMenu = function(player, worldobjects, x, y, test)
    local context = upperLayerCreateMenu(player, worldobjects, x, y, test)

    local playerObj = getSpecificPlayer(player)

    if clickedPlayer and clickedPlayer ~= playerObj and isClient() then
        local clickedPlayerID = clickedPlayer:getOnlineID()

        local isOtherPlayerKnockedOut = Knockout.isOtherPlayerKnockedOutResponse(playerObj, clickedPlayerID)

        if isOtherPlayerKnockedOut and not playerObj:getModData().Knockout_isKnockedout then
            local clickedPlayerName = clickedPlayer:getUsername()
            local inv = playerObj:getInventory()
            local saltItem = inv:getFirstTypeRecurse('Base.Salt')

            local option = context:addOption(getText("ContextMenu_Knockout_WakeUpOption") .. clickedPlayerName, playerObj, Knockout.wakeOtherPlayerUp, clickedPlayer, clickedPlayerID, saltItem)

            local description = clickedPlayerName .. " " .. getText("ContextMenu_Knockout_WakeUpOptionDescription") .. " <LINE>"

            local saltName = getText("ContextMenu_Knockout_Salt")

            if saltItem then
                description = description .. " <RGB:1,1,1>" .. saltName .. " 1/1"
            else
                option.notAvailable = true
                description = description .. " <RED>S" .. saltName .. " 0/1"
            end

            local tooltip = ISToolTip:new();
            tooltip:initialise();
            tooltip:setVisible(false);
            tooltip.description = description
            option.toolTip = tooltip
        end
    end
    return context
end

function Knockout.wakeOtherPlayerUp(playerObj, clickedPlayer, clickedPlayerID, saltItem)
    if luautils.walkAdj(playerObj, clickedPlayer:getSquare()) then
        ISTimedActionQueue.add(ISEquipWeaponAction:new(playerObj, saltItem, 50, primary))
        ISTimedActionQueue.add(Knockout_WakeOtherPlayerUpTimedAction:new(playerObj, clickedPlayerID, saltItem))
    end
end

--Events.OnFillWorldObjectContextMenu.Add(wakePlayerUp)