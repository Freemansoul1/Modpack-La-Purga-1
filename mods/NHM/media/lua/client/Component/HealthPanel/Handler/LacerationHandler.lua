local baseHandler = require('Component/HealthPanel/Proxy/BaseHandlerProxy')
local tooltipHelper = require('Component/HealthPanel/Helper/TooltipDescriptionHelper')
local stitchLacerationAction = require('Component/HealthPanel/Action/StitchLacerationAction')

local var = {
    allowedNeedleTypes = {
        ['Base.Needle'] = true,
        ['Base.SutureNeedle'] = true,
    },
    requiredDoctorLevel = 2,
}

---@type LacerationHandler
local lacerationHandler = baseHandler:derive('LacerationHandler')

function lacerationHandler:new(panel, bodyPart)
    ---@class LacerationHandler
    local public = baseHandler.new(self, panel, bodyPart)
    public.items = {
        needles = {},
        threads = {},
    }

    return public
end

function lacerationHandler:checkItem(item)
    if var.allowedNeedleTypes[item:getFullType()] then
        self:addItem(self.items.needles, item)
    end

    if item:getFullType() == 'Base.Thread' then
        self:addItem(self.items.threads, item)
    end
end

function lacerationHandler:addToMenu(context)
    if not self:isInjured() or not self.bodyPart:isCut() then
        return false
    end

    local needle = self.items.needles[1]
    local thread = self.items.threads[1]
    if needle == nil or (needle:getFullType() == 'Base.Needle' and thread == nil) then
        return
    end

    local option = context:addOption(getText('ContextMenu_Stitch'), nil)
    local subMenu = context:getNew(context)
    context:addSubMenu(option, subMenu)
    local subMenuOption = subMenu:addOption(needle:getName(), self, self.onMenuOptionSelected, needle, thread)

    local tooltip = ISToolTip:new()
    tooltip:initialise()
    tooltip:setVisible(false)
    tooltip:setName(needle:getName())

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

function lacerationHandler:dropItems(items)
    if not self:isInjured() or not self.bodyPart:isCut() then
        return false
    end

    local currentLevel = self:getDoctor():getPerkLevel(Perks.Doctor)
    if currentLevel < var.requiredDoctorLevel then
        return false
    end

    local needle = self:getItemOfType(self.items.needles, 'Base.SutureNeedle') or self:getItemOfType(self.items.needles, 'Base.Needle')
    local thread = self:getItemOfType(self.items.threads, 'Base.Thread')

    if needle == nil or (needle:getFullType() == 'Base.Needle' and thread == nil) then
        return false
    end

    self:onMenuOptionSelected(needle, thread)

    return true
end

function lacerationHandler:isValid(needle, thread)
    if not self:isInjured() or not self.bodyPart:isCut() then
        return false
    end

    local needle = self:getItemOfType(self.items.needles, 'Base.SutureNeedle') or self:getItemOfType(self.items.needles, 'Base.Needle')
    local thread = self:getItemOfType(self.items.threads, 'Base.Thread')

    if needle == nil or (needle:getFullType() == 'Base.Needle' and thread == nil) then
        return false
    end

    return true
end

function lacerationHandler:perform(previousAction, needle, thread)
    if needle ~= nil then
        previousAction = self:toPlayerInventory(needle, previousAction)
        end
        if thread ~= nil then 
        previousAction = self:toPlayerInventory(thread, previousAction)
        end

    local action = stitchLacerationAction:new(self:getDoctor(), self:getPatient(), self.bodyPart, needle, thread)
    ISTimedActionQueue.addAfter(previousAction, action)
end

return lacerationHandler
