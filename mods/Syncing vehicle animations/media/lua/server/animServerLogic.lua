local function OnClientCommand(module, command, player, args)
	if module == 'vehicle' and command == 'setDoorOpen' then
		local args = { vehicle = args.vehicle, part = args.part, open = args.open, username = player:getUsername()}
    sendServerCommand('vehicle', 'setDoorAnim', args)
	end
end

Events.OnClientCommand.Add(OnClientCommand)
