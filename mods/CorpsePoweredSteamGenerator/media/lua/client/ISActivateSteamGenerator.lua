require 'TimedActions/ISActivateGenerator'

local stateMap, CheckAndUpdateSprite = unpack(require 'SteamGeneratorLEDs')

ISActivateSteamGenerator = ISActivateGenerator:derive('ISActivateSteamGenerator')

local function atLeastOneUnit(item)
	return item:getUsedDelta() >= item:getUseDelta()
end

function ISActivateSteamGenerator:isValid(...)
	local inv = self.character and self.character:getInventory()
	return ISActivateGenerator.isValid(self, ...) and (not self.activate or (inv and
		(inv:getUsesTypeRecurse('Lighter') >= 1 or inv:getUsesTypeRecurse('Matches') >= 1)))
end

function ISActivateSteamGenerator:perform(...)
	local inv = self.character:getInventory()
	local item = inv:getFirstTypeEvalRecurse('Matches', atLeastOneUnit) or inv:getFirstTypeEvalRecurse('Lighter', atLeastOneUnit)
	if self.activate then
		if not item then
			return ISBaseTimedAction.perform(self, ...)
		end
		item:Use()
	end
	local ret = {ISActivateGenerator.perform(self, ...)}
	CheckAndUpdateSprite(self.generator)
	return unpack(ret)
end