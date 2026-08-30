local ISPlayGuitar = ISBaseTimedAction:derive('ISPlayGuitar');


ISPlayGuitar.new = function(self, character, item)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character;
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.stopOnAim = false;
    o.maxTime = -1;
    o.item = item;
    o.handItem = nil;
    return o
end


ISPlayGuitar.isValid = function(self)

    return true
end


ISPlayGuitar.update = function(self)
    return;
end


ISPlayGuitar.start = function(self)
    local type =  self.item:getFullType();

    if self.character:isItemInBothHands(self.item) then
        self.handItem = 'BothHands';
    else
        if self.character:isPrimaryHandItem(self.item) then
            self.handItem = 'PrimaryHand';
        elseif self.character:isSecondaryHandItem(self.item) then
            self.handItem = 'SecundaryHand';
        end
    end

    self.character:setPrimaryHandItem(nil);
    self.character:setSecondaryHandItem(self.item);

    if type == 'Base.GuitarAcoustic' then 
        self:setActionAnim('playguitar');
    end
end


ISPlayGuitar.stop = function(self)

    if self.handItem == 'PrimaryHand' then
        self.character:setPrimaryHandItem(self.item);
        self.character:setSecondaryHandItem(nil);
    elseif self.handItem == 'SecundaryHand' then
        self.character:setPrimaryHandItem(nil);
        self.character:setSecondaryHandItem(self.item);
    elseif self.handItem == 'BothHands' then
        self.character:setPrimaryHandItem(self.item);
        self.character:setSecondaryHandItem(self.item);
    end

	ISBaseTimedAction.stop(self);
end


ISPlayGuitar.perform = function(self)

    ISBaseTimedAction.perform(self);
end

return ISPlayGuitar;