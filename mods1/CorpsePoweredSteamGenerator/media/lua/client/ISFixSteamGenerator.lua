require 'TimedActions/ISFixGenerator'

ISFixSteamGenerator = ISFixGenerator:derive('ISFixSteamGenerator')
ISFixGenerator.__index = ISFixGenerator

function ISFixSteamGenerator:isValid()
	return self.generator:getObjectIndex() ~= -1 and
	   not self.generator:isActivated() and
		   self.generator:getCondition() < 100 and
		   self.character:getInventory():containsTypeRecurse('ScrapMetal')
end

function ISFixSteamGenerator:perform()
	self.character:stopOrTriggerSound(self.sound)
	local inv = self.character:getInventory()
	local scrapItem = inv:getFirstTypeRecurse('ScrapMetal')
	if scrapItem then
		self.character:removeFromHands(scrapItem)
		inv:Remove(scrapItem)
	end
	self.generator:setCondition(self.generator:getCondition() + 4 + (1 * 
		(self.character:getPerkLevel(Perks.MetalWelding))/2))
	self.character:getXp():AddXP(Perks.MetalWelding, 5)
	
	scrapItem = inv:getFirstTypeRecurse('ScrapMetal')
	if self.generator:getCondition() < 100 and scrapItem then
		local scrapInv = scrapItem:getContainer()
		local prevAct = self
		if scrapInv ~= inv then
			prevAct = ISInventoryTransferAction:new(self.character, scrapItem, scrapInv, inv, nil)
			ISTimedActionQueue.addAfter(self, prevAct)
		end
		ISTimedActionQueue.addAfter(prevAct, ISFixSteamGenerator:new(self.character, self.generator, 150))
	end
	ISBaseTimedAction.perform(self)
end
