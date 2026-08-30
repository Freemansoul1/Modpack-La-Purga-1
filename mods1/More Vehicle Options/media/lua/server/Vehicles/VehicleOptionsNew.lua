require "Vehicle/Vehicles"

local CreateBattery = Vehicles.Create.Battery
local CreateGasTank = Vehicles.Create.GasTank
local CreateEngine = Vehicles.Create.Engine
local CreateHeadlight = Vehicles.Create.Headlight
local CreateBrake = Vehicles.Create.Brake
local CreateDoor = Vehicles.Create.Door
local CreateTrunkDoor = Vehicles.Create.TrunkDoor
local CreateRadio = Vehicles.Create.Radio
local CreateRadioHAM = Vehicles.Create.Radio_HAM
local CreateDefault = Vehicles.Create.Default
local CreateTire = Vehicles.Create.Tire
local CreateWindow = Vehicles.Create.Window
local InitDoor = Vehicles.Init.Door
local InitWindow = Vehicles.Init.Window
local InitTire = Vehicles.Init.Tire

local incomplete = false
local incomplete_setted = false
local doors = 0
local windows = 0
local door_list = {"DoorFrontLeft", "DoorFrontRight", "DoorMiddleLeft", "DoorMiddleRight", "DoorRearLeft", "DoorRearRight"}
local window_list = {"WindowFrontLeft", "WindowFrontRight", "WindowMiddleLeft", "WindowMiddleRight", "WindowRearLeft", "WindowRearRight"}
local tire_list = {"TireFrontLeft", "TireFrontRight", "TireRearLeft", "TireRearRight"}
local susp_list = {"SuspensionFrontLeft", "SuspensionFrontRight", "SuspensionRearLeft", "SuspensionRearRight"}
local brake_list = {"BrakeFrontLeft", "BrakeFrontRight", "BrakeRearLeft", "BrakeRearRight"}
local condition_destroyed = false
local destroyed_setted = false
local no_trunkdoor = false

local missingparts_prob = 0 -- IF = 1, THEN CHANCE IS RANDOM
local destroyed_prob = 0
local incomplete_prob = 0
local probs_setted = false
local suspension_brakes = 0 -- UP TO 2          ???????????????????
local tires_checked = 0
local rand_chance_setted = false -- SI MISSING PARTS PROB ESTÁ EN RANDOM, CADA VEHÍCULO TIENE MISSING PARTS CHANCE DIFERENTE

function ReduceCondition(v, p, val) -- val = 0 or 1
	if p and (condition_destroyed or val == 1) then
		p:setCondition(math.min(ZombRand(10, 40), p:getCondition()))
		if p:getId() == "TruckBed" or p:getId() == "TrailerTrunk" then
			p:doInventoryItemStats(p:getInventoryItem(), p:getMechanicSkillInstaller())
			v:transmitPartCondition(p)
		end
	end
end

function GetWindow(part)
	for i, k in ipairs(door_list) do
		if part:getId() == k then
			return window_list[i]
		end
	end
	return
end

function GetDoor(part)
	for i, k in ipairs(window_list) do
		if part:getId() == k then
			return door_list[i]
		end
	end
	return
end

function CheckTires(vehicle, list)
	for i, k in ipairs(list) do
		local part = vehicle:getPartById(k)
		if part then
			if not vehicle:getPartById(k):getInventoryItem() then
				vehicle:getPartById(tire_list[i]):setInventoryItem(nil)
			end
		end
	end
	tires_checked = tires_checked + 1
end

function IsConditionExtremelyLow()
	if ZombRand(destroyed_prob) == 0 then
		return true
	end
	return false
end

function SetDestroyed()
	if not destroyed_setted and SandboxVars.VehicleConditionExtremelyLow > 1 then
		condition_destroyed = IsConditionExtremelyLow()
		destroyed_setted = true
		--print("DESTRUIDO?", condition_destroyed)
	end
end

function IsIncomplete()
	if ZombRand(incomplete_prob) == 0 then
		return true
	end
	return false
end

-- NUEVO ------------------------------------------------------------------------------------------------------------------------------

function SetDestroyedProb()
	local arr = {7, 5, 2, 0}
	if SandboxVars.VehicleConditionExtremelyLow > 1 then
		destroyed_prob = arr[SandboxVars.VehicleConditionExtremelyLow - 1]
	end
end

