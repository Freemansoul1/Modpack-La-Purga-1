local MagicChat = require("MagicChat/Main")

local MagicChatGamepad = ISPanelJoypad:derive("MagicChatGamepad")

-- Tracks each player's panel in splitscreen.
MagicChatGamepad.panel = {}
MagicChatGamepad.wasJoypadUp = {}
MagicChatGamepad.wasJoypadLeft = {}
MagicChatGamepad.wasJoypadRight = {}

MagicChatGamepad.fontHeightSmall = getTextManager():getFontHeight(UIFont.Small)
MagicChatGamepad.fontHeightMedium = getTextManager():getFontHeight(UIFont.Medium)

MagicChatGamepad.createGamepadInputPanel = function(playerIndex, player)
     -- Does not need to be done again on respawn.
    if MagicChatGamepad.panel[playerIndex] then 
        MagicChatGamepad.panel[playerIndex].player = player 
        return 
    end
    local left = getPlayerScreenLeft(playerIndex)
    local top = getPlayerScreenTop(playerIndex)
    local screenWidth = getPlayerScreenWidth(playerIndex)
    local screenHeight = getPlayerScreenHeight(playerIndex)
    local width = screenWidth / 2
    local height = MagicChatGamepad.fontHeightMedium * 5
    local x = (screenWidth / 2) - (width / 2)
    local y = (screenHeight / 2) - (height / 2) - 200 -- Always above the player.
    if y < 0 then y = 0 end --> y >= 0
    MagicChatGamepad.panel[playerIndex] = MagicChatGamepad.panel[playerIndex] or
        MagicChatGamepad:new(x, y, width, height, player, playerIndex)
    MagicChatGamepad.panel[playerIndex]:initialise()
    MagicChatGamepad.panel[playerIndex]:setVisible(false)
end

Events.OnCreatePlayer.Add(MagicChatGamepad.createGamepadInputPanel)

MagicChatGamepad.chatAccess = function(player)
    local chat = ISChat.instance

    if not chat then return end

    local playerIndex = player:getPlayerNum()

    local joypadData = JoypadState.players[playerIndex + 1] 

    if not joypadData then return end

    if isJoypadPressed(playerIndex, Joypad.RBumper) and not getJoypadFocus(playerIndex) then
        local magicChatInputPanel = MagicChatGamepad.panel[playerIndex]
        local cannotSeeInputPanel = not magicChatInputPanel:isVisible()

        local shouldOpenInputPanel = false

        if isJoypadLeft(playerIndex) and chat:isVisible() and not MagicChatGamepad.wasJoypadLeft[playerIndex] then
            local tab = chat.tabs[chat.currentTabID]
            if not tab then return end
            local priorIndex = chat.currentTabID - 1 < 1 and #chat.tabs or chat.currentTabID - 1
            local priorTab = chat.tabs[priorIndex]
            chat.panel:activateView(priorTab.tabTitle)
            chat:onActivateView()
        elseif isJoypadRight(playerIndex) and chat:isVisible() and not MagicChatGamepad.wasJoypadRight[playerIndex] then
            local tab = chat.tabs[chat.currentTabID]
            if not tab then return end
            local nextIndex = chat.currentTabID + 1 > #chat.tabs and 1 or chat.currentTabID + 1
            local nextTab = chat.tabs[nextIndex]
            chat.panel:activateView(nextTab.tabTitle)
            chat:onActivateView()
        elseif isJoypadUp(playerIndex) and not MagicChatGamepad.wasJoypadUp[playerIndex] then
            if chat:isVisible() then
                chat:close()
            else
                MagicChat.abracadabra(chat)

                -- Stop chat from closing itself later.
                if not MagicChat.mod.options.enableMagicChat then
                    chat.magicallyOpened = nil
                end
            end
        elseif isJoypadDown(playerIndex) and cannotSeeInputPanel then
            shouldOpenInputPanel = true
        elseif isJoypadPressed(playerIndex, Joypad.AButton) and MagicChat.mod.options.alternativeInputShortcut and cannotSeeInputPanel then
            shouldOpenInputPanel = true
        end

        if shouldOpenInputPanel then
            magicChatInputPanel:addToUIManager()
            magicChatInputPanel:setVisible(true)
            setJoypadFocus(playerIndex, magicChatInputPanel)
            magicChatInputPanel.entry:onJoypadDown(Joypad.AButton, joypadData)
        end
    end

    MagicChatGamepad.wasJoypadUp[playerIndex] = isJoypadUp(playerIndex)
    MagicChatGamepad.wasJoypadLeft[playerIndex] = isJoypadLeft(playerIndex)
    MagicChatGamepad.wasJoypadRight[playerIndex] = isJoypadRight(playerIndex)
end

Events.OnPlayerUpdate.Add(MagicChatGamepad.chatAccess)

MagicChatGamepad.sendMessage = function(message)
    local chat = ISChat.instance

    if not chat then return end

    chat.textEntry:setText(tostring(message))

    chat:onCommandEntered()
end

MagicChatGamepad.isJoypadDisconnected = function(playerIndex) 
	local controller = JoypadState.controllers[playerIndex]
	if not controller then return end
	local joypadData = controller.joypad
	if not joypadData then return end
	if joypadData.disconnectedUI then return true end
end

