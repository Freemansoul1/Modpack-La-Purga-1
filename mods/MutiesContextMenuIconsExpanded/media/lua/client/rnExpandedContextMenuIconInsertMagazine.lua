--[[
require("MutiesContextMenuIcons/HelperFunctions");

MutiesContextMenuIcons.Options["ContextMenu_InsertMagazine"] =
getExpandedIconPath("InsertMagazine.png");
--]]

local originalDoReloadMenuForWeapon = ISInventoryPaneContextMenu.doReloadMenuForWeapon;

function ISInventoryPaneContextMenu.doReloadMenuForWeapon(playerObj, weapon, context)
    originalDoReloadMenuForWeapon(playerObj, weapon, context);
    local option = context:getOptionFromName(getText("ContextMenu_InsertMagazine"));
    if not option then return context end;
    option.iconTexture = getTexture(getExpandedIconPath("InsertMagazine.png"));
end

local originalDoReloadMenuForMagazine = ISInventoryPaneContextMenu.doReloadMenuForMagazine;

function ISInventoryPaneContextMenu.doReloadMenuForMagazine(playerObj, magazine, context)
    originalDoReloadMenuForMagazine(playerObj, magazine, context);
    local option = context:getOptionFromName(getText("ContextMenu_InsertMagazine"));
    if not option then return context end;
    option.iconTexture = getTexture(getExpandedIconPath("InsertMagazine.png"));
end