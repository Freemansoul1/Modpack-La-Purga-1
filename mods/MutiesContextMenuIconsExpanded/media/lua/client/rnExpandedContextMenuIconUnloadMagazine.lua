--[[
require("MutiesContextMenuIcons/HelperFunctions");

MutiesContextMenuIcons.Options["ContextMenu_UnloadMagazine"] =
getExpandedIconPath("UnloadMagazine.png");
--]]

local originalDoMagazineMenu = ISInventoryPaneContextMenu.doMagazineMenu;

function ISInventoryPaneContextMenu.doMagazineMenu(playerObj, magazine, context)
    originalDoMagazineMenu(playerObj, magazine, context);
    local option = context:getOptionFromName(getText("ContextMenu_UnloadMagazine"));
    if not option then return context end;
    option.iconTexture = getTexture(getExpandedIconPath("UnloadMagazine.png"));
end