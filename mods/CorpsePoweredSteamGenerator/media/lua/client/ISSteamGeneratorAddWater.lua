require 'TimedActions/ISBaseTimedAction'

ISSteamGeneratorAddWater = ISBaseTimedAction:derive('ISSteamGeneratorAddWater')

function ISSteamGeneratorAddWater:isValid()
	return self.generator:getObjectIndex() ~= -1 and self.character:getInventory():contains(self.item)
end

function ISSteamGeneratorAddWater:waitToStart()
	self.character:faceThisObject(self.generator)
	return self.character:shouldBeTurning()
end

function ISSteamGeneratorAddWater:update()
	self.character:faceThisObject(self.generator)
	self.item:setJobDelta(self:getJobDelta())
	local unitsSoFar = math.floor(self.addUnits * self:getJobDelta())
	self.item:setUsedDelta(self.itemFromStartDelta - unitsSoFar * self.item:getUsedDelta())
	
	self.character:setMetabolicTarget(Metabolics.LightDomestic)
end

function ISSteamGeneratorAddWater:start()
	self.item:setJobType(getText("ContextMenu_AddWaterFromItem"))
	self.item:setJobDelta(0)
	self.itemFromStartDelta = self.item:getUsedDelta()
	local waterAvailable = self.item:getUsedDelta() / self.item:getUseDelta()
	waterAvailable = (waterAvailable - math.floor(waterAvailable) > 0.99) and math.ceil(waterAvailable) or waterAvailable
	local modData = self.generator:getModData()
	local water = modData.water or 0
	local destCapacity = 100 - water
	self.addUnits = math.min(destCapacity, waterAvailable)
	self.action:setTime(math.max(6, self.addUnits) * 7)
	self.sound = self.character:playSound("PourWaterIntoObject")
	
	self:setActionAnim('Loot')
	self.character:SetVariable('LootPosition', 'High')
	self.character:reportEvent('EventTakeWater')
end

function ISSteamGeneratorAddWater:stop()
	self:stopSound()
	self.item:setJobDelta(0)
	if self.addUnits and self.addUnits > 0 then
		local unitsSoFar = math.floor(self.addUnits * self:getJobDelta())
		self.item:setUsedDelta(self.itemFromStartDelta - unitsSoFar * self.item:getUseDelta())
		if self.item:getUsedDelta() < 0.0001 then
			self.item:Use()
		end
		local modData = self.generator:getModData()
		modData.water = math.min(100, modData.water + unitsSoFar)
		self.generator:transmitModData()
	end
	ISBaseTimedAction.stop(self)
end

function ISSteamGeneratorAddWater:perform()
	self:stopSound()
	self.item:getContainer():setDrawDirty(true)
	self.item:setJobDelta(0)
	self.item:setUsedDelta(self.itemFromStartDelta - self.addUnits * self.item:getUseDelta())
	if self.item:getUsedDelta() < 0.0001 then
		self.item:Use()
	end
	local modData = self.generator:getModData()
	modData.water = math.min(100, (modData.water or 0) + self.addUnits)
	self.generator:transmitModData()
	ISBaseTimedAction.perform(self)
end

function ISSteamGeneratorAddWater:stopSound()
	if self.sound and self.character:getEmitter():isPlaying(self.sound) then
		self.character:stopOrTriggerSound(self.sound)
	end
end

function ISSteamGeneratorAddWater:new(character, generator, item, time)
	local o = setmetatable({}, self)
	o.character = character
	o.stopOnWalk = true
	o.stopOnRun = true
	o.maxTime = character:isTimedActionInstant() and 1 or time
	o.generator = generator
	o.item = item
	return o
end
