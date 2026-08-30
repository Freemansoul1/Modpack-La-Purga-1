require "Recipecode"

LC_Recipe = {}
LC_Recipe.OnCreate = {}

function LC_Recipe.OnCreate.Clean(items, result, player)
    local item = InventoryItemFactory.CreateItem(LandClaimConfig.LCItemFullType)
    if item then
        item:setName('Land Claim')
        local inventory = player:getInventory()
        inventory:DoAddItem(item)
    end
end

LC_Recipe_OnCreate_Clean = LC_Recipe.OnCreate.Clean
