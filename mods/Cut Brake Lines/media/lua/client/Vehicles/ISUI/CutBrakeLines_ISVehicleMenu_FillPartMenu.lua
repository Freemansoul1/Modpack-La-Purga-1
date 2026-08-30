require "Vehicles/ISUI/ISVehicleMenu"

local function predicateNotBroken(item)
	return not item:isBroken()
end

local old_ISVehicleMenu_FillPartMenu = ISVehicleMenu.FillPartMenu

function ISVehicleMenu.FillPartMenu(playerIndex, context, slice, vehicle)

	local playerObj = getSpecificPlayer(playerIndex)
	local playerInv = playerObj:getInventory()
	local typeToItem = VehicleUtils.getItems(playerIndex)
	if playerInv:containsTagEvalRecurse("Pliers", predicateNotBroken)
	or playerInv:containsTagEvalRecurse("Plier", predicateNotBroken)
	and ( playerObj:getPerkLevel(Perks.Mechanics) >= 3
	or playerObj:getKnownRecipes():contains("Cut Brake Lines") or playerObj:getKnownRecipes():contains("Basic Mechanics")
	or playerObj:getKnownRecipes():contains("Intermediate Mechanics") or playerObj:getKnownRecipes():contains("Advanced Mechanics") ) then
		for i=1,vehicle:getPartCount() do
			local part = vehicle:getPartByIndex(i-1)		
			local partID = part:getId()
			local area = part:getArea()
			if partID and partID:contains("Brake") and area and vehicle:isInArea(area, playerObj) and part:getCondition() > 0 then
				-- if ISVehiclePartMenu.getPropaneTankNotFull(playerObj, typeToItem)
				-- and part:getContainerContentAmount() > 0 then
					if slice then
						slice:addSlice(getText("IGUI_Cut_Brake_Line"), getTexture("Item_CarBrakes"), ISVehiclePartMenu.onCutBrakes, playerObj, part)
					else
						context:addOption(getText("IGUI_Cut_Brake_Line"), playerObj, ISVehiclePartMenu.onCutBrakes, part)
					end
				-- end		
			end			
		end
	end
	old_ISVehicleMenu_FillPartMenu(playerIndex, context, slice, vehicle)
end
