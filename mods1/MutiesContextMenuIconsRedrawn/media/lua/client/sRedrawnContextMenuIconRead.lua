local originalDoLiteratureMenu = ISInventoryPaneContextMenu.doLiteratureMenu;

function ISInventoryPaneContextMenu.doLiteratureMenu(context, items, player)
        originalDoLiteratureMenu(context, items, player);
        --if not context then return context end
        local option = context:getOptionFromName(getText("ContextMenu_Read"));
        if not option then return context end
        option.iconTexture = getTexture(getOriginalIconPath("Auto Stories.png"));
end