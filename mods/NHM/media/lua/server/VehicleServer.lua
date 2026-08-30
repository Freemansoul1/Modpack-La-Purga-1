ClientCommandVehicle = {}

ClientCommandVehicle.SpawnCarFrame = function(args, player)
    local carType = tostring(args.vehicle)
    local carSpawnPoint = getCell():getGridSquare(player:getX(), player:getY(), 0)
    local car = addVehicleDebug(carType, IsoDirections.S, nil, carSpawnPoint)

    for i = 0, car:getPartCount() - 1 do
        local part = car:getPartByIndex(i)
        local container = part:getItemContainer()
        if container then
            if container:getItems():size() ~= 0 then
                container:removeAllItems()
            end
        end
    end

    for i = 0, car:getPartCount() - 1 do
        local part = car:getPartByIndex(i);
        if part:getId() ~= "TruckBed" then
            part:setInventoryItem(nil);
        end
    end

    car:getPartById("Engine"):setCondition(0);
    car:getPartById("TruckBed"):setCondition(0);

    print(tostring(carType) .. " successfully spawned!")
end

function ClientCommandVehicle:onClientCommand(command, player, args)
    if ClientCommandVehicle[command] then
        ClientCommandVehicle[command](args, player)
    end
end

if isServer() then
    Events.OnClientCommand.Add(ClientCommandVehicle.onClientCommand)
end
