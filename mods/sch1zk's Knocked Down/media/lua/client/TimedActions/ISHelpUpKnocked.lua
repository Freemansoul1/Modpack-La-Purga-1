-- +================================================================+
-- |                                                                |
-- |                        /##         /##             /##         |
-- |                       | ##       /####            | ##         |
-- |     /#######  /#######| ####### |_  ##   /########| ##   /##   |
-- |    /##_____/ /##_____/| ##__  ##  | ##  |____ /##/| ##  /##/   |
-- |   |  ###### | ##      | ##  \ ##  | ##     /####/ | ######/    |
-- |    \____  ##| ##      | ##  | ##  | ##    /##__/  | ##_  ##    |
-- |    /#######/|  #######| ##  | ## /###### /########| ## \  ##   |
-- |   |_______/  \_______/|__/  |__/|______/|________/|__/  \__/   |
-- |                                                                |
-- +================================================================+

require "TimedActions/ISBaseTimedAction"

ISHelpUpKnocked = ISBaseTimedAction:derive("ISHelpUpKnocked");

function ISHelpUpKnocked:isValid()
    return self.knockedCharacter:getModData().knockedd and self.knockedCharacter:getModData().knockedd.state == "knocked";
end

function ISHelpUpKnocked:waitToStart()
    self.character:faceThisObject(self.knockedCharacter)
    return self.character:shouldBeTurning()
end

function ISHelpUpKnocked:update()
    self.character:faceThisObject(self.knockedCharacter);
end

function ISHelpUpKnocked:start()
    self:setActionAnim("Loot");
    self.character:SetVariable("LootPosition", "Low");
end

function ISHelpUpKnocked:stop()
    ISBaseTimedAction.stop(self);
end

function ISHelpUpKnocked:perform()
    local args = { id = self.knockedCharacter:getOnlineID() }
    sendClientCommand(getPlayer(), 'knockedd', 'helpupknocked', args);
	ISBaseTimedAction.perform(self);
end

function ISHelpUpKnocked:new(character, knockedCharacter)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character;
    o.knockedCharacter = knockedCharacter;
	o.stopOnWalk = true;
	o.stopOnRun = true;
	o.maxTime = 200;
    o.forceProgressBar = true;
    if character:isTimedActionInstant() then
        o.maxTime = 1;
    end
	return o;
end
