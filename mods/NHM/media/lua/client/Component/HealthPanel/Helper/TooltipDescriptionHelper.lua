---@type TooltipDescriptionHelper
local tooltipDescriptionHelper = {
    defaultColors = {
        red = { r = 1, g = 1, b = 1 },
        green = { r = 0, g = 1, b = 0 },
        blue = { r = 0, g = 0, b = 1 },
        black = { r = 0, g = 0, b = 0 },
        white = { r = 1, g = 1, b = 1 },
    }
}

---@param color TooltipColor
---@param text string
---@return string
function tooltipDescriptionHelper:getTextWithRGBColor(text, color)
    return string.format('<RGB:%d,%d,%d> %s', color.r, color.g, color.b, text)
end

---@param perk PerkFactory.Perk
---@param currentLevel number
---@param requiredLevel number
function tooltipDescriptionHelper:getRequiredPerkLabel(perk, currentLevel, requiredLevel)
    local title = getText('IGUI_perks_' .. perk:getType():toString())

    return string.format('%s %d/%d', title, currentLevel, requiredLevel)
end

return tooltipDescriptionHelper
