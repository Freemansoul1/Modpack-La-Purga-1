--***********************************************************
--**                    AuD                                **
--***********************************************************

require "Vehicles/TimedActions/ISDetachTrailerFromVehicle"
-----------------------------------------------------------------------------------------------------------------------------------------------------------
local upperLayer = {}
upperLayer.ISDetachTrailerFromVehicle = {}
local text_double_FIX
-----------------------------------------------------------------------------------------------------------------------------------------------------------
upperLayer.ISDetachTrailerFromVehicle.isValid = ISDetachTrailerFromVehicle.isValid
function ISDetachTrailerFromVehicle:isValid()
    upperLayer.ISDetachTrailerFromVehicle.isValid(self)

    self.TowBar = false
    self.Trailer = false
    local square = self.character:getSquare()
	for y=square:getY() -5,square:getY()+5 do
		for x=square:getX()-5,square:getX()+5 do
			local square2 = getCell():getGridSquare(x, y, square:getZ())
			if square2 then
				for i=1,square2:getMovingObjects():size() do
					local obj = square2:getMovingObjects():get(i-1)
					if instanceof(obj, "BaseVehicle") and obj ~= self.vehicle and obj:getVehicleTowedBy() and obj:getVehicleTowedBy():getTowAttachmentSelf() and (not string.contains(obj:getScriptName(), "Trailer") and not string.contains(obj:getScriptName(), "trailer")) then
						self.TowBar = true
					elseif instanceof(obj, "BaseVehicle") and obj ~= self.vehicle and obj:getVehicleTowedBy() and obj:getVehicleTowedBy():getTowAttachmentSelf() and (string.contains(obj:getScriptName(), "Trailer") and not string.contains(obj:getScriptName(), "trailer")) then
						self.Trailer = true
					end
				end
			end
		end
	end
	if self.Trailer == true and self.TowBar == true then if msgTest == nil then msgTest = true ; self.character:Say(getText("UI_impossibleTrailerTooNear")) else msgTest = nil end return false end
				
	return self.vehicle:getVehicleTowing() ~= nil
end

upperLayer.ISDetachTrailerFromVehicle.perform = ISDetachTrailerFromVehicle.perform
function ISDetachTrailerFromVehicle:perform()
    upperLayer.ISDetachTrailerFromVehicle.perform(self)
	if self.TowBar == true then
        local item = self.character:getInventory():AddItem("TowBarCar")
		self.character:setPrimaryHandItem(nil);
        self.character:setSecondaryHandItem(nil);
		self.character:setPrimaryHandItem(item);
		self.character:setSecondaryHandItem(item);
	end
end	
