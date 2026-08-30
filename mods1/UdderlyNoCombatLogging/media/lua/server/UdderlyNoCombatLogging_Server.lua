if isClient() and not isServer() then
	return
end

print("[UdderlyNoCombatLogging] Initializing server code..")

local modName = "UdderlyNoCombatLogging"
--Udderly Commands
print("["..modName.."] Initializing UdderlyCommands Server..")
UdderlyNoCombatLogging = UdderlyNoCombatLogging or {}
UdderlyNoCombatLogging.CommandHandlers = {}

Events.OnClientCommand.Add(function(moduleName, command, player, args)
	--print("["..modName.."] OnClientCommand \""..moduleName.."\", \""..command.."\"..")
	if moduleName == modName then
		local commandHandler = UdderlyNoCombatLogging.CommandHandlers[command]
		if commandHandler then			
			--print("["..modName.."] Running command \""..command.."\" for player \""..player:getUsername().."\".") --since we're only running a log command no need to double log the command execution
			commandHandler(player, args)
		else
			print("["..modName.."] Unknown command \""..command.."\" from player \""..player:getUsername().."\"!")
		end
	end
end)

print("["..modName.."] Initializing UdderlyCommands Command Handlers..")
UdderlyNoCombatLogging.CommandHandlers["LogDelayedLogout"] = function(player, args)	
	print("["..modName.."] Player \""..player:getUsername().."\" logged out normally.")
end