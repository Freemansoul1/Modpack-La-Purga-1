--[[
local originalCampingCreateMenu = ISCampingMenu.createMenu

function ISCampingMenu.doSleepOption(player, worldobjects, x, y, test)
    local context = originalCampingCreateMenu(player, worldobjects, x, y, test);
    if not context then return context end
    if type(context) ~= "table" then return context end
    local option = context:getOptionFromName(getText("ContextMenu_Rest"));
    if not option then return end
    option.iconTexture = getTexture("media/ui/icons/Expanded/Rest.png");
end
]]--

require("MutiesContextMenuIcons/HelperFunctions");

MutiesContextMenuIcons.Options["ContextMenu_Rest"] =
getExpandedIconPath("Rest.png");

--[[
local originalCreateMenu = ISWorldObjectContextMenu.createMenu;

function ISWorldObjectContextMenu.createMenu(player, worldobjects, x, y, test)
    local context = originalCreateMenu(player, worldobjects, x, y, test);
    if not context then return context end
    if type(context) ~= "table" then return context end
    local option = context:getOptionFromName(getText("ContextMenu_Rest"));
    if not option then return context end
    option.iconTexture = getTexture(getExpandedIconPath("Rest.png"));
    return context;
end
--]]