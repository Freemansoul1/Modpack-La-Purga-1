-- FUNCTIONS FROM RECIPES
-- By Ninja Wizard

--- FOOD SICKNESS PILLS
function WizSickPillTake(items, result, player)
    local WizSicknessMod = 15;
	WizSickPillEffect(player, WizSicknessMod);
end

function WizSickPillEffect(player, WizSicknessMod)
	player:getBodyDamage():setFoodSicknessLevel(player:getBodyDamage():getFoodSicknessLevel() - WizSicknessMod);
end


--STIMULANT PILLS
function WizStimulantPillTake(items, result, player)
    local WizFatigueMod1 = 0.25;
	local WizStressMod1 = 0.1;
	WizStimulantPillEffect_A(player, WizFatigueMod1);
	WizStimulantPillEffect_B(player, WizStressMod1);
end

function WizStimulantPillEffect_A(player, WizFatigueMod1)
	player:getStats():setFatigue(player:getStats():getFatigue() - WizFatigueMod1);	
end
function WizStimulantPillEffect_B(player, WizStressMod1)
	player:getStats():setStress(player:getStats():getStress() + WizStressMod1);	
end


--ADRENALINE SHOT
function WizAdrenalineShot(items, result, player)
    local WizFatigueMod2 = 1.0;
	local WizStressMod2 = 0.5;
	local WizEnduranceMod1 = 1.0;
	WizAdrenalineEffect_A(player, WizFatigueMod2);
	WizAdrenalineEffect_B(player, WizStressMod2);
	WizAdrenalineEffect_C(player, WizEnduranceMod1);
end

function WizAdrenalineEffect_A(player, WizFatigueMod2)
	player:getStats():setFatigue(player:getStats():getFatigue() - WizFatigueMod2);	
end
function WizAdrenalineEffect_B(player, WizStressMod2)
	player:getStats():setStress(player:getStats():getStress() + WizStressMod2);
   -- player:getBodyDamage():IncreasePanic(20);
end
function WizAdrenalineEffect_C(player, WizEnduranceMod1)
	player:getStats():setEndurance(player:getStats():getEndurance() + WizEnduranceMod1);	
end


--MORPHINE SHOT
function WizMorphineShot(items, result, player)
    local WizFatigueMod3 = 0.5;
	local WizStressMod3 = 1.0;
	local WizPainMod1 = 90;
	local WizDrunkennessMod1 = 90;
	WizMorphineEffect_A(player, WizFatigueMod3);
	WizMorphineEffect_B(player, WizStressMod3);
	WizMorphineEffect_C(player, WizPainMod1);
	WizMorphineEffect_D(player, WizDrunkennessMod1);
end

function WizMorphineEffect_A(player, WizFatigueMod3)
	player:getStats():setFatigue(player:getStats():getFatigue() + WizFatigueMod3);	
end
function WizMorphineEffect_B(player, WizStressMod3)
	player:getStats():setStress(player:getStats():getStress() - WizStressMod3);	
end
function WizMorphineEffect_C(player, WizPainMod1)
	player:getStats():setPain(player:getStats():getPain() - WizPainMod1);	
end
function WizMorphineEffect_D(player, WizDrunkennessMod1)
	player:getStats():setDrunkenness(player:getStats():getDrunkenness() + WizDrunkennessMod1);	
end


-- Test Kit for Zombie Infection
function WizZombieInfectionTest(items, result, player)
    local bodyDamage = player:getBodyDamage()

    if bodyDamage:IsInfected() then
		player:Say("Oh no.. I'm infected. :( ");
        bodyDamage:IncreasePanic(100.0);
	else
		player:Say("Oooof.. I'm not infected. :)");
	end
end

-- Tricorder - detect zombie virus
function WizTricorderDetectVirus(items, result, player)
    local bodyDamage = player:getBodyDamage()

    if bodyDamage:IsInfected() then
		player:Say("Knox Virus Detected!");
        bodyDamage:IncreasePanic(100.0);
	else
		player:Say("No Viruses Detected.");
	end
end

-- Cure for the Zombie Virus
function WizZombieVirusCure(items, result, player)

	--local bodyDamage = player:getBodyDamage()
	
	player:getBodyDamage():setInfected(false);
	player:getBodyDamage():setInfectionMortalityDuration(-1);
	player:getBodyDamage():setInfectionTime(-1);
	player:getBodyDamage():setInfectionLevel(0);
	
	local bodyParts = player:getBodyDamage():getBodyParts();
	for i=bodyParts:size()-1, 0, -1  do
		local bodyPart = bodyParts:get(i);
		bodyPart:SetInfected(false);
	end
	
	player:getBodyDamage():setInfected(false);
    player:getBodyDamage():setInfectionLevel(0);
	
	--verify
	if player:getBodyDamage():IsInfected() == false then
		print("Infection Removed");
	end
