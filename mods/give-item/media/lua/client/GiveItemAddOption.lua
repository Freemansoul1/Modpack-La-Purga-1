GiveItem = GiveItem or {}

GiveItem.OnFillInventoryObjectContextMenu = function(playerIndex, context, items)
    local currentPlayer = getSpecificPlayer(playerIndex)
    local players = GiveItem.getCloseByCharacters(currentPlayer)
    if #players == 0 then
        return
    end
    if #players == 1 then
        local player = players[1]
        if (player:getIsNPC()) then
            context:addOption("Give to " .. player:getFullName(), items, GiveItem.giveItemAction, currentPlayer, player)
        else
            context:addOption("Give to " .. player:getUsername(), items, GiveItem.giveItemAction, currentPlayer, player)
        end
        return
    end
    local giveOption = context:addOption("Give to")
    local submenu = context:getNew(context)
    context:addSubMenu(giveOption, submenu)
    for i = 1, #players do
        local player = players[i]
        if (player:getIsNPC()) then
            submenu:addOption(player:getFullName(), items, GiveItem.giveItemAction, currentPlayer, player)
        else
            submenu:addOption(player:getUsername(), items, GiveItem.giveItemAction, currentPlayer, player)
        end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(GiveItem.OnFillInventoryObjectContextMenu)
