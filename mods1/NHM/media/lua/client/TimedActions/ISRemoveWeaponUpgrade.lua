require "TimedActions/ISBaseTimedAction"

ISRemoveWeaponUpgrade = ISBaseTimedAction:derive("ISRemoveWeaponUpgrade");

local function predicateNotBroken(item)
    return not item:isBroken()
end

function ISRemoveWeaponUpgrade:isValid()
    if not self.character:getInventory():containsTagEval("Screwdriver", predicateNotBroken) then return false end
    if not self.character:getInventory():contains(self.weapon) then return false end
    return self.weapon:getWeaponPart(self.part:getPartType()) == self.part
end

function ISRemoveWeaponUpgrade:update()
    self.character:setMetabolicTarget(Metabolics.LightDomestic);
end

function ISRemoveWeaponUpgrade:start()
    self.sound = self.character:playSound("RemoveUpgrade");
    local radius = 4;
    addSound(self.character, self.character:getX(), self.character:getY(), self.character:getZ(), radius, radius);
end

function ISRemoveWeaponUpgrade:stop()
    if self.sound then
		self.character:getEmitter():stopSound(self.sound)
		self.sound = nil
    end
    ISBaseTimedAction.stop(self);
end

function ISRemoveWeaponUpgrade:perform()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    self.weapon:detachWeaponPart(self.part)
    self.character:getInventory():AddItem(self.part);
    self.character:resetEquippedHandsModels();
    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self);
end

function ISRemoveWeaponUpgrade:new(character, weapon, part, time)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character;
    o.weapon = weapon;
    o.part = part;
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.maxTime = time;
    return o;
end