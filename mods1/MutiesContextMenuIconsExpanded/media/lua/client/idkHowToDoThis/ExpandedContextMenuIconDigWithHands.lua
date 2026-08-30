--[[
local originalDoFarmingMenu = ISFarmingMenu.doFarmingMenu;

function ISFarmingMenu.doFarmingMenu(player, context, worldobjects, test)
    originalDoFarmingMenu(player, context, worldobjects, test);
    --if not context then return context end
    --if type(context) ~= "table" then return context end
    local option = context:getOptionFromName(getText("ContextMenu_DigWithHands"));
	--if not option then return end;
    if option then
        option.iconTexture = getTexture(getExpandedIconPath("GrabAll.png"));
    end
end
--]]