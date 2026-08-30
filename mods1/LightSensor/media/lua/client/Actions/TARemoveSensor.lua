require "TimedActions/ISBaseTimedAction"

TARemoveSensor = ISBaseTimedAction:derive("TARemoveSensor");

function TARemoveSensor:isValid()
	return true
end

function TARemoveSensor:update()
end

function TARemoveSensor:start()
    -- self.character:setMetabolicTarget(Metabolics.DiggingSpade);
	self:setActionAnim("Loot")
	self:setOverrideHandModels(nil, nil)
	self.sound = self.character:playSound("GeneratorRepair")
end

function TARemoveSensor:stop()
	self.character:stopOrTriggerSound(self.sound)
	ISBaseTimedAction.stop(self)
end

function TARemoveSensor:perform()
    self.character:stopOrTriggerSound(self.sound)
    
	local x = self.object:getX()
    local y = self.object:getY()
    local z = self.object:getZ()

    local entry = {}
    entry.x = x
    entry.y = y
    entry.z = z

    sendClientCommand(self.character, 'Commands', 'RemoveSensor', entry)

	local info = SensorTypes[self.vsensor.type]
	local itemName = "LightSensors." .. info.itemName
	local sensor = InventoryItemFactory.CreateItem(itemName)

	local sensorModData = sensor:getModData()
	sensorModData.type = self.vsensor.type
	sensorModData.inv = self.vsensor.inv
	sensorModData.positive = self.vsensor.positive
	sensorModData.battery = self.vsensor.battery
	sensorModData.alarm = self.vsensor.alarm
	sensorModData.arm = self.vsensor.arm
	sensorModData.val = self.vsensor.val
	self.character:getInventory():AddItem(sensor)

	ISBaseTimedAction.perform(self)
end

function TARemoveSensor:new(character, square, object, vsensor)
	local o = {}
	setmetatable(o, self)
	self.__index = self
    
    o.character = character
    o.square = square
	o.object = object
	o.vsensor = vsensor

	o.stopOnWalk = false
    o.maxTime = 100
    o.caloriesModifier = 6
	return o
end

return TARemoveSensor;
