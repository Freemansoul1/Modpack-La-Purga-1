require 'TimedActions/ISBaseTimedAction'

local action = ISBaseTimedAction:derive('TransfuseAction')

function action:isValid()
    if ISHealthPanel.DidPatientMove(self.character, self.otherPlayer, self.patientPositionX, self.patientPositionY) then
        return false
    end

    return self.character:getInventory():contains(self.item)
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

    self.item:setJobDelta(self:getJobDelta())
    self.item:setJobType(self.jobType)

    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, self, self.jobType, { transfuse = true })

    self.character:setMetabolicTarget(Metabolics.LightDomestic)
end

function action:start()
    self.item:setJobDelta(0.0)
    self.item:setJobType(self.jobType)

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

    self.item:setJobDelta(0.0)
end

function action:perform()
    ISBaseTimedAction.perform(self)

    self.item:setJobDelta(0.0)

    if self.character:HasTrait('Hemophobic') then
        self.character:getStats():setPanic(self.character:getStats():getPanic() + 50)
    end

    local healthModifierByItemFullType = {
        ['NHM.AdrenalineInjector'] = 1.8,
        ['NHM.FullBloodBag'] = 1.3,
        ['NHM.SalineBag'] = 0.8,
        ['NHM.SalineBag1'] = 0.8,
    }

    local modifier = healthModifierByItemFullType[self.item:getFullType()]
    self.otherPlayer:getBodyDamage():AddGeneralHealth(100 * modifier)

    self.item:Use()

    if isClient() then
        local args = { characterOnlineID = self.character:getOnlineID(), otherPlayerOnlineID = self.otherPlayer:getOnlineID(), modifier = modifier}
        sendClientCommand(self.character, 'NewHope', 'onTransfuse', args)
    end

    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, nil, nil, nil)
end

---@return TransfuseAction
function action:new(doctor, patient, bodyPart, item)
    ---@class TransfuseAction
    local public = {}
    setmetatable(public, self)
    self.__index = self

    public.character = doctor
    public.otherPlayer = patient
    public.doctorLevel = doctor:getPerkLevel(Perks.Doctor)
    public.bodyPart = bodyPart
    public.item = item
    public.stopOnWalk = true
    public.stopOnRun = true
    public.patientPositionX = patient:getX()
    public.patientPositionY = patient:getY()
    public.jobType = getText('UI_ContextMenu_Apply')
    public.maxTime = 400

    public.maxTime = public.maxTime - (public.doctorLevel * 4)
    if doctor:isTimedActionInstant() then
        public.maxTime = 1
    end

    if doctor:getAccessLevel() ~= 'None' then
        public.doctorLevel = 10
    end

    if item:getFullType() == 'NHM.AdrenalineInjector' then
        public.stopOnWalk = false
        public.stopOnRun = false
    end

    return public
end

return action