-----------------------------------------------------
--Visit Sunday Drivers for the latest and greatest!--
--mod by lect----------------------------------------
--Free to use with permission------------------------
-----------------------------------------------------

zonetier = {1, 2, 3, 4}

Zone = {
	list = {
		["LouisvillePD"] 		= {11836, 1201, 12905, 1950, zonetier[4]},
		["LouisvilleMallArea"] 	= {12905, 625, 13800, 1950, zonetier[4]},
		["Louisville"] 			= {11700, 900, 15000, 4800, zonetier[3], "Nested"},
		["Muldraugh"] 			= {9900, 8400, 12300, 11400, zonetier[2]},
		["WestPoint"] 			= {10220, 6300, 12900, 7500, zonetier[2]},
		["Riverside"] 			= {5400, 5100, 7800, 6300, zonetier[2]},
		["Rosewood"] 			= {7500, 10800, 9300, 12600, zonetier[2]},
		["MarchRidge"] 			= {9600, 12300, 10500, 13500, zonetier[2]},
		["Minas"] 			= {8999, 6814, 9199, 7206, zonetier[4]},
		["Purgatown"] 			= {8168, 6481, 9000, 7483, zonetier[3]},
		["MontanaNegra"] 			= {6000, 10799, 6300, 11099, zonetier[2]},
		["Bunker"] 			= {9084, 4845, 9240, 4957, zonetier[4]},
		["Sims"] 			= {15000, 3952, 15600, 4500, zonetier[2]},
		["Black"] 			= {7790, 10500, 8100, 10800, zonetier[2]},
		["militar1"] 			= {7224, 12277, 7483, 12537, zonetier[3]},
		["militar2"] 			= {5400, 12300, 6000, 12598, zonetier[3]},
		["LouisvilleNorth"] 			= {12000, 300, 12903, 1200, zonetier[4]},
		["LouisvilleAgua"] 			= {13557, 2157, 13876, 2527, zonetier[4]},
		["DesiertoAlmacen"] 			= {4447, 11843, 4920, 12496, zonetier[2]},
		["Centro"] 			= {7003, 8150, 7551, 8569, zonetier[2]},
		["Oeste"] 			= {3483, 6938, 3958, 7557, zonetier[2]},
		["Centrocomercial"] 			= {13500, 5400, 14400, 6000, zonetier[2]},
	}
}

local modNames = {}
--[[local function getMapModNames()
	PredefinedMapMods = PredefinedMapMods or {}
	local mapMods = {}
	for modName, _ in pairs(PredefinedMapMods) do
		table.insert(mapMods, modName)
	end
	modNames = mapMods
end
--Events.OnInitGlobalModData.Add(getMapModNames)
--getMapModNames()]]

local function addPredefinedZones()
	PredefinedMapMods = PredefinedMapMods or {}
	local mapMods = {}
	for modName, _ in pairs(PredefinedMapMods) do
		table.insert(mapMods, modName)
	end
	modNames = mapMods
	
	if #modNames == 0 then return end
	PreDefinedZones = PreDefinedZones or {}
	PreDefinedZones.list = PreDefinedZones.list or {}
	for i=1,#modNames do
		if getActivatedMods():contains(modNames[i]) then
			local zoneName = PredefinedMapMods[modNames[i]]
			local zoneData = PredefinedZones.list[zoneName]

			if zoneData then
				Zone.list[zoneName] = {}
				--print(zoneName)
				local X1
				local Y1
				local X2
				local Y2
				local tier
				local nested = nil
				for key, value in pairs(zoneData) do
					if	 key == 1 then X1 = value
					elseif key == 2 then Y1 = value
					elseif key == 3 then X2 = value
					elseif key == 4 then Y2 = value
					elseif key == 5 then tier = value
					elseif key == 6 then 
						if value == "Nested" then nested = "Nested" elseif value == "NestedZone" then nested = "NestedZone" else nested = nil end
					end
					--print(key, value)
				end
				Zone.list[zoneName] = { X1, Y1, X2, Y2, tier, nested }
				--[[print(zoneName)
				for i=1,6 do
					print("  ",Zone.list[zoneName][i])
				end]]
			else
				print("Zone not found: " .. zoneName)
			end
		end
	end
end
Events.OnInitGlobalModData.Add(addPredefinedZones)
--addPredefinedZones()

NestedZone = {
	list = {
		["LouisvillePD"] 		= {12002, 1201, 12905, 1950, zonetier[4]},
		["LouisvilleMallArea"] 	= {12905, 1201, 13800, 1950, zonetier[3]},
	}
}

local function getZoneNames(zonelist)
	local zoneNames = {}
	for zoneName, _ in pairs(zonelist) do
		table.insert(zoneNames, zoneName)
	end
	return zoneNames
end

ZoneName = {}
NestedZoneNames = {}
local function OnGameStart()
	ZoneNames = getZoneNames(Zone.list)
	NestedZoneNames = getZoneNames(NestedZone.list)
end
Events.OnGameStart.Add(OnGameStart)

function checkZone()
	local player = getSpecificPlayer(0)
	if player then
		local x = player:getX()
		local y = player:getY()
		
		for i = 1, #ZoneNames do
			local x1 = Zone.list[ZoneNames[i]][1]
			local y1 = Zone.list[ZoneNames[i]][2]
			local x2 = Zone.list[ZoneNames[i]][3]
			local y2 = Zone.list[ZoneNames[i]][4]
			if x >= x1 and y >= y1 and x <= x2 and y <= y2 then
				if not Zone.list[ZoneNames[i]][6] then 
					return Zone.list[ZoneNames[i]][5], ZoneNames[i], x, y
				else
					for j = 1, #NestedZoneNames do
						local xx1 = NestedZone.list[NestedZoneNames[j]][1]
						local yy1 = NestedZone.list[NestedZoneNames[j]][2]
						local xx2 = NestedZone.list[NestedZoneNames[j]][3]
						local yy2 = NestedZone.list[NestedZoneNames[j]][4]
						if x >= xx1 and y >= yy1 and x <= xx2 and y <= yy2 then 
							return NestedZone.list[NestedZoneNames[j]][5], NestedZoneNames[j], x, y
						end
					end
					return Zone.list[ZoneNames[i]][5], ZoneNames[i], x, y
				end
			end
		end
		return zonetier[1], "Unnamed Zone", x, y
	else
		local x = 11250
		local y = 9000
		return zonetier[1], "Twilight Zone", x, y
	end
end