end

-- Recharge Energy Weapons Clips
function Wiz_RechargeEnergyWeapon(items, result, player) 
    result:setCurrentAmmoCount(result:getMaxAmmo())
end


-- Recharge Magic Weapons 
function Wiz_RechargeMagicWeapon(items, result, player) 
    result:setCurrentAmmoCount(result:getMaxAmmo())
    local WizFatigueModMagic = 0.7;
	WizRechargeDebufEffectWand(player, WizFatigueModMagic);	
end
function WizRechargeDebufEffectWand (player, WizFatigueModMagic)
	player:getStats():setFatigue(player:getStats():getFatigue() + WizFatigueModMagic);	
end





-- Recipes with more than 1 result
function WizSyringeBack(items, result, player) 
    player:getInventory():AddItem("Base.Wiz_SyringeEmpty");
end

function WizDNAtube_back(items, result, player) 
    player:getInventory():AddItems("Base.WizDNAtube", 10);
end

function WizPetridish_back(items, result, player) 
    player:getInventory():AddItem("Base.Wiz_Petridish");
end

function MRE_ExtraItems(items, result, player) 
    player:getInventory():AddItem("Base.PotOfSoup");
	player:getInventory():AddItem("Base.JuiceBox");
	player:getInventory():AddItem("Base.Coffee2");
	player:getInventory():AddItems("Base.Crackers", 10);
	player:getInventory():AddItems("Base.GummyBears", 10);
end

-- PRAYING

--- PRAY FOR HAPPYNESS
function WizPrayHappy(items, result, player)
    local WizHappyMod = 100;
	WizPrayHappyEffect(player, WizHappyMod);
end

function WizPrayHappyEffect(player, WizHappyMod)
	player:Say("I sought the LORD, and He answered me and delivered me from all my fears.");
	player:Say("Those who look to Him are radiant, and their faces shall never be ashamed.");
	player:Say("Oh, taste and see that the LORD is good! Blessed is the man who takes refuge in Him!");
	player:getBodyDamage():setUnhappynessLevel(player:getBodyDamage():getUnhappynessLevel() - WizHappyMod);
end

--- PRAY FOR PEACE (STRESS REDUCTION)
function WizPrayPeace(items, result, player)
    local WizStressMod4 = 1;
	WizPrayPeaceEffect(player, WizStressMod4);
end

function WizPrayPeaceEffect(player, WizStressMod4)
	player:Say("May the God of hope fill you with all joy and peace as you trust in Him,");
	player:Say("so that you may overflow with hope by the power of the Holy Spirit.");
	player:getStats():setStress(player:getStats():getStress() - WizStressMod4);
		
end


-- PRAY FOR INSPIRATION
function WizPrayBored(items, result, player)
    local WizBoredMod = 100;
	WizPrayBoredEffect(player, WizBoredMod);
end

function WizPrayBoredEffect(player, WizBoredMod)
	player:Say("For I, the LORD your God, hold your right hand; it is I who say to you,");
	player:Say("Fear not, I am the one who helps you.");
	player:getBodyDamage():setBoredomLevel(player:getBodyDamage():getBoredomLevel() - WizBoredMod);
	--if player:getStats():getStress() < 0 then
		--	player:getStats():setStress(0);
		--end
end


--RECHARGE RING AND TALISM DEBUFF ENERGY DRAIN
function WizRechargeDebuf(items, result, player)
    local WizFatigueMod4 = 0.5;
	WizRechargeDebufEffect(player, WizFatigueMod4);	
end

function WizRechargeDebufEffect (player, WizFatigueMod4)
	player:getStats():setFatigue(player:getStats():getFatigue() + WizFatigueMod4);	
end


