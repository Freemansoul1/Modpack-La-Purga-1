WSS = WSS or {
    shopsSpawned = 0,
    shopTypes = {
        ["WSS.Female_Biker"] = "Biker",
        ["WSS.Female_Nurse"] = "Nurse",
        ["WSS.Female_Tracksuit"] = "Tracksuit - Female",
        ["WSS.Female_Shopkeeper"] = "Shopkeeper",
        ["WSS.Male_Chef"] = "Chef",
        ["WSS.Male_Construction"] = "Construction",
        ["WSS.Male_Fancy"] = "Dapper",
        ["WSS.Male_Fisher"] = "Fishermen",
        ["WSS.Male_Prepper"] = "Prepper",
        ["WSS.Male_Shady"] = "Shady",
        ["WSS.Male_Tracksuit"] = "Tracksuit - Male",
    }
}

function WSS:playerError(player, message)
    player:Say(message)
end

function WSS:getCurrencyName()
    return getItemNameFromFullType(SandboxVars.WastelandSimpleShops.Currency)
end

function WSS:canGetNewShop(player)
    if WL_Utils.isStaff(player) or getDebug() then
        return true
    end

    if self.shopsSpawned >= SandboxVars.WastelandSimpleShops.MaxShops then
        return false
    end

    return true
end

function WSS:isSimpleShop(item)
    return item:hasTag("WSS_Shop") and item:getModData().WSS_Owner
end

function WSS:isShopOwner(player, item)
    if WL_Utils.isStaff(player) then
        return true
    end
    if not self:isSimpleShop(item) then
        return false
    end
    return item:getModData().WSS_Owner == player:getUsername()
end

function WSS:createNew(player, type)
    local cost = SandboxVars.WastelandSimpleShops.Level1Price
    if not WL_Utils.isStaff(player) or getDebug() then
        if not self:canPlayerAfford(player, cost) then
            self:playerError(player, "You can't afford to hire an NPC Shop Keeper.")
            return
        end
        self:takePlayerMoney(player, cost)
    end
    local item = player:getInventory():AddItem(type)
    if item then
        item:setName(player:getUsername() .. "'s Shop")
        item:setCapacity(SandboxVars.WastelandSimpleShops.Level1Size)
        item:getModData().WSS_Owner = player:getUsername()
        item:getModData().WSS_Level = 1
        return item
    end
    self.shopsSpawned = self.shopsSpawned + 1
    WL_UserData.Append("WSS_MyShops", {shopsSpawned = self.shopsSpawned}, player:getUsername())

    getPlayerInventory(player:getPlayerNum()):refreshBackpacks()
    getPlayerLoot(player:getPlayerNum()):refreshBackpacks()
end


function WSS:canUpgrade(player, shopItem)
    if not self:isSimpleShop(shopItem) then
        return false
    end
    if not self:isShopOwner(player, shopItem) then
        return false
    end
    if shopItem:getModData().WSS_Level >= 4 then
        return false
    end
    return true
end

function WSS:getUpgradeCost(shopItem)
    local level = shopItem:getModData().WSS_Level
    if not level or level < 1 or level >= 4 then
        return -1
    end
    if level == 1 then
        return SandboxVars.WastelandSimpleShops.Level2Price
    elseif level == 2 then
        return SandboxVars.WastelandSimpleShops.Level3Price
    elseif level == 3 then
        return SandboxVars.WastelandSimpleShops.Level4Price
    end
end

function WSS:isValidShopLocation(player, shopItem)
    if not player:getInventory():contains(shopItem) and not shopItem:getWorldItem() then
        self:playerError(player, "You must be holding the shop or have it placed in world to configure.")
        return false
    end
    return true
end

