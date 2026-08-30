restoreUtilities = restoreUtilities or {}

restoreUtilities.WaterDays = 0 -- initialising variables
restoreUtilities.ElecDays = 0
restoreUtilities.progressedDays = 0 

restoreUtilities.MinSkillLvl = 2 -- these are the defaults for all the values the mod needs, but some can be changed with sandbox settings
restoreUtilities.scrapNeededForRepair = 40
restoreUtilities.AllFuses = {"FuseInverter", "FuseRubberWires", "FuseCoil", "FuseSpareParts", "FuseMarkedComps", "FuseNotes"}
restoreUtilities.FailChance = 80
restoreUtilities.InjuryChance = 110 -- 110% means that repairing at lvl 2 or 3 without a fuse is a guaranteed injury
restoreUtilities.XPEarned = 250
restoreUtilities.SoundRange = 600 

local function setupModData(newGame) -- setup the mod data
	restoreUtilities.modData = ModData.getOrCreate("RestoreUtilities")
	if isClient() then
		ModData.request("RestoreUtilities")
	end
	restoreUtilities.modData.validity = restoreUtilities.modData.validity or {}
	restoreUtilities.modData.shutdownDates = restoreUtilities.modData.shutdownDates or {}
	restoreUtilities.modData.extraRepairCoords = restoreUtilities.modData.extraRepairCoords or {} -- additional coords added by server admins
	restoreUtilities.modData.shutdownDates["Elec"] = restoreUtilities.modData.shutdownDates["Elec"] or 0
	restoreUtilities.modData.shutdownDates["Water"] = restoreUtilities.modData.shutdownDates["Water"] or 0
	-- load sandbox option choices
	restoreUtilities.MinSkillLvl = SandboxVars.RestoreUtilities.MinSkillLvl or restoreUtilities.MinSkillLvl
	restoreUtilities.scrapNeededForRepair = SandboxVars.RestoreUtilities.ScrapNeeded or restoreUtilities.scrapNeededForRepair
	restoreUtilities.FailChance = SandboxVars.RestoreUtilities.FailChance or restoreUtilities.FailChance
	restoreUtilities.InjuryChance = SandboxVars.RestoreUtilities.InjuryChance or restoreUtilities.InjuryChance
	restoreUtilities.XPEarned = SandboxVars.RestoreUtilities.XPEarned or restoreUtilities.XPEarned
	restoreUtilities.ScalingRepairModifier = SandboxVars.RestoreUtilities.ScalingRepairModifier or 1
	restoreUtilities.calculateDays()
end

function restoreUtilities.calculateDays() -- hourly check so we know when the water/power is repairable again, also makes shutdown estimates more accurate
	restoreUtilities.progressedDays = math.floor((getGameTime():getWorldAgeHours()/24)+0.01)
	local elecShutdown = SandboxVars["ElecShutModifier"]
	local waterShutdown = SandboxVars["WaterShutModifier"]
	restoreUtilities.ElecDays = elecShutdown - restoreUtilities.progressedDays -- how many days until the elec shuts down, <= 0 means power is already out
	restoreUtilities.WaterDays = waterShutdown - restoreUtilities.progressedDays
	if restoreUtilities.ElecDays <= 5 then
		restoreUtilities.modData.validity["Elec"] = true
	else
		restoreUtilities.modData.validity["Elec"] = false
	end
	if restoreUtilities.WaterDays <= 5 then
		restoreUtilities.modData.validity["Water"] = true
	else
		restoreUtilities.modData.validity["Water"] = false
	end
	if isServer() then
		ModData.transmit("RestoreUtilities")
	end
end

