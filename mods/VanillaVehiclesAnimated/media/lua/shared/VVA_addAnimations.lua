---Like DoParam but for vehicles
---@param vehicle string Name of the vehicle script
---@param param string The parameter(s) to apply to this script
---@param module string Optional: the module of the vehicle
---@see Item#DoParam
---@see VehicleScript#Load
local DoVehicleParam = function(vehicle, param, module)
	module = module or "Base"
	local vehicleScript = ScriptManager.instance:getVehicle(module .. "." .. vehicle)
	if not vehicleScript then return end
	vehicleScript:Load(vehicle, "{" .. param .. "}")
end


---Utility to change the armor of a vehicle
---@param vehicle string Name of the vehicle script
---@param armor string Name of a armor template
---@param doors string Name of a armor template
---@param trunk string Name of a armor template
---@param seat string Name of a armor template
---@param baseModel string Name of a model
---@see DoVehicleParam
local showSeatAnimation = not getActivatedMods():contains("VVA_cullseats1")
local SetAnimationsAdvanced = function(vehicle, armor, doors, trunk, seat, baseModel, module) 
	module = module or "Base"
	DoVehicleParam(vehicle, "template! = " .. armor .. ",", module)
	DoVehicleParam(vehicle, "template! = " .. doors .. ",", module)
	DoVehicleParam(vehicle, "template! = " .. trunk .. ",", module)
	if showSeatAnimation then
		DoVehicleParam(vehicle, "template! = " .. seat .. ",", module)
	end
	if baseModel then
		DoVehicleParam(vehicle, "model { file = " .. baseModel .. ",}", module)
	end
end


local vehicleLayouts = {}
vehicleLayouts["VVA_Vehicles_VanSeats_a"] = {
	exterior = "VVA_VanSeats_animatedDoors",
	doors = "VVA_VanSeatsDoors",
	rear = "VVA_RearDoorVersion",
	seats = "VVA_SixSeats",
}

vehicleLayouts["VVA_Vehicles_LuxuryCar_a"] = {
	exterior = "VVA_LuxuryCar_animatedDoors",
	doors = "VVA_TwoDoor",
	rear = "VVA_TrunkDoorVersion",
	seats = "VVA_TwoSeats",
}

vehicleLayouts["VVA_Vehicles_Van_a"] = {
	exterior = "VVA_Van_animatedDoors",
	doors = "VVA_TwoDoor",
	rear = "VVA_RearDoorVersion",
	seats = "VVA_TwoSeats",
}
vehicleLayouts["VVA_Vehicles_Van_NoRandom_a"] = vehicleLayouts["VVA_Vehicles_Van_a"]
vehicleLayouts["VVA_Vehicles_Ambulance_a"] = vehicleLayouts["VVA_Vehicles_Van_a"]
vehicleLayouts["VVA_Vehicles_VanRadio_a"] = vehicleLayouts["VVA_Vehicles_Van_a"]

vehicleLayouts["VVA_Vehicles_ModernCar_a"] = {
	exterior = "VVA_ModernCar_animatedDoors",
	doors = "VVA_FourDoor",
	rear = "VVA_TrunkDoorVersion",
	seats = "VVA_FourSeats",
}
vehicleLayouts["VVA_Vehicles_ModernCar02_a"] = {
	exterior = "VVA_ModernCar02_animatedDoors",
	doors = "VVA_FourDoor",
	rear = "VVA_TrunkDoorVersion",
	seats = "VVA_FourSeats",
}
vehicleLayouts["VVA_Vehicles_CarNormal_a"] = {
	exterior = "VVA_CarNormal_animatedDoors",
	doors = "VVA_FourDoor",
	rear = "VVA_TrunkDoorVersion",
	seats = "VVA_FourSeats",
}
vehicleLayouts["VVA_Vehicles_CarLights_a"] = vehicleLayouts["VVA_Vehicles_CarNormal_a"]
vehicleLayouts["VVA_Vehicles_CarTaxi_a"] = vehicleLayouts["VVA_Vehicles_CarNormal_a"]
vehicleLayouts["VVA_Vehicles_CarLights_NoRandom_a"] = vehicleLayouts["VVA_Vehicles_CarNormal_a"]

vehicleLayouts["VVA_Vehicles_OffRoad_a"] = {
	exterior = "VVA_OffRoad_animatedDoors",
	doors = "VVA_TwoDoor",
	rear = "VVA_TrunkDoorVersion",
	seats = "VVA_TwoSeats",
}

