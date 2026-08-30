-- New UI Class: ISSpectatePanelUI
ISSpectatePanelUI = ISCollapsableWindow:derive("ISSpectatePanelUI")
local SpectateUtils = require("Spectate_Utils")

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)

local HEADER_HGT = FONT_HGT_SMALL + 2 * 2

--************************************************************************--
--** ISSpectatePanelUI:initialise
--**
--************************************************************************--

function ISSpectatePanelUI:createChildren()
    ISCollapsableWindow.createChildren(self)
    local btnWid = 100
    local btnHgt = math.max(25, FONT_HGT_SMALL + 3 * 2)
    local padBottom = 40

    local y = 20 + FONT_HGT_MEDIUM + HEADER_HGT
    self.datas = ISScrollingListBox:new(10, y, self.width - 20, self.height - padBottom - btnHgt - padBottom - y)
    self.datas:initialise();
    self.datas:instantiate();
    self.datas.itemheight = FONT_HGT_SMALL + 2 * 2;
    self.datas.selected = 0;
    self.datas.joypadParent = self;
    self.datas.font = UIFont.NewSmall;
    self.datas.doDrawItem = self.drawDatas;
    self.datas.drawBorder = true;
    self:addChild(self.datas);

    self.no = ISButton:new(10, self:getHeight() - padBottom - btnHgt - 23, btnWid, btnHgt, getText("UI_Cancel"), self,
        ISSpectatePanelUI.onClick);
    self.no.internal = "CANCEL";
    self.no.anchorTop = false
    self.no.anchorBottom = true
    self.no:initialise();
    self.no:instantiate();
    self.no.borderColor = { r = 1, g = 1, b = 1, a = 1 };
    self:addChild(self.no);

    self.refreshBtn = ISButton:new(10, self.no:getBottom() + 15, btnWid, btnHgt, getText("IGUI_DbViewer_Refresh"), self,
        ISSpectatePanelUI.onClick);
    self.refreshBtn.internal = "REFRESH";
    self.refreshBtn.anchorTop = false
    self.refreshBtn.anchorBottom = true
    self.refreshBtn:initialise();
    self.refreshBtn:instantiate();
    self.refreshBtn.borderColor = { r = 1, g = 1, b = 1, a = 1 };
    self:addChild(self.refreshBtn);

    self.spectateBtn = ISButton:new(self:getWidth() - btnWid - 10, self.no.y, btnWid,
        btnHgt, "Spectate", self, ISSpectatePanelUI.onClick);
    self.spectateBtn.internal = "SPECTATE";
    self.spectateBtn.anchorTop = false
    self.spectateBtn.anchorBottom = true
    self.spectateBtn:initialise();
    self.spectateBtn:instantiate();
    self.spectateBtn.borderColor = { r = 1, g = 1, b = 1, a = 1 };
    self:addChild(self.spectateBtn);

    self.stopSpectateBtn = ISButton:new(self.spectateBtn.x, self.spectateBtn:getBottom() + 15, btnWid,
        btnHgt, "Stop Spectating", self, ISSpectatePanelUI.onClick);
    self.stopSpectateBtn.internal = "STOPSPECTATE";
    self.stopSpectateBtn.anchorTop = false
    self.stopSpectateBtn.anchorBottom = true
    self.stopSpectateBtn:initialise();
    self.stopSpectateBtn:instantiate();
    self.stopSpectateBtn.borderColor = { r = 1, g = 1, b = 1, a = 1 };
    self:addChild(self.stopSpectateBtn);

    self.favBtn = ISButton:new(self:getWidth() - 50, 20, 30, 30, "", self,
        ISSpectatePanelUI.onClick)
    self.favBtn.internal = "FAVORITE";
    self.favBtn:initialise()
    self.favBtn:instantiate()
    self.favBtn:setImage(getTexture("media/ui/favBtn.png"))
    self.favBtn.borderColor = { r = 1, g = 1, b = 1, a = 0 }
    self.favBtn.tooltip = "Favorite this player to pin to top"
    self:addChild(self.favBtn)

    self.unfavBtn = ISButton:new(self:getWidth() - 50, 20, 30, 30, "", self,
        ISSpectatePanelUI.onClick)
    self.unfavBtn.internal = "UNFAVORITE";
    self.unfavBtn:initialise()
    self.unfavBtn:instantiate()
    self.unfavBtn:setImage(getTexture("media/ui/unfavBtn.png"))
    self.unfavBtn.borderColor = { r = 1, g = 1, b = 1, a = 0 }
    self.unfavBtn.tooltip = "Unfavorite this player and remove from pins"
    self:addChild(self.unfavBtn)

    self.searchField = ISTextEntryBox:new("", (self:getWidth() / 2) - 50, self.no.y, 100, btnHgt);
    self.searchField.font = UIFont.Medium
    self.searchField:initialise()
    self.searchField.tooltip = "Filter players"
    self.searchField.onTextChange = self.RefreshUI
    self.searchField.backgroundColor = { r = 0, g = 0, b = 0, a = 1 };
    self.searchField.borderColor = { r = 1, g = 1, b = 1, a = 1 }
    self:addChild(self.searchField)

    self.showFactionTag = ISTickBox:new(self.searchField.x, self.searchField:getBottom() + 15, 100, 100)
    self.showFactionTag:initialise();
    self.showFactionTag:instantiate();
    self.showFactionTag:setFont(UIFont.NewSmall)
    self.showFactionTag.tooltip = "Whether or not to show faction tag."
    self.showFactionTag:addOption("Show Faction Tags")
    self.showFactionTag.selected[1] = false
    self:addChild(self.showFactionTag)

    self:getPlayers();
