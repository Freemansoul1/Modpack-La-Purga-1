restoreUtilities = restoreUtilities or {}

function restoreUtilities.AddContextPrompt(player, context, worldObjects)
	
	local player = getSpecificPlayer(player)
	local utilityInFocus
	if isClient() then
		ModData.request("RestoreUtilities")
	end
	local modData = ModData.get("RestoreUtilities")
	local extraCoordsTable = modData.extraRepairCoords
	
	if #extraCoordsTable > 0 then -- if additional repair coords have been added by admins, check if we're clicking on that specific tile
		local x, y, z = worldObjects[1]:getX(), worldObjects[1]:getY(), worldObjects[1]:getZ() -- coords of where the player right-clicked
		for i, v in ipairs(extraCoordsTable) do
			if v.X == x and v.Y == y and v.Z == z then
				utilityInFocus = v.utilityType
				break
			end
		end
	end
	
	if utilityInFocus == nil then
		if player:getCurrentRoomDef() == nil then return end
		if player:getCurrentRoomDef():getName() == "RU_Water" then
			utilityInFocus = "Water"
		elseif player:getCurrentRoomDef():getName() == "RU_Elec" then
			utilityInFocus = "Elec"
		else
			return
		end
	end

	restoreUtilities.calculateDays()
	local blackoutModPowerOutage = powerDisabledByBlackouts or false -- if using the blackouts mod, this variable tells us if a blackout is in progress. we don't want repairs to be possible during that time to prevent things glitching
	local utilityDays = 0
	if blackoutModPowerOutage then
		if modData.shutdownDates[utilityInFocus] > 0 then
			utilityDays = modData.shutdownDates[utilityInFocus] - restoreUtilities.progressedDays -- blackouts change the ElecShutoffModifier to -1 until they end, so we grab what this mod thinks the days remaining of this utility *should* be, based on mod data
		elseif utilityInFocus == "Elec" then -- if blackouts active AND we haven't done any repairs yet, rely on blackout's priorElecShutModifier to find out what the first power outage is supposed to be
			ModData.request("tmrblackouts")
			local defaultElecShutoffDate = 0
			if ModData.exists("tmrblackouts") then
				local blackoutModData = ModData.get("tmrblackouts")
				defaultElecShutoffDate = blackoutModData.priorElecShutModifier
			end
			utilityDays = defaultElecShutoffDate - restoreUtilities.progressedDays
		elseif utilityInFocus == "Water" then -- if the utility is instead water and it hasn't been repaired yet, we can fall back on the default logic
			utilityDays = restoreUtilities[utilityInFocus .. "Days"]
		end
	else
		utilityDays = restoreUtilities[utilityInFocus .. "Days"]
	end
	
	local repairContext = context:addOptionOnTop(getText("ContextMenu_RU_" .. utilityInFocus .. "_ContextName"), nil, nil)
	local subMenu = ISContextMenu:getNew(context)
	context:addSubMenu(repairContext, subMenu) -- adds initial right-click menu
	local elecSkillLvl = player:getPerkLevel(Perks.Electricity)
	local minLvl = restoreUtilities.MinSkillLvl -- making this variable because im lazy and its easier to type out minLvl :)
	
	
	local utilityInfo = subMenu:addOptionOnTop(getText("ContextMenu_RU_UtilityInfo"), nil, nil)
	local repairButton = subMenu:addOption(getText("ContextMenu_RU_UtilityRepair"), player, startRepairs, utilityInFocus) -- adds submenus to check status & repair
	
	local infoTooltip = ISWorldObjectContextMenu.addToolTip() -- creates a new tooltip for the info button
	local repairButtonTooltip = ISWorldObjectContextMenu.addToolTip()
	
	if blackoutModPowerOutage then
		infoTooltip.description = getText("ContextMenu_RU_BlackoutInProgressInfo") .. infoTooltip.description
		repairButtonTooltip.description = getText("ContextMenu_RU_BlackoutInProgressRepairs") .. repairButtonTooltip.description
	end
	
	-- SETUP INFO TOOLTIP --
	
	infoTooltip.description = infoTooltip.description .. getText("ContextMenu_RU_" .. utilityInFocus .. "_InfoTextOne")
	
	if elecSkillLvl < minLvl then -- level 0-1 (by default) electric skills do not see any information about the utility
	
		infoTooltip.description = infoTooltip.description .. getText("ContextMenu_RU_SkillTooLow")
	
	elseif elecSkillLvl <= 3 then -- level 2-3 electric skill get a warning if the power will go out some time within the next month
	
			if utilityDays >= 30 then
				infoTooltip.description = infoTooltip.description .. getText("ContextMenu_RU_UtilityStatusGood")
			elseif utilityDays < 30 and utilityDays > 0 then
				infoTooltip.description = infoTooltip.description .. getText("ContextMenu_RU_UtilityStatusOkay")
			else
				infoTooltip.description = infoTooltip.description .. getText("ContextMenu_RU_UtilityStatusOff")
			end
	
	elseif elecSkillLvl <= 5 then -- level 4-5 electric skill also get to see a 2 week warning before the utility breaks
	
			if utilityDays >= 30 then
				infoTooltip.description = infoTooltip.description .. getText("ContextMenu_RU_UtilityStatusGood")
			elseif utilityDays < 30 and utilityDays >= 14 then
				infoTooltip.description = infoTooltip.description .. getText("ContextMenu_RU_UtilityStatusOkay")
			elseif utilityDays < 14 and utilityDays > 0 then
				infoTooltip.description = infoTooltip.description .. getText("ContextMenu_RU_UtilityStatusWeak")
			else
				infoTooltip.description = infoTooltip.description .. getText("ContextMenu_RU_UtilityStatusOff")
			end
	
	elseif elecSkillLvl <= 10 then -- level 6-7 electric skill also get a critical warning when the utility is about to break (can be repaired during this time) - I check for <= 10 here instead of <= 7 so I don't need to copy/paste the below code even further down!
	
			if utilityDays >= 30 then
				infoTooltip.description = infoTooltip.description .. getText("ContextMenu_RU_UtilityStatusGood")
			elseif utilityDays < 30 and utilityDays >= 14 then
				infoTooltip.description = infoTooltip.description .. getText("ContextMenu_RU_UtilityStatusOkay")
			elseif utilityDays < 14 and utilityDays >= 5 then
				infoTooltip.description = infoTooltip.description .. getText("ContextMenu_RU_UtilityStatusWeak")
			elseif utilityDays < 5 and utilityDays > 0 then
				infoTooltip.description = infoTooltip.description .. getText("ContextMenu_RU_UtilityStatusBad")
			else
				infoTooltip.description = infoTooltip.description .. getText("ContextMenu_RU_UtilityStatusOff")
			end
	
		if elecSkillLvl <= 9 and elecSkillLvl > 7 then -- level 8-9 electric skill also see how many weeks until the utility shuts down
		
			if utilityDays > 0 then
				infoTooltip.description =  infoTooltip.description .. " <LINE> <LINE> <RGB:1,1,1>" -- week counter should be on a new line for neatness
			end
			if utilityDays > 0 then
				local weeksLeft =  math.floor(utilityDays / 7) -- find out how many weeks (rounded down) are left until shutdown
				if weeksLeft == 1 then -- when shutdown is 1 week away
					infoTooltip.description = infoTooltip.description .. getText("ContextMenu_RU_UtilityWeeksRemainingSingleWeekLeft", weeksLeft)
				elseif weeksLeft > 1 then -- when more than one week to shutdown
					infoTooltip.description = infoTooltip.description .. getText("ContextMenu_RU_UtilityWeeksRemainingMultiWeeksLeft", weeksLeft)
				elseif weeksLeft <= 0 then -- display generic message if there are less than 7 days until the utility breaks down
					infoTooltip.description = infoTooltip.description .. getText("ContextMenu_RU_UtilityShutdownThisWeek") 
				end
			end
			
		elseif elecSkillLvl == 10 then -- level 10 electric skills shows an exact day count until utility shutdown
			
			if utilityDays > 0 then
				infoTooltip.description = infoTooltip.description .. " <LINE> <LINE> <RGB:1,1,1>" -- day counter should also be on a new line for neatness
			end
			if utilityDays > 0 then
				if utilityDays <= 1 then
					infoTooltip.description = infoTooltip.description .. getText("ContextMenu_RU_UtilityOneDayLeft") -- generic message used when the shutdown is supposed to be within 24 hours
				elseif utilityDays >= 1 then
					infoTooltip.description = infoTooltip.description .. getText("ContextMenu_RU_UtilityDaysRemainingOne", utilityDays)
				end
			end
		end
	
	else
	
		infoTooltip.description = "Your electrical level is over 10, I don't know how this happened! If you know how this happened then please let me know so I can fix it :)" -- this should never be seen in an actual game, unless there are mods that increase skill level cap!
	
	end
	
	 -- SETUP REPAIR TOOLTIP --
	
	local availableFuses = {}
	local character = getPlayer()
	for i, v in ipairs(restoreUtilities.AllFuses) do -- find which fuses from the available list the player has in their inventory
		if character:getInventory():getItemCount("RestoreUtilities." .. v .. "T2", true) > 0 then -- we only use 1 fuse of either tier per repair operation, tier 2 fuses are given priority
			availableFuses[#availableFuses + 1] = v .. "T2"
		elseif character:getInventory():getItemCount("RestoreUtilities." .. v .. "T1", true) > 0 then -- if we don't have any tier 2 fuses of the variety we're searching for, look for any tier 1 fuses
			availableFuses[#availableFuses + 1] = v .. "T1"
		end
	end
	
	local function searchFuses(fusesInInv, fuseToFind) -- searches the player's inventory to find a specific fuse
	local foundFuse = false
	for i, v in ipairs(fusesInInv) do
		if v == fuseToFind then
			foundFuse = true
			break
		end
	end
	return foundFuse
	end
	
	local effectiveElecLvl = 0 -- 0 means we aren't using either tier of marked components
	local effectiveModifier = 0
	if searchFuses(availableFuses, "FuseMarkedCompsT2") then
		effectiveElecLvl = elecSkillLvl + 2 -- our "effective" electrical skill level is higher than our actual level, because of the fuse
		effectiveModifier = 2
	elseif searchFuses(availableFuses, "FuseMarkedCompsT1") then
		effectiveElecLvl = elecSkillLvl + 1
		effectiveModifier = 1
	end
	
	if utilityDays > 5 then
		repairButtonTooltip.description = repairButtonTooltip.description .. getText("ContextMenu_RU_UnableToRepairTime") -- system already repaired
	end
	local scrapNeeded = restoreUtilities.scrapNeededForRepair
	if searchFuses(availableFuses, "FuseSparePartsT2") then -- repairs are discounted when using the spare parts
		scrapNeeded = math.floor(scrapNeeded * 0.5) -- sandbox options might result in this number having decimals, so round them out
	elseif searchFuses(availableFuses, "FuseSparePartsT1") then
		scrapNeeded = math.floor(scrapNeeded * 0.75)
	end
	local scrapOnHand = character:getInventory():getItemCount("Base.ElectronicsScrap", true)
	local genKnowledgeRequired = true
	if searchFuses(availableFuses, "FuseRubberWiresT2") or searchFuses(availableFuses, "FuseRubberWiresT1") then
		genKnowledgeRequired = false
	end

	if effectiveElecLvl > 0 then -- this is another way of checking if we're using the marked components fuse (either tier)
		if effectiveElecLvl >= minLvl then -- shows required electrical level, add marked comp fuse skill bonus info
			repairButtonTooltip.description = repairButtonTooltip.description .. " <RGB:0,1,0> " .. getText("ContextMenu_RU_ElecSkillRequiredWithOffset", elecSkillLvl, minLvl, effectiveModifier)
		else
			repairButtonTooltip.description = repairButtonTooltip.description .. " <RGB:1,0,0> " .. getText("ContextMenu_RU_ElecSkillRequiredWithOffset", elecSkillLvl, minLvl, effectiveModifier)
		end
	else
		if elecSkillLvl >= minLvl then -- shows required electrical level
			repairButtonTooltip.description = repairButtonTooltip.description .. " <RGB:0,1,0> " .. getText("ContextMenu_RU_ElecSkillRequired", elecSkillLvl, minLvl)
		else
			repairButtonTooltip.description = repairButtonTooltip.description .. " <RGB:1,0,0> " .. getText("ContextMenu_RU_ElecSkillRequired", elecSkillLvl, minLvl)
		end
	end
	
	if scrapOnHand >= scrapNeeded then -- shows required electrical scrap
		repairButtonTooltip.description = repairButtonTooltip.description .. " <RGB:0,1,0> " .. getText("ContextMenu_RU_ScrapRequired", scrapOnHand, scrapNeeded)
	else
		repairButtonTooltip.description = repairButtonTooltip.description .. " <RGB:1,0,0> " .. getText("ContextMenu_RU_ScrapRequired", scrapOnHand, scrapNeeded)
	end
	
	if genKnowledgeRequired then
		if not character:isRecipeKnown("Generator") then
			repairButtonTooltip.description = repairButtonTooltip.description .. getText("ContextMenu_RU_GenKnowledgeNeeded")
		else
			repairButtonTooltip.description = repairButtonTooltip.description .. getText("ContextMenu_RU_HaveGenKnowledge")
		end
	else
		repairButtonTooltip.description = repairButtonTooltip.description .. getText("ContextMenu_RU_GenKnowledgeBypassed")
	end
		
	local failRisk = restoreUtilities.FailChance
	if searchFuses(availableFuses, "FuseMarkedCompsT2") then -- if using the marked components, increase effective electrical level and reduce chance of failure
		elecSkillLvl = elecSkillLvl + 2
		failRisk = 0
	elseif searchFuses(availableFuses, "FuseMarkedCompsT1") then
		elecSkillLvl = elecSkillLvl + 1
		failRisk = failRisk - ((elecSkillLvl - minLvl) * 8)
		failRisk = failRisk / 2
	else -- set fail chance when not using a marked components fuse
		failRisk = failRisk - ((elecSkillLvl - minLvl) * 8) 
	end
	
	if failRisk <= 0 then -- add fail risk info to tooltip
		repairButtonTooltip.description = repairButtonTooltip.description .. getText("ContextMenu_RU_FailChanceNone")
	else
		if elecSkillLvl < 7 then
			if failRisk >= 65 then
				repairButtonTooltip.description = repairButtonTooltip.description .. getText("ContextMenu_RU_FailChanceHigh")
			elseif failRisk >= 30 then
				repairButtonTooltip.description = repairButtonTooltip.description .. getText("ContextMenu_RU_FailChanceMid")
			else
				repairButtonTooltip.description = repairButtonTooltip.description .. getText("ContextMenu_RU_FailChanceLow")
			end
		else
			local successChance = 100 - failRisk
			if failRisk >= 65 then
				repairButtonTooltip.description = repairButtonTooltip.description .. " <RGB:1,0.25,0> " .. getText("ContextMenu_RU_FailChanceAccurate", successChance)
			elseif failRisk >= 30 then
				repairButtonTooltip.description = repairButtonTooltip.description .. " <RGB:1,1,0> " .. getText("ContextMenu_RU_FailChanceAccurate", successChance)
			else
				repairButtonTooltip.description = repairButtonTooltip.description .. " <RGB:0.5,1,0> " .. getText("ContextMenu_RU_FailChanceAccurate", successChance)
			end
		end
	end
	
	local injuryRisk = restoreUtilities.InjuryChance
	injuryRisk = injuryRisk - ((elecSkillLvl - minLvl) * 10)
	if searchFuses(availableFuses, "FuseRubberWiresT2") then -- reduce injury chance with rubber wires
		injuryRisk = 0
	elseif searchFuses(availableFuses, "FuseRubberWiresT1") then
		injuryRisk = injuryRisk / 2
	end
	
	if injuryRisk <= 0 then -- add injury risk info to tooltip
		repairButtonTooltip.description = repairButtonTooltip.description .. getText("ContextMenu_RU_InjuryChanceNone")
	else
		if elecSkillLvl < 7 then -- if elec skill is smaller than 7, show vague information
			if injuryRisk >= 80 then
				repairButtonTooltip.description = repairButtonTooltip.description .. getText("ContextMenu_RU_InjuryChanceHigh")
			elseif injuryRisk >= 50 then
				repairButtonTooltip.description = repairButtonTooltip.description .. getText("ContextMenu_RU_InjuryChanceMid")
			else
				repairButtonTooltip.description = repairButtonTooltip.description .. getText("ContextMenu_RU_InjuryChanceLow")
			end
		else -- at elec lvl 7+ show exact %
			if injuryRisk >= 80 then
				repairButtonTooltip.description = repairButtonTooltip.description .. " <RGB:1,0.25,0> " .. getText("ContextMenu_RU_InjuryChanceAccurate", injuryRisk)
			elseif injuryRisk >= 50 then
				repairButtonTooltip.description = repairButtonTooltip.description .. " <RGB:1,1,0> " .. getText("ContextMenu_RU_InjuryChanceAccurate", injuryRisk)
			else
				repairButtonTooltip.description = repairButtonTooltip.description .. " <RGB:0.5,1,0> " .. getText("ContextMenu_RU_InjuryChanceAccurate", injuryRisk)
			end
		end
	end
	
	if #availableFuses <= 0 then
		repairButtonTooltip.description = repairButtonTooltip.description .. getText("ContextMenu_RU_NoFuses")
	else
		repairButtonTooltip.description = repairButtonTooltip.description .. getText("ContextMenu_RU_FusesBuffs")
		local lightGreen = "<RGB:0.8,1,0.8>" -- fuse names are coloured differently to their descriptions to make it easier to read
		local heavyGreen = "<RGB:0.5,1,0.5>" -- tier 1 and 2 fuses are also coloured differently to be easier to notice at a glance
		local white = "<RGB:1,1,1>" -- the description stays white, although you can change all of these colours freely :)
		for i, v in ipairs(availableFuses) do
			repairButtonTooltip.description = repairButtonTooltip.description .. " <LINE>- " .. getText("ContextMenu_RU_" .. v, lightGreen, heavyGreen, white)
		end
	end
	
	utilityInfo.toolTip = infoTooltip -- adds the tooltip to the Info button
	repairButton.toolTip = repairButtonTooltip -- and this adds a tooltip to the repair button
end

function startRepairs(player, utility)
	local plr = getPlayer()
	ISTimedActionQueue.add(RU_RepairAction:new(plr, utility))
end

Events.OnFillWorldObjectContextMenu.Add(restoreUtilities.AddContextPrompt)