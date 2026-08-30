--[[
require("MutiesContextMenuIcons/HelperFunctions");

MutiesContextMenuIcons.Options["ContextMenu_EjectMagazine"] =
getExpandedIconPath("EjectMagazine.png");
--]]

local originalDoReloadMenuForWeapon = ISInventoryPaneContextMenu.doReloadMenuForWeapon;

function ISInventoryPaneContextMenu.doReloadMenuForWeapon(playerObj, weapon, context)
    originalDoReloadMenuForWeapon(playerObj, weapon, context);
    local option = context:getOptionFromName(getText("ContextMenu_EjectMagazine"));
    if not option then return context end;
    option.iconTexture = getTexture(getExpandedIconPath("EjectMagazine.png"));
end