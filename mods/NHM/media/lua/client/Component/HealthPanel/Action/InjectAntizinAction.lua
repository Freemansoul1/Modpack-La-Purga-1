require 'TimedActions/ISBaseTimedAction'

local action = ISBaseTimedAction:derive('InjectAntizinAction')

function action:isValid()
    if ISHealthPanel.DidPatientMove(self.character, self.otherPlayer, self.patientPositionX, self.patientPositionY) then
        return false
    end

    return self.character:getInventory():contains(self.antizin)
end

function action:waitToStart()
    if self.character == self.otherPlayer then
        return false
    end

    self.character:faceThisObject(self.otherPlayer)

    return self.character:shouldBeTurning()
end

function action:update()
    if self.character ~= self.otherPlayer then
        self.character:faceThisObject(self.otherPlayer)
    end

    self.antizin:setJobDelta(self:getJobDelta())
    self.antizin:setJobType(self.jobType)

    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, self, self.jobType, { inject = true })

    self.character:setMetabolicTarget(Metabolics.LightDomestic)
end

function action:start()
    self.antizin:setJobDelta(0.0)
    self.antizin:setJobType(self.jobType)

    if self.character == self.otherPlayer then
        self:setActionAnim(CharacterActionAnims.Bandage)
        self:setAnimVariable('BandageType', ISHealthPanel.getBandageType(self.bodyPart))
        self.character:reportEvent('EventBandage')
    else
        self:setActionAnim('Loot')
        self.character:SetVariable('LootPosition', 'Mid')
        self.character:reportEvent('EventLootItem')
    end

    self:setOverrideHandModels(nil, nil)
end

function action:stop()
    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, nil, nil, nil)
    ISBaseTimedAction.stop(self)

    self.antizin:setJobDelta(0.0)
end

function action:perform()
    ISBaseTimedAction.perform(self)

    self.antizin:setJobDelta(0.0)

    if self.character:HasTrait('Hemophobic') then
        self.character:getStats():setPanic(self.character:getStats():getPanic() + 50)
    end

    local infectionModifierByItemFullType = {
        ['NHM.AntizinTier1'] = 0.5,
        ['NHM.AntizinTier2'] = 0.7,
        ['NHM.AntizinTier3'] = 0.99,
    }

    local modifier = infectionModifierByItemFullType[self.antizin:getFullType()]
    local infectionMortalityDuration = self.otherPlayer:getBodyDamage():getInfectionMortalityDuration()
    local infectionTime = self.otherPlayer:getBodyDamage():getInfectionTime() + infectionMortalityDuration * modifier

    

    self.antizin:Use()

    if isClient() then
        local args = { characterOnlineID = self.character:getOnlineID(), otherPlayerOnlineID = self.otherPlayer:getOnlineID(), bodyPartIndex = self.bodyPart:getIndex(), modifier = modifier }
        sendClientCommand(self.character, 'NewHope', 'onUpdateInfectionTime', args)
    else
        if self.otherPlayer:getBodyDamage():getInfectionTime() >= 0 then
            self.otherPlayer:getBodyDamage():setInfectionTime(infectionTime)
        end
    
        if not self.otherPlayer:getBodyDamage():isInfected() then
            self.otherPlayer:getBodyDamage():setInfected(true)
        end
    end

    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, nil, nil, nil)
end

---@return InjectAntizinAction
function action:new(doctor, patient, bodyPart, antizin)
    ---@class InjectAntizinAction
    local public = {}
    setmetatable(public, self)
    self.__index = self

    public.character = doctor
    public.otherPlayer = patient
    public.doctorLevel = doctor:getPerkLevel(Perks.Doctor)
    public.bodyPart = bodyPart
    public.antizin = antizin
    public.stopOnWalk = true
    public.stopOnRun = true
    public.patientPositionX = patient:getX()
    public.patientPositionY = patient:getY()
    public.jobType = getText('UI_ContextMenu_Inject')
    public.maxTime = 400

    public.maxTime = public.maxTime - (public.doctorLevel * 4)
    if doctor:isTimedActionInstant() then
        public.maxTime = 1
    end

    if doctor:getAccessLevel() ~= 'None' then
        public.doctorLevel = 10
    end

    return public
end

return action