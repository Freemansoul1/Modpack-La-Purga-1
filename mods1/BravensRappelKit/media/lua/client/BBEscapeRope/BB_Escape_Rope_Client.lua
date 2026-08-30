--***********************************************************
--**                       BitBraven                       **
--***********************************************************

local function onServerCommand(module, command, args)
    if module ~= "EscapeRope" then return end
    if command ~= "RescuePlayer" then return end
    if not isClient() then return end
	BB_Escape_Rope.RescuePlayer(getPlayer(), args.x, args.y, args.z)
end

Events.OnServerCommand.Add(onServerCommand)