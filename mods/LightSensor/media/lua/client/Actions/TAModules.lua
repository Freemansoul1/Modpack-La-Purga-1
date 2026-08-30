require "TimedActions/ISBaseTimedAction"

TAModules = ISBaseTimedAction:derive("TAModules")

function TAModules:isValid()
    return true
end

function TAModules:update()
end

function TAModules:start()
    self:setActionAnim("Loot")
    self:setOverrideHandModels(nil, nil)
    self.sound = self.character:playSound("LightFlicker")
end

function TAModules:stop()
    self.character:stopOrTriggerSound(self.sound)
    ISBaseTimedAction.stop(self)
end

function TAModules:perform()
    if self.character and self.sensor and self.mode then
        if self["perform"..self.mode] then
            self["perform"..self.mode](self)
            self.character:stopOrTriggerSound(self.sound)
        end
    end

    ISBaseTimedAction.perform(self)
end

-- BATTERY
function TAModules:isValidAddBattery()
    if self.sensorModData.battery then 
        return false
    else
        return true
    end
end

function TAModules:performAddBattery()
    local batteryPower = self.secondaryItem:getDelta()
    self.sensorModData.battery = batteryPower
    local inv = self.character:getInventory()
    inv:Remove(self.secondaryItem)
end

function TAModules:isValidRemoveBattery()
    if self.sensorModData.battery then 
        return true
    else
        return false
    end
end

function TAModules:performRemoveBattery()
    if self.sensorModData.battery > 0 then
        local inv = self.character:getInventory()
        local item = InventoryItemFactory.CreateItem("Battery")
        item:setDelta(self.sensorModData.battery)
        inv:AddItem(item)
    end
    self.sensorModData.battery = nil
end

-- ALARM
function TAModules:isValidAddAlarm()
    if self.sensorModData.alarm then 
        return false
    else
        return true
    end
end

function TAModules:performAddAlarm()
    self.sensorModData.alarm = true
    local inv = self.character:getInventory()
    inv:Remove(self.secondaryItem)
end

function TAModules:isValidRemoveAlarm()
    if self.sensorModData.alarm then 
        return true
    else
        return false
    end
end

function TAModules:performRemoveAlarm()
    local inv = self.character:getInventory()
    local item = InventoryItemFactory.CreateItem("Amplifier")
    inv:AddItem(item)
    self.sensorModData.alarm = false
end

-- WEAPON
function TAModules:isValidAddArm()
    if self.sensorModData.arm then 
        return false
    else
        return true
    end
end

function TAModules:performAddArm()
    local arm = self.secondaryItem:getFullType()
    self.sensorModData.arm = arm
    local inv = self.character:getInventory()
    inv:Remove(self.secondaryItem)
end

function TAModules:isValidRemoveArm()
    if self.sensorModData.arm then 
        return true
    else
        return false
    end
end

function TAModules:performRemoveArm()
    local arm = self.sensorModData.arm
    local inv = self.character:getInventory()
    local item = InventoryItemFactory.CreateItem(arm)
    inv:AddItem(item)
    self.sensorModData.arm = nil
end


function TAModules:new(mode, character, sensor, secondaryItem)
    local o             = {}
    setmetatable(o, self)
    self.__index        = self
    o.mode              = mode
    o.character         = character
    o.sensor            = sensor
    o.sensorModData     = LSUtils.GetSensorModData(sensor)
    o.secondaryItem     = secondaryItem

    o.stopOnWalk        = false
    o.stopOnRun         = true
    o.maxTime           = 100

    return o;
end

return TAModules;