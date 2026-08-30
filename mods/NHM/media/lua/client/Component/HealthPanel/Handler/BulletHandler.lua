local baseHandler = require('Component/HealthPanel/Proxy/BaseHandlerProxy')
local tooltipHelper = require('Component/HealthPanel/Helper/TooltipDescriptionHelper')

local var = {
    allowedToolTypes = {
        ['Base.SutureNeedleHolder'] = true,
        ['Base.Tweezers'] = true,
    },
    requiredDoctorLevels = {
        ['Base.SutureNeedleHolder'] = 2,
        ['Base.Tweezers'] = 2,
        ['Hands'] = 5,
    },
}

---@type RemoveBulletHandler
local removeBulletHandler = baseHandler:derive('RemoveBulletHandler')

function removeBulletHandler:new(panel, bodyPart)
    ---@class RemoveBulletHandler
    local public = baseHandler.new(self, panel, bodyPart)
    public.items = {
        tools = {},
    }

    return public
end

function removeBulletHandler:checkItem(item)
    if var.allowedToolTypes[item:getFullType()] then
        self:addItem(self.items.tools, item)
    end
end

function removeBulletHandler:addToMenu(context)
    if not self:isInjured() or not self.bodyPart:haveBullet() then
        return false
    end

    local option = context:addOption(getText('ContextMenu_Remove_Bullet'), nil)
    local subMenu = context:getNew(context)
    context:addSubMenu(option, subMenu)

    local subMenuOption
    local toolName
    if #self.items.tools > 0 then
        toolName = self.items.tools[1]:getFullType()
        subMenuOption = subMenu:addOption(self.items.tools[1]:getName(), self, self.onMenuOptionSelected, self.items.tools[1])
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
    if currentLevel >= var.requiredDoctorLevels[toolName] then
        color = tooltipHelper.defaultColors.green
        isAvailable = true
    end

    local doctorLevelLabel = tooltipHelper:getRequiredPerkLabel(doctorPerk, currentLevel, var.requiredDoctorLevels[toolName])
    tooltip.description = tooltip.description .. tooltipHelper:getTextWithRGBColor(doctorLevelLabel, color)

    subMenuOption.toolTip = tooltip
    subMenuOption.notAvailable = not isAvailable
end

function removeBulletHandler:dropItems(items)
    local types = self:getAllItemTypes(items)

    local currentLevel = self:getDoctor():getPerkLevel(Perks.Doctor)
    for i = 1, #types do
        local requiredLevel = var.requiredDoctorLevels[types[i]] or 11
        if currentLevel < requiredLevel then
            return false
        end
    end

    if #self.items.tools > 0 and #types == 1 and self:isInjured() and self.bodyPart:haveBullet() then
        self:onMenuOptionSelected(types[1])
        return true
    end

    return false
end

function removeBulletHandler:isValid(tool)
    if not self:isInjured() or not self.bodyPart:haveBullet() then
        return false
    end

    self:checkItems()

    return tool ~= nil
end

function removeBulletHandler:perform(previousAction, tool)
    if instanceof(tool, 'InventoryItem') then
        previousAction = self:toPlayerInventory(tool, previousAction)
    end

    local action = ISRemoveBullet:new(self:getDoctor(), self:getPatient(), self.bodyPart)
    ISTimedActionQueue.addAfter(previousAction, action)
end

return removeBulletHandler
