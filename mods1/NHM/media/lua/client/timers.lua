require "SSRTimer"

PrevBDamage = {}

local function tablelength(T)
    local count = 0
    for _ in pairs(T) do
        count = count + 1
    end
    return count
end

function loadPrevBDamage()
    local tickCount = 0
    local function Process()
        if tickCount < 20 then
            tickCount = tickCount + 1
            return
        end

        print("LODAING PREVIOUS DAMAGE...")

        local BDamage = getPlayer():getBodyDamage();
        local BParts = BDamage:getBodyParts();

        local tableBDamage = {}
        for i = 0, BParts:size() - 1 do
            local bpart = BParts:get(i)
            local bpartType = tostring(bpart:getType())
            tableBDamage[bpartType] = {}
            tableBDamage[bpartType]["Bullet"] = bpart:haveBullet()
            tableBDamage[bpartType]["Health"] = bpart:getHealth()
        end

        for k, v in pairs(tableBDamage) do
            print(v["Bullet"])
            print(v["Health"])
        end

        PrevBDamage = tableBDamage

        print("LOADING DONE!")

        Events.EveryTenMinutes.Remove(loadPrevBDamage)
        Events.OnPlayerUpdate.Remove(Process)
    end
    Events.OnPlayerUpdate.Add(Process)
end

function CheckForLosingEnergyLevel()
    local info = getPlayer():getPerkInfo(Perks.MineEndurance);
    if info then
        local level = info:getLevel()
        if level >= 1 and level <= 10 and getPlayer():getXp():getXP(Perks.MineEndurance) < PerkFactory.getPerk(Perks.MineEndurance):getTotalXpForLevel(level) then
            getPlayer():LoseLevel(Perks.MineEndurance);
        end
    end
end

function Footprints()
    local player = getPlayer()
    local AllFootprintsList = {
        player:getInventory():getAllTypeRecurse("BoarFootprints"),
        player:getInventory():getAllTypeRecurse("WolfFootprints"),
        player:getInventory():getAllTypeRecurse("BearFootprints"),
        player:getInventory():getAllTypeRecurse("GoatFootprints"),
        player:getInventory():getAllTypeRecurse("CowFootprints"),
        player:getInventory():getAllTypeRecurse("FoxFootprints"),
        player:getInventory():getAllTypeRecurse("ODeerFootprints"),
        player:getInventory():getAllTypeRecurse("YDeerFootprints"),
        player:getInventory():getAllTypeRecurse("DogFootprints"),
        player:getInventory():getAllTypeRecurse("MooseFootprints"),
        player:getInventory():getAllTypeRecurse("CoyoteFootprints"),
        player:getInventory():getAllTypeRecurse("HareFootprints"),
        player:getInventory():getAllTypeRecurse("ChickenFootprints"),
        player:getInventory():getAllTypeRecurse("CrowFootprints")
    }

    for i = 1, #AllFootprintsList do
        local FootprintsList = AllFootprintsList[i]
        if FootprintsList ~= nil then
            if FootprintsList:size() ~= 0 then
                for j = 0, FootprintsList:size() - 1 do
                    local item = FootprintsList:get(j)
                    if item:getUsedDelta() <= 0.01 then
                        player:getInventory():removeItemWithIDRecurse(item:getID())
                        break
                    else
                        item:setUsedDelta(item:getUsedDelta() - 0.000125);
                        break
                    end
                end
            end
        end
    end

end

function DieFromFakeInfection()
    local player = getPlayer();
    local bodyParts = player:getBodyDamage():getBodyParts()
    local items = player:getInventory():getItems();
    local x1 = getPlayer():getX();
    local y1 = getPlayer():getY();
    if player:getBodyDamage():getFakeInfectionLevel() >= 25 and player:getBodyDamage():getFakeInfectionLevel() < 50 then
        local bodyParts = player:getBodyDamage():getBodyParts()
        for i = 1, bodyParts:size() do
            local bodyPart = bodyParts:get(i - 1)
            bodyPart:AddDamage(1.0)
        end
    elseif player:getBodyDamage():getFakeInfectionLevel() >= 50 and player:getBodyDamage():getFakeInfectionLevel() < 75 then
        local bodyParts = player:getBodyDamage():getBodyParts()
        for i = 1, bodyParts:size() do
            local bodyPart = bodyParts:get(i - 1)
            bodyPart:AddDamage(2.0)
        end
    elseif player:getBodyDamage():getFakeInfectionLevel() >= 75 then
        local bodyParts = player:getBodyDamage():getBodyParts()
        for i = 1, bodyParts:size() do
            local bodyPart = bodyParts:get(i - 1)
            bodyPart:AddDamage(3.0)
        end
    end
end

