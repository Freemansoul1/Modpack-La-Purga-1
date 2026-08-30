require "TimedActions/ISBaseTimedAction"

RPReadTimedAction = ISBaseTimedAction:derive("RPReadTimedAction");

function RPReadTimedAction:isValid()
    return true;
end

function RPReadTimedAction:update()
    --
end

function RPReadTimedAction:waitToStart()
    return false;
end

function RPReadTimedAction:start()
    self:setActionAnim(CharacterActionAnims.Read)
    self:setOverrideHandModels(nil, self.rpItem);

    if self.rpItem == "Base.Book" or self.rpItem == "Base.Magazine" or self.rpItem == "Base.Journal" then
        self:setAnimVariable("ReadType", "book")
    elseif self.rpItem == "Base.Newspaper" or self.rpItem == "Base.MapInHand" then
        self:setAnimVariable("ReadType", "newspaper")
    end

    self.character:playSound("OpenBook")
end

function RPReadTimedAction:stop()
    self.character:playSound("CloseBook")
    ISBaseTimedAction.stop(self);
end

function RPReadTimedAction:perform()
    ISBaseTimedAction.perform(self);
end

function RPReadTimedAction:new(character, item)
    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o.character = character;

    o.maxTime = -1;
    o.useProgressBar = false;
    o.forceProgressBar = false;
    o.stopOnWalk = false;
    o.stopOnRun = true;

    o.rpItem = item;

    if o.character:isTimedActionInstant() then o.maxTime = 1; end
    return o;
end