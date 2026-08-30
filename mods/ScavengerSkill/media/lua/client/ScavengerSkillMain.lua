luckimpact = 1.0;

local function tableContains(t, e)
    for _, value in pairs(t) do
        if value == e then
            return true
        end
    end
    return false
end
local function istable(t)
    local type = type(t)
    return type == 'table'
end

local function ScavengerSkill_Scavenger(_iSInventoryPage, _state, _player)
    local player = _player;
    local playerData = player:getModData();
    local containerObj;
    local container;
	local basechance = 0;
	local modifier = 1.0;
	local lootRespawnSetting = SandboxVars.LootRespawn;
	local respawnDays = getRespawnDays(lootRespawnSetting);
	if player:getPerkLevel(Perks.Scavenging) == 0 then
		basechance = SandboxVars.ScavengerSkill.Level0FindChance;
		modifier = SandboxVars.ScavengerSkill.Level0BonusLoot * 0.01;
	end
	if player:getPerkLevel(Perks.Scavenging) == 1 then
		basechance = SandboxVars.ScavengerSkill.Level1FindChance;
		modifier = SandboxVars.ScavengerSkill.Level1BonusLoot * 0.01;
	end
	if player:getPerkLevel(Perks.Scavenging) == 2 then
		basechance = SandboxVars.ScavengerSkill.Level2FindChance;
		modifier = SandboxVars.ScavengerSkill.Level2BonusLoot * 0.01;
	end
	if player:getPerkLevel(Perks.Scavenging) == 3 then
		basechance = SandboxVars.ScavengerSkill.Level3FindChance;
		modifier = SandboxVars.ScavengerSkill.Level3BonusLoot * 0.01;
	end
	if player:getPerkLevel(Perks.Scavenging) == 4 then
		basechance = SandboxVars.ScavengerSkill.Level4FindChance;
		modifier = SandboxVars.ScavengerSkill.Level4BonusLoot * 0.01;
	end
	if player:getPerkLevel(Perks.Scavenging) == 5 then
		basechance = SandboxVars.ScavengerSkill.Level5FindChance;
		modifier = SandboxVars.ScavengerSkill.Level5BonusLoot * 0.01;
	end
	if player:getPerkLevel(Perks.Scavenging) == 6 then
		basechance = SandboxVars.ScavengerSkill.Level6FindChance;
		modifier = SandboxVars.ScavengerSkill.Level6BonusLoot * 0.01;
	end
	if player:getPerkLevel(Perks.Scavenging) == 7 then
		basechance = SandboxVars.ScavengerSkill.Level7FindChance;
		modifier = SandboxVars.ScavengerSkill.Level7BonusLoot * 0.01;
	end
	if player:getPerkLevel(Perks.Scavenging) == 8 then
		basechance = SandboxVars.ScavengerSkill.Level8FindChance;
		modifier = SandboxVars.ScavengerSkill.Level8BonusLoot * 0.01;
	end
	if player:getPerkLevel(Perks.Scavenging) == 9 then
		basechance = SandboxVars.ScavengerSkill.Level9FindChance;
		modifier = SandboxVars.ScavengerSkill.Level9BonusLoot * 0.01;
	end
	if player:getPerkLevel(Perks.Scavenging) == 10 then
		basechance = SandboxVars.ScavengerSkill.Level10FindChance;
		modifier = SandboxVars.ScavengerSkill.Level0BonusLoot * 0.01;
	end
	if player:HasTrait("Lucky") then
		basechance = basechance + 5 * luckimpact;
		modifier = modifier + 0.1 * luckimpact;
	end
	if player:HasTrait("Unlucky") then
		basechance = basechance - 5 * luckimpact;
		modifier = modifier - 0.1 * luckimpact;
	end
	for i, v in ipairs(_iSInventoryPage.backpacks) do
		if v.inventory:getParent() then
			containerObj = v.inventory:getParent();
			if not containerObj:getModData().bScroungeScavengerSkillolled and instanceof(containerObj, "IsoObject") and not instanceof(containerObj, "IsoDeadBody") and containerObj:getContainer() then
				containerObj:getModData().bScroungeScavengerSkillolled = true;
				containerObj:transmitModData();
				if ZombRand(100) <= basechance then
					local tempcontainer = {};
					container = containerObj:getContainer();
					if container:getItems() then
						for i = 0, container:getItems():size() - 1 do
							local item = container:getItems():get(i);
							if item ~= nil then
								if tableContains(tempcontainer, item:getFullType()) == false then
									table.insert(tempcontainer, item:getFullType());
									local count = container:getNumberOfItem(item:getFullType());
									local n = 1;
									local rolled = false;
									local skip = false;
									--Add a Special Case for Cigarettes since they inherently create 20 when added.
									if item:getFullType() == "Base.Cigarettes" then
										count = math.floor(count / 20);
									end
									local bchance = 5;
									if player:HasTrait("Lucky") then
										bchance = bchance + 2 * luckimpact;
									end
									if player:HasTrait("Unlucky") then
										bchance = bchance - 2 * luckimpact;
									end
									if item:getCategory() == "Food" or item:getCategory() == "FoodP" then
										bchance = bchance + 20;
										if item:isRotten() == true then
											skip = true;
										end
									end
									if item:IsDrainable() then
										bchance = bchance + 10;
									end
									if item:IsWeapon() then
										bchance = bchance + 5;
									end
									if count == 1 then
										if ZombRand(100) <= bchance then
											rolled = true;
										end
									elseif count > 1 and count < 5 then
										n = math.floor(count * modifier);
										rolled = true;
									elseif count >= 5 then
										n = math.floor((count * modifier) * 2)
										rolled = true;
									end
									if rolled and not skip then
										for iterator = 0, n - 1 do
											local addedItem = container:AddItem(item:getFullType())
											container:addItemOnServer(addedItem);
										end
										if ScavengerSkill.settings.ScavengerLootIndicator then
											HaloTextHelper.addText(player, "Found " .. item:getName(), true, HaloTextHelper.getColorGreen());
										end
										if ScavengerSkill.settings.ScavengerExpIndicator then
											HaloTextHelper.addTextWithArrow(player, getText("UI_GainSkill"), true, HaloTextHelper.getColorGreen());
										end
										player:getXp():AddXP(Perks.Scavenging, SandboxVars.ScavengerSkill.XPGain)
										if not playerData.scavengerTimerTbl then
											playerData.scavengerTimerTbl = {}
										end
										playerData.scavengerTimerTbl[containerObj] = respawnDays;
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

