--[[ --This system don't work with new world drink
require("MutiesContextMenuIcons/HelperFunctions");

MutiesContextMenuIcons.Options["ContextMenu_Drink"] = {
    ["TexturePath"] = getRedrawnIconPath("Drink.png"),
    ["SubOptions"] = {
        ["ContextMenu_Eat_All"] = getOriginalIconPath("Circle Filled.png"),
        ["ContextMenu_Eat_Half"] = getRedrawnIconPath("Half.png"),
        ["ContextMenu_Eat_Quarter"] = getRedrawnIconPath("Quarter.png"),
    }
};
--]]

local originalCreateMenu = ISInventoryPaneContextMenu.createMenu;

function ISInventoryPaneContextMenu.createMenu(player, isInPlayerInventory, items, x, y, origin)
    local context = originalCreateMenu(player, isInPlayerInventory, items, x, y, origin);
    if not context then return context end
    local option = context:getOptionFromName(getText("ContextMenu_Drink"));
    if not option then return context end
    option.iconTexture = getTexture(getRedrawnIconPath("Drink.png"));
    
    local subContext = context:getSubMenu(option.subOption);
    if not subContext then return context end

    local quarterOption = subContext:getOptionFromName(getText("ContextMenu_Eat_Quarter"));
    if quarterOption then
        quarterOption.iconTexture = getTexture(getRedrawnIconPath("Quarter.png"));
    end
    
    local halfOption = subContext:getOptionFromName(getText("ContextMenu_Eat_Half"));
    if halfOption then
        halfOption.iconTexture = getTexture(getRedrawnIconPath("Half.png"));
    end

    local allOption = subContext:getOptionFromName(getText("ContextMenu_Eat_All"));
    if allOption then
        allOption.iconTexture = getTexture(getOriginalIconPath("Circle Filled.png"));
    end
    return context;
end