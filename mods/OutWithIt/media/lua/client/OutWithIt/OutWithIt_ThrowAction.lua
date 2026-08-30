OutWithIt = OutWithIt or {}
ISThrow = ISBaseTimedAction:derive('ISThrow')

function ISThrow:isValid()
	return true
end

function ISThrow:waitToStart()
	self.character:faceThisObject(self.target)
	return self.character:shouldBeTurning()
end

function ISThrow:update()
	self.character:faceThisObject(self.target)
end

function ISThrow:start()
	self:setActionAnim('Loot')
	self.character:SetVariable('LootPosition', 'Mid')
end

function ISThrow:stop()
    ISBaseTimedAction.stop(self)
end

function ISThrow:perform()
	if (self.item == self.character:getPrimaryHandItem()) then
		self.character:setPrimaryHandItem(nil)
	end
	if (self.item == self.character:getSecondaryHandItem()) then
		self.character:setSecondaryHandItem(nil)
	end

	local dropSquare = OutWithIt.getDropSquare(self.character, self.target)

	local fallHeight = self.character:getSquare():getZ() - dropSquare:getZ()

	if (fallHeight > 0 and OutWithIt.Options.damageItemsOnFall) then
		local condition = self.item:getCondition()

		local damagePercentage = fallHeight * fallHeight * 10 / 100
		if (damagePercentage > 1) then damagePercentage = 1 end
		if (damagePercentage < 0) then damagePercentage = 0 end

		local newCondition = condition * (1 - damagePercentage)

		self.item:setCondition(newCondition, true)
	end

	self.character:getInventory():Remove(self.item)
	dropSquare:AddWorldInventoryItem(self.item, 0.0, 0.0, 0.0)
    ISBaseTimedAction.perform(self)
end

function ISThrow:new(character, target, item, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.target = target
	o.item = item
	o.maxTime = time
	if o.character:isTimedActionInstant() then o.maxTime = 1 end
	return o
end
