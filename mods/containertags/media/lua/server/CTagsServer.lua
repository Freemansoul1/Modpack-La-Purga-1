-- No client
if not isServer() and CTags:isMultiplayer() then return end

function CTags:cleanupServer()
	CTags:sleepDo(1, CTags.cleanupServer);

	local cleanup = false;
	local CTagsData = ModData.getOrCreate("ContainerTagDataFaction");
	local tagsKeyset={};
	local n=0;
	for k,v in pairs(CTagsData) do
		n= n + 1
		tagsKeyset[n]= k
	end

	local factionsKeyset = {};
	local factions = Faction.getFactions();
	for i=0, factions:size()-1 do
		local faction = factions:get(i);
		local name = faction:getName();
		table.insert(factionsKeyset, name);
	end

	for i, tag in pairs(tagsKeyset) do 
		if not CTags:tableContains(factionsKeyset, tag) then
			print('Removing stale tag data: ' .. tag);
			CTagsData[tag] = nil;
			cleanup = true;
		end
	end

	if cleanup then
		ModData.add("ContainerTagDataFaction", CTagsData);
		ModData.transmit("ContainerTagDataFaction");
	end		
end 

local function Init()
	CTags:sleepDo(0, CTags.cleanupServer);
end 

Events.OnInitGlobalModData.Add(Init);

local function remoteExecServer(module, command, player, args)
	if module ~= "CTags" then return end;
	local CTagsData = ModData.getOrCreate("ContainerTagDataFaction");

	local factionName = args.factionName;
	local playerName = player:getUsername();
	local squareCoords = args.square;
	local squareID = "" .. squareCoords[1] .. "." .. squareCoords[2] .. "." .. squareCoords[3];
	if not CTagsData[factionName] then CTagsData[factionName] = {} end;

	if command == "update" then
		local text = args.tag;
		local color = args.color;

		-- Update
		CTagsData[factionName][squareID] = { ['square'] = {squareCoords[1], squareCoords[2], squareCoords[3]}, ['tag'] = text, ['color'] = {color[1], color[2], color[3]}, ['player'] = playerName }; 
	end 

	if command == "delete" then
		CTagsData[factionName][squareID] = { ['player'] = playerName }; 
	end 

	-- Transmit
	ModData.add("ContainerTagDataFaction", CTagsData);
	ModData.transmit("ContainerTagDataFaction");	
end
Events.OnClientCommand.Add(remoteExecServer);