-- server.lua
local vehicles = {}

-- Receives vehicle updates from clients
function receiveVehicleUpdate(module, command, player, args)
    if module == "vehicleSync" and command == "vehicleUpdate" then
        local vehicleId = tonumber(args[1])
        local x, y, z = tonumber(args[2]), tonumber(args[3]), tonumber(args[4])
        print("[Server] Received vehicle update:", vehicleId, x, y, z)
        vehicles[vehicleId] = { x = x, y = y, z = z }
    end
end

-- Función que verifica si un jugador pertenece a la facción del dueño de un safehouse
function isPlayerInOwnerFaction(player, safehouse)
    -- Obtenemos el owner del safehouse
    local ownerName = safehouse:getOwner()
    
    -- Obtenemos la facción del owner del safehouse
    local ownerFaction = Faction.getPlayerFaction(ownerName)

    -- Si el player no tiene facción, no pertenece
    if not ownerFaction then return false end

    -- Verificamos si el jugador pertenece a la facción del owner
    return ownerFaction:isMember(player:getUsername())
end

-- Función que verifica si un jugador está conduciendo o es pasajero en un vehículo dentro de un safehouse
function isDrivingInsideSafeZone(player)
    -- Obtenemos el vehículo en el que está el jugador
    local vehicle = player:getVehicle()

    -- Verificamos si el jugador está dentro de un vehículo
    if not vehicle then return false end

    -- Obtenemos la posición actual del vehículo
    local square = vehicle:getSquare()
    if not square then return false end

    -- Verificamos si el vehículo está dentro de un safehouse
    local safehouse = SafeHouse.hasSafehouse(square)
    if not safehouse then return false end

    -- Verificamos si el jugador pertenece a la facción del owner del safehouse
    if not isPlayerInOwnerFaction(player, safehouse) then
        return false
    end

    -- El jugador está conduciendo o es pasajero y pertenece a la facción del owner
    return true
end

-- Register network handler for receiving updates from clients
Events.OnClientCommand.Add(function(module, command, player, args)
    receiveVehicleUpdate(module, command, player, args)
end)

print("[Server] Vehicle sync script initialized.")
