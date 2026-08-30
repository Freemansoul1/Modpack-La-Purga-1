require 'ISUI/ISWorldObjectContextMenu'
require 'ISUI/ISVehicleMenu'

--Disable the ability to cancel the knocked out timed action
local old_isPlayerDoingActionThatCanBeCancelled = isPlayerDoingActionThatCanBeCancelled

---@param playerObj IsoPlayer
function isPlayerDoingActionThatCanBeCancelled(playerObj)
    if not playerObj then return false end
    local currentAction = ISTimedActionQueue.getTimedActionQueue(playerObj)
    if currentAction and currentAction.queue[1] then
        if currentAction.queue[1].Type == "Knockout_TimedAction" then
            return false
        end
    end
    return old_isPlayerDoingActionThatCanBeCancelled(playerObj)
end

--Disable the draw of world context menu if the player is knocked out
local old_ISWorldObjectContextMenu_createMenu = ISWorldObjectContextMenu.createMenu;
ISWorldObjectContextMenu.createMenu = function(player, worldobjects, x, y, test)
    local character = getSpecificPlayer(player)

    if character:isLocalPlayer() and character:getModData().Knockout_isKnockedout then return end

    return old_ISWorldObjectContextMenu_createMenu(player, worldobjects, x, y, test)
end

--Disable the ability use the car horn if the player is knocked out
local old_ISVehicleMenu_onHornStart = ISVehicleMenu.onHornStart
ISVehicleMenu.onHornStart = function(playerObj)
    if playerObj:getModData().Knockout_isKnockedout then return end

    return old_ISVehicleMenu_onHornStart(playerObj)
end

--Disable the ability to toggle world map if the player is knocked out
local old_ISWorldMap_ToggleWorldMap = ISWorldMap.ToggleWorldMap;
ISWorldMap.ToggleWorldMap = function(playerNum)
    local character = getSpecificPlayer(playerNum)

    if character:getModData().Knockout_isKnockedout then return end

    return old_ISWorldMap_ToggleWorldMap(playerNum)
end
