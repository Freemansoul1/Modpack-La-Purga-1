---------------------------------------------------------------------------------------------------------------------------------------------------------------------
local CAMmod = require "CorpsesAutoMove/CorpsesAutoMove_Functions"
--CAMmod or {}
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
CAMmod.onFillWorldObjectContextMenu = function(playerId, context, worldobjects, test)
	local player = getSpecificPlayer(playerId)
    if test or getCore():getGameMode() == 'LastStand' or not player or player:getVehicle() then return end
    local clickedPlayer
    for i, v in ipairs(worldobjects) do
        local movingObjects = v:getSquare():getMovingObjects()
        for i = 0, movingObjects:size() - 1 do
            local o = movingObjects:get(i)
            if instanceof(o, "IsoPlayer") and o == player then
                clickedPlayer = o
                break
            end
        end
    end
    if clickedPlayer or IsoObjectPicker.Instance:PickCorpse(getMouseX(), getMouseY()) then
        local KeyMenu = context:addOption(getText("IGUI_CAMmod_ContextMenu_cleanUpCorpses"),nil,function() 
            if player:getVehicle() then return end
            local square = player:getCurrentSquare()
            local ui = CAMmod.UI:new(0, 0, player, square);
            ui:initialise();
            ui:addToUIManager();
        end);
        KeyMenu.iconTexture = getTexture("media/ui/CAMmod_takeContextIcon.png");
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Events.OnFillWorldObjectContextMenu.Add(CAMmod.onFillWorldObjectContextMenu)

return CAMmod