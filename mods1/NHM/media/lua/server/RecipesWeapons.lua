function GunPistol1_OnCreate(items, result, player, selectedItem)
    local availableItems = {
        'NHM.BarrelPistol',
        'NHM.Pistolbody',
        'NHM.Triggergroup',
        'NHM.Spring',
    }
    local function tablelength(T)
        local count = 0
        for _ in pairs(T) do count = count + 1 end
        return count
    end
    local resultItems = {}
    local maxBrokenItems = math.floor(0.5 + (10.0 - selectedItem:getCondition()) / 10 * tablelength(availableItems))

    local uniqueIds = { }
    while tablelength(uniqueIds) < maxBrokenItems do
        local chance = ZombRand(1, tablelength(availableItems) + 1)
        if uniqueIds[chance] == nil then
            uniqueIds[chance] = chance
        end
    end

    for index, itemIdWithModule in ipairs(availableItems) do
        if uniqueIds[index] == nil then
            resultItems[itemIdWithModule] = 1
        else
            resultItems['Base.ScrapMetal'] = (resultItems['Base.ScrapMetal'] or 0) + 5
        end
    end

    for itemIdWithModule, quantity in pairs(resultItems) do
        player:getInventory():AddItems(itemIdWithModule, quantity)
    end
    
    for i = 0, selectedItem:getAllWeaponParts():size() - 1 do
        player:getInventory():AddItem(selectedItem:getAllWeaponParts():get(i))
    end
    if selectedItem:isContainsClip() then
        local newMag = InventoryItemFactory.CreateItem(selectedItem:getMagazineType())
        newMag:setCurrentAmmoCount(selectedItem:getCurrentAmmoCount())

        player:getInventory():AddItem(newMag)
        selectedItem:setContainsClip(false)
        selectedItem:setCurrentAmmoCount(0)
    end

    if selectedItem:isRoundChambered() then
        player:getInventory():AddItem(selectedItem:getAmmoType(),1)
        selectedItem:setRoundChambered(false)
    end
end

function GunPistol2_OnCreate(items, result, player, selectedItem)
    local availableItems = {
        'NHM.ChromedBarrelPistol',
        'NHM.HIQLPistolbody',
        'NHM.Triggergroup',
        'NHM.Spring',
    }
    local function tablelength(T)
        local count = 0
        for _ in pairs(T) do count = count + 1 end
        return count
    end
    local resultItems = {}
    local maxBrokenItems = math.floor(0.5 + (10.0 - selectedItem:getCondition()) / 10 * tablelength(availableItems))

    local uniqueIds = { }
    while tablelength(uniqueIds) < maxBrokenItems do
        local chance = ZombRand(1, tablelength(availableItems) + 1)
        if uniqueIds[chance] == nil then
            uniqueIds[chance] = chance
        end
    end

    for index, itemIdWithModule in ipairs(availableItems) do
        if uniqueIds[index] == nil then
            resultItems[itemIdWithModule] = 1
        else
            resultItems['Base.ScrapMetal'] = (resultItems['Base.ScrapMetal'] or 0) + 5
        end
    end

    for itemIdWithModule, quantity in pairs(resultItems) do
        player:getInventory():AddItems(itemIdWithModule, quantity)
    end

    for i = 0, selectedItem:getAllWeaponParts():size() - 1 do
        player:getInventory():AddItem(selectedItem:getAllWeaponParts():get(i))
    end
    if selectedItem:isContainsClip() then
        local newMag = InventoryItemFactory.CreateItem(selectedItem:getMagazineType())
        newMag:setCurrentAmmoCount(selectedItem:getCurrentAmmoCount())

        player:getInventory():AddItem(newMag)
        selectedItem:setContainsClip(false)
        selectedItem:setCurrentAmmoCount(0)
    end

    if selectedItem:isRoundChambered() then
        player:getInventory():AddItem(selectedItem:getAmmoType(),1)
        selectedItem:setRoundChambered(false)
    end
end

