GiveItem = GiveItem or {}

GiveItem.giveItem = function (player, selectedItem, target)
    if (selectedItem:isEquipped()) then
        ISInventoryPaneContextMenu.unequipItem(selectedItem, player:getPlayerNum())
    end
    ISInventoryPaneContextMenu.transferIfNeeded(player, selectedItem)

    local minTime = 5
    local maxTime = 80
    local itemWeight = selectedItem:getWeight()
    local time = math.max(minTime, math.min(maxTime, itemWeight * 20))
    ISTimedActionQueue.add(ISGiveItemAction:new(player, selectedItem, time, target))
end

GiveItem.giveItemAction = function(items, player, target)
    if not player or not target then
        return
    end
    for i = 1, #items do
        local selectedItem = items[i]
        if selectedItem.items then
            local item = selectedItem.items[1]
            GiveItem.giveItem(player, item, target)
        elseif selectedItem then
            GiveItem.giveItem(player, selectedItem, target)
        end
    end
end