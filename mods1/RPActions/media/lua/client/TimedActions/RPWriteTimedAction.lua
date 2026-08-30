require "TimedActions/ISBaseTimedAction"

RPWriteTimedAction = ISBaseTimedAction:derive("RPWriteTimedAction");

function RPWriteTimedAction:isValid()
    return true;
end

function RPWriteTimedAction:update()
    --
end

function RPWriteTimedAction:waitToStart()
    return false;
end

function RPWriteTimedAction:start()
    self:setActionAnim("WriteInBook")
    self:setOverrideHandModels("Base.Pen", self.rpItem);

    self.character:playSound("Character/Survival/Map/AddNote")
end

function RPWriteTimedAction:stop()
    self.character:playSound("CloseBook")
    ISBaseTimedAction.stop(self);
end

function RPWriteTimedAction:perform()
    ISBaseTimedAction.perform(self);
end

function RPWriteTimedAction:new(character, item)
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