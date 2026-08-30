local originalDoWearClothingMenu = ISInventoryPaneContextMenu.doWearClothingMenu;

ISInventoryPaneContextMenu.doWearClothingMenu = function(player, clothing, items, context)
        originalDoWearClothingMenu(player, clothing, items, context);
        local option = context:getOptionFromName(getText("ContextMenu_Wear"));
        if not option then return context end
        option.iconTexture = getTexture(getOriginalIconPath("Checkroom.png"));
end

local originalDoClothingItemExtraMenu = ISInventoryPaneContextMenu.doClothingItemExtraMenu;

ISInventoryPaneContextMenu.doClothingItemExtraMenu = function(context, clothingItemExtra, playerObj)
        originalDoClothingItemExtraMenu(context, clothingItemExtra, playerObj);
        local option = context:getOptionFromName(getText("ContextMenu_Wear"));
        if not option then return context end
        option.iconTexture = getTexture(getOriginalIconPath("Checkroom.png"));
end