-- All credit to Konijima

local function switchWeapon(newWeapon, oldWeapon)
    local weaponData = {
        currentAmmo = oldWeapon:getCurrentAmmoCount(),
        condition = oldWeapon:getCondition(),
        haveChamber = oldWeapon:haveChamber(),
        isJammed = oldWeapon:isJammed(),
        magazineType = oldWeapon:getMagazineType(),
        isRoundChambered = oldWeapon:isRoundChambered(),
        isContainsClip = oldWeapon:isContainsClip(),
    }
    newWeapon:getModData().oldWeaponData = weaponData;

    local oldWeapondata = oldWeapon:getModData().oldWeaponData;
    if oldWeapondata then
        newWeapon:setContainsClip(oldWeapondata.isContainsClip or false);
        newWeapon:setCurrentAmmoCount(oldWeapondata.currentAmmo or 0);
        newWeapon:setHaveChamber(oldWeapondata.haveChamber or false);
        newWeapon:setRoundChambered(oldWeapondata.isRoundChambered or false);
        newWeapon:setJammed(oldWeapondata.isJammed or false);
        newWeapon:setMagazineType(oldWeapondata.magazineType or nil);
        newWeapon:setCondition(oldWeapondata.condition or newWeapon:getConditionMax());
    end
end

local function onKeyPressed_weapon_switch(key)
    if key == Keyboard.KEY_HOME then  -- toggle weapon mode
    
        local player = getPlayer();
        local inventory = player:getInventory();

        local function getEquippedPulseRifle(item)
            return item:getType() == "Wiz_m41APulseRifle" and item:isEquipped();
        end
        local function getEquippedPulseGrenade(item)
            return item:getType() == "Wiz_m41APulseGrenade" and item:isEquipped();
        end
        
        local equippedPulseRifle = inventory:getFirstEvalRecurse(getEquippedPulseRifle);
        local equippedPulseGrenade = inventory:getFirstEvalRecurse(getEquippedPulseGrenade);

        local newItem;
        if equippedPulseRifle then
            -- do you stuff if its a pulse rifle
            inventory:Remove(equippedPulseRifle);
            newItem = inventory:AddItem("Wiz_m41APulseGrenade");
            switchWeapon(newItem, equippedPulseRifle);
            player:Say("Grenade Launcher Mode");
        elseif equippedPulseGrenade then
            -- do you stuff if its a pulse grenade
            inventory:Remove(equippedPulseGrenade);
            newItem = inventory:AddItem("Wiz_m41APulseRifle");
            switchWeapon(newItem, equippedPulseGrenade);
            player:Say("Pulse Rifle Mode");
        end

        if newItem then
            getSoundManager():PlayWorldSoundWav('M16Rack', false, player:getSquare(), 0, 0, 0, true);
            player:setPrimaryHandItem(nil);
            player:setSecondaryHandItem(nil);
            player:setPrimaryHandItem(newItem);
            player:setSecondaryHandItem(newItem);
        end
    end
end
Events.OnKeyPressed.Add(onKeyPressed_weapon_switch)