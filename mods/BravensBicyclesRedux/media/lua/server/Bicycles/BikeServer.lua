--***********************************************************
--**                       BitBraven                       **
--***********************************************************

BikeServer = {}
BikeServer.Create = {}
BikeServer.Update = {}
BikeServer.Init = {}

BikeServer.RemoveBikePart = function(part, vehicle)
    part:setInventoryItem(nil);
    vehicle:transmitPartItem(part);
end

BikeServer.LiftBike = function(vehicle, playerObj)
    vehicle:setAngles(0, 0, 0)
    BravensUtils.TirePlayer(playerObj, 0.1)
end

BikeServer.StartBike = function(vehicle)
    vehicle:setKeysInIgnition(true)
    vehicle:setHotwired(true)
    vehicle:engineDoRunning()
end

BikeServer.UpdateBike = function(character, vehicle, frame, inventory)

	if not vehicle then return end
	if not BravensBikeUtils.isBike(vehicle) then return end

	BravensBikeUtils.setPartsToCondition(vehicle, inventory, character)

	--Match the new bicycle frame's color and rust to the original if possible. Otherwise, make it random.
    if not frame:getModData().frameColor then return end

    vehicle:setSkinIndex(frame:getModData().frameColor)
    vehicle:updateSkin()

    vehicle:setRust(frame:getModData().rustAmount)
    vehicle:transmitRust()
end

function BikeServer.Create.CustomPartRand(vehicle, part)
    if (ZombRand(100) <= 40) then
        VehicleUtils.createPartInventoryItem(part)
    end
end

function BikeServer.Create.Headlight(vehicle, part)
print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
    local bikeType = vehicle:getScriptName()
    print("-----------------------------")
    print(bikeType)
    print(bikeType == "Base.BicycleMTBScrap")
    print("-----------------------------")
    if bikeType == "Base.BicycleMTB" or bikeType == "Base.BicycleMTBScrap" then
        VehicleUtils.createPartInventoryItem(part)
        part:createSpotLight(0.7, 0.5, 0.5, 0.5, 0.5, 0.5)
        print("BBBBBBBBBBBBBBBBBBBBBBBBB")
    elseif (ZombRand(100) <= 20) then
        VehicleUtils.createPartInventoryItem(part)
        part:createSpotLight(0.7, 0.5, 0.5, 0.5, 0.5, 0.5)
    end
    print("CCCCCCCCCCCCCCCCCCCCCCCCCCCCCC")
end

function BikeServer.Update.Headlight(vehicle, part, elapsedMinutes)
	local light = part:getLight() if not light then return end
	part:setLightActive(true)
end

local function onClientCommand(module, command, player, args)

    if module ~= "Braven" then return end

    if command == "SpawnBike" then

        local square = getSquare(player:getX(), player:getY(), player:getZ())
        local vehicle = addVehicleDebug(args.bikeName, nil, nil, square);

        if vehicle then
            local params = { vehicleId = vehicle:getId(), frame = args.frame };
            if isServer() then
                sendServerCommand(player, 'Braven', 'BikeSpawned', params);
            else
                triggerEvent('OnServerCommand', 'Braven', 'BikeSpawned', params);
            end
        end
    end
end

Events.OnClientCommand.Add(onClientCommand);
