require "TimedActions/ISBaseTimedAction"

ISUpgradeWeapon = ISBaseTimedAction:derive("ISUpgradeWeapon");

local function predicateNotBroken(item)
    return not item:isBroken()
end

function ISUpgradeWeapon:isValid()
    if not self.character:getInventory():containsTagEval("Screwdriver", predicateNotBroken) then return false end
    if self.weapon:getWeaponPart(self.part:getPartType()) then return false end
    return self.character:getInventory():contains(self.part);
end

function ISUpgradeWeapon:update()
    self.weapon:setJobDelta(self:getJobDelta());
    self.part:setJobDelta(self:getJobDelta());

    self.character:setMetabolicTarget(Metabolics.LightDomestic);
end

function ISUpgradeWeapon:start()
    self.sound = self.character:playSound("UpgradeWeapon");
    local radius = 4;
    addSound(self.character, self.character:getX(), self.character:getY(), self.character:getZ(), radius, radius);
    self.weapon:setJobType(getText("ContextMenu_Add_Weapon_Upgrade"));
    self.weapon:setJobDelta(0.0);
    self.part:setJobType(getText("ContextMenu_Add_Weapon_Upgrade"));
    self.part:setJobDelta(0.0);
end

function ISUpgradeWeapon:stop()
    if self.sound then
		self.character:getEmitter():stopSound(self.sound)
		self.sound = nil
    end
    ISBaseTimedAction.stop(self);
    self.weapon:setJobDelta(0.0);
    self.part:setJobDelta(0.0);
end

function ISUpgradeWeapon:perform()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    self.weapon:setJobDelta(0.0);
    self.part:setJobDelta(0.0);
    self.weapon:attachWeaponPart(self.part)
    self.character:getInventory():Remove(self.part);
    self.character:setSecondaryHandItem(nil);
    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self);
end

function ISUpgradeWeapon:new(character, weapon, part, time)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character;
    o.weapon = weapon;
    o.part = part;
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.maxTime = time;
    if character:isTimedActionInstant() then
        o.maxTime = 1;
    end
    return o;
end
