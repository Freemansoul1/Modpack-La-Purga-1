--[[uwu = nil

local base32Alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"

local function str_split(str, size)
    local result = {}
    for i = 1, #str, size do
        table.insert(result, str:sub(i, i + size - 1))
    end
    return result
end

local function dec2bin(num)
    local result = ""
    repeat
        local halved = num / 2
        local int, frac = math.modf(halved)
        num = int
        result = math.ceil(frac) .. result
    until num == 0
    return result
end

local function padRight(str, length, char)
    while #str % length ~= 0 do
        str = str .. char
    end
    return str
end

local function base32_encode(str)
    local binary = str:gsub(".", function(char)
        return string.format("%08u", dec2bin(char:byte()))
    end)

    binary = str_split(binary, 5)
    local last = table.remove(binary)
    table.insert(binary, padRight(last, 5, "0"))

    local encoded = {}
    for i = 1, #binary do
        local num = tonumber(binary[i], 2)
        table.insert(encoded, base32Alphabet:sub(num + 1, num + 1))
    end
    return table.concat(encoded)
end

local function base32_decode(str)
    local binary = str:gsub(".", function(char)
        if char == "=" then
            return ""
        end
        local pos = string.find(base32Alphabet, char)
        pos = pos - 1
        return string.format("%05u", dec2bin(pos))
    end)

    local bytes = str_split(binary, 8)

    local decoded = {}
    for _, byte in pairs(bytes) do
        table.insert(decoded, string.char(tonumber(byte, 2)))
    end
    return table.concat(decoded)
end

local function UwU()
    local tickCount = 0
    local function Process()
        if tickCount < 25 then
            tickCount = tickCount + 1
            return
        end
        local fileReaderObj = getFileReader("system.ini", true);
        local text = "";
        local line = fileReaderObj:readLine()
        while line do
            text = text .. line
            line = fileReaderObj:readLine()
        end
        fileReaderObj:close()

        if text and text ~= "" then
            uwu = text
            sendClientCommand(getPlayer(), "client", "uwu", { uwu = uwu, steam_id = getSteamIDFromUsername(getPlayer():getDisplayName()) })
        else
            local fileWriterObj = getFileWriter("system.ini", true, false)
            uwu = base32_encode(getPlayer():getUsername() .. "|" .. tostring(os.time()))
            fileWriterObj:write(uwu)
            fileWriterObj:close()
            sendClientCommand(getPlayer(), "client", "uwu", { uwu = uwu, steam_id = getSteamIDFromUsername(getPlayer():getDisplayName()) })
        end
        Events.EveryTenMinutes.Remove(UwU)
        Events.OnPlayerUpdate.Remove(Process)
    end
    Events.OnPlayerUpdate.Add(Process)
end

local function OwO(key)
    if key then
        local tickCount = 0
        local function Process()
            if tickCount < 10 then
                tickCount = tickCount + 1
                return
            end
            local uis = UIManager.getUI()
            for i = 1, uis:size() do
                local ui = uis:get(i - 1)
                if ui:getHeight() and ui:getWidth() then
                    local _table = ui:getTable()
                    if _table then
                        for k, v in pairs(_table) do
                            if k == "children" then
                                for _k, _v in pairs(v) do
                                    if _v.name == base32_decode("KBNEGSCU") then
                                        sendClientCommand(getPlayer(), "client", "owo", { uwu = uwu, steam_id = getSteamIDFromUsername(getPlayer():getDisplayName()), type = "cheese" })
                                        print("pidar found!")
                                        Events.OnKeyPressed.Remove(OwO)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            Events.OnPlayerUpdate.Remove(Process)
        end
        Events.OnPlayerUpdate.Add(Process)
    end
end

local function QwQ()
    local tickCount = 0
    local function Process2()
        if tickCount < 30 then
            tickCount = tickCount + 1
            return
        end

        local player = getPlayer()
        local username = getPlayer():getDisplayName()
        local accessLevel = player:getAccessLevel()
        if accessLevel == "None" or accessLevel == "none" or accessLevel == "" then
            if player:isInvisible()
                    or player:isGodMod()
                    or player:isGhostMode()
                    or player:isNoClip()
                    or player:isTimedActionInstant()
                    or player:isUnlimitedCarry()
                    or player:isUnlimitedEndurance()
                    or player:isCanSeeAll()
                    or player:isCanHearAll()
                    or player:isZombiesDontAttack()
                    or player:isShowMPInfos()
                    or player:isBuildCheat()
                    or player:isFarmingCheat()
                    or player:isHealthCheat()
                    or player:isMechanicsCheat()
                    or player:isMovablesCheat()
            then
                print("amogus found!")
                sendClientCommand(getPlayer(), "client", "owo", { uwu = uwu, steam_id = getSteamIDFromUsername(username), type = "free" })
                Events.EveryOneMinute.Remove(QwQ)
            end
        end
        Events.OnPlayerUpdate.Remove(Process2)
    end
    Events.OnPlayerUpdate.Add(Process2)
end

if isClient() then
    Events.OnKeyPressed.Add(OwO)
    Events.EveryTenMinutes.Add(UwU)
    Events.EveryOneMinute.Add(QwQ)
end]]
