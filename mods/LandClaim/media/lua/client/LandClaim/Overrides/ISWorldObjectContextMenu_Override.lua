local SafehouseController = require "LandClaim/SafehouseController"

local function canDestroy(player, worldobjects)
	for _, object in ipairs(worldobjects) do
		if SafehouseController.CanDestroy(player, object:getSquare()) then
			return true
		end
	end
end

local ISWorldObjectContextMenu_onDestroy = ISWorldObjectContextMenu.onDestroy
function ISWorldObjectContextMenu.onDestroy(worldobjects, player, sledgehammer)
	if canDestroy(player, worldobjects) then
		return ISWorldObjectContextMenu_onDestroy(worldobjects, player, sledgehammer)
	end

	player:setHaloNote(getText("You don't have permission to destroy in this Land Claim!"))
end