require ("TimedActions/ISBaseTimedAction");

OpenFLeadBoxAction = ISBaseTimedAction:derive("OpenFLeadBoxAction");

function OpenFLeadBoxAction:isValid()
	return (self.character:getPrimaryHandItem() ~= nil and self.character:getPrimaryHandItem():getType() ~= nil and FLBoxDefs[self.character:getPrimaryHandItem():getType()] ~= nil);
end

function OpenFLeadBoxAction:update()
    self.item:setJobDelta(self:getJobDelta());
end

function OpenFLeadBoxAction:start()
    --self.character:getEmitter():playSoundImpl("browselurebox", nil)
	self.character:playSound("browselurebox")
    self.item:setJobType(getText("ContextMenu_OpenFLeadBox"));
    self.item:setJobDelta(0.0);
	self:setActionAnim(CharacterActionAnims.Craft);
end


function OpenFLeadBoxAction:stop()
	ISBaseTimedAction.stop(self);
	self.item:setJobDelta(0.0);
end

function OpenFLeadBoxAction:perform()

    ISBaseTimedAction.perform(self);
	self.item:setJobDelta(0.0);

    self.prim = self.character:getPrimaryHandItem();
	if self.prim and FLBoxDefs[self.character:getPrimaryHandItem():getType()] then
		local ItemsTable = FLBoxDefs[self.character:getPrimaryHandItem():getType()].Items;
		local luck = 6;
		if self.character:HasTrait("Lucky") then
			luck = luck + ZombRand(1,3);
		elseif self.character:HasTrait("Unlucky") then
			luck = luck - ZombRand(1,3);
		end
		if ItemsTable then
			for i=1, ZombRand(1, luck) do
				self.character:getInventory():AddItem(ItemsTable[ZombRand(#ItemsTable)+1])
			end
			self.prim:Use();
			self.character:setPrimaryHandItem(nil);
		end
	end
end


function OpenFLeadBoxAction:new(character, item, time)
	local o = {};
	setmetatable(o, self);
	self.__index = self;
	o.character = character;
	o.item = item;
	o.stopOnWalk = true;
	o.stopOnRun = true;
	o.maxTime = time;
	return o;
end