end

function ISSpectatePanelUI:onClick(button)
    if button.internal == "CANCEL" then
        self:close();
    elseif button.internal == "SPECTATE" then
        if self.selectedPlayer then
            local target = self.selectedPlayer:getUsername()
            if target then
                SpectateUtils.setSpectateTarget(target)
            end
        end
    elseif button.internal == "STOPSPECTATE" then
        SpectateUtils.stopSpectating()
    elseif button.internal == "FAVORITE" then
        if self.selectedPlayer then
            local target = self.selectedPlayer:getUsername()
            if target then
                SpectateUtils.favoritePlayer(self.chr, target:lower())
            end
        end
    elseif button.internal == "UNFAVORITE" then
        if self.selectedPlayer then
            local target = self.selectedPlayer:getUsername()
            if target then
                SpectateUtils.unfavoritePlayer(self.chr, target:lower())
            end
        end
    elseif button.internal == "REFRESH" then
        self:RefreshUI()
    end
end

function ISSpectatePanelUI:getPlayers()
    local onlinePlayers = getOnlinePlayers()
    if onlinePlayers then
        self.onlinePlayers = onlinePlayers
        self:populateList()
    end
end

function ISSpectatePanelUI:populateList()
    self.datas:clear()
    self.selectedPlayer = nil

    -- Retrieve and clean the search filter, with a safety check for nil values
    local instance = ISSpectatePanelUI.instance.searchField
    local searchTerm = (instance and instance:getInternalText() or ""):trim():lower()

    -- Initialize two separate tables: one for favorited and one for non-favorited players
    local favoritedPlayers = {}
    local nonFavoritedPlayers = {}

    -- Collect all players and categorize them as favorited or non-favorited
    for i = 0, self.onlinePlayers:size() - 1 do
        local player = self.onlinePlayers:get(i)
        if player then
            local playerName = player:getUsername():lower()

            -- Check if the player matches the search filter
            if searchTerm == "" or playerName:find(searchTerm, 1, true) then
                if SpectateUtils.isPlayerFavorited(self.chr, playerName:lower()) then
                    table.insert(favoritedPlayers, player)
                else
                    table.insert(nonFavoritedPlayers, player)
                end
            end
        end
    end

    -- Sort both favorited and non-favorited players alphabetically by username
    table.sort(favoritedPlayers, function(a, b)
        return a:getUsername():lower() < b:getUsername():lower()
    end)

    table.sort(nonFavoritedPlayers, function(a, b)
        return a:getUsername():lower() < b:getUsername():lower()
    end)

    -- First, populate the list with sorted favorited players
    for i, player in ipairs(favoritedPlayers) do
        local item = {}
        item.data = player

        self.datas:addItem(player:getUsername(), item)
        if i == 1 then
            self.selectedPlayer = player -- Set the first favorited player as selected
        end
    end

    -- Then, populate the list with sorted non-favorited players
    for i, player in ipairs(nonFavoritedPlayers) do
        local item = {}
        item.data = player
        self.datas:addItem(player:getUsername(), item)
        if not self.selectedPlayer then
            self.selectedPlayer = player -- If no favorited player exists, select the first non-favorited player
        end
    end
