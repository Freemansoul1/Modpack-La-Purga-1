--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

require "TimedActions/ISBaseTimedAction"

CentralizedLockVehicleDoor = ISBaseTimedAction:derive("CentralizedLockVehicleDoor")

function CentralizedLockVehicleDoor:isValid()
	return self.part:getDoor() and not self.part:getDoor():isLocked()
end

function CentralizedLockVehicleDoor:update()
	if not self.character:getVehicle() then
		self.character:faceThisObject(self.vehicle)
	end
end

function CentralizedLockVehicleDoor:start()
	self.vehicle:playPartSound(self.part, self.character, "Lock")
end

function CentralizedLockVehicleDoor:stop()
	ISBaseTimedAction.stop(self)
end

function CentralizedLockVehicleDoor:perform()
	--local args = { vehicle = self.vehicle:getId(), part = self.part:getId(), locked = true }
	--sendClientCommand(self.character, 'vehicle', 'setDoorLocked', args)
--
--	---- needed to remove from queue / start next.
	--ISBaseTimedAction.perform(self)

	local vehicleInside = self.character:getVehicle()

	if not vehicleInside then 

		self.character:faceThisObject(self.vehicle)
		self.character:Say("locked")

		local args = { vehicle = self.vehicle:getId(), locked = true }
		sendClientCommand(self.character, 'vehiclebis2', 'setTrunkLocked', args)--{ locked = false })
	
		for seat=1,self.vehicle:getMaxPassengers() do
			local part = self.vehicle:getPassengerDoor(seat-1)
			if part then
				local args = { vehicle = self.vehicle:getId(), part = part:getId(), locked = true }
				sendClientCommand(self.character, 'vehicle', 'setDoorLocked', args)
				
			end
		end
	else	
		local args = { vehicle = self.vehicle:getId(), part = self.part:getId(), locked = true }
		sendClientCommand(self.character, 'vehicle', 'setDoorLocked', args)
	end
	
	ISBaseTimedAction.perform(self)
end

function CentralizedLockVehicleDoor:new(character, part, vehicle)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.vehicle = vehicle
	o.part = part
	o.maxTime = 0
	return o
end

