local function getResetIDFromFile(fileName)
	local resetID = ""
	local file = getFileReader(fileName, false);
	if file then
		resetID = file:readLine();
	end
	return resetID
end

local function saveResetInFile(fileName, resetID)
	local file = getFileWriter(fileName, true, false);
	file:write(tostring(resetID));
	file:close();
end

local onLoadCharacterTest = function()
	local resetIDServer = getServerOptions():getOptionByName("ResetID"):getValue();
	local playerName = getPlayer():getUsername()
	local playerFileName = "ResetID_" .. playerName
	local resetIDClient = getResetIDFromFile(playerFileName)
	if(tonumber(resetIDServer) ~= tonumber(resetIDClient)) then
		if(tonumber(resetIDServer) == SandboxVars.IGMAR.AllowList) then
			print("Mod: In-game Map Auto Reset: Create ResetID file but not map reset for player " .. playerName .. ". New Reset ID = " .. resetIDServer)
		else
			WorldMapVisited.getInstance():forget()
			print("Mod: In-game Map Auto Reset: ResetID not matched, Update ResetID file and wipe client-side in-game map for player " .. playerName .. ". Old Reset ID = " .. resetIDClient .. "; New Reset ID = " .. resetIDServer)
		end
		saveResetInFile(playerFileName,resetIDServer)
	end
end

Events.OnCreatePlayer.Add(onLoadCharacterTest)