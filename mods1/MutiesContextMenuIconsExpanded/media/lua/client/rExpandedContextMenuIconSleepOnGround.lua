require("MutiesContextMenuIcons/HelperFunctions");

MutiesContextMenuIcons.Options["ContextMenu_SleepOnGround"] =
getExpandedIconPath("SleepOnGround.png");

--[[
local originalISWorldObjectContextMenuDoSleepOnGroundOption = ISWorldObjectContextMenu.doSleepOption

function ISWorldObjectContextMenu.doSleepOption(context, bed, player, playerObj)
    originalISWorldObjectContextMenuDoSleepOnGroundOption(context, bed, player, playerObj);
    local option = context:getOptionFromName(getText("ContextMenu_SleepOnGround"));
    if not option then return end
    option.iconTexture = getTexture(getExpandedIconPath("SleepOnGround.png"));
end
--]]