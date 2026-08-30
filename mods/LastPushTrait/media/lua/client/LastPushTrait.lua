
local LastPushTrait = {}

LastPushTrait.getDistanceBetween = function(z1, z2) -- Copied from Sixth Sense Trait
	if (z1 == nil) or (z2 == nil) then return -1; end

	local z2z = z2:getZ();
	local z1z = z1:getZ();

	local floorDifference = math.abs(z2z - z1z);
	if floorDifference >= 0.5 then -- For stairs
		return -1
	end

	local z1x = z1:getX();
	local z1y = z1:getY();
	local z2x = z2:getX();
	local z2y = z2:getY();

	local dx = z1x - z2x;
	local dy = z1y - z2y;
    local dz = floorDifference * 2

	local val = math.sqrt ((dx * dx) + (dy * dy) + (dz * dz))

	return val
end

local last_tested_attacker = nil
LastPushTrait.testHitActivation = function(player)
	local settings = SandboxVars.LastPushTrait
	if not settings.HitActivation then
		return false
	end
	if player:getCurrentStateName() ~= "PlayerHitReactionState" then
		return false
	end
	local attacker = player:getAttackedBy()
	if attacker == nil then
		do return end
	end
	attacker = attacker:hashCode()
	if attacker == last_tested_attacker then
		do return end -- Don't test again if the attacker is the same
	end
	last_tested_attacker = attacker

	local objects = player:getCell():getObjectList()
	if objects == nil then
		do return end
	end
	local zombies = 0
	for i=0, objects:size()-1 do
		local zombie = objects:get(i);
		if instanceof(zombie, "IsoZombie") then
			if not zombie:isKnockedDown() then
				local distance = LastPushTrait.getDistanceBetween(player, zombie)
				if distance ~= -1 and distance <= settings.HitActivationDistance then
					zombies = zombies + 1
					if zombies >= settings.HitActivationZombies then
						return true
					end
				end
			end
		end
	end
	return false
end

LastPushTrait.getNearestZombies = function(player)
	local objects = player:getCell():getObjectList()
	if objects == nil then
		do return end
	end

	local zombies = {}
	for i=0, objects:size()-1 do
		local zombie = objects:get(i);
		if instanceof(zombie, "IsoZombie") then
			if not zombie:isKnockedDown() then
				local distance = LastPushTrait.getDistanceBetween(player, zombie)
				if distance ~= -1 and distance <= SandboxVars.LastPushTrait.PushDistance then
					table.insert(zombies, {zombie, distance})
				end
			end
		end
	end
 
	--- Sort by how close a zombie is
	table.sort(zombies, function (left, right)
		return left[2] < right[2]
	end)
	return zombies
end

LastPushTrait.pushNearbyZombies = function(player)
	local zombies = LastPushTrait.getNearestZombies(player)

	--- Push/kill the closest ones until the limit
	local settings = SandboxVars.LastPushTrait
	for i, data in ipairs(zombies) do
		if settings.ZombiesLimit ~= 0 and settings.ZombiesLimit < i then
			do return end
		end

		local zombie = data[1]

		--- Push the zombie
		-- Took this code from Project Fallout: Scientific Armoury mod
		zombie:knockDown(false) -- isHitFromBehind
		zombie:setKnockedDown(true)
		zombie:setStaggerBack(true)
		zombie:setHitReaction("")
		zombie:setPlayerAttackPosition("FRONT")
		zombie:setHitForce(2.0)
		zombie:reportEvent("wasHit")

		-- This code works too though
		--zombie:knockDown(false) -- isHitFromBehind
		--zombie:update()

		--- Damage the zombie
		if (ZombRand(100)+1) <= math.floor(settings.DamageChance*100) then
			local damage = settings.DamageMin + (ZombRand(((settings.DamageMax - settings.DamageMin) * 100) + 1) / 100)
			--print("Damage: "..tostring(damage))

			zombie:setHealth(zombie:getHealth() - damage)
			if zombie:getHealth() <= 0 then
				zombie:update()
			end
		end
	end
end

LastPushTrait.stopDeath = function(player)
	--- Cancel death
	-- Probably terribly wrong, I'm sorry, but it works (Tested only in singleplayer, though)
	player:setDeathDragDown(false) -- Doesn't have an effect on its own, but is probably required. Also my code relies on isDeathDragDown
	if player:getCurrentStateName() == "PlayerHitReactionState" then -- This check is required to not accidentaly break the other state
		player:changeState(IdleState:instance())
	end
	player:postupdate()
	player:setHitReaction("") -- This or the next line seems to interrupt the death animation in case it still started
	player:reportEvent("wasHit")
	player:setBlockMovement(false) -- Added this because sometimes it glitches and the character can't move

	--- Do not scream, silly
	local death_sound
	if player:isFemale() then
		death_sound = "FemaleBeingEatenDeath"
	else
		death_sound = "MaleBeingEatenDeath"
	end
	if player:getEmitter():isPlaying(death_sound) then
		player:getEmitter():stopSoundByName(death_sound)
	end