function GunRevolver1_OnCreate(items, result, player, selectedItem)
    local availableItems = {
        'NHM.BarrelPistol',
        'NHM.Pistolbody',
        'NHM.Triggergroup',
        'NHM.Revolverdrum',
    }
    local function tablelength(T)
        local count = 0
        for _ in pairs(T) do count = count + 1 end
        return count
    end
    local resultItems = {}
    local maxBrokenItems = math.floor(0.5 + (10.0 - selectedItem:getCondition()) / 10 * tablelength(availableItems))

    local uniqueIds = { }
    while tablelength(uniqueIds) < maxBrokenItems do
        local chance = ZombRand(1, tablelength(availableItems) + 1)
        if uniqueIds[chance] == nil then
            uniqueIds[chance] = chance
        end
    end

    for index, itemIdWithModule in ipairs(availableItems) do
        if uniqueIds[index] == nil then
            resultItems[itemIdWithModule] = 1
        else
            resultItems['Base.ScrapMetal'] = (resultItems['Base.ScrapMetal'] or 0) + 5
        end
    end

    for itemIdWithModule, quantity in pairs(resultItems) do
        player:getInventory():AddItems(itemIdWithModule, quantity)
    end

    for i = 0, selectedItem:getAllWeaponParts():size() - 1 do
        player:getInventory():AddItem(selectedItem:getAllWeaponParts():get(i))
    end
    if selectedItem:isContainsClip() then
        local newMag = InventoryItemFactory.CreateItem(selectedItem:getMagazineType())
        newMag:setCurrentAmmoCount(selectedItem:getCurrentAmmoCount())

        player:getInventory():AddItem(newMag)
        selectedItem:setContainsClip(false)
        selectedItem:setCurrentAmmoCount(0)
    end

    if selectedItem:isRoundChambered() then
        player:getInventory():AddItem(selectedItem:getAmmoType(),1)
        selectedItem:setRoundChambered(false)
    end
end

function GunRevolver2_OnCreate(items, result, player, selectedItem)
    local availableItems = {
        'NHM.ChromedBarrelPistol',
        'NHM.HIQLPistolbody',
        'NHM.Triggergroup',
        'NHM.Revolverdrum',
    }
    local function tablelength(T)
        local count = 0
        for _ in pairs(T) do count = count + 1 end
        return count
    end
    local resultItems = {}
    local maxBrokenItems = math.floor(0.5 + (10.0 - selectedItem:getCondition()) / 10 * tablelength(availableItems))

    local uniqueIds = { }
    while tablelength(uniqueIds) < maxBrokenItems do
        local chance = ZombRand(1, tablelength(availableItems) + 1)
        if uniqueIds[chance] == nil then
            uniqueIds[chance] = chance
        end
    end

    for index, itemIdWithModule in ipairs(availableItems) do
        if uniqueIds[index] == nil then
            resultItems[itemIdWithModule] = 1
        else
            resultItems['Base.ScrapMetal'] = (resultItems['Base.ScrapMetal'] or 0) + 5
        end
    end

    for itemIdWithModule, quantity in pairs(resultItems) do
        player:getInventory():AddItems(itemIdWithModule, quantity)
    end

    for i = 0, selectedItem:getAllWeaponParts():size() - 1 do
        player:getInventory():AddItem(selectedItem:getAllWeaponParts():get(i))
    end
    if selectedItem:isContainsClip() then
        local newMag = InventoryItemFactory.CreateItem(selectedItem:getMagazineType())
        newMag:setCurrentAmmoCount(selectedItem:getCurrentAmmoCount())

        player:getInventory():AddItem(newMag)
        selectedItem:setContainsClip(false)
        selectedItem:setCurrentAmmoCount(0)
    end

    if selectedItem:isRoundChambered() then
        player:getInventory():AddItem(selectedItem:getAmmoType(),1)
        selectedItem:setRoundChambered(false)
    end
end

