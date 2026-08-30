-- ***********************************************************
-- **              	  ROBERT JOHNSON                       **
-- ***********************************************************
ISLevelDisplay = ISPanel:derive("ISLevelDisplay");

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)

-- ************************************************************************--
-- ** ISLevelDisplay:initialise
-- **
-- ************************************************************************--

function ISLevelDisplay:initialise()
    ISPanel.initialise(self);
    local baseY = FONT_HGT_MEDIUM + 20
    local btnHeight = math.max(25, FONT_HGT_SMALL + 5)
    local btnWidth = getTextManager():MeasureStringX(UIFont.Small, self.expandButtonLabel)

    local paddingX = 10
    self.expandButton = ISButton:new(paddingX, baseY + FONT_HGT_SMALL + 5, btnWidth, btnHeight, self.expandButtonLabel,
        self, ISLevelDisplay.onExpandToggle);
    self.expandButton.internal = "TOGGLESTATS";
    self.expandButton.anchorTop = true
    self.expandButton.anchorBottom = false
    self.expandButton:initialise();
    self.expandButton:instantiate();
    self.expandButton.borderColor = {
        r = 1,
        g = 1,
        b = 1,
        a = 0.1
    };
    self:addChild(self.expandButton);
end

function ISLevelDisplay:onExpandToggle()
    self.expanded = not self.expanded
end

function ISLevelDisplay:update()

end

function ISLevelDisplay:updateData(playerData, killsNeeded)
    if not playerData.pzarpg then
        self.buffs = {}
        self.level = 'Player Level: NIL'
    else
        self.buffs = playerData.pzarpg.buffs
        self.level = 'Player Level: ' .. tostring(playerData.pzarpg.level)
    end

    self.killsToNextLevel = killsNeeded
end

function ISLevelDisplay:prerender()
    local y = 10;
    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r,
        self.backgroundColor.g, self.backgroundColor.b);
    self:drawRect(0, 0, self.width, y + FONT_HGT_MEDIUM, self.backgroundColor.a, self.backgroundColor.r,
        self.backgroundColor.g, self.backgroundColor.b);
    self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r,
        self.borderColor.g, self.borderColor.b);
    self:drawRectBorder(0, 0, self.width, y + FONT_HGT_MEDIUM, self.borderColor.a, self.borderColor.r,
        self.borderColor.g, self.borderColor.b);
    self:drawText("RPG Stats",
        self.width / 2 - (getTextManager():MeasureStringX(UIFont.Medium, "RPG Stats") / 2), y, 1, 1, 1, 1,
        UIFont.Medium);
end

function ISLevelDisplay.updatewidth(currWidth, stringData)
    local stringLen = getTextManager():MeasureStringX(UIFont.Small, stringData)
    if stringLen > currWidth then
        return stringLen
    end
    return currWidth + 20
end

function ISLevelDisplay:render()
    self.width = 100
    local paddingX = 5
    local runningY = FONT_HGT_MEDIUM + 20
    self.width = ISLevelDisplay.updatewidth(self.width, self.level)
    self:drawText(self.level, paddingX, runningY, 1, 1, 1, 1, UIFont.Small);
    runningY = runningY + FONT_HGT_SMALL + 20
    if (self.expanded) then
        runningY = runningY + FONT_HGT_SMALL
        local killsNeededText = ''

        if self.killsToNextLevel == -1 then
            killsNeededText = 'You reached Max level!'
        else
            killsNeededText = 'Kills needed for next level: ' .. tostring(self.killsToNextLevel)
        end
        self.width = ISLevelDisplay.updatewidth(self.width, killsNeededText)
        self:drawText(killsNeededText, paddingX, runningY, 1, 1, 1, 1, UIFont.Small);

        runningY = runningY + FONT_HGT_SMALL + 10

        if self.buffs then
            for k, buff in pairs(self.buffs) do
                local buffVal = buff.value
                local roundedVal = math.floor(buffVal * 100 + 0.5) / 100
                local buff = buff.display .. ': ' .. roundedVal
                self.width = ISLevelDisplay.updatewidth(self.width, buff)
                self:drawText(buff, paddingX, runningY, 1, 1, 1, 1, UIFont.Small);

                runningY = runningY + FONT_HGT_SMALL
            end
        end
    end
    self.height = runningY + FONT_HGT_MEDIUM + 5
end

-- ************************************************************************--
-- ** ISLevelDisplay:new
-- **
-- ************************************************************************--
function ISLevelDisplay:new(x, y, width, height, playerData, killsToNextLevel)
    local o = {}
    o = ISPanel:new(x, y, width, height);
    setmetatable(o, self)

    o.borderColor = {
        r = 0.4,
        g = 0.4,
        b = 0.4,
        a = 1
    };
    o.backgroundColor = {
        r = 0,
        g = 0,
        b = 0,
        a = 0.8
    };
    o.width = 100;
    o.height = 100;
    o.width = 100
    o.moveWithMouse = true;

    if not playerData.pzarpg then
        o.buffs = {}
        o.level = 'Player Level: NIL'
    else
        o.buffs = playerData.pzarpg.buffs
        o.level = 'Player Level: ' .. tostring(playerData.pzarpg.level)
    end

    o.killsToNextLevel = killsToNextLevel
    o.expanded = false
    o.expandButtonLabel = 'Toggle Stats'

    ISLevelDisplay.instance = o;
    return o;
end

function ISLevelDisplay.onOpen(playerData, killsToNextLevel)
    local ui = ISLevelDisplay:new(100, 100, 100, 100, playerData, killsToNextLevel)
    ui:initialise()
    ui:addToUIManager()
    ISLayoutManager.RegisterWindow('levelDisplay', ISLevelDisplay, ui)
    return ui
end

return ISLevelDisplay
