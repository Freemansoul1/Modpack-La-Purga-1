setmetatable(HIC, { __index = _G })
setfenv(1, HIC) 

require("HIC_VehiclePartData");

function IsVehicleValid(player, vehicle)
    if vehicle:isEngineRunning() then return false; end
    local seatIndex = vehicle:getSeat(player);

    local partsData = GetPartsDataListBasedOnSeat(seatIndex);
    if partsData == nil then return false; end
    local partsValid = IsPartListValid(vehicle, partsData);

    if not partsValid then return false;
    else return true;
    end
end

function IsPartListValid(vehicle, vehiclePartsData)
    for _, partData in ipairs(vehiclePartsData) do
        local part = vehicle:getPartById(partData:getId())
        if part == nil then print("Part " .. partData:getId() .. " not found."); end
        if part ~= nil then 
            if not IsPartValid(part) then return false; end
        elseif part == nil and partData:isRequired() then return false; end
    end
    return true;
end

function IsPartValid(part)
    local conditionValid = IsPartConditionValid(part)
    if not conditionValid then return false; end

    local door = part:getDoor();
    local window = part:getWindow();

    local checked = false;
    if door then
        checked = CheckAsDoor(door);
    elseif window then
        checked = CheckAsWindow(window);
    else
        checked = true;
    end
    return checked;
end

function CheckAsDoor(door)
    if door:isOpen() then
        return false;
    end;
    return true;
end

function CheckAsWindow(window)
    if window:isDestroyed() then
        return false
    end;

    if window:isOpen() then
        return false
    end;
    return true;
end

function IsPartConditionValid(part)
    local condition = part:getCondition();
    if condition >= HIC.MinimalCondition then
        return true;
    end
    return false
end

function GetPartsDataListBasedOnSeat(seatIndex)
    if seatIndex == 0 or seatIndex == 1 then
        return FrontPartsList;
    elseif seatIndex == 2 or seatIndex == 3 then
        return RearPartsList;
    end
    return nil;
end

FrontPartsList = {
    HIC.VehiclePartData("WindowFrontLeft", true),
    HIC.VehiclePartData("WindowFrontRight", true),
    HIC.VehiclePartData("Windshield", true),
    HIC.VehiclePartData("DoorFrontLeft", true),
    HIC.VehiclePartData("DoorFrontRight", true)
}

RearPartsList = {
    HIC.VehiclePartData("WindowRearLeft", true),
    HIC.VehiclePartData("WindowRearRight", true),
    HIC.VehiclePartData("WindshieldRear", false),
    HIC.VehiclePartData("DoorRearLeft", false),
    HIC.VehiclePartData("DoorRearRight", false)
}