vehicleLayouts["VVA_Vehicles_PickUpTruck_a"] = {
	exterior = "VVA_PickUpTruck_animatedDoors",
	doors = "VVA_TwoDoor",
	rear = "VVA_OpenBedVersion",
	seats = "VVA_TwoSeats",
}
vehicleLayouts["VVA_Vehicles_PickUpTruck_NoRandom_a"] = vehicleLayouts["VVA_Vehicles_PickUpTruck_a"]
vehicleLayouts["VVA_Vehicles_PickUpTruckLights_a"] = vehicleLayouts["VVA_Vehicles_PickUpTruck_a"]
vehicleLayouts["VVA_Vehicles_PickUpTruckLights_NoRandom_a"] = vehicleLayouts["VVA_Vehicles_PickUpTruck_a"]

vehicleLayouts["VVA_Vehicles_PickUpVan_a"] = {
	exterior = "VVA_PickUpVan_animatedDoors",
	doors = "VVA_TwoDoor",
	rear = "VVA_TrunkDoorVersion",
	seats = "VVA_TwoSeats",
}
vehicleLayouts["VVA_Vehicles_PickUpVan_NoRandom_a"] = vehicleLayouts["VVA_Vehicles_PickUpVan_a"]
vehicleLayouts["VVA_Vehicles_PickUpVanLights_a"] = vehicleLayouts["VVA_Vehicles_PickUpVan_a"]
vehicleLayouts["VVA_Vehicles_PickUpVanLights_NoRandom_a"] = vehicleLayouts["VVA_Vehicles_PickUpVan_a"]

vehicleLayouts["VVA_Vehicles_SmallCar_a"] = {
	exterior = "VVA_SmallCar_animatedDoors",
	doors = "VVA_TwoDoor",
	rear = "VVA_TrunkDoorVersion",
	seats = "VVA_FourSeats",
}
vehicleLayouts["VVA_Vehicles_SmallCar02_a"] = {
	exterior = "VVA_SmallCar02_animatedDoors",
	doors = "VVA_TwoDoor",
	rear = "VVA_TrunkDoorVersion",
	seats = "VVA_FourSeats",
}
vehicleLayouts["VVA_Vehicles_SportsCar_a"] = {
	exterior = "VVA_SportsCar_animatedDoors",
	doors = "VVA_TwoDoor",
	rear = "VVA_TrunkDoorVersion",
	seats = "VVA_CullSeats",
}

vehicleLayouts["VVA_Vehicle_StepVan_a"] = {
	exterior = "VVA_StepVan_animatedDoors",
	doors = "VVA_TwoDoor",
	rear = "VVA_RearDoorVersion",
	seats = "VVA_TwoSeats",
}
vehicleLayouts["VVA_Vehicle_StepVan_NoRandom_a"] = vehicleLayouts["VVA_Vehicle_StepVan_a"]

vehicleLayouts["VVA_Vehicles_SUV_a"] = {
	exterior = "VVA_SUV_animatedDoors",
	doors = "VVA_FourDoor",
	rear = "VVA_TrunkDoorVersion",
	seats = "VVA_FourSeats",
}
vehicleLayouts["VVA_Vehicles_CarStationWagon_a"] = {
	exterior = "VVA_CarStationWagon_animatedDoors",
	doors = "VVA_FourDoor",
	rear = "VVA_TrunkDoorVersion",
	seats = "VVA_FourSeats",
}
vehicleLayouts["VVA_Vehicles_CarTaxiArg_a"] = {
	exterior = "VVA_CarTaxiArg_animatedDoors",
	doors = "VVA_FourDoor",
	rear = "VVA_TrunkDoorVersion",
	seats = "VVA_FourSeats",
}
vehicleLayouts["VVA_Vehicle_87gmcarmored_a"] = {
	exterior = "VVA_87gmcarmored_animatedDoors",
	doors = "VVA_TwoDoor",
	rear = "VVA_TrunkDoorVersion",
	seats = "VVA_TwoSeats",
}

local SetAnimationsConfig = function (vehicle, baseModel, module)
	module = module or "Base"
	local info = vehicleLayouts[baseModel]
	if info then
		SetAnimationsAdvanced(vehicle, info.exterior, info.doors, info.rear, info.seats, baseModel, module)
	end
end

