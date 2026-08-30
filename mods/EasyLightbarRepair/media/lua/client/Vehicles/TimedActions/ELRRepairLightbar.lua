--***********************************************************
--**                    Based on code by                   **
--**                                                       **
--**                    THE INDIE STONE                    **
--***********************************************************

require "TimedActions/ISBaseTimedAction"

ELRRepairLightbar = ISBaseTimedAction:derive("ELRRepairLightbar")

function ELRRepairLightbar:isValid()
--	return self.vehicle:isInArea(self.part:getArea(), self.character)
	return true
end

function ELRRepairLightbar:waitToStart()
	self.character:faceThisObject(self.vehicle)
	return self.character:shouldBeTurning()
end

function ELRRepairLightbar:update()
	self.character:faceThisObject(self.vehicle)
	self.item:setJobDelta(self:getJobDelta())

    self.character:setMetabolicTarget(Metabolics.MediumWork)
end

function ELRRepairLightbar:start()
	self.item:setJobType(self.jobType)
	
	-- Todo? - Find a better animation for working on a raised object
	self:setActionAnim("VehicleWorkOnMid")
end

function ELRRepairLightbar:stop()
	self.item:setJobDelta(0)
	ISBaseTimedAction.stop(self)
end

function ELRRepairLightbar:perform()
	ISBaseTimedAction.perform(self)
	self.item:setJobDelta(0)
	
	sendClientCommand(self.character, 'ELR_vehicle', 'repairLightbar', { vehicle = self.part:getVehicle():getId(), part = self.part:getId(), repairBlocks = self.repairBlocks, targetCondition = self.targetCondition, repairParts = self.requiredParts })
end

function ELRRepairLightbar:new(character, part, item, timeToRepair, repairBlocks, requiredParts, targetCondition)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.vehicle = part:getVehicle()
	o.part = part
	o.item = item
	o.maxTime = timeToRepair
	
	o.repairBlocks = repairBlocks
	o.requiredParts = requiredParts
	o.targetCondition = targetCondition
	
	o.jobType = getText("ContextMenu_Repair")..' '..getText("IGUI_VehiclePartlightbar")
	return o
end


