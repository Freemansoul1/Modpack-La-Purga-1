--***********************************************************
--**                       BitBraven                       **
--***********************************************************

local headlight
local climateManager

local onGameStart = function()
	climateManager = getClimateManager()
end

local OnEnterVehicle = function(playerObj)
	local vehicle = playerObj:getVehicle()
	if not vehicle then return end

	if BravensBikeUtils.isBike(vehicle) then

		--We keep track of the presence of a headlight at all times
		if (not headlight) then

			local headlightPart = vehicle:getPartById("Headlight")
			if not headlightPart:getInventoryItem() then return end
			headlight = headlightPart
		end
	end
end

local everyOneMinute = function()
	local playerObj = getPlayer(); if not playerObj then return end
	local vehicle = playerObj:getVehicle()

	if not vehicle then

		if headlight then

			vehicle = headlight:getVehicle()

			if vehicle then
				vehicle:setHeadlightsOn(false)
			end

			headlight = nil
		end

		return
	elseif BravensBikeUtils.isBike(vehicle) then

		if (vehicle:getCurrentSpeedKmHour() > 1 or vehicle:getCurrentSpeedKmHour() < -1) then
			-- Power the dynamo headlight
			if headlight and climateManager:getNightStrength() >= 0.5 and vehicle:getHeadlightsOn() == false then
				vehicle:setHeadlightsOn(true)
			end
		else
			--Turn off the dynamo headlight
			if vehicle:getHeadlightsOn() == true then
				vehicle:setHeadlightsOn(false)
			end
		end
	end
end

Events.OnClientCommand.Add(OnClientCommand)
Events.OnEnterVehicle.Add(OnEnterVehicle)
Events.EveryOneMinute.Add(everyOneMinute)
Events.OnGameStart.Add(onGameStart)