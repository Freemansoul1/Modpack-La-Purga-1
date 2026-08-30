require "TimedActions/ISBaseTimedAction"

RPFoodTimedAction = ISBaseTimedAction:derive("RPFoodTimedAction");

function RPFoodTimedAction:isValid()
    return true;
end

function RPFoodTimedAction:update()
    --
end

function RPFoodTimedAction:waitToStart()
    return false;
end

function RPFoodTimedAction:start()
    self:setActionAnim(self.actionType)
    self:setOverrideHandModels(self.rightItem, self.leftItem);
    self:setAnimVariable("FoodType", self.actionN);
end

function RPFoodTimedAction:stop()
    ISBaseTimedAction.stop(self);
end

function RPFoodTimedAction:perform()
    ISBaseTimedAction.perform(self);
end

function RPFoodTimedAction:new(character, item1, item2, action, type)
    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o.character = character;

    o.maxTime = -1;
    o.useProgressBar = false;
    o.forceProgressBar = false;
    o.stopOnWalk = false;
    o.stopOnRun = true;
    
    o.rightItem = item1;
    o.leftItem = item2;
    o.actionN = action;
    if type == "drink" then
        o.actionType = CharacterActionAnims.Drink;
    else
        o.actionType = CharacterActionAnims.Eat;
    end
    if o.character:isTimedActionInstant() then o.maxTime = 1; end
    return o;
end