--***********************************************************
--**                THE PLANET ALGOL IS STONED             **
--***********************************************************
require "Vehicle/ISVehiclePartMenu"
local function predicateNotBroken(item)
	return not item:isBroken()
end

function ISVehiclePartMenu.onCutBrakes(playerObj, part)
	local playerInv = playerObj:getInventory()
	local item = playerInv:getFirstTagEvalRecurse("Pliers", predicateNotBroken) or  playerInv:getFirstTagEvalRecurse("Plier", predicateNotBroken)
	
	if item then
		ISTimedActionQueue.add(ISPathFindAction:pathToVehicleArea(playerObj, part:getVehicle(), part:getArea()))
		ISInventoryPaneContextMenu.equipWeapon(item, true, false, playerObj:getPlayerNum())
		--ISTimedActionQueue.add(FuelTruck_TakePropaneFromVehicle:new(playerObj, part, item, 50))
		ISTimedActionQueue.add(PA_CutBrakeLine:new(playerObj, part, 500))
	end
end


