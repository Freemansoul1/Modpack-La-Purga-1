--***********************************************************
--**                THE PLANET ALGOL IS STONED             **
--***********************************************************

if isClient() then return end

local VehicleCommands = {}
local Commands = {}

VehicleCommands.wantNoise = getDebug() or false

local noise = function(msg)
	if VehicleCommands.wantNoise then
		print('VehicleCommands: '..msg)
	end
end




function Commands.CutLine(player, args)
	-- local vehicle = getVehicleById(args.vehicle)
	-- if vehicle then
	print("Someone is being naughty and spicy and cut someone's brake line!")
		print(tostring(args.cutLog))
	-- else
		-- noise('no such vehicle id='..tostring(args.vehicle))
	-- end
end



VehicleCommands.OnClientCommand = function(module, command, player, args)
	if module == 'PA_CutBrakeLine' and Commands[command] then
		local argStr = ''
		args = args or {}
		for k,v in pairs(args) do
			argStr = argStr..' '..k..'='..tostring(v)
		end
		noise('received '..module..' '..command..' '..tostring(player)..argStr)
		Commands[command](player, args)
	end
end

Events.OnClientCommand.Add(VehicleCommands.OnClientCommand)