function GunSMG1_OnCreate(items, result, player, selectedItem)
    local availableItems = {
        'NHM.BarrelPistol',
        'NHM.Pistolbody',
        'NHM.Triggergroup',
        'NHM.Spring',
        'NHM.BoltgroupSA',
    }
    local function tablelength(T)
        local count = 0
        for _ in pairs(T) do count = count + 1 end
        return count
    end
    local resultItems = {}
    local maxBrokenItems = math.floor(0.5 + (10.0 - selectedItem:getCondition()) / 10 * tablelength(availableItems))

    local uniqueIds = { }
    while tablelength(uniqueIds) < maxBrokenItems do
        local chance = ZombRand(1, tablelength(availableItems) + 1)
        if uniqueIds[chance] == nil then
            uniqueIds[chance] = chance
        end
    end

    for index, itemIdWithModule in ipairs(availableItems) do
        if uniqueIds[index] == nil then
            resultItems[itemIdWithModule] = 1
        else
            resultItems['Base.ScrapMetal'] = (resultItems['Base.ScrapMetal'] or 0) + 5
        end
    end

    for itemIdWithModule, quantity in pairs(resultItems) do
        player:getInventory():AddItems(itemIdWithModule, quantity)
    end

    for i = 0, selectedItem:getAllWeaponParts():size() - 1 do
        player:getInventory():AddItem(selectedItem:getAllWeaponParts():get(i))
    end
    if selectedItem:isContainsClip() then
        local newMag = InventoryItemFactory.CreateItem(selectedItem:getMagazineType())
        newMag:setCurrentAmmoCount(selectedItem:getCurrentAmmoCount())

        player:getInventory():AddItem(newMag)
        selectedItem:setContainsClip(false)
        selectedItem:setCurrentAmmoCount(0)
    end

    if selectedItem:isRoundChambered() then
        player:getInventory():AddItem(selectedItem:getAmmoType(),1)
        selectedItem:setRoundChambered(false)
    end
end

function GunSMG2_OnCreate(items, result, player, selectedItem)
    local availableItems = {
        'NHM.ChromedBarrelPistol',
        'NHM.HIQLPistolbody',
        'NHM.Triggergroup',
        'NHM.Spring',
        'NHM.BoltgroupSA',
    }
    local function tablelength(T)
        local count = 0
        for _ in pairs(T) do count = count + 1 end
        return count
    end
    local resultItems = {}
    local maxBrokenItems = math.floor(0.5 + (10.0 - selectedItem:getCondition()) / 10 * tablelength(availableItems))

    local uniqueIds = { }
    while tablelength(uniqueIds) < maxBrokenItems do
        local chance = ZombRand(1, tablelength(availableItems) + 1)
        if uniqueIds[chance] == nil then
            uniqueIds[chance] = chance
        end
    end

    for index, itemIdWithModule in ipairs(availableItems) do
        if uniqueIds[index] == nil then
            resultItems[itemIdWithModule] = 1
        else
            resultItems['Base.ScrapMetal'] = (resultItems['Base.ScrapMetal'] or 0) + 5
        end
    end

    for itemIdWithModule, quantity in pairs(resultItems) do
        player:getInventory():AddItems(itemIdWithModule, quantity)
    end

    for i = 0, selectedItem:getAllWeaponParts():size() - 1 do
        player:getInventory():AddItem(selectedItem:getAllWeaponParts():get(i))
    end
    if selectedItem:isContainsClip() then
        local newMag = InventoryItemFactory.CreateItem(selectedItem:getMagazineType())
        newMag:setCurrentAmmoCount(selectedItem:getCurrentAmmoCount())

        player:getInventory():AddItem(newMag)
        selectedItem:setContainsClip(false)
        selectedItem:setCurrentAmmoCount(0)
    end

    if selectedItem:isRoundChambered() then
        player:getInventory():AddItem(selectedItem:getAmmoType(),1)
        selectedItem:setRoundChambered(false)
    end
end

