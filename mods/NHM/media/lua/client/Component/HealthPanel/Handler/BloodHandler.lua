local baseHandler = require('Component/HealthPanel/Proxy/BaseHandlerProxy')
local tooltipHelper = require('Component/HealthPanel/Helper/TooltipDescriptionHelper')
local transfuseAction = require('Component/HealthPanel/Action/TransfuseAction')

local var = {
    requiredDoctorLevelByItemFullType = {
        ['NHM.AdrenalineInjector'] = 3,
        ['NHM.SalineBag'] = 1,
        ['NHM.SalineBag1'] = 0,
        ['NHM.FullBloodBag'] = 2,
    },
    allowedItemTypes = {
        ['NHM.AdrenalineInjector'] = true,
        ['NHM.SalineBag'] = true,
        ['NHM.SalineBag1'] = true,
        ['NHM.FullBloodBag'] = true,
    },
    maxHealthPercentageByItemFullType = {
        ['NHM.AdrenalineInjector'] = 30,
        ['NHM.SalineBag'] = 90,
        ['NHM.SalineBag1'] = 90,
        ['NHM.FullBloodBag'] = 50,
    },
}

---@type BloodHandler
local bloodHandler = baseHandler:derive('BloodHandler')

function bloodHandler:new(panel, bodyPart)
    ---@class BloodHandler
    local public = baseHandler.new(self, panel, bodyPart)
    public.items = {
        bags = {},
    }

    return public
end

function bloodHandler:checkItem(item)
    if var.allowedItemTypes[item:getFullType()] then
        self:addItem(self.items.bags, item)
    end
end

function bloodHandler:addToMenu(context)
    local types = self:getAllItemTypes(self.items.bags)
    if #types > 0 then
        local option = context:addOption(getText('UI_ContextMenu_Apply'), nil)
        local subMenu = context:getNew(context)
        context:addSubMenu(option, subMenu)

        local bodyDamage = self:getPatient():getBodyDamage()
        if self:getPatient() ~= self:getDoctor() then
            bodyDamage = self:getPatient():getBodyDamageRemote()
        end

        for i = 1, #types do
            if bodyDamage:getOverallBodyHealth() <= var.maxHealthPercentageByItemFullType[types[i]] then
                local item = self:getItemOfType(self.items.bags, types[i])
                local subMenuOption = subMenu:addOption(item:getName(), self, self.onMenuOptionSelected, types[i])

                local tooltip = ISToolTip:new()
                tooltip:initialise()
                tooltip:setVisible(false)
                tooltip:setName(item:getName())

                local isAvailable = false
                local doctorPerk = PerkFactory.getPerk(Perks.Doctor)
                local currentLevel = self:getDoctor():getPerkLevel(Perks.Doctor)

                local color = tooltipHelper.defaultColors.red
                if currentLevel >= var.requiredDoctorLevelByItemFullType[types[i]] then
                    color = tooltipHelper.defaultColors.green
                    isAvailable = true
                end

                local doctorLevelLabel = tooltipHelper:getRequiredPerkLabel(doctorPerk, currentLevel, var.requiredDoctorLevelByItemFullType[types[i]])
                tooltip.description = tooltip.description .. tooltipHelper:getTextWithRGBColor(doctorLevelLabel, color)

                subMenuOption.toolTip = tooltip
                subMenuOption.notAvailable = not isAvailable
            end
        end
    end
end

function bloodHandler:dropItems(items)
    local types = self:getAllItemTypes(items)

    local bodyDamage = self:getPatient():getBodyDamage()
    if self:getPatient() ~= self:getDoctor() then
        bodyDamage = self:getPatient():getBodyDamageRemote()
    end

    local currentLevel = self:getDoctor():getPerkLevel(Perks.Doctor)
    for i = 1, #types do
        local requiredLevel = var.requiredDoctorLevelByItemFullType[types[i]] or 11
        if currentLevel < requiredLevel then
            return false
        end

        if bodyDamage:getOverallBodyHealth() > var.maxHealthPercentageByItemFullType[types[i]] then
            return false
        end
    end

    if #self.items.bags > 0 then
        self:onMenuOptionSelected(types[1])
        return true
    end

    return false
end

function bloodHandler:isValid(itemType)
    self:checkItems()

    return self:getItemOfType(self.items.bags, itemType)
end

function bloodHandler:perform(previousAction, itemType)
    local item = self:getItemOfType(self.items.bags, itemType)
    previousAction = self:toPlayerInventory(item, previousAction)

    local action = transfuseAction:new(self:getDoctor(), self:getPatient(), self.bodyPart, item)
    ISTimedActionQueue.addAfter(previousAction, action)
end

return bloodHandler