function restoreUtilities.addDays(utilityToEnable, daysToAdd, dualRepair, dualRepairTier, soundRange, player) -- adds extra days to the utility shutoff sandbox options - "turns back on" the power/water
	restoreUtilities.progressedDays = math.floor((getGameTime():getWorldAgeHours()/24)+0.01) -- the number of days since the start of the world
	local oldDays = daysToAdd
	daysToAdd = math.floor((daysToAdd * restoreUtilities.ScalingRepairModifier) + 0.5)
	local newDays = daysToAdd
	local altUtilityRepairDays = 0
	if dualRepair then -- dual repair handles if player is using an inverter fuse to repair both utilities at once
		altUtilityRepairDays = math.ceil(daysToAdd * dualRepairTier) -- dual repair tier is either 0.5 or 0.25, depending on fuse tier
		if dualRepairTier == 0.25 then
			daysToAdd = math.ceil(daysToAdd * 0.5) -- the tier 1 inverter fuse reduces repair effectiveness by 50%
		end
	end
	local altUtilityType = nil
	if utilityToEnable == "Elec" then -- adds extra days if there is still a day or 2 before shutdown and we repair early
		if restoreUtilities.ElecDays > 0 then
			daysToAdd = daysToAdd + restoreUtilities.ElecDays
		end
		if dualRepair and restoreUtilities.WaterDays > 0 then
			altUtilityRepairDays = altUtilityRepairDays + restoreUtilities.WaterDays
		end
	elseif utilityToEnable == "Water" then
		if restoreUtilities.WaterDays > 0 then
			daysToAdd = daysToAdd + restoreUtilities.WaterDays
		end
		if dualRepair and restoreUtilities.ElecDays > 0 then
			altUtilityRepairDays = altUtilityRepairDays + restoreUtilities.ElecDays
		end
	end
	local newUtilityShutoffDate = restoreUtilities.progressedDays + daysToAdd
	restoreUtilities.modData.shutdownDates[utilityToEnable] = newUtilityShutoffDate -- modData.shutdownDates["Elec"]/modData.shutdownDates["Water"] = new shutoff day
	SandboxVars[utilityToEnable .. "ShutModifier"] = newUtilityShutoffDate
	getSandboxOptions():set(utilityToEnable .. "ShutModifier", newUtilityShutoffDate)
	if dualRepair then
		if utilityToEnable == "Elec" then -- if using an inverter fuse, get the opposite utility's name
			altUtilityType = "Water"
		elseif utilityToEnable == "Water" then
			altUtilityType = "Elec"
		end
		local altUtilityShutoffDate = restoreUtilities.progressedDays + altUtilityRepairDays -- apply repairs to opposite utility
		restoreUtilities.modData.shutdownDates[altUtilityType] = altUtilityShutoffDate
		SandboxVars[altUtilityType .. "ShutModifier"] = altUtilityShutoffDate
		getSandboxOptions():set(altUtilityType .. "ShutModifier", altUtilityShutoffDate)
	end
	if isServer() then -- sync sandbox settings in MP
		local newPowerShutoff = SandboxVars["ElecShutModifier"]
		local newWaterShutoff = SandboxVars["WaterShutModifier"]
		local clientUpdateTable = {newPowerShutoff, newWaterShutoff}
		sendServerCommand("RestoreUtilities", "UpdateSandbox", clientUpdateTable)
		ModData.transmit("RestoreUtilities")
	end
	if ModData.exists("RandomShutoff") then -- if using my other mod RandomShutoff, update its mod data so there are no accidental rollbacks
		local RS = ModData.get("RandomShutoff")
		RS.PowerDate = restoreUtilities.modData.shutdownDates["Elec"]
		RS.WaterDate = restoreUtilities.modData.shutdownDates["Water"]
	end
	if soundRange > 0 then
		if player then
			local globalSound = getWorldSoundManager()
			globalSound:addSound(player, player:getX(), player:getY(), player:getZ(), soundRange, 100)
		end
	end
	restoreUtilities.calculateDays()
end

local function validateClient(modID, commandID, player, info) -- makes sure the client sending the repair complete action is a valid character to do so
	if not isServer() then return end
	if modID ~= "RestoreUtilities" then return end
	if commandID ~= "RepairComplete" then return end
	local plrElecLvl = player:getPerkLevel(Perks.Electricity)
	if info[1] == "Elec" then 
		if not restoreUtilities.modData.validity["Elec"] then return end 
	elseif info[1] == "Water" then
		if not restoreUtilities.modData.validity["Water"] then return end
	else return
	end
	local utility = info[1]
	local daysToAdd = info[2]
	local inverterFuseActive = info[3]
	local inverterFuseTier = info[4]
	local soundRange = info[5]
	local electrician = info[6]
	if daysToAdd > math.ceil((((plrElecLvl + 2) * 7) + 3) * 1.5) then -- soft anti-cheat measure, days to add should NEVER be higher than this anyway as it accounts for absolute best-case scenario
		daysToAdd = plrElecLvl * 7 -- but for some reason if it is (perhaps because a naughty naughty is cheating), set it to a reasonable level
	end
	restoreUtilities.addDays(utility, daysToAdd, inverterFuseActive, inverterFuseTier, soundRange, electrician)
end

local function refreshClients(modID, commandID, info) -- makes the client update its own sandbox options, the server will not send the new options to clients until they rejoin, and having to relog every time you fix the power or water seemed annoying.
-- this is kinda hacky and may cause other desync issues, but hopefully it won't
	if not isClient() then return end
	if modID ~= "RestoreUtilities" then return end
	if commandID ~= "UpdateSandbox" then return end
	if info == nil then return end
	if not info[1] or not info[2] then return end
	SandboxVars["ElecShutModifier"] = info[1] -- lua side power shutoff
	getSandboxOptions():set("ElecShutModifier", info[1]) -- java side power shutoff
	SandboxVars["WaterShutModifier"] = info[2] -- lua side water shutoff
	getSandboxOptions():set("WaterShutModifier", info[2]) -- java side water shutoff :)))
end

local function serverStartup() -- apply the proper shutdown dates when starting up the server, as the server doesn't save sandbox changes
	if not isServer() then return end
	local applyPower = false
	local applyWater = false
	if restoreUtilities.modData.shutdownDates["Elec"] > 0 then
		applyPower = true
	end
	if restoreUtilities.modData.shutdownDates["Water"] > 0 then
		applyWater = true
	end
	if applyPower or applyWater then
		if applyPower then
			SandboxVars["ElecShutModifier"] = restoreUtilities.modData.shutdownDates["Elec"]
			getSandboxOptions():set("ElecShutModifier", restoreUtilities.modData.shutdownDates["Elec"])
		end
		if applyWater then
			SandboxVars["WaterShutModifier"] = restoreUtilities.modData.shutdownDates["Water"]
			getSandboxOptions():set("WaterShutModifier", restoreUtilities.modData.shutdownDates["Water"])
		end
	end
	restoreUtilities.calculateDays()
end	

Events.OnInitGlobalModData.Add(setupModData)
Events.EveryHours.Add(restoreUtilities.calculateDays)
Events.OnClientCommand.Add(validateClient)
Events.OnServerStarted.Add(serverStartup)
Events.OnServerCommand.Add(refreshClients)