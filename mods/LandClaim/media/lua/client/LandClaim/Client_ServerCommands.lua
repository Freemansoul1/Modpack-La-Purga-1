local MODULE = 'LandClaim_Client'

local ClientCommands = {}

ClientCommands.OnModAuth = function(player, data)
end

local OnClientCommand = function(module, command, playerObj, args)
    if module == MODULE and ClientCommands[command] then
        ClientCommands[command](playerObj, args)
    end
end

Events.OnClientCommand.Add(OnClientCommand)