local function containsGasMask(items)
    local item = nil
    for i = 0, items:size() - 1 do
        item = items:get(i);
        if item:getType() == "Hat_Gasmask2" then
            return item
        end
    end
    return nil
end

function Radiation()
    local player = getPlayer()
    local bodyParts = player:getBodyDamage():getBodyParts()
    local items = player:getInventory():getItems()
    local x1 = getPlayer():getX()
    local y1 = getPlayer():getY()

    if ((x1 <= 9064 and x1 >= 9025) and (y1 <= 7200 and y1 >= 7170)) or ((x1 <= 15000 and x1 >= 11900) and (y1 <= 3450 and y1 >= 1000)) or ((x1 <= 15963 and x1 >= 15915) and (y1 <= 3798 and y1 >= 3757)) then
        local itemGasMask = containsGasMask(items)
        if itemGasMask ~= nil and player:isEquippedClothing(itemGasMask) then
            if player:getInventory():contains("HandmadeGasMaskFilter") then
                for i = 0, items:size() - 1 do
                    local item = items:get(i);
                    if item:getType() == "HandmadeGasMaskFilter" then
                        if item:getUsedDelta() <= 0.01 then
                            player:getInventory():Remove(item)
                            break
                        else
                            item:setUsedDelta(item:getUsedDelta() - 0.002);
                            break
                        end
                    end
                end
            elseif player:getInventory():contains("RegularGasMaskFilter") then
                for i = 0, items:size() - 1 do
                    local item = items:get(i);
                    if item:getType() == "RegularGasMaskFilter" then
                        if item:getUsedDelta() <= 0.01 then
                            player:getInventory():Remove(item)
                            break
                        else
                            item:setUsedDelta(item:getUsedDelta() - 0.001);
                            break
                        end
                    end
                end
            elseif player:getInventory():contains("AdvancedGasMaskFilter") then
                for i = 0, items:size() - 1 do
                    local item = items:get(i);
                    if item:getType() == "AdvancedGasMaskFilter" then
                        if item:getUsedDelta() <= 0.01 then
                            player:getInventory():Remove(item)
                            break
                        else
                            item:setUsedDelta(item:getUsedDelta() - 0.0005);
                            break
                        end
                    end
                end
            else
                if player:getBodyDamage():getFakeInfectionLevel() <= 99 then
                    player:getBodyDamage():setFakeInfectionLevel(player:getBodyDamage():getFakeInfectionLevel() + 0.2);
                end
            end
        else
            if player:getBodyDamage():getFakeInfectionLevel() <= 99 then
                player:getBodyDamage():setFakeInfectionLevel(player:getBodyDamage():getFakeInfectionLevel() + 0.2);
            end
        end
        if player:getBodyDamage():getFakeInfectionLevel() > 25 then
            local bodyParts = player:getBodyDamage():getBodyParts()
            for i = 1, bodyParts:size() do
                local bodyPart = bodyParts:get(i - 1)
                bodyPart:AddDamage(0.01)
            end
        end
        if ZombRand(2) == 0 and player:getInventory():contains("GeigerCounter") then
            getSoundManager():PlaySound("Radiation", true, 0.8);
        end
    end

    if ((x1 <= 9104 and x1 >= 9078) and (y1 <= 6990 and y1 >= 6919)) or ((x1 <= 3628 and x1 >= 3600) and (y1 <= 10740 and y1 >= 10674)) then
        local itemGasMask = containsGasMask(items)
        if itemGasMask ~= nil and player:isEquippedClothing(itemGasMask) then
            if player:getInventory():contains("RegularGasMaskFilter") then
                for i = 0, items:size() - 1 do
                    local item = items:get(i);
                    if item:getType() == "RegularGasMaskFilter" then
                        if item:getUsedDelta() <= 0.01 then
                            player:getInventory():Remove(item);
                            break
                        else
                            item:setUsedDelta(item:getUsedDelta() - 0.002);
                            break
                        end
                    end
                end
            elseif player:getInventory():contains("AdvancedGasMaskFilter") then
                for i = 0, items:size() - 1 do
                    local item = items:get(i);
                    if item:getType() == "AdvancedGasMaskFilter" then
                        if item:getUsedDelta() <= 0.01 then
                            player:getInventory():Remove(item);
                            break
                        else
                            item:setUsedDelta(item:getUsedDelta() - 0.001);
                            break
                        end
                    end
                end
            else
                if player:getBodyDamage():getFakeInfectionLevel() <= 99 then
                    player:getBodyDamage():setFakeInfectionLevel(player:getBodyDamage():getFakeInfectionLevel() + 0.4);
                end
            end
        else
            if player:getBodyDamage():getFakeInfectionLevel() <= 99 then
                player:getBodyDamage():setFakeInfectionLevel(player:getBodyDamage():getFakeInfectionLevel() + 0.6);
            end
        end
        if player:getBodyDamage():getFakeInfectionLevel() > 25 then
            local bodyParts = player:getBodyDamage():getBodyParts()
            for i = 1, bodyParts:size() do
                local bodyPart = bodyParts:get(i - 1)
                bodyPart:AddDamage(0.02)
            end
        end
        if ZombRand(2) == 0 and player:getInventory():contains("GeigerCounter") then
            getSoundManager():PlaySound("Radiation", true, 0.8);
        end
    end

    if ((x1 <= 9188 and x1 >= 9116) and (y1 <= 7199 and y1 >= 7181)) or ((x1 <= 4689 and x1 >= 4626) and (y1 <= 11999 and y1 >= 11973)) or ((x1 <= 11262 and x1 >= 11116) and (y1 <= 13034 and y1 >= 12900)) then
        local itemGasMask = containsGasMask(items)
        if itemGasMask ~= nil and player:isEquippedClothing(itemGasMask) then
            if player:getInventory():contains("AdvancedGasMaskFilter") then
                for i = 0, items:size() - 1 do
                    local item = items:get(i);
                    if item:getType() == "AdvancedGasMaskFilter" then
                        if item:getUsedDelta() <= 0.01 then
                            player:getInventory():Remove(item);
                            break
                        else
                            item:setUsedDelta(item:getUsedDelta() - 0.001);
                            break
                        end
                    end
                end
            else
                if player:getBodyDamage():getFakeInfectionLevel() <= 99 then
                    player:getBodyDamage():setFakeInfectionLevel(player:getBodyDamage():getFakeInfectionLevel() + 0.6);
                end
            end
        else
            if player:getBodyDamage():getFakeInfectionLevel() <= 99 then
                player:getBodyDamage():setFakeInfectionLevel(player:getBodyDamage():getFakeInfectionLevel() + 1);
            end
        end
        if player:getBodyDamage():getFakeInfectionLevel() > 25 then
            local bodyParts = player:getBodyDamage():getBodyParts()
            for i = 1, bodyParts:size() do
                local bodyPart = bodyParts:get(i - 1)
                bodyPart:AddDamage(0.03)
            end
        end
        if ZombRand(2) == 0 and player:getInventory():contains("GeigerCounter") then
            getSoundManager():PlaySound("Radiation", true, 0.8);
        end
    end

