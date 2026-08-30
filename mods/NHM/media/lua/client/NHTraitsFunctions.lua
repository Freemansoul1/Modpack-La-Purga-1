require('NPCs/MainCreationMethods');


local function ChangeSadness(player, amount)
	player:getBodyDamage():setUnhappynessLevel(player:getBodyDamage():getUnhappynessLevel() + amount);
	if player:getBodyDamage():getUnhappynessLevel() > 100 then
		player:getBodyDamage():setUnhappynessLevel(100);
	end
	if player:getBodyDamage():getUnhappynessLevel() < 0 then
		player:getBodyDamage():setUnhappynessLevel(0);
	end
end

local function ChangeBoredom(player, amount)
	player:getBodyDamage():setBoredomLevel(player:getBodyDamage():getBoredomLevel() + amount);
	if player:getBodyDamage():getBoredomLevel() < 0 then
		player:getBodyDamage():setBoredomLevel(0);
	end
	if player:getBodyDamage():getBoredomLevel() > 100 then
		player:getBodyDamage():setBoredomLevel(100);
	end
end

local function ChangePanic(player, amount)
	player:getStats():setPanic(player:getStats():getPanic() + amount);
	if player:getStats():getPanic() < 0 then
		player:getStats():setPanic(0);
	end
	if player:getStats():getPanic() > 100 then
		player:getStats():setPanic(100);
	end
end

local function ChangeStress(player, amount)
	player:getStats():setStress(math.max(0, player:getStats():getStress() - player:getStats():getStressFromCigarettes()) + amount);
	if player:getStats():getStress() < 0 then
		player:getStats():setStress(0);
	end
	if player:getStats():getStress() > 1 then
		player:getStats():setStress(1);
	end
end

local function TakeDamage(player, minhealth)
	if player:getBodyDamage():getOverallBodyHealth() >= minhealth then
		for i = 0, player:getBodyDamage():getBodyParts():size() - 1 do
			local b = player:getBodyDamage():getBodyParts():get(i);
			b:AddDamage(0.06 * math.ceil(GameSpeedMultiplier() * 1.25));
		end
	end
end

local function AddXP(player, perk, amount)
	if getCore():getGameVersion():getMajor() > 41 or (getCore():getGameVersion():getMajor() == 41 and getCore():getGameVersion():getMinor() >= 66) then
		player:getXp():AddXP(perk, amount, false, false, false);
	else
		player:getXp():AddXP(perk, amount, false, false);
	end
end


local function GymnastXP(player, perk, amount)
	if player:HasTrait("Gymnast") and player:getCurrentState() == FitnessState.instance() and (perk == Perks.Strength or perk == Perks.Fitness) then
		amount = amount * 6;
		AddXP(player, perk, amount);
	end
end

local function WeaponDamage(player, playerdata)
	local fatigue = player:getStats():getFatigue();
	local endurance = player:getStats():getEndurance();
	local panic = player:getStats():getPanic();
	local kills = player:getZombieKills();
	local multiplier = 1;
	local allow = false;
	if player:HasTrait("BrawlerNH") then
		if fatigue > 0.6 and fatigue < 0.7 then
			multiplier = multiplier + 0.75;
			allow = true;
		elseif fatigue > 0.7 and fatigue < 0.8 then
			multiplier = multiplier + 4;
			allow = true;
		elseif fatigue > 0.8 and fatigue < 0.9 then
			multiplier = multiplier + 6;
			allow = true;
		elseif fatigue > 0.9 then
			multiplier = multiplier + 8;
			allow = true;
		end
		if endurance < 0.75 and endurance > 0.5 then
			multiplier = multiplier + 0.75;
			allow = true;
		elseif endurance < 0.5 and endurance > 0.25 then
			multiplier = multiplier + 4;
			allow = true;
		elseif endurance < 0.25 and endurance > 0.1 then
			multiplier = multiplier + 6;
			allow = true;
		elseif endurance < 0.1 then
			multiplier = multiplier + 8;
			allow = true;
		end
	end
	if player:HasTrait("AdrenalineJunkie") then
		if panic > 6 and panic < 30 then
			multiplier = multiplier + 0.5;
			allow = true;
		elseif panic > 30 and panic < 65 then
			multiplier = multiplier + 0.65;
			allow = true;
		elseif panic > 65 then
			multiplier = multiplier + 1.07;
			allow = true;
		end
	end
	if player:HasTrait("Brave") then
		if panic > 30 and panic < 65 then
			multiplier = multiplier + 0.08;
			allow = true;
		elseif panic > 65 and panic < 80 then
			multiplier = multiplier + 0.15;
			allow = true;
		elseif panic > 80 then
			multiplier = multiplier + 0.2;
			allow = true;
		end
	end
	if player:getPrimaryHandItem() ~= nil then
		if player:getPrimaryHandItem():getCategory() == "Weapon" then
			if player:getPrimaryHandItem():getSubCategory() ~= "Firearm" then
				local item = player:getPrimaryHandItem();
				local itemdata = item:getModData();
				if itemdata.NHState == nil then
					itemdata.NHState = "Normal";
					itemdata.OrigMinDamage = item:getMinDamage();
					itemdata.OrigMaxDamage = item:getMaxDamage();
				end
				if allow == true and item:getMinDamage() ~= (itemdata.OrigMinDamage * multiplier) then
					itemdata.NHState = "Modified";
					item:setMinDamage(itemdata.OrigMinDamage * multiplier);
					item:setMaxDamage(itemdata.OrigMaxDamage * multiplier);
				end
				if allow == false then
					if itemdata.NHState ~= "Normal" then
						item:setMinDamage(itemdata.OrigMinDamage);
						item:setMaxDamage(itemdata.OrigMaxDamage);
					end
				end
			end
		end
	end