---DERMAL REGENERATOR
function WizDermalRegUse(items, result, player)
    
	
	player:getBodyDamage():getBodyPart(BodyPartType.ForeArm_L):setBleeding(false);
    player:getBodyDamage():getBodyPart(BodyPartType.ForeArm_L):setBleedingTime(0);
	player:getBodyDamage():getBodyPart(BodyPartType.Hand_L):setBleeding(false);
    player:getBodyDamage():getBodyPart(BodyPartType.Hand_L):setBleedingTime(0);
	player:getBodyDamage():getBodyPart(BodyPartType.Hand_R):setBleeding(false);
    player:getBodyDamage():getBodyPart(BodyPartType.Hand_R):setBleedingTime(0);
	player:getBodyDamage():getBodyPart(BodyPartType.Foot_L):setBleeding(false);
    player:getBodyDamage():getBodyPart(BodyPartType.Foot_L):setBleedingTime(0);
	player:getBodyDamage():getBodyPart(BodyPartType.Foot_R):setBleeding(false);
    player:getBodyDamage():getBodyPart(BodyPartType.Foot_R):setBleedingTime(0);
	player:getBodyDamage():getBodyPart(BodyPartType.ForeArm_R):setBleeding(false);
    player:getBodyDamage():getBodyPart(BodyPartType.ForeArm_R):setBleedingTime(0);
	player:getBodyDamage():getBodyPart(BodyPartType.Head):setBleeding(false);
    player:getBodyDamage():getBodyPart(BodyPartType.Head):setBleedingTime(0);
	player:getBodyDamage():getBodyPart(BodyPartType.Neck):setBleeding(false);
    player:getBodyDamage():getBodyPart(BodyPartType.Neck):setBleedingTime(0);
	player:getBodyDamage():getBodyPart(BodyPartType.Groin):setBleeding(false);
    player:getBodyDamage():getBodyPart(BodyPartType.Groin):setBleedingTime(0);
	player:getBodyDamage():getBodyPart(BodyPartType.LowerLeg_L):setBleeding(false);
    player:getBodyDamage():getBodyPart(BodyPartType.LowerLeg_L):setBleedingTime(0);
	player:getBodyDamage():getBodyPart(BodyPartType.LowerLeg_R):setBleeding(false);
    player:getBodyDamage():getBodyPart(BodyPartType.LowerLeg_R):setBleedingTime(0);
	player:getBodyDamage():getBodyPart(BodyPartType.Torso_Lower):setBleeding(false);
    player:getBodyDamage():getBodyPart(BodyPartType.Torso_Lower):setBleedingTime(0);
	player:getBodyDamage():getBodyPart(BodyPartType.Torso_Upper):setBleeding(false);
    player:getBodyDamage():getBodyPart(BodyPartType.Torso_Upper):setBleedingTime(0);
	player:getBodyDamage():getBodyPart(BodyPartType.UpperArm_L):setBleeding(false);
    player:getBodyDamage():getBodyPart(BodyPartType.UpperArm_L):setBleedingTime(0);
	player:getBodyDamage():getBodyPart(BodyPartType.UpperArm_R):setBleeding(false);
    player:getBodyDamage():getBodyPart(BodyPartType.UpperArm_R):setBleedingTime(0);
	player:getBodyDamage():getBodyPart(BodyPartType.UpperLeg_L):setBleeding(false);
    player:getBodyDamage():getBodyPart(BodyPartType.UpperLeg_L):setBleedingTime(0);
	player:getBodyDamage():getBodyPart(BodyPartType.UpperLeg_R):setBleeding(false);
    player:getBodyDamage():getBodyPart(BodyPartType.UpperLeg_R):setBleedingTime(0);
	 


	 
end

-- Full Restore
function OnEat_ElixirLifeEffect(food, player)
	player:getBodyDamage():RestoreToFullHealth();
	player:Say("You fell a wonderfull celestial energy around you, fully restoring your health.");
end

-- dice
function Wiz_DiceRoll(items, result, player)
    local DiceResult = ZombRand(6);
	if DiceResult == 0 then
		player:Say("Result: 1");
	elseif DiceResult == 1 then
		player:Say("Result: 2");
	elseif DiceResult == 2 then
		player:Say("Result: 3");
	elseif DiceResult == 3 then
		player:Say("Result: 4");
	elseif DiceResult == 4 then
		player:Say("Result: 5");
	else
		player:Say("Result: 6");
	end
end

-- play song
function Wiz_MusicBoxSong(items, result, player)
    getSoundManager():PlayWorldSoundWav('Wiz_musicbox', false, player:getSquare(), 0, 40, 2, true);
end



-- Buy random color Bic
function Wiz_RandomBic(items, result, player)
	local player = getPlayer()
    local RandColor = ZombRand(5);
	if RandColor == 0 then
		player:getInventory():AddItem("Base.Wiz_BicLighter_Black");
		player:getInventory():Remove("Wiz_BicLighter_White");
	elseif RandColor == 1 then
		player:getInventory():AddItem("Base.Wiz_BicLighter_Red");
		player:getInventory():Remove("Wiz_BicLighter_White");
	elseif RandColor == 2 then
		player:getInventory():AddItem("Base.Wiz_BicLighter_Blue");
		player:getInventory():Remove("Wiz_BicLighter_White");
	elseif RandColor == 3 then
		player:getInventory():AddItem("Base.Wiz_BicLighter_Yellow");
		player:getInventory():Remove("Wiz_BicLighter_White");
	else
		--player:getInventory():AddItem("Base.Wiz_BicLighter_White");
	end
	
end


--Gold Gun pieces
function Wiz_GoldGunDisassemble(items, result, player) 
    player:getInventory():AddItem("Base.Wiz_GoldLighter");
	player:getInventory():AddItem("Base.Wiz_GoldenCigarrete");
end

function Wiz_GoldGunAssemble(items, result, player) 
    player:getInventory():Remove("Wiz_GoldLighter");
end