if getActivatedMods():contains("VVehicleEnhancer1") then
	
	vehicleLayouts["VVA_Vehicles_CarNormal_vve_a"] = {
		exterior = "VVA_CarNormal_vve_animatedDoors",
		doors = "VVA_FourDoor",
		rear = "VVA_TrunkDoorVersion",
		seats = "VVA_FourSeats",
	}
	vehicleLayouts["VVA_Vehicles_CarLights_vve_a"] = vehicleLayouts["VVA_Vehicles_CarNormal_vve_a"]
	vehicleLayouts["VVA_Vehicles_CarTaxi_vve_a"] = vehicleLayouts["VVA_Vehicles_CarNormal_vve_a"]
	vehicleLayouts["VVA_Vehicles_CarLights_vve_NoRandom_a"] = vehicleLayouts["VVA_Vehicles_CarNormal_vve_a"]
	vehicleLayouts["VVA_Vehicles_SmallCar_vve_a"] = {
		exterior = "VVA_SmallCar_vve_animatedDoors",
		doors = "VVA_TwoDoor",
		rear = "VVA_TrunkDoorVersion",
		seats = "VVA_FourSeats",
	}
	vehicleLayouts["VVA_Vehicles_SmallCar02_vve_a"] = {
		exterior = "VVA_SmallCar02_vve_animatedDoors",
		doors = "VVA_TwoDoor",
		rear = "VVA_TrunkDoorVersion",
		seats = "VVA_FourSeats",
	}
	vehicleLayouts["VVA_Vehicles_PickUpVan_vve_a"] = {
		exterior = "VVA_PickUpVan_vve_animatedDoors",
		doors = "VVA_VanSeatsDoors",
		rear = "VVA_TrunkDoorVersion",
		seats = "VVA_SixSeats",
	}
	vehicleLayouts["VVA_Vehicles_PickUpVanLights_Fire_vve_NoRandom_a"] = vehicleLayouts["VVA_Vehicles_PickUpVan_vve_a"]

	vehicleLayouts["VVA_Vehicles_PickUpVanLights_Police_vve_NoRandom_a"] = {
		exterior = "VVA_PickUpVan_Police_vve_animatedDoors",
		doors = "VVA_FourDoor",
		rear = "VVA_TrunkDoorVersion",
		seats = "VVA_FourSeats",
	}
	vehicleLayouts["VVA_Vehicles_PickUpVanLights_vve_NoRandom_a"] = {
		exterior = "VVA_PickUpVanLights_vve_animatedDoors",
		doors = "VVA_TwoDoor",
		rear = "VVA_TrunkDoorVersion",
		seats = "VVA_TwoSeats",
	}
	vehicleLayouts["VVA_Vehicles_PickUpVanMcCoy_vve_NoRandom_a"] = vehicleLayouts["VVA_Vehicles_PickUpVanLights_vve_NoRandom_a"]
	vehicleLayouts["VVA_Vehicles_PickUpVanf76_vve_NoRandom_a"] = {
		exterior = "VVA_PickUpVanf76_vve_animatedDoors",
		doors = "VVA_TwoDoor",
		rear = "VVA_TrunkDoorVersion",
		seats = "VVA_TwoSeats",
	}
	vehicleLayouts["VVA_Vehicles_VanSeats_vve_a"] = {
		exterior = "VVA_VanSeats_vve_animatedDoors",
		doors = "VVA_ThreeDoor",
		rear = "VVA_RearDoorVersion",
		seats = "VVA_SixSeats",
	}
	vehicleLayouts["VVA_Vehicles_PickUpTruck_vve_a"] = {
		exterior = "VVA_PickUpTruck_vve_animatedDoors",
		doors = "VVA_TwoDoor",
		rear = "VVA_OpenBedVersion",
		seats = "VVA_TwoSeats",
	}
	vehicleLayouts["VVA_Vehicles_PickUpTruck_vve_NoRandom_a"] = vehicleLayouts["VVA_Vehicles_PickUpTruck_vve_a"]
	vehicleLayouts["VVA_Vehicles_PickUpTruckLights_vve_a"] = vehicleLayouts["VVA_Vehicles_PickUpTruck_vve_a"]
	vehicleLayouts["VVA_Vehicles_PickUpTruckLights_vve_NoRandom_a"] = vehicleLayouts["VVA_Vehicles_PickUpTruck_vve_a"]
	vehicleLayouts["VVA_Vehicles_73cayenne_vve_a"] = {
		exterior = "VVA_73cayenne_vve_animatedDoors",
		doors = "VVA_TwoDoor",
		rear = "VVA_OpenBedVersion",
		seats = "VVA_TwoSeats",
	}
	vehicleLayouts["VVA_Vehicles_PickUpTruckf76_vve_a"] = {
		exterior = "VVA_PickUpTruckf76_vve_animatedDoors",
		doors = "VVA_TwoDoor",
		rear = "VVA_OpenBedVersion",
		seats = "VVA_TwoSeats",
	}
	vehicleLayouts["VVA_Vehicles_CarStationWagon_vve_a"] = {
		exterior = "VVA_CarStationWagon_vve_animatedDoors",
		doors = "VVA_FourDoor",
		rear = "VVA_TrunkDoorVersion",
		seats = "VVA_FourSeats",
	}
	vehicleLayouts["VVA_Vehicles_CarStationWagonOld_vve_a"] = {
		exterior = "VVA_CarStationWagonOld_vve_animatedDoors",
		doors = "VVA_FourDoor",
		rear = "VVA_TrunkDoorVersion",
		seats = "VVA_FourSeats",
	}
	vehicleLayouts["VVA_Vehicles_Van_vve_a"] = {
		exterior = "VVA_Van_vve_animatedDoors",
		doors = "VVA_TwoDoor",
		rear = "VVA_RearDoorVersion",
		seats = "VVA_TwoSeats",
	}
	vehicleLayouts["VVA_Vehicles_Van_vve_NoRandom_a"] = vehicleLayouts["VVA_Vehicles_Van_vve_a"]
	vehicleLayouts["VVA_Vehicles_Ambulance_vve_a"] = vehicleLayouts["VVA_Vehicles_Van_vve_a"]
	vehicleLayouts["VVA_Vehicles_VanRadio_vve_a"] = vehicleLayouts["VVA_Vehicles_Van_vve_a"]

	vehicleLayouts["VVA_Vehicles_ModernCar_vve_a"] = {
		exterior = "VVA_ModernCar_vve_animatedDoors",
		doors = "VVA_FourDoor",
		rear = "VVA_TrunkDoorVersion",
		seats = "VVA_FourSeats",
	}
	vehicleLayouts["VVA_Vehicles_ModernCar02_vve_a"] = {
		exterior = "VVA_ModernCar02_vve_animatedDoors",
		doors = "VVA_FourDoor",
		rear = "VVA_TrunkDoorVersion",
		seats = "VVA_FourSeats",
	}
	vehicleLayouts["VVA_Vehicles_LuxuryCar_vve_a"] = {
		exterior = "VVA_LuxuryCar_vve_animatedDoors",
		doors = "VVA_TwoDoor",
		rear = "VVA_TrunkDoorVersion",
		seats = "VVA_TwoSeats",
	}
	vehicleLayouts["VVA_Vehicles_SUV_vve_a"] = {
		exterior = "VVA_SUV_vve_animatedDoors",
		doors = "VVA_FourDoor",
		rear = "VVA_TrunkDoorVersion",
		seats = "VVA_FourSeats",
	}
	vehicleLayouts["VVA_Vehicles_OffRoad_vve_a"] = {
		exterior = "VVA_OffRoad_vve_animatedDoors",
		doors = "VVA_TwoDoor",
		rear = "VVA_TrunkDoorVersion",
		seats = "VVA_TwoSeats",
	}
	vehicleLayouts["VVA_Vehicles_SportsCar_vve_a"] = {
		exterior = "VVA_SportsCar_vve_animatedDoors",
		doors = "VVA_TwoDoor",
		rear = "VVA_TrunkDoorVersion",
		seats = "VVA_CullSeats",
	}
	vehicleLayouts["VVA_Vehicle_StepVan_vve_a"] = {
		exterior = "VVA_StepVan_vve_animatedDoors",
		doors = "VVA_TwoDoor",
		rear = "VVA_RearDoorVersion",
		seats = "VVA_TwoSeats",
	}
	vehicleLayouts["VVA_Vehicle_StepVan_vve_NoRandom_a"] = vehicleLayouts["VVA_Vehicle_StepVan_vve_a"]

	if not getActivatedMods():contains("Purga_VVSR_Continued") then
	
		SetAnimationsConfig("CarLights",		"VVA_Vehicles_CarLights_vve_a");			-- ok.
		SetAnimationsConfig("CarLightsPolice",		"VVA_Vehicles_CarLights_vve_NoRandom_a");		-- ok.
		SetAnimationsConfig("CarNormal",		"VVA_Vehicles_CarNormal_vve_a");			-- ok.
		SetAnimationsConfig("SmallCar",			"VVA_Vehicles_SmallCar_vve_a");				-- ok.
		SetAnimationsConfig("PickUpVanLights",		"VVA_Vehicles_PickUpVanLights_vve_NoRandom_a"); 	-- ok.
		SetAnimationsConfig("PickUpVanLightsPolice",	"VVA_Vehicles_PickUpVanLights_Police_vve_NoRandom_a"); 	-- ok.
		SetAnimationsConfig("PickUpVanLightsFire",	"VVA_Vehicles_PickUpVanLights_Fire_vve_NoRandom_a"); 	-- ok.
		SetAnimationsConfig("PickUpVan",		"VVA_Vehicles_PickUpVan_vve_a");			-- ok.
		SetAnimationsConfig("PickUpTruckLights",	"VVA_Vehicles_PickUpTruckLights_vve_a");		-- ok.
		SetAnimationsConfig("PickUpTruckLightsFire",	"VVA_Vehicles_PickUpTruckLights_vve_NoRandom_a");	-- ok.
		SetAnimationsConfig("PickUpTruck",		"VVA_Vehicles_PickUpTruck_vve_a");			-- ok.
		SetAnimationsConfig("VanAmbulance",		"VVA_Vehicles_Ambulance_vve_a");			-- ok.
	end

		SetAnimationsConfig("CarOldsFull",		"VVA_Vehicles_CarNormal_vve_a");			-- ok.
		SetAnimationsConfig("CarNormalPoncho",		"VVA_Vehicles_CarNormal_vve_a");			-- ok.
		SetAnimationsConfig("CarLightsStatepolice",	"VVA_Vehicles_CarLights_vve_NoRandom_a");		-- ok.
		SetAnimationsConfig("CarLightsSheriff",		"VVA_Vehicles_CarLights_vve_NoRandom_a");		-- ok.
		SetAnimationsConfig("CarLightsFireDept",	"VVA_Vehicles_CarLights_vve_NoRandom_a");		-- ok.
		SetAnimationsConfig("CarLightsFireDept2",	"VVA_Vehicles_CarLights_vve_NoRandom_a");		-- ok.
		SetAnimationsConfig("CarOldWagon",		"VVA_Vehicles_CarStationWagonOld_vve_a");		-- ok.
		SetAnimationsConfig("CarPonchoWagon",		"VVA_Vehicles_CarStationWagon_vve_a");			-- ok.
		SetAnimationsConfig("PickUpVanf76",		"VVA_Vehicles_PickUpVanf76_vve_NoRandom_a");		-- ok.
		SetAnimationsConfig("PickUpTruckf76",		"VVA_Vehicles_PickUpTruckf76_vve_a");			-- ok.
		SetAnimationsConfig("73cayenne",		"VVA_Vehicles_73cayenne_vve_a");			-- ok.
		SetAnimationsConfig("Vanateam",			"VVA_Vehicles_Van_vve_a");				-- ok.
		SetAnimationsConfig("Vanboogie",		"VVA_Vehicles_Van_vve_a");				-- ok.
		SetAnimationsConfig("Boltrs",			"VVA_Vehicles_SmallCar_vve_a");				-- ok.
		SetAnimationsConfig("SmallCarSwiffer",		"VVA_Vehicles_SmallCar02_vve_a");			-- ok.
		SetAnimationsConfig("280sport",			"VVA_Vehicles_ModernCar02_vve_a");			-- ok.
		SetAnimationsConfig("StepVanMailupz",		"VVA_Vehicle_StepVan_vve_NoRandom_a");			-- ok.
		
		SetAnimationsConfig("CarTaxi",			"VVA_Vehicles_CarTaxi_vve_a");				-- ok.
		SetAnimationsConfig("CarTaxi2",			"VVA_Vehicles_CarTaxi_vve_a");				-- ok.
		SetAnimationsConfig("CarStationWagon",		"VVA_Vehicles_CarStationWagon_vve_a");			-- ok.
		SetAnimationsConfig("CarStationWagon2",		"VVA_Vehicles_CarStationWagon_vve_a");			-- ok.
		SetAnimationsConfig("ModernCar",		"VVA_Vehicles_ModernCar_vve_a");			-- ok.
		SetAnimationsConfig("ModernCar02",		"VVA_Vehicles_ModernCar02_vve_a");			-- ok.
		SetAnimationsConfig("CarLuxury",		"VVA_Vehicles_LuxuryCar_vve_a");			-- ok.
		SetAnimationsConfig("SmallCar02",		"VVA_Vehicles_SmallCar02_vve_a");			-- ok.
		SetAnimationsConfig("SUV",			"VVA_Vehicles_SUV_vve_a");				-- ok.
		SetAnimationsConfig("OffRoad",			"VVA_Vehicles_OffRoad_vve_a");				-- ??
		SetAnimationsConfig("PickUpVanMccoy",		"VVA_Vehicles_PickUpVanMcCoy_vve_NoRandom_a");		-- ok.
		SetAnimationsConfig("PickUpTruckMccoy",		"VVA_Vehicles_PickUpTruck_vve_NoRandom_a");		-- ok.
		SetAnimationsConfig("StepVan",			"VVA_Vehicle_StepVan_vve_a");				-- ok.
		SetAnimationsConfig("StepVan_Heralds",		"VVA_Vehicle_StepVan_vve_a");				-- ok.
		SetAnimationsConfig("StepVanMail",		"VVA_Vehicle_StepVan_vve_NoRandom_a");			-- ok.
		SetAnimationsConfig("StepVan_Scarlet",		"VVA_Vehicle_StepVan_vve_a");				-- ok.
		SetAnimationsConfig("VanSeats",			"VVA_Vehicles_VanSeats_vve_a"); 			-- ok.
		SetAnimationsConfig("Van",			"VVA_Vehicles_Van_vve_a");				-- ok.
		SetAnimationsConfig("Van_KnoxDisti",		"VVA_Vehicles_Van_vve_a");				-- ok.
		SetAnimationsConfig("Van_Transit",		"VVA_Vehicles_Van_vve_a");				-- ok.
		SetAnimationsConfig("VanSpiffo",		"VVA_Vehicles_Van_vve_NoRandom_a");			-- ok.
		SetAnimationsConfig("VanSpecial",		"VVA_Vehicles_Van_vve_NoRandom_a");			-- ok.
		SetAnimationsConfig("Van_MassGenFac",		"VVA_Vehicles_Van_vve_a");				-- ok.
		SetAnimationsConfig("Van_LectroMax",		"VVA_Vehicles_Van_vve_a");				-- ok.
		SetAnimationsConfig("VanRadio",			"VVA_Vehicles_VanRadio_vve_a");				-- ok.
		SetAnimationsConfig("VanRadio_3N",		"VVA_Vehicles_VanRadio_vve_a");				-- ok.
		SetAnimationsConfig("SportsCar",		"VVA_Vehicles_SportsCar_vve_a");			-- ok.




	if getActivatedMods():contains("Purga_STFR") then
		SetAnimationsConfig("StepVan_swat",		"VVA_Vehicle_StepVan_vve_a");				-- ok.
		SetAnimationsConfig("Van_doc",			"VVA_Vehicles_Van_vve_a");				-- ok.
		SetAnimationsConfig("STFR_87gmcarmoredcar",	"VVA_Vehicle_87gmcarmored_a");
	end


