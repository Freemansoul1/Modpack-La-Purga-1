--***********************************************************
--**                    ROBERT JOHNSON                     **
--***********************************************************

require "TimedActions/ISBaseTimedAction"
require "TimedActions/ISTakePillAction"

ISUseChem = ISBaseTimedAction:derive("ISUseChem");


function ISUseChem:isValid()
	return true
end

function ISUseChem:update()
    self.item:setJobDelta(self:getJobDelta());
end

function ISUseChem:start()
    self.item:setJobType(getText("ContextMenu_UseChem") ..' '.. self.item:getName());
    self.item:setJobDelta(0.0);

    self:setAnimVariable("ReadType", "book");

    self:setActionAnim(CharacterActionAnims.Read);
    self:setOverrideHandModels(self.item, nil);
end

function ISUseChem:stop()
    self.item:setJobDelta(0.0);
    ISBaseTimedAction.stop(self);
end

function ISUseChem:perform()

	local Fix = 0
	if self.item:getType() == "MedX" then

		self.character:getBodyDamage():setPainReduction(65.0);
		self.character:getStats():setPain(self.character:getStats():getPain() - 40.0);
		self.character:getStats():setFatigue(self.character:getStats():getFatigue() - 0.3);
		self.character:getStats():setStress(self.character:getStats():getStress() - 0.5);
		self.character:getBodyDamage():setUnhappynessLevel(self.character:getBodyDamage():getUnhappynessLevel() - 40.0);
		self.character:getBodyDamage():setBoredomLevel(self.character:getBodyDamage():getBoredomLevel() - 35.0);
		self.character:getStats():setDrunkenness(self.character:getStats():getDrunkenness() + 25);
		self.item:getContainer():setDrawDirty(true);
		self.character:getInventory():Remove(self.item);
		self.character:getInventory():AddItem("Base.EmptyMedX");

		self.character:playSound("Stimpack");

		if self.character:HasTrait("Hemophobic") then
		--Big blood baby trait time
			self.character:getStats():setPanic(self.character:getStats():getPanic() + 50.0);
			self.character:Say(getText("Tooltip_blood"));
		end
    elseif self.item:getType() == "Stimpack" then

		self.character:getBodyDamage():AddGeneralHealth(27.0 * 4);
		self.character:getBodyDamage():setPainReduction(10.0);
		self.character:getStats():setHunger(self.character:getStats():getHunger() + 0.02);
		self.character:getStats():setPain(self.character:getStats():getPain() - 10.0);
		self.item:getContainer():setDrawDirty(true);
		self.character:getInventory():Remove(self.item);
		self.character:getInventory():AddItem("Base.EmptyStimpack");

		self.character:playSound("Stimpack");

		if self.character:HasTrait("Hemophobic") then
			self.character:getStats():setPanic(self.character:getStats():getPanic() + 50.0);
			self.character:Say(getText("Tooltip_blood"));
		end
	elseif self.item:getType() == "Buffout" then

		self.character:getBodyDamage():setPainReduction(10.0);
		self.character:getStats():setFatigue(self.character:getStats():getFatigue() - 0.45);
		self.character:getStats():setEndurance(self.character:getStats():getEndurance() + 0.67);
		self.item:getContainer():setDrawDirty(true);
		self.character:getInventory():Remove(self.item);
		self.character:getInventory():AddItem("Base.EmptyBuffout");

		self.character:playSound("Mentats");
		local RandBuffout = ZombRand(6);
		if RandBuffout == 0 then
			self.character:getXp():AddXP(Perks.Lightfoot,getSandboxOptions():getOptionByName("ScientificChemistry.Buffout"):getValue());
		elseif RandBuffout == 1 then
			self.character:getXp():AddXP(Perks.Sprinting,getSandboxOptions():getOptionByName("ScientificChemistry.Buffout"):getValue());
		elseif RandBuffout == 2 then
			self.character:getXp():AddXP(Perks.Sneak,getSandboxOptions():getOptionByName("ScientificChemistry.Buffout"):getValue());
		elseif RandBuffout == 3 then
			self.character:getXp():AddXP(Perks.Nimble,getSandboxOptions():getOptionByName("ScientificChemistry.Buffout"):getValue());
		end	
	elseif self.item:getType() == "Bufftats" then

		self.character:getBodyDamage():setPainReduction(10.0);
		self.character:getStats():setFatigue(self.character:getStats():getFatigue() - 0.63);
		self.character:getStats():setEndurance(self.character:getStats():getEndurance() + 0.15);
		self.item:getContainer():setDrawDirty(true);
		self.character:getInventory():Remove(self.item);
		self.character:getInventory():AddItem("Base.EmptyBuffout");

		self.character:playSound("Mentats");
		local RandBuffout = ZombRand(6);
		if RandBuffout == 0 then
			self.character:getXp():AddXP(Perks.Lightfoot,getSandboxOptions():getOptionByName("ScientificChemistry.Buffout"):getValue()*3);
		elseif RandBuffout == 1 then
			self.character:getXp():AddXP(Perks.Sprinting,getSandboxOptions():getOptionByName("ScientificChemistry.Buffout"):getValue()*3);
		elseif RandBuffout == 2 then
			self.character:getXp():AddXP(Perks.Sneak,getSandboxOptions():getOptionByName("ScientificChemistry.Buffout"):getValue()*3);
		elseif RandBuffout == 3 then
			self.character:getXp():AddXP(Perks.Nimble,getSandboxOptions():getOptionByName("ScientificChemistry.Buffout"):getValue()*3);
		end	
		local RandMentats = ZombRand(10);
		if RandMentats == 0 then
			self.character:getXp():AddXP(Perks.Woodwork,getSandboxOptions():getOptionByName("ScientificChemistry.Mentats"):getValue()*3);
		elseif RandMentats == 1 then
			self.character:getXp():AddXP(Perks.Farming,getSandboxOptions():getOptionByName("ScientificChemistry.Mentats"):getValue()*3);
		elseif RandMentats == 2 then
			self.character:getXp():AddXP(Perks.Electricity,getSandboxOptions():getOptionByName("ScientificChemistry.Mentats"):getValue()*3);
		elseif RandMentats == 3 then
			self.character:getXp():AddXP(Perks.Doctor,getSandboxOptions():getOptionByName("ScientificChemistry.Mentats"):getValue()*3);
		elseif RandMentats == 4 then
			self.character:getXp():AddXP(Perks.Cooking,getSandboxOptions():getOptionByName("ScientificChemistry.Mentats"):getValue()*3);
		elseif RandMentats == 5 then
			self.character:getXp():AddXP(Perks.MetalWelding,getSandboxOptions():getOptionByName("ScientificChemistry.Mentats"):getValue()*3);
		elseif RandMentats == 6 then
			self.character:getXp():AddXP(Perks.Mechanics,getSandboxOptions():getOptionByName("ScientificChemistry.Mentats"):getValue()*3);
		elseif RandMentats == 7 then
			self.character:getXp():AddXP(Perks.Tailoring,getSandboxOptions():getOptionByName("ScientificChemistry.Mentats"):getValue()*3);
		end
	elseif self.item:getType() == "Buffjet" then

		self.character:getBodyDamage():setPainReduction(8.0);
		self.character:getStats():setFatigue(self.character:getStats():getFatigue() - 0.40);
		self.character:getStats():setEndurance(self.character:getStats():getEndurance() + 0.82);
		self.character:getStats():setStress(self.character:getStats():getStress() - 0.3);
		self.character:getStats():setPanic(self.character:getStats():getPanic() - 20.0);
		self.character:getBodyDamage():setUnhappynessLevel(self.character:getBodyDamage():getUnhappynessLevel() - 15.0);
		self.character:getBodyDamage():setBoredomLevel(self.character:getBodyDamage():getBoredomLevel() - 15.0);
		self.item:getContainer():setDrawDirty(true);
		self.character:getInventory():Remove(self.item);
		self.character:getInventory():AddItem("Base.EmptyBuffout");

		self.character:playSound("Mentats");
		local RandBuffout = ZombRand(6);
		if RandBuffout == 0 then
			self.character:getXp():AddXP(Perks.Lightfoot,getSandboxOptions():getOptionByName("ScientificChemistry.Buffout"):getValue());
		elseif RandBuffout == 1 then
			self.character:getXp():AddXP(Perks.Sprinting,getSandboxOptions():getOptionByName("ScientificChemistry.Buffout"):getValue());
		elseif RandBuffout == 2 then
			self.character:getXp():AddXP(Perks.Sneak,getSandboxOptions():getOptionByName("ScientificChemistry.Buffout"):getValue());
		elseif RandBuffout == 3 then
			self.character:getXp():AddXP(Perks.Nimble,getSandboxOptions():getOptionByName("ScientificChemistry.Buffout"):getValue());
		end	
	elseif self.item:getType() == "Daytrip" then

		self.character:getBodyDamage():setPainReduction(15.0);
		self.character:getStats():setFatigue(self.character:getStats():getFatigue() - 0.10);
		self.character:getStats():setAnger(self.character:getStats():getAnger() - 0.70);
		self.character:getBodyDamage():setUnhappynessLevel(self.character:getBodyDamage():getUnhappynessLevel() - 85.0);
		self.character:getBodyDamage():setBoredomLevel(self.character:getBodyDamage():getBoredomLevel() - 65.0);
		self.character:getStats():setFear(self.character:getStats():getFear() - 0.50);
		self.character:getStats():setPanic(self.character:getStats():getPanic() - 50.0);
		self.character:getStats():setStress(self.character:getStats():getStress() - 0.55);
		self.item:getContainer():setDrawDirty(true);
		self.character:getInventory():Remove(self.item);
		self.character:getInventory():AddItem("Base.EmptyDaytrip");

		self.character:playSound("Mentats");
		local RandDaytrip = ZombRand(20);
		if RandDaytrip == 0 then
			self.character:Say(getText("Tooltip_groovy1"));
		elseif RandDaytrip == 1 then
			self.character:Say(getText("Tooltip_groovy2"));
		elseif RandDaytrip == 2 then
			self.character:Say(getText("Tooltip_groovy3"));
		elseif RandDaytrip == 3 then
			self.character:Say(getText("Tooltip_groovy4"));
		elseif RandDaytrip == 4 then
			self.character:Say(getText("Tooltip_groovy5"));
		elseif RandDaytrip == 5 then
			self.character:Say(getText("Tooltip_groovy2"));
		elseif RandDaytrip == 6 then
			self.character:Say(getText("Tooltip_groovy2"));
		end	
	elseif self.item:getType() == "Jet" then

		self.character:getStats():setHunger(self.character:getStats():getHunger() + 0.025);
		self.character:getStats():setFatigue(self.character:getStats():getFatigue() - 0.15);
		self.character:getStats():setEndurance(self.character:getStats():getEndurance() + 0.12);
		self.character:getStats():setDrunkenness(self.character:getStats():getDrunkenness() + 3);
		self.character:getStats():setStress(self.character:getStats():getStress() - 0.3);
		self.character:getStats():setPanic(self.character:getStats():getPanic() - 20.0);
		self.character:getBodyDamage():setUnhappynessLevel(self.character:getBodyDamage():getUnhappynessLevel() - 15.0);
		self.character:getBodyDamage():setBoredomLevel(self.character:getBodyDamage():getBoredomLevel() - 15.0);
		self.item:getContainer():setDrawDirty(true);
		self.character:getInventory():Remove(self.item);
		self.character:getInventory():AddItem("Base.EmptyJet");

		self.character:playSound("Jet");
	elseif self.item:getType() == "Rocket" then

		self.character:getStats():setHunger(self.character:getStats():getHunger() + 0.055);
		self.character:getStats():setFatigue(self.character:getStats():getFatigue() - 0.30);
		self.character:getStats():setEndurance(self.character:getStats():getEndurance() + 0.24);
		self.character:getStats():setDrunkenness(self.character:getStats():getDrunkenness() + 5);
		self.character:getStats():setStress(self.character:getStats():getStress() - 0.35);
		self.character:getStats():setPanic(self.character:getStats():getPanic() - 30.0);
		self.character:getBodyDamage():setUnhappynessLevel(self.character:getBodyDamage():getUnhappynessLevel() - 15.0);
		self.character:getBodyDamage():setBoredomLevel(self.character:getBodyDamage():getBoredomLevel() - 15.0);
		self.item:getContainer():setDrawDirty(true);
		self.character:getInventory():Remove(self.item);
		self.character:getInventory():AddItem("Base.EmptyJet");

		self.character:playSound("Jet");
	elseif self.item:getType() == "Cateye" then

		self.character:getStats():setHunger(self.character:getStats():getHunger() + 0.10);
		self.character:getStats():setDrunkenness(self.character:getStats():getDrunkenness() + 10);
		self.item:getContainer():setDrawDirty(true);
		self.character:getInventory():Remove(self.item);
		if not self.character:HasTrait("NightVision") then
			self.character:getTraits():add("NightVision");
			self.character:getModData().CatVision = 4;
		end
		self.character:playSound("Mentats");
	elseif self.item:getType() == "Mentats" then

		self.character:getStats():setHunger(self.character:getStats():getHunger() + 0.02);
		self.character:getStats():setFatigue(self.character:getStats():getFatigue() - 0.35);
		self.character:getStats():setEndurance(self.character:getStats():getEndurance() + 0.08);
		self.character:getStats():setDrunkenness(self.character:getStats():getDrunkenness() - 85);
		self.character:getStats():setStress(self.character:getStats():getStress() - 0.75);
		self.character:getBodyDamage():setUnhappynessLevel(self.character:getBodyDamage():getUnhappynessLevel() - 15.0);
		self.character:getBodyDamage():setBoredomLevel(self.character:getBodyDamage():getBoredomLevel() - 10.0);
		self.item:getContainer():setDrawDirty(true);
		self.character:getInventory():Remove(self.item);
		self.character:getInventory():AddItem("Base.EmptyMentats");

		self.character:playSound("Mentats");
		local RandMentats = ZombRand(10);
		if RandMentats == 0 then
			self.character:getXp():AddXP(Perks.Woodwork,getSandboxOptions():getOptionByName("ScientificChemistry.Mentats"):getValue());
		elseif RandMentats == 1 then
			self.character:getXp():AddXP(Perks.Farming,getSandboxOptions():getOptionByName("ScientificChemistry.Mentats"):getValue());
		elseif RandMentats == 2 then
			self.character:getXp():AddXP(Perks.Electricity,getSandboxOptions():getOptionByName("ScientificChemistry.Mentats"):getValue());
		elseif RandMentats == 3 then
			self.character:getXp():AddXP(Perks.Doctor,getSandboxOptions():getOptionByName("ScientificChemistry.Mentats"):getValue());
		elseif RandMentats == 4 then
			self.character:getXp():AddXP(Perks.Cooking,getSandboxOptions():getOptionByName("ScientificChemistry.Mentats"):getValue());
		elseif RandMentats == 5 then
			self.character:getXp():AddXP(Perks.MetalWelding,getSandboxOptions():getOptionByName("ScientificChemistry.Mentats"):getValue());
		elseif RandMentats == 6 then
			self.character:getXp():AddXP(Perks.Mechanics,getSandboxOptions():getOptionByName("ScientificChemistry.Mentats"):getValue());
		elseif RandMentats == 7 then
			self.character:getXp():AddXP(Perks.Tailoring,getSandboxOptions():getOptionByName("ScientificChemistry.Mentats"):getValue());
		end
	elseif self.item:getType() == "Fixer" then

		self.character:getStats():setHunger(self.character:getStats():getHunger() + 0.15);
		self.character:getStats():setFatigue(self.character:getStats():getFatigue() + 0.10);
		self.character:getStats():setEndurance(self.character:getStats():getEndurance() - 0.05);
		self.character:getStats():setDrunkenness(self.character:getStats():getDrunkenness() - 85);
		self.item:getContainer():setDrawDirty(true);
		self.character:getInventory():Remove(self.item);
		self.character:getInventory():AddItem("Base.EmptyMentats");
		Fix = 1;

		self.character:playSound("Mentats");			
	elseif self.item:getType() == "SuperStimpack" then

		self.character:getBodyDamage():AddGeneralHealth(68.0 * 4);
		self.character:getBodyDamage():setPainReduction(35.0);
		self.character:getStats():setHunger(self.character:getStats():getHunger() + 0.01);
		self.character:getStats():setPain(self.character:getStats():getPain() - 35.0);
		self.character:getStats():setDrunkenness(self.character:getStats():getDrunkenness() + 15);
		self.item:getContainer():setDrawDirty(true);
		self.character:getInventory():Remove(self.item);
		self.character:getInventory():AddItem("Base.EmptyStimpack");

		self.character:playSound("Stimpack");
		
		if self.character:HasTrait("Hemophobic") then

			self.character:getStats():setPanic(self.character:getStats():getPanic() + 50.0);
			self.character:Say(getText("Tooltip_blood"));
		end
	elseif self.item:getType() == "Psycho" then

		self.character:getBodyDamage():AddGeneralHealth(35.0 * 4);
		self.character:getBodyDamage():setPainReduction(85.0);
		self.character:getStats():setAnger(self.character:getStats():getAnger() + 0.90);
		self.character:getStats():setThirst(self.character:getStats():getThirst() + 0.15);
		self.character:getStats():setPain(self.character:getStats():getPain() - 90.0);
		self.character:getStats():setEndurance(self.character:getStats():getEndurance() + 0.58);
		self.character:getStats():setFatigue(self.character:getStats():getFatigue() - 0.6);
		self.character:getStats():setFear(self.character:getStats():getFear() - 0.95);
		self.character:getStats():setPanic(self.character:getStats():getPanic() - 90.0);
		self.character:getStats():setStress(self.character:getStats():getStress() - 0.95);
		self.character:getStats():setDrunkenness(self.character:getStats():getDrunkenness() + 35);
		self.item:getContainer():setDrawDirty(true);
		self.character:getInventory():Remove(self.item);
		self.character:getInventory():AddItem("Base.EmptyPsycho");
		self.character:playSound("Stimpack");

		--self.character:setBetaEffect(0.90);
		--self.character:setBetaEffect(1200);
		--self.character:setBetaDelta(self.character:getBetaDelta() + 0.80);
		--These are suppose to control beta pills effects on the players but so far does nothing from my testing but it dosen't give back any errors. Strange'
		--Just subscribe to the anger plus mod lmao
		local RandPsycho = ZombRand(8);
		if RandPsycho == 0 then
			self.character:getXp():AddXP(Perks.LongBlunt,getSandboxOptions():getOptionByName("ScientificChemistry.Psycho"):getValue());
		elseif RandPsycho == 1 then
			self.character:getXp():AddXP(Perks.Shortblunt,getSandboxOptions():getOptionByName("ScientificChemistry.Psycho"):getValue());
		elseif RandPsycho == 2 then
			self.character:getXp():AddXP(Perks.LongBlade,getSandboxOptions():getOptionByName("ScientificChemistry.Psycho"):getValue());
		elseif RandPsycho == 3 then
			self.character:getXp():AddXP(Perks.Shortblade,getSandboxOptions():getOptionByName("ScientificChemistry.Psycho"):getValue());
		elseif RandPsycho == 4 then
			self.character:getXp():AddXP(Perks.Spear,getSandboxOptions():getOptionByName("ScientificChemistry.Psycho"):getValue());
		elseif RandPsycho == 5 then
			self.character:getXp():AddXP(Perks.Axe,getSandboxOptions():getOptionByName("ScientificChemistry.Psycho"):getValue());
		elseif RandPsycho == 6 then
			self.character:getXp():AddXP(Perks.Aiming,getSandboxOptions():getOptionByName("ScientificChemistry.Psycho"):getValue());
		elseif RandPsycho == 7 then
			self.character:getXp():AddXP(Perks.Reloading,getSandboxOptions():getOptionByName("ScientificChemistry.Psycho"):getValue());
		end

		if self.character:HasTrait("Hemophobic") then

			self.character:getStats():setPanic(self.character:getStats():getPanic() + 50.0);
		end
		self.character:Say(getText("Tooltip_FUCKING_KILL"));
	elseif self.item:getType() == "Slasher" then

		self.character:getBodyDamage():AddGeneralHealth(65.0 * 4);
		self.character:getBodyDamage():setPainReduction(98.0);
		self.character:getStats():setAnger(self.character:getStats():getAnger() + 0.99);
		self.character:getStats():setThirst(self.character:getStats():getThirst() + 0.20);
		self.character:getStats():setPain(self.character:getStats():getPain() - 98.0);
		self.character:getStats():setEndurance(self.character:getStats():getEndurance() + 0.85);
		self.character:getStats():setFatigue(self.character:getStats():getFatigue() - 0.75);
		self.character:getStats():setFear(self.character:getStats():getFear() - 0.99);
		self.character:getStats():setPanic(self.character:getStats():getPanic() - 99.0);
		self.character:getStats():setStress(self.character:getStats():getStress() - 0.99);
		self.character:getStats():setDrunkenness(self.character:getStats():getDrunkenness() + 50);
		self.item:getContainer():setDrawDirty(true);
		self.character:getInventory():Remove(self.item);
		self.character:getInventory():AddItem("Base.EmptyPsycho");
		self.character:playSound("Stimpack");

		--self.character:setBetaEffect(0.90);
		--self.character:setBetaEffect(1200);
		--self.character:setBetaDelta(self.character:getBetaDelta() + 0.80);
		--These are suppose to control beta pills effects on the players but so far does nothing from my testing but it dosen't give back any errors. Strange'
		--Just subscribe to the anger plus mod lmao
		local RandPsycho = ZombRand(8);
		if RandPsycho == 0 then
			self.character:getXp():AddXP(Perks.LongBlunt,getSandboxOptions():getOptionByName("ScientificChemistry.Psycho"):getValue());
		elseif RandPsycho == 1 then
			self.character:getXp():AddXP(Perks.Shortblunt,getSandboxOptions():getOptionByName("ScientificChemistry.Psycho"):getValue());
		elseif RandPsycho == 2 then
			self.character:getXp():AddXP(Perks.LongBlade,getSandboxOptions():getOptionByName("ScientificChemistry.Psycho"):getValue());
		elseif RandPsycho == 3 then
			self.character:getXp():AddXP(Perks.Shortblade,getSandboxOptions():getOptionByName("ScientificChemistry.Psycho"):getValue());
		elseif RandPsycho == 4 then
			self.character:getXp():AddXP(Perks.Spear,getSandboxOptions():getOptionByName("ScientificChemistry.Psycho"):getValue());
		elseif RandPsycho == 5 then
			self.character:getXp():AddXP(Perks.Axe,getSandboxOptions():getOptionByName("ScientificChemistry.Psycho"):getValue());
		elseif RandPsycho == 6 then
			self.character:getXp():AddXP(Perks.Aiming,getSandboxOptions():getOptionByName("ScientificChemistry.Psycho"):getValue());
		elseif RandPsycho == 7 then
			self.character:getXp():AddXP(Perks.Reloading,getSandboxOptions():getOptionByName("ScientificChemistry.Psycho"):getValue());
		end
		if self.character:HasTrait("Hemophobic") then

			self.character:getStats():setPanic(self.character:getStats():getPanic() + 50.0);
		end
		self.character:Say(getText("Tooltip_FUCKING_KILL"));
	elseif self.item:getType() == "Xcell" then

		self.character:getBodyDamage():AddGeneralHealth(15.0 * 4);
		self.character:getBodyDamage():setPainReduction(45.0);
		self.character:getStats():setThirst(self.character:getStats():getThirst() + 0.10);
		self.character:getStats():setPain(self.character:getStats():getPain() - 45.0);
		self.character:getStats():setEndurance(self.character:getStats():getEndurance() + 0.40);
		self.character:getStats():setFatigue(self.character:getStats():getFatigue() - 0.95);
		self.character:getStats():setDrunkenness(self.character:getStats():getDrunkenness() - 85);
		self.character:getBodyDamage():setUnhappynessLevel(self.character:getBodyDamage():getUnhappynessLevel() - 50.0);
		self.character:getBodyDamage():setBoredomLevel(self.character:getBodyDamage():getBoredomLevel() - 50.0);
		self.item:getContainer():setDrawDirty(true);
		self.character:getInventory():Remove(self.item);
		self.character:getInventory():AddItem("Base.EmptyXcell");

		self.character:playSound("Jet");
		local RandXcell = ZombRand(2);
		if RandXcell == 0 then
			self.character:getXp():AddXP(Perks.Fitness,getSandboxOptions():getOptionByName("ScientificChemistry.Xcell"):getValue());
		elseif RandXcell == 1 then
			self.character:getXp():AddXP(Perks.Strength,getSandboxOptions():getOptionByName("ScientificChemistry.Xcell"):getValue());
		end
	end
	local temp = self.character:getModData().ChemTemp;
	local temphour = self.character:getModData().HoursSinceChem;
	local temphourhalf = temphour/2;
	self.character:getModData().ChemTemp = temp + 1;
	if  Fix == 1 then 
		self.character:getModData().HoursSinceChem = temphour + temphourhalf + 4;
	else
		self.character:getModData().HoursSinceChem = 0;
	end

    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self);
end

function ISUseChem:new(character, item)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character;
    o.item = item;
    o.stopOnWalk = false;
    o.stopOnRun = true;
    o.ignoreHandsWounds = true;
    o.maxTime = 50;
    o.caloriesModifier = 0.5;
    if character:isTimedActionInstant() then
        o.maxTime = 1;
    end
    return o;
end