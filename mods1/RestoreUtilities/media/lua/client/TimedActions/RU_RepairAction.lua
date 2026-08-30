require "TimedActions/ISBaseTimedAction"
require "Base"

RU_RepairAction = ISBaseTimedAction:derive("RU_RepairAction");
restoreUtilities = restoreUtilities or {}

local function searchFuses(fusesInInv, fuseToFind) -- searches our inventory to find a specific fuse
	local foundFuse = false
	for i, v in ipairs(fusesInInv) do
		if v == fuseToFind then
			foundFuse = true
			break
		end
	end
	return foundFuse
end

function RU_RepairAction:isValid() -- Check if the action can be done
	if self.ElectricalLvl < self.requiredSkillLvl then return false end -- if skill level is too low to do these repairs
	if self.scrapCount < self.requiredParts then return false end -- if the player doesn't have enough scrap to do the repairs
	if restoreUtilities[self.UtilityRepair .. "Days"] > 5 then return false end -- if system is already repaired, don't let us repair again
	if self.generatorKnowledgeRequired then -- if using the fuse that bypasses generator knowledge then we don't check for it
		if not self.player:isRecipeKnown("Generator") then return end -- if no fuse and no gen knowledge, no repairs allowed
	end
	if powerDisabledByBlackouts then return end -- if using blackouts mod, disable repairs during one of their blackouts
	return true
end

function RU_RepairAction:update() -- Triggers every game update when the action is performed
end

function RU_RepairAction:start() -- Triggers when the action starts
	self:setActionAnim("VehicleWorkOnMid") -- I thought this animation looked best, the blowtorch animation might've been good but I don't want to require a blowtorch set to repair a utility
end

function RU_RepairAction:stop() -- Triggers if the action is cancelled
    ISBaseTimedAction.stop(self);
end

