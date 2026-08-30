Knockout = Knockout or {}

require "TimedActions/ISBaseTimedAction"

Knockout_TimedAction = ISBaseTimedAction:derive("Knockout_TimedAction");

function Knockout_TimedAction:isValid() -- Check if the action can be done. Calls :stop() if false is returned
    if SandboxVars.Knockout.zombiesWakeupKnockedPlayers then
        if Knockout.isBeingAttackedByZombies(self.character) then return false end
    end

    return true
end

function Knockout_TimedAction:update() -- Trigger every game update when the action is perform

end

function Knockout_TimedAction:waitToStart() -- Wait until return false
    return false
end

function Knockout_TimedAction:start() -- Trigger when the action starts
    if ISWorldMap_instance and ISWorldMap_instance:isVisible() then
        ISWorldMap.HideWorldMap(self.playerIndex)
    end

    self:setActionAnim("KnockedOut")

    Knockout.disabler(self.character, true) --Disable player controls

    self.character:getModData().Knockout_isKnockedout = true

    UIManager.setFadeBeforeUI(self.playerIndex, true) --Initiate black screen
    UIManager.FadeOut(self.playerIndex, 1)            --Show black screen

    local moodle = MF.getMoodle("Knockedout");

    if moodle then
        moodle:setValue(0)
    end
end

function Knockout_TimedAction:stop()         -- Trigger if the action is cancelled
    Knockout.disabler(self.character, false) --Enable player controls

    UIManager.FadeIn(self.playerIndex, 1)
    self.character:getModData().Knockout_isKnockedout = false

    local moodle = MF.getMoodle("Knockedout");

    if moodle then
        moodle:setValue(0.5)
    end

    ISBaseTimedAction.stop(self);
end

function Knockout_TimedAction:perform()      -- Trigger when the action is complete
    Knockout.disabler(self.character, false) --Enable player controls

    UIManager.FadeIn(self.playerIndex, 1)
    self.character:getModData().Knockout_isKnockedout = false

    local moodle = MF.getMoodle("Knockedout");

    if moodle then
        moodle:setValue(0.5)
    end

    if self.sound then
        self.character:stopOrTriggerSound(self.sound);
    end
end

function Knockout_TimedAction:adjustMaxTime(maxTime)
    return SandboxVars.Knockout.knockoutTime * 2 * getGameTime():getMinutesPerDay();
end

function Knockout_TimedAction:new(character, playerIndex) -- What to call in your code
    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o.character = character;
    o.playerIndex = playerIndex;
    o.maxTime = SandboxVars.Knockout.knockoutTime * 2 * getGameTime():getMinutesPerDay(); -- Time take by the action
    if o.character:isTimedActionInstant() then o.maxTime = 1; end
    return o;
end