else
if not getActivatedMods():contains("Purga_VVSR_Continued") then
	
		SetAnimationsConfig("CarLights",		"VVA_Vehicles_CarLights_a");
		SetAnimationsConfig("CarLightsPolice",		"VVA_Vehicles_CarLights_NoRandom_a");
		SetAnimationsConfig("CarNormal",		"VVA_Vehicles_CarNormal_a");
		SetAnimationsConfig("SmallCar",			"VVA_Vehicles_SmallCar_a");
		SetAnimationsConfig("PickUpVanLights",		"VVA_Vehicles_PickUpVanLights_NoRandom_a");
		SetAnimationsConfig("PickUpVanLightsPolice",	"VVA_Vehicles_PickUpVanLights_NoRandom_a");
		SetAnimationsConfig("PickUpVanLightsFire",	"VVA_Vehicles_PickUpVanLights_NoRandom_a");
		SetAnimationsConfig("PickUpVan",		"VVA_Vehicles_PickUpVan_a");
		SetAnimationsConfig("PickUpTruckLights",	"VVA_Vehicles_PickUpTruckLights_a");
		SetAnimationsConfig("PickUpTruckLightsFire",	"VVA_Vehicles_PickUpTruckLights_NoRandom_a");
		SetAnimationsConfig("PickUpTruck",		"VVA_Vehicles_PickUpTruck_a");
		SetAnimationsConfig("VanAmbulance",		"VVA_Vehicles_Ambulance_a");
