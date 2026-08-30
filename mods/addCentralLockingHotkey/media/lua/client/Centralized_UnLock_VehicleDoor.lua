--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

require "TimedActions/ISBaseTimedAction"

CentralizedUnLockVehicleDoor = ISBaseTimedAction:derive("CentralizedUnLockVehicleDoor")

function CentralizedUnLockVehicleDoor:isValid()
	--print("CentralizedUnLockVehicleDoor:isValid()")
	--print(self.part:getDoor() and self.part:getDoor():isLocked())
	return self.part:getDoor() and (self.forceValid or self.part:getDoor():isLocked())
end

function CentralizedUnLockVehicleDoor:update()
	if not self.character:getVehicle() then
		self.character:faceThisObject(self.vehicle)
	end
	--print("CentralizedUnLockVehicleDoor:update()")
	-- TODO: drunk/panic = fumble
end

function CentralizedUnLockVehicleDoor:start()
	if not self.character:getVehicle() then
		self.character:faceThisObject(self.vehicle)
		
	end
	self.character:Say("unlocked")

	self.vehicle:toggleLockedDoor(self.part, self.character, false)
	if self.part:getDoor():isLocked() then
		if self.part:getDoor():isLockBroken() then
			self.character:Say(getText("IGUI_PlayerText_VehicleLockIsBroken"))
		end
		self.vehicle:playPartSound(self.part, self.character, "IsLocked");
		self:forceStop();
        return;
	end
	self.vehicle:playPartSound(self.part, self.character, "Unlock")
	if isClient() then
		--local args = { vehicle = self.vehicle:getId(), part = self.part:getId(), locked = false }
		--sendClientCommand(self.character, 'vehicle', 'setDoorLocked', args)
		--local args = { vehicle = self.vehicle:getId(), locked = false }
		--sendClientCommand(self.character, 'vehicle', 'setTrunkLocked', args)
		local vehicleInside = self.character:getVehicle()

		if not vehicleInside then 
	
			local args = { vehicle = self.vehicle:getId(), locked = false }
			sendClientCommand(self.character, 'vehiclebis2', 'setTrunkLocked', args)--{ locked = false })
		
			for seat=1,self.vehicle:getMaxPassengers() do
				local part = self.vehicle:getPassengerDoor(seat-1)
				if part then
					local args = { vehicle = self.vehicle:getId(), part = part:getId(), locked = false }
					sendClientCommand(self.character, 'vehicle', 'setDoorLocked', args)
					
				end
			end
		else	
			local args = { vehicle = self.vehicle:getId(), part = self.part:getId(), locked = false }
			sendClientCommand(self.character, 'vehicle', 'setDoorLocked', args)
		end

	end
	-- isValid() will return false since the door isn't locked now
	self.forceValid = true
	self:forceComplete()
end

function CentralizedUnLockVehicleDoor:stop()
	ISBaseTimedAction.stop(self)
end

function CentralizedUnLockVehicleDoor:perform()
	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)
end

function CentralizedUnLockVehicleDoor:new(character, part, vehicle)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.vehicle = vehicle
	o.part = part
	--o.seat = seat
	o.forceValid = false
	o.maxTime = -1
	return o
end

