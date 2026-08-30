-- ************************************************************************
-- **        ██████  ██████   █████  ██    ██ ███████ ███    ██          **
-- **        ██   ██ ██   ██ ██   ██ ██    ██ ██      ████   ██          **
-- **        ██████  ██████  ███████ ██    ██ █████   ██ ██  ██          **
-- **        ██   ██ ██   ██ ██   ██  ██  ██  ██      ██  ██ ██          **
-- **        ██████  ██   ██ ██   ██   ████   ███████ ██   ████          **
-- ************************************************************************
-- ** All rights reserved. This content is protected by © Copyright law. **
-- ************************************************************************

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)

BB_RespawnPoints_List_UI = ISCollapsableWindow:derive("BB_RespawnPoints_List_UI")

function BB_RespawnPoints_List_UI:createChildren()
    ISCollapsableWindow.createChildren(self)

    local btnWidth = 160
    local btwnHeight = 30
    local x = (self:getWidth() / 2) - (btnWidth / 2)
    local y = (self:getHeight() - btwnHeight) - 20

    self.selectButton = ISButton:new(x, y, btnWidth, btwnHeight, getText("Select"), self, self.onSelectButtonMouseDown)
    self.selectButton.internal = "SELECT"
    self.selectButton:initialise()
    self.selectButton:instantiate()
    self:addChild(self.selectButton)
end

function BB_RespawnPoints_List_UI:onSelectButtonMouseDown(button, x, y)
    if button.internal == "SELECT" then

        if #RespawnableSBags.respawnPoints > 0 then
            for i, point in ipairs(RespawnableSBags.respawnPoints) do
                if i == self.respawnPointList.selected then
                    RespawnableSBags.respawnPoint = i
                    RespawnableSBags.respawnX = point.x
                    RespawnableSBags.respawnY = point.y
                    RespawnableSBags.respawnZ = point.z
                    break
                end
            end
        end
    end
end

function BB_RespawnPoints_List_UI:prerender()
    ISCollapsableWindow.prerender(self)
    self:drawTextCentre(getText("IGUI_Respawn_Points_List"), self.width / 2, 0, 1, 1, 1, 1, UIFont.Small)
end

function BB_RespawnPoints_List_UI:render()
    ISCollapsableWindow.render(self)
end

function BB_RespawnPoints_List_UI:close()
    self:setVisible(false)
    self:removeFromUIManager()
end

function BB_RespawnPoints_List_UI:new(character)
    local width, height = 800, 500
    local playerNum = character:getPlayerNum()
    local x = (getPlayerScreenWidth(playerNum) / 2) - (width / 2)
    local y = (getPlayerScreenHeight(playerNum) / 2) - (height / 2)

    local o = ISCollapsableWindow.new(self, x, y, width, height)
    o.chr = character
    o.playerNum = playerNum
    o.moveWithMouse = true
    o.anchorLeft = true
    o.anchorRight = true
    o.anchorTop = true
    o.anchorBottom = true
    return o
end

function BB_RespawnPoints_List_UI:initialise()
    ISCollapsableWindow.initialise(self)
    local btnHgt = FONT_HGT_SMALL + 2
    local y = 120

    self.respawnPointList = ISScrollingListBox:new(10, (y - 40), self.width - 20, self.height - (5 + btnHgt + 5) - y)
    self.respawnPointList:initialise()
    self.respawnPointList:instantiate()
    self.respawnPointList.itemheight = 50
    self.respawnPointList.selected = 0
    self.respawnPointList.joypadParent = self
    self.respawnPointList.font = UIFont.NewSmall
    self.respawnPointList.doDrawItem = self.drawRespawnPoints
    self.respawnPointList.drawBorder = true
    self.respawnPointList:addColumn(getText("Index"), 0)
    self.respawnPointList:addColumn(getText("Name"), 60)
    self.respawnPointList:addColumn(getText("Position"), 450)
    self:addChild(self.respawnPointList)
end

function BB_RespawnPoints_List_UI:populateList()
    self.respawnPointList:clear()

    local character = self.chr
    if not character then
        return
    end

    if #RespawnableSBags.respawnPoints ~= 0 then
        for i, point in ipairs(RespawnableSBags.respawnPoints) do
            local respawnPointName = "Respawn Point " .. string.char(64 + i)
            local positionStr = "X = " .. point.x .. ", Y = " .. point.y .. ", Z = " .. point.z
            self.respawnPointList:addItem(respawnPointName, { index = i, name = respawnPointName, position = positionStr })
        end
    end
end

function BB_RespawnPoints_List_UI:drawRespawnPoints(y, entry, alt)
    local a = 0.9
    self:drawRectBorder(0, (y), self:getWidth(), self.itemheight - 1, a, self.borderColor.r, self.borderColor.g, self.borderColor.b)

    self:drawRect(60, y, 1, self.itemheight, 0.5, 1, 1, 1)
    self:drawRect(450, y, 1, self.itemheight, 0.5, 1, 1, 1)

    if self.selected == entry.index then
        self:drawRect(0, (y), self:getWidth(), self.itemheight - 1, 0.3, 0.7, 0.35, 0.15)
    end

    self:drawText(tostring(entry.index), 10, y + 20, 1, 1, 1, a, UIFont.Medium)
    self:drawText(entry.item.name, 70, y + 20, 1, 1, 1, a, UIFont.Medium)
    self:drawText(entry.item.position, 460, y + 20, 1, 1, 1, a, UIFont.Medium)

    return y + self.itemheight
end