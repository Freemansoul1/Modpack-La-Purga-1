---
--- WL_Utils.lua
---
--- Utility functions for Wasteland RP
---
--- 17/10/2023
---

-- quick fix for ISFastTeleportMove breaking Z sometimes

local original_ISFastTeleportMove_moveZ = ISFastTeleportMove.moveZ
ISFastTeleportMove.moveZ = function(self, z)
    original_ISFastTeleportMove_moveZ(self, z)
    ISFastTeleportMove.currentZ = math.max(0, math.floor(ISFastTeleportMove.currentZ))
end

WL_Utils = WL_Utils or {}
--- Add a WL_FakeMessage to the chat window
--- @param message WL_FakeMessage
function WL_Utils.addFakeMessageToChatWindow(message)
    if not ISChat or not ISChat.instance or not ISChat.instance.chatText then return end
    local line = message:getTextWithPrefix()
    local chatText = ISChat.instance.chatText
    if message:getChatID() then
        for _,v in ipairs(ISChat.instance.tabs) do
            if v.tabID == message:getChatID() then
                chatText = v
                break
            end
        end
    end
    if chatText.tabTitle ~= ISChat.instance.chatText.tabTitle then
        local alreadyExist = false;
        for i,blinkedTab in ipairs(ISChat.instance.panel.blinkTabs) do
            if blinkedTab == chatText.tabTitle then
                alreadyExist = true;
                break;
            end
        end
        if alreadyExist == false then
            table.insert(ISChat.instance.panel.blinkTabs, chatText.tabTitle);
        end
    end
    local vscroll = chatText.vscroll
    local scrolledToBottom = (chatText:getScrollHeight() <= chatText:getHeight()) or (vscroll and vscroll.pos == 1)
    if #chatText.chatTextLines > ISChat.maxLine then
        local newLines = {}
        for i,v in ipairs(chatText.chatTextLines) do
            if i ~= 1 then
                table.insert(newLines, v)
            end
        end
        table.insert(newLines, line .. " <LINE> ")
        chatText.chatTextLines = newLines
    else
        table.insert(chatText.chatTextLines, line .. " <LINE> ")
    end
    chatText.text = ""
    local newText = ""
    for i,v in ipairs(chatText.chatTextLines) do
        if i == #chatText.chatTextLines then
            v = string.gsub(v, " <LINE> $", "")
        end
        newText = newText .. v
    end
    chatText.text = newText
    table.insert(chatText.chatMessages, message)
    chatText:paginate()
    if scrolledToBottom then
        chatText:setYScroll(-100000)
    end
end

--- Add a message to the chat window
--- @param text string
--- @param options WL_ChatOptions|nil
function WL_Utils.addToChat(text, options)
    local message = WL_FakeMessage:new(text, options)
    WL_Utils.addFakeMessageToChatWindow(message)
end

--- Add a message to the chat window with a red color
--- @param text string
--- @param options WL_ChatOptions|nil
function WL_Utils.addErrorToChat(text, options)
    options = options or {}
    options.color = "1.0,0.2,0.2"
    WL_Utils.addToChat(text, options)
end

--- Add a message to the chat window with a blue color
--- @param text string
--- @param options WL_ChatOptions|nil
function WL_Utils.addInfoToChat(text, options)
    options = options or {}
    options.color = "0.2,0.2,1.0"
    WL_Utils.addToChat(text, options)
end

--- Local utility function to write chat messages for item spawning
--- @return string the translated name of the item that was added or nil if no such item existed
local function addItemGainedMessage(itemID, newItem, quantity)
    if not newItem then
        WL_Utils.addToChat("ERROR item not found: " .. itemID, { color = "1.0,0,0", })
        return nil
    end

    local numberString
    if quantity and quantity > 1 then
        numberString =  " (" .. quantity .. ")"
    else
        numberString = ""
    end

    WL_Utils.addToChat("Gained Item: " .. newItem:getName() .. numberString, { color = "1.0,0.8,0.2", })
    return newItem:getName()
end

