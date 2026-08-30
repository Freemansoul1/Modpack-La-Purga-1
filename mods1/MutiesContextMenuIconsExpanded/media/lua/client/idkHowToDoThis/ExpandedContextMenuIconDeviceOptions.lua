--[[
require("MutiesContextMenuIconsExpanded/HelperFunctions");

MutiesContextMenuIcons.Options["IGUI_DeviceOptions"] =
getExpandedIconPath("Settings.png");
--]]
--[[
local originalHandleInteraction = ISWorldObjectContextMenu.handleInteraction;

function ISWorldObjectContextMenu.handleInteraction(x, y, test, context, worldobjects, playerObj, playerInv)
    originalHandleInteraction(x, y, test, context, worldobjects, playerObj, playerInv);
    if not context then return context end
    if type(context) ~= "table" then return context end
    local option = context:getOptionFromName(getText("IGUI_DeviceOptions"));
    if not option then return end
    option.iconTexture = getTexture(getExpandedIconPath("Settings.png"));
end
--why it doesn't work бл
--]]