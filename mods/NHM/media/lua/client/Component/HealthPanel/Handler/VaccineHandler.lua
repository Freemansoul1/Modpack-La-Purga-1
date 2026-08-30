local baseHandler = require('Component/HealthPanel/Proxy/BaseHandlerProxy')
local tooltipHelper = require('Component/HealthPanel/Helper/TooltipDescriptionHelper')
local injectVaccineAction = require('Component/HealthPanel/Action/InjectVaccineAction')

local var = {
    requiredDoctorLevel = 5,
}

---@type VaccineHandler
local vaccineHandler = baseHandler:derive('VaccineHandler')

function vaccineHandler:new(panel, bodyPart)
    ---@class VaccineHandler
    local public = baseHandler.new(self, panel, bodyPart)
    public.items = {
        vaccine = {},
    }

    return public
end

function vaccineHandler:checkItem(item)
    if item:getFullType() == 'NHM.Vaccine' then
        self:addItem(self.items.vaccine, item)
    end
end

function vaccineHandler:addToMenu(context)
    local types = self:getAllItemTypes(self.items.vaccine)
    if #types > 0 then
        local option = context:addOption(getText('UI_ContextMenu_Inject'), nil)
        local subMenu = context:getNew(context)
        context:addSubMenu(option, subMenu)

        for i = 1, #types do
            local item = self:getItemOfType(self.items.vaccine, types[i])
            local subMenuOption = subMenu:addOption(item:getName(), self, self.onMenuOptionSelected, types[i])

            local tooltip = ISToolTip:new()
            tooltip:initialise()
            tooltip:setVisible(false)
            tooltip:setName(item:getName())

            local isAvailable = false
            local doctorPerk = PerkFactory.getPerk(Perks.Doctor)
            local currentLevel = self:getDoctor():getPerkLevel(Perks.Doctor)

            local color = tooltipHelper.defaultColors.red
            if currentLevel >= var.requiredDoctorLevel then
                color = tooltipHelper.defaultColors.green
                isAvailable = true
            end

            local doctorLevelLabel = tooltipHelper:getRequiredPerkLabel(doctorPerk, currentLevel, var.requiredDoctorLevel)
            tooltip.description = tooltip.description .. tooltipHelper:getTextWithRGBColor(doctorLevelLabel, color)

            subMenuOption.toolTip = tooltip
            subMenuOption.notAvailable = not isAvailable
        end
    end
end

function vaccineHandler:dropItems(items)
    local currentLevel = self:getDoctor():getPerkLevel(Perks.Doctor)
    if currentLevel < var.requiredDoctorLevel then
        return false
    end

    local types = self:getAllItemTypes(items)
    if #self.items.vaccine > 0 then
        self:onMenuOptionSelected(types[1])
        return true
    end

    return false
end

function vaccineHandler:isValid(itemType)
    self:checkItems()

    return self:getItemOfType(self.items.vaccine, itemType)
end

function vaccineHandler:perform(previousAction, itemType)
    local item = self:getItemOfType(self.items.vaccine, itemType)
    previousAction = self:toPlayerInventory(item, previousAction)

    local action = injectVaccineAction:new(self:getDoctor(), self:getPatient(), self.bodyPart, item)
    ISTimedActionQueue.addAfter(previousAction, action)
end

return vaccineHandler
