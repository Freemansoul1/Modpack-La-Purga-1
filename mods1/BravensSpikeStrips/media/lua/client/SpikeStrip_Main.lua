local playerObj
local tireNames = {
    "TireFrontLeft",
    "TireFrontRight",
    "TireRearLeft",
    "TireRearRight",
}

local onTick = function(tick)
    if not playerObj then return end
	local vehicle = playerObj:getVehicle(); if not vehicle then return end

    local spikeStrip = GetSpikeStripInSquare()

    if spikeStrip then
        PunctureTires(vehicle)
    end
end

local onEnterVehicle = function()
    if not playerObj then return end
	local vehicle = playerObj:getVehicle(); if not vehicle then return end
	Events.OnTick.Add(onTick)
end


local onExitVehicle = function()
	Events.OnTick.Remove(onTick)
end

local OnGameStart = function()
	playerObj = getPlayer()
	onEnterVehicle()
end

function PunctureTires(vehicle)
    if getWorld():getGameMode() ~= "Multiplayer" then
        -- Identificar las ruedas disponibles en el vehículo
        local tires = {}
        for i = 1, 4, 1 do
            local tire = vehicle:getPartById(tireNames[i])
            if tire then
                table.insert(tires, tire)
            end
        end

        -- Verificar si el vehículo tiene al menos dos ruedas, si no, abortar
        if #tires < 3 then return end
        local vehicleName = self.vehicle:getScript():getName()
        for _, tire in ipairs(tires) do
            if tire and not vehicleName == "28ss100" and not vehicleName == "28ss100hermes" and not vehicleName == "AMC_bmw_classic" and not vehicleName == "AMC_bmw_custom" and not vehicleName == "AMC_harley" and not vehicleName == "vino125" and not vehicleName == "vino125b" and not vehicleName == "vino125pizza" and not vehicleName == "Trailer" and not vehicleName == "Trailer51chevy" and not vehicleName == "TrailerAMC" and not vehicleName == "TrailerAMCWaverunner" and not vehicleName == "TrailerAMCWaverunnerWithBody" and not vehicleName == "TrailerAdvert" and not vehicleName == "TrailerCover" and not vehicleName == "TrailerFirst" and not vehicleName == "TrailerForBoat" and not vehicleName == "TrailerGenerator" and not vehicleName == "TrailerHome" and not vehicleName == "TrailerHomeExplorer" and not vehicleName == "TrailerHomeHartman" and not vehicleName == "TrailerKbac" and not vehicleName == "TrailerM101A3cargo" and not vehicleName == "TrailerM1082" and not vehicleName == "TrailerM1082tarp" and not vehicleName == "TrailerM1095" and not vehicleName == "TrailerM1095tarp" and not vehicleName == "TrailerM127stake" and not vehicleName == "TrailerM128van" and not vehicleName == "Trailer129van" and not vehicleName == "TrailerM747lowbed" and not vehicleName == "TrailerM967tanker" and not vehicleName == "TrailerSecond" and not vehicleName == "TrailerTSMega" and not vehicleName == "TrailerWithBoat" and not vehicleName == "TrailerWithBoatMotor" and not vehicleName == "TrailerBoatSailingYacht" and not vehicleName == "Trailercamperscamp" and not vehicleName == "Trailerfuelmedium" and not vehicleName == "Trailerfuelsmall" and not vehicleName == "Trailermovingbig" and not vehicleName == "Trailermovingmedium" and not vehicleName == "Trailersemi" and not vehicleName == "UnimogTrailer" and not vehicleName == "TrailerWaterBig" and not vehicleName == "TrailerWaterSmall" then
                BravensUtils.DelayFunction(function()
                    local wheelIndex = tire:getWheelIndex()
                    tire:setCondition(tire:getCondition() - 75)
                    tire:setContainerContentAmount(0)
                    vehicle:setTireInflation(wheelIndex, tire:getContainerContentAmount() / tire:getContainerCapacity())
                    vehicle:transmitPartModData(tire)
                    vehicle:updatePartStats()
                    BravensUtils.TryPlaySoundClip(vehicle, "TiresPop")
                end, 50 + (_ * 50))
            end
        end
    else
        if not vehicle:isDriver(playerObj) then return end
        sendClientCommand(playerObj, 'SpikeStrip', 'RemoveTires', { })
    end

    Events.OnTick.Remove(onTick)
end

function GetSpikeStripInSquare()

    local px = playerObj:getX()
    local py = playerObj:getY()
    local pz = playerObj:getZ()

    local sqs = {}
    sqs[1] = getCell():getGridSquare(px, py, pz)

    local dir = playerObj:getDir()

    if (dir == IsoDirections.N) then        sqs[2] = getCell():getGridSquare(px-1, py-1, pz); sqs[3] = getCell():getGridSquare(px, py-1, pz);   sqs[4] = getCell():getGridSquare(px+1, py-1, pz);
    elseif (dir == IsoDirections.NE) then   sqs[2] = getCell():getGridSquare(px, py-1, pz);   sqs[3] = getCell():getGridSquare(px+1, py-1, pz); sqs[4] = getCell():getGridSquare(px+1, py, pz);
    elseif (dir == IsoDirections.E) then    sqs[2] = getCell():getGridSquare(px+1, py-1, pz); sqs[3] = getCell():getGridSquare(px+1, py, pz);   sqs[4] = getCell():getGridSquare(px+1, py+1, pz);
    elseif (dir == IsoDirections.SE) then   sqs[2] = getCell():getGridSquare(px+1, py, pz);   sqs[3] = getCell():getGridSquare(px+1, py+1, pz); sqs[4] = getCell():getGridSquare(px, py+1, pz);
    elseif (dir == IsoDirections.S) then    sqs[2] = getCell():getGridSquare(px+1, py+1, pz); sqs[3] = getCell():getGridSquare(px, py+1, pz);   sqs[4] = getCell():getGridSquare(px-1, py+1, pz);
    elseif (dir == IsoDirections.SW) then   sqs[2] = getCell():getGridSquare(px, py+1, pz);   sqs[3] = getCell():getGridSquare(px-1, py+1, pz); sqs[4] = getCell():getGridSquare(px-1, py, pz);
    elseif (dir == IsoDirections.W) then    sqs[2] = getCell():getGridSquare(px-1, py+1, pz); sqs[3] = getCell():getGridSquare(px-1, py, pz);   sqs[4] = getCell():getGridSquare(px-1, py-1, pz);
    elseif (dir == IsoDirections.NW) then   sqs[2] = getCell():getGridSquare(px-1, py, pz);   sqs[3] = getCell():getGridSquare(px-1, py-1, pz); sqs[4] = getCell():getGridSquare(px, py-1, pz);
    end

    for _,sq in ipairs(sqs) do

        local objs = sq:getWorldObjects();

        if objs then

            for i = 0, objs:size() - 1 do

                local item = objs:get(i):getItem()

                if item:getFullType() == "Braven.SpikeStrip" then
                    return item
                end
            end
        end
    end
end

local function onServerCommand(module, command, args)
    if module ~= "SpikeStrip" then return end
    if not isClient() then return end

    if command == "PlayPopSound" then
        BravensUtils.TryPlaySoundClip(playerObj:getVehicle(), "TiresPop")
    end
end

Events.OnServerCommand.Add(onServerCommand)
Events.OnGameStart.Add(OnGameStart)
Events.OnEnterVehicle.Add(onEnterVehicle)
Events.OnExitVehicle.Add(onExitVehicle)