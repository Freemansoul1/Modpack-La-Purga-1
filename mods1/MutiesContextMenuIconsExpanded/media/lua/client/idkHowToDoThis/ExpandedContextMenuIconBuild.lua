--This not works, why ಠ╭╮ಠ
--[[
local originalDoBuildMenu = ISBuildMenu.doBuildMenu;

function ISBuildMenu.doBuildMenu(player, context, worldobjects, test)
    originalDoBuildMenu(player, context, worldobjects, test);
    local option = context:getOptionFromName(getText("ContextMenu_Build"));
    if not option then return end
    option.iconTexture = getTexture(getExpandedIconPath("Stub.png"));
end
--]]