end

LastPushTrait.processEarning = function()
	local player = getPlayer()
	if player:HasTrait("LastPush") then
		do return end
	end

	local settings = SandboxVars.LastPushTrait
	if not settings.EarnIt then
		do return end
	end
	if player:getPerkLevel(Perks.Strength) >= settings.StrengthRequirement then
		player:getTraits():add("LastPush")
	end
end

LastPushTrait.onPlayerUpdate = function(player)
	if not player:HasTrait("LastPush") then
		do return end
	end

	local data = player:getModData()
	local settings = SandboxVars.LastPushTrait
	if settings.UsesLimit ~= 0 and data.LastPushUses >= settings.UsesLimit then
		do return end -- No uses left
	end

	local cooldown = settings.Cooldown
	if data.LastPushCooldownRandomnessIsPlus then
		cooldown = cooldown + data.LastPushCooldownRandomness
	else
		cooldown = cooldown - data.LastPushCooldownRandomness
	end

	local since_last_use = (getGametimeTimestamp() - data.LastPushUsedAt) / 60 -- In minutes
	if since_last_use < cooldown then
		do return end
	end

	if player:isDeathDragDown() or LastPushTrait.testHitActivation(player) then
		--- Test endurance and fatigue
		local stats = player:getStats()
		local endurance = stats:getEndurance()
		local fatigue = stats:getFatigue()
		if endurance < (settings.EnduranceMin/100) or fatigue > (settings.FatigueMax/100) then
			-- Don't spam the speech
			if data.LastPushTiredSpeechAt == nil or (getTimestamp() - data.LastPushTiredSpeechAt) > 5 then
				data.LastPushTiredSpeechAt = getTimestamp()
				player:addLineChatElement(getText("UI_lastpush_too_tired_phrase"), 1, 0, 0)
				addSound(player, player:getX(), player:getY(), player:getZ(), 15, 1.0)
			end
			do return end
		end

		--- Test Use Chance
		if data.LastPushLostAt ~= nil and (getTimestamp() - data.LastPushLostAt) < settings.UseChanceReroll then
			do return end
		elseif settings.UseChance ~= 100 and (ZombRand(100)+1) > math.floor(settings.UseChance*100) then
			data.LastPushLostAt = getTimestamp()
			player:addLineChatElement(getText("UI_lastpush_bad_luch_phrase"), 1, 0, 0)
			addSound(player, player:getX(), player:getY(), player:getZ(), 30, 1.0)
			do return end
		end

		--- Do the magic
		LastPushTrait.pushNearbyZombies(player)
		if player:isDeathDragDown() then
			LastPushTrait.stopDeath(player)
		end

		--- Reduce endurance and add fatigue
		stats:setEndurance(math.max(0, endurance - (settings.EnduranceCost/100)))
		stats:setFatigue(math.min(1, fatigue + (settings.FatigueAddUp/100)))

		-- Data updates
		data.LastPushUses = data.LastPushUses + 1
		data.LastPushUsedAt = getGametimeTimestamp()
		data.LastPushCooldownRandomness = ZombRand(settings.Cooldown * settings.CooldownRandomness)
		data.LastPushCooldownRandomnessIsPlus = ZombRand(2) == 1

		-- Speech
		player:addLineChatElement(getText("UI_lastpush_phrase"), 1, 0, 0)
		addSound(player, player:getX(), player:getY(), player:getZ(), settings.SoundRadius, 1.0)
	end
end

LastPushTrait.onCreatePlayer = function(index, player)
	if player == getPlayer() then
		local settings = SandboxVars.LastPushTrait
		local data = player:getModData()
		if data.LastPushUses == nil then
			data.LastPushUses = 0
		end
		if data.LastPushUsedAt == nil then
			data.LastPushUsedAt = 0
		end
		if data.LastPushCooldownRandomness == nil then
			data.LastPushCooldownRandomness = ZombRand(settings.Cooldown * settings.CooldownRandomness)
		end
		if data.LastPushCooldownRandomnessIsPlus == nil then
			data.LastPushCooldownRandomnessIsPlus = ZombRand(2) == 1
		end
		if data.LastPushLostAt == nil then -- just in case it was bugged or something
			data.LastPushLostAt = getTimestamp()
		end
	end
end

Events.OnCreatePlayer.Add(LastPushTrait.onCreatePlayer)
Events.OnPlayerUpdate.Add(LastPushTrait.onPlayerUpdate)
Events.EveryTenMinutes.Add(LastPushTrait.processEarning)

return LastPushTrait