require "ISOriginals"

--- @param self ISToolTipInv
local function renderSkills(self)
    --- if not our mod, just return
    if not (self.item:isCustomName() and self.item:getModName() == "Purga Skills") then return end

    ---print("Purga Skills Tooltip")

    local tooltip = self.tooltip
    local ttlayout = tooltip:beginLayout()
    ttlayout:setMinLabelWidth(90)

    --- get exp book's saver and show in the centre
    tooltip:DrawTextCentre(
            UIFont.AutoNormLarge,
            "Alma de " .. self.item:getLockedBy(),
            tooltip:getWidth() / 2,
            tooltip:getHeight() + 3,
            0.0, 2.5, 2.0, 1.0
    )
    tooltip:DrawTextCentre(
        UIFont.AutoNormSmall,
        "Hora de la muerte: " .. self.item:getModData().PurgaSkills.gametime.hour .. ":" .. self.item:getModData().PurgaSkills.gametime.minute .. " ",
        tooltip:getWidth() / 2,
        tooltip:getHeight() + 30,
        2.5, 2.5, 2.5, 1.0
    )
    tooltip:DrawTextCentre(
        UIFont.AutoNormSmall,
        "Dia de la muerte: " .. self.item:getModData().PurgaSkills.gametime.day .. "-" .. self.item:getModData().PurgaSkills.gametime.month .. "-" .. self.item:getModData().PurgaSkills.gametime.year .. " ",
        tooltip:getWidth() / 2,
        tooltip:getHeight() + 45,
        2.5, 2.5, 2.5, 1.0
    )
    tooltip:DrawTextCentre(
        UIFont.AutoNormSmall,
        "Ofrece esta reliquia",
        tooltip:getWidth() / 2,
        tooltip:getHeight() + 76,
        2.5, 2.5, 0.0, 1.0
    )
    tooltip:DrawTextCentre(
        UIFont.AutoNormSmall,
        "al Senor Oscuro.",
        tooltip:getWidth() / 2,
        tooltip:getHeight() + 88,
        2.5, 2.5, 0.0, 1.0
    )
    tooltip:DrawTextCentre(
        UIFont.AutoNormMedium,
        "Prohibido robar o destruir",
        tooltip:getWidth() / 2,
        tooltip:getHeight() + 110,
        2.5, 0.0, 0.0, 1.0
    )
    tooltip:DrawTextCentre(
        UIFont.AutoNormMedium,
        "si no eres su propietario",
        tooltip:getWidth() / 2,
        tooltip:getHeight() + 122,
        2.5, 0.0, 0.0, 1.0
    )

    local lastheight = tooltip:getHeight() + 140

    tooltip:endLayout(ttlayout)
    tooltip:setHeight(lastheight + getClassFieldVal(tooltip,getClassField(tooltip,9)))

    if tooltip:getWidth() < 150.0 then
        tooltip:setWidth(150.0)
    end
end

---@param self ISToolTipInv
ISToolTipInv.render = function(self)
    ---ISOriginal.origTooltipRender(self)

    --- idk, follow original code
    if ISContextMenu.instance and ISContextMenu.instance.visibleCheck then return end

    local mx = getMouseX() + 24;
    local my = getMouseY() + 24;
    if not self.followMouse then
        mx = self:getX()
        my = self:getY()
        if self.anchorBottomLeft then
            mx = self.anchorBottomLeft.x
            my = self.anchorBottomLeft.y
        end
    end

    self.tooltip:setX(mx+11);
    self.tooltip:setY(my);

    self.tooltip:setWidth(50)
    self.tooltip:setMeasureOnly(true)
    self.item:DoTooltip(self.tooltip);
    renderSkills(self)
    self.tooltip:setMeasureOnly(false)

    --- clampy x, y

    local myCore = getCore();
    local maxX = myCore:getScreenWidth();
    local maxY = myCore:getScreenHeight();

    local tw = self.tooltip:getWidth();
    local th = self.tooltip:getHeight();

    self.tooltip:setX(math.max(0, math.min(mx + 11, maxX - tw - 1)));
    if not self.followMouse and self.anchorBottomLeft then
        self.tooltip:setY(math.max(0, math.min(my - th, maxY - th - 1)));
    else
        self.tooltip:setY(math.max(0, math.min(my, maxY - th - 1)));
    end

    self:setX(self.tooltip:getX() - 11);
    self:setY(self.tooltip:getY());
    self:setWidth(tw + 11);
    self:setHeight(th);

    if self.followMouse then
        self:adjustPositionToAvoidOverlap({ x = mx - 24 * 2, y = my - 24 * 2, width = 24 * 2, height = 24 * 2 })
    end

    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
    self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
    self.item:DoTooltip(self.tooltip);
    renderSkills(self)
end