end

local function ReadingSadness(player, playerdata)
	if player:HasTrait("SlowReader") and player:isReading() == true then
		local increase = 0.5;
		ChangeBoredom(player, increase)
	end
end

local function ReadingBoredom(player, playerdata)
	local bodydamage = player:getBodyDamage();
	local boredom = bodydamage:getBoredomLevel();
	local sadness = bodydamage:getUnhappynessLevel();
	if player:HasTrait("FastReader") and player:isReading() == true then
		ChangeBoredom(player, -1);
		ChangeSadness(player, -1);
	end
end

local function HeartyAppetiteSadness(player, playerdata)
	local bodydamage = player:getBodyDamage();
	local stats = player:getStats();
	local sadness = bodydamage:getUnhappynessLevel();
	local hunger = stats:getHunger();
	if player:HasTrait("HeartyAppitite") and hunger > 0.25 then
		ChangeSadness(player, 0.3);
	end
	if player:HasTrait("HeartyAppitite") and hunger == 0 then
		ChangeSadness(player, -5);
	end
end

local function Angler(player, playerdata)
	local bodydamage = player:getBodyDamage();
	local profession = getPlayer():getDescriptor():getProfession()
	local stats = player:getStats();
	local panic = stats:getPanic();
	local stress = stats:getStress();
	local boredom = stats:getBoredom();
	local sadness = bodydamage:getUnhappynessLevel();
	if player:HasTrait("Fishing") or player:HasTrait("harpoon") then
		if player:getCurrentState() == FishingState.instance() then
			ChangePanic(player, -20);
			ChangeStress(player, -0.005);
			ChangeBoredom(player, -5);
			ChangeSadness(player, -2);
		end
	end
end


local function IronGutPreventsDeath(player, playerdata)
	local bodydamage = player:getBodyDamage();
	local foodsickness = bodydamage:getFoodSicknessLevel();
	local poison = bodydamage:getPoisonLevel();
	if player:HasTrait("IronGut") then
		if foodsickness > 89 then
			bodydamage:setFoodSicknessLevel(foodsickness - 20);
		end
		if bodydamage:getOverallBodyHealth() < 5 and poison ~= 0 then
			bodydamage:setPoisonLevel(0);
		end
	end
end

--local function OutdoorsmanHappiness(player, playerdata)
--	if player:HasTrait("Outdoorsman") then
--		if getZoneType(player:getX(), player:getY()) == "DeepForest" or getZoneType(player:getX(), player:getY()) == "Forest" then
--			ChangeSadness(player, -1);
--		end
--	end
--end

