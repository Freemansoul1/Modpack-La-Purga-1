require('NPCs/MainCreationMethods');
require("Items/Distributions");
require("Items/ProceduralDistributions");
local HephasSandbox = SandboxVars.Hepha;




local function BreathingTechnique(_player)
	local player = getPlayer();
	local playerEndurance = player:getStats():getEndurance();

    if player:HasTrait("breathingTechnique") then
        if playerEndurance < 1 and player:isSitOnGround() == true then
            player:getStats():setEndurance(playerEndurance + 0.00004) 

            if playerEndurance > 1 then
                playerEndurance = 1;
            end

			if playerEndurance >= 0.96  then
				HaloTextHelper.addText(player, "You feel that your breathing is steady again");
			end
        end
    end
end

local function ZedKill(_zombie, player)
	local player = getPlayer();
    local zombie = _zombie;

	if player:HasTrait("Peaceful") then
        local bodydamage = player:getBodyDamage();
        local unhappiness = bodydamage:getUnhappynessLevel();
		local stats = player:getStats()

        bodydamage:setUnhappynessLevel(unhappiness + 0.25);
		stats:setStress(stats:getStress() + 0.025);
        if stats:getStress() < 0 then
            stats:setStress(0);
        end
    end
end


local function DrunkMaster(player, target, weapon, damage)
	if player:HasTrait("DrunkenMaster") then
		if getPlayer():getStats():getDrunkenness() >= 10 then
			if not getPlayer():getPrimaryHandItem():isRanged() then
				target:setHealth(target:getHealth() - (damage * 1.2) * 0.1);
				if target:getHealth() <= 0 and target:isAlive() then
					target:update();
				end
			end
		end
	end
end

local function DecreaseDrunk()
    if getPlayer():HasTrait("DrunkenMaster") then
        local bodydamage = getPlayer():getBodyDamage();
		local currentDrunkenness = getPlayer():getStats():getDrunkenness();
		
		getPlayer():getStats():setDrunkenness(currentDrunkenness - 0.75);
		if getPlayer():getStats():getDrunkenness() < 0 then
			getPlayer():getStats():setDrunkenness(0);
		end
    end
end


function Bleeder(player)
    if not player:HasTrait("bleeder") then
        return
    end

    local bodyDamage = player:getBodyDamage()
    if bodyDamage:getNumPartsBleeding() <= 0 then
        return
    end

    local bodyParts = bodyDamage:getBodyParts()
    for i = 0, bodyParts:size() - 1 do
        local bodyPart = bodyParts:get(i)
        if bodyPart:bleeding() and not bodyPart:IsBleedingStemmed() then
            local healthReduction = 0.006
            if bodyPart:getType() == BodyPartType.Neck then
                healthReduction = healthReduction * 3
            end
            bodyPart:ReduceHealth(healthReduction)
            HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Bleeder"), false, HaloTextHelper.getColorRed())
        end
    end
end



function StressEaterCheck()
    local player = getPlayer();

	if player:HasTrait("StressEater") then
		if player:getStats():getStress() > 0.25 and player:getStats():getHunger() < 0.3 then 
			player:getStats():setHunger(player:getStats():getHunger() + 0.03);

		end
	end
end


---- Update 1.7 ----
function Nudist()
    local player = getPlayer()

    if player:HasTrait("Nudist") then
        local wearingClothes = false
        local wornItems = player:getWornItems()
        local backpackItem = player:getClothingItem_Back()

        for i = 0, wornItems:size() - 1 do
            local item = wornItems:get(i):getItem()
            local bodyLocation = item:getBodyLocation()
            local displayCategory = item:getDisplayCategory()

            if not (bodyLocation == "Shoes" or
                    bodyLocation == "LeftWrist" or
                    bodyLocation == "RightWrist" or
                    displayCategory == "Accessory" or
                    item == backpackItem) then
                wearingClothes = true
                break
            end
        end

        local bodyDamage = player:getBodyDamage()
        local unhappinessLevel = bodyDamage:getUnhappynessLevel()

        if wearingClothes then
            bodyDamage:setUnhappynessLevel(math.max(55, unhappinessLevel + 6))
        else
            bodyDamage:setUnhappynessLevel(math.max(0, unhappinessLevel - 8))
        end
    end
end



function Sprinter()
    local player = getPlayer()

    if player:HasTrait("Sprinter12") or player:HasTrait("Sprinter1") then
        local bodyDamage = player:getBodyDamage()
        local unhappinessLevel = bodyDamage:getUnhappynessLevel()
        local boredomLevel = bodyDamage:getBoredomLevel()


        if player:isSprinting() then
            if unhappinessLevel > 0 then
                bodyDamage:setUnhappynessLevel(math.max(0, unhappinessLevel - 0.0001))
            end

            if boredomLevel > 0 then
                bodyDamage:setBoredomLevel(math.max(0, boredomLevel - 0.0001))
            end
        end
    end
end




----------------------------------------   EVENTS   ----------------------------------------

--- On Zombied Dead
Events.OnZombieDead.Add(ZedKill);
Events.OnZombieDead.Add(DecreaseDrunk);

--- On Weapon Hit
Events.OnWeaponHitCharacter.Add(DrunkMaster);


--- On Eat

--- On Player Update
Events.OnPlayerUpdate.Add(BreathingTechnique);
Events.OnPlayerUpdate.Add(Bleeder);
Events.OnPlayerUpdate.Add(Sprinter);


--- Every Hour
Events.EveryHours.Add(StressEaterCheck);
Events.EveryHours.Add(Nudist);

