-- ************************************************************************
-- **        ██████  ██████   █████  ██    ██ ███████ ███    ██          **
-- **        ██   ██ ██   ██ ██   ██ ██    ██ ██      ████   ██          **
-- **        ██████  ██████  ███████ ██    ██ █████   ██ ██  ██          **
-- **        ██   ██ ██   ██ ██   ██  ██  ██  ██      ██  ██ ██          **
-- **        ██████  ██   ██ ██   ██   ████   ███████ ██   ████          **
-- ************************************************************************
-- ** All rights reserved. This content is protected by © Copyright law. **
-- ************************************************************************

local onCommand = ISChat.onCommandEntered

function ISChat:onCommandEntered()
    onCommand(self)

    local chat = ISChat.instance
    local chatText = chat.chatText
    chatText.logIndex = chatText.logIndex + 1

    if chatText.logIndex > #chatText.log then
        chatText.logIndex = #chatText.log;
    end

    if chatText.log and chatText.log[chatText.logIndex] then
        local command = chatText.log[chatText.logIndex]
        if command == "/suicide" or command == "/kill" then
            local bodyDamage = getPlayer():getBodyDamage()
            bodyDamage:setOverallBodyHealth(0)
        end
    end
end