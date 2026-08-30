--[[
local originalCreateMenu = ISWorldObjectContextMenu.createMenu;
local originalFetch = ISWorldObjectContextMenu.fetch;
clickedPlayer;

function ISWorldObjectContextMenu.fetch(v, player, doSquare)
    clickedPlayer = originalFetch(v, player, doSquare);
end

function ISWorldObjectContextMenu.createMenu(player, worldobjects, x, y, test)
    local context = originalCreateMenu(player, worldobjects, x, y, test);
    if not context then return context end;
    if type(context) ~= "table" then return context end
    local option = context:getOptionFromName(getText("ContextMenu_Trade"), clickedPlayer:getDisplayName());
    if not option then return context end;
    option.iconTexture = getTexture(getExpandedIconPath("Trade.png"));
    return context;
end
--]]