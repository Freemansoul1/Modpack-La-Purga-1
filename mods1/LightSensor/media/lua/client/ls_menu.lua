--
-- ********************************
-- ***    Sensors and Traps     ***
-- ********************************
-- ***     Coded by: Slayer     ***
-- ********************************
--
require "ISUI/LSSensorEditor"

local TAAddSensor = require("Actions/TAAddSensor")
local TARemoveSensor = require("Actions/TARemoveSensor")
local TAModules = require("Actions/TAModules")

local function predicateSensor(item)
    -- print (item:getType())
    -- local x = item:getType()
    local isSensor = false
    if LSUtils.GetSensorKey(item:getType()) then isSensor = true end
	return isSensor
    --uautils.stringStarts(item:getType(), "LS")
end

local function getNameAndNumFromSpriteName(name)
    local len = string.len(name)
    local num = nil
    local strName = nil
    for i = len, 1, -1 do
        local sub = string.sub(name, i, i)
        if sub == "_" then
            strName = string.sub(name, 1, i-1)
            num = tonumber(string.sub(name, i+1, len))
            break
        end
    end
    return strName, num
end

LSMenu = LSMenu or {}

function LSMenu.TimedAddSensor (player, square, object, sensor, stype)
    if luautils.walkAdj(player, square) then
        ISTimedActionQueue.add(TAAddSensor:new(player, square, object, sensor, stype))
    end
end

function LSMenu.TimedRemoveSensor (player, square, object, stype)
    if luautils.walkAdj(player, square) then
        ISTimedActionQueue.add(TARemoveSensor:new(player, square, object, stype))
    end
end

function LSMenu.AdjustSensor(player, sensor)
    local ui = LSSensorEditorUI:new(0, 0, 300, 300, player, sensor)
    ui:initialise();
    ui:addToUIManager();
end

function LSMenu.MakeRealDoor (square, door)
    local sprite = door:getSprite()
    local spriteName = sprite:getName()
    local props = sprite:getProperties()
    
    local tname, tnum = getNameAndNumFromSpriteName(spriteName)
    local obj = IsoDoor.new(getCell(), square, tname .. "_" .. tostring(tnum), props:Is(IsoFlagType.doorN))

    if obj then
        if isClient() then
            sledgeDestroy(door)
        else
            square:transmitRemoveItemFromSquare(door)
        end

        square:AddSpecialObject(obj)
        obj:transmitCompleteItemToServer()
    end

end

function LSMenu.WorldContextMenuPre(playerID, context, worldobjects, test)

    local square = clickedSquare
    local player = getSpecificPlayer(playerID)
   
    for _, object in pairs(worldobjects) do

        if LSUtils.CanHaveSensor(object) then
            local vsensor = LSUtils.GetVSensor(object)
            for stype, sinfo in pairs(SensorTypes) do

                if vsensor and vsensor.type == stype then
                    -- REMOVE SENSOR
                    context:addOption(sinfo.removeText, player, LSMenu.TimedRemoveSensor, square, object, vsensor)
                elseif not vsensor then
                    -- ADD SENSOR
                    local sensor = player:getInventory():getFirstTypeRecurse(sinfo.itemName)
                    if sensor then
                        context:addOption(sinfo.addText, player, LSMenu.TimedAddSensor, square, object, sensor, stype)
                    end
                end
            end
        end
    end

    -- There are two types of door in the game: IsoDoor and IsoThumpable with door flag. 
    -- For some reason IsoThumpable doors are bugged when operated via a sensor.
    -- That is why they all need to be converted. 
    local door = LSUtils.GetDoor(square)
    if door and not door:IsOpen() and instanceof(door, 'IsoThumpable') then
        local cell = getCell()
        for x=-4, 4 do
            for y=-4, 4 do
                local nsquare = cell:getGridSquare(square:getX() + x, square:getY() + y, square:getZ())
                local ndoor = LSUtils.GetDoor(nsquare)
                if ndoor and not ndoor:IsOpen() and instanceof(ndoor, 'IsoThumpable') then
                    LSMenu.MakeRealDoor(nsquare, ndoor)
                end
            end
        end
    end
end

function LSMenu.WorldContextMenu(playerID, context, worldobjects, test)

    local square = clickedSquare
    local player = getSpecificPlayer(playerID)

    local objects = square:getObjects()
    for i=0, objects:size()-1 do
        local object = objects:get(i)

    --for _, object in pairs(worldobjects) do
        if (getActivatedMods():contains("Computer")) then
            local sprite = object:getSprite()
            if sprite then
                local spriteName = sprite:getName()
                if spriteName == "appliances_com_01_76" or spriteName == "appliances_com_01_77" or spriteName == "appliances_com_01_78" or spriteName == "appliances_com_01_79" then
                    for _, v in ipairs(context.options) do
                        if v.name == "Desktop Computer" then
                            local computerOption = v
                            local computerMenu = context:getSubMenu(computerOption.subOption)
                            local reprogramMenu = context:getNew(context)
                            local hasSensors = false

                            local playerInv = player:getInventory()
                            local items = ArrayList.new()
                            playerInv:getAllEvalRecurse(predicateSensor, items)
                            for i=1, items:size() do
                                local item = items:get(i-1)

                                local name
                                if instanceof(item, "ComboItem") then name = item:getName() else name = item.name end

                                reprogramMenu:addOption(name, player, LSMenu.AdjustSensor, item)
                                hasSensors = true
                            end
                            
                            local reprogramOption = computerMenu:addOption("Reprogram Sensor")
                            if not hasSensors then 
                                reprogramOption.notAvailable = true
                                local tooltipReprogramOption = ISToolTip:new()
                                tooltipReprogramOption.description = "No sensors in inventory found."
                                reprogramOption.toolTip = tooltipReprogramOption
                            
                            end
                            context:addSubMenu(reprogramOption, reprogramMenu)

                            break
                        end
                    end
                    break
                end
            end
        end
    end
end

function LSMenu.InventoryObjectContextMenuPre(playerID, context, items)
    local player = getSpecificPlayer(playerID)

    for i, item in ipairs(items) do

        local name
        if instanceof(item, "ComboItem") then name = item:getType() else name = item.name end

        if name == "LSLightSensor" then
            context:addOption("Adjust", player, AdjustSensor, item)
        elseif name == "LSProxySensor" then
            context:addOption("Adjust", player, AdjustSensor, item)
        elseif name == "LSTemperatureSensor" then
            context:addOption("Adjust", player, AdjustSensor, item)
        elseif name == "LSRainSensor" then
            context:addOption("Adjust", player, AdjustSensor, item)
        end
    end
end

Events.OnPreFillWorldObjectContextMenu.Add(LSMenu.WorldContextMenuPre)
Events.OnFillWorldObjectContextMenu.Add(LSMenu.WorldContextMenu)