function GunRifleSA1_OnCreate(items, result, player, selectedItem)
    local availableItems = {
        'NHM.BarrelRifle',
        'NHM.Riflebody',
        'NHM.Triggergroup',
        'NHM.Spring',
        'NHM.BoltgroupSA',
        'NHM.Woodenparts',
    }
    local function tablelength(T)
        local count = 0
        for _ in pairs(T) do count = count + 1 end
        return count
    end
    local resultItems = {}
    local maxBrokenItems = math.floor(0.5 + (10.0 - selectedItem:getCondition()) / 10 * tablelength(availableItems))

    local uniqueIds = { }
    while tablelength(uniqueIds) < maxBrokenItems do
        local chance = ZombRand(1, tablelength(availableItems) + 1)
        if uniqueIds[chance] == nil then
            uniqueIds[chance] = chance
        end
    end

    for index, itemIdWithModule in ipairs(availableItems) do
        if uniqueIds[index] == nil then
            resultItems[itemIdWithModule] = 1
        else
            resultItems['Base.ScrapMetal'] = (resultItems['Base.ScrapMetal'] or 0) + 5
        end
    end

    for itemIdWithModule, quantity in pairs(resultItems) do
        player:getInventory():AddItems(itemIdWithModule, quantity)
    end

    for i = 0, selectedItem:getAllWeaponParts():size() - 1 do
        player:getInventory():AddItem(selectedItem:getAllWeaponParts():get(i))
    end
    if selectedItem:isContainsClip() then
        local newMag = InventoryItemFactory.CreateItem(selectedItem:getMagazineType())
        newMag:setCurrentAmmoCount(selectedItem:getCurrentAmmoCount())

        player:getInventory():AddItem(newMag)
        selectedItem:setContainsClip(false)
        selectedItem:setCurrentAmmoCount(0)
    end

    if selectedItem:isRoundChambered() then
        player:getInventory():AddItem(selectedItem:getAmmoType(),1)
        selectedItem:setRoundChambered(false)
    end
end

function GunRifleSA2_OnCreate(items, result, player, selectedItem)
    local availableItems = {
        'NHM.ChromedBarrelRifle',
        'NHM.HIQLRiflebody',
        'NHM.Triggergroup',
        'NHM.Spring',
        'NHM.BoltgroupSA',
        'NHM.Gastube',
    }
    local function tablelength(T)
        local count = 0
        for _ in pairs(T) do count = count + 1 end
        return count
    end
    local resultItems = {}
    local maxBrokenItems = math.floor(0.5 + (10.0 - selectedItem:getCondition()) / 10 * tablelength(availableItems))

    local uniqueIds = { }
    while tablelength(uniqueIds) < maxBrokenItems do
        local chance = ZombRand(1, tablelength(availableItems) + 1)
        if uniqueIds[chance] == nil then
            uniqueIds[chance] = chance
        end
    end

    for index, itemIdWithModule in ipairs(availableItems) do
        if uniqueIds[index] == nil then
            resultItems[itemIdWithModule] = 1
        else
            resultItems['Base.ScrapMetal'] = (resultItems['Base.ScrapMetal'] or 0) + 5
        end
    end

    for itemIdWithModule, quantity in pairs(resultItems) do
        player:getInventory():AddItems(itemIdWithModule, quantity)
    end

    for i = 0, selectedItem:getAllWeaponParts():size() - 1 do
        player:getInventory():AddItem(selectedItem:getAllWeaponParts():get(i))
    end
    if selectedItem:isContainsClip() then
        local newMag = InventoryItemFactory.CreateItem(selectedItem:getMagazineType())
        newMag:setCurrentAmmoCount(selectedItem:getCurrentAmmoCount())

        player:getInventory():AddItem(newMag)
        selectedItem:setContainsClip(false)
        selectedItem:setCurrentAmmoCount(0)
    end

    if selectedItem:isRoundChambered() then
        player:getInventory():AddItem(selectedItem:getAmmoType(),1)
        selectedItem:setRoundChambered(false)
    end
end

