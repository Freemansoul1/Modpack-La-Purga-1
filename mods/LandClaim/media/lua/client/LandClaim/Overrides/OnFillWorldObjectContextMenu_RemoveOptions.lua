local SafehouseController = require "LandClaim/SafehouseController"

local function OnFillWorldObjectContextMenu(playerIndex, context, worldObjects, test)
    --todo uncomment for final version
	context:removeOptionByName(getText("ContextMenu_SafehouseClaim"))
    context:removeOptionByName(getText("ContextMenu_SafehouseRelease"))
    --context:removeOptionByName(getText("ContextMenu_SafehouseAddPlayer"))
    --context:removeOptionByName(getText("ContextMenu_SafehouseRemovePlayer"))

    local square
    for i,v in ipairs(worldObjects) do
        square = v:getSquare();
        break
    end

    local player = getSpecificPlayer(playerIndex);
    if SafehouseController.CanLockDoors(player, square) then
        context:removeOptionByName(getText("ContextMenu_LockDoor"))
        context:removeOptionByName(getText("ContextMenu_UnlockDoor"))
        --Remove context menus 
    end
end

Events.OnFillWorldObjectContextMenu.Add(OnFillWorldObjectContextMenu)