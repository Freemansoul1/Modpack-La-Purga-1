require "TimedActions/ISBaseTimedAction"

CraftVehicleAction = ISBaseTimedAction:derive("CraftVehicleAction")

function CraftVehicleAction:isValid()
    return true
end

function CraftVehicleAction:update()
    if not self.character:getEmitter():isPlaying(self.sound) then
        self.sound = self.character:playSound("BlowTorch")
    end
end

function CraftVehicleAction:start()
    self.item = self.character:getPrimaryHandItem()
    self:setActionAnim("BlowTorch")
    self:setOverrideHandModels(self.item, nil)
    self.sound = self.character:playSound("BlowTorch")
end

function CraftVehicleAction:stop()
    if self.item then
        self.item:setJobDelta(0)
    end
    if self.sound ~= 0 then
        self.character:getEmitter():stopSound(self.sound)
    end
    ISBaseTimedAction.stop(self)
end

function GetMaterialsList(playerObj, checkItem)
    local items = playerObj:getInventory():getAllTypeRecurse(checkItem)
    return items
end

function CraftVehicleAction:perform()
    if self.item then
        self.item:setJobDelta(0)
    end
    if self.sound ~= 0 then
        self.character:getEmitter():stopSound(self.sound)
    end

    local CarMaterials = self.CarMaterials
    for i = 1, #CarMaterials do
        local Materials = GetMaterialsList(self.character, CarMaterials[i][1])
        for j = 1, CarMaterials[i][2] do
            local ItemToDeleteID = Materials:get(j-1):getID()
            print(ItemToDeleteID)
            self.character:getInventory():removeItemWithIDRecurse(ItemToDeleteID)
        end
    end
    self.BlowTorch:setDelta(0)

    self.character:getXp():AddXP(Perks.MetalWelding, 40*4)

    sendClientCommand(self.character, "vehicle", "SpawnCarFrame", { vehicle = self.vehicle })
    ISBaseTimedAction.perform(self)
end


function CraftVehicleAction:new(character, CarMaterials, BlowTorch, time, vehicle)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.stopOnWalk = true
    o.stopOnRun = true
    o.character = character
    o.maxTime = time
    o.vehicle = vehicle
    o.CarMaterials = CarMaterials
    o.BlowTorch = BlowTorch

    if character:isTimedActionInstant() then o.maxTime = 10 end
    return o
end