require("MutiesContextMenuIcons/HelperFunctions");

MutiesContextMenuIcons.Options["ContextMenu_Wash"] =
getExpandedIconPath("Wash.png");

--[[
local originalDoWearClothingMenu = ISWorldObjectContextMenu.doWashClothingMenu;

function ISWorldObjectContextMenu.doWashClothingMenu(sink, player, context)
    originalDoWearClothingMenu(sink, player, context);
    local option = context:getOptionFromName(getText("ContextMenu_Wash"));
    if not option then return context end
    option.iconTexture = getTexture(getExpandedIconPath("Wash.png"));
end
--]]