function SetIncomplete()
	if not probs_setted and SandboxVars.VehicleMayBeIncomplete then
		SetIncompleteProb()
		SetPartsMissingProb()
		if IsBetween(SandboxVars.VehicleConditionExtremelyLow, 1, 6) then
			SetDestroyedProb()
		end
		probs_setted = true
	end
	if not incomplete_setted and SandboxVars.VehicleMayBeIncomplete then
		if SandboxVars.VehicleMissingPartsQuantity == 4 then
			missingparts_prob = ZombRand(9) + 1
			print("MISSING PARTS PROB", missingparts_prob)
		end
		incomplete = IsIncomplete()
		incomplete_setted = true
		tires_checked = 0
		suspension_brakes = 0
		-- print("INCOMPLETO:", incomplete)
		-- print("MIS PARTS PROB", missingparts_prob)
	end
end

function IsBetween(v, minn, maxx)
	if v > minn and v < maxx then
		return true
	end
	return false
end

function SetPartsMissingProb()
	local arr = {8, 6, 3} -- CHANCES FOR DIFFERENT VehicleMissingPartsQuantity VALUES
	if SandboxVars.VehicleMissingPartsQuantity < 4 then
		missingparts_prob = arr[SandboxVars.VehicleMissingPartsQuantity]
	end
end

function PartsMissing(value)
	if IsBetween(value, -1, 9) and ZombRand(value) == 0 then
		return true
	end
	return false
end

function SetIncompleteProb()
	local arr = {10, 5, 2, 0} -- CHANCES FOR DIFERRENT VehicleIncompleteProb VALUES
	incomplete_prob = arr[SandboxVars.VehicleIncompleteProb]
end

function Vehicles.Create.Battery(vehicle, part)
	SetIncomplete()
	SetDestroyed()
	if incomplete and PartsMissing(missingparts_prob) then
		return false
	end
	CreateBattery(vehicle, part)
	local item = VehicleUtils.createPartInventoryItem(part)
	if (SandboxVars.TimeSinceApo == 13) and (not vehicle:isGoodCar()) and (SandboxVars.VehicleBatteryChance > 1) then
		local arr = {30, 20, 12, 6, 3}
		if ZombRand(arr[SandboxVars.VehicleBatteryChance - 1]) == 0 then
			item:setUsedDelta(ZombRandFloat(0.15, 0,5))
		end
	end
	ReduceCondition(vehicle, part, 0)
end

-- NUEVO ------------------------------------------------------------------------------------------------------------------------------

function Vehicles.Create.GasTank(vehicle, part)
	--print(part:getId())
	SetIncomplete()
	SetDestroyed()
	if incomplete and PartsMissing(missingparts_prob) then
		return false
	end
	CreateGasTank(vehicle, part)
	ReduceCondition(vehicle, part, 0)
	if SandboxVars.VehicleRandomGasAmount and part:getContainerContentAmount() > 0 and not vehicle:isGoodCar() then
		local gas_prob = ZombRand(15)
		local new_amount = 0
		if gas_prob < 9 then
			local maxGas = ZombRand(2, part:getContainerCapacity()/5)
			new_amount = ZombRand(1, maxGas)
		else
			if gas_prob < 13 then
				new_amount = ZombRand(part:getContainerCapacity()/4, part:getContainerCapacity()/3)
			else
				new_amount = ZombRand(part:getContainerCapacity()/3, part:getContainerCapacity()/2)
			end
		end
		local new_amount = ZombRand(1, part:getContainerCapacity()/4)
		part:setContainerContentAmount(new_amount)
	end
end

function Vehicles.Create.Engine(vehicle, part)
	--print(part:getId())
	SetIncomplete()
	SetDestroyed()
	CreateEngine(vehicle, part)
	if incomplete and PartsMissing(missingparts_prob) then
		--print("FALTA MOTOR")
		ReduceCondition(vehicle, part, 1)
		-- part:setCondition(0)
		return
	end
	ReduceCondition(vehicle, part, 0)
end

function Vehicles.Create.Headlight(vehicle, part)
	--print(part:getId())
	SetIncomplete()
	SetDestroyed()
	CreateHeadlight(vehicle, part)
	if incomplete and PartsMissing(missingparts_prob) then
		part:setInventoryItem(nil)
	end
	ReduceCondition(vehicle, part, 0)
end

function Vehicles.Create.Brake(vehicle, part)
	--print(part:getId())
	SetIncomplete()
	SetDestroyed()
	if incomplete and PartsMissing(missingparts_prob) then
		return false
	end
	CreateBrake(vehicle, part)
	ReduceCondition(vehicle, part, 0)
end

function Vehicles.Create.TrunkDoor(vehicle, part)
	--condition_destroyed = SandboxVars.VehicleConditionExtremelyLow == 1
	SetIncomplete()
	SetDestroyed()
	CreateTrunkDoor(vehicle, part)
	ReduceCondition(vehicle, part, 0)
	if incomplete and PartsMissing(missingparts_prob) then
		--print("FALTA TAPA MALETERO")
		no_trunkdoor = true
		vehicle:getPartById("WindshieldRear"):setInventoryItem(nil)
		part:setInventoryItem(nil)
	end
