require("MutiesContextMenuIcons/HelperFunctions");

MutiesContextMenuIcons.Options["ContextMenu_Climb_through"] =
getExpandedIconPath("ClimbThrough.png");

--[[
local originalCreateMenu = ISWorldObjectContextMenu.createMenu;

function ISWorldObjectContextMenu.createMenu(player, worldobjects, x, y, test)
    local context = originalCreateMenu(player, worldobjects, x, y, test);
    if not context then return context end
    if type(context) ~= "table" then return context end
    local option = context:getOptionFromName(getText("ContextMenu_Climb_through"));
    if not option then return context end
    option.iconTexture = getTexture(getExpandedIconPath("ClimbThrough.png"));
    return context;
end
--]]