function RU_RepairAction:perform() -- Triggers when the action is complete
	for i = 1, self.requiredParts do -- remove the required amount of scrap after a repair action, regardless of if success or fail
		self.character:getInventory():RemoveOneOf("Base.ElectronicsScrap")
	end
	for i, v in ipairs(self.availableFuses) do -- remove all the fuses we used during this repair operation, whether successful or not
		self.character:getInventory():RemoveOneOf("RestoreUtilities." .. v)
	end
	
	local failedRepairs = false -- roll for a failed repair attempt
	local failRoll = ZombRand(1, 100)
	if failRoll <= self.failChance then
		failedRepairs = true
	end
	
	local injuryRoll = ZombRand(1, 100) -- roll for an injury
	if injuryRoll <= self.injuryChance then
		local validInjuryParts = {BodyPartType.ForeArm_L, BodyPartType.ForeArm_R, BodyPartType.Hand_L, BodyPartType.Hand_R, BodyPartType.UpperArm_L, BodyPartType.UpperArm_R, BodyPartType.Torso_Upper} -- injuries can occur on the arms and upper torso
		local placeToInjure = validInjuryParts[ZombRand(1, #validInjuryParts)]
		local selectedPart = self.player:getBodyDamage():getBodyPart(placeToInjure)
		if injuryRoll > 80 then -- if injury chance AND roll are above 80, apply a burn
			selectedPart:setBurned()
		elseif injuryRoll > 50 then -- if injury chance AND roll are above 50 but at or below 80, apply a deep wound
			selectedPart:generateDeepWound()
		else -- if not applying a burn or a deep wound, apply a laceration
			selectedPart:setCut(true)
		end
	end
	
	if not failedRepairs then -- if we passed the repair check
		local repairTimes = {(self.ElectricalLvl * 7) - 3, (self.ElectricalLvl * 7) + 3} -- set min and max time repairs can hold for
		if searchFuses(self.availableFuses, "FuseSparePartsT2") then -- if using spare parts fuse, increase repair efficiency
			repairTimes[1] = math.ceil(repairTimes[1]*1.5)
			repairTimes[2] = math.ceil(repairTimes[2]*1.5)
		elseif searchFuses(self.availableFuses, "FuseSparePartsT1") then
			repairTimes[1] = math.ceil(repairTimes[1]*1.25)
			repairTimes[2] = math.ceil(repairTimes[2]*1.25)
		end
		local finalRepairTime = ZombRand(repairTimes[1], repairTimes[2]) -- the actual finalised repair time
		local inverterActive = false
		local inverterTier = 0
		if searchFuses(self.availableFuses, "FuseInverterT2") then -- if using inverter fuse, enable some variables that are handled in restoreUtilities.lua
			inverterActive = true
			inverterTier = 0.5 -- inverter tier 2 adds 50% of the repair efficiency to the opposite utility, regardless of if it needs repairs or not
		elseif searchFuses(self.availableFuses, "FuseInverterT1") then
			inverterActive = true
			inverterTier = 0.25 -- inverter tier 1 adds 25% of the repair efficiency to the opposite utility
		end
		if not isClient() then
			restoreUtilities.addDays(self.UtilityRepair, finalRepairTime, inverterActive, inverterTier, self.repairNoiseRange, self.player) -- repairs the system by using the function in restoreUtilities.lua
		elseif isClient() then
			local dataTable = {self.UtilityRepair, finalRepairTime, inverterActive, inverterTier, self.repairNoiseRange, self.player}
			sendClientCommand("RestoreUtilities", "RepairComplete", dataTable)
		end
		if self.UtilityRepair == "Elec" then -- play the in-world sounds, these sounds do not emit noise for zombies to hear! the noise-generation for zombies is in restoreUtilities.lua
			self.player:getEmitter():playSound("RU_PowerOn")
		elseif self.UtilityRepair == "Water" then
			self.player:getEmitter():playSound("RU_WaterOn")
		end
		finalRepairTime = math.floor((finalRepairTime * SandboxVars.RestoreUtilities.ScalingRepairModifier) + 0.5) -- server will verify this maths on its side, we do it here so that notes will show the correct estimate when using the scaling repair modifier
		local notesTier = 0 -- easy marker for seeing if we used a notes fuse or not
		if searchFuses(self.availableFuses, "FuseNotesT2") then -- add extra XP and setup for note item when repairing with note fuse
			self.player:getXp():AddXP(Perks.Electricity, self.xpEarned * 1.2)
			notesTier = 2
		elseif searchFuses(self.availableFuses, "FuseNotesT1") then
			self.player:getXp():AddXP(Perks.Electricity, self.xpEarned * 1.1)
			notesTier = 1
		else -- if we aren't using the fuse to gain extra xp and a repair details note
			self.player:getXp():AddXP(Perks.Electricity, self.xpEarned)
		end
		self.player:addLineChatElement(getText("ContextMenu_RU_Success" .. ZombRand(1, 5)), 0.1, 1, 0) -- the player will say a success line over their head
		if notesTier > 0 then -- if we used either tier of notes, create a note item for the player
			local resultPaper
			if notesTier == 2 then
				resultPaper = self.player:getInventory():AddItem("RestoreUtilities.RepairResultsT2")
				resultPaper:getModData().Accuracy = "Accurate"
			else
				resultPaper = self.player:getInventory():AddItem("RestoreUtilities.RepairResultsT1")
				resultPaper:getModData().Accuracy = "Loose"
			end
			local paperModData = resultPaper:getModData() -- the paper's information is saved to it's moddata, clients see the data in ShowResultsTooltip.lua - setting the item's tooltip from here works but the information is lost after exiting the world
			local clock = UIManager.getClock()
			local repairDate = ""
			if clock and clock:isDateVisible() then -- write down the date the repairs were done on if the player has a digital watch
				local gameTime = getGameTime()
				local day = gameTime:getDayPlusOne() -- a month starts on the 0th in zomboid-land, so we use this to get the correct date
				local month = gameTime:getMonth()
				local year = gameTime:getYear()
				paperModData.Timestamp = true
				paperModData.RepairDay = day
				paperModData.RepairMonth = month + 1 -- jan is "month 0" for some reason, so we have to offset all the months by 1
				paperModData.RepairYear = year
			end
			local utilityName = ""
			local altUtilityName = ""
			if self.UtilityRepair == "Elec" then -- set alt names for the utilities just in case an inverter was used too
				utilityName = "Power"
				altUtilityName = "Water"
			else
				utilityName = "Water"
				altUtilityName = "Power"
			end	
			paperModData.utility = utilityName
			paperModData.altUtility = altUtilityName
			if notesTier == 2 then -- when using tier 2 notes
				if inverterActive then -- show time repaired on opposite utility if using an inverter fuse
					paperModData.InverterActive = true
					if inverterTier == 0.5 then -- if using inverter fuse tier 2, no penalty to normal repair efficiency
						paperModData.repairLength = finalRepairTime
						paperModData.altRepairLength = math.ceil(finalRepairTime/2)
					else -- if using inverter fuse tier 1, also remember to apply penalty to utility repair
						paperModData.repairLength = math.ceil(finalRepairTime/2)
						paperModData.altRepairLength = math.ceil(finalRepairTime/4)
					end
				else -- if not using an inverter fuse
					paperModData.repairLength = finalRepairTime
				end
			else -- if notesTier == 1
				local function determineEstimates(accurateTime) -- figure out estimation strings (used for notes fuse tier 1 only)
					local estimatedWeeks = 1 -- placeholder number really
					local finalRepairEstimate = "" -- the eventual string we will send back
					if accurateTime < 2 then -- if we are adding 1 week or less somehow, then set the estimate to always be 2 (would always show as "1-2 weeks")
						estimatedWeeks = 2
					else -- if 2 or more weeks will be repaired, flip to see whether the estimate should include 1 week higher or lower
						local coinFlip = ZombRand(1, 2)
						if coinFlip == 1 then
							estimatedWeeks = accurateTime - 1
						else
							estimatedWeeks = accurateTime + 1
						end
					end
					local finalRepairEstimate = ""
					if estimatedWeeks > accurateTime then -- figure out which number is smaller so it can go at the front of the estimate, "2-1 weeks" would look odd
						finalRepairEstimate = accurateTime .. "-" .. estimatedWeeks
					else
						finalRepairEstimate = estimatedWeeks .. "-" .. accurateTime
					end
					return finalRepairEstimate -- send back our calculated string
				end
				
				if inverterActive then -- when repairing with inverter, give estimates on both utilities
					paperModData.InverterActive = true
					if inverterTier == 0.5 then -- when using tier 2 inverter, no penalty for utility being repaired
						local repairWeeks = math.floor((finalRepairTime/7) + 0.5)
						local repairAltWeeks = math.floor(((finalRepairTime/2)/7) + 0.5)
						local finalRepairEstimate = determineEstimates(repairWeeks) -- 100% repair efficiency
						local finalAltRepairEstimate = determineEstimates(repairAltWeeks) -- 50% repair efficiency
						paperModData.repairLength = finalRepairEstimate
						paperModData.altRepairLength = finalAltRepairEstimate
					else -- inverter tier 1 gets a penalty to repairs and repairs the opposite utility at 25% efficiency
						local finalRepairEstimate = determineEstimates(math.floor(((finalRepairTime/2)/7) + 0.5)) -- 50% repair efficiency
						local finalAltRepairEstimate = determineEstimates(math.floor(((finalRepairTime/4)/7) + 0.5)) -- 25% repair efficiency
						paperModData.repairLength = finalRepairEstimate
						paperModData.altRepairLength = finalAltRepairEstimate
					end
				else -- if not repairing with an inverter, give an estimate on the utility we're repairing
					local finalRepairEstimate = determineEstimates(math.floor((finalRepairTime/7) + 0.5)) -- and of course, divided by 7 because we want these in weeks, not days!
					paperModData.repairLength = finalRepairEstimate
				end
			end
		end
	else -- if the repairs failed
		self.player:getXp():AddXP(Perks.Electricity, self.xpEarned * 0.1) -- gain 10% worth of successful repair xp on failed attempt
		self.player:addLineChatElement(getText("ContextMenu_RU_Failure" .. ZombRand(1, 5)), 1, 0, 0) -- the player will say a failure line over their head
	end
    ISBaseTimedAction.perform(self);
end

function RU_RepairAction:new(character, utilityBeingRepaired)
    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o.character = character;
	self.player = character
	self.generatorKnowledgeRequired = true
	self.failChance = restoreUtilities.FailChance
	self.injuryChance = restoreUtilities.InjuryChance
	self.xpEarned = restoreUtilities.XPEarned
	self.repairNoiseRange = restoreUtilities.SoundRange -- repair noise "pulse" range, 600 is apparently the same as a house alarm
	
	self.availableFuses = {}
	for i, v in ipairs(restoreUtilities.AllFuses) do -- find which fuses from the available list the player has in their inventory
		if character:getInventory():getItemCount("RestoreUtilities." .. v .. "T2", true) > 0 then -- we only use 1 fuse of either tier per repair operation, tier 2 fuses are given priority
			self.availableFuses[#self.availableFuses + 1] = v .. "T2"
		elseif character:getInventory():getItemCount("RestoreUtilities." .. v .. "T1", true) > 0 then -- if we don't have any tier 2 fuses of the variety we're searching for, look for any tier 1 fuses
			self.availableFuses[#self.availableFuses + 1] = v .. "T1"
		end
	end
    o.maxTime = 5000; -- Time taken by the action, attempted to get this to about half an hour in-game (at default time settings)
	if searchFuses(self.availableFuses, "FuseCoilT2") then -- coils reduce max time taken to repair and reduce sound range
		o.maxTime = o.maxTime * 0.5
		self.repairNoiseRange = 0
	elseif searchFuses(self.availableFuses, "FuseCoilT1") then
		o.maxTime = o.maxTime * 0.75
		self.repairNoiseRange = self.repairNoiseRange / 2
	end
	if searchFuses(self.availableFuses, "FuseRubberWiresT2") or searchFuses(self.availableFuses, "FuseRubberWiresT1") then
		self.generatorKnowledgeRequired = false
	end
	
	self.UtilityRepair = utilityBeingRepaired -- marks whether we're fixing the water or the power with this action
	
	self.requiredSkillLvl = restoreUtilities.MinSkillLvl -- level required to start repairs
	self.ElectricalLvl = character:getPerkLevel(Perks.Electricity) -- the player's electrical skill
	if searchFuses(self.availableFuses, "FuseMarkedCompsT2") then -- if using the marked components, increase effective electrical level and reduce chance of failure
		self.ElectricalLvl = self.ElectricalLvl + 2
		self.failChance = 0
	elseif searchFuses(self.availableFuses, "FuseMarkedCompsT1") then
		self.ElectricalLvl = self.ElectricalLvl + 1
		self.failChance = self.failChance - ((self.ElectricalLvl - self.requiredSkillLvl) * 8)
		self.failChance = self.failChance / 2
	else -- set fail chance when not using a marked components fuse
		self.failChance = self.failChance - ((self.ElectricalLvl - self.requiredSkillLvl) * 8) 
	end
	
	if searchFuses(self.availableFuses, "FuseRubberWiresT2") then -- reduce injury chance with rubber wires
		self.injuryChance = 0
	elseif searchFuses(self.availableFuses, "FuseRubberWiresT1") then
		self.injuryChance = self.injuryChance - ((self.ElectricalLvl - self.requiredSkillLvl) * 10)
		self.injuryChance = self.injuryChance / 2
	else
		self.injuryChance = self.injuryChance - ((self.ElectricalLvl - self.requiredSkillLvl) * 10)
	end
	
	self.scrapCount = character:getInventory():getItemCount("Base.ElectronicsScrap", true) -- amount of scrap in player's inventory + bags
	self.requiredParts = restoreUtilities.scrapNeededForRepair -- amount of parts needed to complete repairs

	if searchFuses(self.availableFuses, "FuseSparePartsT2") then -- discount cost of repairs when using the spare parts
		self.requiredParts = math.floor(self.requiredParts * 0.5) -- round down to whole number
	elseif searchFuses(self.availableFuses, "FuseSparePartsT1") then
		self.requiredParts = math.floor(self.requiredParts * 0.75)
	end
    if o.character:isTimedActionInstant() then o.maxTime = 1; end
    return o;
end