function MagicChatGamepad:initialise()
    if self.hasMadeChildren then return end

    ISPanelJoypad.initialise(self)

    self.buttonWidth = 100
    self.buttonHeight = math.max(25, MagicChatGamepad.fontHeightSmall + 3 * 2)
    self.padBottom = 10

    self.entryX = 10
    self.entryY = 20 + MagicChatGamepad.fontHeightMedium + 20
    self.entryWidth = self.width - (self.entryX * 2)

    self.entry = ISTextEntryBox:new(getText("UI_MagicChat_messageInputPanelTitle"), self.entryX, self.entryY, self.entryWidth, 3 * (MagicChatGamepad.fontHeightSmall + 4))
    self.entry.font = UIFont.Small
    self.entry:initialise()
    self.entry:instantiate()
    self:addChild(self.entry)

    self.ok = ISButton:new(10, self.entry:getBottom() + 20, self.buttonWidth, self.buttonHeight, getText("IGUI_ServerToolBox_Accept"), self, MagicChatGamepad.onClick)
    self.ok.internal = "OK"
    self.ok:initialise()
    self.ok:instantiate()
    self.ok.borderColor = { r = 1, g = 1, b = 1, a = 0.1 }
    self:addChild(self.ok)

    self.edit = ISButton:new((self.width / 2) - (self.buttonWidth / 2), self.ok.y, self.buttonWidth, self.buttonHeight, getText("IGUI_TextBox_Edit"), self, MagicChatGamepad.onClick);    
    self.edit.internal = "EDIT"
    self.edit:initialise()
    self.edit:instantiate()
    self.edit.borderColor = { r = 1, g = 1, b = 1, a = 0.1 }
    self:addChild(self.edit)

    if not JoypadState.players[self.playerIndex + 1] then
        self.edit:setVisible(false)
    end

    self.no = ISButton:new(self:getWidth() - self.buttonWidth, self.ok.y, self.buttonWidth, self.buttonHeight, getText("UI_Cancel"), self, MagicChatGamepad.onClick)
    self.no.internal = "CANCEL"
    self.no:initialise()
    self.no:instantiate()
    self.no.borderColor = { r = 1, g = 1, b = 1, a = 0.1 }
    self:addChild(self.no)

    self:setHeight(self.no:getBottom() + self.padBottom)

    self.hasMadeChildren = true
end

function MagicChatGamepad:onGainJoypadFocus(joypadData)
    ISPanelJoypad.onGainJoypadFocus(self, joypadData)
    
    self:setISButtonForA(self.edit)
    self:setISButtonForB(self.no)
    self:setISButtonForY(self.ok)

    self.edit:setVisible(true)
    self.no:setVisible(true)
    self.ok:setVisible(true)

    self.no.xOriginal = self.no.xOriginal or self.no:getX()

    self.no:setX(self.no.xOriginal - 20)
end

function MagicChatGamepad:onLoseJoypadFocus(joypadData)
    ISPanelJoypad.onLoseJoypadFocus(self, joypadData)

    self.edit:setVisible(false)
    self.no:setVisible(false)
    self.ok:setVisible(false)
    
    self.no:setX(self.no.xOriginal)
end

function MagicChatGamepad:onJoypadDown(button, joypadData)
    if button == Joypad.AButton then -- This summons the keyboard.
        self.entry:onJoypadDown(button, joypadData)
    elseif button == Joypad.YButton then
        self:onClick({ internal = "OK" })
    elseif button == Joypad.BButton then
        self:onClick({ internal = "CANCEL" })
    end
end

function MagicChatGamepad:render()
    if self.player:isDead() then return end
    if MagicChatGamepad.isJoypadDisconnected(self.playerIndex) then self:onClick({ internal = "CANCEL", disconnect = true }) end
end

function MagicChatGamepad:prerender()
    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b)
    self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b)
    self:drawText(getText("UI_MagicChat_inputMessage"), (self.width / 2) - (getTextManager():MeasureStringX(UIFont.Medium, getText("UI_MagicChat_inputMessage")) / 2), 
        20, 1, 1, 1, 1, UIFont.Medium)
	self:bringToTop()
end

function MagicChatGamepad:onClick(button)
    if button.internal == "CANCEL" then
        self:setVisible(false)
        self:removeFromUIManager()
        if button.disconnect then return end
    end

    if button.internal == "OK" then
        local message = self.entry:getText()
        MagicChatGamepad.sendMessage(message)
        self:setVisible(false)
        self:removeFromUIManager()
    end

    setJoypadFocus(self.playerIndex, nil)
end

function MagicChatGamepad:new(x, y, width, height, player, playerIndex)
    local o = {}

    o = ISPanelJoypad:new(x, y, width, height)

    setmetatable(o, self)
    self.__index = self

    o.moveWithMouse = true
    o.borderColor = { r = 1.0, g = 1.0, b = 0.0, a = 0.5 }
    o.buttonBorderColor = { r = 0.7, g = 0.7, b = 0.7, a = 0.5 }
    o.backgroundColor = { r = 0.0, g = 0.0, b = 0.0, a = 1.0 }
    o.playerIndex = playerIndex
    o.player = player

    return o
end

-- Death Focus Management

function MagicChatGamepad.clearOnDeath(player)
    local playerIndex = player:getPlayerNum()
    if not JoypadState.players[playerIndex + 1] then return end
    local magicChatInputPanel = MagicChatGamepad.panel[playerIndex]
    if magicChatInputPanel and magicChatInputPanel:isVisible() then 
        magicChatInputPanel:onClick({ internal = "CANCEL" })
        setJoypadFocus(playerIndex, ISPostDeathUI.instance[playerIndex])
    end
end

Events.OnPlayerDeath.Add(MagicChatGamepad.clearOnDeath)

-- Because I am a bit OCD about grammar and I hate looking at the 
-- atrocious spelling of what should have been called "Accept" below:

if not getTextOriginal then
    getTextOriginal = getText
    getText = function(text, ...)
        if text == "IGUI_ServerToolBox_Accept" then
            return getTextOriginal("IGUI_ServerToolBox_acccept")
        else
            return getTextOriginal(text, ...)
        end
    end
end

return MagicChatGamepad
