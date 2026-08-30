--***********************************************************
--**                       BitBraven                       **
--***********************************************************

local Settings = BravensBikes.Settings.options
local OnExitVehicle = ISVehicleMenu.onExit
local tickCounter = 0

-- Damage variables
local bikeEngine
local bikeCondition = 0

--#region AUXILIARY FUNCTIONS

-- Throw the player off the bicycle!
local FallOut = function(playerObj)
	local vehicle = playerObj:getVehicle()
	BravensUtils.TryStopSoundClip(vehicle, "BicycleRide")

	vehicle:exit(playerObj)
	vehicle:setHotwired(false)
	vehicle:shutOff()

	playerObj:setBumpType("stagger")
	playerObj:setVariable("BumpDone", false)
	playerObj:setVariable("BumpFall", true)
	playerObj:setVariable("BumpFallType", "pushedFront") -- Crawl out through the fallout, baby!
end

-- Perform occasional checks so as to conserve performance
local OccasionalCheck = function()
	local playerObj = getPlayer(); if not playerObj then return end
	local vehicle = playerObj:getVehicle(); if not vehicle then return end
	if not BravensBikeUtils.isBike(vehicle) then return end

	-- Sound check
	local bikeSpeed = vehicle:getCurrentSpeedKmHour()

	if (bikeSpeed > -0.15 and bikeSpeed < 0.15) then
		BravensUtils.TryStopSoundClip(vehicle, "BicycleRide")
	else
		BravensUtils.TryPlaySoundClip(vehicle, "BicycleRide")
	end

	-- Collision check
	if bikeEngine then
		if bikeEngine:getCondition() ~= bikeCondition then
			if (ZombRand(1000) <= 1) then
				FallOut(playerObj)
			end
			bikeCondition = bikeEngine:getCondition()
		end
	end
end
--#endregion

--#region EVENT LISTENERS

local everyTenMinutes = function()
	local playerObj = getPlayer(); if not playerObj then return end
	local vehicle = playerObj:getVehicle(); if not vehicle then return end
	if not BravensBikeUtils.isBike(vehicle) then return end
	if vehicle:getCurrentSpeedKmHour() == 0 then return end

	if Settings.toggleExp == true then
		local fitnessLevel = playerObj:getPerkLevel(Perks.Fitness)
		if fitnessLevel ~= 10 then -- Give some EXP for pedalling every now and then
			playerObj:getXp():AddXP(Perks.Fitness, Settings.expGain * fitnessLevel)
		end
	end
end

local everyOneMinute = function()
	local playerObj = getPlayer(); if not playerObj then return end
	local vehicle = playerObj:getVehicle(); if not vehicle then return end
	if not BravensBikeUtils.isBike(vehicle) then return end

	local bikeSpeed = vehicle:getCurrentSpeedKmHour()

	if (bikeSpeed > 1 or bikeSpeed < -1) then

		if Settings.toggleWarmth == true then -- Make the player warmer from pedalling
			if playerObj:getTemperature() < 36 then
				playerObj:setTemperature(playerObj:getTemperature() + (Settings.warmthGain * vehicle:getCurrentSpeedKmHour()))
			end
		end

		if Settings.toggleExhaustion == true then -- Drain the player's stamina from pedalling
			local stats = playerObj:getStats()
			if stats:getEndurance() > 0.21 then
				stats:setEndurance(stats:getEndurance() - (Settings.exhaustionDrain * vehicle:getCurrentSpeedKmHour()))
			else
				FallOut(playerObj)
			end
		end
	end
end

local onZombieUpdate = function(zombie)
	local playerObj = getPlayer(); if not playerObj then return end
	local vehicle = playerObj:getVehicle(); if not vehicle then return end
	if not BravensBikeUtils.isBike(vehicle) then return end
	if not zombie:getTarget() == playerObj then return end
	if vehicle:getCurrentSpeedKmHour() > 5 or vehicle:getCurrentSpeedKmHour() < -5 then return end
	if not zombie:isAttacking() then return end
	if vehicle:getDistanceSq(zombie) > 1 then return end

	if(ZombRand(100) == 1) then
		playerObj:getBodyDamage():AddRandomDamageFromZombie(zombie, nil)
	end