function GunRifleB0_OnCreate(items, result, player, selectedItem)
    local availableItems = {
        'NHM.MetalPipe',
        'NHM.Triggergroup',
        'NHM.Woodenparts',
        'NHM.Boltgroup',
    }
    local function tablelength(T)
        local count = 0
        for _ in pairs(T) do count = count + 1 end
        return count
    end
    local resultItems = {}
    local maxBrokenItems = math.floor(0.5 + (10.0 - selectedItem:getCondition()) / 10 * tablelength(availableItems))

    local uniqueIds = { }
    while tablelength(uniqueIds) < maxBrokenItems do
        local chance = ZombRand(1, tablelength(availableItems) + 1)
        if uniqueIds[chance] == nil then
            uniqueIds[chance] = chance
        end
    end

    for index, itemIdWithModule in ipairs(availableItems) do
        if uniqueIds[index] == nil then
            resultItems[itemIdWithModule] = 1
        else
            resultItems['Base.ScrapMetal'] = (resultItems['Base.ScrapMetal'] or 0) + 5
        end
    end

    for itemIdWithModule, quantity in pairs(resultItems) do
        player:getInventory():AddItems(itemIdWithModule, quantity)
    end

    for i = 0, selectedItem:getAllWeaponParts():size() - 1 do
        player:getInventory():AddItem(selectedItem:getAllWeaponParts():get(i))
    end
    if selectedItem:isContainsClip() then
        local newMag = InventoryItemFactory.CreateItem(selectedItem:getMagazineType())
        newMag:setCurrentAmmoCount(selectedItem:getCurrentAmmoCount())

        player:getInventory():AddItem(newMag)
        selectedItem:setContainsClip(false)
        selectedItem:setCurrentAmmoCount(0)
    end

    if selectedItem:isRoundChambered() then
        player:getInventory():AddItem(selectedItem:getAmmoType(),1)
        selectedItem:setRoundChambered(false)
    end
end

function GunRifleB1_OnCreate(items, result, player, selectedItem)
    local availableItems = {
        'NHM.BarrelRifle',
        'NHM.Riflebody',
        'NHM.Triggergroup',
        'NHM.Woodenparts',
        'NHM.Boltgroup',
    }
    local function tablelength(T)
        local count = 0
        for _ in pairs(T) do count = count + 1 end
        return count
    end
    local resultItems = {}
    local maxBrokenItems = math.floor(0.5 + (10.0 - selectedItem:getCondition()) / 10 * tablelength(availableItems))

    local uniqueIds = { }
    while tablelength(uniqueIds) < maxBrokenItems do
        local chance = ZombRand(1, tablelength(availableItems) + 1)
        if uniqueIds[chance] == nil then
            uniqueIds[chance] = chance
        end
    end

    for index, itemIdWithModule in ipairs(availableItems) do
        if uniqueIds[index] == nil then
            resultItems[itemIdWithModule] = 1
        else
            resultItems['Base.ScrapMetal'] = (resultItems['Base.ScrapMetal'] or 0) + 5
        end
    end

    for itemIdWithModule, quantity in pairs(resultItems) do
        player:getInventory():AddItems(itemIdWithModule, quantity)
    end

    for i = 0, selectedItem:getAllWeaponParts():size() - 1 do
        player:getInventory():AddItem(selectedItem:getAllWeaponParts():get(i))
    end
    if selectedItem:isContainsClip() then
        local newMag = InventoryItemFactory.CreateItem(selectedItem:getMagazineType())
        newMag:setCurrentAmmoCount(selectedItem:getCurrentAmmoCount())

        player:getInventory():AddItem(newMag)
        selectedItem:setContainsClip(false)
        selectedItem:setCurrentAmmoCount(0)
    end

    if selectedItem:isRoundChambered() then
        player:getInventory():AddItem(selectedItem:getAmmoType(),1)
        selectedItem:setRoundChambered(false)
    end
end