end

function ISSpectatePanelUI:update()
    ISCollapsableWindow.update(self)

    local selectedItem = self.datas.items[self.datas.selected]
    if selectedItem then
        local selectedPlayerData = selectedItem.item.data
        self.selectedPlayer = selectedPlayerData
    end
end

function ISSpectatePanelUI:drawDatas(y, item, alt)
    local a = 0.9

    self:drawRectBorder(0, y, self:getWidth(), self.itemheight + 4, a, self.borderColor.r, self.borderColor.g,
        self.borderColor.b)

    local player = item.item.data

    if self.selected == item.index then
        self:drawRect(0, y, self:getWidth(), self.itemheight + 4, 0.3, 0.7, 0.35, 0.15)
        self.selectedPlayer = player
    end

    local username = player:getUsername()
    if ISSpectatePanelUI.instance.showFactionTag.selected[1] then
        local faction = Faction.getPlayerFaction(player)
        if faction then
            local tag = faction:getTag()
            if tag then
                username = "[" .. tag .. "] " .. username
            end
        end
    end
    self:drawText(username, 10, y + 2, 1, 1, 1, a, UIFont.Medium)

    -- Store y position in the item
    item.item.yPosition = y

    return y + self.itemheight + 4
end

function ISSpectatePanelUI:prerender()
    ISCollapsableWindow.prerender(self);

    -- Draw the background
    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g,
        self.backgroundColor.b)
    self:drawText("Spectate Panel",
        self.width / 2 - (getTextManager():MeasureStringX(UIFont.Large, "Spectate Panel") / 2), 10, 1, 1, 1, 1,
        UIFont.Large)
    self.datas.doDrawItem = self.drawDatas

    if not SpectateUtils.isPlayerSpectating() then
        self.stopSpectateBtn:setEnable(false)
        self.stopSpectateBtn.tooltip = "You aren't spectating anyone"

        self.spectateBtn:setEnable(true)
        self.spectateBtn.tooltip = "Start spectating this player"
    else
        self.stopSpectateBtn:setEnable(true)
        self.stopSpectateBtn.tooltip = "Stop spectating the current target"
        if self.selectedPlayer:getUsername() == SpectateUtils.target then
            self.spectateBtn:setEnable(false)
            self.spectateBtn.tooltip = "You are already spectating this player"
        else
            self.spectateBtn:setEnable(true)
            self.spectateBtn.tooltip = "Start spectating this player"
        end
    end

    if not self.selectedPlayer then
        self.favBtn:setVisible(false)
        self.unfavBtn:setVisible(false)
    else
        local target = self.selectedPlayer:getUsername()
        if target then
            if SpectateUtils.isPlayerFavorited(self.chr, target:lower()) then
                self.favBtn:setVisible(false)
                self.unfavBtn:setVisible(true)
            else
                self.unfavBtn:setVisible(false)
                self.favBtn:setVisible(true)
            end
        end
    end
end

function ISSpectatePanelUI:render()
    ISCollapsableWindow.render(self);

    self.searchField:drawTexture(getTexture("media/ui/searchicon.png"), 83, 6, 1, 1,
        1, 1)
end

function ISSpectatePanelUI:RefreshUI()
    local instance = ISSpectatePanelUI.instance
    instance.datas:clear();
    instance.selectedPlayer = nil
    instance:getPlayers();
end

function ISSpectatePanelUI:close()
    ISSpectatePanelUI.instance = nil
    self:setVisible(false)
    self:removeFromUIManager()
end

function ISSpectatePanelUI:new(character)
    local o = {}
    local width = 380;
    local height = 400;
    local x = getCore():getScreenWidth() / 2 - width / 2
    local y = getCore():getScreenHeight() / 2 - height / 2
    o = ISCollapsableWindow:new(x, y, width, height);
    setmetatable(o, self)
    self.__index = self
    o.borderColor = { r = 0.4, g = 0.4, b = 0.4, a = 1 };
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.8 };
    o.listHeaderColor = { r = 0.1, g = 0.1, b = 0.1, a = 0.75 };
    o.moveWithMouse = true;
    o.chr = character
    o:setResizable(false)
    ISSpectatePanelUI.instance = o;
    return o;
end

--[[
local SpectateUtils = require("Spectate_Utils")
print(SpectateUtils.unfavoritePlayer(getPlayer(), "Echo"))
]]
