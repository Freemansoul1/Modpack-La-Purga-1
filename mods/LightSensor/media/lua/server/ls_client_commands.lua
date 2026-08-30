LSServer = {}
LSServer.Commands = {}
LSServer.Broadcaster = {}

LSServer.Commands.AddSensor = function(player, args)
    local globalModData = GetLightSensorsModData()
    local k = LSUtils.Coords2Id(args.x, args.y, args.z)
    globalModData.LightSensors[k] = args
end

LSServer.Commands.UpdateSensor = function(player, args)
    local globalModData = GetLightSensorsModData()
    local k = LSUtils.Coords2Id(args.x, args.y, args.z)
    if globalModData.LightSensors[k] then
        globalModData.LightSensors[k] = args
    end
end

LSServer.Commands.RemoveSensor = function(player, args)
    local globalModData = GetLightSensorsModData()
    local k = LSUtils.Coords2Id(args.x, args.y, args.z)
    globalModData.LightSensors[k] = nil
end

LSServer.Commands.UpdatePlayer = function(player, args)
    local globalModData = GetLightSensorsModData()
    local k = args.id
    globalModData.NetworkPlayers[k] = args
end

LSServer.Broadcaster.WakeUp = function(player, args)
    sendServerCommand('Commands', 'WakeUp', args)
end

-- main
local onLightSensorsClientCommand = function(module, command, player, args)
    if LSServer[module] and LSServer[module][command] then
        local argStr = ""
        for k, v in pairs(args) do
            argStr = argStr .. " " .. k .. "=" .. tostring(v)
        end
        -- print ("received " .. module .. "." .. command .. " "  .. argStr)
        LSServer[module][command](player, args)
        TransmitLightSensorsModData()
    end
end

print ("-------------------------------")
print ("- light sensors server ready  -")
print ("-------------------------------")

Events.OnClientCommand.Add(onLightSensorsClientCommand)
