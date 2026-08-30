--***********************************************************
--**                THE PLANET ALGOL IS STONED             **
--***********************************************************
require "Vehicle/ISVehiclePartMenu"
local function predicateNotBroken(item)
	return not item:isBroken()
end
local function predicateNotBrokenOrAxe(item)
	return not item:isBroken() and not item:hasTag("ChopTree")
end

function ISVehiclePartMenu.onSlashTire(playerObj, part)
	local playerInv = playerObj:getInventory()
	local item = playerInv:getFirstTagEvalRecurse("Knife", predicateNotBroken) or  playerInv:getFirstTagEvalRecurse("CutPlant", predicateNotBrokenOrAxe) or playerInv:getFirstTypeEvalRecurse("Bayonnet", predicateNotBroken)
	
	if item then
		ISTimedActionQueue.add(ISPathFindAction:pathToVehicleArea(playerObj, part:getVehicle(), part:getArea()))
		ISInventoryPaneContextMenu.equipWeapon(item, true, false, playerObj:getPlayerNum())
		--ISTimedActionQueue.add(FuelTruck_TakePropaneFromVehicle:new(playerObj, part, item, 50))
		ISTimedActionQueue.add(PA_SlashTire:new(playerObj, part, item))
	end
end