--Give Trait achivement Trait and Extra Money if the player got the trait
-- Coin Collector
function Wiz_GiveTraitCoin(items, result, player)
	local player = getPlayer() 
	
    if not getPlayer():HasTrait("WizCoinCollector") then
	
	 getPlayer():getTraits():add("WizCoinCollector");
	 else
	 player:getInventory():AddItems("Base.Money", 250);
	end
end

-- Ufo Collector
function WizUFOCollector(items, result, player)
	local player = getPlayer() 
	
    if not getPlayer():HasTrait("WizUFOPictureCollector") then
	
	 getPlayer():getTraits():add("WizUFOPictureCollector");
	 else
	 player:getInventory():AddItems("Base.Money", 250);
	end
end

-- Comic Collector
function WizComicCollection(items, result, player)
	local player = getPlayer() 
	
    if not getPlayer():HasTrait("WizComicCollector") then
	
	 getPlayer():getTraits():add("WizComicCollector");
	 else
	 player:getInventory():AddItems("Base.Money", 150);
	end
end

-- Cryptid Collector
function WizCriptideoColector(items, result, player)
	local player = getPlayer() 
	
    if not getPlayer():HasTrait("WizCryptidCollector") then
	
	 getPlayer():getTraits():add("WizCryptidCollector");
	 else
	 player:getInventory():AddItems("Base.Money", 180);
	end
end

-- Gem Collector
function WizGemaColector(items, result, player)
	local player = getPlayer() 
	
    if not getPlayer():HasTrait("WizGemCollector") then
	
	 getPlayer():getTraits():add("WizGemCollector");
	 else
	 player:getInventory():AddItems("Base.Money", 250);
	end
end


--Random Egg Surprise
function WizEasterEggSurprises(items, result, player)
	local player = getPlayer()
    local RandToy = ZombRand(7);
	
	if RandToy == 0 then
		player:getInventory():AddItem("Base.Bricktoys");
		
	elseif RandToy == 1 then
		player:getInventory():AddItem("Base.CatToy");
		
	elseif RandToy == 2 then
		player:getInventory():AddItem("Base.Crayons");
		
	elseif RandToy == 3 then
		player:getInventory():AddItem("Base.Dice");
		
	elseif RandToy == 4 then
		player:getInventory():AddItem("Base.ToyCar");
		
	elseif RandToy == 5 then
		player:getInventory():AddItem("Base.Yoyo");
		
	else
		player:getInventory():AddItem("Base.Rubberducky");
		
	end
	
end


-- TRAIT GENE INJECTIONS

-- Cats Eye
function WizCatsEyeShot(items, result, player)
	local player = getPlayer() 
	
    if not getPlayer():HasTrait("NightVision") then
	 getPlayer():getTraits():add("NightVision");
	 else
	 
	end
end

-- Strong
function WizStrongShot(items, result, player)
	local player = getPlayer() 
	
    if not getPlayer():HasTrait("Strong") then
	 getPlayer():getTraits():add("Strong");
	 else
	 
	end
end

-- Fast Healer
function WizFastHealShot(items, result, player)
	local player = getPlayer() 
	
    if not getPlayer():HasTrait("FastHealer") then
	 getPlayer():getTraits():add("FastHealer");
	 else
	 
	end
end

-- Fast Learner
function WizFastLearnShot(items, result, player)
	local player = getPlayer() 
	
    if not getPlayer():HasTrait("FastLearner") then
	 getPlayer():getTraits():add("FastLearner");
	 else
	 
	end
end

-- Keen Hearing
function WizKeenHearShot(items, result, player)
	local player = getPlayer() 
	
    if not getPlayer():HasTrait("KeenHearing") then
	 getPlayer():getTraits():add("KeenHearing");
	 else
	 
	end
end



-- Handy - from book
function WizFreemasonHandy(items, result, player)
	local player = getPlayer() 
	
    if not getPlayer():HasTrait("Handy") then
	 getPlayer():getTraits():add("Handy");
	 else
	 
	end
end

-- Herbalist - from book
function WizVoynichSecret(items, result, player)
	local player = getPlayer() 
	
    if not getPlayer():HasTrait("Herbalist") then
	 getPlayer():getTraits():add("Herbalist");
	 else
	 
	end
end

-- nutricionsta valors caloricos - from book
function WizNutricionistaGive(items, result, player)
	local player = getPlayer() 
	
    if not getPlayer():HasTrait("Nutritionist") then
	 getPlayer():getTraits():add("Nutritionist");
	 else
	 
	end
end


-- Try Extract FastHealer Gene 1/6 from gecko blood
function WizFastHealGeneTry(items, result, player)
	local player = getPlayer()
    local RandColor = ZombRand(6);
	
	if RandColor == 0 then
		player:getInventory():AddItem("Base.WizDNAtube_GeckoGene");
		player:Say("You had Sucess in extract a viable DNA sample");
	else
		player:getInventory():AddItem("Base.WizDNAtube");
		player:Say("You failed to extract a viable DNA sample");
	end
	
