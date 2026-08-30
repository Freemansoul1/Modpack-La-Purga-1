OutWithIt = OutWithIt or {}

function OutWithIt.OnFillInventoryObjectContextMenu(playerId, contextMenu, items)
	local player = getSpecificPlayer(playerId)
	if player == nil then
		return
	end

    items = ISInventoryPane.getActualItems(items)

	local count = 0
    for _ in ipairs(items) do count = count + 1 end
	if count == 0 then
		return
	end

	if OutWithIt.TryFillInventoryObjectContextMenuForSquare(player, player:getSquare(), contextMenu, count, items)
	or OutWithIt.TryFillInventoryObjectContextMenuForSquare(player, player:getSquare():getS(), contextMenu, count, items)
	or OutWithIt.TryFillInventoryObjectContextMenuForSquare(player, player:getSquare():getE(), contextMenu, count, items)
	or OutWithIt.TryFillInventoryObjectContextMenuForSquare(player, player:getSquare():getW(), contextMenu, count, items)
	or OutWithIt.TryFillInventoryObjectContextMenuForSquare(player, player:getSquare():getN(), contextMenu, count, items)
	 then
		return
	end
end

function OutWithIt.TryFillInventoryObjectContextMenuForSquare(player, square, contextMenu, itemCount, items)
	if (square == nil) then
		return false
	end

	local objects = square:getObjects()
	for i = 0, objects:size() - 1 do
		local throwType, throwTarget = OutWithIt.getThrowTypeAndTarget(player, objects:get(i))
		if throwType then
			if itemCount == 1 then
				contextMenu:addOption(getText('ContextMenu_Throw' .. throwType, items[1]:getName()), table, OutWithIt.onThrow, player, throwTarget, items[1])
				return true
			else
				contextMenu:addOption(getText('ContextMenu_ThrowMultiple' .. throwType, itemCount), table, OutWithIt.onThrow, player, throwTarget, items)
				return true
			end
		end
	end

	return false
end

function OutWithIt.OnFillWorldObjectContextMenu(playerId, contextMenu, table, test)
	local player = getSpecificPlayer(playerId)
	if player == nil then
		return
	end

	if not OutWithIt.Options.allowQuickEquippedItemsThrow then
		return
	end

	local primaryItem = player:getPrimaryHandItem()
	local secondaryItem = player:getSecondaryHandItem()
	if (primaryItem == nil and secondaryItem == nil) then
		return
	end

	for _, object in ipairs(table) do
		local objects = object:getSquare():getObjects()
		for i = 0, objects:size() - 1 do
			local throwType, throwTarget = OutWithIt.getThrowTypeAndTarget(player, objects:get(i))
			if throwType then
				if (primaryItem ~= nil) then
					contextMenu:addOption(getText('ContextMenu_Throw' .. throwType, primaryItem:getName()), table, OutWithIt.onThrow, player, throwTarget, primaryItem)
				end
				if (secondaryItem ~= nil and secondaryItem ~= primaryItem) then
					contextMenu:addOption(getText('ContextMenu_Throw' .. throwType, secondaryItem:getName()), table, OutWithIt.onThrow, player, throwTarget, secondaryItem)
				end
				return
			end
		end
	end
end

Events.OnFillInventoryObjectContextMenu.Add(OutWithIt.OnFillInventoryObjectContextMenu)
Events.OnFillWorldObjectContextMenu.Add(OutWithIt.OnFillWorldObjectContextMenu)