--- Adds one or more instances of an item to the player's inventory and sends a chat window message informing them
--- @param itemID string of the item's type, e.g Base.Pistol
--- @param quantity number|nil optional parameter defining how many of this item to add
--- @return string the translated name of the item that was added or nil if no such item existed
function WL_Utils.addItemToInventory(itemID, quantity)
    local inventory = getPlayer():getInventory()
    local newItem

    if quantity then
        for _ = 1, quantity do
            newItem = inventory:AddItem(itemID)
        end
        return addItemGainedMessage(itemID, newItem, quantity)
    else
        newItem = inventory:AddItem(itemID)
        return addItemGainedMessage(itemID, newItem)
    end
end

---@param playerFrom IsoPlayer to take from
---@param itemID string full ID of the item
---@param amount number number of items to take
---@return boolean true if successful taking the items, otherwise false
function WL_Utils.attemptTakeItems(playerFrom, itemID, amount)
    if not amount then amount = 1 end
    if amount < 1 then return true end
    if playerFrom:getInventory():getItemCountFromTypeRecurse(itemID) < amount then
        return false
    end
    for i = 1, amount do
        local item = playerFrom:getInventory():getFirstTypeRecurse(itemID)
        if item then
            item:getContainer():Remove(item)
        end
    end
    return true
end

--- Gives XP to a player and sends a chat window message informing them
--- Does not factor in perk bonuses, adding the XP value exactly as it is, which makes the message reporting
--- how much XP the player gained be correct at all times (Though this isn't what is wanted in many cases)
--- --@param perk PerkFactory.Perks object NOT the string ID e.g Perks.Cooking
--- --@param amount number how much XP to give the player
function WL_Utils.gainXP(perk, amount)
    getPlayer():getXp():AddXP(perk, amount, false, false, false);
    WL_Utils.addToChat("Gained " .. perk:getName() .. ": " .. tostring(amount) .. "XP",
            { color = "0.85,0.5,1.0", })
end

-- Makes the player safe from zombies for a short time
----- @param time number how long to make the player safe for in seconds
--[[function WL_Utils.makePlayerSafe(moveTime, stillTime)
    local player = getPlayer()
    if not player then return end
    if WL_Utils.isStaff(player) then return end -- Admins can choose to be safe on their own
    stillTime = stillTime or moveTime * 10
    WL_SafePlayer:start(player, moveTime, stillTime)
end]]


local function scanItem(holder, item, foundAt)
    table.insert(holder, {item = item, foundAt = foundAt})
    if instanceof(item, "InventoryContainer") then
        local container = item:getItemContainer()
        if container then
            local items = container:getItems()
            if items then
                for i = 0, items:size() - 1 do
                    local innerItem = items:get(i)
                    if innerItem then
                        scanItem(holder, innerItem, "bag")
                    end
                end
            end
        end
    end
end

-- Scans a gridSquare for all items, and returns them in a table
function WL_Utils.scanGridSquare(x, y, z)
    if not instanceof(x, "IsoGridSquare") then
        if not x or not y or not z then return {} end
        x = getCell():getGridSquare(x, y, z)
    end
    if not x then return {} end
    local items = {}

    worldObjects = x:getWorldObjects()
    if worldObjects then
        for j = 0, worldObjects:size() - 1 do
            object = worldObjects:get(j):getItem()
            if object then
                scanItem(items, object, "ground")
            end
        end
    end

    objects = x:getObjects()
    if objects then
        for j = 0, objects:size() - 1 do
            object = objects:get(j)
            if object then
                container = object:getContainer()
                if container then
                    for k = 0, container:getItems():size() - 1 do
                        item = container:getItems():get(k)
                        if item then
                            scanItem(items, item, "container")
                        end
                    end
                end
            end
        end
    end

    movingObjects = x:getMovingObjects()
    if movingObjects then
        for j = 0, movingObjects:size() - 1 do
            object = movingObjects:get(j)
            if instanceof(object, "BaseVehicle") then
                for k = 0, object:getPartCount() - 1 do
                    local part = object:getPartByIndex(k)
                    if part then
                        container = part:getItemContainer()
                        if container then
                            for l = 0, container:getItems():size() - 1 do
                                item = container:getItems():get(l)
                                if item then
                                    scanItem(items, item, "vehicle")
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return items
end