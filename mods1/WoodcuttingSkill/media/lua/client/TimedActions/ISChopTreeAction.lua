--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

require "TimedActions/ISBaseTimedAction"

ISChopTreeAction = ISBaseTimedAction:derive("ISChopTreeAction")

function ISChopTreeAction:isValid()
	return self.tree ~= nil and self.tree:getObjectIndex() >= 0 and
			self.character:CanAttack() and
			self.character:getPrimaryHandItem() ~= nil and
            self.character:getPrimaryHandItem():getScriptItem():getCategories():contains("Axe")
end

function ISChopTreeAction:waitToStart()
	self.character:faceThisObject(self.tree)
	return self.character:shouldBeTurning()
end

function ISChopTreeAction:update()
    self.axe:setJobDelta(self:getJobDelta());

	self.character:faceThisObject(self.tree)

    if instanceof(self.character, "IsoPlayer") then
        self.character:setMetabolicTarget(Metabolics.ForestryAxe);
    end
end

function ISChopTreeAction:start()

    self.axe = self.character:getPrimaryHandItem()
	self.axeTreeDamage = self.axe:getTreeDamage()
	self.axe:setTreeDamage(self.axeTreeDamage  + self.perkLevel*Woodcutting.Settings.bonusAxeTreeDamagePerLevel)
	
	-- FOR DEBUG :
	if Woodcutting.testMode then
		Woodcutting.noise("Tree Sprite = '" ..self.tree:getSprite():getName().."'")
		Woodcutting.noise("Tree Size = '"..self.tree:getSize().."'")
		Woodcutting.noise("Perk Level = "..self.perkLevel)
		Woodcutting.noise("Axe Tree Damage = "..self.axeTreeDamage .." -> "..self.axe:getTreeDamage())
		Woodcutting.noise("Calories Modifier = "..self.caloriesModifier)
	end


--    self.action:setTime(math.max((self.tree:getHealth() / self.axe:getTreeDamage()) * 62, 30)) --62 is as close as I can get to making the timer sync up. -Fox
    self.axe:setJobType(getText("ContextMenu_Chop_Tree"));
    self.axe:setJobDelta(0.0);
	if self.character:isTimedActionInstant() then
		self.tree:setHealth(1)
    end
    self:setActionAnim(CharacterActionAnims.Chop_tree);

    self:setOverrideHandModels(self.axe, nil)
end

function ISChopTreeAction:stop()
    self.axe:setJobDelta(0.0);

	self.axe:setTreeDamage(self.axeTreeDamage)
    ISBaseTimedAction.stop(self)
end

function ISChopTreeAction:randomizeFood(foodItem)
	foodItem:setName(foodItem:getDisplayName() .. " (" .. getText("UI_foraging_WildFood") .. ")");
	local sizeModifier = ((ZombRand(50) + 25) / 100);
	sizeModifier = sizeModifier + ((ZombRand(self.perkLevel+self.character:getPerkLevel(Perks.PlantScavenging)) + 1) / 40)
	if foodItem:getBaseHunger() <= -0.02 then
		foodItem:setBaseHunger(foodItem:getBaseHunger() * sizeModifier);
		foodItem:setHungChange(foodItem:getHungChange() * sizeModifier);
		foodItem:setCarbohydrates(foodItem:getCarbohydrates() * sizeModifier);
		foodItem:setLipids(foodItem:getLipids() * sizeModifier);
		foodItem:setProteins(foodItem:getProteins() * sizeModifier);
		foodItem:setCalories(foodItem:getCalories() * sizeModifier);
		foodItem:setUnhappyChange(foodItem:getUnhappyChange() * sizeModifier);
	end;
end

