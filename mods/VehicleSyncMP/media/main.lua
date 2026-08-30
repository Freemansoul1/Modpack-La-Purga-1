-- main.lua

-- Initialize the mod
function init()
    if isServer() then
        dofile("server.lua")
    else
        dofile("client.lua")
    end
end

-- Utility functions
function getOnlinePlayers()
    return IsoPlayer.getOnlinePlayers()
end

function getPlayerVehicle()
    local player = getSpecificPlayer(0)
    if player then
        return player:getVehicle()
    end
    return nil
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


function getVehicleById(vehicleId)
    for i = 0, IsoWorld.instance.vehicles:size() - 1 do
        local vehicle = IsoWorld.instance.vehicles:get(i)
        if vehicle:getId() == vehicleId then
            return vehicle
        end
    end
    return nil
end

function getVehiclePassengers(vehicle)
    local passengers = {}
    for i = 0, vehicle:getMaxPassengers() - 1 do
        local passenger = vehicle:getCharacter(i)
        if passenger then
            table.insert(passengers, passenger)
        end
    end
    return passengers
end

function isDriver()
    local vehicle = getPlayerVehicle()
    if vehicle then
        return vehicle:getDriver() == getPlayer()
    end
    return false
end

function getGameTime()
    return getGameTime()
end

function sendClientCommand(player, module, command, args)
    sendServerCommand(player, module, command, args)
end

-- Register initialization
Events.OnGameStart.Add(init)

print("[Debug] Mod initialized.")