end

-- Try Extract KeenHearing Gene 1/6 from rabbit blood
function WizKeenHearGeneTry(items, result, player)
	local player = getPlayer()
    local RandColor = ZombRand(6);
	
	if RandColor == 0 then
		player:getInventory():AddItem("Base.WizDNAtube_RabbitGene");
		player:Say("You had Sucess in extract a viable DNA sample");
	else
		player:getInventory():AddItem("Base.WizDNAtube");
		player:Say("You failed to extract a viable DNA sample");
	end
	
end

-- Try Extract Strong Gene 1/10 from lobster blood
function WizStrongGeneTry(items, result, player)
	local player = getPlayer()
    local RandColor = ZombRand(10);
	
	if RandColor == 0 then
		player:getInventory():AddItem("Base.WizDNAtube_LobsterGene");
		player:Say("You had Sucess in extract a viable DNA sample");
	else
		player:getInventory():AddItem("Base.WizDNAtube");
		player:Say("You failed to extract a viable DNA sample");
	end
	
end

-- Try Extract Cats eye Gene 1/3 from Rat blood
function WizCateyeGeneTry(items, result, player)
	local player = getPlayer()
    local RandColor = ZombRand(3);
	
	if RandColor == 0 then
		player:getInventory():AddItem("Base.WizDNAtube_RatGene");
		player:Say("You had Sucess in extract a viable DNA sample");
	else
		player:getInventory():AddItem("Base.WizDNAtube");
		player:Say("You failed to extract a viable DNA sample");
	end
	
end


-- Try Extract Fast Learn Gene 1/6 from Bird blood
function WizFastLearnGeneTry(items, result, player)
	local player = getPlayer()
    local RandColor = ZombRand(6);
	
	if RandColor == 0 then
		player:getInventory():AddItem("Base.WizDNAtube_BirdGene");
		player:Say("You had Sucess in extract a viable DNA sample");
	else
		player:getInventory():AddItem("Base.WizDNAtube");
		player:Say("You failed to extract a viable DNA sample");
	end
	
end

-- video game effects
function Wiz_PlayVideoGame(items, result, player)
	local WizGameHappyMod = 20;
	local WizGameBoreMod = 40;
	local WizGameStressMod = 0.2;
	Wiz_PlayVideoGameEffect_A(player, WizGameHappyMod);
	Wiz_PlayVideoGameEffect_B(player, WizGameBoreMod);
	Wiz_PlayVideoGameEffect_C(player, WizGameStressMod);	
end
	
function Wiz_PlayVideoGameEffect_A(player, WizGameHappyMod)
	player:getBodyDamage():setUnhappynessLevel(player:getBodyDamage():getUnhappynessLevel() - WizGameHappyMod);	
end
	
function Wiz_PlayVideoGameEffect_B(player, WizGameBoreMod)
	player:getBodyDamage():setBoredomLevel(player:getBodyDamage():getBoredomLevel() - WizGameBoreMod);
end

function Wiz_PlayVideoGameEffect_C(player, WizGameStressMod)
	player:getStats():setStress(player:getStats():getStress() - WizGameStressMod);	
end



-- builder kit effect
function Wiz_BuildKitEffect(items, result, player)
	local WizKitHappyMod = 80;
	local WizKitBoreMod = 20;
	local WizKitStressMod = 0.5;
	Wiz_KitGameEffect_A(player, WizKitHappyMod);
	Wiz_KitGameEffect_B(player, WizKitBoreMod);
	Wiz_KitGameEffect_C(player, WizKitStressMod);	
end
	
function Wiz_KitGameEffect_A(player, WizKitHappyMod)
	player:getBodyDamage():setUnhappynessLevel(player:getBodyDamage():getUnhappynessLevel() - WizKitHappyMod);	
end
	
function Wiz_KitGameEffect_B(player, WizKitBoreMod)
	player:getBodyDamage():setBoredomLevel(player:getBodyDamage():getBoredomLevel() - WizKitBoreMod);
end

function Wiz_KitGameEffect_C(player, WizKitStressMod)
	player:getStats():setStress(player:getStats():getStress() - WizKitStressMod);	
end



-- Dice Pack Open
function Wiz_CreateExtraDice(items, result, player) 
    player:getInventory():AddItem("Base.Wiz_D6Dice");
	player:getInventory():AddItem("Base.Wiz_D8Dice");
	player:getInventory():AddItem("Base.Wiz_D10Dice");
	player:getInventory():AddItem("Base.Wiz_D12Dice");
	player:getInventory():AddItem("Base.Wiz_D20Dice");
end