function ISChopTreeAction:rollSpawnExtraMaterials()
	if self.tree:getSize() < 3 then return; end
	local fruit = false
	local fruitItem = nil
	local fruitNumber = 0
	local settings = Woodcutting.Settings
	local chanceSettings = settings.ChanceOfExtrasOneIn
	for i=0, self.tree:getSize(), 1 do
		if self.perkLevel > i then
			if ZombRand(chanceSettings.Log - self.perkLevel - i) == 0 then
				self.treeSquare:AddWorldInventoryItem("Base.Log", self.treeSquare:getX() + ZombRand(0, 10)/10, self.treeSquare:getY() + ZombRand(0, 10)/10, self.treeSquare:getZ())
				self.character:getXp():AddXP(Perks.Woodcutting, 6*Woodcutting.Settings.xpMultiplier)
				Woodcutting.noise("ISChopTreeAction:perform() : spawned a log")
			end
			if ZombRand(chanceSettings.TreeBranch - self.perkLevel - i) == 0 then
				self.treeSquare:AddWorldInventoryItem("Base.TreeBranch", self.treeSquare:getX() + ZombRand(0, 10)/10, self.treeSquare:getY() + ZombRand(0, 10)/10, self.treeSquare:getZ())
				self.character:getXp():AddXP(Perks.Woodcutting, 4*Woodcutting.Settings.xpMultiplier)
				Woodcutting.noise("ISChopTreeAction:perform() : spawned a tree branch")
			end
			if ZombRand(chanceSettings.Twigs - self.perkLevel - i) == 0 then
				self.treeSquare:AddWorldInventoryItem("Base.Twigs", self.treeSquare:getX() + ZombRand(0, 10)/10, self.treeSquare:getY() + ZombRand(0, 10)/10, self.treeSquare:getZ())
				self.character:getXp():AddXP(Perks.Woodcutting, 3*Woodcutting.Settings.xpMultiplier)
				Woodcutting.noise("ISChopTreeAction:perform() : spawned a twig")
			end
			if Woodcutting.TreePineSpriteDefinitions[self.treeSprite] then -- for pine trees
				if ZombRand(chanceSettings.Pinecone - self.perkLevel - i) == 0 then
					self.treeSquare:AddWorldInventoryItem("Base.Pinecone", self.treeSquare:getX() + ZombRand(0, 10)/10, self.treeSquare:getY() + ZombRand(0, 10)/10, self.treeSquare:getZ())
					self.character:getXp():AddXP(Perks.Woodcutting, 4*Woodcutting.Settings.xpMultiplier)
					Woodcutting.noise("ISChopTreeAction:perform() : spawned a pinecone")
				end
				local foragingLevel = self.character:getPerkLevel(Perks.PlantScavenging)
				local cumulatedLevels = foragingLevel + self.perkLevel
				if cumulatedLevels >= settings.cumulatedForagingAndWoodcuttingSkillLevelForFruit then
					if ZombRand(chanceSettings.PineTreeExtra - cumulatedLevels - i) == 0 then
						if not fruit then
							fruit = Woodcutting.PineTreeExtrasList[ZombRand(1, #Woodcutting.PineTreeExtrasList)]
						end
						if forageDefs[fruit] then
							
							fruitItem = InventoryItemFactory.CreateItem(forageDefs[fruit].type)
							self:randomizeFood(fruitItem)
							fruitNumber = fruitNumber + 1
							self.treeSquare:AddWorldInventoryItem(fruitItem, self.treeSquare:getX() + ZombRand(0, 10)/10, self.treeSquare:getY() + ZombRand(0, 10)/10, self.treeSquare:getZ())
							self.character:getXp():AddXP(Perks.Woodcutting, forageDefs[fruit].xp*Woodcutting.Settings.xpMultiplier*15)
							self.character:getXp():AddXP(Perks.PlantScavenging, forageDefs[fruit].xp)
							Woodcutting.noise("ISChopTreeAction:perform() : spawned a ".. fruit)
						end
					end
				end

			else
				local cumulatedLevels = self.character:getPerkLevel(Perks.PlantScavenging) + self.perkLevel
				if cumulatedLevels >= settings.cumulatedForagingAndWoodcuttingSkillLevelForFruit then
					if (getGameTime():getMonth() + 1) >= 11 or (getGameTime():getMonth() + 1) <= 2 then -- disable fruits in winter
						if ZombRand(chanceSettings.Winter - cumulatedLevels - i) == 0 then


							if not fruit then
								fruit = Woodcutting.TreeFruitsWinterList[ZombRand(1, #Woodcutting.TreeFruitsWinterList)]
							end
							if forageDefs[fruit] then
								
								fruitItem = InventoryItemFactory.CreateItem(forageDefs[fruit].type)
								self:randomizeFood(fruitItem)
								fruitNumber = fruitNumber + 1
								
								self.treeSquare:AddWorldInventoryItem(fruitItem, self.treeSquare:getX() + ZombRand(0, 10)/10, self.treeSquare:getY() + ZombRand(0, 10)/10, self.treeSquare:getZ())
								self.character:getXp():AddXP(Perks.Woodcutting, forageDefs[fruit].xp*Woodcutting.Settings.xpMultiplier*15)
								self.character:getXp():AddXP(Perks.PlantScavenging, forageDefs[fruit].xp)
								Woodcutting.noise("ISChopTreeAction:perform() : spawned a ".. fruit)
							end
						end
					else
						if ZombRand(chanceSettings.FruitTreeExtra - cumulatedLevels - i) == 0 then

							if not fruit then
								fruit = Woodcutting.TreeFruitExtrasList[ZombRand(1, #Woodcutting.TreeFruitExtrasList)]
							end
							if forageDefs[fruit] then

								
								fruitItem = InventoryItemFactory.CreateItem(forageDefs[fruit].type)
								self:randomizeFood(fruitItem)
								self.treeSquare:AddWorldInventoryItem(fruitItem, self.treeSquare:getX() + ZombRand(0, 10)/10, self.treeSquare:getY() + ZombRand(0, 10)/10, self.treeSquare:getZ())
								fruitNumber = fruitNumber + 1
								self.character:getXp():AddXP(Perks.Woodcutting, forageDefs[fruit].xp*Woodcutting.Settings.xpMultiplier)
								self.character:getXp():AddXP(Perks.PlantScavenging, forageDefs[fruit].xp*Woodcutting.Settings.xpMultiplier)
								if fruit == "Acorn" and fruitNumber < 2 then 
									local fruitItem2 = InventoryItemFactory.CreateItem(forageDefs[fruit].type)
									self:randomizeFood(fruitItem2)
									fruitNumber = fruitNumber + 1
									self.treeSquare:AddWorldInventoryItem(fruitItem2, self.treeSquare:getX() + ZombRand(0, 10)/10, self.treeSquare:getY() + ZombRand(0, 10)/10, self.treeSquare:getZ())
									self.character:getXp():AddXP(Perks.Woodcutting, forageDefs[fruit].xp*Woodcutting.Settings.xpMultiplier*15)
									self.character:getXp():AddXP(Perks.PlantScavenging, forageDefs[fruit].xp)
									Woodcutting.noise("ISChopTreeAction:perform() : spawned a ".. fruit)
								end
								Woodcutting.noise("ISChopTreeAction:perform() : spawned a ".. fruit)
							end
						end
					end
				end
			end
		else
			break;
		end
	end

	if fruit and fruitItem then
		HaloTextHelper.addText(self.character, fruitItem:getName()..(fruitNumber > 1 and " x"..fruitNumber or ""), HaloTextHelper:getColorGreen())
	end
end


function ISChopTreeAction:perform()
    self.axe:setJobDelta(0.0);
	
	self:rollSpawnExtraMaterials()
	self.axe:setTreeDamage(self.axeTreeDamage)
	self.character:getXp():AddXP(Perks.Woodcutting, self.tree:getSize()*Woodcutting.Settings.xpMultiplier)
	if self.tree:getSize() > 5 then
		self.character:getXp():AddXP(Perks.Woodcutting, 3*self.tree:getSize()*Woodcutting.Settings.xpMultiplier)
	end
	if not self.character:getModData().treekills then
		self.character:getModData().treekills = 1
	else
		self.character:getModData().treekills = self.character:getModData().treekills + 1
	end

	-- trigger refresh inventory window to show extra materials
	-- ISInventoryPage:refreshBackpacks()

    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self)
end

function ISChopTreeAction:animEvent(event, parameter)
	if event == 'ChopTree' then
		self.tree:WeaponHit(self.character, self.axe)
		if self.perkLevel < Woodcutting.Settings.skillLevelForNoSevereExhaustion or self.character:getStats():getEndurance() > 0.26 then
			self:useEndurance()
		end
		local chanceToLowerConditionOneIn = self.axe:getConditionLowerChance() * 2 + self.character:getMaintenanceMod() * 2  + math.floor(self.perkLevel)*Woodcutting.Settings.bonusConditionLowerOneInPerLevel + 1
		if ZombRand(chanceToLowerConditionOneIn) == 0 then
			self.axe:setCondition(self.axe:getCondition() - 1)
			self.character:getXp():AddXP(Perks.Woodcutting, 0.5*Woodcutting.Settings.xpMultiplier)
			ISWorldObjectContextMenu.checkWeapon(self.character);
		else
			self.character:getXp():AddXP(Perks.Maintenance, 1)
			self.character:getXp():AddXP(Perks.Woodcutting, 1*Woodcutting.Settings.xpMultiplier)
		end
		if self.tree:getObjectIndex() == -1 then
			self:forceComplete()
		end
	end
end

function ISChopTreeAction:useEndurance()
	if self.axe:isUseEndurance() then
		local use = self.axe:getWeight() * self.axe:getFatigueMod(self.character) * self.character:getFatigueMod() * self.axe:getEnduranceMod() * 0.1
		local useChargeDelta = 1.0
		use = use * useChargeDelta * 0.041
		if self.axe:isTwoHandWeapon() and self.character:getSecondaryHandItem() ~= self.axe then
			use = use + self.axe:getWeight() / 1.5 / 10 / 20
		end
		use = use * (1 - self.perkLevel*Woodcutting.Settings.enduranceSavedPerPerkLevel)
		self.character:getStats():setEndurance(self.character:getStats():getEndurance() - use)
	end
end

function ISChopTreeAction:new(character, tree)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.perkLevel = character:getPerkLevel(Perks.Woodcutting) + (character:HasTrait("Axeman") and 1 or 0)
	o.tree = tree
	o.treeSprite = tree:getSprite() and tree:getSprite():getName() or "none"
	o.treeSquare = tree:getSquare() or character:getCurrentSquare() or nil
	o.stopOnWalk = true
	o.stopOnRun = true
	o.maxTime = -1
	o.spriteFrame = 0
    o.caloriesModifier = 8 - math.floor(o.perkLevel * Woodcutting.Settings.caloriesSavedModifierPerLevel);
	o.forceProgressBar = true;
	return o
end
