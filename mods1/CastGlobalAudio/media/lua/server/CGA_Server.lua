------------------------      SERVER        ---------------------------
if isClient() then return; end

local Commands = {}
Commands.DOTD = {}


Commands.DOTD.SendAudio = function(player, args)
    sendServerCommand("DOTD", "ReceiveAudio", {audioSFX = args.audioSFX})
    --getSoundManager():PlayWorldSound(args.audioSFX, args.player:getSquare(), 0, 150, 5, false)
end

--Server sided listener 
Events.OnClientCommand.Add(function(module, command, player, args)
    if Commands[module] and Commands[module][command] then
        Commands[module][command](player, args)
    end
end)
------------------------                 ---------------------------