local function SniperAim(player)
	local item = player:getPrimaryHandItem()
	if item == nil then
		return
	end
	if item:getCategory() == "Weapon" then
		if item:getSubCategory() == "Firearm" then
			local itemdata = item:getModData();
			local aimingtime = item:getAimingTime();
			local range = item:getMaxRange();
			if itemdata.SniperState == nil then
				itemdata.SniperState = "Normal";
			end
			if player:HasTrait("Precision") and itemdata.SniperState ~= "Sniper" then
				item:setAimingTime(aimingtime - 10);
				item:setMaxRange(range + 5);
				itemdata.SniperState = "Sniper";
			end
			if player:HasTrait("Precision") == false and itemdata.SniperState ~= "Normal" then
				item:setAimingTime(aimingtime + 10);
				item:setMaxRange(range - 5);
				itemdata.SniperState = "Normal";
			end
		end
	end
end

local function QuickAim(player)
	local item = player:getPrimaryHandItem()
	if item == nil then
		return
	end
	if item:getCategory() == "Weapon" then
		if item:getSubCategory() == "Firearm" then
			local itemdata = item:getModData();
			local aimingtime = item:getAimingTime();
			if itemdata.QuickAState == nil then
				itemdata.QuickAState = "Normal";
			end
			if player:HasTrait("Shooter") and itemdata.QuickAState ~= "Quick" then
				item:setAimingTime(aimingtime + 4);
				itemdata.QuickAState = "Quick";
			end
			if player:HasTrait("Shooter") == false and itemdata.QuickAState ~= "Normal" then
				item:setAimingTime(aimingtime - 4);
				itemdata.QuickAState = "Normal";
				end
			end
		end
	end

local function Swordsboost(player)
	local item = player:getPrimaryHandItem()
	if item == nil then
		return
	end
	if item:getCategory() == "Weapon" then
		if tostring(item:getCategories()) == '[LongBlade]' then
			local itemdata = item:getModData();
			local critchance = item:getCriticalChance();
			local minangle = item:getMinAngle();
			if itemdata.LBState == nil then
				itemdata.LBState = "Normal";
			end
			if player:HasTrait("Cuttingedge") and itemdata.LBState ~= "Sharp" then
				print(item:getCriticalChance())
				print(item:getMinAngle())
				item:setCriticalChance(critchance + 20);
				item:setMinAngle(minangle - 0.2);
				itemdata.LBState = "Sharp";
				print(item:getCriticalChance())
				print(item:getMinAngle())
			end
			if player:HasTrait("Cuttingedge") == false and itemdata.LBState ~= "Normal" then
				print(item:getCriticalChance())
				print(item:getMinAngle())
				item:setCriticalChance(critchance - 20);
				item:setMinAngle(minangle + 0.2);
				print(item:getCriticalChance())
				print(item:getMinAngle())
				itemdata.LBState = "Normal";
			end
		end
	end
end

local function Knifeboost(player)
	local item = player:getPrimaryHandItem()
	if item == nil then
		return
	end
	if item:getCategory() == "Weapon" then
		if tostring(item:getCategories()) == '[SmallBlade]' then
			local itemdata = item:getModData();
			local critchance = item:getCriticalChance();
			local minrange = item:getMinRange();
			if itemdata.HeartState == nil then
				itemdata.HeartState = "Normal";
			end
			if player:HasTrait("Heartstrike") and itemdata.HeartState ~= "Heart" then
				print(item:getCriticalChance())
				print(item:getMinRange())
				item:setCriticalChance(critchance + 30);
				item:setMinRange(minrange - 0.3);
				itemdata.HeartState = "Heart";
				print(item:getCriticalChance())
				print(item:getMinRange())
			end
			if player:HasTrait("Heartstrike") == false and itemdata.HeartState ~= "Normal" then
				print(item:getCriticalChance())
				print(item:getMinRange())
				item:setCriticalChance(critchance - 30);
				item:setMinRange(minrange + 0.3);
				print(item:getCriticalChance())
				print(item:getMinRange())
				itemdata.HeartState = "Normal";
			end
		end
	end
end

local function IronlungsBoost(player)
	local item = player:getPrimaryHandItem()
	if item == nil then
		return
	end
	if item:getCategory() == "Weapon" then
		if tostring(item:getCategories()) == '[Blunt]' then
			local itemdata = item:getModData();
			local endurancemod = item:getEnduranceMod();
			if itemdata.SWState == nil then
				itemdata.SWState = "Normal";
			end
			if player:HasTrait("Ironlungs") and itemdata.SWState ~= "Bluntboost" then
				print(item:getEnduranceMod())
				item:setEnduranceMod(endurancemod / 2);
				itemdata.SWState = "Bluntboost";
				print(item:getEnduranceMod())
			end
			if player:HasTrait("Ironlungs") == false and itemdata.SWState ~= "Normal" then
				print(item:getEnduranceMod())
				item:setEnduranceMod(endurancemod * 2);
				itemdata.SWState = "Normal";
				print(item:getEnduranceMod())
			end
		end
	end
