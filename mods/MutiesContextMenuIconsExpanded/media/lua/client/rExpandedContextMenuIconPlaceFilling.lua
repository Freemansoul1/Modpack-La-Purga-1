require("MutiesContextMenuIcons/HelperFunctions");

MutiesContextMenuIcons.Options["ContextMenu_PlaceItemOnGround"] = {
    ["TexturePath"] = getRedrawnIconPath("Place.png"),
    ["SubOptions"] = {
        ["ContextMenu_PlaceOne"] = getRedrawnIconPath("Place.png"),
        ["ContextMenu_PlaceHalf"] = getExpandedIconPath("PlaceHalf.png"),
        ["ContextMenu_PlaceAll"] = getExpandedIconPath("PlaceAll.png"),
    }
};

--[[
local originalDoPlace3DItemOption = ISInventoryPaneContextMenu.doPlace3DItemOption

function ISInventoryPaneContextMenu.doPlace3DItemOption(items, player, context)
    originalDoPlace3DItemOption(items, player, context);

	local option = context:getOptionFromName(getText("ContextMenu_PlaceItemOnGround"));
    if not option then return end;

	local subContext = context:getSubMenu(option.subOption);
	if not subContext then return context end

    local oneOption = subContext:getOptionFromName(getText("ContextMenu_PlaceOne"));
    if oneOption then
        oneOption.iconTexture = getTexture(getExpandedIconPath("Place.png"));
    end

    local halfOption = subContext:getOptionFromName(getText("ContextMenu_PlaceHalf"));
    if halfOption then
        halfOption.iconTexture = getTexture(getExpandedIconPath("PlaceHalf.png"));
    end

    local allOption = subContext:getOptionFromName(getText("ContextMenu_PlaceAll"));
    if allOption then
        allOption.iconTexture = getTexture(getExpandedIconPath("PlaceAll.png"));
    end
end
--]]