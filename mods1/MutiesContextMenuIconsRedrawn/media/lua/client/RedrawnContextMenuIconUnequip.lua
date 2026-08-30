--[[
require("MutiesContextMenuIcons/HelperFunctions");

MutiesContextMenuIcons.Options["ContextMenu_Unequip"] =
getRedrawnIconPath("Unequip.png");
--]]

local originalCreateMenu = ISInventoryPaneContextMenu.createMenu

function ISInventoryPaneContextMenu.createMenu(player, isInPlayerInventory, items, x, y, origin)
    local context = originalCreateMenu(player, isInPlayerInventory, items, x, y, origin);
    if not context then return context end
    local option = context:getOptionFromName(getText("ContextMenu_Unequip"));
    if not option then return context end
    option.iconTexture = getTexture(getRedrawnIconPath("Unequip.png"));
    return context;
end