
require "MF_ISMoodle"
MF.createMoodle("Bloodlust")

local BloodlustTrait = {}

BloodlustTrait.calculateBloodiness = function(player)
	local settings = SandboxVars.BloodlustTrait

	--- Get body bloodiness
	local body_bloodiness = 0
	local body_visual = player:getHumanVisual()
	for i=0, BloodBodyPartType.MAX:index()-1 do
		-- 0 is completely clean, 1 is completely bloody
		body_bloodiness = body_bloodiness + body_visual:getBlood(BloodBodyPartType.FromIndex(i))
	end
	body_bloodiness = body_bloodiness / BloodBodyPartType.MAX:index() -- get the overall bloodiness
	--print("Body bloodiness " .. tostring(body_bloodiness) .. " | With factor " .. tostring(body_bloodiness * settings.BodyBloodinessFactor))

	--- Get worn items bloodiness
	local clothing_bloodiness = 0
	local worn_items = player:getWornItems()
	for i=0, worn_items:size() - 1 do
		local item = worn_items:get(i):getItem()
		if item:IsClothing() then
			local covers = item:getCoveredParts()
			clothing_bloodiness = clothing_bloodiness + ((item:getBloodLevel() * covers:size()) * 0.01)
		end
	end
	clothing_bloodiness = clothing_bloodiness / BloodBodyPartType.MAX:index()
	--print("Clothing bloodiness " .. tostring(clothing_bloodiness) .. " | With factor " .. tostring(clothing_bloodiness * settings.ClothingBloodinessFactor))

	--- Get held item bloodiness
	local weapon_bloodiness = 0
	local first_held_item = player:getPrimaryHandItem()
	local second_held_item = player:getSecondaryHandItem()
	if first_held_item ~= nil and first_held_item:IsWeapon() then
		weapon_bloodiness = first_held_item:getBloodLevel()
	end
	if second_held_item ~= nil and second_held_item:IsWeapon() and not player:isItemInBothHands(second_held_item) then
		weapon_bloodiness = weapon_bloodiness + second_held_item:getBloodLevel()
	end
	--print("Weapon bloodiness " .. tostring(weapon_bloodiness) .. " | With factor " .. tostring(weapon_bloodiness * settings.WeaponBloodinessFactor))

	--- Finally get the overall bloodiness
	bloodiness = (body_bloodiness * settings.BodyBloodinessFactor) + (clothing_bloodiness * settings.ClothingBloodinessFactor) + (weapon_bloodiness * settings.WeaponBloodinessFactor)
	--print("Bloodiness " .. tostring(math.floor(bloodiness*100)/100))
	return bloodiness
end

--- I know it's janky, I'll rework it later
BloodlustTrait.isWeaponAcceptable = function(item)
	if item:getType() == "Fisticuffs" then -- Brutal Handwork
		return true
	end

	local item_categories = item:getCategories()
	if item_categories:contains("Axe") then
		return true
	elseif item_categories:contains("Spear") then
		return true
	elseif item_categories:contains("LongBlade") then
		return true
	elseif item_categories:contains("SmallBlade") then
		return true
	else
		return false
	end
end

