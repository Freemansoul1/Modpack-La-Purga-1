require 'TimedActions/ISBaseTimedAction'

local stateMap, CheckAndUpdateSprite = unpack(require 'SteamGeneratorLEDs')

ISSteamGeneratorAddFuel = ISBaseTimedAction:derive('ISSteamGeneratorAddFuel')

function ISSteamGeneratorAddFuel:isValid()
	return self.generator:getObjectIndex() ~= -1 and
		self.character:getInventory():contains(self.item) and
		self.generator:getFuel() < 100
end

function ISSteamGeneratorAddFuel:waitToStart()
	self.character:faceThisObject(self.generator)
	return self.character:shouldBeTurning()
end

function ISSteamGeneratorAddFuel:update()
	self.character:faceThisObject(self.generator)
	self.item:setJobDelta(self:getJobDelta())
	
	self.character:setMetabolicTarget(Metabolics.HeavyDomestic)
end

function ISSteamGeneratorAddFuel:start()
	self.item:setJobType(campingText.addFuel)
	self.item:setJobDelta(0)
	self:setActionAnim('Loot')
	self.character:SetVariable('LootPosition', 'Low')
end

function ISSteamGeneratorAddFuel:stop()
	ISBaseTimedAction.stop(self)
	self.item:setJobDelta(0)
end

function ISSteamGeneratorAddFuel:perform()
	ISBaseTimedAction.perform(self)
	self.item:setJobDelta(0)
	self.generator:setFuel(self.generator:getFuel() + 5)
	self.character:removeFromHands(self.item)
	local inv = self.character:getInventory()
	if self.item:getName():find('Charcoal') then
		self.item:Use()
	else
		inv:Remove(self.item)
	end
	CheckAndUpdateSprite(self.generator)
	local nextLog = inv:getFirstTypeRecurse('Base.Charcoal') or inv:getFirstTypeRecurse('Base.Log')
	if nextLog then
		ISTimedActionQueue.add(ISSteamGeneratorAddFuel:new(self.character, self.generator, nextLog, self.maxTime))
	end
end

function ISSteamGeneratorAddFuel:new(character, generator, log, time)
	local o = setmetatable({}, self)
	o.character = character
	o.stopOnWalk = true
	o.stopOnRun = true
	o.maxTime = character:isTimedActionInstant() and 1 or time
	o.generator = generator
	o.item = log
	return o
end

ISSteamGeneratorAddFuel.__index = ISSteamGeneratorAddFuel
