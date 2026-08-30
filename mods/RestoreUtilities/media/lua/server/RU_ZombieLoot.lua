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
local scrapSpawnRate = SandboxVars.RestoreUtilities.ScrapSpawnRateZombie
local T1SpawnRate = SandboxVars.RestoreUtilities.T1SpawnRateZombie
local T2SpawnRate = SandboxVars.RestoreUtilities.T2SpawnRateZombie

local function rollForZombieLoot(zombie)
	
	local advScrapDropChance = 500 -- 500/100,000 = 5/1,000 = 0.5% which is roughly 1 adv scrap every 200 zombies killed
	local T1DropChance = 100 -- 0.1% drop chance, 1 in 1000
	local T2DropChance = 10 -- 0.01% drop chance, 1 in 10,000, we roll out of 100,000 so the sandbox settings can lower this value if needed :)
	local zombiePockets = zombie:getInventory()
	
	advScrapDropChance = math.ceil(advScrapDropChance * sandboxModValues[scrapSpawnRate])
	T1DropChance = math.ceil(T1DropChance * sandboxModValues[T1SpawnRate])
	T2DropChance = math.ceil(T2DropChance * sandboxModValues[T2SpawnRate])
	
	local scrapRoll = ZombRand(100000)
	local fuseRoll = ZombRand(100000)
	
	if advScrapDropChance >= scrapRoll then -- roll for advanced scrap
		zombiePockets:AddItem(AScrap)
	end	
	
	if T2DropChance >= fuseRoll then -- roll for T2 fuses
		local randomFuse = T2Fuses[ZombRand(1, #T2Fuses)]
		zombiePockets:AddItem(randomFuse)
	elseif T2DropChance + T1DropChance >= fuseRoll then -- if no T2 fuse, try to drop a T1 fuse instead (but never both a T1 AND T2 on the same zombie)
		local randomFuse = T1Fuses[ZombRand(1, #T1Fuses)]
		zombiePockets:AddItem(randomFuse)
	end
	
end

local function updateSandboxValues()
	scrapSpawnRate = SandboxVars.RestoreUtilities.ScrapSpawnRateZombie
	T1SpawnRate = SandboxVars.RestoreUtilities.T1SpawnRateZombie
	T2SpawnRate = SandboxVars.RestoreUtilities.T2SpawnRateZombie
end

Events.OnZombieDead.Add(rollForZombieLoot)
Events.OnGameStart.Add(updateSandboxValues)