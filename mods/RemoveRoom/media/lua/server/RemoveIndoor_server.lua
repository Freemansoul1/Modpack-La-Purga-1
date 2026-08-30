if isClient() then return end

local function checkModData()
    if not ModData.exists("RemoveIndoor") then
        ModData.add("RemoveIndoor", {
            squares = {}
        })
    end
end

local function onServerStart()
	checkModData()
	local modData = ModData.get("RemoveIndoor").squares
	for i, v in pairs(modData) do
		local square = getCell():getGridSquare(v[1], v[2], v[3])
		if square then
			square:getModData().roomId = v[4]
			square:setRoomID(-1)
		end
	end
end

local function onLoadSquare(square)
    if square:getModData().roomId then
		square:setRoomID(-1)
	end
end

if isServer() then
	Events.OnServerStarted.Add(onServerStart)
	Events.LoadGridsquare.Add(onLoadSquare)
end

local clientCommands = {} -- Handle client commands

local function onClientCommand(module, command, player, arguments)
	if module ~= "RmIndoor" or not arguments then return end
	
	if clientCommands[command] then
		--print("[RM] Client Command Received : ", command)
		clientCommands[command](arguments)
	end
end

Events.OnClientCommand.Add(onClientCommand)

--*************************************************************************************--
--** Send indoor removed squares info to client **
--*************************************************************************************--
clientCommands.requestSquares = function(args)
	checkModData()
	local modData = ModData.get("RemoveIndoor").squares
	local squares = {}
	
	for i, v in pairs(modData) do
		table.insert(squares, {v[1], v[2], v[3], v[4]})
	end
	
	if isServer() then
		sendServerCommand(getPlayerByOnlineID(args[1]), "RmIndoor", "removeIndoor", squares)
	else
		triggerEvent("OnServerCommand", "RmIndoor", "removeIndoor", squares)
	end
end

--*************************************************************************************--
--** Receive squares info from client and send to clients what they want **
--*************************************************************************************--
clientCommands.removeIndoor = function(args)
	checkModData()
	local modData = ModData.get("RemoveIndoor").squares
	local squares = {}
	
	for i, v in pairs(args) do
		table.insert(modData, {v[1], v[2], v[3], v[4]})
		table.insert(squares, {v[1], v[2], v[3], v[4]})
		if isServer() then
			local square = getCell():getGridSquare(v[1], v[2], v[3])
			if square then
				square:getModData().roomId = v[4]
				square:setRoomID(-1)
			end
		end
	end
	
	if isServer() then
		sendServerCommand("RmIndoor", "removeIndoor", squares)
	else
		triggerEvent("OnServerCommand", "RmIndoor", "removeIndoor", squares)
	end
end

clientCommands.restoreIndoor = function(args)
	checkModData()
	local modData = ModData.get("RemoveIndoor").squares
	local squares = {}
	
	for i, v in pairs(args) do
		for j, k in pairs(modData) do
			if v[1] == k[1] and v[2] == k[2] and v[3] == k[3] then
				if isServer() then
					local square = getCell():getGridSquare(v[1], v[2], v[3])
					if square and square:getModData().roomId then
						square:setRoomID(v[4])
						square:getModData().roomId = nil
					end
				end
				table.insert(squares, {v[1], v[2], v[3], v[4]})
				modData[j] = nil
			end
		end
	end
	
	if isServer() then
		sendServerCommand("RmIndoor", "restoreIndoor", squares)
	else
		triggerEvent("OnServerCommand", "RmIndoor", "restoreIndoor", squares)
	end
end

--*************************************************************************************--
--** Send all squares info and clear moddata **
--*************************************************************************************--
clientCommands.restoreAllIndoor = function(args)
	checkModData()
	local modData = ModData.get("RemoveIndoor").squares
	local squares = {}
	
	for i, v in pairs(modData) do
		if isServer() then
			local square = getCell():getGridSquare(v[1], v[2], v[3])
			if square and square:getModData().roomId then
				square:setRoomID(v[4])
				square:getModData().roomId = nil
			end
		end
		table.insert(squares, {v[1], v[2], v[3], v[4]})
		modData[i] = nil
	end
	
	if isServer() then
		sendServerCommand("RmIndoor", "restoreIndoor", squares)
	else
		triggerEvent("OnServerCommand", "RmIndoor", "restoreIndoor", squares)
	end
end