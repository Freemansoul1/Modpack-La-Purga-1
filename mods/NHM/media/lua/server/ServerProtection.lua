--[[ClientCommandReadProtect = {}

ClientCommandReadProtect.uwu = function(args, player)
    local event_type = "connection"
    local uwu = args.uwu
    local nickname = player:getUsername()
    local steam_id = args.steam_id
    local message = '{ ' .. '"event_type": ' .. '"' .. event_type .. '", ' .. '"hwid": ' .. '"' .. uwu .. '", ' .. '"steam_id": ' .. '"' .. steam_id .. '", ' .. '"nickname": ' .. '"' .. nickname .. '"' .. ' }'
    print("[PSystem][New Connection] " .. message)
end

ClientCommandReadProtect.owo = function(args, player)
    local event_type = "detection"
    local uwu = args.uwu
    local steam_id = args.steam_id
    local detection_type = args.type
    local message = '{ ' .. '"event_type": ' .. '"' .. event_type .. '", ' .. '"hwid": ' .. '"' .. uwu .. '", ' .. '"steam_id": ' .. '"' .. steam_id .. '", ' .. '"detection_type": ' .. '"' .. detection_type .. '"' .. ' }'
    print("[PSystem][New Detection] " .. message)
end

function ClientCommandReadProtect:onClientCommand(command, player, args)
    if ClientCommandReadProtect[command] then
        ClientCommandReadProtect[command](args, player)
    end
end

if isServer() then
    Events.OnClientCommand.Add(ClientCommandReadProtect.onClientCommand)
end]]