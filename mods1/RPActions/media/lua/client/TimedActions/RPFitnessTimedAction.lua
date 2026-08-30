require "TimedActions/ISBaseTimedAction"

RPFitnessTimedAction = ISBaseTimedAction:derive("RPFitnessTimedAction");

function RPFitnessTimedAction:isValid()
    return true;
end

function RPFitnessTimedAction:update()
    --
end

function RPFitnessTimedAction:waitToStart()
    return false;
end

function RPFitnessTimedAction:start()
    self:setOverrideHandModels(nil, nil);
end

function RPFitnessTimedAction:stop()
    ISBaseTimedAction.stop(self);
end

function RPFitnessTimedAction:perform()
    ISBaseTimedAction.perform(self);
end

function RPFitnessTimedAction:new(character, action)
    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o.character = character;

    o.maxTime = -1;
    o.useProgressBar = false;
    o.forceProgressBar = false;
    o.stopOnWalk = false;
    o.stopOnRun = true;

    o.fitnessAction = action;

    if o.character:isTimedActionInstant() then o.maxTime = 1; end
    return o;
end