end


local function Spearboost(player)
	local item = player:getPrimaryHandItem()
	if item == nil then
		return
	end
	if item:getCategory() == "Weapon" then
		if tostring(item:getCategories()) == '[Improvised, Spear]' then
			local itemdata = item:getModData();
			local range = item:getMaxRange();
			if itemdata.LongshaftState == nil then
				itemdata.LongshaftState = "Normal";
			end
			if player:HasTrait("Longshaft") and itemdata.LongshaftState ~= "Long" then
				item:setMaxRange(range + 0.5);
				itemdata.LongshaftState = "Long";
			end
			if player:HasTrait("Longshaft") == false and itemdata.LongshaftState ~= "Normal" then
				item:setMaxRange(range - 0.5);
				itemdata.LongshaftState = "Normal";
			end
		end
	end
end

local function Swordway(player)
	local item = player:getPrimaryHandItem()
	if item == nil then
		return
	end
	if item:getCategory() == "Weapon" then
		if tostring(item:getCategories()) == '[LongBlade]' then
			local itemdata = item:getModData();
			local speed = item:getBaseSpeed();
			if itemdata.SwordwayState == nil then
				itemdata.SwordwayState = "Normal";
			end
			if player:HasTrait("Swordway") and itemdata.SwordwayState ~= "Way" then
				item:setBaseSpeed(speed + 1);
				itemdata.SwordwayState = "Way";
			end
			if player:HasTrait("Swordway") == false and itemdata.SwordwayState ~= "Normal" then
				item:setBaseSpeed(speed - 1);
				itemdata.SwordwayState = "Normal";
			end
		end
	end
end

local function Flurry(player)
	local item = player:getPrimaryHandItem()
	if item == nil then
		return
	end
	if item:getCategory() == "Weapon" then
		if tostring(item:getCategories()) == '[SmallBlade]' then
			local itemdata = item:getModData();
			local speed = item:getBaseSpeed();
			if itemdata.FlurryState == nil then
				itemdata.FlurryState = "Normal";
			end
			if player:HasTrait("Flurry") and itemdata.FlurryState ~= "Shank" then
				item:setBaseSpeed(speed + 1);
				itemdata.FlurryState = "Shank";
			end
			if player:HasTrait("Flurry") == false and itemdata.FlurryState ~= "Normal" then
				item:setBaseSpeed(speed - 1);
				itemdata.FlurryState = "Normal";
			end
		end
	end
end

local function Oiledweapon(player)
	local item = player:getPrimaryHandItem()
	if item == nil then
		return
	end
	if item:getCategory() == "Weapon" then
		if item:getSubCategory() == "Firearm" then
			local itemdata = item:getModData();
			local conditionlowerchance = item:getConditionLowerChance();
			local Jamchance = item:getJamGunChance();
			if itemdata.OilState == nil then
				itemdata.OilState = "Normal";
			end
			if player:HasTrait("Oiler") and itemdata.OilState ~= "Oiled" then
				print(item:getConditionLowerChance())
				print(item:getJamGunChance())
				item:setConditionLowerChance(conditionlowerchance * 1.5);
				item:setJamGunChance(Jamchance - 1);
				itemdata.OilState = "Oiled";
				print(item:getConditionLowerChance())
				print(item:getJamGunChance())
			end
			if player:HasTrait("Oiler") == false and itemdata.OilState ~= "Normal" then
				print(item:getConditionLowerChance())
				print(item:getJamGunChance())
				item:setConditionLowerChance(conditionlowerchance / 1.5);
				item:setJamGunChance(Jamchance + 1);
				itemdata.OilState = "Normal";
				print(item:getConditionLowerChance())
				print(item:getJamGunChance())
			end
		end
	end
end