-- dice D6
function Wiz_DiceRollD6(items, result, player)
    local DiceResult = ZombRand(6);
	if DiceResult == 0 then
		player:Say("D6 Roll: 1");
	elseif DiceResult == 1 then
		player:Say("D6 Roll: 2");
	elseif DiceResult == 2 then
		player:Say("D6 Roll: 3");
	elseif DiceResult == 3 then
		player:Say("D6 Roll: 4");
	elseif DiceResult == 4 then
		player:Say("D6 Roll: 5");
	else
		player:Say("D6 Roll: 6");
	end
end

-- dice D4
function Wiz_DiceRollD4(items, result, player)
    local DiceResult = ZombRand(4);
	if DiceResult == 0 then
		player:Say("D4 Roll: 1");
	elseif DiceResult == 1 then
		player:Say("D4 Roll: 2");
	elseif DiceResult == 2 then
		player:Say("D4 Roll: 3");
	else
		player:Say("D4 Roll: 4");
	
	end
end

-- dice D8
function Wiz_DiceRollD8(items, result, player)
    local DiceResult = ZombRand(8);
	if DiceResult == 0 then
		player:Say("D8 Roll: 1");
	elseif DiceResult == 1 then
		player:Say("D8 Roll: 2");
	elseif DiceResult == 2 then
		player:Say("D8 Roll: 3");
	elseif DiceResult == 3 then
		player:Say("D8 Roll: 4");
	elseif DiceResult == 4 then
		player:Say("D8 Roll: 5");
	elseif DiceResult == 5 then
		player:Say("D8 Roll: 6");
	elseif DiceResult == 6 then
		player:Say("D8 Roll: 7");
	else
		player:Say("D8 Roll: 8");
	end
end


-- dice D10
function Wiz_DiceRollD10(items, result, player)
    local DiceResult = ZombRand(10);
	if DiceResult == 0 then
		player:Say("D10 Roll: 1");
	elseif DiceResult == 1 then
		player:Say("D10 Roll: 2");
	elseif DiceResult == 2 then
		player:Say("D10 Roll: 3");
	elseif DiceResult == 3 then
		player:Say("D10 Roll: 4");
	elseif DiceResult == 4 then
		player:Say("D10 Roll: 5");
	elseif DiceResult == 5 then
		player:Say("D10 Roll: 6");
	elseif DiceResult == 6 then
		player:Say("D10 Roll: 7");
	elseif DiceResult == 7 then
		player:Say("D10 Roll: 8");
	elseif DiceResult == 8 then
		player:Say("D10 Roll: 9");
	else
		player:Say("D10 Roll: 10");
	end
end


-- dice D12
function Wiz_DiceRollD12(items, result, player)
    local DiceResult = ZombRand(12);
	if DiceResult == 0 then
		player:Say("D12 Roll: 1");
	elseif DiceResult == 1 then
		player:Say("D12 Roll: 2");
	elseif DiceResult == 2 then
		player:Say("D12 Roll: 3");
	elseif DiceResult == 3 then
		player:Say("D12 Roll: 4");
	elseif DiceResult == 4 then
		player:Say("D12 Roll: 5");
	elseif DiceResult == 5 then
		player:Say("D12 Roll: 6");
	elseif DiceResult == 6 then
		player:Say("D12 Roll: 7");
	elseif DiceResult == 7 then
		player:Say("D12 Roll: 8");
	elseif DiceResult == 8 then
		player:Say("D12 Roll: 9");
	elseif DiceResult == 9 then
		player:Say("D12 Roll: 10");
	elseif DiceResult == 10 then
		player:Say("D12 Roll: 11");
	else
		player:Say("D12 Roll: 12");
	end
end



-- dice D20
function Wiz_DiceRollD20(items, result, player)
    local DiceResult = ZombRand(20);
	if DiceResult == 0 then
		player:Say("D20 Roll: 1");
	elseif DiceResult == 1 then
		player:Say("D20 Roll: 2");
	elseif DiceResult == 2 then
		player:Say("D20 Roll: 3");
	elseif DiceResult == 3 then
		player:Say("D20 Roll: 4");
	elseif DiceResult == 4 then
		player:Say("D20 Roll: 5");
	elseif DiceResult == 5 then
		player:Say("D20 Roll: 6");
	elseif DiceResult == 6 then
		player:Say("D20 Roll: 7");
	elseif DiceResult == 7 then
		player:Say("D20 Roll: 8");
	elseif DiceResult == 8 then
		player:Say("D20 Roll: 9");
	elseif DiceResult == 9 then
		player:Say("D20 Roll: 10");
	elseif DiceResult == 10 then
		player:Say("D20 Roll: 11");
	elseif DiceResult == 11 then
		player:Say("D20 Roll: 12");
	elseif DiceResult == 12 then
		player:Say("D20 Roll: 13");
	elseif DiceResult == 13 then
		player:Say("D20 Roll: 14");
	elseif DiceResult == 14 then
		player:Say("D20 Roll: 15");
	elseif DiceResult == 15 then
		player:Say("D20 Roll: 16");
	elseif DiceResult == 16 then
		player:Say("D20 Roll: 17");
	elseif DiceResult == 17 then
		player:Say("D20 Roll: 18");
	elseif DiceResult == 18 then
		player:Say("D20 Roll: 19");
	else
		player:Say("D20 Roll: 20");
	end