end

local onTick = function(tick)
	local playerObj = getPlayer(); if not playerObj then return end
	local vehicle = playerObj:getVehicle(); if not vehicle then return end
	if not BravensBikeUtils.isBike(vehicle) then return end

	if tickCounter < 70 then
		tickCounter = tickCounter + 1
	else
		OccasionalCheck()
		tickCounter = 0
	end
end

local OnEnterVehicle = function(playerObj)
	local vehicle = playerObj:getVehicle(); if not vehicle then return end
	if not BravensBikeUtils.isBike(vehicle) then return end

	bikeEngine = vehicle:getPartById("Engine")
	bikeCondition = 100
	playerObj:SetVariable("BikeType", vehicle:getScriptName())

	local windowPart = vehicle:getPartById("WindowFront")
	if windowPart and windowPart:getWindow():isOpen() == false then -- Force window open
		if getWorld():getGameMode() == "Multiplayer" then
			local args = { vehicle = vehicle:getId(), part = windowPart:getId(), open = true }
			sendClientCommand(playerObj, 'vehicle', 'setWindowOpen', args)
		else
			windowPart:getWindow():setOpen(true)
		end
	end

	-- Haxx to disable vehicle UI, fix invisible parts and get the bicycle started
	if (vehicle:isDriver(playerObj)) then

		if getPlayerVehicleDashboard(playerObj:getPlayerNum()).vehicle ~= nil then
			getPlayerVehicleDashboard(playerObj:getPlayerNum()):setVehicle(nil)
			vehicle:setHotwired(true)
			vehicle:engineDoRunning()
			ISVehicleMechanics.onCheatRepairPart(playerObj, vehicle:getPartById("Engine"))
			ISVehicleMechanics.onCheatRepairPart(playerObj, vehicle:getPartById("GasTank"))
			ISVehicleMechanics.onCheatRepairPart(playerObj, vehicle:getPartById("Battery"))
			ISVehicleMechanics.onCheatRepairPart(playerObj, vehicle:getPartById("TireFrontRight"))
			ISVehicleMechanics.onCheatRepairPart(playerObj, vehicle:getPartById("TireRearRight"))
			ISVehicleMechanics.onCheatRepairPart(playerObj, vehicle:getPartById("SuspensionFrontRight"))
			ISVehicleMechanics.onCheatRepairPart(playerObj, vehicle:getPartById("SuspensionRearRight"))
		end
		if getWorld():getGameMode() == "Multiplayer" then --MP Haxx
			sendClientCommand(playerObj, 'vehicle', 'startEngine', {haveKey=true})
		end
	end

	-- Subscribe to events only when on a bicycle to conserve performance
	Events.EveryTenMinutes.Add(everyTenMinutes)
	Events.EveryOneMinute.Add(everyOneMinute)
	Events.OnZombieUpdate.Add(onZombieUpdate)
	Events.OnTick.Add(onTick)
end

local OnGameStart = function()
	local playerObj = getPlayer(); if not playerObj then return end
	OnEnterVehicle(playerObj)
end
--#endregion

--#region VANILLA OVERRIDES

ISVehicleMenu.onExit = function(playerObj, seatFrom)
	local vehicle = playerObj:getVehicle()
	if not vehicle then return end

	if BravensBikeUtils.isBike(vehicle) then

		bikeEngine = nil

		-- Delay because game is now sending this command earlier for <<SOME REASON™>>
		BravensUtils.DelayFunction(function()

			playerObj:SetVariable("BikeType", "")
			BravensUtils.TryStopSoundClip(vehicle, "BicycleRide")
			vehicle:shutOff()

			-- Remove unnecessary event listeners
			Events.EveryTenMinutes.Remove(everyTenMinutes)
			Events.EveryOneMinute.Remove(everyOneMinute)
			Events.OnZombieUpdate.Remove(onZombieUpdate)
			Events.OnTick.Remove(onTick)
		end, 50)
	end

	OnExitVehicle(playerObj, seatFrom)
end
--#endregion

Events.OnGameStart.Add(OnGameStart)
Events.OnEnterVehicle.Add(OnEnterVehicle)