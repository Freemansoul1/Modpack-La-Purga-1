local toDOutils = {}

function toDOutils.generateUUID()
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and ZombRand(0, 15) or ZombRand(8, 11)
        return string.format('%x', v)
    end)
end

function toDOutils.removeItemById(list, id)
    for i, item in ipairs(list) do
        if item.id == id then
            table.remove(list, i)
            break
        end
    end
end

function toDOutils.findItemByIndex(list, index)
    local idx = 0;
    for i, item in ipairs(list) do
        if item.id == index then
            idx = i
            break
        end
    end
    return idx
end

function toDOutils.isPlayerInAFaction(character)
    local fac = Faction.getPlayerFaction(character) or false
    return fac
end

function toDOutils.getPlayerFactionName(character)
    local playerFaction = Faction.getPlayerFaction(character)
    local playerFactionName = playerFaction and playerFaction:getName() or nil
    return playerFactionName
end

function toDOutils.getFindModData(character)
    if toDOutils.isPlayerInAFaction(character) then
        local fN = toDOutils.getPlayerFactionName(character)
        if not ModData.get("SharedTDL").Faction[fN] then ModData.get("SharedTDL").Faction[fN] = {} end
        return ModData.get("SharedTDL").Faction[fN]
     else return ModData.get("SharedTDL").notFaction
    end
end

function toDOutils.getPlayerName(character)
    local name = character:getDescriptor():getForename()
    if isClient() and getServerOptions():getBoolean("DisplayUserName") then
      name = character:getUsername()
    end
    return name
end

function toDOutils.writeCheckList(text, character, parent)
    local currentDate = os.date("*t")
    local characterName = toDOutils.getPlayerName(character)
    local date = tostring(currentDate.year) .. "/" .. tostring(currentDate.month) .. "/" .. tostring(currentDate.day)   
    local wText = date .. "|" .. characterName .. " : " .. text
    if not ModData.exists("SharedTDL") then
        ModData.add("SharedTDL", {
            notFaction = {},
            Faction = {}
        })
    end
    local newItem = {
        id = toDOutils.generateUUID(),
        text = wText,
        check = false,
        checkName = ""
    }
    table.insert(toDOutils.getFindModData(character), newItem)
    ModData.transmit("SharedTDL")
    if not parent.listbox:isVisible() then parent.listbox:setVisible(true) end
    if parent.notList then 
        parent.notList:setVisible(false)
        parent.notList:removeFromUIManager()
    end
    parent.listbox:addItem(characterName .. " : " .. text, newItem.id)
    toDOutils.refresh(character, "false")
end

function toDOutils.wrapText(text, font, maxLength)
    local result = ""
    local line = ""
    local textManager = getTextManager()
    local spaceWidth = textManager:MeasureStringX(font, " ")

    local function measureStringWidth(str)
        return textManager:MeasureStringX(font, str)
    end

    local i = 1
    while i <= #text do
        local char = text:sub(i, i)
        local nextLine = line == "" and char or line .. char
        local length = measureStringWidth(nextLine)

        if length > maxLength then
            result = result .. line .. "\n"
            line = char
        else
            line = nextLine
        end

        i = i + 1
    end

    result = result .. line
    return result
end

function toDOutils.playOpenSound()
	local play = getSoundManager():PlaySound("ListOpen",true,0);
    getSoundManager():PlayAsMusic("ListOpen",play,true,0);
	play:setVolume(1);
  return play
end

function toDOutils.refresh(character, isCheck)
    if not isClient() then return end
    for i=0,getOnlinePlayers():size()-1 do
      local pl = getOnlinePlayers():get(i);
      if character:getSteamID() ~= pl:getSteamID() then
        sendClientCommand(character, "SharedTDL", "REFRESH", { id = pl:getOnlineID(), check = isCheck }) 
      end
    end
end

function toDOutils.delete(character)
    if not isClient() then return end
    for i=0,getOnlinePlayers():size()-1 do
      local pl = getOnlinePlayers():get(i);
      if character:getSteamID() ~= pl:getSteamID() then
        sendClientCommand(character, "SharedTDL", "DELETE", { id = pl:getOnlineID() }) 
      end
    end
end


return toDOutils