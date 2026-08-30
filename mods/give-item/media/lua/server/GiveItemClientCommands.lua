if isClient() then return end

GiveItemClientCommands = GiveItemClientCommands or {}

function GiveItemClientCommands.onGiveItem(player, args)
	local argsWithId = args
	local otherPlayer = getPlayerByOnlineID(args.receiverID)
    sendServerCommand(otherPlayer, "giveitem", "onReceiveItem", argsWithId)
end

function GiveItemClientCommands.onItemReceived(player, args)
	local otherPlayer = getPlayerByOnlineID(args.senderID)
	sendServerCommand(otherPlayer, "giveitem", "onFinalizeTransaction", args)
end

GiveItemClientCommands.OnClientCommand = function(module, command, player, args)
	if module == "giveitem" and GiveItemClientCommands[command] then
		local argStr = ''
		for k,v in pairs(args) do argStr = argStr..' '..k..'='..tostring(v) end
		--print('received '..module..' '..command..' '..tostring(player)..argStr)
		GiveItemClientCommands[command](player, args)
	end
end

Events.OnClientCommand.Add(GiveItemClientCommands.OnClientCommand)