local function doBuff(character, inventoryItem)
    if not inventoryItem or not inventoryItem:IsWeapon() then
        return
    end

    local wmd = inventoryItem:getModData()

    if not wmd.pzarpg or not wmd.pzarpg.originalStats then
        wmd.pzarpg = {}
        wmd.pzarpg.originalStats = {
            swingtime = inventoryItem:getSwingTime(),
            mindamage = inventoryItem:getMinDamage(),
            maxdamage = inventoryItem:getMaxDamage(),
            criticalchance = inventoryItem:getCriticalChance(),
            rangemaximum = inventoryItem:getMaxRange(),
            aimingtime = inventoryItem:getAimingTime()
        }
    end

    local modData = character:getModData()
    if not modData.pzarpg or not modData.pzarpg.buffs then
        inventoryItem:setSwingTime(wmd.pzarpg.originalStats.swingtime)
        inventoryItem:setMinDamage(wmd.pzarpg.originalStats.mindamage)
        inventoryItem:setMaxDamage(wmd.pzarpg.originalStats.maxdamage)
        inventoryItem:setMaxRange(wmd.pzarpg.originalStats.rangemaximum)
        inventoryItem:setCriticalChance(wmd.pzarpg.originalStats.criticalchance)
        inventoryItem:setAimingTime(wmd.pzarpg.originalStats.aimingtime)
        return
    end

    if modData.pzarpg.buffs['swing_speed'] then
        local buffModifier = 1 - modData.pzarpg.buffs['swing_speed'].value --decrease so modifier has to be less than 1
        inventoryItem:setSwingTime(wmd.pzarpg.originalStats.swingtime * buffModifier)
    else
        inventoryItem:setSwingTime(wmd.pzarpg.originalStats.swingtime)
    end

    if modData.pzarpg.buffs['attack_dmg'] then
        local buffModifier = 1 + modData.pzarpg.buffs['attack_dmg'].value
        inventoryItem:setMinDamage(wmd.pzarpg.originalStats.mindamage * buffModifier)
        inventoryItem:setMaxDamage(wmd.pzarpg.originalStats.maxdamage * buffModifier)
    else
        inventoryItem:setMinDamage(wmd.pzarpg.originalStats.mindamage)
        inventoryItem:setMaxDamage(wmd.pzarpg.originalStats.maxdamage)
    end

    if modData.pzarpg.buffs['attack_range'] then
        local buffModifier = 1 + modData.pzarpg.buffs['attack_range'].value
        inventoryItem:setMaxRange(wmd.pzarpg.originalStats.rangemaximum * buffModifier)
    else
        inventoryItem:setMaxRange(wmd.pzarpg.originalStats.rangemaximum)
    end

    if modData.pzarpg.buffs['crit_chance'] then
        local buffModifier = 1 + modData.pzarpg.buffs['crit_chance'].value
        inventoryItem:setCriticalChance(wmd.pzarpg.originalStats.criticalchance * buffModifier)
    else
        inventoryItem:setCriticalChance(wmd.pzarpg.originalStats.criticalchance)
    end

    if modData.pzarpg.buffs['accuracy'] then
        local buffModifier = 1 - modData.pzarpg.buffs['accuracy'].value  --decrease so modifier has to be less than 1
        inventoryItem:setAimingTime(wmd.pzarpg.originalStats.aimingtime * buffModifier)
    else
        inventoryItem:setAimingTime(wmd.pzarpg.originalStats.aimingtime)
    end
end

Events.OnEquipPrimary.Add(doBuff)
Events.OnEquipSecondary.Add(doBuff)

function PzArpg_UpdateEquippedWeapon(player)
    local primaryHandItem = player:getPrimaryHandItem()

    doBuff(player, primaryHandItem)
end
