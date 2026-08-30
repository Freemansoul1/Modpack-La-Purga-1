require "VehicleZoneDefinition"

--    /************************ Normal Spawns ************************/

-- Regular Bicycle
VehicleZoneDistribution.junkyard.vehicles["Base.BicycleRegular"] = {index = -1, spawnChance = 0};
VehicleZoneDistribution.parkingstall.vehicles["Base.BicycleRegular"] = {index = -1, spawnChance = 0};
VehicleZoneDistribution.trailerpark.vehicles["Base.BicycleRegular"] = {index = -1, spawnChance = 0};
VehicleZoneDistribution.trafficjams.vehicles["Base.BicycleRegular"] = {index = -1, spawnChance = 0};
--
VehicleZoneDistribution.junkyard.vehicles["Base.BicycleRegularScrap"] = {index = -1, spawnChance = 0};
VehicleZoneDistribution.parkingstall.vehicles["Base.BicycleRegularScrap"] = {index = -1, spawnChance = 0};
VehicleZoneDistribution.trailerpark.vehicles["Base.BicycleRegularScrap"] = {index = -1, spawnChance = 0};
VehicleZoneDistribution.trafficjams.vehicles["Base.BicycleRegularScrap"] = {index = -1, spawnChance = 0};

-- MTB Bicycle
VehicleZoneDistribution.junkyard.vehicles["Base.BicycleMTB"] = {index = -1, spawnChance = 0};
VehicleZoneDistribution.parkingstall.vehicles["Base.BicycleMTB"] = {index = -1, spawnChance = 0};
VehicleZoneDistribution.trailerpark.vehicles["Base.BicycleMTB"] = {index = -1, spawnChance = 0};
VehicleZoneDistribution.trafficjams.vehicles["Base.BicycleMTB"] = {index = -1, spawnChance = 0};
--
VehicleZoneDistribution.junkyard.vehicles["Base.BicycleMTBScrap"] = {index = -1, spawnChance = 0};
VehicleZoneDistribution.parkingstall.vehicles["Base.BicycleMTBScrap"] = {index = -1, spawnChance = 0};
VehicleZoneDistribution.trailerpark.vehicles["Base.BicycleMTBScrap"] = {index = -1, spawnChance = 0};
VehicleZoneDistribution.trafficjams.vehicles["Base.BicycleMTBScrap"] = {index = -1, spawnChance = 0};

-- Bicycle Trailer
VehicleZoneDistribution.junkyard.vehicles["Base.BicycleTrailer"] = {index = -1, spawnChance = 0};
VehicleZoneDistribution.parkingstall.vehicles["Base.BicycleTrailer"] = {index = -1, spawnChance = 0};
VehicleZoneDistribution.trailerpark.vehicles["Base.BicycleTrailer"] = {index = -1, spawnChance = 0};
VehicleZoneDistribution.trafficjams.vehicles["Base.BicycleTrailer"] = {index = -1, spawnChance = 0};

--    /************************ Farm Spawns ************************/
VehicleZoneDistribution.farm = VehicleZoneDistribution.farm or {}
VehicleZoneDistribution.farm.vehicles = VehicleZoneDistribution.farm.vehicles or {}

-- Regular Bicycle
VehicleZoneDistribution.farm.vehicles["Base.BicycleRegular"] = {index = -1, spawnChance = 0};
--
VehicleZoneDistribution.farm.vehicles["Base.BicycleRegularScrap"] = {index = -1, spawnChance = 0};

-- MTB Bicycle
VehicleZoneDistribution.farm.vehicles["Base.BicycleMTB"] = {index = -1, spawnChance = 0};
--
VehicleZoneDistribution.farm.vehicles["Base.BicycleMTBScrap"] = {index = -1, spawnChance = 0};

--    /************************ Misc Spawns ************************/

-- Regular Bicycle
VehicleZoneDistribution.mccoy.vehicles["Base.BicycleRegular"] = {index = -1, spawnChance = 0};
VehicleZoneDistribution.fossoil.vehicles["Base.BicycleRegular"] = {index = -1, spawnChance = 0};
VehicleZoneDistribution.postal.vehicles["Base.BicycleRegular"] = {index = -1, spawnChance = 0};
--
VehicleZoneDistribution.mccoy.vehicles["Base.BicycleRegularScrap"] = {index = -1, spawnChance = 0};
VehicleZoneDistribution.fossoil.vehicles["Base.BicycleRegularScrap"] = {index = -1, spawnChance = 0};
VehicleZoneDistribution.postal.vehicles["Base.BicycleRegularScrap"] = {index = -1, spawnChance = 0};

-- MTB Bicycle
VehicleZoneDistribution.mccoy.vehicles["Base.BicycleMTB"] = {index = -1, spawnChance = 0};
VehicleZoneDistribution.fossoil.vehicles["Base.BicycleMTB"] = {index = -1, spawnChance = 0};
VehicleZoneDistribution.postal.vehicles["Base.BicycleMTB"] = {index = -1, spawnChance = 0};
--
VehicleZoneDistribution.mccoy.vehicles["Base.BicycleMTBScrap"] = {index = -1, spawnChance = 0};
VehicleZoneDistribution.fossoil.vehicles["Base.BicycleMTBScrap"] = {index = -1, spawnChance = 0};
VehicleZoneDistribution.postal.vehicles["Base.BicycleMTBScrap"] = {index = -1, spawnChance = 0};

-- Bicycle Trailer
VehicleZoneDistribution.mccoy.vehicles["Base.BicycleTrailer"] = {index = -1, spawnChance = 0};
VehicleZoneDistribution.fossoil.vehicles["Base.BicycleTrailer"] = {index = -1, spawnChance = 0};
VehicleZoneDistribution.postal.vehicles["Base.BicycleTrailer"] = {index = -1, spawnChance = 0};