function GunRifleB2_OnCreate(items, result, player, selectedItem)
    local availableItems = {
        'NHM.ChromedBarrelRifle',
        'NHM.HIQLRiflebody',
        'NHM.Triggergroup',
        'NHM.Woodenparts',
        'NHM.Boltgroup',
    }
    local function tablelength(T)
        local count = 0
        for _ in pairs(T) do count = count + 1 end
        return count
    end
    local resultItems = {}
    local maxBrokenItems = math.floor(0.5 + (10.0 - selectedItem:getCondition()) / 10 * tablelength(availableItems))

    local uniqueIds = { }
    while tablelength(uniqueIds) < maxBrokenItems do
        local chance = ZombRand(1, tablelength(availableItems) + 1)
        if uniqueIds[chance] == nil then
            uniqueIds[chance] = chance
        end
    end

    for index, itemIdWithModule in ipairs(availableItems) do
        if uniqueIds[index] == nil then
            resultItems[itemIdWithModule] = 1
        else
            resultItems['Base.ScrapMetal'] = (resultItems['Base.ScrapMetal'] or 0) + 5
        end
    end

    for itemIdWithModule, quantity in pairs(resultItems) do
        player:getInventory():AddItems(itemIdWithModule, quantity)
    end

    for i = 0, selectedItem:getAllWeaponParts():size() - 1 do
        player:getInventory():AddItem(selectedItem:getAllWeaponParts():get(i))
    end
    if selectedItem:isContainsClip() then
        local newMag = InventoryItemFactory.CreateItem(selectedItem:getMagazineType())
        newMag:setCurrentAmmoCount(selectedItem:getCurrentAmmoCount())

        player:getInventory():AddItem(newMag)
        selectedItem:setContainsClip(false)
        selectedItem:setCurrentAmmoCount(0)
    end

    if selectedItem:isRoundChambered() then
        player:getInventory():AddItem(selectedItem:getAmmoType(),1)
        selectedItem:setRoundChambered(false)
    end
end

function GunAssaultRifle1_OnCreate(items, result, player, selectedItem)
    local availableItems = {
        'NHM.BarrelRifle',
        'NHM.Riflebody',
        'NHM.Triggergroup',
        'NHM.Spring',
        'NHM.BoltgroupSA',
        'NHM.Gastube',
    }
    local function tablelength(T)
        local count = 0
        for _ in pairs(T) do count = count + 1 end
        return count
    end
    local resultItems = {}
    local maxBrokenItems = math.floor(0.5 + (10.0 - selectedItem:getCondition()) / 10 * tablelength(availableItems))

    local uniqueIds = { }
    while tablelength(uniqueIds) < maxBrokenItems do
        local chance = ZombRand(1, tablelength(availableItems) + 1)
        if uniqueIds[chance] == nil then
            uniqueIds[chance] = chance
        end
    end

    for index, itemIdWithModule in ipairs(availableItems) do
        if uniqueIds[index] == nil then
            resultItems[itemIdWithModule] = 1
        else
            resultItems['Base.ScrapMetal'] = (resultItems['Base.ScrapMetal'] or 0) + 5
        end
    end

    for itemIdWithModule, quantity in pairs(resultItems) do
        player:getInventory():AddItems(itemIdWithModule, quantity)
    end

    for i = 0, selectedItem:getAllWeaponParts():size() - 1 do
        player:getInventory():AddItem(selectedItem:getAllWeaponParts():get(i))
    end
    if selectedItem:isContainsClip() then
        local newMag = InventoryItemFactory.CreateItem(selectedItem:getMagazineType())
        newMag:setCurrentAmmoCount(selectedItem:getCurrentAmmoCount())

        player:getInventory():AddItem(newMag)
        selectedItem:setContainsClip(false)
        selectedItem:setCurrentAmmoCount(0)
    end

    if selectedItem:isRoundChambered() then
        player:getInventory():AddItem(selectedItem:getAmmoType(),1)
        selectedItem:setRoundChambered(false)
    end
end

