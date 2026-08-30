require("MutiesContextMenuIcons/HelperFunctions");

MutiesContextMenuIcons.Options["ContextMenu_UnlockDoor"] =
getExpandedIconPath("Unlock.png");

MutiesContextMenuIcons.Options["ContextMenu_Unlock_Doors"] =
getExpandedIconPath("Unlock.png");

--[[
local originalDoorCreateMenu = ISWorldObjectContextMenu.createMenu;

function ISWorldObjectContextMenu.createMenu(player, worldobjects, x, y, test)
    local context = originalDoorCreateMenu(player, worldobjects, x, y, test);
    if not context then return context end
    if type(context) ~= "table" then return context end
    local option = context:getOptionFromName(getText("ContextMenu_UnlockDoor"));
    if not option then return context end
    option.iconTexture = getTexture(getExpandedIconPath("Unlock.png"));
    return context;
end

local originalVehicleDoorsCreateMenu = ISWorldObjectContextMenu.createMenu;

function ISWorldObjectContextMenu.createMenu(player, worldobjects, x, y, test)
    local context = originalVehicleDoorsCreateMenu(player, worldobjects, x, y, test);
    if not context then return context end
    if type(context) ~= "table" then return context end
    local option = context:getOptionFromName(getText("ContextMenu_Unlock_Doors"));
    if not option then return context end
    option.iconTexture = getTexture(getExpandedIconPath("Unlock.png"));
    return context;
end
--]]