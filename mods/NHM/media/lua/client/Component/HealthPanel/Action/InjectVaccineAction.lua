require 'TimedActions/ISBaseTimedAction'
local vaccineEffect = require('Component/HealthPanel/Effect/VaccineEffect')

local action = ISBaseTimedAction:derive('InjectVaccineAction')

function action:isValid()
    if ISHealthPanel.DidPatientMove(self.character, self.otherPlayer, self.patientPositionX, self.patientPositionY) then
        return false
    end

    return self.character:getInventory():contains(self.vaccine)
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

    self.vaccine:setJobDelta(self:getJobDelta())
    self.vaccine:setJobType(self.jobType)

    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, self, self.jobType, { inject = true })

    self.character:setMetabolicTarget(Metabolics.LightDomestic)
end

function action:start()
    self.vaccine:setJobDelta(0.0)
    self.vaccine:setJobType(self.jobType)

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

    self.vaccine:setJobDelta(0.0)
end

function action:perform()
    ISBaseTimedAction.perform(self)

    self.vaccine:setJobDelta(0.0)

    if self.character:HasTrait('Hemophobic') then
        self.character:getStats():setPanic(self.character:getStats():getPanic() + 50)
    end


    self.vaccine:Use()

    if isClient() then
        local args = { characterOnlineID = self.character:getOnlineID(), otherPlayerOnlineID = self.otherPlayer:getOnlineID() }
        sendClientCommand(self.character, 'NewHope', 'onUpdateInfection', args)
    else vaccineEffect.apply(self.otherPlayer)
    end

    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, nil, nil, nil)
end

---@return InjectVaccineAction
function action:new(doctor, patient, bodyPart, vaccine)
    ---@class InjectVaccineAction
    local public = {}
    setmetatable(public, self)
    self.__index = self

    public.character = doctor
    public.otherPlayer = patient
    public.doctorLevel = doctor:getPerkLevel(Perks.Doctor)
    public.bodyPart = bodyPart
    public.vaccine = vaccine
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