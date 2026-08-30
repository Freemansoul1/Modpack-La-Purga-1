WSS_InventoryMenu = WSS_InventoryMenu or {initalized = false}

function WSS_InventoryMenu.showPreMenu(playerIdx, context, items)
    local player = getSpecificPlayer(playerIdx)

    items = ISInventoryPane.getActualItems(items)
    local item = items[1]

    if not item then return end

    if WSS:isSimpleShop(item) and (player:getInventory():contains(item) or item:getWorldItem()) then
        if WSS:isShopOwner(player, item) and WSS:canUpgrade(player, item) then
            local currentLevel = item:getModData().WSS_Level
            local upgradeCost = WSS:getUpgradeCost(item)
            local option = context:addOption("Upgrade to Level " .. (currentLevel + 1) .. " (" .. tostring(upgradeCost) .. ")", WSS, WSS.upgrade, player, item, currentLevel + 1)
            if not WSS:canPlayerAfford(player, upgradeCost) then
                option.notAvailable = true
            end
        end

        if WL_Utils.canModerate(player) or getDebug() then
            context:addOption("Change Owner", WSS, WSS.promptChangeOwner, player, item)
        end
    end

    if WSS:isSimpleShop(item) and player:getInventory():contains(item) and WSS:isShopOwner(player, item) and item:getInventory():getItems():size() == 0 then
        local newMenu = WL_ContextMenuUtils.getOrCreateSubMenu(context, "Change Type")
        local currentType = item:getFullType()
        for shopType, shopName in pairs(WSS.shopTypes) do
            if currentType ~= shopType then
                newMenu:addOption(shopName, WSS, WSS.swapType, player, item, shopType)
            end
        end
    end

    local container = item:getContainer()
    if container then
        local parent = container:getContainingItem()
        if parent and WSS:isSimpleShop(parent) and WSS:isShopOwner(player, parent) and (player:getInventory():contains(parent) or parent:getWorldItem()) then
            context:addOption("Set Price", WSS, WSS.promptSetPrice, player, parent, items)
        end
    end
end

function WSS_InventoryMenu.showPostMenu(playerIdx, context, items)
    local player = getSpecificPlayer(playerIdx)

    items = ISInventoryPane.getActualItems(items)
    local item = items[1]

    if not item then return end

    if item:getFullType() ~= SandboxVars.WastelandSimpleShops.Currency then return end

    if WSS:canGetNewShop(player) and player:getInventory():contains(item) then
        if not WSS:canPlayerAfford(player, SandboxVars.WastelandSimpleShops.Level1Price) and not WL_Utils.isStaff(player) then
            local option = context:addOption("Hire Salesperson (" .. tostring(SandboxVars.WastelandSimpleShops.Level1Price) .. " " .. WSS:getCurrencyName() .. ")")
            option.notAvailable = true
        else
            local newMenu = WL_ContextMenuUtils.getOrCreateSubMenu(context, "Hire Salesperson (" .. tostring(SandboxVars.WastelandSimpleShops.Level1Price) .. " " .. WSS:getCurrencyName() .. ")")            for shopType, shopName in pairs(WSS.shopTypes) do
                newMenu:addOption(shopName, WSS, WSS.createNew, player, shopType)
            end
        end
    end
end


if not WSS_InventoryMenu.initialized then
    Events.OnPreFillInventoryObjectContextMenu.Add(function (p, c,i) WSS_InventoryMenu.showPreMenu(p,c,i) end)
    Events.OnFillInventoryObjectContextMenu.Add(function (p, c,i) WSS_InventoryMenu.showPostMenu(p,c,i) end)
    WSS_InventoryMenu.initialized = true
end