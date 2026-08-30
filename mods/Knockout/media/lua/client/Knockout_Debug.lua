local KnockoutUI

-- Function to get the selected player's ID
local function getSelectedPlayerID()
    local selectedItem = Knockout.selectedItem
    if selectedItem then
        -- Extract the ID from the selected item using string manipulation
        local _, _, id = selectedItem:find("%((%d+)%)")
        if id then
            return tonumber(id)
        end
    end
    return nil
end

-- Function to force knockout on the selected player
local function forceKnockout(button, args)
    if not Knockout.selectedItem then return end
    local onlineID = getSelectedPlayerID()
    sendClientCommand('RealKnockouts', 'knockOtherPlayerOut', {onlineID})
end

-- Function to wake up the selected player
local function wakeUpPlayer(button, args)
    if not Knockout.selectedItem then return end
    local onlineID = getSelectedPlayerID()
    sendClientCommand('RealKnockouts', 'wakeOtherPlayerUp', {onlineID})
end

-- Function to set the selected item when clicked
local function setSelectedItem(_, item)
    Knockout.selectedItem = item
end

-- Function called when creating the UI
function Knockout.onCreateUI()
    KnockoutUI = NewUI()
    local playersList = getOnlinePlayers()

    KnockoutUI:setTitle(getText("UI_Knockout_DebugOnlinePlayer"));

    local playerNamesList = {}

    -- Populate the playerNamesList with player names and IDs
    for i = 1, playersList:size() do
        local player = playersList:get(i - 1)
        table.insert(playerNamesList, player:getUsername() .. " (" .. player:getOnlineID() .. ")")
    end

    -- Create a scroll list with player names and IDs
    KnockoutUI:addScrollList("list", playerNamesList)
    KnockoutUI["list"]:setOnMouseDownFunction(_, setSelectedItem)

    KnockoutUI:nextLine();

    KnockoutUI:addButton("ForceKnockout", getText("UI_Knockout_DebugForceKnockout"), forceKnockout)
    KnockoutUI:addButton("WakeUpPlayer", getText("UI_Knockout_DebugWakeUpPlayer"), wakeUpPlayer)

    -- Save the layout
    KnockoutUI:saveLayout()
end