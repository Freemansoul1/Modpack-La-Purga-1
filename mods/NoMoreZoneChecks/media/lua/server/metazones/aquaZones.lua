function doAgroMapZones()
	--do nothing, remove this
end

function doAquaMapZones()
-- print("doAgroMapZones")
        local file = 'media/mapszones/Muldraugh, KY/aquazones.lua'
        if fileExists(file) then
		-- print("doAgroMapZones fileExists")
		aquazones = {}
		reloadLuaFile(file)
		for k,v in ipairs(aquazones) do
			if v.type == "Mannequin" then
				handleMannequinZone(file, v)
			elseif v.type == "SpawnOrigin" then
				handleSpawnOrigin(file, v)
			elseif v.type == "WaterFlow" then
				handleWaterFlow(file, v)
			elseif v.type == "WaterZone" then
				handleWaterZone(file, v)
			elseif v.geometry ~= nil then
				if tonumber(v.lineWidth) then
					v.properties = v.properties or {}
					v.properties.LineWidth = v.lineWidth
				end
				getWorld():getMetaGrid():registerGeometryZone(v.name, v.type, v.z, v.geometry, v.points, v.properties)
			else
				local vzone = getWorld():registerVehiclesZone(v.name, v.type, v.x, v.y, v.z, v.width, v.height, v.properties)
				-- print("doAgroMapZones vzone")
				-- print(vzone)
				if vzone == nil then
					getWorld():registerZone(v.name, v.type, v.x, v.y, v.z, v.width, v.height)
				end
			end
			table.wipe(v)
		end
		table.wipe(aquazones)
	else
		print('can\'t find map aquazones file: '..file)
	end
	getWorld():checkVehiclesZones();
end
Events.OnLoadMapZones.Remove(doAgroMapZones);
Events.OnLoadMapZones.Add(doAquaMapZones);