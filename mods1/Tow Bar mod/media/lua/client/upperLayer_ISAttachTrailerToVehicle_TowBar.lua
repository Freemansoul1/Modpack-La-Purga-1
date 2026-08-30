--***********************************************************
--**                    AuD                                **
--***********************************************************

require "Vehicles/TimedActions/ISAttachTrailerToVehicle"
--require "TimedActions/ISBaseTimedAction"
-----------------------------------------------------------------------------------------------------------------------------------------------------------
local upperLayer = {}
upperLayer.ISAttachTrailerToVehicle = {}
local msgTest
-----------------------------------------------------------------------------------------------------------------------------------------------------------
upperLayer.ISAttachTrailerToVehicle.isValid = ISAttachTrailerToVehicle.isValid
function ISAttachTrailerToVehicle:isValid()
    upperLayer.ISAttachTrailerToVehicle.isValid(self)
    if (not string.contains(self.vehicleA:getScriptName(), "Trailer") and not string.contains(self.vehicleA:getScriptName(), "trailer")) and (not string.contains(self.vehicleB:getScriptName(), "Trailer") and not string.contains(self.vehicleB:getScriptName(), "trailer")) then 
    	
    	local bar = self.character:getInventory():getItemFromType("TowBarCar")
    	if not bar then 
    		if msgTest == nil then msgTest = true ; self.character:Say(getText("IGUI_noTowBar")) else msgTest = nil end
    		return false
    	elseif bar then
    		self.TowBar = bar
    	end
    end
    return self.vehicleA:getVehicleTowing() == nil
end

upperLayer.ISAttachTrailerToVehicle.perform = ISAttachTrailerToVehicle.perform
function ISAttachTrailerToVehicle:perform()
    upperLayer.ISAttachTrailerToVehicle.perform(self)
	local squareBis = self.vehicleA:getCurrentSquare()
	local vehicleBbis = ISVehicleTrailerUtils.getTowableVehicleNear(squareBis, self.vehicleA, self.attachmentA, self.attachmentB)
	if vehicleBbis == self.vehicleB and self.TowBar then
		self.character:removeFromHands(self.TowBar)
		self.character:getInventory():DoRemoveItem(self.TowBar) 
		local pdata = getPlayerData(self.character:getPlayerNum())
		if pdata ~= nil then
			pdata.playerInventory:refreshBackpacks()
			pdata.lootInventory:refreshBackpacks()
		end		
	end
end