local function Rustyweapon(player)
	local item = player:getPrimaryHandItem()
	if item == nil then
		return
	end
	if item:getCategory() == "Weapon" then
		if item:getSubCategory() == "Firearm" then
			local itemdata = item:getModData();
			local conditionlowerchance = item:getConditionLowerChance();
			local Jamchance = item:getJamGunChance();
			if itemdata.RustState == nil then
				itemdata.RustState = "Normal";
			end
			if player:HasTrait("Rust") and itemdata.RustState ~= "Rusty" then
				print(item:getConditionLowerChance())
				print(item:getJamGunChance())
				item:setConditionLowerChance(conditionlowerchance / 1.5);
				item:setJamGunChance(Jamchance + 1);
				itemdata.RustState = "Rusty";
				print(item:getConditionLowerChance())
				print(item:getJamGunChance())
			end
			if player:HasTrait("Rust") == false and itemdata.RustState ~= "Normal" then
				print(item:getConditionLowerChance())
				print(item:getJamGunChance())
				item:setConditionLowerChance(conditionlowerchance * 1.5);
				item:setJamGunChance(Jamchance - 1);
				itemdata.RustState = "Normal";
				print(item:getConditionLowerChance())
				print(item:getJamGunChance())
			end
		end
	end
end


local function MainPlayerUpdate(player)
	local playerdata = player:getModData();
	IronGutPreventsDeath(player, playerdata);
end

local function EveryOneMinute()
	local player = getPlayer();
	local playerdata = player:getModData();
	Angler(player, playerdata);
	HeartyAppetiteSadness(player, playerdata);
	ReadingBoredom(player, playerdata);
	ReadingSadness(player, playerdata);
	WeaponDamage(player, playerdata);
	--OutdoorsmanHappiness(player, playerdata);
end

local function MeleeArmor(player)
	local playerdata = player:getModData();
    local BDamage = player:getBodyDamage();
    local BParts = BDamage:getBodyParts();
	local avoid = ZombRand(100)
	local tableBDamage = {}

    for i=0, BParts:size()-1 do
		local bpart = BParts:get(i)
		local bpartType = tostring(bpart:getType())
		tableBDamage[bpartType] = {}
		tableBDamage[bpartType]["Bullet"] = bpart:haveBullet()
		tableBDamage[bpartType]["Health"] = bpart:getHealth()
	end

	if player:HasTrait("Avoidance") and playerdata.PrevBDamage ~= nil and avoid <= 20 then
		for i=0, BParts:size()-1 do
			local bpart = BParts:get(i)
			local bpartType = tostring(bpart:getType())
			if tableBDamage[bpartType]["Bullet"] and not playerdata.PrevBDamage[bpartType]["Bullet"] then
				bpart:RestoreToFullHealth();
					if tableBDamage[bpartType]["Health"] < playerdata.PrevBDamage[bpartType]["Health"] then
						bpart:SetHealth(playerdata.PrevBDamage[bpartType]["Health"])
					end
			end
		end
	end

	for i=0, BParts:size()-1 do
		local bpart = BParts:get(i)
		local bpartType = tostring(bpart:getType())
		tableBDamage[bpartType] = {}
		tableBDamage[bpartType]["Bullet"] = bpart:haveBullet()
		tableBDamage[bpartType]["Health"] = bpart:getHealth()
	end
	playerdata.PrevBDamage = tableBDamage
end

	Events.EveryOneMinute.Add(EveryOneMinute);
	Events.EveryTenMinutes.Add(EveryTenMinutes);
	Events.EveryHours.Add(EveryHour);
	Events.EveryDays.Add(EveryDay);
	Events.OnPlayerUpdate.Add(MainPlayerUpdate);
	Events.OnPlayerUpdate.Add(MeleeArmor);
	Events.OnNewGame.Add(Initialization);
	Events.OnEquipPrimary.Add(SniperAim);
	Events.OnEquipPrimary.Add(Oiledweapon);
	Events.OnEquipPrimary.Add(Rustyweapon);
	Events.OnEquipPrimary.Add(QuickAim);
	Events.OnEquipPrimary.Add(Swordsboost);
	Events.OnEquipPrimary.Add(Swordway);
	Events.OnEquipPrimary.Add(IronlungsBoost);
	Events.OnEquipPrimary.Add(Knifeboost);
	Events.OnEquipPrimary.Add(Flurry);
	Events.OnEquipPrimary.Add(Spearboost);
	Events.OnEquipPrimary.Add(DextrousItems);
	Events.OnEquipSecondary.Add(DextrousItems);
	Events.onItemFall.Add(DextrousItemsRecovery);
	Events.OnCreatePlayer.Add(OnCreatePlayer);
	Events.AddXP.Add(GymnastXP);
