local AScrap = "RestoreUtilities.AdvancedScrap" -- short versions of all available items to save me some time :)
local FuseInvT1 = "RestoreUtilities.FuseInverterT1"
local FuseInvT2 = "RestoreUtilities.FuseInverterT2"
local FuseWireT1 = "RestoreUtilities.FuseRubberWiresT1"
local FuseWireT2 = "RestoreUtilities.FuseRubberWiresT2"
local FuseCoilT1 = "RestoreUtilities.FuseCoilT1"
local FuseCoilT2 = "RestoreUtilities.FuseCoilT2"
local FusePartsT1 = "RestoreUtilities.FuseSparePartsT1"
local FusePartsT2 = "RestoreUtilities.FuseSparePartsT2"
local FuseCompsT1 = "RestoreUtilities.FuseMarkedCompsT1"
local FuseCompsT2 = "RestoreUtilities.FuseMarkedCompsT2"
local FuseNotesT1 = "RestoreUtilities.FuseNotesT1"
local FuseNotesT2 = "RestoreUtilities.FuseNotesT2"
local T1Fuses = {FuseInvT1, FuseWireT1, FuseCoilT1, FusePartsT1, FuseCompsT1, FuseNotesT1}
local T2Fuses = {FuseInvT2, FuseWireT2, FuseCoilT2, FusePartsT2, FuseCompsT2, FuseNotesT2}
local sandboxModValues = {0, 0.25, 0.5, 1, 1.5, 2}

local function addLootToProcTables(lootTable, itemName, itemChance, junk)

	local lootPool = ProceduralDistributions.list[lootTable]
	if not lootPool then
		print(lootTable .. " does not exist!")
		return
	end
	
	if junk then
		table.insert(lootPool.junk, itemName)
		table.insert(lootPool.junk, itemChance)
	else
		table.insert(lootPool.items, itemName)
		table.insert(lootPool.items, itemChance)
	end
	
end

local function addLootToSubTables(lootTable, itemName, itemChance)

	local lootPool = SuburbsDistributions["all"][lootTable]
	if not lootPool then
		print(lootTable .. " does not exist!")
		return
	end
	
	if junk then
		table.insert(lootPool.junk, itemName)
		table.insert(lootPool.junk, itemChance)
	else
		table.insert(lootPool.items, itemName)
		table.insert(lootPool.items, itemChance)
	end
	
end

local function addLootToVehicleTables(lootTable, itemName, itemChance)

	local lootPool = VehicleDistributions[lootTable]
	if not lootPool then
		print(lootTable .. " does not exist!")
		return
	end
	
	if junk then
		table.insert(lootPool.junk, itemName)
		table.insert(lootPool.junk, itemChance)
	else
		table.insert(lootPool.items, itemName)
		table.insert(lootPool.items, itemChance)
	end
	
end

local function initLootSpawns()

	if isClient() then return end -- only singleplayer or a server should be running this code!

	local scrapSpawnRate = SandboxVars.RestoreUtilities.ScrapSpawnRateChest
	local T1SpawnRate = SandboxVars.RestoreUtilities.T1SpawnRateChest
	local T2SpawnRate = SandboxVars.RestoreUtilities.T2SpawnRateChest

-- ADVANCED SCRAP --

	local sandboxModifier = sandboxModValues[scrapSpawnRate]
	
	if sandboxModifier > 0 then -- for some reason, items will spawn even at 0%. so if sandbox settings are set to not spawn something, we just won't even add it to the spawn tables instead
		addLootToSubTables("bin", AScrap, 0.25 * sandboxModifier)
		addLootToSubTables("metal_shelves", AScrap, 0.75 * sandboxModifier)

		addLootToProcTables("BinGeneric", AScrap, 0.4 * sandboxModifier)
		addLootToProcTables("CrateComputer", AScrap, 1 * sandboxModifier)
		addLootToProcTables("CrateElectronics", AScrap, 5 * sandboxModifier)
		addLootToProcTables("CrateMechanics", AScrap, 0.25 * sandboxModifier)
		addLootToProcTables("CrateMetalwork", AScrap, 0.25 * sandboxModifier)
		addLootToProcTables("CrateRandomJunk", AScrap, 0.5 * sandboxModifier)
		addLootToProcTables("EngineerTools", AScrap, 2 * sandboxModifier)
		addLootToProcTables("GeneratorRoom", AScrap, 0.5 * sandboxModifier)
		addLootToProcTables("MechanicShelfElectric", AScrap, 2 * sandboxModifier)
		addLootToProcTables("MechanicSpecial", AScrap, 0.5 * sandboxModifier)
		addLootToProcTables("ScienceMisc", AScrap, 0.5 * sandboxModifier)
		addLootToProcTables("ClosetShelfGeneric", AScrap, 0.1 * sandboxModifier)
		addLootToProcTables("GarageMechanics", AScrap, 1 * sandboxModifier)
		addLootToProcTables("GarageMetalwork", AScrap, 1 * sandboxModifier)
		addLootToProcTables("LivingRoomSideTableNoRemote", AScrap, 0.05 * sandboxModifier)

		addLootToVehicleTables("ElectricianGloveBox", AScrap, 10 * sandboxModifier)
		addLootToVehicleTables("ElectricianTruckBed", AScrap, 5 * sandboxModifier)
		addLootToVehicleTables("ConstructionWorkerGloveBox", AScrap, 1 * sandboxModifier)
		addLootToVehicleTables("ConstructionWorkerTruckBed", AScrap, 0.5 * sandboxModifier)
		addLootToVehicleTables("Glovebox", AScrap, 0.03 * sandboxModifier)
		addLootToVehicleTables("TrunkStandard", AScrap, 0.02 * sandboxModifier)
		addLootToVehicleTables("TrunkHeavy", AScrap, 0.02 * sandboxModifier)
		addLootToVehicleTables("SurvivalistGlovebox", AScrap, 3 * sandboxModifier)
		addLootToVehicleTables("SurvivalistTrunk", AScrap, 1.5 * sandboxModifier)
	end

