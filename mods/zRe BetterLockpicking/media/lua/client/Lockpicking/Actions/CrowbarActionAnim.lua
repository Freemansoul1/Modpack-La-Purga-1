require "TimedActions/ISBaseTimedAction"
require "Lockpicking/Crowbar/CrowbarWindow"

CrowbarActionAnim = ISBaseTimedAction:derive("CrowbarActionAnim")

function CrowbarActionAnim:isValid()
	if self.lockpick_object == door or self.lockpick_object == window then
		return true;
	 else
		return self.lockpick_object:getVehicle():isStopped()
	end
end

function CrowbarActionAnim:waitToStart()
	if self.lockpick_object == door or self.lockpick_object == window then
		self.character:faceThisObject(self.lockpick_object)
		return self.character:shouldBeTurning()
	 else
		self.character:faceThisObject(self.lockpick_object:getVehicle())
		return self.character:shouldBeTurning()
	end
end

function CrowbarActionAnim:update()
	local uispeed = UIManager.getSpeedControls():getCurrentGameSpeed()
    if uispeed ~= 1 then
        UIManager.getSpeedControls():SetCurrentGameSpeed(1)
	end
	
	if not self.sound or not self.sound:isPlaying() then
		self.sound = getSoundManager():PlayWorldSound("zReBL_crowbarSound", self.character:getCurrentSquare(), 1, 25, 2, true)
	end

	if self.lockpick_object == door or self.lockpick_object == window then
		self.character:faceThisObject(self.lockpick_object)	
	 else
		self.character:faceThisObject(self.lockpick_object:getVehicle())
	end
end

function CrowbarActionAnim:start()
	if self.isGarage then
		self:setActionAnim("CrowbarGarageAction")
	 else
		self:setActionAnim("CrowbarAction")
	end
	
	self.character:getModData().zReBLStopFlag = 0
end

function CrowbarActionAnim:stop()
	getSoundManager():StopSound(self.sound)
	
	if self.character:getModData().zReBLStopFlag == 0 then
		CrowbarWindow.instance:close()
		self.character:getModData().zReBLStopFlag = 1
	end
	
	ISBaseTimedAction.stop(self)
end

function CrowbarActionAnim:perform()
	getSoundManager():StopSound(self.sound)
	ISBaseTimedAction.perform(self)
end

function CrowbarActionAnim:new(character, isGarage, lockpick_object)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.lockpick_object = lockpick_object
	o.maxTime = 50000
	o.isGarage = isGarage
	
	return o
end