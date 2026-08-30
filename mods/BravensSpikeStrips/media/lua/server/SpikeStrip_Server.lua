local tireNames = {
    "TireFrontLeft",
    "TireFrontRight",
    "TireRearLeft",
    "TireRearRight",
}

local function RemoveTires(playerObj)
    local vehicle = playerObj:getVehicle()
    if not vehicle then return end
    
    -- Identificar las ruedas disponibles en el vehículo
    local tires = {}
    for i = 1, 4 do
        local tire = vehicle:getPartById(tireNames[i])
        if tire then
            table.insert(tires, tire)
        end
    end

    -- Si no hay suficientes ruedas, salir de la función
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

                local item = tire:getInventoryItem()
                tire:setInventoryItem(nil)
                vehicle:transmitPartItem(tire)
                vehicle:getCurrentSquare():AddWorldInventoryItem(item,
                    vehicle:getX() - math.floor(vehicle:getX()),
                    vehicle:getY() - math.floor(vehicle:getY()),
                    vehicle:getZ() - math.floor(vehicle:getZ()))
                
                sendServerCommand(playerObj, "SpikeStrip", "PlayPopSound", {})
            end, 25 + (_ * 25))
        end
    end
end

local function onClientCommand(module, command, playerObj, args)
    if module ~= "SpikeStrip" then return end

    if command == "RemoveTires" then
        RemoveTires(playerObj)
    end
end

Events.OnClientCommand.Add(onClientCommand)
