require "Vehicles/ISUI/ISVehicleMenu"

local function predicateNotBroken(item)
	return not item:isBroken()
end
local function predicateNotBrokenOrAxe(item)
	return not item:isBroken() and not item:hasTag("ChopTree")
end
local old_ISVehicleMenu_FillPartMenu = ISVehicleMenu.FillPartMenu

function ISVehicleMenu.FillPartMenu(playerIndex, context, slice, vehicle)

	local playerObj = getSpecificPlayer(playerIndex)
	local playerInv = playerObj:getInventory()
	if playerInv:containsTagEvalRecurse("Knife", predicateNotBroken) or playerInv:containsTagEvalRecurse("CutPlant", predicateNotBrokenOrAxe) or playerInv:getFirstTypeEvalRecurse("Bayonnet", predicateNotBroken) then
		for i=1,vehicle:getPartCount() do
			local part = vehicle:getPartByIndex(i-1)		
			local partID = part:getId()
			local area = part:getArea()
			if partID and partID:contains("Tire") and area and vehicle:isInArea(area, playerObj) and part:getCondition() > 0 then
				-- if ISVehiclePartMenu.getPropaneTankNotFull(playerObj, typeToItem)
				-- and part:getContainerContentAmount() > 0 then
					if slice then
						slice:addSlice(getText("IGUI_Slash_Tire"), getTexture("Item_CarTire"), ISVehiclePartMenu.onSlashTire, playerObj, part)
					else
						context:addOption(getText("IGUI_Slash_Tire"), playerObj, ISVehiclePartMenu.onSlashTire, part)
					end
				-- end		
			end			
		end
	end
	old_ISVehicleMenu_FillPartMenu(playerIndex, context, slice, vehicle)
end