function WSS:upgrade(player, shopItem, level)
    if not self:isValidShopLocation(player, shopItem) then return end

    if not self:canUpgrade(player, shopItem) then
        self:playerError(player, "You can't upgrade this shop.")
        return
    end
    if level < 1 or level > 4 then
        self:playerError(player, "Invalid upgrade level.")
        return
    end
    local cost = SandboxVars.WastelandSimpleShops.Level1Price
    if level == 2 then
        cost = SandboxVars.WastelandSimpleShops.Level2Price
    elseif level == 3 then
        cost = SandboxVars.WastelandSimpleShops.Level3Price
    elseif level == 4 then
        cost = SandboxVars.WastelandSimpleShops.Level4Price
    end
    if not self:canPlayerAfford(player, cost) then
        self:playerError(player, "You can't afford to upgrade this shop.")
        return
    end
    self:takePlayerMoney(player, cost)
    shopItem:getModData().WSS_Level = level
    local size = SandboxVars.WastelandSimpleShops.Level1Size
    if level == 2 then
        size = SandboxVars.WastelandSimpleShops.Level2Size
    elseif level == 3 then
        size = SandboxVars.WastelandSimpleShops.Level3Size
    elseif level == 4 then
        size = SandboxVars.WastelandSimpleShops.Level4Size
    end
    shopItem:setCapacity(size)
    if shopItem:getWorldItem() then
        sendClientCommand(player, "WSS", "setLevel", {
            shopItem:getID(),
            shopItem:getWorldItem():getSquare():getX(),
            shopItem:getWorldItem():getSquare():getY(),
            shopItem:getWorldItem():getSquare():getZ(),
            level,
            size
        })
    end
    getPlayerInventory(player:getPlayerNum()):refreshBackpacks()
    getPlayerLoot(player:getPlayerNum()):refreshBackpacks()
end

function WSS:swapType(player, shopItem, newType)
    if not player:getInventory():contains(shopItem) then
        self:playerError(player, "You must be holding the shop to swap types.")
        return
    end

    local newItem = player:getInventory():AddItem(newType)
    if not newItem then
        self:playerError(player, "Failed to swap shop type.")
        return
    end
    newItem:setName(shopItem:getName())
    newItem:setCustomName(true)
    newItem:setCapacity(shopItem:getCapacity())
    newItem:getModData().WSS_Owner = shopItem:getModData().WSS_Owner
    newItem:getModData().WSS_Level = shopItem:getModData().WSS_Level

    local oldInventory = shopItem:getInventory()
    local oldItems = oldInventory:getItems()
    local newInventory = newItem:getInventory()
    for i=oldItems:size()-1,0,-1 do
        local item = oldItems:get(i)
        oldInventory:DoRemoveItem(item)
        newInventory:addItem(item)
    end
    player:getInventory():DoRemoveItem(shopItem)
end

function WSS:promptSetPrice(player, shopItem, items)
    if not self:isValidShopLocation(player, shopItem) then return end

    if not shopItem:getInventory():contains(items[1]) then
        self:playerError(player, "The shop must contain the item to configure a price.")
        return
    end

    local scale = getTextManager():MeasureStringY(UIFont.Small, "XXX") / 12

    local width = 200 * scale
    local height = 130 * scale
    local x = (getCore():getScreenWidth() / 2) - (width / 2)
    local y = (getCore():getScreenHeight() / 2) - (height / 2)
    local modal = ISTextBox:new(x, y, width, height, "Set New Price", "", nil, function (_, button)
        if button.internal == "OK" then
            for _, item in ipairs(items) do
                WSS:setItemCost(player, shopItem, item, tonumber(button.parent.entry:getText()))
                if shopItem:getWorldItem() then
                    sendClientCommand(player, "WSS", "setPrice", {
                        shopItem:getID(),
                        shopItem:getWorldItem():getSquare():getX(),
                        shopItem:getWorldItem():getSquare():getY(),
                        shopItem:getWorldItem():getSquare():getZ(),
                        item:getID(),
                        tonumber(button.parent.entry:getText())
                    })
                end
            end
            player:Say("Item's price was set.")
        end
    end, nil)
    modal:initialise()
    modal:addToUIManager()
end

function WSS:setItemCost(player, shopItem, item, cost)
    if not self:isValidShopLocation(player, shopItem) then return end

    if not shopItem:getInventory():contains(item) then
        self:playerError(player, "The shop must contain the item to configure a price.")
        return
    end
    if not cost then
        self:playerError(player, "Cost must be a number.")
        return
    end
    if cost < 0 then
        item:getModData().WSS_Cost = nil
    else
        item:getModData().WSS_Cost = math.floor(cost)
    end
