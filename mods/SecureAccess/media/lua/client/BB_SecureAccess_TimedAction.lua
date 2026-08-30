-- ************************************************************************
-- **        ██████  ██████   █████  ██    ██ ███████ ███    ██          **
-- **        ██   ██ ██   ██ ██   ██ ██    ██ ██      ████   ██          **
-- **        ██████  ██████  ███████ ██    ██ █████   ██ ██  ██          **
-- **        ██   ██ ██   ██ ██   ██  ██  ██  ██      ██  ██ ██          **
-- **        ██████  ██   ██ ██   ██   ████   ███████ ██   ████          **
-- ************************************************************************
-- ** All rights reserved. This content is protected by © Copyright law. **
-- ************************************************************************

require "TimedActions/ISBaseTimedAction"

BB_SecureAccess_TimedAction = ISBaseTimedAction:derive("BB_FAO_ISTimedAction")

BB_SecureAccess_TimedAction.isValid = function(self)
    return true
end

BB_SecureAccess_TimedAction.start = function(self)
    self:setActionAnim("Loot")
    self:setAnimVariable("LootPosition", "Mid")
end

BB_SecureAccess_TimedAction.stop = function(self)
    ISBaseTimedAction.stop(self)
end

local function tryRemoveItem(item, playerInv)
    if item then
        if item:getContainer() then
            item:getContainer():Remove(item)
        else
            playerInv:Remove(item)
        end
    end
end

BB_SecureAccess_TimedAction.perform = function(self)

    if self.typeTimeAction == "InsertKeycard" then
        --local playerInv = self.playerObj:getInventory() <-------------- REMOVE KEYCARD
        --if self.keycardItem then tryRemoveItem(self.keycardItem, playerInv) end

        for i, sq in ipairs(self.squares) do
            local args = { square = { x = sq:getX(), y = sq:getY(), z = sq:getZ() }, properties = self.properties[i] }
            sendClientCommand(self.playerObj, 'SecureAccess', 'SetDoor', args)
        end
    end

    ISBaseTimedAction.perform(self)
end

BB_SecureAccess_TimedAction.InsertKeycard = function(self, squares, properties, playerObj, keycardItem)

    local action = ISBaseTimedAction.new(self, playerObj)
    action.typeTimeAction = "InsertKeycard"
    action.squares = squares
    action.properties = properties
    action.playerObj = playerObj
    action.keycardItem = keycardItem
    action.stopOnWalk = true
    action.stopOnRun = true
    action.maxTime = 50
    action.fromHotbar = false

    if action.character:isTimedActionInstant() then action.maxTime = 1 end
    return action
end

return TimeAction