require "ISUI/ISWorldObjectContextMenu"

require "RainBarrel/CRainBarrelSystem"
require "MetalDrum/CMetalDrumSystem"

require "rWaterTrailer"

rWaterTrailer.Barrels = rWaterTrailer.Barrels or {}

-- main hook; not using Events.X.Add() here, as we want new context entries near vanilla water-related stuff --

local ISWOCM_addWaterFromItem = ISWorldObjectContextMenu.addWaterFromItem
function ISWorldObjectContextMenu.addWaterFromItem(test, context, worldobjects, player, playerInv, ...)

	local result = ISWOCM_addWaterFromItem(test, context, worldobjects, player, playerInv, ...)

	local canGive, canTake, object

	for _,obj in ipairs(worldobjects) do

		if instanceof(obj, "IsoClothingWasher") or instanceof(obj, "IsoClothingDryer") then
			-- skip --
		elseif CRainBarrelSystem:isValidIsoObject(obj) then
			canGive = obj:getWaterAmount() > 0
			canTake = obj:getWaterAmount() < obj:getWaterMax()
		elseif CMetalDrumSystem:isValidIsoObject(obj) and obj:hasModData() and not obj:getModData().isLit and not obj:getModData().haveLogs and not obj:getModData().haveCharcoal then
			canGive = obj:getWaterAmount() > 0
			canTake = obj:getWaterAmount() < obj:getWaterMax()
		end

		if canGive or canTake then
			object = obj
			break
		end
	end

	if object and (canGive or canTake) then
		rWaterTrailer.Barrels.Menu(player, object, canGive, canTake, context)
	end

	return result
end

--

function rWaterTrailer.Barrels.Menu(player, object, canGive, canTake, context)
	local trailer = rWaterTrailer.Find(object:getSquare(), rWaterTrailer.GetPumpRange("max"))
	local tank = rWaterTrailer.GetWaterStorage(trailer)
	if not trailer or not tank then
		return
	end

	if canGive and tank:getContainerContentAmount() < tank:getContainerCapacity() then -- tank not full --
		context:addOption(getText("ContextMenu_Add_Water_To_Trailer"), player, rWaterTrailer.OnTransferWater, trailer, tank, "<-", object)
	end

	if canTake and tank:getContainerContentAmount() > 0 then -- tank not empty
		context:addOption(getText("ContextMenu_VehicleSiphonWater"), player, rWaterTrailer.OnTransferWater, trailer, tank, "->", object)
	end
end
