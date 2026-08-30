require "TimedActions/ISBaseTimedAction"

RPSmokeTimedAction = ISBaseTimedAction:derive("RPSmokeTimedAction");

function RPSmokeTimedAction:isValid()
    return true;
end

function RPSmokeTimedAction:update()
    --
end

function RPSmokeTimedAction:waitToStart()
    return false;
end

function RPSmokeTimedAction:start()
    self:setActionAnim("RPSmoke")
    self:setOverrideHandModels(nil, "Base.Cigarette");
    self.character:playSound("Smoke")
end

function RPSmokeTimedAction:stop()
    ISBaseTimedAction.stop(self);
end

function RPSmokeTimedAction:perform()
    ISBaseTimedAction.perform(self);
end

function RPSmokeTimedAction:new(character)
    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o.character = character;

    o.maxTime = -1;
    o.useProgressBar = false;
    o.forceProgressBar = false;
    o.stopOnWalk = false;
    o.stopOnRun = true;

    if o.character:isTimedActionInstant() then o.maxTime = 1; end
    return o;
end