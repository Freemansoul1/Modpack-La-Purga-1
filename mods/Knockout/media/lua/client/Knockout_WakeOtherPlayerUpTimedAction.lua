Knockout = Knockout or {}

require "TimedActions/ISBaseTimedAction"

Knockout_WakeOtherPlayerUpTimedAction = ISBaseTimedAction:derive("Knockout_WakeOtherPlayerUpTimedAction");

function Knockout_WakeOtherPlayerUpTimedAction:isValid() -- Check if the action can be done
    return true
end

function Knockout_WakeOtherPlayerUpTimedAction:update() -- Trigger every game update when the action is perform
    
end

function Knockout_WakeOtherPlayerUpTimedAction:waitToStart() -- Wait until return false
    return false
end

function Knockout_WakeOtherPlayerUpTimedAction:start() -- Trigger when the action starts
    self:setActionAnim("Loot")
    self.character:SetVariable("LootPosition", "Low")
end

function Knockout_WakeOtherPlayerUpTimedAction:stop() -- Trigger if the action is cancelled
    ISBaseTimedAction.stop(self);
end

function Knockout_WakeOtherPlayerUpTimedAction:perform() -- Trigger when the action is complete
    sendClientCommand('RealKnockouts', 'wakeOtherPlayerUp', {self.clickedPlayerID})
end

function Knockout_WakeOtherPlayerUpTimedAction:new(character, clickedPlayerID, saltItem) -- What to call in you code
    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o.character = character;
    o.clickedPlayerID = clickedPlayerID;
    o.saltItem = saltItem
    o.maxTime = 100 -- Time take by the action
    if o.character:isTimedActionInstant() then o.maxTime = 1; end
    return o;
end