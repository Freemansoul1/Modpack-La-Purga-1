require "TimedActions/ISBaseTimedAction"

FollowPlayerAction = ISBaseTimedAction:derive("FollowPlayerAction");

function FollowPlayerAction:isValid()
	if self.character:getVehicle() then return false end
    if self.otherCharacter:getVehicle() then return false end
    return getGameSpeed() <= 2;
end

function FollowPlayerAction:update()
    if instanceof(self.character, "IsoPlayer") and (self.character:pressedMovement(false) or self.character:pressedCancelAction()) then
        self:forceStop()
        return
    end

    local distanceSq = self.character:getDistanceSq(self.otherCharacter)

    if distanceSq < 4 then -- withen 2 tiles
        if self.isWalking then
            self.character:getPathFindBehavior2():cancel()
            self.character:setPath2(nil)
            self.character:setForceSprint(false)
            self.character:setForceRun(false)
            self.isWalking = false
        end
        return
    elseif distanceSq > 900 then -- more than 30 tiles
        self:forceStop()
        return
    elseif distanceSq > 225 then -- more than 15 tiles
        if not self.character:isForceSprint() then
            self.character:setForceSprint(true)
            self.character:setForceRun(false)
        end
    elseif distanceSq > 25 then -- more than 5 tiles
        if not self.character:isForceRun() then
            self.character:setForceSprint(false)
            self.character:setForceRun(true)
        end
    else
        if self.character:isForceRun() or self.character:isForceSprint() then
            self.character:setForceSprint(false)
            self.character:setForceRun(false)
        end
    end

    self.tick = self.tick + 1
    if not self.isWalking or self.tick > 20 then
        self:start()
        self.tick = 0
    else
        self.result = self.character:getPathFindBehavior2():update();

        if self.result == BehaviorResult.Failed then
            self:forceStop();
            return;
        end

        if self.result == BehaviorResult.Succeeded then
            self.isWalking = false
        end
    end
end

function FollowPlayerAction:start()
    self.character:getPathFindBehavior2():pathToCharacter(self.otherCharacter)
    self.isWalking = true
end

function FollowPlayerAction:stop()
    ISBaseTimedAction.stop(self);
	self.character:getPathFindBehavior2():cancel()
    self.character:setPath2(nil);
    self.character:setForceSprint(false)
    self.character:setForceRun(false)
end

function FollowPlayerAction:perform()
	self.character:getPathFindBehavior2():cancel()
    self.character:setPath2(nil);
    self.character:setForceSprint(false)
    self.character:setForceRun(false)
    ISBaseTimedAction.perform(self);
end

function FollowPlayerAction:new(character, otherCharacter)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character;
    o.otherCharacter = otherCharacter;
    o.isWalking = false
    o.tick = 0;
    o.stopOnWalk = false;
    o.stopOnRun = false;
    o.maxTime = -1;
    return o
end
