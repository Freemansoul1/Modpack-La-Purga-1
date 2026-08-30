require 'TimedActions/ISBaseTimedAction'

local stateMap, CheckAndUpdateSprite = unpack(require 'SteamGeneratorLEDs')

ISSteamGeneratorAddCorpse = ISBaseTimedAction:derive('ISSteamGeneratorAddCorpse')

function ISSteamGeneratorAddCorpse:isValid() -- TODO
	return self.generator:getObjectIndex() ~= -1 and
		self.character:getPrimaryHandItem() == self.item and
		self.generator:getFuel() < 100
end

function ISSteamGeneratorAddCorpse:waitToStart()
	self.character:faceThisObject(self.generator)
	return self.character:shouldBeTurning()
end

function ISSteamGeneratorAddCorpse:update()
	self.character:faceThisObject(self.generator)
	self.item:setJobDelta(self:getJobDelta())
	
	self.character:setMetabolicTarget(Metabolics.HeavyDomestic)
end

function ISSteamGeneratorAddCorpse:start()
	self.item:setJobType(campingText.addFuel)
	self.item:setJobDelta(0)
	self:setActionAnim('Loot')
	self.character:SetVariable('LootPosition', 'Low')
end

function ISSteamGeneratorAddCorpse:stop()
	ISBaseTimedAction.stop(self)
	self.item:setJobDelta(0)
end

function ISSteamGeneratorAddCorpse:perform()
	ISBaseTimedAction.perform(self)
	self.item:setJobDelta(0)
	self.generator:setFuel(self.generator:getFuel() + 5)
	self.character:setSecondaryHandItem(nil);
	self.character:setPrimaryHandItem(nil);
	self.character:getInventory():Remove(self.item);
	CheckAndUpdateSprite(self.generator)
end

function ISSteamGeneratorAddCorpse:new(character, generator, corpse, time)
	local o = setmetatable({}, self)
	o.character = character
	o.stopOnWalk = true
	o.stopOnRun = true
	o.maxTime = character:isTimedActionInstant() and 1 or time
	o.generator = generator
	o.item = corpse
	return o
end

ISSteamGeneratorAddCorpse.__index = ISSteamGeneratorAddCorpse
