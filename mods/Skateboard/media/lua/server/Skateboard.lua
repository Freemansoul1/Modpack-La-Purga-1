--[[
if not isServer() then return end -- Evitar cargar en modo un jugador

local Functions = require "Skateboard/Functions"

-- Variable para almacenar el intervalo de ticks entre ejecuciones
local tickCounter = 0
local TICKS_INTERVAL = 15 -- Verificar cada 15 ticks (~0.49 segundos)

-- Tabla para guardar el estado de la durabilidad del "Front End" de cada vehículo
local lastDurability = {}

local onTick = function(tick)
    -- Incrementamos el contador de ticks
    tickCounter = tickCounter + 1
    
    -- Solo ejecutar cada X ticks (15 ticks = aproximadamente 0.49 segundos)
    if tickCounter % TICKS_INTERVAL ~= 0 then
        return
    end

    -- Obtener lista de jugadores en línea
    local players = getOnlinePlayers()

    -- Iterar sobre los jugadores conectados
    for i = 0, players:size() - 1 do
        local player = players:get(i)

        -- Verificar si el jugador existe y está en un vehículo
        if player and player:getVehicle() then
            local vehicle = player:getVehicle()

            -- Solo proceder si el vehículo es un "Skateboard"
            if vehicle:getScriptName() == "Base.Skateboard" then
                -- Obtener la durabilidad del front-end del vehículo
                local frontDurability = Functions.currentFrontEndDurability(vehicle)

                -- Obtener ID del vehículo para usarlo como clave única en la tabla
                local vehicleId = vehicle:getId()

                -- Verificar si la durabilidad ha cambiado desde la última vez
                if lastDurability[vehicleId] ~= frontDurability then
                    -- Actualizar la durabilidad en nuestra tabla
                    lastDurability[vehicleId] = frontDurability
                    
                    -- Actualizar los datos del vehículo
                    vehicle:getModData().currentFrontEndDurability = frontDurability

                    -- Enviar comando al servidor para actualizar el vehículo
                    sendServerCommand(player, "Skateboard", "BumpVehicle", {
                        vehicleId = vehicleId
                    })
                end
            end
        end
    end
end

-- Añadir la función al evento OnTick
Events.OnTick.Add(onTick)]]