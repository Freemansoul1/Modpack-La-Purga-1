local function getSteamIDFromPacket(packet)
    local result = {}
    for str in string.gmatch(packet.logText, "([^" .. "]" .. "]+)") do
        table.insert(result, string.sub(str, 2))
    end
    return result[1]
end

local function encodeTable(t)
    local toReturn = "";
    for k, v in pairs(t) do
        toReturn = toReturn .. tostring(v) .. ",";
    end
    return string.sub(toReturn, 1, -2)
end

local function decodeTable(txt, player)
    local toReturn = {}
    for str in string.gmatch(txt, "([^" .. "," .. "]+)") do
        table.insert(toReturn, str)
    end
    print("[SaveReputationSystem] Decoded successfully!")
    sendServerCommand(player, "server", "onReceive", { playerData = toReturn })
    print("[SaveReputationSystem] Data send!")
end

function SaveFile(t, name)
    print("[SaveReputationSystem] Trying to save table to file " .. name .. ".txt..")
    local fileWriterObj = getFileWriter(name .. ".txt", true, false);
    local text = encodeTable(t);
    fileWriterObj:write(text);
    fileWriterObj:close();
    print("[SaveReputationSystem] Table saved to file " .. name .. ".txt successfully!")
end

function LoadFile(name, player)
    print("[SaveReputationSystem] Trying to load file " .. name .. ".txt..")
    local fileReaderObj = getFileReader(name .. ".txt", false);
    local text = "";
    if fileReaderObj then
        local line = fileReaderObj:readLine();
        while line ~= nil do
            text = text .. line;
            line = fileReaderObj:readLine()
        end
        fileReaderObj:close();
    end

    if text and text ~= "" then
        print("[SaveReputationSystem] File " .. name .. ".txt loaded successfully!")
        print("[SaveReputationSystem] Decoding..")
        decodeTable(text, player)
    else
        print("[SaveReputationSystem] Empty file " .. name .. ".txt loaded successfully!")
        sendServerCommand(player, "server", "onReceive", { playerData = {} })
        print("[SaveReputationSystem] Empty table sent!")
    end
end

SaveReputationServer = {}

SaveReputationServer.writeLog = function(packet, player)
    if string.find(packet.logText, "Login") then
        print(string.format("[SaveReputationSystem] Player %s connected!", player:getUsername()))
        LoadFile(string.format("PlayersReputation/%s", getSteamIDFromPacket(packet)), player)
    end
end

SaveReputationServer.saveReputation = function(data, player)
    SaveFile(data.playerData, string.format("PlayersReputation/%s", data.steamid))
    print("[SaveReputationSystem] Data saved!")
end

SaveReputationServer.dropReputation = function(data, player)
    SaveFile({}, string.format("PlayersReputation/%s", data.steamid))
    print("[SaveReputationSystem] Data dropped!")
end

function SaveReputationServer:onClientCommand(command, player, data)
    if SaveReputationServer[command] then
        SaveReputationServer[command](data, player)
    end
end

if isServer() then
    Events.OnClientCommand.Add(SaveReputationServer.onClientCommand)
end