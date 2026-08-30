local baseHandler = require('Component/HealthPanel/Proxy/BaseHandlerProxy')
local tooltipHelper = require('Component/HealthPanel/Helper/TooltipDescriptionHelper')
local virusTesterAction = require('Component/HealthPanel/Action/ApplyVirusTesterAction')

local var = {
    requiredDoctorLevel = 0,
}

---@type VirusTesterHandler
local virusTesterHandler = baseHandler:derive('VirusTesterHandler')

function virusTesterHandler:new(panel, bodyPart)
    ---@class VirusTesterHandler
    local public = baseHandler.new(self, panel, bodyPart)
    public.items = {
        testers = {},
    }

    return public
end

function virusTesterHandler:checkItem(item)
    if item:getFullType() == 'NHM.VirusTester' then
        self:addItem(self.items.testers, item)
    end
end

function virusTesterHandler:addToMenu(context)
    local types = self:getAllItemTypes(self.items.testers)
    if #types > 0 then
        local option = context:addOption(getText('UI_ContextMenu_Test'), nil)
        local subMenu = context:getNew(context)
        context:addSubMenu(option, subMenu)

        for i = 1, #types do
            local item = self:getItemOfType(self.items.testers, types[i])
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

function virusTesterHandler:dropItems(items)
    local currentLevel = self:getDoctor():getPerkLevel(Perks.Doctor)
    if currentLevel < var.requiredDoctorLevel then
        return false
    end

    local types = self:getAllItemTypes(items)
    if #self.items.testers > 0 then
        self:onMenuOptionSelected(types[1])
        return true
    end

    return false
end

function virusTesterHandler:isValid(itemType)
    self:checkItems()

    return self:getItemOfType(self.items.testers, itemType)
end

function virusTesterHandler:perform(previousAction, itemType)
    local item = self:getItemOfType(self.items.testers, itemType)
    previousAction = self:toPlayerInventory(item, previousAction)

    local action = virusTesterAction:new(self:getDoctor(), self:getPatient(), self.bodyPart, item)
    ISTimedActionQueue.addAfter(previousAction, action)
end

return virusTesterHandler
