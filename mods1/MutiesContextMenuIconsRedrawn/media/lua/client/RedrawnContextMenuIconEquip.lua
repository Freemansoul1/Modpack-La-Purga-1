require("MutiesContextMenuIcons/HelperFunctions");

MutiesContextMenuIcons.Options["ContextMenu_Equip_Primary"] =
getRedrawnIconPath("EquipPrimary.png");

MutiesContextMenuIcons.Options["ContextMenu_Equip_Secondary"] =
getRedrawnIconPath("EquipSecondary.png");

MutiesContextMenuIcons.Options["ContextMenu_Equip_on_your_Back"] =
getRedrawnIconPath("EquipOnBack.png");

MutiesContextMenuIcons.Options["ContextMenu_Equip_Two_Hands"] =
getRedrawnIconPath("EquipTwoHands.png");

--[[
local originalISInventoryPaneContextMenuDoEquipOption = ISInventoryPaneContextMenu.doEquipOption;

function ISInventoryPaneContextMenu.doEquipOption(context, playerObj, isWeapon, items, player)
    originalISInventoryPaneContextMenuDoEquipOption(context, playerObj, isWeapon, items, player);
    local equipPrimaryOption = context:getOptionFromName(getText("ContextMenu_Equip_Primary"));
    if equipPrimaryOption then
        equipPrimaryOption.iconTexture = getTexture(getRedrawnIconPath("EquipPrimary.png"));
    end
    local equipSecondaryOption = context:getOptionFromName(getText("ContextMenu_Equip_Secondary"));
    if equipSecondaryOption then
        equipSecondaryOption.iconTexture = getTexture(getRedrawnIconPath("EquipSecondary.png"));
    end
end

local originalCreateMenu = ISInventoryPaneContextMenu.createMenu
function ISInventoryPaneContextMenu.createMenu(player, isInPlayerInventory, items, x, y, origin)
    local context = originalCreateMenu(player, isInPlayerInventory, items, x, y, origin);
    if not context then return context end
    local equipOnBackOption = context:getOptionFromName(getText("ContextMenu_Equip_on_your_Back"));
    if equipOnBackOption then
        equipOnBackOption.iconTexture = getTexture(getRedrawnIconPath("EquipOnBack.png"));
    end
    local equipTwoHandsOption = context:getOptionFromName(getText("ContextMenu_Equip_Two_Hands"));
    if equipTwoHandsOption then
        equipTwoHandsOption.iconTexture = getTexture(getRedrawnIconPath("EquipTwoHands.png"));
    end
    return context;
end
--]]