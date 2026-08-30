require("MutiesContextMenuIcons/HelperFunctions");

MutiesContextMenuIcons.Options["ContextMenu_PlaceItemOnGround"] =
getRedrawnIconPath("Place.png");

--[[
local originalDoPlace3DItemOption = ISInventoryPaneContextMenu.doPlace3DItemOption;

function ISInventoryPaneContextMenu.doPlace3DItemOption(items, player, context)
    originalDoPlace3DItemOption(items, player, context);
    local option = context:getOptionFromName(getText("ContextMenu_PlaceItemOnGround"));
    if not option then return end;
    option.iconTexture = getTexture(getRedrawnIconPath("Place.png"));
end
--]]