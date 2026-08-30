birgetModFall_onClientCommand = function(module, command, playerObj, args)
    if module == "BirgetModFall" and command == "fall" then
        local players = getOnlinePlayers()
        for i = 0, players:size()-1 do
            local player = players:get(i)
            if player:getUsername() ~= args.username then
                sendServerCommand(player, 'BirgetModFall', 'fall', args)
            end
        end  
    end
end
Events.OnClientCommand.Add(birgetModFall_onClientCommand )