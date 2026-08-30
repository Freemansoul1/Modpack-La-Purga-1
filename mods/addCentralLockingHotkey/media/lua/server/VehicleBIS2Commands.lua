if isClient() then return end
-----------------------------------------------------------------------------------------------------------------------------------------------------------
local VehicleBIS2Commands = {}
local Commands = {}

VehicleBIS2Commands.wantNoise = getDebug() or false

local noise = function(msg)
	if VehicleBIS2Commands.wantNoise then
		--print('VehicleBIS2Commands: '..msg)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------

function Commands.setTrunkLocked(player, args)
	--local vehicle = args.vehicle--player:getUseableVehicle()
	local vehicle = getVehicleById(args.vehicle)

	if vehicle then

		vehicle:setTrunkLocked(args.locked)
		--local part = vehicle:getTrunkLocked()
		--vehicle:transmitPartDoor(part)
	else
		noise('no vehicle')
	end
end


-----------------------------------------------------------------------------------------------------------------------------------------------------------
VehicleBIS2Commands.OnClientCommand = function(module, command, player, args)
	if module == 'vehiclebis2' and Commands[command] then
		local argStr = ''
		args = args or {}
		for k,v in pairs(args) do
			argStr = argStr..' '..k..'='..tostring(v)
		end
		noise('received '..module..' '..command..' '..tostring(player)..argStr)
		Commands[command](player, args)
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------
Events.OnClientCommand.Add(VehicleBIS2Commands.OnClientCommand);
-----------------------------------------------------------------------------------------------------------------------------------------------------------
