WAT_ItemDuplicator = WAT_ItemDuplicator or {}

function WAT_ItemDuplicator.OnDuplicateItem(_, item, playerObj)
    local newItem = WL_Utils.cloneItem(item)
    if not newItem then return end
    print("Made new item!")
    item:getContainer():AddItem(newItem)
end

function WAT_ItemDuplicator.OnFillInventoryObjectContextMenu(playerIdx, context, items)
    local playerObj = getSpecificPlayer(playerIdx)
    if #items ~= 1 then return end
    if isClient() and not WL_Utils.canModerate() then return end
    local item = items[1]
    if item.items then item = item.items[1] end
    if not item then return end
    context:addOption("Duplicate Item", nil, WAT_ItemDuplicator.OnDuplicateItem, item, playerObj)
end

if not WAT_ItemDuplicator.didBindEvents then
    Events.OnFillInventoryObjectContextMenu.Add(function (p, c, i) WAT_ItemDuplicator.OnFillInventoryObjectContextMenu(p, c, i) end)
    WAT_ItemDuplicator.didBindEvents = true
end