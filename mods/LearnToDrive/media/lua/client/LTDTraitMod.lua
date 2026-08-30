LTD = {};

LTD.initXP = function(player)

	local baseDriveTick      = 240; -- default number of ticks to lose trait (in ten minute intervals)
	local varDriveTick       = 240; -- upper limit of random additional required ticks to lose trait (in ten minute intervals)
	local baseDriveTickNight =  60; -- number of ticks at night to lose trait (in ten minute intervals)
	local varDriveTickNight  =  60; -- upper limit of random additional required ticks to lose trait (in ten minute intervals)

	local playerTraits = player:getTraits();
	local nTraits      = playerTraits:size();
	local lastTrait    = playerTraits:get(nTraits-1);

	local defaultDriveTick      = 0;
	local defaultDriveTickNight = 0;
	if lastTrait ~= "SundayDriver" then -- logic to fix players affected by never having Sunday Driver but gaining it at night
		defaultDriveTick      = baseDriveTick + ZombRand(varDriveTick);
		defaultDriveTickNight = baseDriveTickNight + ZombRand(varDriveTickNight);	
	end

	local playerData = player:getModData();
	if player:HasTrait("FastLearner") then
		playerData.driveTick      = math.floor(defaultDriveTick/2.3);
		playerData.driveTickNight = math.floor(defaultDriveTickNight/2.3);
	elseif player:HasTrait("SlowLearner") then
		playerData.driveTick      = math.floor(defaultDriveTick/.7);
		playerData.driveTickNight = math.floor(defaultDriveTickNight/.7);
	else
		playerData.driveTick      = defaultDriveTick;
		playerData.driveTickNight = defaultDriveTickNight;
	end
	
	if player:HasTrait("SundayDriver") then
		playerData.hadSundayDriver = 1;
	else
		playerData.hadSundayDriver = 0;
	end
	player:transmitModData();
end

LTD.GainDrivingXP = function(player, vehicle, args)
	local player = getPlayer();
	local playerData = player:getModData();
	if playerData.driveTick == nil or playerData.driveTickNight == nil or playerData.hadSundayDriver == nil then
		LTD.initXP(player)
	end
	
	local nightValue = GameTime:getInstance():getNight();
	if player:isDriving() and player:HasTrait("SundayDriver") then
		playerData.driveTick = math.max(playerData.driveTick - 1,0);
		if nightValue > .5 then
			playerData.driveTickNight = math.max(playerData.driveTickNight - 1,0);
		end
		player:transmitModData();
	end
end

LTD.CheckDrivingXP = function(player, vehicle, args)
	local player = getPlayer();
	local playerData = player:getModData();
	if playerData.driveTick == nil or playerData.driveTickNight == nil or playerData.hadSundayDriver == nil then
		LTD.initXP(player)
	end
	
	local nightValue = GameTime:getInstance():getNight();
	if player:HasTrait("SundayDriver") then
		if playerData.driveTick < .01 and playerData.driveTickNight < .01 then
			player:getTraits():remove("SundayDriver");
		elseif playerData.driveTick < .01 and nightValue < .5 then
			player:getTraits():remove("SundayDriver");
		end
	elseif not player:HasTrait("SundayDriver") and nightValue > .5 and playerData.hadSundayDriver == 1 then
		if playerData.driveTickNight > .01 then
			player:getTraits():add("SundayDriver");
		end
	end
	
	if playerData.driveTick < .01 and playerData.driveTickNight < .01 then
		Events.EveryTenMinutes.Remove(LTD.GainDrivingXP);
		Events.EveryHours.Remove(LTD.CheckDrivingXP);
	end
end

Events.EveryTenMinutes.Add(LTD.GainDrivingXP);
Events.EveryHours.Add(LTD.CheckDrivingXP);