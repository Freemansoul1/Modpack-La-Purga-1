local baseHandler = require('Component/HealthPanel/Proxy/BaseHandlerProxy')
local tooltipHelper = require('Component/HealthPanel/Helper/TooltipDescriptionHelper')
local injectAntizinAction = require('Component/HealthPanel/Action/InjectAntizinAction')

local var = {
    allowedItemTypes = {
        ['NHM.AntizinTier3'] = true,
    },
    requiredDoctorLevelByItemType = {
        ['NHM.AntizinTier3'] = 8,
    },
}

---@type AntizinHandler
local antizinHandler = baseHandler:derive('AntizinHandler')

function antizinHandler:new(panel, bodyPart)
    ---@class AntizinHandler
    local public = baseHandler.new(self, panel, bodyPart)
    public.items = {
        antizin = {},
    }

    return public
end

function antizinHandler:checkItem(item)
    if var.allowedItemTypes[item:getFullType()] then
        self:addItem(self.items.antizin, item)
    end
end

function antizinHandler:addToMenu(context)
    local types = self:getAllItemTypes(self.items.antizin)
    if #types > 0 then
        local option = context:addOption(getText('UI_ContextMenu_Inject'), nil)
        local subMenu = context:getNew(context)
        context:addSubMenu(option, subMenu)

        for i = 1, #types do
            local item = self:getItemOfType(self.items.antizin, types[i])
            local subMenuOption = subMenu:addOption(item:getName(), self, self.onMenuOptionSelected, types[i])

            local tooltip = ISToolTip:new()
            tooltip:initialise()
            tooltip:setVisible(false)
            tooltip:setName(item:getName())

            local isAvailable = false
            local doctorPerk = PerkFactory.getPerk(Perks.Doctor)
            local currentLevel = self:getDoctor():getPerkLevel(Perks.Doctor)

            local color = tooltipHelper.defaultColors.red
            if currentLevel >= var.requiredDoctorLevelByItemType[types[i]] then
                color = tooltipHelper.defaultColors.green
                isAvailable = true
            end

            local doctorLevelLabel = tooltipHelper:getRequiredPerkLabel(doctorPerk, currentLevel, var.requiredDoctorLevelByItemType[types[i]])
            tooltip.description = tooltip.description .. tooltipHelper:getTextWithRGBColor(doctorLevelLabel, color)

            subMenuOption.toolTip = tooltip
            subMenuOption.notAvailable = not isAvailable
        end
    end
end

function antizinHandler:dropItems(items)
    local types = self:getAllItemTypes(items)

    local currentLevel = self:getDoctor():getPerkLevel(Perks.Doctor)
    for i = 1, #types do
        local requiredLevel = var.requiredDoctorLevelByItemType[types[i]] or 11
        if currentLevel < requiredLevel then
            return false
        end
    end

    if #self.items.antizin > 0 then
        self:onMenuOptionSelected(types[1])
        return true
    end

    return false
end

function antizinHandler:isValid(itemType)
    self:checkItems()

    return self:getItemOfType(self.items.antizin, itemType)
end

function antizinHandler:perform(previousAction, itemType)
    local item = self:getItemOfType(self.items.antizin, itemType)
    previousAction = self:toPlayerInventory(item, previousAction)

    local action = injectAntizinAction:new(self:getDoctor(), self:getPatient(), self.bodyPart, item)
    ISTimedActionQueue.addAfter(previousAction, action)
end

return antizinHandler
