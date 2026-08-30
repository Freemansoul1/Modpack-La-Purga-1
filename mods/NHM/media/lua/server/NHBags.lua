NHB = {}
NHB.AcceptItemFunctionQuiver = function(inventoryContainer, inventoryItem)
local scriptItem = inventoryItem:getScriptItem()
    local category = scriptItem:getDisplayCategory()
    if category == "Arrows" then
        return true
    end
end

NHB.AcceptItemFunctionAmmo = function(inventoryContainer, inventoryItem)
    local scriptItem = inventoryItem:getScriptItem()
        local category = scriptItem:getDisplayCategory()
        if category == "Ammo" or category == "WeaponPart" then
            return true
        end
end

NHB.AcceptItemFunctionMedical = function(inventoryContainer, inventoryItem)
        local scriptItem = inventoryItem:getScriptItem()
            local category = scriptItem:getDisplayCategory()
            if category == "FirstAid" then
                return true
        end
end

NHB.AcceptItemFunctionSupply = function(inventoryContainer, inventoryItem)
    local scriptItem = inventoryItem:getScriptItem()
        local category = scriptItem:getDisplayCategory()
        if category == "Food" then
            return true
    end
end