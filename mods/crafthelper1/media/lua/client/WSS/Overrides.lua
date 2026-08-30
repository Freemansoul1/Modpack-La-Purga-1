local ISToolTipInv_render = ISToolTipInv.render
function ISToolTipInv:render()
    ISToolTipInv_render(self)
    if not self.item or not self.tooltip then return end
    local container = self.item:getContainer()
    if not container then return end
    local shop = container:getContainingItem()
    if not shop or not WSS:isSimpleShop(shop) then return end
    local tt = WSS:itemTooltip(self.item)
    local currentHeight = self.height
    local height = getTextManager():MeasureStringY(self.tooltip:getFont(), tt) + 10
    self:setHeight(self.height + height)
    self:drawRect(0, currentHeight, self.width, height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
    self:drawRectBorder(0, currentHeight, self.width, height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
    self.tooltip:DrawText(self.tooltip:getFont(), tt, 0, currentHeight + 5, 1, 1, 1, 1)
end

local original_ISInventoryPane_refreshContainer = ISInventoryPane.refreshContainer
function ISInventoryPane:refreshContainer()
    local result = original_ISInventoryPane_refreshContainer(self)
    local item = self.inventory:getContainingItem()
    if not item or not WSS:isSimpleShop(item) then
        return result
    end

    local player = getPlayer()
    if WL_Utils.isStaff(player) or WSS:isShopOwner(player, item) then
        return result
    end

    local newItemsList = {}
    for i=1,#self.itemslist do
        local newItemsEntry = {}
        for j=1,#self.itemslist[i].items do
            local itemListItem = self.itemslist[i].items[j]
            if WSS:getItemFullCost(itemListItem) > 0 then
                table.insert(newItemsEntry, itemListItem)
            end
        end
        local weight = 0
        for j=1,#newItemsEntry do
            weight = weight + newItemsEntry[j]:getUnequippedWeight()
        end
        if #newItemsEntry > 0 then
            table.insert(newItemsList, {
                items = newItemsEntry,
                name = self.itemslist[i].name,
                invPanel = self.itemslist[i].invPanel,
                cat = self.itemslist[i].cat,
                count = #newItemsEntry,
                weight = weight,
            })
        end
    end

    self.itemslist = newItemsList
    self:updateScrollbars()
    self.inventory:setDrawDirty(false)

    return result
end

local original_ISInventoryTransferAction_new = ISInventoryTransferAction.new
function ISInventoryTransferAction:new(player, item, srcContainer, destContainer, time)
    local result = original_ISInventoryTransferAction_new(self, player, item, srcContainer, destContainer, time)

    -- if the source container is a shop, we need to check if the player can afford the item
    -- or if the player is the shop owner or staff
    local shop = srcContainer:getContainingItem()
    if shop and WSS:isSimpleShop(shop) then
        if WL_Utils.isStaff(player) or WSS:isShopOwner(player, shop) then
            return result
        end

        if player:getInventory() ~= destContainer then
            WSS:playerError(player, "You can't move items out of another players shop.")
            return {ignoreAction = true}
        end

        local totalCost = WSS:getItemFullCost(item)
        if not WSS:canPlayerAfford(player, totalCost) then
            WSS:playerError(player, "You can't afford that.")
            return {ignoreAction = true}
        end

        WL_Dialogs.showConfirmationDialog("Are you sure you want to buy " .. item:getName() ..  " for " .. totalCost .. " " .. WSS:getCurrencyName() .. "?", function()
            if not WSS:canPlayerAfford(player, totalCost) then
                WSS:playerError(player, "You can't afford that.")
                return
            end
            local paid, fee, feePercentage = WSS:movePlayerMoney(player, totalCost, srcContainer)
            srcContainer:removeItemOnServer(item)
            srcContainer:DoRemoveItem(item)
            destContainer:addItem(item)

            item:getModData().WSS_Cost = nil

            local log = InventoryItemFactory.CreateItem("Base.SheetPaper2")
            log:setName("Rcpt - " .. item:getName() .. " (" .. totalCost .. "/" .. fee .. "/" .. paid .. ")")
            log:setCustomName(true)
            local logText = "Transaction Log\n\n"
            logText = logText .. "Item: " .. item:getName() .. "\n"
            logText = logText .. "Sold By: " .. shop:getName() .. "\n"
            logText = logText .. "Sold To: " .. player:getUsername() .. "\n"
            logText = logText .. "Price: " .. totalCost .. " " .. WSS:getCurrencyName() .. "\n"
            logText = logText .. "Fee: " .. fee .. " " .. WSS:getCurrencyName() .. " (" .. tostring(feePercentage) .. "%)\n"
            logText = logText .. "Profit: " .. paid .. " " .. WSS:getCurrencyName() .. "\n"
            log:addPage(1, logText)
            srcContainer:addItem(log)
            srcContainer:addItemOnServer(log)

            srcContainer:setDrawDirty(true)
            destContainer:setDrawDirty(true)

            getPlayerInventory(player:getPlayerNum()):refreshBackpacks()
            getPlayerLoot(player:getPlayerNum()):refreshBackpacks()

            sendClientCommand(player, 'WSS', 'logSale', {shop:getName(), item:getName(), totalCost, fee})
        end)

        return {ignoreAction = true}
    end

    -- if the destination container is a shop, we need to check if the player is the shop owner or staff
    shop = destContainer:getContainingItem()
    if shop and WSS:isSimpleShop(shop) then
        if WL_Utils.isStaff(player) or WSS:isShopOwner(player, shop) then
            return result
        end
        return {ignoreAction = true}
    end

    return result
end