end

		SetAnimationsConfig("CarTaxi",			"VVA_Vehicles_CarTaxi_a");
		SetAnimationsConfig("CarTaxi2",			"VVA_Vehicles_CarTaxi_a");
		SetAnimationsConfig("CarStationWagon",		"VVA_Vehicles_CarStationWagon_a");
		SetAnimationsConfig("CarStationWagon2",		"VVA_Vehicles_CarStationWagon_a");
		SetAnimationsConfig("ModernCar",		"VVA_Vehicles_ModernCar_a");
		SetAnimationsConfig("ModernCar02",		"VVA_Vehicles_ModernCar02_a");
		SetAnimationsConfig("CarLuxury",		"VVA_Vehicles_LuxuryCar_a");
		SetAnimationsConfig("SmallCar02",		"VVA_Vehicles_SmallCar02_a");
		SetAnimationsConfig("SUV",			"VVA_Vehicles_SUV_a");
		SetAnimationsConfig("OffRoad",			"VVA_Vehicles_OffRoad_a");
		SetAnimationsConfig("PickUpVanMccoy",		"VVA_Vehicles_PickUpVan_NoRandom_a");
		SetAnimationsConfig("PickUpTruckMccoy",		"VVA_Vehicles_PickUpTruck_NoRandom_a");
		SetAnimationsConfig("StepVan",			"VVA_Vehicle_StepVan_a");
		SetAnimationsConfig("StepVan_Heralds",		"VVA_Vehicle_StepVan_a");
		SetAnimationsConfig("StepVanMail",		"VVA_Vehicle_StepVan_NoRandom_a");
		SetAnimationsConfig("StepVan_Scarlet",		"VVA_Vehicle_StepVan_a");
		SetAnimationsConfig("VanSeats",			"VVA_Vehicles_VanSeats_a");
		SetAnimationsConfig("Van",			"VVA_Vehicles_Van_a");
		SetAnimationsConfig("Van_KnoxDisti",		"VVA_Vehicles_Van_a");
		SetAnimationsConfig("Van_Transit",		"VVA_Vehicles_Van_a");
		SetAnimationsConfig("VanSpiffo",		"VVA_Vehicles_Van_NoRandom_a");
		SetAnimationsConfig("VanSpecial",		"VVA_Vehicles_Van_NoRandom_a");
		SetAnimationsConfig("Van_MassGenFac",		"VVA_Vehicles_Van_a");
		SetAnimationsConfig("Van_LectroMax",		"VVA_Vehicles_Van_a");
		SetAnimationsConfig("VanRadio",			"VVA_Vehicles_VanRadio_a");
		SetAnimationsConfig("VanRadio_3N",		"VVA_Vehicles_VanRadio_a");
		SetAnimationsConfig("SportsCar",		"VVA_Vehicles_SportsCar_a");


	if getActivatedMods():contains("Purga_STFR") then
		SetAnimationsConfig("StepVan_swat",		"VVA_Vehicle_StepVan_a");
		SetAnimationsConfig("Van_doc",			"VVA_Vehicles_Van_a");
		SetAnimationsConfig("STFR_87gmcarmoredcar",	"VVA_Vehicle_87gmcarmored_a");
	end

