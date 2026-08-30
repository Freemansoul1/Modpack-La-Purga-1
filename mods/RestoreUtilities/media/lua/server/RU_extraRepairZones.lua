local function addNewCoords(newCoords)
	local modData = ModData.get("RestoreUtilities")
	modData.extraRepairCoords[#modData.extraRepairCoords + 1] = newCoords
	print("[Restore Utilities] Server added new coord data, X:" .. newCoords.X .. ", Y: " .. newCoords.Y .. ", Z: " .. newCoords.Z .. ", Utility: " .. newCoords.utilityType)
end

local function removeOldCoords(oldCoordIndex)
	local modData = ModData.get("RestoreUtilities")
	local oldEntry = modData.extraRepairCoords[oldCoordIndex] -- this lets us print the data of what was removed, makes server owner's lives a little easier :D
	local x, y, z, util = oldEntry.X, oldEntry.Y, oldEntry.Z, oldEntry.utilityType
	table.remove(modData.extraRepairCoords, oldCoordIndex)
	print("[Restore Utilities] Server removed coord data, X: " .. x .. ", Y: " .. y .. ", Z: " .. z .. ", Utility: " .. util)
end

local function updateRepairCoords(moduleName, command, player, newData) -- server side code that updates repair coord locations
	if not player:getAccessLevel() == "admin" then print("Player is not admin!") return end
	if not isServer() then return end -- only the server should run this code anyway, but just in case
	if not moduleName == "RestoreUtilities" then return end
	if command == "AddCoords" then
		addNewCoords(newData)
	elseif command == "RemoveCoords" then
		removeOldCoords(newData[1])
	end
	ModData.transmit("RestoreUtilities")
end

Events.OnClientCommand.Add(updateRepairCoords)

local function syncClientData(key, data) -- keeps mod data synced, right now only useful for coord locations, but might be useful for other things in the future :)
	if isServer() or not isClient() then return end
	if key == "RestoreUtilities" then
		local modData = ModData.get("RestoreUtilities")
		for k, v in pairs(data) do 
			modData[k] = v
		end
	end
end

Events.OnReceiveGlobalModData.Add(syncClientData)

-- to add or remove custom squares, call the below functions and supply a newCoordInfo, this is an array which must be laid out like {X = xCoord, Y = yCoord, z = zCoord, utilityType = "Elec"/"Water"}, obviously subbing out xCoord for your x coordinate, and so forth. utility type does not need to be supplied when calling to remove a coordinate, but it won't break anything if you add/leave it in by accident. comment on the steam workshop page if you need more help :) - Jack

function RU_AddNewCoords(newCoordInfo) -- a way for modders to add new repair squares cleanly :)
	if isServer() or (not isServer() and not isClient()) then
		local modData = ModData.get("RestoreUtilities")
		if not newCoordInfo.X or not newCoordInfo.Y or not newCoordInfo.Z or not newCoordInfo.utilityType then warn("Invalid setup for adding new utility repair location!") return end
		local spaceAlreadyOccupied = false
		if #modData.extraRepairCoords > 0 then
			for i, v in ipairs(modData.extraRepairCoords) do
				if v.X == newCoordInfo.X and v.Y == newCoordInfo.Y and v.Z == newCoordInfo.Z then
					spaceAlreadyOccupied = true
					print("Repair square already exists at X: " .. v.X .. ", Y: " .. v.Y .. ", Z: " .. v.Z .. ", skipping...")
					break
				end
			end
		end
		if spaceAlreadyOccupied then return end
		addNewCoords(newCoordInfo)
	end
end

function RU_RemoveOldCoords(newCoordInfo) -- a way for modders to remove old repair squares cleanly :)
	if isServer() or (not isServer() and not isClient()) then
		local modData = ModData.get("RestoreUtilities")
		if not newCoordInfo.X or not newCoordInfo.Y or not newCoordInfo.Z then warn("Invalid setup for adding new utility repair location!") return end
		local coordIndex = 0
		if #modData.extraRepairCoords > 0 then
			for i, v in ipairs(modData.extraRepairCoords) do
				if v.X == newCoordInfo.X and v.Y == newCoordInfo.Y and v.Z == newCoordInfo.Z then
					coordIndex = i
					print("Repair square found for coords X: " .. v.X .. ", Y: " .. v.Y .. ", Z: " .. v.Z)
					break
				end
			end
		end
		if coordIndex == 0 then return end
		removeOldCoords(coordIndex)
	end
end