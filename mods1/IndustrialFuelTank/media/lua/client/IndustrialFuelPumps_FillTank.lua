local Action = ISBaseTimedAction:derive("IFP_FillFuel")

function Action:new(character, fuelStation, item, isRepeat)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.fuelStation = fuelStation
    o.square = fuelStation:getSquare()
    o.item = item
    o.stopOnWalk = true
    o.stopOnRun = true
    o.isRepeat = isRepeat
    o.maxTime = 111
    return o
end

function Action:isValid()
    return self.character:isPrimaryHandItem(self.item)
end

function Action:waitToStart()
    self.character:faceThisObject(self.fuelStation)
    return self.character:shouldBeTurning()
end

function Action:update()
    self.character:faceThisObject(self.fuelStation)
    local delta = self:getJobDelta()
    self.item:setJobDelta(delta)

    local df = self.dFuel * delta - self.fuelTransferred
    if df >= 1 then
        self:checkFuel(df)
    end

    self.character:setMetabolicTarget(Metabolics.HeavyDomestic)
end

function Action:start()

    self.dFuel = math.min(tonumber(self.fuelStation:getSprite():getProperties():Val("fuelAmount")) - tonumber(self.fuelStation:getPipedFuelAmount()),self.item:getRemainingUses())
    self.fuelTransferred = 0

    self.action:setTime(self.dFuel * 50)
    self:setActionAnim("refuelgascan")
    self:setOverrideHandModels(self.item:getStaticModel(),nil)

    self.sound = self.character:playSound("CanisterAddFuelSiphon")

end

function Action:stop()
    self.character:stopOrTriggerSound(self.sound)
    self.item:setJobDelta(0.0)

    self:checkFuel()

    ISBaseTimedAction.stop(self)
end

function Action:perform()
    self.character:stopOrTriggerSound(self.sound)
    self.item:setJobDelta(0)

    self:checkFuel()

    if self.isRepeat then IndustrialFuelPumps.onFillTank(self.character,self.fuelStation,nil,true) end

    ISBaseTimedAction.perform(self)
end

function Action:checkFuel(df) --java commands only accept int in v41.78, even though it is saved as double in modData
    df = math.floor(df or (self.dFuel * self:getJobDelta() - self.fuelTransferred))
    if df > 0 then
        for i = 1, df do
            self.item:Use()
        end
        self.fuelStation:setPipedFuelAmount(tonumber(self.fuelStation:getPipedFuelAmount()) + df)
        self.fuelTransferred = self.fuelTransferred + df
    end
end

IndustrialFuelPumps.FillTank = Action
