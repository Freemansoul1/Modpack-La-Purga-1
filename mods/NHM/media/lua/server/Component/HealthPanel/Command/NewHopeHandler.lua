if isClient() then
    return
end

local commands = {}

commands.wantNoise = getDebug() or false

local noise = function(msg)
    if commands.wantNoise then
        print('New Hope Commands: ' .. msg)
    end
end

function commands.onReceiveHealthPanelAction(command, player, args)
    local character = getPlayerByOnlineID(args.characterOnlineID)
    if not character then
        noise('character doesn\'t exist')
        return
    end

    local otherPlayer = getPlayerByOnlineID(args.otherPlayerOnlineID)
    if not otherPlayer then
        noise('otherPlayer doesn\'t exist')
        return
    end

    sendServerCommand(otherPlayer, 'NewHope', command, args)
end

local onClientCommand = function(module, command, player, args)
    if module == 'NewHope' then
        local argStr = ''
        args = args or {}
        for k, v in pairs(args) do
            argStr = argStr .. ' ' .. k .. '=' .. tostring(v)
        end

        noise('received ' .. module .. ' ' .. command .. ' ' .. tostring(player) .. argStr)
        commands.onReceiveHealthPanelAction(command, player, args)
    end
end

Events.OnClientCommand.Add(onClientCommand)
