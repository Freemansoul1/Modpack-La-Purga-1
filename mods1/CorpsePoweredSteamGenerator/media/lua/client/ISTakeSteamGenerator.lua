require 'TimedActions/ISTakeGenerator'

ISTakeSteamGenerator = ISTakeGenerator:derive('ISTakeSteamGenerator')

function ISTakeSteamGenerator:perform()
	forceDropHeavyItems(self.character)
	local item = self.character:getInventory():AddItem('SteamGenerator.Generator')
	item:setCondition(self.generator:getCondition())
	local modData = item:getModData()
	local genModData = self.generator:getModData()
	modData.water = genModData.water or 0
	local fuel = self.generator:getFuel()
	modData.fuel = fuel > 0 and fuel or nil
	self.character:setPrimaryHandItem(item)
	self.character:setSecondaryHandItem(item)
	self.character:getInventory():setDrawDirty(true)
	triggerEvent('OnObjectAboutToBeRemoved', self.generator) -- for single player
	self.generator:remove()
	ISBaseTimedAction.perform(self)
end