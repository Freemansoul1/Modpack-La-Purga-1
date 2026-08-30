local function zReDontSetZombiesOnFire()
	local zReDSZOFChance = SandboxVars.zReDSZOF.RunChance;
	local zombies = getWorld():getCell():getZombieList();
	for i=0,zombies:size() -1 do
		local zombie = zombies:get(i);
		local zRand = ZombRand(100)
		if zombie:isOnFire() and not zombie:isCrawling() and not zombie:getModData().zReDSZOFa and (zReDSZOFChance > zRand) then
			zombie:setWalkType("sprint1");
			zombie:getModData().zReDSZOFa = true;
		end
	end
end

local function zReDontSetZombiesOnFireDEFENCES()
	local zombies = getWorld():getCell():getZombieList();
	local VanillaFireDMG = 0.0038;
	local zReDSZOFMultiple = SandboxVars.zReDSZOF.FireDamageMultiple;
	local ModedFireDMG = VanillaFireDMG * zReDSZOFMultiple;
	
	for i=0,zombies:size() -1 do
		--zombies:get(i):setFireSpreadProbability(6); --Fire spread probability. default value: 6, 0 = Fire will never be spread by zombies.
		zombies:get(i):setFireKillRate(ModedFireDMG); --Fire kill rate. default value: 0.003800000064074993, 0 = Fire can never kill zombies, 0.0152 ~ 4 times more, 0.0019 ~ 2 times less.
	end
end

Events.EveryOneMinute.Add(zReDontSetZombiesOnFire)
Events.EveryTenMinutes.Add(zReDontSetZombiesOnFireDEFENCES)
Events.OnGameStart.Add(zReDontSetZombiesOnFireDEFENCES)