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

local wantNoise = getDebug()
local noise = function(msg)
	if (wantNoise) then print('ClientCommand: '..msg) end
end

SForcedSync = SForcedSync or {}
SForcedSync.Server = {}

function SForcedSync.Server.getPlayersAroundPlayer(player, args)
	local players = getOnlinePlayers();
	if players then
		for i=1,players:size() do
			local p = players:get(i-1)
			if p and p ~= player then
				if p:getX() >= args.x - 50 and p:getX() < args.x + 50 and p:getY() >= args.y - 50 and p:getY() < args.y + 50 then
                    local args = { id = p:getOnlineID(), x = p:getX(), y = p:getY(), z = p:getZ() }
					sendServerCommand(player, "playersync", "forcesync", args)
				end
			end
		end
	end
end

function SForcedSync.Server.getPlayerByID(player, args)
    local otherPlayer = getPlayerByOnlineID(args.id);
    if otherPlayer then
		local args = { id = otherPlayer:getOnlineID(), x = otherPlayer:getX(), y = otherPlayer:getY(), z = otherPlayer:getZ() }
		sendServerCommand(player, "playersync", "forcesync", args)
    end
end

local Commands = {}
Commands.playersync = {}
Commands.playersync.forcesyncaround = function(player, args)
    SForcedSync.Server.getPlayersAroundPlayer(player, args);
end

Commands.playersync.forcesyncone = function(player, args)
	SForcedSync.Server.getPlayerByID(player, args)
end

Commands.playersync.sendzombiedata = function(player, args)
    if args.zombieid and args.x and args.y and args.z then
		local players = getOnlinePlayers();
		if players then
			for i=1,players:size() do
				local p = players:get(i-1)
				if p and p ~= player then
					if p:getX() >= args.x - 15 and p:getX() < args.x + 15 and p:getY() >= args.y - 15 and p:getY() < args.y + 15 then
						local args = {
							zombieid = args.zombieid,
							x = args.x,
							y = args.y,
							z = args.z
						}
						sendServerCommand(p, "playersync", "zombiesync", args)
					end
				end
			end
		end
    end
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