-- TIER 1 FUSES --

	local sandboxModifier = sandboxModValues[T1SpawnRate]
	
	if sandboxModifier > 0 then
		for i, v in ipairs(T1Fuses) do -- for now T1 fuses spawn in the same places as advanced scrap just 10x more rare
			addLootToSubTables("metal_shelves", v, 0.075 * sandboxModifier)

			addLootToProcTables("BinGeneric", v, 0.04 * sandboxModifier)
			addLootToProcTables("CrateComputer", v, 0.1 * sandboxModifier)
			addLootToProcTables("CrateElectronics", v, 0.5 * sandboxModifier)
			addLootToProcTables("CrateMechanics", v, 0.025 * sandboxModifier)
			addLootToProcTables("CrateMetalwork", v, 0.025 * sandboxModifier)
			addLootToProcTables("CrateRandomJunk", v, 0.05 * sandboxModifier)
			addLootToProcTables("EngineerTools", v, 0.2 * sandboxModifier)
			addLootToProcTables("GeneratorRoom", v, 0.05 * sandboxModifier)
			addLootToProcTables("MechanicShelfElectric", v, 0.2 * sandboxModifier)
			addLootToProcTables("MechanicSpecial", v, 0.05 * sandboxModifier)
			addLootToProcTables("ScienceMisc", v, 0.05 * sandboxModifier)
			addLootToProcTables("ClosetShelfGeneric", v, 0.01 * sandboxModifier)
			addLootToProcTables("GarageMechanics", v, 0.1 * sandboxModifier)
			addLootToProcTables("GarageMetalwork", v, 0.1 * sandboxModifier)
			addLootToProcTables("LivingRoomSideTableNoRemote", v, 0.005 * sandboxModifier)
			addLootToProcTables("LivingRoomSideTable", v, 0.005 * sandboxModifier)

			addLootToVehicleTables("ElectricianGloveBox", v, 1 * sandboxModifier)
			addLootToVehicleTables("ElectricianTruckBed", v, 0.5 * sandboxModifier)
			addLootToVehicleTables("ConstructionWorkerGloveBox", v, 0.1 * sandboxModifier)
			addLootToVehicleTables("ConstructionWorkerTruckBed", v, 0.05 * sandboxModifier)
			addLootToVehicleTables("SurvivalistGlovebox", v, 0.3 * sandboxModifier)
			addLootToVehicleTables("SurvivalistTrunk", v, 0.15 * sandboxModifier)
		end
	end

-- TIER 2 FUSES --

	local sandboxModifier = sandboxModValues[T2SpawnRate]

	if sandboxModifier > 0 then
		for i, v in ipairs(T2Fuses) do -- T2 fuses spawn in some of the same places as T1, just half as likely
			addLootToSubTables("metal_shelves", v, 0.034 * sandboxModifier)

			addLootToProcTables("CrateComputer", v, 0.05 * sandboxModifier)
			addLootToProcTables("CrateElectronics", v, 0.25 * sandboxModifier)
			addLootToProcTables("CrateMechanics", v, 0.012 * sandboxModifier)
			addLootToProcTables("CrateMetalwork", v, 0.012 * sandboxModifier)
			addLootToProcTables("CrateRandomJunk", v, 0.025 * sandboxModifier)
			addLootToProcTables("EngineerTools", v, 0.1 * sandboxModifier)
			addLootToProcTables("GeneratorRoom", v, 0.025 * sandboxModifier)
			addLootToProcTables("MechanicShelfElectric", v, 0.1 * sandboxModifier)
			addLootToProcTables("MechanicSpecial", v, 0.025 * sandboxModifier)
			addLootToProcTables("ScienceMisc", v, 0.025 * sandboxModifier)
			addLootToProcTables("ClosetShelfGeneric", v, 0.005 * sandboxModifier)
			addLootToProcTables("GarageMechanics", v, 0.05 * sandboxModifier)
			addLootToProcTables("GarageMetalwork", v, 0.05 * sandboxModifier)

			addLootToVehicleTables("ElectricianGloveBox", v, 0.5 * sandboxModifier)
			addLootToVehicleTables("ElectricianTruckBed", v, 0.25 * sandboxModifier)
			addLootToVehicleTables("ConstructionWorkerGloveBox", v, 0.05 * sandboxModifier)
			addLootToVehicleTables("ConstructionWorkerTruckBed", v, 0.025 * sandboxModifier)
			addLootToVehicleTables("SurvivalistGlovebox", v, 0.15 * sandboxModifier)
			addLootToVehicleTables("SurvivalistTrunk", v, 0.08 * sandboxModifier)
		end
	end

end

Events.OnPreDistributionMerge.Add(initLootSpawns) -- add items to the loot tables BEFORE theyre all merged