BloodlustTrait.everyTenMinutes = function()
	local player = getPlayer()

	local data = player:getModData()
	local settings = SandboxVars.BloodlustTrait

	if not player:HasTrait("BloodlustTrait") then
		if settings.EarnDecreaseBloodyKills then
			local bloodiness = BloodlustTrait.calculateBloodiness(player)
			if bloodiness < settings.EarnBloodinessThreshold then
				data.BloodlustBloodyKills = math.max(0, data.BloodlustBloodyKills - 1)
				--print("Decreased bloody kills by 1. Current: "..tostring(data.BloodlustBloodyKills))
			end
		end do return end
	end

	if player:isAsleep() then
		do return end
	end

	--- Calculate minutes until desire to kill is taking over
	local bloodiness = BloodlustTrait.calculateBloodiness(player)
	local bloodlust_modifier = math.max(0, 1 - bloodiness)
	--print("Bloodlust modifier " .. tostring(bloodlust_modifier) .. " ("..tostring(bloodiness).." bloodiness)")

	local minutes_until_bloodlust = math.max(settings.MinMinutesNoKill, settings.MaxMinutesNoKill * bloodlust_modifier)
	--print("Minutes until bloodlust " .. tostring(minutes_until_bloodlust))

	local since_last_kill = (getGametimeTimestamp() - data.BloodlustLastKillAt) / 60 -- In minutes
	--print("Since last kill " .. tostring(since_last_kill))

	local moodle = MF.getMoodle("Bloodlust")
	if since_last_kill < minutes_until_bloodlust then
		local until_bloodlust = minutes_until_bloodlust - since_last_kill
		if until_bloodlust < (minutes_until_bloodlust/3) then
			moodle:setValue(0.4) -- Bad 1
		else
			moodle:setValue(0.5) -- hide
		end
		data.BloodlustIsActive = false
		do return end
	end

	--- TODO Probably should rework this to be more dynamic
	--local increment = 0 -- For every X minutes since kill reduce X times more

	-- Increase boredom, stress, and unhappiness
	local body_damage = player:getBodyDamage()
	local stats = player:getStats()

	local boredom = body_damage:getBoredomLevel()
	body_damage:setBoredomLevel(math.min(boredom + settings.BoredomGain, 99))

	local stress = stats:getStress()
	stats:setStress(math.min(stress + (settings.StressGain * 0.01), 0.99))

	local unhappiness = body_damage:getUnhappynessLevel()
	body_damage:setUnhappynessLevel(math.min(unhappiness + settings.UnhappinessGain, 99))

	--- Update the moodle
	if moodle:getValue() > 0.3 then
		moodle:setValue(0.2) -- Bad 3
	else
		moodle:doWiggle()
	end
	data.BloodlustIsActive = true
end

local hit_zombie = 0 -- Used to verify zombie kills
BloodlustTrait.onZombieKill = function(zombie)
	local player = getPlayer()
	if zombie:getAttackedBy() ~= player or zombie:hashCode() ~= hit_zombie then
		do return end
	end

	local settings = SandboxVars.BloodlustTrait
	local data = player:getModData()

	if player:HasTrait("BloodlustTrait") then
		local bloodiness = BloodlustTrait.calculateBloodiness(player)

		--- Reduce boredom, stress, cigar stress, and unhappiness
		local body_damage = player:getBodyDamage()
		local stats = player:getStats()
		local reduce_modifier = 1 + (bloodiness * settings.BloodinessImpactOnReduces)
		--print("Moodle reduces multiplier: "..tostring(reduce_modifier))

		local boredom = body_damage:getBoredomLevel()
		body_damage:setBoredomLevel(math.max(boredom - (settings.BoredomReduce * reduce_modifier), 0))
		--print("Boredom reduced: "..tostring(settings.BoredomReduce * reduce_modifier).." | "..tostring(boredom - body_damage:getBoredomLevel()))

		local stress = stats:getStress()
		stats:setStress(math.max(stress - (settings.StressReduce * 0.01 * reduce_modifier), 0))
		--print("Stress reduced: "..tostring(settings.StressReduce * 0.01 * reduce_modifier).." | "..tostring(stress - stats:getStress()))

		local cigar_stress = stats:getStressFromCigarettes()
		stats:setStressFromCigarettes(math.max(cigar_stress - (settings.CigarStressReduce * 0.01 * reduce_modifier), 0))
		--print("CigarStress reduced: "..tostring(settings.CigarStressReduce * 0.01 * reduce_modifier).." | "..tostring(cigar_stress - stats:getStressFromCigarettes()))

		local unhappiness = body_damage:getUnhappynessLevel()
		body_damage:setUnhappynessLevel(math.max(unhappiness - (settings.UnhappinessReduce * reduce_modifier), 0))
		--print("Unhappiness reduced: "..tostring(settings.UnhappinessReduce * reduce_modifier).." | "..tostring(unhappiness - body_damage:getUnhappynessLevel()))

		--- Finally a desired kill!
		if data.BloodlustIsActive then
			player:addLineChatElement(getText("UI_bloodlust_first_kill_after_long_break"), 1, 0, 0)
			addSound(player, player:getX(), player:getY(), player:getZ(), 15, 1.0)
		end

		-- Update mod data
		data.BloodlustLastKillAt = getGametimeTimestamp()
		data.BloodlustIsActive = false

		-- Moodle management
		MF.getMoodle("Bloodlust"):setValue(0.5) -- hide
	else
		--- Handle the trait earning
		if not settings.EarnIt then
			do return end
		end

		local bloodiness = BloodlustTrait.calculateBloodiness(player)
		if bloodiness >= settings.EarnBloodinessThreshold then
			data.BloodlustBloodyKills = data.BloodlustBloodyKills + 1
			--print("Increased bloody kills by 1. Current: "..tostring(data.BloodlustBloodyKills))
		end

		if data.BloodlustBloodyKills >= settings.EarnKiilsThreshold then
			player:getTraits():add("BloodlustTrait")
			player:addLineChatElement(getText("UI_bloodlust_earned"), 1, 0, 0)
			addSound(player, player:getX(), player:getY(), player:getZ(), 30, 1.0)
		end
	end
