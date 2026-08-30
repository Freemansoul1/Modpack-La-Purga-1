DupeA = DupeA or {}
ISDupeListPanel = ISPanel:derive("ISDupeListPanel")

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)

function ISDupeListPanel:initialise()
    ISPanel.initialise(self)
    local btnWid = 100
    local btnHgt = math.max(25, FONT_HGT_SMALL + 3 * 2)
    local btnHgt2 = FONT_HGT_SMALL + 2 * 2
    local padBottom = 10

    local listY = 20 + FONT_HGT_MEDIUM + 20
    self.dupeList = ISScrollingListBox:new(10, listY, self.width - 20, (FONT_HGT_SMALL + 2 * 2) * 16)
    self.dupeList:initialise()
    self.dupeList:instantiate()
    self.dupeList.itemheight = FONT_HGT_SMALL + 2 * 2
    self.dupeList.selected = 0
    self.dupeList.joypadParent = self
    self.dupeList.font = UIFont.NewSmall
    self.dupeList.doDrawItem = self.drawList
    self.dupeList.drawBorder = true
    self:addChild(self.dupeList)

    local buttonLine1 = self.dupeList.y + self.dupeList.height + 35
    local buttonLine2 = buttonLine1 - 30

    self.areapanelBtn = ISButton:new(self.dupeList.x, buttonLine1, 70, btnHgt, getText("IGUI_DupeAnalyzer_SelectZone"), self, ISDupeListPanel.onClick)
    self.areapanelBtn.internal = "AREAPANEL"
    self.areapanelBtn:initialise()
    self.areapanelBtn:instantiate()
    self.areapanelBtn.borderColor = {r=1, g=1, b=1, a=0.1}
    self:addChild(self.areapanelBtn)

    self.delItemBtn = ISButton:new(self.dupeList.x + 80, buttonLine1, 70, btnHgt, getText("IGUI_DupeAnalyzer_DeleteItem"), self, ISDupeListPanel.onClick)
    self.delItemBtn.internal = "DELETEITEM"
    self.delItemBtn:initialise()
    self.delItemBtn:instantiate()
    self.delItemBtn.borderColor = {r=1, g=1, b=1, a=0.1}
    self:addChild(self.delItemBtn)

    self.teleportItemBtn = ISButton:new(self.dupeList.x + 160, buttonLine1, 100, btnHgt, getText("IGUI_DupeAnalyzer_TeleportItem"), self, ISDupeListPanel.onClick)
    self.teleportItemBtn.internal = "TELEPORTITEM"
    self.teleportItemBtn:initialise()
    self.teleportItemBtn:instantiate()
    self.teleportItemBtn.borderColor = {r=1, g=1, b=1, a=0.1}
    self:addChild(self.teleportItemBtn)

    self.teleportCopyBtn = ISButton:new(self.dupeList.x + 160, buttonLine2, 100, btnHgt, getText("IGUI_DupeAnalyzer_TeleportCopy"), self, ISDupeListPanel.onClick)
    self.teleportCopyBtn.internal = "TELEPORTCOPY"
    self.teleportCopyBtn:initialise()
    self.teleportCopyBtn:instantiate()
    self.teleportCopyBtn.borderColor = {r=1, g=1, b=1, a=0.1}
    self:addChild(self.teleportCopyBtn)

    self.no = ISButton:new(self.dupeList.x + self.dupeList.width - 110, buttonLine1, btnWid, btnHgt, getText("IGUI_DupeAnalyzer_Close"), self, ISDupeListPanel.onClick)
    self.no.internal = "OK"
    self.no:initialise()
    self.no:instantiate()
    self.no.borderColor = {r=1, g=1, b=1, a=0.1}
    self:addChild(self.no)

    --Panel height defined here based on Cancel button
    self:setHeight(self.no:getBottom() + padBottom)

    self:populateList()
end

function ISDupeListPanel:populateList()
    self.dupeList:clear()

    local dupeTable = ISDupeListPanel:requestDupeData()
    for i, dupe in pairs(dupeTable.items) do
        local item = dupe.item
        local itemID = dupe.id
        local name = item:getType()
        local dupes = {}
        local containerName = ""
        -- Check if container is not null, because some times items on floor do not return the floor as container, bugged maybe.
        if item:getContainer() then
            containerName = item:getContainer():getType()
            if DupeA.IsItemMoved(item:getContainer()) then
                containerName = "MOVED"
            end
        end
        local containerItems = ""
        if item:getCategory() == "Container" then
            containerItems = " - EMPTY - "
            if item:getItemContainer():getItems():size() > 0 then
                containerItems = " - WITH ITEMS - "
            end
        end

        local itemName = itemID .. " " .. name
        local itemCoord = "x:  " .. dupe.x .. "  y:  " .. dupe.y .. "  z:  " .. dupe.z .. ""
        local originalCoord = "COPY ON: x:  " .. dupe.xo .. "  y:  " .. dupe.yo .. "  z:  " .. dupe.zo .. ""

        dupes.title = itemName .. " -> " .. itemCoord .. containerItems .. "  - ON: " .. containerName .. "     -> " .. originalCoord
        dupes.dupe = dupe
        self.dupeList:addItem(i, dupes)
    end