end




-- Open D&D pack
function Wiz_DungeonsBoxOpen(items, result, player) 
    player:getInventory():AddItem("Base.Wiz_RPGDicesSet");
	player:getInventory():AddItems("Base.Journal", 4);
	
end

--Necronomicon
function WizNecronomiconRead(items, result, player)
	local player = getPlayer();
	local WizNecronomicomMod1 = 80;
    local WizNecronomicomMod2 = 0.8; 	
	player:Say("Kunda");
	player:Say("Astratta");
	player:Say("Montosse");
	player:Say("Kanda");
	WizNecronomiconEffectA(player, WizNecronomicomMod1);
	WizNecronomiconEffectB(player, WizNecronomicomMod2);
	getSoundManager():PlayWorldSoundWav('wiz_joinus', false, player:getSquare(), 0, 40, 2, true);
end

function WizNecronomiconEffectA(player, WizNecronomicomMod1)
	player:getBodyDamage():setUnhappynessLevel(player:getBodyDamage():getUnhappynessLevel() + WizNecronomicomMod1);
end

function WizNecronomiconEffectB(player, WizNecronomicomMod2)
	player:getStats():setStress(player:getStats():getStress() + WizNecronomicomMod2);
	player:getBodyDamage():IncreasePanic(20.0);
end



--Random Dust
function Wiz_GenRandomDust(items, result, player)
	local player = getPlayer()
    local RandDust = ZombRand(9);
	
	if RandDust < 4 then
		player:getInventory():AddItem("Base.Wiz_DustPile_Silica");
		
	elseif RandDust == 4 then
		player:getInventory():AddItem("Base.Wiz_DustPile_Coal");
		
	elseif RandDust == 5 then
		player:getInventory():AddItem("Base.Wiz_DustPile_Saltpeter");
		
	elseif RandDust == 6 then
		player:getInventory():AddItem("Base.Wiz_DustPile_Sulfur");
		
	elseif RandDust == 7 then
		player:getInventory():AddItem("Base.Wiz_DustPile_Iron");
		
	elseif RandDust == 8 then
		player:getInventory():AddItem("Base.Wiz_DustPile_Salt");
		
	end
	
end


--- HEALING POTION not working ATM
function OnEat_HealPotionEffect(food, player)
	local player = getPlayer()
    local WizLifeModA = 25;
	player:getBodyDamage():setOverallBodyHealth(player:getBodyDamage():getOverallBodyHealth() + WizLifeModA);
end



--Random Contact Lenses
function Wiz_GenRandomLenses(items, result, player)
	local player = getPlayer()
    local RandLens = ZombRand(15);
	
	if RandLens < 4 then
		player:getInventory():AddItem("Base.Wiz_ContactLens_blue");
		
	elseif RandLens == 4 then
		player:getInventory():AddItem("Base.Wiz_ContactLens_green");
		
	elseif RandLens == 5 then
		player:getInventory():AddItem("Base.Wiz_ContactLens_green");
		
	elseif RandLens == 6 then
		player:getInventory():AddItem("Base.Wiz_ContactLens_green");
		
	elseif RandLens == 7 then
		player:getInventory():AddItem("Base.Wiz_ContactLens_green");
		
	elseif RandLens == 8 then
		player:getInventory():AddItem("Base.Wiz_ContactLens_honey");
	
	elseif RandLens == 9 then
		player:getInventory():AddItem("Base.Wiz_ContactLens_honey");
		
	elseif RandLens == 10 then
		player:getInventory():AddItem("Base.Wiz_ContactLens_purple");
		
	elseif RandLens == 11 then
		player:getInventory():AddItem("Base.Wiz_ContactLens_purple");
		
	elseif RandLens == 12 then
		player:getInventory():AddItem("Base.Wiz_ContactLens_reptile");
		
	elseif RandLens == 13 then
		player:getInventory():AddItem("Base.Wiz_ContactLens_demon");
		
	elseif RandLens == 14 then
		player:getInventory():AddItem("Base.Wiz_ContactLens_allred");
		
	end
	
end



function Wiz_mariomushsound(items, result, player)
	local player = getPlayer();
	getSoundManager():PlayWorldSoundWav('Wiz_mariomushroomgrow', false, player:getSquare(), 0, 40, 2, true);
end

