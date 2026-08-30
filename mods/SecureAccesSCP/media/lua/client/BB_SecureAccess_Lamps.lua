-- ************************************************************************
-- **        ██████  ██████   █████  ██    ██ ███████ ███    ██          **
-- **        ██   ██ ██   ██ ██   ██ ██    ██ ██      ████   ██          **
-- **        ██████  ██████  ███████ ██    ██ █████   ██ ██  ██          **
-- **        ██   ██ ██   ██ ██   ██  ██  ██  ██      ██  ██ ██          **
-- **        ██████  ██   ██ ██   ██   ████   ███████ ██   ████          **
-- ************************************************************************
-- ** All rights reserved. This content is protected by © Copyright law. **
-- ************************************************************************

local function onFillWorldObjectContextMenu(player, context, worldObjects, test)

   local removeLampOption = context:getOptionFromName(getText("ContextMenu_RemoveLightbulb"))
   if not removeLampOption then return end

   if not isAdmin() and getWorld():getGameMode() == "Multiplayer" then
        removeLampOption.notAvailable = true
    end

end

Events.OnFillWorldObjectContextMenu.Add(onFillWorldObjectContextMenu)