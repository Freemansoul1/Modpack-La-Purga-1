-- +================================================================+
-- |                                                                |
-- |                        /##         /##             /##         |
-- |                       | ##       /####            | ##         |
-- |     /#######  /#######| ####### |_  ##   /########| ##   /##   |
-- |    /##_____/ /##_____/| ##__  ##  | ##  |____ /##/| ##  /##/   |
-- |   |  ###### | ##      | ##  \ ##  | ##     /####/ | ######/    |
-- |    \____  ##| ##      | ##  | ##  | ##    /##__/  | ##_  ##    |
-- |    /#######/|  #######| ##  | ## /###### /########| ## \  ##   |
-- |   |_______/  \_______/|__/  |__/|______/|________/|__/  \__/   |
-- |                                                                |
-- +================================================================+

SKnockedDown = SKnockedDown or {}

local wantNoise = getDebug()
local noise = function(msg)
	if (wantNoise) then print('ClientCommand: '..msg) end
end

function SKnockedDown.sendKnockedDownStateToAllPlayers(initiator, state)
	local players = getOnlinePlayers();
	if players then
		for i=1,players:size() do
			local player = players:get(i-1)
			if player and player ~= initiator then
				local args = { id = initiator:getOnlineID(), state = state };
				sendServerCommand(player, "knockedd", "update", args);
			end
		end
	end
end

function SKnockedDown.sendKnockedDownStateOfAllPlayers(initiator)
	local players = getOnlinePlayers();
	if players then
		for i=1,players:size() do
			local player = players:get(i-1)
			if player and player ~= initiator and player:getModData().knockedd and player:getModData().knockedd.state == "fall" then
				local args = { id = player:getOnlineID(), state = player:getModData().knockedd.state };
				sendServerCommand(initiator, "knockedd", "update", args);
			end
		end
	end
end

local Commands = {}
Commands.knockedd = {}
Commands.knockedd.update = function(player, args)
	if not args.state then return end
	if not player:getModData().knockedd then
		player:getModData().knockedd = {}
	end
	if args.state == "fall" then
		player:getModData().knockedd.state = args.state;
	else
		player:getModData().knockedd.state = nil;
	end
	SKnockedDown.sendKnockedDownStateToAllPlayers(player, args.state);
end

Commands.knockedd.helpupknocked = function(player, args)
	if not args.id then return end
	local knockedPlayer = getPlayerByOnlineID(args.id)
	if not knockedPlayer then return end

	local args = { id = player:getOnlineID() };
	sendServerCommand(knockedPlayer, "knockedd", "helpupknocked", args);
end

Commands.knockedd.requestknockedstates = function(player, args)
	SKnockedDown.sendKnockedDownStateOfAllPlayers(player)
end

Commands.knockedd.getsync = function(player, args)
	local args = { ts = getTimestampMs(), lastts = args.ts };
	sendServerCommand(player, "knockedd", "getsync", args);
end

local function onClientCommand(module, command, player, args)
	if Commands[module] and Commands[module][command] then
		local argStr = ''
		for k,v in pairs(args) do argStr = argStr..' '..k..'='..tostring(v) end
		noise('received '..module..' '..command..' '..tostring(player)..argStr)
		Commands[module][command](player, args)
	end
end

Events.OnClientCommand.Add(onClientCommand)