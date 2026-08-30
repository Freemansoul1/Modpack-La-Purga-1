local MagicChat = {}

local none = 0

MagicChat.category = "[UI]"

MagicChat.magicalShortcut = {
    key = none,
    name = "summonMagicChat"
}

MagicChat.mod = {
    options = {
        enableMagicChat = true,
        alternativeInputShortcut = false,
        closeChatOnJoin = false,
        spellDuration = 10
    },
    
    names = {
        enableMagicChat = getText("UI_MagicChat_enableMagicChat"),
        alternativeInputShortcut = getText("UI_MagicChat_alternativeInputShortcut"),
        closeChatOnJoin = getText("UI_MagicChat_closeChatOnJoin"),
        spellDuration = getText("UI_MagicChat_spellDuration")
    },

    mod_id = "MagicChat1",

    mod_shortname = "Magic Chat1"
}

if ModOptions and ModOptions.getInstance then
    ModOptions:AddKeyBinding(MagicChat.category, MagicChat.magicalShortcut)

    MagicChat.modSettings = ModOptions:getInstance(MagicChat.mod)

    MagicChat.enableMagicChat = MagicChat.modSettings:getData("enableMagicChat")
    MagicChat.alternativeInputShortcut = MagicChat.modSettings:getData("alternativeInputShortcut")
    MagicChat.closeChatOnJoin = MagicChat.modSettings:getData("closeChatOnJoin")
    MagicChat.spellDuration = MagicChat.modSettings:getData("spellDuration")
    
    MagicChat.enableMagicChat.tooltip = getText("UI_MagicChat_enableMagicChat_tooltip")
    MagicChat.alternativeInputShortcut.tooltip = getText("UI_MagicChat_alternativeInputShortcut_tooltip")
    MagicChat.closeChatOnJoin.tooltip = getText("UI_MagicChat_closeChatOnJoin_tooltip")
    MagicChat.spellDuration.tooltip = getText("UI_MagicChat_spellDuration_tooltip")

    for index = 1, 20 do
        local unit = index == 1 and getText("IGUI_Gametime_second") or getText("IGUI_Gametime_secondes")
        MagicChat.spellDuration[index] = index .. " " .. unit
    end
end

MagicChat.abracadabra = function(chat)
    chat.magicallyOpened = getTimestampMs()
    chat:setVisible(true)
    local tab = chat.tabs[tabID]
    if not tab then return end
    chat.panel:activateView(tab.tabTitle)
    chat:onActivateView()
end

MagicChat.castSpellUsingKey = function(key)
    if key == MagicChat.magicalShortcut.key then
        local chat = ISChat.instance
        if not chat then return end
        MagicChat.abracadabra(chat)
    end
end

Events.OnKeyPressed.Add(MagicChat.castSpellUsingKey)

MagicChat.addLineInChat = ISChat.addLineInChat

ISChat.addLineInChat = function(message, tabID)
    MagicChat.addLineInChat(message, tabID)
    
    local chat = ISChat.instance

    if not chat then return end

    local mustSeeServerAlert = message:isServerAlert() and not SandboxVars.MagicChat.allowIgnoringAdminAnnouncements

    local shouldOpenChat = MagicChat.mod.options.enableMagicChat or mustSeeServerAlert

    if shouldOpenChat and not chat:isVisible() then
        MagicChat.abracadabra(chat)
    elseif chat.magicallyOpened and not chat.openedForServerAlert then 
        chat.magicallyOpened = getTimestampMs() -- Keeps chat open longer for new message.
    end

    if mustSeeServerAlert and chat.magicallyOpened and not chat.openedForServerAlert then 
        chat.openedForServerAlert = true
        -- Just trust this one. It's because of math. Math is powerful.
        local durationDifference = (SandboxVars.MagicChat.minimumServerMessageDuration - MagicChat.mod.options.spellDuration)
        chat.magicallyOpened = getTimestampMs() + (durationDifference * 1000)
    end

    if mustSeeServerAlert then
        chat.servermsgTimer = SandboxVars.MagicChat.minimumServerMessageDuration * 1000
    end
end

MagicChat.prerender = ISChat.prerender

function ISChat:prerender()
    if MagicChat.mod.options.closeChatOnJoin and not self.closedOnceAfterJoining then
        self.closedOnceAfterJoining = true
        self.magicallyOpened = getTimestampMs()
    end

    if self.magicallyOpened and (getTimestampMs() - self.magicallyOpened) > (MagicChat.mod.options.spellDuration * 1000) then
        self:close()
    else
        MagicChat.prerender(self)
    end
end

MagicChat.focus = ISChat.focus

function ISChat:focus()
    MagicChat.focus(self)
    self.magicallyOpened = nil
end

MagicChat.close = ISChat.close

function ISChat:close()
    MagicChat.close(self)
    self.closedOnceAfterJoining = true
    self.magicallyOpened = nil
end

return MagicChat
