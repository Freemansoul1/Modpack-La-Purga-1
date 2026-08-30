if isServer() then return end

rmSquareCoord = {} -- Coordinates of squares want to remove or restore indoor

--*************************************************************************************--
--** Request indoor removed squares info on game load **
--*************************************************************************************--
local function requestSquares()
	local player = getPlayer()
	sendClientCommand("RmIndoor", "requestSquares", {player:getOnlineID()})
end

Events.OnLoad.Add(requestSquares)

--*************************************************************************************--
--** On loading indoor removed squares **
--*************************************************************************************--
local function onLoadSquare(square)
    if square:getModData().roomId then
		square:setRoomID(-1)
	end
end

Events.LoadGridsquare.Add(onLoadSquare)

--*************************************************************************************--
--** Send squares info to server for removing indoors **
--*************************************************************************************--
local function removeSquares(worldObjects)
	local coord = rmSquareCoord

    if coord.z1 ~= coord.z2 then
        getPlayer():Say(getText("Remove Indoor Cancel"))
        return
    end

	local squares = {}
    for i = math.min(coord.x1, coord.x2) , math.max(coord.x1, coord.x2) do
        for j = math.min(coord.y1, coord.y2) , math.max(coord.y1, coord.y2) do
            local square = getSquare(i, j, coord.z1)
            if square and square:getRoom() then
				table.insert(squares, {i, j, coord.z1, square:getRoomID()})
            end
        end
    end
	
	sendClientCommand("RmIndoor", "removeIndoor", squares)
    rmSquareCoord = {}
	getPlayer():Say(getText("Remove Indoor Finish"))
end

--*************************************************************************************--
--** Send squares info to server for restoring indoors **
--*************************************************************************************--
local function restoreSquares(worldObjects)
	local coord = rmSquareCoord

    if coord.z1 ~= coord.z2 then
        getPlayer():Say(getText("Restore Indoor Cancel"))
        return
    end

	local squares = {}
    for i = math.min(coord.x1, coord.x2) , math.max(coord.x1, coord.x2) do
        for j = math.min(coord.y1, coord.y2) , math.max(coord.y1, coord.y2) do
            local square = getSquare(i, j, coord.z1)
            if square and square:getModData().roomId then
				table.insert(squares, {i, j, coord.z1})
            end
        end
    end
	
	sendClientCommand("RmIndoor", "restoreIndoor", squares)
    rmSquareCoord = {}
	getPlayer():Say(getText("Restore Indoor"))
end

--*************************************************************************************--
--** Request restoring all indoors **
--*************************************************************************************--
local function restoreAllSquares(worldObjects)
	local player = getPlayer()
	
	sendClientCommand("RmIndoor", "restoreAllIndoor", {true})
	getPlayer():Say(getText("Restore All Indoor"))
end

--*************************************************************************************--
--** Add context menu option **
--*************************************************************************************--
local function removeIndoorContext(_player, _context, _worldObjects, _test)
    local player = getPlayer()
	
	if isClient() and not isAdmin() then return end	-- Only admin remove indoor in MP
	
	local floorObject = _worldObjects[1]
	local square = floorObject:getSquare()
	local subMenu = ISContextMenu:getNew(_context)
	
	local removeIndoorOption = _context:addOption(getText("Remove Indoor"), _worldObjects)
	_context:addSubMenu(removeIndoorOption, subMenu)
	
	local coordinate1 = getText("Set Coordinate 1")
	if rmSquareCoord.x1 and rmSquareCoord.y1 and rmSquareCoord.z1 then
		coordinate1 = " (" .. tostring(rmSquareCoord.x1) .. ", " .. tostring(rmSquareCoord.y1) .. ", " .. tostring(rmSquareCoord.z1) .. ")"
	end
	
	local coordinate2 = getText("Set Coordinate 2")
	if rmSquareCoord.x2 and rmSquareCoord.y2 and rmSquareCoord.z2 then
		coordinate2 = " (" .. tostring(rmSquareCoord.x2) .. ", " .. tostring(rmSquareCoord.y2) .. ", " .. tostring(rmSquareCoord.z2) .. ")"
	end
	
	subMenu:addOption(coordinate1, _worldObjects, function()
		local flootObject = _worldObjects[1]
		
		rmSquareCoord.x1 = flootObject:getX()
		rmSquareCoord.y1 = flootObject:getY()
		rmSquareCoord.z1 = flootObject:getZ()
		
		if rmSquareCoord.x2 and rmSquareCoord.y2 and rmSquareCoord.z2 then
			player:Say((math.abs(rmSquareCoord.x1 - rmSquareCoord.x2) + 1) .. " * " .. (math.abs(rmSquareCoord.y1 -rmSquareCoord.y2) + 1).. " Tiles Selected")
		end
	end)
	
	subMenu:addOption(coordinate2, _worldObjects, function()
		local flootObject = _worldObjects[1]
		
		rmSquareCoord.x2 = flootObject:getX()
		rmSquareCoord.y2 = flootObject:getY()
		rmSquareCoord.z2 = flootObject:getZ()
		
		if rmSquareCoord.x1 and rmSquareCoord.y1 and rmSquareCoord.z1 then
			player:Say((math.abs(rmSquareCoord.x1 - rmSquareCoord.x2) + 1) .. " * " .. (math.abs(rmSquareCoord.y1 -rmSquareCoord.y2) + 1).. " Tiles Selected")
		end
	end)
	
	if rmSquareCoord.x1 and rmSquareCoord.x2 and rmSquareCoord.y1 and rmSquareCoord.y2 and rmSquareCoord.z1 and rmSquareCoord.z2 then
        subMenu:addOption(getText("Do Remove Indoor"), _worldObjects, removeSquares)
		subMenu:addOption(getText("Do Restore Indoor"), _worldObjects, restoreSquares)
    end
	
	subMenu:addOption(getText("Do Restore All Indoor"), _worldObjects, restoreAllSquares)
end

Events.OnFillWorldObjectContextMenu.Add(removeIndoorContext)

local serverCommands = {} -- Handle server commands

local function onServerCommand(module, command, arguments)
	if module ~= "RmIndoor" then return end
	
	if serverCommands[command] then
		--print("[RM] Server Command Received : ", command)
		serverCommands[command](arguments)
	end
end

Events.OnServerCommand.Add(onServerCommand)

--*************************************************************************************--
--** Receive squares info from server **
--*************************************************************************************--
serverCommands.removeIndoor = function(args)
	local squares = args
	
	for i, v in pairs(squares) do
		local square = getCell():getGridSquare(v[1], v[2], v[3])
		if square then
			if not square:getModData().roomId then
				square:getModData().roomId = v[4]
			end
			square:setRoomID(-1)
		end
	end
end

serverCommands.restoreIndoor = function(args)
	local squares = args
	
	for i, v in pairs(squares) do
		local square = getCell():getOrCreateGridSquare(v[1], v[2], v[3])
		if square and square:getModData().roomId then
			square:setRoomID(v[4])
			square:getModData().roomId = nil
		end
	end
end