end


function Vehicles.Create.Radio(vehicle, part)
	--print(part:getId())
	SetIncomplete()
	SetDestroyed()
	CreateRadio(vehicle, part)
	if incomplete and PartsMissing(missingparts_prob) then
		part:setInventoryItem(nil)
	end
	ReduceCondition(vehicle, part, 0)
end

function Vehicles.Create.Radio_HAM(vehicle, part)
	--print(part:getId())
	SetIncomplete()
	SetDestroyed()
	CreateRadioHAM(vehicle, part)
	if incomplete and PartsMissing(missingparts_prob) then
		part:setInventoryItem(nil)
	end
	ReduceCondition(vehicle, part, 0)
end

function Vehicles.Create.Default(vehicle, part)
	--print(part:getId())
	SetIncomplete()
	SetDestroyed()
	--[[if getActivatedMods():contains("SCKCO") and part:getId() == "SeatFrontLeft" then
		condition_destroyed = IsConditionExtremelyLow()
		incomplete = IsIncomplete()
	end]]
	if part:getId() == "WindshieldRear" and no_trunkdoor then
		return false
	end
	if incomplete and PartsMissing(missingparts_prob) and (part:getId() ~= "TruckBed" and part:getId() ~= "GloveBox") then
		return false
	end
	CreateDefault(vehicle, part)
	ReduceCondition(vehicle, part, 0)
	if (part:getId() == "TruckBed" or part:getId() == "GloveBox") and incomplete and PartsMissing(missingparts_prob) then
		--print(part:getId(), "MAL ESTADO")
		part:setCondition(ZombRand(3, 15))
		part:doInventoryItemStats(part:getInventoryItem(), part:getMechanicSkillInstaller())
		vehicle:transmitPartCondition(part)
	end
end

function Vehicles.Create.Tire(vehicle, part)
	--print(part:getId())
	SetIncomplete()
	SetDestroyed()
	-- if incomplete and PartsMissing(SandboxVars.VehicleMissingPartsQuantity) then
	-- 	return false
	-- end
	CreateTire(vehicle, part)
	ReduceCondition(vehicle, part, 0)
end

function Vehicles.Create.Door(vehicle, part)
	--print(part:getId())
	SetIncomplete()
	SetDestroyed()
	doors = doors + 1
	if incomplete and PartsMissing(missingparts_prob) then
		if windows> 0 then
			local current_window = GetWindow(part)
			if vehicle:getPartById(current_window) and vehicle:getPartById(current_window):getInventoryItem() ~= nil then
				vehicle:getPartById(current_window):setInventoryItem(nil)
			end
		end
		return false
	end
	CreateDoor(vehicle, part)
	ReduceCondition(vehicle, part, 0)
end

function Vehicles.Create.Window(vehicle, part)
	--print(part:getId())
	SetIncomplete()
	SetDestroyed()
	windows= windows+ 1
	local current_door = ""
	current_door = GetDoor(part)
	--if vehicle:getPartById(current_door) then
	if current_door ~= "" then
		if vehicle:getPartById(current_door) ~= nil then
			if doors > 0 and vehicle:getPartById(current_door):getInventoryItem() == nil then
				return false
			end
		end
	end
	if incomplete and PartsMissing(missingparts_prob) then
		return false
	end
	CreateWindow(vehicle, part)
	ReduceCondition(vehicle, part, 0)
	CheckTires(vehicle, susp_list)
	CheckTires(vehicle, brake_list)
end
	
function Vehicles.Init.Window(vehicle, part)
	if incomplete and PartsMissing(missingparts_prob) then
		ReduceCondition(vehicle, vehicle:getHeater(), 1)
	end
	ReduceCondition(vehicle, vehicle:getPartById("lightbar"), 0)
	ReduceCondition(vehicle, vehicle:getHeater(), 0)
	windows = 0
	incomplete_setted = false
	destroyed_setted = false
	despawn_setted = false
	vehicle_despawned = false
	InitWindow(vehicle, part)
	CheckTires(vehicle, susp_list)
	CheckTires(vehicle, brake_list)
end

function Vehicles.Init.Door(vehicle, part)
	doors = 0
	no_trunkdoor = false
	InitDoor(vehicle, part)
end

function Vehicles.Init.Tire(vehicle, part)
	--print(part:getId())
	--print(vehicle:getVehicleType())
	CheckTires(vehicle, susp_list)
	CheckTires(vehicle, brake_list)
	InitTire(vehicle, part)
end