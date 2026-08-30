HIC = HIC or {}

setmetatable(HIC, { __index = _G })
setfenv(1, HIC)

require("HIC_VehiclePartData");
require("HIC_PlayerUtils");
require("HIC_VehiclePartData");
require("MF_ISMoodle");

MinimalCondition             = SandboxVars.HIC.MinimalCondition;
Active                       = SandboxVars.HIC.Active;
BaseRadius                   = SandboxVars.HIC.Radius;
CheckForTraits               = SandboxVars.HIC.CheckForTraits;
TraitCoefficient             = SandboxVars.HIC.TraitCoefficient;
MoodleActive                 = SandboxVars.HIC.MoodleActive;

UpdateTimer                  = 0;
LongUpdateTimer              = 0;
UpdateFrequencyInSeconds     = 1;
LongUpdateFrequencyInSeconds = 120;
InCar                        = false;
Ghosted                      = false;
CachedSeatID                 = 0;
CachedVehicle                = nil;
Radius                       = BaseRadius;

ConspicuousTraitId           = "Conspicuous";
InconspicuousTraitId         = "Inconspicuous";
MoodleId                     = "GhostedInCar";
MoodleOffValue               = 0.5;
MoodleOnValue                = 1;

MF.createMoodle(MoodleId);

HIC.OnPlayerUpdate = function(player)
	if Active == false then return; end
	if not player or not player:isLocalPlayer() then return; end
	local deltaTime = GetDeltaTime();
	if UpdateTimerPassed(deltaTime) then
		Update(player);
	end
	if LongUpdateTimerPassed(deltaTime) then
		LongUpdate(player)
	end
end

function GetDeltaTime()
	return getGameTime():getRealworldSecondsSinceLastUpdate();
end

function Update(player)
	if InCar then HandlePlayerGhostModeInCar(player); end
	if MoodleActive then
		UpdateMoodle();
	end
	--print("Ghost mode active - " .. tostring(player:isGhostMode()) .. "  - Ghosted -" .. tostring(Ghosted));
end

function UpdateMoodle()
	local value = MoodleOffValue;
	if InCar and Ghosted then
		value = MoodleOnValue;
	end
	MF.getMoodle(MoodleId):setValue(value)
end

function HandlePlayerGhostModeInCar(player)
	local vehicleValid = VehicleValidated(player)
	local playerDetected = AreZombiesDetectPlayer(player);
	if playerDetected or not vehicleValid then
		ExitGhostMode(player); return;
	end
	EnterGhostMode(player);
end

function VehicleValidated(player)
	if player == nil then
		return false;
	end

	local vehicle = GetCachedVehicle(player);
	if vehicle == nil then return false; end

	return IsVehicleValid(player, vehicle);
end

function LongUpdate(player)
	if not InCar and Ghosted then ExitGhostMode(player); end
	UpdateRadiusBasedOnTraits(player);
end

function UpdateRadiusBasedOnTraits(player)
	if not CheckForTraits then return; end
	if player:HasTrait(ConspicuousTraitId) then
		Radius = BaseRadius + GetConvertedTraitCoefficient();
	elseif player:HasTrait(InconspicuousTraitId) then
		Radius = BaseRadius - GetConvertedTraitCoefficient();
	else
		Radius = BaseRadius;
	end
end

function GetConvertedTraitCoefficient()
	return math.floor(BaseRadius * (TraitCoefficient / 100));
end

function GetCachedVehicle(player)
	local vehicle = CachedVehicle;
	if vehicle == nil then vehicle = player:getVehicle(); end
	CachedVehicle = vehicle;
	return vehicle;
end

function UpdateTimerPassed(deltaTime)
	UpdateTimer = UpdateTimer + deltaTime;
	if UpdateTimer > UpdateFrequencyInSeconds then
		UpdateTimer = 0;
		return true
	end
	return false
end

function LongUpdateTimerPassed(deltaTime)
	LongUpdateTimer = LongUpdateTimer + deltaTime;
	if LongUpdateTimer > LongUpdateFrequencyInSeconds then
		LongUpdateTimer = 0;
		return true
	end
	return false
end

function OnPlayerChased(player)
	ExitGhostMode(player)
end

function OnVehicleEntered(player)
	if not player:isLocalPlayer() then return end;
	if InCar then return end;
	InCar = true;
	CachedVehicle = player:getVehicle();
end

function OnVehicleExit(player)
	if not player:isLocalPlayer() then return end;
	if not InCar then return end;
	InCar = false;
	ExitGhostMode(player);
	CachedVehicle = nil;
end

function OnGameStart()
	MinimalCondition = SandboxVars.HIC.MinimalCondition;
	Active           = SandboxVars.HIC.Active;
	BaseRadius       = SandboxVars.HIC.Radius;
	CheckForTraits   = SandboxVars.HIC.CheckForTraits;
	TraitCoefficient = SandboxVars.HIC.TraitCoefficient;
	MoodleActive     = SandboxVars.HIC.MoodleActive;
end

function OnDisconnect()
	Events.OnPlayerUpdate.Remove(HIC.OnPlayerUpdate);
	Events.OnEnterVehicle.Remove(HIC.OnVehicleEntered);
	Events.OnExitVehicle.Remove(HIC.OnVehicleExit);
end

Events.OnGameStart.Add(HIC.OnGameStart)
Events.OnPlayerUpdate.Add(HIC.OnPlayerUpdate);
Events.OnEnterVehicle.Add(HIC.OnVehicleEntered);
Events.OnExitVehicle.Add(HIC.OnVehicleExit);
Events.OnDisconnect.Add(HIC.OnDisconnect)