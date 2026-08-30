-- By 🆂🅲🆁🅸🅱🅻
-- Discord: scribl

-- Я не против если вы будете исследовать мои модификации. Не копируйте модификацию!
-- I don't mind if you explore my modifications. Do not copy the modification!

ISGloomyPlaceDemoAnim = ISBaseTimedAction:derive("ISGloomyPlaceDemoAnim");

function ISGloomyPlaceDemoAnim:update() end

function ISGloomyPlaceDemoAnim:isValid() return true; end

function ISGloomyPlaceDemoAnim:waitToStart() return false; end

function ISGloomyPlaceDemoAnim:stop() ISBaseTimedAction.stop(self); end

function ISGloomyPlaceDemoAnim:perform() ISBaseTimedAction.perform(self); end

function ISGloomyPlaceDemoAnim:start()
    self:setActionAnim(self.animNode);
    if self.animKey then
        self.character:SetVariable(self.animKey, self.animVariale);
    end
end

function ISGloomyPlaceDemoAnim:new(character,anim, key, variable)
	local o = {};
    setmetatable(o, self);
    self.__index = self;
    o.character = character
    o.animNode = anim;
    o.animKey = key;
    if key == "" then
        o.animKey = nil;
    end
    o.animVariale = variable;
	o.stopOnWalk = true;
	o.stopOnRun = true;
    o.forceProgressBar = true
	o.maxTime = -1;
	return o;
end