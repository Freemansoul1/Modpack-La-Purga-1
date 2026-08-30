local Commands = {}

function Commands.knockOtherPlayerOut(onlineID)
	local player = getPlayerByOnlineID(onlineID)
	sendServerCommand(player, 'RealKnockouts', 'knockOtherPlayerOut', {onlineID})
end

function Commands.wakeOtherPlayerUp(onlineID)
	local player = getPlayerByOnlineID(onlineID)
	sendServerCommand(player, 'RealKnockouts', 'wakeOtherPlayerUp', {onlineID})
end

function Commands.CheckKnockoutStatus(playerObjID, onlineID)
	local player = getPlayerByOnlineID(onlineID)
	local args = {playerObjID}

	sendServerCommand(player, 'RealKnockouts', 'CheckKnockoutStatus', args)
end

function Commands.CheckKnockoutStatusResponse(playerObjID, response)
	local player = getPlayerByOnlineID(playerObjID)
	local args = {response}

	sendServerCommand(player, 'RealKnockouts', 'CheckKnockoutStatusResponse', args)
end


local function OnClientCommand(module, command, player, args)
    if module == 'RealKnockouts' then
    	if command == 'CheckKnockoutStatus' or command == 'CheckKnockoutStatusResponse' then
    		Commands[command](args[1], args[2])
    	else
        	Commands[command](args[1])
        end
    end
end

Events.OnClientCommand.Add(OnClientCommand)