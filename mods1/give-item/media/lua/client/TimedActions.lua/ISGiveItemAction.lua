require "TimedActions/ISBaseTimedAction"

ISGiveItemAction = ISBaseTimedAction:derive("ISGiveItemAction");

function ISGiveItemAction:isValid()
	return self.character:getInventory():contains(self.item);
end

function ISGiveItemAction:update()
	self.item:setJobDelta(self:getJobDelta());
end

function ISGiveItemAction:start()
	self.item:setJobType("giveitem");
	self.item:setJobDelta(0.0);
end

function ISGiveItemAction:stop()
    ISBaseTimedAction.stop(self);
    self.item:setJobDelta(0.0);

end

function ISGiveItemAction:perform()
    self.item:getContainer():setDrawDirty(true);
    self.item:setJobDelta(0.0);

    sendClientCommand(self.character, 'giveitem', 'onGiveItem', {item=self.item, senderID = self.character:getOnlineID(), receiverID = self.target:getOnlineID()})

    self.character:getInventory():Remove(self.item)

	ISInventoryPage.renderDirty = true
	ISBaseTimedAction.perform(self);
end

function ISGiveItemAction:new (character, item, time, target)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character;
	o.target = target;
	o.item = item;
	o.stopOnWalk = false;
	o.stopOnRun = false;
	o.maxTime = time;
	if o.character:isTimedActionInstant() then o.maxTime = 1; end
	return o
end
