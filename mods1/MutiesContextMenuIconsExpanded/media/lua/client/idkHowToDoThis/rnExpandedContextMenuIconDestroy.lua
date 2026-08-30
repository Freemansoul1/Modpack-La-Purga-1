--[[
local originalDoBuildMenu = ISBuildMenu.doBuildMenu;

ISBuildMenu.doBuildMenu = function(player, context, worldobjects, test)
    originalDoBuildMenu(player, context, worldobjects, test);
    local option = context:getOptionFromName(getText("ContextMenu_Destroy"));
    if not option then return context end
    option.iconTexture = getTexture(getExpandedIconPath("Stub.png"));
end
--]]