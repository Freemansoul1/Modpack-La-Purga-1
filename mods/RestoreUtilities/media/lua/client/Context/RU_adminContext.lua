local function appendCoordsTable(player, x, y, z, utility)
	local newCoordEntry = {X = x, Y = y, Z = z, utilityType = utility}
	if isClient() then
		sendClientCommand("RestoreUtilities", "AddCoords", newCoordEntry)
	elseif not isClient() and not isServer() then
		local modData = ModData.get("RestoreUtilities")
		local extraCoordsTable = modData.extraRepairCoords
		extraCoordsTable[#extraCoordsTable + 1] = newCoordEntry
	end
end

local function removeFromCoordsTable(player, tableIndex)
	if isClient() then
		sendClientCommand("RestoreUtilities", "RemoveCoords", {tableIndex})
	elseif not isClient() and not isServer() then
		local modData = ModData.get("RestoreUtilities")
		local extraCoordsTable = modData.extraRepairCoords
		table.remove(extraCoordsTable, tableIndex)
	end
end

local function AddAdminContextPrompt(player, context, worldObjects)
	
	local player = getSpecificPlayer(player)
	if isClient() then
		if not isAdmin() then return end
		ModData.request("RestoreUtilities") -- request mod data from server
	elseif not isClient() and not isServer() then
		if not isDebugEnabled() then return end
	else return
	end
	
	local modData = ModData.get("RestoreUtilities")
	local extraCoordsTable = modData.extraRepairCoords
	local x, y, z = worldObjects[1]:getX(), worldObjects[1]:getY(), worldObjects[1]:getZ() -- coords of where the player right-clicked
	local tileAlreadyDesignated = false
	local tableEntryIndex = 0 -- lets us quickly locate and delete a set of coords from the table if we need to
	
	if #extraCoordsTable > 0 then -- check if any additional tiles have been added, and if so, if we are clicking on one
		for i, v in ipairs(extraCoordsTable) do
			if v.X == x and v.Y == y and v.Z == z then
				tileAlreadyDesignated = true
				tableEntryIndex = i
				break
			end
		end
	end
	
	local adminContext = context:addOptionOnTop(getText("ContextMenu_RU_Admin"), nil, nil)
	local subMenu = ISContextMenu:getNew(context)
	context:addSubMenu(adminContext, subMenu) -- adds initial right-click menu
	
	if not tileAlreadyDesignated then
		local designatePower = subMenu:addOption(getText("ContextMenu_RU_Admin_AddPower"), getPlayer(), appendCoordsTable, x, y, z, "Elec") 
		local designateWater = subMenu:addOption(getText("ContextMenu_RU_Admin_AddWater"), getPlayer(), appendCoordsTable, x, y, z, "Water")
	else
		local removeUtilityRepairSpot = subMenu:addOption(getText("ContextMenu_RU_Admin_RemoveSpot"), getPlayer(), removeFromCoordsTable, tableEntryIndex)
	end
	
end

Events.OnFillWorldObjectContextMenu.Add(AddAdminContextPrompt)