function getRespawnDays(setting)
	if setting == 1 then return 1000000	end
	if setting == 2 then return 1 end
	if setting == 3 then return 7 end
	if setting == 4 then return 30 end
	if setting == 5 then return 60 end
	return 1000000
end

local function ScavengingTimer(_player, _playerdata)
	local player = _player;
	local playerData = _playerdata;
	if not playerData.scavengerTimerTbl then
		playerData.scavengerTimerTbl = {}
	end
	local scavengerTimerTbl = playerData.scavengerTimerTbl;
	if scavengerTimerTbl ~= {} then
		for containerObj, timer in pairs(scavengerTimerTbl) do
			if timer <= 0 then
				scavengerTimerTbl[containerObj] = nil;
				containerObj:getModData().bScroungeScavengerSkillolled = false;
			else
				scavengerTimerTbl[containerObj] = timer - 1;
			end
		end
	end
end

local function EveryDays()
    local player = getPlayer();
    local playerdata = player:getModData();
	ScavengingTimer(player, playerdata);
end

local function ContainerEvents(_iSInventoryPage, _state)
    local page = _iSInventoryPage;
    local state = _state;
    if state == "end" then
        local player = getPlayer();
        ScavengerSkill_Scavenger(page, state, player);
    end
end

Events.EveryDays.Add(EveryDays);
Events.OnRefreshInventoryWindowContainers.Add(ContainerEvents);