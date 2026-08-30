if isServer() then return end

GiveItemServerCommands = GiveItemServerCommands or {}

function GiveItemServerCommands.onReceiveItem(args)
    local item = args['item']
    local player = getPlayer()
    local playerInv = player:getInventory()
    local plInventoryHasSpace = (playerInv:getCapacityWeight() <= playerInv:getEffectiveCapacity(player));
    if plInventoryHasSpace and playerInv:hasRoomFor(player, item) then
        player:getInventory():addItem(item)
    else
        player:getCurrentSquare():AddWorldInventoryItem(item, 0.0, 0.0, 0.0)
    end
end

function GiveItemServerCommands.onFinalizeTransaction(args)
    local pl = getPlayer()
    local item = args['item']
    if item:getContainer() then
        item:getContainer():Remove(item)
        item:getContainer():removeItemOnServer(item)
    else
        pl:getInventory():Remove(item)
        pl:getInventory():removeItemOnServer(item)
    end
end

local function OnServerCommand(module, command, args)
    if module == "giveitem" and GiveItemServerCommands[command] then
        local argStr = ''
        for k,v in pairs(args) do argStr = argStr..' '..k..'='..tostring(v) end
        --print('received '..module..' '..command..' '..argStr)
        GiveItemServerCommands[command](args)
    end
end

Events.OnServerCommand.Add(OnServerCommand)