end

BloodlustTrait.onWeaponHit = function(player, target, weapon, damage)
	--print("------------------ WEAPON HIT! ----------------------")
	--print("Target: "..tostring(target))
	--print("Weapon: "..tostring(weapon:getType()).." | "..tostring(weapon:getCategories()))
	--print("Damage: "..tostring(damage))
	--print("Health: "..tostring(target:getHealth()))
	--print("=====================================================")

	if not instanceof(player, "IsoPlayer") or not instanceof(target, "IsoZombie") or player ~= getPlayer() then
		do return end
	end
	hit_zombie = target:hashCode() -- Used in onZombieKill

	if not player:HasTrait("BloodlustTrait") then
		do return end
	end

	-- Additional damage inflicted only for specific weapons
	if not BloodlustTrait.isWeaponAcceptable(weapon) then
		do return end
	end

	local settings = SandboxVars.BloodlustTrait
	local data = player:getModData()

	--- Deal additional damage based on bloodiness
	-- It's probably too much, since it deals damage to general health instead of specific body part health
	local damage_to_add
	if data.BloodlustIsActive and settings.MassiveDamageOnBloodlust then
		damage_to_add = 2
	else
		local bloodiness = BloodlustTrait.calculateBloodiness(player)
		damage_to_add = damage * math.min(settings.BloodinessDamageLimit, bloodiness * settings.BloodinessDamageMultiplier)
	end
	--print("Additional damage: "..tostring(damage_to_add))

	target:setHealth(target:getHealth() - damage_to_add)
	--print("Target health: "..tostring(target:getHealth()))

	if target:getHealth() <= 0 then
		target:update()
	end
end

BloodlustTrait.onPlayerUpdate = function(player)
	if player ~= getPlayer() or not player:isAlive() then
		do return end
	end
	if not player:HasTrait("BloodlustTrait") then
		do return end
	end
	local data = player:getModData()
	if data.BloodlustIsActive and SandboxVars.BloodlustTrait.DisablePanic then
		player:getStats():setPanic(0)
	end
end

BloodlustTrait.onCreatePlayer = function(index, player)
	if player == getPlayer() then
		local data = player:getModData()
		if data.BloodlustLastKillAt == nil then
			data.BloodlustLastKillAt = getGametimeTimestamp()
		end
		if data.BloodlustIsActive == nil then
			data.BloodlustIsActive = false
		end
		if data.BloodlustBloodyKills == nil then
			data.BloodlustBloodyKills = 0
		end
	end
end


Events.OnCreatePlayer.Add(BloodlustTrait.onCreatePlayer)
Events.OnPlayerUpdate.Add(BloodlustTrait.onPlayerUpdate)
Events.EveryTenMinutes.Add(BloodlustTrait.everyTenMinutes)
Events.OnZombieDead.Add(BloodlustTrait.onZombieKill)
Events.OnWeaponHitCharacter.Add(BloodlustTrait.onWeaponHit)

return BloodlustTrait