end

function WSS:getItemFullCost(item)
    return item and item:getModData().WSS_Cost and item:getModData().WSS_Cost or 0
end

function WSS:promptChangeOwner(player, shopItem)
    if not self:isValidShopLocation(player, shopItem) then return end

    local scale = getTextManager():MeasureStringY(UIFont.Small, "XXX") / 12

    local width = 200 * scale
    local height = 130 * scale
    local x = (getCore():getScreenWidth() / 2) - (width / 2)
    local y = (getCore():getScreenHeight() / 2) - (height / 2)
    local modal = ISTextBox:new(x, y, width, height, "New Owner Username", "", nil, function (_, button)
        if button.internal == "OK" then
            WSS:setShopOwner(player, shopItem, button.parent.entry:getText())
        end
    end, nil)
    modal:initialise()
    modal:addToUIManager()
end

function WSS:setShopOwner(player, shopItem, newOwner)
    if not self:isValidShopLocation(player, shopItem) then return end

    shopItem:getModData().WSS_Owner = newOwner
    if shopItem:getWorldItem() then
        sendClientCommand(player, "WSS", "setOwner", {
            shopItem:getID(),
            shopItem:getWorldItem():getSquare():getX(),
            shopItem:getWorldItem():getSquare():getY(),
            shopItem:getWorldItem():getSquare():getZ(),
            newOwner
        })
    end
    getPlayerInventory(player:getPlayerNum()):refreshBackpacks()
    getPlayerLoot(player:getPlayerNum()):refreshBackpacks()
end

function WSS:itemTooltip(item)
    if item:getModData().WSS_Cost then
        tooltip = "Purchase Price: " .. item:getModData().WSS_Cost ..  " " .. self:getCurrencyName()
        return tooltip
    end
    return "Not for sale"
end

function WSS:canPlayerAfford(player, cost)
    return player:getInventory():getCountTypeRecurse(SandboxVars.WastelandSimpleShops.Currency) >= cost
end

function WSS:takePlayerMoney(player, cost)
    local items = player:getInventory():getAllTypeRecurse(SandboxVars.WastelandSimpleShops.Currency)
    local remaining = cost
    for i=items:size()-1,0,-1 do
        local item = items:get(i)
        item:getContainer():DoRemoveItem(item)
        remaining = remaining - 1
        if remaining <= 0 then
            break
        end
    end
end

function WSS:movePlayerMoney(player, cost, targetInventory)
    local items = player:getInventory():getAllTypeRecurse(SandboxVars.WastelandSimpleShops.Currency)
    local remaining = cost
    local amountPaid = 0
    local amountFee = 0
    local feePercentage, town = WSS:getFee(player)

    for i=items:size()-1,0,-1 do
        local item = items:get(i)
        item:getContainer():DoRemoveItem(item)
        if ZombRand(100) > feePercentage then
            targetInventory:addItem(item)
            targetInventory:addItemOnServer(item)
            amountPaid = amountPaid + 1
        else
            amountFee = amountFee + 1
        end

        remaining = remaining - 1
        if remaining <= 0 then
            break;
        end
    end

    if town and town.type ~= WWP_TownType.NPC_HUB then
        WWP_TownLedger.getClient():makeDeposit(town.id, amountFee, WWP_TownLedger.SALES_TAX)
    end
    return amountPaid, amountFee, feePercentage
end

function WSS:getFee(player)
    if getActivatedMods():contains("WastelandWorkplaces1") and getActivatedMods():contains("WastelandLedger") then
        local town = WWP_Town.findTownAt(player:getX(), player:getY(), player:getZ())
        if town and town.salesTaxRate > 0 then -- 0% sales tax means Anarchy towns - they get the NPC fee instead
            return town.salesTaxRate, town
        end
    end
    return SandboxVars.WastelandSimpleShops.NpcFeePercentage, nil
end

if not WSS.initalized then
    WL_PlayerReady.Add(function (playerIdx, player)
        WL_UserData.Fetch("WSS_MyShops", player:getUsername(), function (data)
            WSS.shopsSpawned = data and data.shopsSpawned or 0
        end)
    end)
    WSS.initialized = true
end