-- Member Berry random voices
function Wiz_memberberrysounds(food, player)
	local player = getPlayer();
	local BerrySound = ZombRand(8);
	
	if BerrySound == 0 then
		getSoundManager():PlayWorldSoundWav('wiz_member_ghostbusters', false, player:getSquare(), 0, 40, 2, true);
		
	elseif BerrySound == 1 then
		getSoundManager():PlayWorldSoundWav('wiz_membe_tatoine', false, player:getSquare(), 0, 40, 2, true);
		
	elseif BerrySound == 2 then
		getSoundManager():PlayWorldSoundWav('wiz_membe_goonies', false, player:getSquare(), 0, 40, 2, true);
		
	elseif BerrySound == 3 then
		getSoundManager():PlayWorldSoundWav('wiz_membe_lando', false, player:getSquare(), 0, 40, 2, true);
		
	elseif BerrySound == 4 then
		getSoundManager():PlayWorldSoundWav('wiz_membe_fellsafe', false, player:getSquare(), 0, 40, 2, true);
		
	elseif BerrySound == 5 then
		getSoundManager():PlayWorldSoundWav('wiz_membe_killya', false, player:getSquare(), 0, 40, 2, true);
		
	elseif BerrySound == 6 then
		getSoundManager():PlayWorldSoundWav('wiz_membe_deathstar', false, player:getSquare(), 0, 40, 2, true);
		
	elseif BerrySound == 7 then
		getSoundManager():PlayWorldSoundWav('wiz_membe_tantan', false, player:getSquare(), 0, 40, 2, true);
		
	end
	
end


-- Member Berry random voices
function Wiz_memberberrytalk(items, result, player)
	local player = getPlayer();
	local BerrySound = ZombRand(8);
	
	if BerrySound == 0 then
		getSoundManager():PlayWorldSoundWav('wiz_member_ghostbusters', false, player:getSquare(), 0, 40, 2, true);
		
	elseif BerrySound == 1 then
		getSoundManager():PlayWorldSoundWav('wiz_membe_tatoine', false, player:getSquare(), 0, 40, 2, true);
		
	elseif BerrySound == 2 then
		getSoundManager():PlayWorldSoundWav('wiz_membe_goonies', false, player:getSquare(), 0, 40, 2, true);
		
	elseif BerrySound == 3 then
		getSoundManager():PlayWorldSoundWav('wiz_membe_lando', false, player:getSquare(), 0, 40, 2, true);
		
	elseif BerrySound == 4 then
		getSoundManager():PlayWorldSoundWav('wiz_membe_fellsafe', false, player:getSquare(), 0, 40, 2, true);
		
	elseif BerrySound == 5 then
		getSoundManager():PlayWorldSoundWav('wiz_membe_killya', false, player:getSquare(), 0, 40, 2, true);
		
	elseif BerrySound == 6 then
		getSoundManager():PlayWorldSoundWav('wiz_membe_deathstar', false, player:getSquare(), 0, 40, 2, true);
		
	elseif BerrySound == 7 then
		getSoundManager():PlayWorldSoundWav('wiz_membe_tantan', false, player:getSquare(), 0, 40, 2, true);
		
	end
	
end


--Fairy Dust Sniff Effect
function Wiz_fairydustsniff(items, result, player)
	local FairyStressMod = 1.0;
	local FairyDrunkennessMod = 90;
	FairyDust_Effect1(player, FairyStressMod);
	FairyDust_Effect2(player, FairyDrunkennessMod);
end

function FairyDust_Effect1(player, FairyStressMod)
	player:getStats():setStress(player:getStats():getStress() - FairyStressMod);	
end

function FairyDust_Effect2(player, FairyDrunkennessMod)
	player:getStats():setDrunkenness(player:getStats():getDrunkenness() + FairyDrunkennessMod);	
end


-- Pikachu talking
function Wiz_pikachutalk(items, result, player)
	local player = getPlayer();
	local PikaSound = ZombRand(4);
	
	if PikaSound == 0 then
		getSoundManager():PlayWorldSoundWav('wiz_pika1', false, player:getSquare(), 0, 40, 2, true);
		
	elseif PikaSound == 1 then
		getSoundManager():PlayWorldSoundWav('wiz_pika2', false, player:getSquare(), 0, 40, 2, true);
		
	elseif PikaSound == 2 then
		getSoundManager():PlayWorldSoundWav('wiz_pika3', false, player:getSquare(), 0, 40, 2, true);
		
	elseif PikaSound == 3 then
		getSoundManager():PlayWorldSoundWav('wiz_pika4', false, player:getSquare(), 0, 40, 2, true);
		
	end
	
end


-- Clover Luck
function WizEatClover(items, result, player)
	local player = getPlayer() 
	
    if not getPlayer():HasTrait("Unlucky") then
		if not getPlayer():HasTrait("Lucky") then
			getPlayer():getTraits():add("Lucky");
			player:Say("I fell i got a bless from the Luck gods");
		else end
	 else
	 player:Say("I was borned cursed so eating this clover wont help me :(");
	end
end