end

function ISDupeListPanel:requestDupeData()
    self.DupeData = DupeA.dupes
    return self.DupeData
end

function ISDupeListPanel:drawList(y, item, alt)
    local a = 0.9
    self:drawRectBorder(0, (y), self:getWidth(), self.itemheight - 1, a, self.borderColor.r, self.borderColor.g, self.borderColor.b)
    if self.selected == item.index then
        self:drawRect(0, (y), self:getWidth(), self.itemheight - 1, 0.3, 0.7, 0.35, 0.15)
    end
    self:drawText(item.item.title, 10, y + 2, 1, 1, 1, a, self.font)
    return y + self.itemheight
end

function ISDupeListPanel:prerender()
    local z = 2
    local splitPoint = 100
    local x = 10
    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b)
    self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b)
    self:drawText(getText("IGUI_DupeAnalyzer_Title"), self.width/2 - (getTextManager():MeasureStringX(UIFont.Medium, getText("IGUI_WipeZone_Title")) / 2), z, 1,1,1,1, UIFont.Medium)

    local dupes = DupeA.dupes.items
    self:drawText(getText("IGUI_DupeAnalyzer_SearchedLabel"), x, z,1,1,1,1,UIFont.Small)
    self:drawText(DupeA.dupes.count .. "", splitPoint, z,1,1,1,1,UIFont.Small)

    z = z + FONT_HGT_SMALL + 2
    self:drawText(getText("IGUI_DupeAnalyzer_FoundLabel"), x, z,1,1,1,1,UIFont.Small)
    self:drawText(#dupes .. "", splitPoint, z,1,1,1,1,UIFont.Small)

    z = z + FONT_HGT_SMALL + 2
    self:drawText(getText("IGUI_DupeAnalyzer_CoordsLabel"), x, z,1,1,1,1,UIFont.Small)
    self:drawText(DupeA.dupes.coords .. "", splitPoint - 40, z,1,1,1,1,UIFont.Small)

end

function ISDupeListPanel:updateButtons()
    local deleteActive = false
    local teleportActive = false
    if self.dupeList.selected > 0 then
        teleportActive = true
        if self.selectedItem then
            if self.selectedItem:getCategory() ~= "Container" then
                deleteActive = true
            else
                local container = self.selectedItem:getItemContainer()
                if container then
                    if container:getItems():size() == 0 then
                        deleteActive = true
                    end
                end
            end
        end
    end
    self.delItemBtn.enable = deleteActive
    self.teleportItemBtn.enable = teleportActive
    self.teleportCopyBtn.enable = teleportActive
end

function ISDupeListPanel:render()
    self:updateButtons()

    if self.dupeList.selected > 0 then
        self.selectedItem = self.dupeList.items[self.dupeList.selected].item.dupe.item
        self.selectedDupe = self.dupeList.items[self.dupeList.selected].item.dupe
    else
        self.selectedItem = nil
        self.selectedDupe = nil
    end
end

function ISDupeListPanel:onClick(button)
    if button.internal == "OK" then
        DupeA.ResetDupes()
        self:setVisible(false)
        self:removeFromUIManager()
    end
    if button.internal == "AREAPANEL" then
        local selectAreaPanel = ISAddDupeZoneUI:new(10,10, 400, 350, self.player)
        selectAreaPanel:initialise()
        selectAreaPanel:addToUIManager()
        selectAreaPanel.parentUI = self
        self:setVisible(false)
    end

    if button.internal == "DELETEITEM" then
        if self.selectedItem then
            local index = self.dupeList.selected
            DupeA.DeleteItem(self.selectedItem, index)
            self.dupeList.selected = 0
            self:populateList()
        end
    end

    if button.internal == "TELEPORTITEM" then
        local dupe = self.selectedDupe
        if dupe then
            SendCommandToServer("/teleportto " .. dupe.x .. "," .. dupe.y .. "," .. dupe.z)
        end
    end

    if button.internal == "TELEPORTCOPY" then
        local dupe = self.selectedDupe
        if dupe then
            SendCommandToServer("/teleportto " .. dupe.xo .. "," .. dupe.yo .. "," .. dupe.zo)
        end
    end
end

function ISDupeListPanel:new(x, y, width, height, player)
    DupeA.ResetDupes()
    local o = {}
    x = getCore():getScreenWidth() / 2 - (width / 2)
    y = getCore():getScreenHeight() / 2 - (height / 2)
    o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1}
    o.backgroundColor = {r=0, g=0, b=0, a=0.8}
    o.width = width
    o.height = height
    o.player = player
    o.moveWithMouse = true
    ISDupeListPanel.instance = o
    o.buttonBorderColor = {r=0.7, g=0.7, b=0.7, a=0.5}
    o.DupeData = DupeA.dupes
    o.startX = nil
    o.endX = nil
    o.startY = nil
    o.endY = nil
    return o
end
