---@diagnostic disable: redefined-local, undefined-global, undefined-field
require('NPCs/MainCreationMethods');
local function initIntrovert()
		local Introvert = TraitFactory.addTrait("Introvert", getText("Introvert"), 2, getText("Gets happy and less bored while indoors"), false, false);

end

Events.OnGameBoot.Add(initIntrovert);


local Introvert

local function Introvert()
	local player = getPlayer();
	local bodyDamage = player:getBodyDamage();
	local stats = player:getStats();
	local instance = GameTime:getInstance();
	if player:HasTrait("Introvert") and player:getCurrentSquare():isInARoom() then
		bodyDamage:setUnhappynessLevel(bodyDamage:getUnhappynessLevel() - 0.75);
		bodyDamage:setBoredomLevel(bodyDamage:getBoredomLevel() - 0.75)

	end

end

Events.EveryTenMinutes.Add(Introvert)



--Extrovert trait

local function initExtrovert()
	local Extrovert = TraitFactory.addTrait("Extrovert", getText("Extrovert"), -2, getText("Gets more bored while indoors"), false, false);

end

Events.OnGameBoot.Add(initExtrovert);


local Extrovert

local function Extrovert()
    local player = getPlayer();
    local bodyDamage = player:getBodyDamage();
	local stats = player:getStats();
    local instance = GameTime:getInstance();
    if player:HasTrait("Extrovert") and player:getCurrentSquare():isInARoom() == true then
	    bodyDamage:setBoredomLevel(bodyDamage:getBoredomLevel() + 1.5)
	    bodyDamage:setUnhappynessLevel(bodyDamage:getUnhappynessLevel() + 0.125);
	end
end


Events.EveryTenMinutes.Add(Extrovert)


--Extreme Introvert trait


local function initExIntrovert()
	local ExIntrovert = TraitFactory.addTrait("Extremeintrovert", getText("Extreme introvert"), -2, getText("Gets sad and bored while outdoors (Automatically includes the introvert trait)"), false, false);

end

Events.OnGameBoot.Add(initExIntrovert);



local ExIntrovert

local function ExIntrovert()
    local player = getPlayer();
    local bodyDamage = player:getBodyDamage();
	local stats = player:getStats();
    local instance = GameTime:getInstance();
    if player:HasTrait("Extremeintrovert") and player:getCurrentSquare():isOutside() then
	    bodyDamage:setBoredomLevel(bodyDamage:getBoredomLevel() + 1);
		bodyDamage:setUnhappynessLevel(bodyDamage:getUnhappynessLevel() + 0.25)
	elseif player:HasTrait("Extremeintrovert") and player:getCurrentSquare():isInARoom() then
		bodyDamage:setUnhappynessLevel(bodyDamage:getUnhappynessLevel() - 0.5);
		bodyDamage:setBoredomLevel(bodyDamage:getBoredomLevel() - 0.5)
	end

end


Events.EveryOneMinute.Add(ExIntrovert)



IntBaseGameCharacterDetails = {}


IntBaseGameCharacterDetails.DoTraits = function()
    TraitFactory.setMutualExclusive("Extrovert", "Introvert");
    TraitFactory.setMutualExclusive("Extrovert", "Extremeintrovert");
    TraitFactory.setMutualExclusive("Introvert", "Extremeintrovert");
    TraitFactory.setMutualExclusive("Introvert", "Claustophobic")
    TraitFactory.setMutualExclusive("Extremeintrovert", "Claustophobic")
    TraitFactory.setMutualExclusive("Extrovert", "Agoraphobic")


end

Events.OnGameBoot.Add(IntBaseGameCharacterDetails.DoTraits);








