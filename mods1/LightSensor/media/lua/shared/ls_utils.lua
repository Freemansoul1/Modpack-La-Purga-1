LSUtils = LSUtils or {}

SensorTypes = {}
SensorTypes["LIGHT"] = {
    itemName="LSLightSensor", 
    hasVal=true, 
    defaultVal = 0.6,
    minVal = 0.0,
    maxVal = 1.0,
    addText="Add Light Sensor", 
    removeText="Remove Light Sensor", 
    tooltipText="Light sensor needed"
}

SensorTypes["PROXY"] = {
    itemName="LSProxySensor", 
    hasVal=true, 
    defaultVal = 6,
    minVal = 1.0,
    maxVal = 10.0,
    addText="Add Proximity Sensor", 
    removeText="Remove Proximity Sensor", 
    tooltipText="Proximity sensor needed"
}

SensorTypes["ZOMBIE"] = {
    itemName="LSZombieSensor", 
    hasVal=true, 
    defaultVal = 6,
    minVal = 1.0,
    maxVal = 10.0,
    addText="Add Zombie Sensor", 
    removeText="Remove Zombie Sensor", 
    tooltipText="Zombie sensor needed"
}

SensorTypes["ROOM"] = {
    itemName="LSRoomSensor", 
    hasVal=false, 
    addText="Add Room Sensor", 
    removeText="Remove Room Sensor", 
    tooltipText="Room sensor needed"
}

SensorTypes["TEMP"] = {
    itemName="LSTemperatureSensor", 
    hasVal=true, 
    defaultVal = 22,
    minVal = -50.0,
    maxVal = 50.0,
    addText="Add Temperature Sensor", 
    removeText="Remove Temperature Sensor", 
    tooltipText="Temperature sensor needed"
}

SensorTypes["RAIN"] = {
    itemName="LSRainSensor", 
    hasVal=true, 
    defaultVal = 0.2,
    minVal = 0.0,
    maxVal = 1.0,
    addText="Add Rain Sensor", 
    removeText="Remove Rain Sensor", 
    tooltipText="Rain sensor needed"
}

SensorTypes["POWER"] = {
    itemName="LSPowerSensor", 
    hasVal=false, 
    addText="Add Power Sensor", 
    removeText="Remove Power Sensor",
    tooltipText="Power sensor needed"
}

function LSUtils.Coords2Id (x, y, z)
    local id = x .. "-" .. y .. "-" .. z
    return id
end

function LSUtils.Id2Coords (inputstr)

    local t = {}
    for str in string.gmatch(inputstr, "([^-]+)") do
            table.insert(t, str)
    end
    return tonumber(t[1]), tonumber(t[2]), tonumber(t[3])
end

function LSUtils.HasVSensor (object)
    local x = object:getX()
    local y = object:getY()
    local z = object:getZ()
    local k = LSUtils.Coords2Id(x, y, z)

    local globalModData = GetLightSensorsModData()
    if globalModData.LightSensors[k] then
        return true
    else
        return false
    end
end

function LSUtils.GetVSensor (object)
    local x = object:getX()
    local y = object:getY()
    local z = object:getZ()
    local k = LSUtils.Coords2Id(x, y, z)

    local globalModData = GetLightSensorsModData()
    if globalModData.LightSensors[k] then
        return globalModData.LightSensors[k]
    else
        return nil
    end
end

function LSUtils.GetSensorKey (itemName)
    for k, v in pairs(SensorTypes) do
        if v.itemName == itemName then return k end
    end
    return false
end

function LSUtils.GetSensorModData(item)
    local modData = item:getModData()

    if not modData.inv then modData.inv = false end
    if not modData.alarm then modData.alarm = false end
    if not modData.arm then modData.arm = false end
    if not modData.positive then modData.positive = false end
    
    local itemType = item:getType()
    local stype = LSUtils.GetSensorKey(itemType)
    modData.type = stype
    if SensorTypes[stype].hasVal then
        if not modData.val then modData.val = SensorTypes[stype].defaultVal end
        if modData.val < SensorTypes[stype].minVal then modData.val = SensorTypes[stype].minVal end
        if modData.val > SensorTypes[stype].maxVal then modData.val = SensorTypes[stype].maxVal end
    end

    return modData
end

function LSUtils.GetObjectByClass(square, class)
    local objects = square:getObjects()
    for i=0, objects:size()-1 do
        local object = objects:get(i)
        if instanceof(object, class) then
            return object
        end
    end
    return nil
end

function LSUtils.GetDoor(square)
    local objects = square:getObjects()
    for i=0, objects:size()-1 do
        local object = objects:get(i)
        if instanceof(object, "IsoDoor") then
            return object
        end
        if instanceof(object, 'IsoThumpable') then
            if object:isDoor() == true then return object end
        end
    end
    return nil
end

function LSUtils.CanHaveSensor(object)

    -- electrical
    if instanceof(object, 'IsoLightSwitch') then return true end
    if instanceof(object, 'IsoGenerator') then return true end
    if instanceof(object, "IsoClothingDryer") then return true end
    if instanceof(object, "IsoClothingWasher") then return true end
    if instanceof(object, "IsoCombinationWasherDryer") then return true end
    if instanceof(object, "IsoStackedWasherDryer") then return true end
    if instanceof(object, "IsoTelevision") then return true end
    if instanceof(object, "IsoRadio") then return true end
    if instanceof(object, "IsoStove") then return true end

    -- mechanical
    if instanceof(object, 'IsoDoor') then return true end 
    --[[
    if instanceof(object, 'IsoThumpable') then
        if object:isDoor() == true and not object:IsOpen() then return true end
    end]]

    -- custom mods integrations
    if (getActivatedMods():contains("AirCond")) and isConnectedAC(object) then return true end

    return false
end

function LSUtils.PlaceBlood (x, y, z, q)
    local cell = getCell()
    local square = cell:getGridSquare(x, y, z)
    local surfaceOffset = GetSurfaceOffset(x, y, z)

    for i=1, q do
        local bx = x + ZombRandFloat(0.1, 0.9)
        local by = y + ZombRandFloat(0.1, 0.9)
        square:getChunk():addBloodSplat(bx, by, surfaceOffset, ZombRand(20))
        -- square:DoSplat
    end
end

function LSUtils.GetSurfaceOffset (x, y, z)

    local cell = getCell()
    local square = cell:getGridSquare(x, y, z)
    local tileObjects = square:getLuaTileObjectList()
    local squareSurfaceOffset = 0

    -- get the object with the highest offset
    for k, object in pairs(tileObjects) do
        local surfaceOffsetNoTable = object:getSurfaceOffsetNoTable()
        if surfaceOffsetNoTable > squareSurfaceOffset then
            squareSurfaceOffset = surfaceOffsetNoTable
        end

        local surfaceOffset = object:getSurfaceOffset()
        if surfaceOffset > squareSurfaceOffset then
            squareSurfaceOffset = surfaceOffset
        end
    end

    return squareSurfaceOffset / 96
end