function GunAssaultRifle2_OnCreate(items, result, player, selectedItem)
    local availableItems = {
        'NHM.ChromedBarrelRifle',
        'NHM.HIQLRiflebody',
        'NHM.Triggergroup',
        'NHM.Spring',
        'NHM.BoltgroupSA',
        'NHM.Gastube',
    }
    local function tablelength(T)
        local count = 0
        for _ in pairs(T) do count = count + 1 end
        return count
    end
    local resultItems = {}
    local maxBrokenItems = math.floor(0.5 + (10.0 - selectedItem:getCondition()) / 10 * tablelength(availableItems))

    local uniqueIds = { }
    while tablelength(uniqueIds) < maxBrokenItems do
        local chance = ZombRand(1, tablelength(availableItems) + 1)
        if uniqueIds[chance] == nil then
            uniqueIds[chance] = chance
        end
    end

    for index, itemIdWithModule in ipairs(availableItems) do
        if uniqueIds[index] == nil then
            resultItems[itemIdWithModule] = 1
        else
            resultItems['Base.ScrapMetal'] = (resultItems['Base.ScrapMetal'] or 0) + 5
        end
    end

    for itemIdWithModule, quantity in pairs(resultItems) do
        player:getInventory():AddItems(itemIdWithModule, quantity)
    end

    for i = 0, selectedItem:getAllWeaponParts():size() - 1 do
        player:getInventory():AddItem(selectedItem:getAllWeaponParts():get(i))
    end
    if selectedItem:isContainsClip() then
        local newMag = InventoryItemFactory.CreateItem(selectedItem:getMagazineType())
        newMag:setCurrentAmmoCount(selectedItem:getCurrentAmmoCount())

        player:getInventory():AddItem(newMag)
        selectedItem:setContainsClip(false)
        selectedItem:setCurrentAmmoCount(0)
    end

    if selectedItem:isRoundChambered() then
        player:getInventory():AddItem(selectedItem:getAmmoType(),1)
        selectedItem:setRoundChambered(false)
    end
end

function GunShotgunDB_OnCreate(items, result, player, selectedItem)
    local availableItems = {
        'NHM.MetalPipe',
        'NHM.MetalPipe',
        'NHM.Triggergroup',
        'NHM.Woodenparts',
    }
    local function tablelength(T)
        local count = 0
        for _ in pairs(T) do count = count + 1 end
        return count
    end
    local resultItems = {}
    local maxBrokenItems = math.floor(0.5 + (10.0 - selectedItem:getCondition()) / 10 * tablelength(availableItems))

    local uniqueIds = { }
    while tablelength(uniqueIds) < maxBrokenItems do
        local chance = ZombRand(1, tablelength(availableItems) + 1)
        if uniqueIds[chance] == nil then
            uniqueIds[chance] = chance
        end
    end

    for index, itemIdWithModule in ipairs(availableItems) do
        if uniqueIds[index] == nil then
            resultItems[itemIdWithModule] = 1
        else
            resultItems['Base.ScrapMetal'] = (resultItems['Base.ScrapMetal'] or 0) + 5
        end
    end

    for itemIdWithModule, quantity in pairs(resultItems) do
        player:getInventory():AddItems(itemIdWithModule, quantity)
    end

    for i = 0, selectedItem:getAllWeaponParts():size() - 1 do
        player:getInventory():AddItem(selectedItem:getAllWeaponParts():get(i))
    end
    if selectedItem:isContainsClip() then
        local newMag = InventoryItemFactory.CreateItem(selectedItem:getMagazineType())
        newMag:setCurrentAmmoCount(selectedItem:getCurrentAmmoCount())

        player:getInventory():AddItem(newMag)
        selectedItem:setContainsClip(false)
        selectedItem:setCurrentAmmoCount(0)
    end

    if selectedItem:isRoundChambered() then
        player:getInventory():AddItem(selectedItem:getAmmoType(),1)
        selectedItem:setRoundChambered(false)
    end
end

