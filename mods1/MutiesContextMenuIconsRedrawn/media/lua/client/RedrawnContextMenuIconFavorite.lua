require("MutiesContextMenuIcons/HelperFunctions");

MutiesContextMenuIcons.Options["IGUI_CraftUI_Favorite"] =
getRedrawnIconPath("Favorite.png");

MutiesContextMenuIcons.Options["ContextMenu_Unfavorite"] =
getRedrawnIconPath("Unfavorite.png");

--[[
local originalCreateMenu = ISInventoryPaneContextMenu.createMenu;

function ISInventoryPaneContextMenu.createMenu(player, isInPlayerInventory, items, x, y, origin)
    local context = originalCreateMenu(player, isInPlayerInventory, items, x, y, origin);
    if not context then return context end
    local favoriteOption = context:getOptionFromName(getText("IGUI_CraftUI_Favorite"));
    if favoriteOption then
        favoriteOption.iconTexture = getTexture(getRedrawnIconPath("Favorite.png"));
    end
    local unfavoriteOption = context:getOptionFromName(getText("ContextMenu_Unfavorite"));
    if unfavoriteOption then
        unfavoriteOption.iconTexture = getTexture(getRedrawnIconPath("Unfavorite.png"));
    end
    return context;
end
--]]