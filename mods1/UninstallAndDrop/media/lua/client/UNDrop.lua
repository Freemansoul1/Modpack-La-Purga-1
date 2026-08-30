UNDrop = UNDrop or {}
UNDrop.started = false
local VISUninstallVehiclePart_stop = ISUninstallVehiclePart.stop
function ISUninstallVehiclePart:stop()
	VISUninstallVehiclePart_stop(self)
	if UNDrop.started then
		UNDrop.started = false
	end
end

local VISVehicleMechanics_doPartContextMenu = ISVehicleMechanics.doPartContextMenu
function ISVehicleMechanics:doPartContextMenu(part, x, y)
	if part:getItemType() and not part:getItemType():isEmpty() and part:getTable("uninstall") and part:getVehicle():canUninstallPart(self.chr, part) then
		if UNDrop.checkKey() then
			UNDrop.doUNDrop(self.chr, part)
		else
			VISVehicleMechanics_doPartContextMenu(self, part, x, y);
			local option = self.context:addOption("Uninstall and Drop", self.chr, UNDrop.doUNDrop, part)
		end
	else
		VISVehicleMechanics_doPartContextMenu(self, part, x, y);
	end
end

function UNDrop.checkKey()
	-- return false
	return isKeyDown(56)
end

function UNDrop.doUNDrop(player, part)
	UNDrop.started = true
	ISVehiclePartMenu.onUninstallPart(player, part)
end

function UNDrop.getInventoryItem(inv, itemId) --returns the item only if it is in player main inventory
	local it = inv:getItems()
	local count = it:size() - 1;
	for i = 0, count do
		local item = it:get(count - i) --decreasing loop because we were potentially removing the item [OBSOLETE]
		if item:getID() == itemId then
			return item
		end
	end
	return nil
end

function UNDrop.OnMechanicActionDone(player, success, vehicleId, partId, itemId, installing)
	if UNDrop.started then
		UNDrop.started = false
		if success and itemId ~= -1 then
			local floor = ISInventoryPage.GetFloorContainer(player:getPlayerNum())
			local inv = player:getInventory()
			local invItem = UNDrop.getInventoryItem(inv, itemId)
			if invItem ~= nil then
				ISTimedActionQueue.add(ISInventoryTransferAction:new(player, invItem, player:getInventory(), floor))
			end
		end
	end
end

Events.OnMechanicActionDone.Add(UNDrop.OnMechanicActionDone);