end

	if getActivatedMods():contains("Purga_STR") then
		SetAnimationsConfig("Van_ravencreekdoc",	"VVA_Vehicles_Van_a");
		SetAnimationsConfig("Van_meadedoc",		"VVA_Vehicles_Van_a");
		SetAnimationsConfig("Van_jeffersondoc",		"VVA_Vehicles_VanSeats_a");
		SetAnimationsConfig("STFR_87gmcarmoredcar",	"VVA_Vehicle_87gmcarmored_a");
	end

	if getActivatedMods():contains("Purga_TallerMecanico") then		
		SetAnimationsConfig("VanSnakeneta",		"VVA_Vehicles_Van_NoRandom_a");
		SetAnimationsConfig("VanGenova",		"VVA_Vehicles_Van_NoRandom_a");
		SetAnimationsConfig("CarTaxiArg",		"VVA_Vehicles_CarTaxiArg_a");
		SetAnimationsConfig("StepVan_Nubasian",		"VVA_Vehicle_StepVan_a");

		SetAnimationsConfig("Vancmneta",		"VVA_Vehicles_Van_NoRandom_a");
		SetAnimationsConfig("PickUpTruckKelo",		"VVA_Vehicles_PickUpVan_NoRandom_a");
		SetAnimationsConfig("StepVanNubAsian",		"VVA_Vehicle_StepVan_NoRandom_a");
		SetAnimationsConfig("StepVanNumark",		"VVA_Vehicle_StepVan_NoRandom_a");
		SetAnimationsConfig("StepVanHoneyLove",		"VVA_Vehicle_StepVan_NoRandom_a");
	end
	if getActivatedMods():contains("Purga_MysteryMachineOGSN") then
		SetAnimationsConfig("VanMysterymachine",	"VVA_Vehicles_Van_a");
	end
	if getActivatedMods():contains("Purga_SaveOurStation_KnoxCountry") then
		SetAnimationsConfig("SWWS_PickUp",		"VVA_Vehicles_PickUpTruckLights_NoRandom_a");
		SetAnimationsConfig("SWWS_PickUpVan",		"VVA_Vehicles_PickUpVanLights_NoRandom_a");
		SetAnimationsConfig("SWWS_Radio",		"VVA_Vehicles_VanRadio_a");		
	end

