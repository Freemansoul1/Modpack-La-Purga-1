local baseHandler = require('Component/HealthPanel/Proxy/BaseHandlerProxy')
local tooltipHelper = require('Component/HealthPanel/Helper/TooltipDescriptionHelper')

local var = {
    allowedToolTypes = {
        'Base.SutureNeedleHolder',
        'Base.Tweezers',
    },
    requiredDoctorLevel = 0,
}

---@type RemoveGlassHandler
local removeGlassHandler = baseHandler:derive('RemoveGlassHandler')

function removeGlassHandler:new(panel, bodyPart)
    ---@class RemoveGlassHandler
    local public = baseHandler.new(self, panel, bodyPart)
    public.items = {
        tools = {},
    }

    return public
end

function removeGlassHandler:checkItem(item)
    if var.allowedToolTypes[item:getFullType()] then
        self:addItem(self.items.tools, item)
    end
end

function removeGlassHandler:addToMenu(context)
    if not self:isInjured() or not self.bodyPart:haveGlass() then
        return false
    end

    local option = context:addOption(getText('ContextMenu_Remove_Glass'), nil)
    local subMenu = context:getNew(context)
    context:addSubMenu(option, subMenu)

    local subMenuOption
    local toolName
    if #self.items.tools > 0 then
        toolName = self.items.tools[1]:getFullType()
        subMenuOption = subMenu:addOption(toolName, self, self.onMenuOptionSelected, self.items.tools[1])
    else
        toolName = 'Hands'
        subMenuOption = subMenu:addOption(getText('ContextMenu_Hand'), self, self.onMenuOptionSelected, toolName)
    end

    local tooltip = ISToolTip:new()
    tooltip:initialise()
    tooltip:setVisible(false)
    tooltip:setName(toolName)

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

function removeGlassHandler:dropItems(items)
    local types = self:getAllItemTypes(items)

    if #self.items.tools > 0 and #types == 1 and self:isInjured() and self.bodyPart:haveGlass() then
        self:onMenuOptionSelected(types[1])
        return true
    end

    return false
end

function removeGlassHandler:isValid(tool)
    if not self:isInjured() or not self.bodyPart:haveGlass() then
        return false
    end

    self:checkItems()

    return tool ~= nil
end

function removeGlassHandler:perform(previousAction, tool)
    local action
    if instanceof(tool, 'InventoryItem') then
        previousAction = self:toPlayerInventory(tool, previousAction)
        action = ISRemoveGlass:new(self:getDoctor(), self:getPatient(), self.bodyPart, true)
        ISTimedActionQueue.addAfter(previousAction, action)

        return
    end

    action = ISRemoveGlass:new(self:getDoctor(), self:getPatient(), self.bodyPart)
    ISTimedActionQueue.add(action)
end

return removeGlassHandler
