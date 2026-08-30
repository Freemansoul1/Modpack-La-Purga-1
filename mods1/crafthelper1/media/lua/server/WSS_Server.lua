Events.OnClientCommand.Add(function(module, command, player, args)
    if module ~= "WSS" then return end

    if command == "logSale" then
        local shopName = args[1]
        local itemName = args[2]
        local totalCost = args[3]
        local fee = args[4]
        local buyer = player:getUsername()

        writeLog("WastelandSimpleStores", string.format("%s bought %s from %s for %d with a fee of %d", buyer, itemName, shopName, totalCost, fee))
    end

    if command == "setPrice" then
        local shopId = args[1]
        local x = args[2]
        local y = args[3]
        local z = args[4]
        local itemId = args[5]
        local price = args[6]

        local gs = getCell():getGridSquare(x, y, z)
        if not gs then
            print("WSS: Could not find grid square at " .. x .. ", " .. y .. ", " .. z)
            return
        end

        local shop = nil
        local objects = gs:getWorldObjects()
        for i=0, objects:size()-1 do
            local object = objects:get(i)
            if object:getItem():getID() == shopId then
                shop = object:getItem()
                break
            end
        end
        if not shop then
            print("WSS: Could not find shop with ID " .. shopId)
            return
        end
        local container = shop:getInventory()
        local item = container:getItemById(itemId)
        if not item then
            print("WSS: Could not find item with ID " .. itemId)
            return
        end
        if not price then return end
        if price < 0 then
            item:getModData().WSS_Cost = nil
        else
            item:getModData().WSS_Cost = math.floor(price)
        end
        container:DoRemoveItem(item)
        container:AddItem(item)
        print("WSS: Set price of " .. item:getName() .. " to " .. price .. " in " .. shop:getName() .. " at " .. x .. ", " .. y .. ", " .. z)
    end

    if command == "setOwner" then
        local shopId = args[1]
        local x = args[2]
        local y = args[3]
        local z = args[4]
        local newOwner = args[5]

        local gs = getCell():getGridSquare(x, y, z)
        if not gs then
            print("WSS: Could not find grid square at " .. x .. ", " .. y .. ", " .. z)
            return
        end

        local shop = nil
        local objects = gs:getWorldObjects()
        for i=0, objects:size()-1 do
            local object = objects:get(i)
            if object:getItem():getID() == shopId then
                shop = object:getItem()
                break
            end
        end
        if not shop then
            print("WSS: Could not find shop with ID " .. shopId)
            return
        end
        shop:getModData().WSS_Owner = newOwner
        print("WSS: Set owner of " .. shop:getName() .. " to " .. newOwner .. " at " .. x .. ", " .. y .. ", " .. z)
    end

    if command == "setLevel" then
        local shopId = args[1]
        local x = args[2]
        local y = args[3]
        local z = args[4]
        local level = args[5]
        local newCapacity = args[6]

        local gs = getCell():getGridSquare(x, y, z)
        if not gs then
            print("WSS: Could not find grid square at " .. x .. ", " .. y .. ", " .. z)
            return
        end

        local shop = nil
        local objects = gs:getWorldObjects()
        for i=0, objects:size()-1 do
            local object = objects:get(i)
            if object:getItem():getID() == shopId then
                shop = object:getItem()
                break
            end
        end
        if not shop then
            print("WSS: Could not find shop with ID " .. shopId)
            return
        end
        shop:getModData().WSS_Level = level
        shop:setCapacity(newCapacity)
        print("WSS: Set level of " .. shop:getName() .. " to " .. level .. " at " .. x .. ", " .. y .. ", " .. z)
    end
end)