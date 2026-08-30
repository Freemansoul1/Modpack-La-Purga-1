require "TimedActions/ISBaseTimedAction"
require "Lockpicking/Crowbar/CrowbarWindow"

BobbyPinActionAnim = ISBaseTimedAction:derive("BobbyPinActionAnim")

function BobbyPinActionAnim:isValid()
	if self.lockpick_object == door or self.lockpick_object == window then
		return true
	 else
		return self.lockpick_object:getVehicle():isStopped()
	end
end

function BobbyPinActionAnim:waitToStart()
	if self.lockpick_object == door or self.lockpick_object == window then
		self.character:faceThisObject(self.lockpick_object)
		return self.character:shouldBeTurning()
	 else
		self.character:faceThisObject(self.lockpick_object:getVehicle())
		return self.character:shouldBeTurning()
	end
end

function BobbyPinActionAnim:update()
	local uispeed = UIManager.getSpeedControls():getCurrentGameSpeed()
    if uispeed ~= 1 then
        UIManager.getSpeedControls():SetCurrentGameSpeed(1)
    end
	
	if self.lockpick_object == door or self.lockpick_object == window then
		self.character:faceThisObject(self.lockpick_object)	
	 else
		self.character:faceThisObject(self.lockpick_object:getVehicle())
	end
end

function BobbyPinActionAnim:start()
	self:setActionAnim("Picklock")
	
	self.character:getModData().zReBLStopFlag = 0
end

function BobbyPinActionAnim:stop()
	if self.character:getModData().zReBLStopFlag == 0 then
		BobbyPinWindow.instance:close()
		self.character:getModData().zReBLStopFlag = 1
	end
	
	ISBaseTimedAction.stop(self)
end

function BobbyPinActionAnim:perform()
	ISBaseTimedAction.perform(self)
end

function BobbyPinActionAnim:new(character, lockpick_object)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.lockpick_object = lockpick_object
	o.maxTime = 50000
	
	return o
end




