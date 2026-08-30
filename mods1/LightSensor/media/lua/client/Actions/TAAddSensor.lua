require "TimedActions/ISBaseTimedAction"

TAAddSensor = ISBaseTimedAction:derive("TAAddSensor");

function TAAddSensor:isValid()
    return true
end

function TAAddSensor:update()
end

function TAAddSensor:start()
    -- self.character:setMetabolicTarget(Metabolics.DiggingSpade);
    self:setActionAnim("Loot")
    self:setOverrideHandModels(nil, nil)
    self.sound = self.character:playSound("GeneratorRepair")
end

function TAAddSensor:stop()
    self.character:stopOrTriggerSound(self.sound)
    ISBaseTimedAction.stop(self)
end

function TAAddSensor:perform()
    self.character:stopOrTriggerSound(self.sound)
    
    local x = self.object:getX()
    local y = self.object:getY()
    local z = self.object:getZ()

    local entry = {}
    entry.x = x
    entry.y = y
    entry.z = z
    entry.type = self.stype

    local sensorModData = LSUtils.GetSensorModData(self.sensor)
    entry.inv = sensorModData.inv
    entry.positive = sensorModData.positive
	entry.battery = sensorModData.battery
    entry.alarm = sensorModData.alarm
    entry.arm = sensorModData.arm
    entry.val = sensorModData.val
    
    sendClientCommand(self.character, 'Commands', 'AddSensor', entry)

    self.character:getInventory():Remove(self.sensor)

    ISBaseTimedAction.perform(self)
end

function TAAddSensor:new(character, square, object, sensor, stype)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    
    o.character = character
    o.square = square
    o.object = object
    o.sensor = sensor
    o.stype = stype

    o.stopOnWalk = false
    o.maxTime = 100
    o.caloriesModifier = 6
    return o
end

return TAAddSensor;
