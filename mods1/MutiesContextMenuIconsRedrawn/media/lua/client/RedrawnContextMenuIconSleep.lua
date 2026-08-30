require("MutiesContextMenuIcons/HelperFunctions");

MutiesContextMenuIcons.Options["ContextMenu_Sleep"] =
getRedrawnIconPath("Sleep.png");

--[[
local originalISCampingMenuDoSleepOption = ISCampingMenu.doSleepOption;

function ISCampingMenu.doSleepOption(context, bed, player, playerObj)
    originalISCampingMenuDoSleepOption(context, bed, player, playerObj);
    local option = context:getOptionFromName(getText("ContextMenu_Sleep"));
    if not option then return end
    option.iconTexture = getTexture(getRedrawnIconPath("Sleep.png"));
end

local originalISWorldObjectContextMenuDoSleepOption = ISWorldObjectContextMenu.doSleepOption

function ISWorldObjectContextMenu.doSleepOption(context, bed, player, playerObj)
    originalISWorldObjectContextMenuDoSleepOption(context, bed, player, playerObj);
    local option = context:getOptionFromName(getText("ContextMenu_Sleep"));
    if not option then return end
    option.iconTexture = getTexture(getRedrawnIconPath("Sleep.png"));
end
--]]