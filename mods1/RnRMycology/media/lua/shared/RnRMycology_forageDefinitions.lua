require 'Foraging/forageSystem'

-- print("RnR: in forageDefinitions");

function RnRShallowCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else
        copy = orig
    end
    return copy
end

Events.onAddForageDefs.Add(function()

	-- print("RnR: onAddForageDefs Event fired");

	-- template for a gourmet mushroom
	local gourmet = {
		maxCount = 5,
		minCount = 2,
		xp = 5,
		snowChance = 5,
		rainChance = 15,
		hasRainedChance = 50;
		categories = {"Mushrooms"},
		zones = {
			Forest      = 40,
			DeepForest  = 40,
			Vegitation  = 40,
			FarmLand    = 20,
			Farm        = 20,
			TrailerPark = 5,
			TownZone    = 5,
			Nav         = 5,
		},
		months = {2, 3, 4, 5, 6, 8, 9, 10, 11, 12 },
		bonusMonths = { 4, 10 },
		malusMonths = { 2, 8 },
		spawnFuncs = { doWildFoodSpawn, doRandomAgeSpawn },
	};

	-- template for a poison mushroom
	local poison = {
		maxCount = 2,
		minCount = 1,
		xp = 5,
		snowChance = 5,
		rainChance = 15,
		hasRainedChance = 50;
		categories = {"Mushrooms"},
		zones = {
			Forest      = 40,
			DeepForest  = 40,
			Vegitation  = 40,
			FarmLand    = 20,
			Farm        = 20,
			TrailerPark = 5,
			TownZone    = 5,
			Nav         = 5,
		},
		months = {2, 3, 4, 5, 6, 8, 9, 10, 11, 12 },
		bonusMonths = { 4, 10 },
		malusMonths = { 2, 8 },
		spawnFuncs = { doWildFoodSpawn, doRandomAgeSpawn },
	};

	-- template for a medicinal mushroom
	local medicinal = {
		maxCount = 3,
		minCount = 1,
		xp = 10,
		snowChance = 5,
		rainChance = 15,
		hasRainedChance = 50;
		categories = {"Mushrooms"},
		zones = {
			Forest      = 50,
			DeepForest  = 50,
			Vegitation  = 50,
			FarmLand    = 5,
			Farm        = 5,
			TrailerPark = 5,
			TownZone    = 5,
			Nav         = 5,
		},
		months = {2, 3, 4, 5, 6, 8, 9, 10, 11, 12 },
		bonusMonths = { 4, 10 },
		malusMonths = { 2, 8 },
		spawnFuncs = { doWildFoodSpawn, doRandomAgeSpawn },
	};

	-- template for an active mushroom
	local active = {
		maxCount = 3,
		minCount = 1,
		xp = 10,
		snowChance = 5,
		rainChance = 15,
		hasRainedChance = 50;
		categories = {"Mushrooms"},
		zones = {
			Forest      = 15,
			DeepForest  = 15,
			Vegitation  = 15,
			FarmLand    = 30,
			Farm        = 30,
			TrailerPark = 30,
			TownZone    = 15,
			Nav         = 5,
		},
		months = {2, 3, 4, 5, 6, 8, 9, 10, 11, 12 },
		bonusMonths = { 4, 10 },
		malusMonths = { 2, 8 },
		spawnFuncs = { doWildFoodSpawn, doRandomAgeSpawn },
	};

	-- update this list from the definitions in scripts
	local gourmetItems = {
		"RnR.MushroomOysterKingNoID",
		"RnR.MushroomOysterWhiteNoID",
		"RnR.MushroomOysterYellowNoID",
		"RnR.MushroomOysterBlueNoID",
		"RnR.MushroomWineCapNoID",
		"RnR.MushroomShiitakeNoID",
		"RnR.MushroomEnokiNoID",
		"RnR.MushroomPortobelloNoID",
		"RnR.MushroomMorelNoID",
		"RnR.MushroomNamekoNoID",
	};

	local poisonItems = {
		"RnR.MushroomDeathCapNoID",
		"RnR.MushroomFlyAgaricNoID",
		"RnR.MushroomDestroyingAngelNoID",
		"RnR.MushroomFalseParasolNoID",
	};

	local medicinalItems = {
		"RnR.MushroomReshiNoID",
		"RnR.MushroomLionsManeNoID",
		"RnR.MushroomTurkeyTailNoID",
		"RnR.MushroomChagaNoID",
		"RnR.MushroomMaitakeNoID",
		"RnR.MushroomCordycepsMilitarisNoID",
	};

	local activeItems = {
		"RnR.MushroomGoldenTeacherNoID",
		"RnR.MushroomAPENoID",
		"RnR.MushroomHawaiianPESHNoID",
		"RnR.MushroomWavyCapNoID",
	};

	-- iterate and add gourmets to the forage system
	for _, itemFullName in ipairs(gourmetItems) do
		-- shallow copy the gourmet template
		local gourmetCopy = RnRShallowCopy(gourmet);
		gourmetCopy.type = itemFullName;
		forageSystem.addItemDef(gourmetCopy);
	end;

	-- iterate and add poisons to the forage system
	for _, itemFullName in ipairs(poisonItems) do
		-- shallow copy the poison template
		local poisonCopy = RnRShallowCopy(poison);
		poisonCopy.type = itemFullName;
		forageSystem.addItemDef(poisonCopy);
	end;

	-- iterate and add medicinals to the forage system
	for _, itemFullName in ipairs(medicinalItems) do
		-- shallow copy the medicinal template
		local medicinalCopy = RnRShallowCopy(medicinal);
		medicinalCopy.type = itemFullName;
		forageSystem.addItemDef(medicinalCopy);
	end;

	-- iterate and add actives to the forage system
	for _, itemFullName in ipairs(activeItems) do
		-- shallow copy the active template
		local activeCopy = RnRShallowCopy(active);
		activeCopy.type = itemFullName;
		forageSystem.addItemDef(activeCopy);
	end;

	-- remove vanilla shrooms
	for i = 1, 7 do
		forageSystem.removeItemDef({type = "Base.MushroomGeneric" .. i})
	end

	forageSystem.generateLootTable();

	--[[
	-- for testing only
	print("RnR forageable item defs:");
	for key, value in pairs(forageSystem.itemDefs) do
		if string.sub(key, 1, 3) == "RnR" then
			print("Key:", key, " Type:", value.type);
		end
	end
	--]]

end)