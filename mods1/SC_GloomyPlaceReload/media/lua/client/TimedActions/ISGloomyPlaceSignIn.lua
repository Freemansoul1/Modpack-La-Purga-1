-- By 🆂🅲🆁🅸🅱🅻
-- Discord: scribl

-- Я не против если вы будете исследовать мои модификации. Не копируйте модификацию!
-- I don't mind if you explore my modifications. Do not copy the modification!

ISGloomyPlaceSignIn = ISBaseTimedAction:derive("ISGloomyPlaceSignIn");

function ISGloomyPlaceSignIn:update() end

function ISGloomyPlaceSignIn:isValid() return true; end

function ISGloomyPlaceSignIn:waitToStart() return false; end

function ISGloomyPlaceSignIn:stop() self.character:stopOrTriggerSound(self.sound); ISBaseTimedAction.stop(self); end

function ISGloomyPlaceSignIn:perform() SC_GloomyPlaceReload.SignIn(self.coords); ISBaseTimedAction.perform(self); end

function ISGloomyPlaceSignIn:start()
    if self.isAnim then
        self:setActionAnim(self.anode);
        if self.akey then
            self.character:SetVariable(self.akey, self.avar);
        end
    end
    if self.isSound and self.soundName ~= "" then
        self.sound = self.character:playSound(self.soundName);
    end
end

function ISGloomyPlaceSignIn:new(character, coords, anode, akey, avar, sound, isAnim, isSound, timedAction)
	local o = {};
    --{ x, y, z, toX, toY, toZ, anode, akey, avar, sound, marker, isAnim, isSound, isMarker, toOne}
    setmetatable(o, self);
    self.__index = self;
	o.stopOnWalk = true;
	o.stopOnRun = true;
    o.forceProgressBar = true
    o.ignoreHandsWounds = false
	o.maxTime = timedAction or 35;

	o.character  = character;
    o.coords = coords; -- { x = x, y = y, z = z }
    o.anode = anode;
    o.akey = akey;
    o.avar = avar;
    o.soundName = sound;
    o.isAnim = isAnim;
    o.isSound = isSound;
    if o.character:isTimedActionInstant() then o.maxTime = 1; end
	return o;
end