local MeditationServer = {}

MeditationServer.changeAnimationState = function(mod, command, player, arguments)
	
	if mod ~= "Meditation" or command ~= "Animation Toggle" then return end
	
	sendServerCommand(mod, command, arguments)

end

Events.OnClientCommand.Add(MeditationServer.changeAnimationState)

return MeditationServer
