local MapJson = require('MAPJSON')
--require("GameTime")

ServerSyncMap = { }

function ServerSyncMap:Save(table)
    local fileWriterObj = getFileWriter("GlobalMapSymbols.json", true, false);
    local json = MapJson:encode(table);
    fileWriterObj:write(json);
    fileWriterObj:close();
end

function ServerSyncMap:Load()
    local fileReaderObj = getFileReader("GlobalMapSymbols.json", true);
    local text = "";
    local line = fileReaderObj:readLine()
    while line do
        text = text..line
        line = fileReaderObj:readLine()
    end
    fileReaderObj:close()

    if text and text ~= "" then
        return MapJson:decode(text);
    end
end

function ServerSyncMap:init()
    print("[Global Map] Initializing mod..")
    local jsonTable = ServerSyncMap:Load()
    print("[Global Map] Mod initialization completed!")
end

ServerSyncMap.savejson = function(table, player)
    ServerSyncMap:Save(table)
    sendServerCommand(player, "server", "storetable", table)
end

ServerSyncMap.loadmap = function(args, player)
    local thisTable = ServerSyncMap:Load()
    sendServerCommand(player, "server", "storetable", thisTable)
end

function ServerSyncMap:onClientCommand(command, player, args)
    if ServerSyncMap[command] then
        ServerSyncMap[command](args, player)
    end
end

Events.OnServerStarted.Add(ServerSyncMap.init)

if isServer() then
    Events.OnClientCommand.Add(ServerSyncMap.onClientCommand)
end