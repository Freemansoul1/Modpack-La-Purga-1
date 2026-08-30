local originalCreateMenu = ISInventoryPaneContextMenu.createMenu

function ISInventoryPaneContextMenu.createMenu(player, isInPlayerInventory, items, x, y, origin)
    local context = originalCreateMenu(player, isInPlayerInventory, items, x, y, origin);
    if not context then return context end
    local loot = getPlayerLoot(player);
    local option = context:getOptionFromName(getText("ContextMenu_PutInContainer", loot.title));
    if not option then return context end
    option.iconTexture = getTexture(getExpandedIconPath("PutInContainer.png"));
    return context;
end