if getActivatedMods():contains("Purga_Drive90s1") then
	vehicleLayouts["VVA_Vehicles_D90_CarNormal2_a"] = {
		exterior = "VVA_D90_CarNormal2_animatedDoors",
		doors = "VVA_FourDoor",
		rear = "VVA_TrunkDoorVersion",
		seats = "VVA_FourSeats",
	}
	vehicleLayouts["VVA_Vehicles_D90_CarNormal3_a"] = {
		exterior = "VVA_D90_CarNormal3_animatedDoors",
		doors = "VVA_FourDoor",
		rear = "VVA_TrunkDoorVersion",
		seats = "VVA_FourSeats",
	}
	vehicleLayouts["VVA_Vehicles_D90_CarCoupe_a"] = {
		exterior = "VVA_D90_CarCoupe_animatedDoors",
		doors = "VVA_TwoDoor",
		rear = "VVA_TrunkDoorVersion",
		seats = "VVA_FourSeats",
	}
	vehicleLayouts["VVA_Vehicles_D90_ModernCar3_a"] = {
		exterior = "VVA_D90_ModernCar3_animatedDoors",
		doors = "VVA_FourDoor",
		rear = "VVA_TrunkDoorVersion",
		seats = "VVA_FourSeats",
	}
	vehicleLayouts["VVA_Vehicles_D90_ModernCar4_a"] = {
		exterior = "VVA_D90_ModernCar4_animatedDoors",
		doors = "VVA_FourDoor",
		rear = "VVA_TrunkDoorVersion",
		seats = "VVA_FourSeats",
	}
	vehicleLayouts["VVA_Vehicles_D90_ModernWagon_a"] = {
		exterior = "VVA_D90_ModernWagon_animatedDoors",
		doors = "VVA_FourDoor",
		rear = "VVA_RearDoorVersion",
		seats = "VVA_FourSeats",
	}
	vehicleLayouts["VVA_Vehicles_D90_MuscleCar_a"] = {
		exterior = "VVA_D90_MuscleCar_animatedDoors",
		doors = "VVA_TwoDoor",
		rear = "VVA_TrunkDoorVersion",
		seats = "VVA_FourSeats",
	}
	vehicleLayouts["VVA_Vehicles_D90_CarOld_a"] = {
		exterior = "VVA_D90_CarOld_animatedDoors",
		doors = "VVA_FourDoor",
		rear = "VVA_TrunkDoorVersion",
		seats = "VVA_FourSeats",
	}
	vehicleLayouts["VVA_Vehicles_D90_CarSmall3_a"] = {
		exterior = "VVA_D90_CarSmall3_animatedDoors",
		doors = "VVA_TwoDoor",
		rear = "VVA_TrunkDoorVersion",
		seats = "VVA_FourSeats",
	}
	vehicleLayouts["VVA_Vehicles_D90_CarUTE_a"] = {
		exterior = "VVA_D90_CarUTE_animatedDoors",
		doors = "VVA_TwoDoor",
		rear = "VVA_OpenBedVersion",
		seats = "VVA_TwoSeats",
	}
	vehicleLayouts["VVA_Vehicles_D90_CarPickUpTruckL_a"] = {
		exterior = "VVA_D90_CarPickUpTruckL_animatedDoors",
		doors = "VVA_FourDoor",
		rear = "VVA_OpenBedVersion",
		seats = "VVA_FourSeats",
	}


	SetAnimationsConfig("CarNormal02",			"VVA_Vehicles_D90_CarNormal2_a");
	SetAnimationsConfig("CarNormal03",			"VVA_Vehicles_D90_CarNormal3_a");
	SetAnimationsConfig("Coupe",				"VVA_Vehicles_D90_CarCoupe_a");
	SetAnimationsConfig("CoupeSpecial",			"VVA_Vehicles_D90_CarCoupe_a");
	SetAnimationsConfig("ModernCar03",			"VVA_Vehicles_D90_ModernCar3_a");
	SetAnimationsConfig("ModernCar04",			"VVA_Vehicles_D90_ModernCar4_a");
	SetAnimationsConfig("ModernWagon",			"VVA_Vehicles_D90_ModernWagon_a");
	SetAnimationsConfig("MuscleCar",			"VVA_Vehicles_D90_MuscleCar_a");
	SetAnimationsConfig("OldCar",				"VVA_Vehicles_D90_CarOld_a");
	SetAnimationsConfig("SmallCar03",			"VVA_Vehicles_D90_CarSmall3_a");
	SetAnimationsConfig("Ute",				"VVA_Vehicles_D90_CarUTE_a");
	SetAnimationsConfig("PickUpLarge",			"VVA_Vehicles_D90_CarPickUpTruckL_a");

end

if getActivatedMods():contains("Purga_DashRoamer1") then
	vehicleLayouts["VVA_Vehicles_TruckCamper_a"] = {
		exterior = "VVA_TruckCamper_animatedDoors",
		doors = "VVA_2FRRDoor",
		rear = "VVA_OpenBedVersion",
		seats = "VVA_FourSeats",
	}
	
	SetAnimationsConfig("DashRoamer",			"VVA_Vehicles_TruckCamper_a");
end