require("MutiesContextMenuIcons/HelperFunctions");

MutiesContextMenuIcons.Options["ContextMenu_Fill"] = {
    ["TexturePath"] = getExpandedIconPath("Fill.png"),
    ["SubOptions"] = {
        ["ContextMenu_FillAll"] = getExpandedIconPath("FillAll.png"),
    }
};

--[[
local originalDoFillWaterMenu = ISWorldObjectContextMenu.doFillWaterMenu;

function ISWorldObjectContextMenu.doFillWaterMenu(sink, playerNum, context)
    originalDoFillWaterMenu(sink, playerNum, context);

    local option = context:getOptionFromName(getText("ContextMenu_Fill"));
    if not option then return context end
    option.iconTexture = getTexture(getExpandedIconPath("Fill.png"));

    local subContext = context:getSubMenu(option.subOption);
	if not subContext then return context end

    local allOption = subContext:getOptionFromName(getText("ContextMenu_FillAll"));
    if allOption then
        allOption.iconTexture = getTexture(getExpandedIconPath("FillAll.png"));
    end
end
--]]