end

function ShieldArmor()
    --TODO: add armor logic
    local player = getPlayer()
    local BDamage = player:getBodyDamage();
    local BParts = BDamage:getBodyParts();
    local avoid = ZombRand(100)
    local currentHandItem = player:getSecondaryHandItem()
    local tableBDamage = {}

    for i = 0, BParts:size() - 1 do
        local bpart = BParts:get(i)
        local bpartType = tostring(bpart:getType())
        tableBDamage[bpartType] = {}
        tableBDamage[bpartType]["Bullet"] = bpart:haveBullet()
        tableBDamage[bpartType]["Health"] = bpart:getHealth()
    end

    if currentHandItem and currentHandItem:getType() == "Shield1" then
        if avoid <= 50 and tablelength(PrevBDamage) ~= 0 and not currentHandItem:isBroken() then
            for i = 0, BParts:size() - 1 do
                local bpart = BParts:get(i)
                local bpartType = tostring(bpart:getType())
                if tableBDamage[bpartType]["Bullet"] and not PrevBDamage[bpartType]["Bullet"] then
                    local blocksound = ZombRand(2)
                    if blocksound == 1 then
                        getSoundManager():PlaySound("Rikoshet1", true, 0.8);
                    else
                        getSoundManager():PlaySound("Rikoshet2", true, 0.8);
                    end
                    bpart:RestoreToFullHealth();
                    if tableBDamage[bpartType]["Health"] < PrevBDamage[bpartType]["Health"] then
                        bpart:SetHealth(PrevBDamage[bpartType]["Health"])
                    end
                    currentHandItem:setUsedDelta(currentHandItem:getUsedDelta() - 0.1);
                end
            end
        end
    end

    if currentHandItem and currentHandItem:getType() == "Shield2" then
        if avoid <= 90 and tablelength(PrevBDamage) ~= 0 and not currentHandItem:isBroken() then
            for i = 0, BParts:size() - 1 do
                local bpart = BParts:get(i)
                local bpartType = tostring(bpart:getType())
                if tableBDamage[bpartType]["Bullet"] and not PrevBDamage[bpartType]["Bullet"] then
                    local blocksound = ZombRand(2)
                    if blocksound == 1 then
                        getSoundManager():PlaySound("Rikoshet1", true, 0.8);
                    else
                        getSoundManager():PlaySound("Rikoshet2", true, 0.8);
                    end
                    bpart:RestoreToFullHealth();
                    if tableBDamage[bpartType]["Health"] < PrevBDamage[bpartType]["Health"] then
                        bpart:SetHealth(PrevBDamage[bpartType]["Health"])
                    end
                    currentHandItem:setUsedDelta(currentHandItem:getUsedDelta() - 0.1);
                end
            end
        end
    end

    if currentHandItem and currentHandItem:getType() == "Shield2Shark" then
        if avoid <= 90 and tablelength(PrevBDamage) ~= 0 and not currentHandItem:isBroken() then
            for i = 0, BParts:size() - 1 do
                local bpart = BParts:get(i)
                local bpartType = tostring(bpart:getType())
                if tableBDamage[bpartType]["Bullet"] and not PrevBDamage[bpartType]["Bullet"] then
                    local blocksound = ZombRand(2)
                    if blocksound == 1 then
                        getSoundManager():PlaySound("Rikoshet1", true, 0.8);
                    else
                        getSoundManager():PlaySound("Rikoshet2", true, 0.8);
                    end
                    bpart:RestoreToFullHealth();
                    if tableBDamage[bpartType]["Health"] < PrevBDamage[bpartType]["Health"] then
                        bpart:SetHealth(PrevBDamage[bpartType]["Health"])
                    end
                    getSoundManager():PlaySound("Rikoshet2", true, 0.8);
                    currentHandItem:setUsedDelta(currentHandItem:getUsedDelta() - 0.1);
                end
            end
        end
    end

    if currentHandItem and currentHandItem:getType() == "Shield2LGN" then
        if avoid <= 90 and tablelength(PrevBDamage) ~= 0 and not currentHandItem:isBroken() then
            for i = 0, BParts:size() - 1 do
                local bpart = BParts:get(i)
                local bpartType = tostring(bpart:getType())
                if tableBDamage[bpartType]["Bullet"] and not PrevBDamage[bpartType]["Bullet"] then
                    local blocksound = ZombRand(2)
                    if blocksound == 1 then
                        getSoundManager():PlaySound("Rikoshet1", true, 0.8);
                    else
                        getSoundManager():PlaySound("Rikoshet2", true, 0.8);
                    end
                    bpart:RestoreToFullHealth();
                    if tableBDamage[bpartType]["Health"] < PrevBDamage[bpartType]["Health"] then
                        bpart:SetHealth(PrevBDamage[bpartType]["Health"])
                    end
                    currentHandItem:setUsedDelta(currentHandItem:getUsedDelta() - 0.1);
                end
            end
        end
    end

    local BDamageNew = player:getBodyDamage();
    local BPartsNew = BDamageNew:getBodyParts();
    for i = 0, BPartsNew:size() - 1 do
        local bpart = BPartsNew:get(i)
        local bpartType = tostring(bpart:getType())
        tableBDamage[bpartType] = {}
        tableBDamage[bpartType]["Bullet"] = bpart:haveBullet()
        tableBDamage[bpartType]["Health"] = bpart:getHealth()
    end
    PrevBDamage = tableBDamage

    local Shields1 = player:getInventory():getAllTypeRecurse("Shield1")

    if Shields1 ~= nil then
        for i = 0, Shields1:size() - 1 do
            local item = Shields1:get(i)
            if item:getUsedDelta() == 0 then
                player:removeFromHands(item)
                item:setBroken(true)
            end
        end
    end
    local Shields2 = player:getInventory():getAllTypeRecurse("Shield2")

    if Shields2 ~= nil then
        for i = 0, Shields2:size() - 1 do
            local item = Shields2:get(i)
            if item:getUsedDelta() == 0 then
                player:removeFromHands(item)
                item:setBroken(true)
            end
        end
    end

    local Shields2Shark = player:getInventory():getAllTypeRecurse("Shield2Shark")

    if Shields2Shark ~= nil then
        for i = 0, Shields2Shark:size() - 1 do
            local item = Shields2Shark:get(i)
            if item:getUsedDelta() == 0 then
                player:removeFromHands(item)
                item:setBroken(true)
            end
        end
    end

    local Shields2LGN = player:getInventory():getAllTypeRecurse("Shield2LGN")

    if Shields2LGN ~= nil then
        for i = 0, Shields2LGN:size() - 1 do
            local item = Shields2LGN:get(i)
            if item:getUsedDelta() == 0 then
                player:removeFromHands(item)
                item:setBroken(true)
            end
        end
    end
end

Events.OnPlayerUpdate.Add(CheckForLosingEnergyLevel)
SSRTimer.add_ms(Footprints, 500, true)
SSRTimer.add_ms(Radiation, 500, true)
Events.EveryTenMinutes.Add(DieFromFakeInfection);

SSRTimer.add_ms(ShieldArmor, 100, true)
Events.EveryTenMinutes.Add(loadPrevBDamage)