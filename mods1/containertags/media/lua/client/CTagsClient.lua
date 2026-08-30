if isServer() then return end

-- Add context action
local function contextFunc(player, context, worldobjects, test)
	CTags:contextFunction(player, context, worldobjects, test)
end
Events.OnFillWorldObjectContextMenu.Add(contextFunc);

function CTags:formDrawData(data, faction)
	local player = getPlayer();

	for i, tag in pairs(data) do 
		local squareCoords = tag.square;
		if squareCoords then
			if player:getZ() == squareCoords[3] then 
				local square = getCell():getGridSquare(squareCoords[1], squareCoords[2], squareCoords[3]);
				if square then 
					local objects = square:getObjects();
					local isPresent = false;
					for j=0, objects:size()-1 do
						local object = objects:get(j);
						local container = object:getContainer();
						if container then
							table.insert(CTags.drawData, { ['square'] = square, ['coords'] = squareCoords, ['text'] = tag.tag, ['color'] = tag.color });
							isPresent = true;
							break
						end
					end

					-- Not anymore, cleanup
					if not isPresent then
						local squareID = "" .. squareCoords[1] .. "." .. squareCoords[2] .. "." .. squareCoords[3];
						if faction then 
							local factionName = faction:getName();
							sendClientCommand(player, "CTags", "delete", { ['factionName'] = factionName, ['square'] = {square:getX(), square:getY(), square:getZ()} });
						else
							local tagData = ModData.getOrCreate("ContainerTagData");
							tagData.tags[squareID] = {};
						end 
					end 
				end				
			end			
		end
	end
end 

-- Tag tracker
function CTags:tagTracker()
	CTags:sleepDo(0.25, CTags.tagTracker);

	-- Clear drawData
	CTags.drawData = {}; 

	-- Disabled, exit
	if CTags.mode == 0 then return end;
	local player = getPlayer();

	-- Check if faction was disbanded
	if CTags.mode == 2 and not CTags:getFaction() then
		CTags.mode = 1;
		CTagsPanel.button:setImage(getTexture("media/textures/note.png"));
	end

	-- Personal tags only
	if CTags.mode == 1 then 
		local tagData = ModData.getOrCreate("ContainerTagData");
		if not tagData.tags then tagData.tags = {} end;
		local data = tagData.tags;

		CTags:formDrawData(data);
	end 
	-- Faction tags only
	if CTags.mode == 2 then
		local faction = CTags:getFaction(); 

		if faction then 
			local factionName = faction:getName();
			local tagData = ModData.getOrCreate("ContainerTagDataFaction");
			if not tagData[factionName] then tagData[factionName] = {} end;
			local data = tagData[factionName];
			CTags:formDrawData(data, faction);
		end 
	end 

	-- Run overlays
	if getPlayer() and not CTagsOverlay.window then
		CTagsOverlay:make()
	end 

	if getPlayer() and not CTagsPanel.window then
		local faction = CTags:getFaction()
		if faction then 
			CTags.mode = 2;
		else 
			CTags.mode = 1;
		end		
		CTagsPanel:make()
	end
end


-- Runtime
local function OnInitGlobalModData(isNewGame)
	ModData.request("ContainerTagDataFaction");
	CTags:sleepDo(0, CTags.tagTracker);
end	
Events.OnInitGlobalModData.Add(OnInitGlobalModData)

local function OnReceiveGlobalModData(module, packet)
	if module == "ContainerTagDataFaction" then
		if packet then
			ModData.add(module, packet)
		end
	end	
end

Events.OnReceiveGlobalModData.Add(OnReceiveGlobalModData)
