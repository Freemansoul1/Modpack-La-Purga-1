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

	-- print("From : " .. self.character:getSteamID() .. " To : " .. self.target:getSteamID())
	-- print("From : " .. self.character:getUsername() .. " To : " .. self.target:getUsername() .. " Item : " .. self.item:getName());
	-- print("From : " .. self.character:getOnlineID() .. " To : " .. self.target:getOnlineID());
	-- print("From : " .. self.character:getPlayerNum() .. " To : " .. self.target:getPlayerNum());
	-- print("From : " .. self.character:getFullName() .. " To : " .. self.target:getFullName());
	-- print("From : " .. self.character:getSurname() .. " To : " .. self.target:getSurname());
	-- print("isTargetNPC : " .. tostring(self.target:getIsNPC()));
	if (self.target:getIsNPC() or self.character:getSteamID() == self.target:getSteamID() or self.character:getOnlineID() == self.target:getOnlineID()) then
		print("Target is NPC or same player");
		-- Lag created when giving to superbsurvivors, so commented for now
		-- if (getActivatedMods():contains("SuperbSurvivors")) then 
		-- 	local SS = SSM:Get(self.target:getModData().ID)
		-- 	local RSS = SSM:Get(0)
		-- 	local gift = RSS:getFacingSquare():AddWorldInventoryItem(self.item,0.5,0.5,0)
		-- 	SS:getTaskManager():AddToTop(TakeGiftTask:new(SS,gift))
		-- 	SS:PlusRelationshipWP(2.0)
		-- else
			self.target:getInventory():AddItem(self.item);
		--end
	else
		sendClientCommand(self.character, 'giveitem', 'onGiveItem', {item=self.item, senderID = self.character:getOnlineID(), receiverID = self.target:getOnlineID()})
	end

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
