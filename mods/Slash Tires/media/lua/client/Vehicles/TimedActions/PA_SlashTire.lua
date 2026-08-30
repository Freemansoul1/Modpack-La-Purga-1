-- --***********************************************************
-- --**                THE PLANET ALGOL IS STONED             **
-- --***********************************************************

require "TimedActions/ISBaseTimedAction"

PA_SlashTire = ISBaseTimedAction:derive("PA_SlashTire")

function PA_SlashTire:isValid()
	if ISVehicleMechanics.cheat then return true; end
	-- return self.part:getInventoryItem() and self.vehicle:canUninstallPart(self.character, self.part)
	return true
end

function PA_SlashTire:waitToStart()
	self.character:faceThisObject(self.vehicle)
	return self.character:shouldBeTurning()
end

function PA_SlashTire:update()
	self.character:faceThisObject(self.vehicle)
    self.character:setMetabolicTarget(Metabolics.MediumWork);
end

function PA_SlashTire:start()
	
	self.character:getEmitter():playSound("HuntingKnifeHit")
	-- self.character:getEmitter():playSound("WireCutting")
	
    -- self.sound = self.character:playSound("WireCutting");
	-- if self.part:getWheelIndex() ~= -1 or self.part:getId():contains("Brake") then
		self:setActionAnim("VehicleWorkOnTire")
	-- else
		-- self:setActionAnim("VehicleWorkOnMid")
	-- end
--	self:setOverrideHandModels(nil, nil)
end

function PA_SlashTire:stop()
	-- if self.character:getEmitter():isPlaying(self.sound) then
		-- self.character:getEmitter():stopSound(self.sound)
	-- end
    ISBaseTimedAction.stop(self)
end

function PA_SlashTire:perform()
	self.item:setCondition(self.item:getCondition() - 1)
	self.character:getEmitter():playSound("HuntingKnifeHit")
	-- self.character:getEmitter():playSound("VehicleTireExplode")
	local args = { vehicle = self.vehicle:getId(), part = self.part:getId(), psi = 0 }
	sendClientCommand(self.character, 'vehicle', 'setTirePressure', args)
	local args = { vehicle = self.vehicle:getId(), part = self.part:getId(), condition = 0 }
	sendClientCommand(self.character, 'vehicle', 'setPartCondition', args)
	local userName = self.character:getUsername()
	local cutLog = tostring(userName .. " slashed a tire on " .. tostring(self.vehicle:getScriptName()) .. " / " ..  tostring(self.vehicle:getId()) .. " at " .. tostring(math.floor(self.character:getX())) .. " / " .. tostring(math.floor(self.character:getY())))
	local args = { cutLog = cutLog }
	sendClientCommand(self.character, 'PA_SlashTire', 'SlashTire', args)
	-- if self.character:getEmitter():isPlaying(self.sound) then
		-- self.character:getEmitter():stopSound(self.sound)
	-- end
	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)
end

function PA_SlashTire:new(character, part, item)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.vehicle = part:getVehicle()
	o.part = part
	o.item = item
	o.maxTime = 100
	if character:isTimedActionInstant() then
		o.maxTime = 1;
	end
	if ISVehicleMechanics.cheat then o.maxTime = 1; end
	-- o.jobType = getText("Tooltip_Vehicle_Uninstalling", part:getInventoryItem():getDisplayName());
	return o
end

