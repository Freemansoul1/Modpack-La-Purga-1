
-- client.lua
local updateInterval = 0.1 -- Update every 0.1 seconds
local lastUpdateTime = 0

-- Sends the vehicle position to other passengers
function updateVehiclePosition()
    local vehicle = getPlayerVehicle()
    if vehicle then
        local x, y, z = vehicle:getX(), vehicle:getY(), vehicle:getZ()
        local passengers = getVehiclePassengers(vehicle)
        for _, passenger in ipairs(passengers) do
            if passenger ~= getPlayer() then
                print("[Client] Sending vehicle update to passenger:", passenger:getUsername(), vehicle:getId(), x, y, z)
                sendClientCommand(passenger, "vehicleSync", "vehicleUpdate", { vehicle:getId(), x, y, z })
            end
        end
    end
end

-- Receives vehicle updates from the driver
function receiveVehicleUpdate(module, command, args)
    if module == "vehicleSync" and command == "vehicleUpdate" then
        local vehicleId = tonumber(args[1])
        local x, y, z = tonumber(args[2]), tonumber(args[3]), tonumber(args[4])
        print("[Client] Received vehicle update:", vehicleId, x, y, z)
        local vehicle = getVehicleById(vehicleId)
        if vehicle then
            vehicle:setX(x)
            vehicle:setY(y)
            vehicle:setZ(z)
        end
    end
end


function ejectPlayerFromVehicle(victim)

    -- Ejecutar las acciones necesarias para expulsar al jugador del vehículo
    ISVehicleMenu.onExit(victim, seat)
    victim:faceThisObjectAlt(vehicle)
    victim:clearVariable("BumpFallType")
    victim:setBumpType("stagger")
    victim:setBumpDone(false)
    victim:setBumpFall(true)
    victim:setBumpFallType("pushedFront")
end

-- Main update loop
Events.OnTick.Add(function()
    local currentTime = getGameTime():getTimeOfDay()
    local player = getSpecificPlayer(0)
    if currentTime - lastUpdateTime > updateInterval then
        if isDriver() then
            updateVehiclePosition()
            checkPlayerInSafehouseZone(player)
        end
        lastUpdateTime = currentTime
    end
end)

-- Register network handler for receiving updates from the driver
Events.OnServerCommand.Add(function(module, command, player, args)
    receiveVehicleUpdate(module, command, args)
end)

print("[Client] Vehicle sync script initialized.")

-- Función principal que verifica si debe expulsar al jugador del vehículo
function checkPlayerInSafehouseZone(player)
    -- Verificamos si el jugador está dentro de la zona segura y pertenece a la facción del owner
    if not isDrivingInsideSafeZone(player) then
        -- El jugador no pertenece a la facción del owner, lo expulsamos del vehículo
        ejectPlayerFromVehicle(player)
    end
end