function GunShotgun1_OnCreate(items, result, player, selectedItem)
    local availableItems = {
        'NHM.MetalPipe',
        'NHM.MetalPipe',
        'NHM.Triggergroup',
        'NHM.Woodenparts',
        'NHM.Boltgroup',
    }
    local function tablelength(T)
        local count = 0
        for _ in pairs(T) do count = count + 1 end
        return count
    end
    local resultItems = {}
    local maxBrokenItems = math.floor(0.5 + (10.0 - selectedItem:getCondition()) / 10 * tablelength(availableItems))

    local uniqueIds = { }
    while tablelength(uniqueIds) < maxBrokenItems do
        local chance = ZombRand(1, tablelength(availableItems) + 1)
        if uniqueIds[chance] == nil then
            uniqueIds[chance] = chance
        end
    end

    for index, itemIdWithModule in ipairs(availableItems) do
        if uniqueIds[index] == nil then
            resultItems[itemIdWithModule] = 1
        else
            resultItems['Base.ScrapMetal'] = (resultItems['Base.ScrapMetal'] or 0) + 5
        end
    end

    for itemIdWithModule, quantity in pairs(resultItems) do
        player:getInventory():AddItems(itemIdWithModule, quantity)
    end

    for i = 0, selectedItem:getAllWeaponParts():size() - 1 do
        player:getInventory():AddItem(selectedItem:getAllWeaponParts():get(i))
    end
    if selectedItem:isContainsClip() then
        local newMag = InventoryItemFactory.CreateItem(selectedItem:getMagazineType())
        newMag:setCurrentAmmoCount(selectedItem:getCurrentAmmoCount())

        player:getInventory():AddItem(newMag)
        selectedItem:setContainsClip(false)
        selectedItem:setCurrentAmmoCount(0)
    end

    if selectedItem:isRoundChambered() then
        player:getInventory():AddItem(selectedItem:getAmmoType(),1)
        selectedItem:setRoundChambered(false)
    end
end

function GunShotgun2_OnCreate(items, result, player, selectedItem)
    local availableItems = {
        'NHM.MetalPipe',
        'NHM.MetalPipe',
        'NHM.Riflebody',
        'NHM.Triggergroup',
        'NHM.Revolverdrum',
        'NHM.Boltgroup',
    }
    local function tablelength(T)
        local count = 0
        for _ in pairs(T) do count = count + 1 end
        return count
    end
    local resultItems = {}
    local maxBrokenItems = math.floor(0.5 + (10.0 - selectedItem:getCondition()) / 10 * tablelength(availableItems))

    local uniqueIds = { }
    while tablelength(uniqueIds) < maxBrokenItems do
        local chance = ZombRand(1, tablelength(availableItems) + 1)
        if uniqueIds[chance] == nil then
            uniqueIds[chance] = chance
        end
    end

    for index, itemIdWithModule in ipairs(availableItems) do
        if uniqueIds[index] == nil then
            resultItems[itemIdWithModule] = 1
        else
            resultItems['Base.ScrapMetal'] = (resultItems['Base.ScrapMetal'] or 0) + 5
        end
    end

    for itemIdWithModule, quantity in pairs(resultItems) do
        player:getInventory():AddItems(itemIdWithModule, quantity)
    end

    for i = 0, selectedItem:getAllWeaponParts():size() - 1 do
        player:getInventory():AddItem(selectedItem:getAllWeaponParts():get(i))
    end
    if selectedItem:isContainsClip() then
        local newMag = InventoryItemFactory.CreateItem(selectedItem:getMagazineType())
        newMag:setCurrentAmmoCount(selectedItem:getCurrentAmmoCount())

        player:getInventory():AddItem(newMag)
        selectedItem:setContainsClip(false)
        selectedItem:setCurrentAmmoCount(0)
    end

    if selectedItem:isRoundChambered() then
        player:getInventory():AddItem(selectedItem:getAmmoType(),1)
        selectedItem:setRoundChambered(false)
    end
end

function RepairFull(items, result, player, selectedItem)
    result:setCondition(selectedItem:getConditionMax())
end

function RepairArmor(items, result, player, selectedItem)
    result:setCondition(selectedItem:getCondition())
end