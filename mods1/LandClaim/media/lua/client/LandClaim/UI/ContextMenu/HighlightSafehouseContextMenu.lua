local SafehouseController = require "LandClaim/SafehouseController"

local function highlightSafehouse(square)
    SafehouseController.HighlightSafehouse(square)
end

local function HighlightSafehouseContextMenu(playerIndex, context, worldObjects, test)
	local player = getSpecificPlayer(playerIndex);
    local inventory = player:getInventory();
    local square;
    local target;

    if player:getVehicle() then return end

    for i,v in ipairs(worldObjects) do
        square = v:getSquare();
        break
    end

    if not square then return end

    if isAdmin() or SafehouseController.IsPlayerAllowedBySquare(player, square) then
        context:addOption(getText("Highlight Land Claim"), square, highlightSafehouse);
    end
end

Events.OnFillWorldObjectContextMenu.Add(HighlightSafehouseContextMenu)