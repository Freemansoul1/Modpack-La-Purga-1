require("MutiesContextMenuIcons/HelperFunctions");

MutiesContextMenuIcons.Options["IGUI_invpanel_Inspect"] =
getRedrawnIconPath("Search.png");

--[[
local originalCreateMenu = ISInventoryPaneContextMenu.createMenu;

function ISInventoryPaneContextMenu.createMenu(player, isInPlayerInventory, items, x, y, origin)
    local context = originalCreateMenu(player, isInPlayerInventory, items, x, y, origin);
    if not context then return context end
    local option = context:getOptionFromName(getText("IGUI_invpanel_Inspect"));
    if not option then return context end
    option.iconTexture = getTexture(getRedrawnIconPath("Search.png"));
    return context;
end
--]]