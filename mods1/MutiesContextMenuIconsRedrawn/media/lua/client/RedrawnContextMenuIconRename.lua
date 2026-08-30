--require("MutiesContextMenuIcons/HelperFunctions");

--MutiesContextMenuIcons.Options["ContextMenu_RenameBag"] =
--getRedrawnIconPath("Rename.png");

--MutiesContextMenuIcons.Options["ContextMenu_RenameFood"] =
--getRedrawnIconPath("Rename.png");

--MutiesContextMenuIcons.Options["ContextMenu_RenameMap"] =
--getRedrawnIconPath("Rename.png");

local originalCreateMenu = ISInventoryPaneContextMenu.createMenu;

function ISInventoryPaneContextMenu.createMenu(player, isInPlayerInventory, items, x, y, origin)
    local context = originalCreateMenu(player, isInPlayerInventory, items, x, y, origin);
    if not context then return context end
    local renameBagOption = context:getOptionFromName(getText("ContextMenu_RenameBag"));
    if renameBagOption then
        renameBagOption.iconTexture = getTexture(getRedrawnIconPath("Rename.png"));
    end
    
    local renameFoodOption = context:getOptionFromName(getText("ContextMenu_RenameFood"));
    if renameFoodOption then
        renameFoodOption.iconTexture = getTexture(getRedrawnIconPath("Rename.png"));
    end

    local renameMapOption = context:getOptionFromName(getText("ContextMenu_RenameMap"));
    if renameMapOption then
        renameMapOption.iconTexture = getTexture(getRedrawnIconPath("Rename.png"));
    end
    return context;
end