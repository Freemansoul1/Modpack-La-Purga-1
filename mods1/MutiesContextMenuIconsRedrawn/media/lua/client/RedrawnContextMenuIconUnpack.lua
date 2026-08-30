--[[
require("MutiesContextMenuIcons/HelperFunctions");

MutiesContextMenuIcons.Options["ContextMenu_Unpack"] =
getRedrawnIconPath("Unpack.png");
--]]

local originalCreateMenu = ISInventoryPaneContextMenu.createMenu

function ISInventoryPaneContextMenu.createMenu(player, isInPlayerInventory, items, x, y, origin)
    local context = originalCreateMenu(player, isInPlayerInventory, items, x, y, origin);
    if not context then return context end
    local option = context:getOptionFromName(getText("ContextMenu_Unpack"));
    if not option then return context end
    option.iconTexture = getTexture(getRedrawnIconPath("Unpack.png"));
    return context;
end