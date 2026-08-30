WeaponWithoutSuppressorTable = {
    ["AssaultRifleMK"]="M16Shoot", ["AssaultRifleAR"]="M16Shoot", 
    ["AssaultRifleAK"]="M14Shoot", ["AssaultRifleDSA"]="M14Shoot",
};

AutomaticRiflesTable = {
    "AssaultRifleMK", "AssaultRifleAR",
    "AssaultRifleAK", "AssaultRifleDSA",
    "SRifleM1A", "SRifleSVD",
};

SingleShotRiflesTable = {
    "BRifle700M", "BRifleMOS",
};

WeaponWithSupressorTable = {};
WeaponSuppressionLevelTable = {
    ["AssaultRifleMK"]=0.3, ["AssaultRifleAR"]=0.3, 
    ["AssaultRifleAK"]=0.3, ["AssaultRifleDSA"]=0.3,
};

local function initializeWeaponTables()
    for k, v in pairs(WeaponWithoutSuppressorTable) do
        WeaponWithSupressorTable[k] = WeaponWithoutSuppressorTable[k] .. "_Silenced";
    end
end

function IsSuppressorAttached(weapon)
    local weaponCanon = weapon:getCanon();
    if (weaponCanon) and string.find(weaponCanon:getType(), "Supressor") then
        return true
    else
        return false
    end
end

function TableHasValue(table, val)
    for index, value in ipairs(table) do
        if value == val then
            return true
        end
    end

    return false
end

function IsHandguardAttached(weapon)
    local weaponScript = weapon:getScriptItem();
    local weaponName = weaponScript:getName();
    local isAutomaticRifle = TableHasValue(AutomaticRiflesTable, weaponName);
    local isSingleShotRifle = TableHasValue(SingleShotRiflesTable, weaponName);
    if (isAutomaticRifle) then
        local weaponCanon = weapon:getSling();
        if (weaponCanon) and string.find(weaponCanon:getType(), "Handguard") then
            return true
        else 
            return false
        end
    elseif (isSingleShotRifle) then
        local weaponStock = weapon:getStock();
        if (weaponStock) and string.find(weaponStock:getType(), "Forearm") then
            return true
        else 
            return false
        end
    else 
        return true
    end
end

function GetWeaponShotSound(weapon)
    initializeWeaponTables();
    local weaponScript = weapon:getScriptItem();
    local weaponName = weaponScript:getName();
    if (IsSuppressorAttached(weapon)) then
        return WeaponWithSupressorTable[weaponName];
    else
        return WeaponWithoutSuppressorTable[weaponName];
    end
end

function GetWeaponSupressionLevel(weapon)
    local weaponScript = weapon:getScriptItem();
    local weaponName = weaponScript:getName();
    return WeaponSuppressionLevelTable[weaponName];
end

function SwitchWeaponFlashlight(key)
    if (key == 39) then

        local character = getPlayer();
        if character == nil then
            return
        end
        local equipedWeapon = character:getPrimaryHandItem();
        local weaponClip;
        if (equipedWeapon and instanceof(equipedWeapon, "HandWeapon") and equipedWeapon:isAimedFirearm()) then
            weaponClip = equipedWeapon:getClip();
        end
        
        if (weaponClip and string.find(weaponClip:getType(), "Gunlight")) then 
            if (equipedWeapon:getModData().turnedOn == true) then
                equipedWeapon:getModData().turnedOn = false;
            else
                equipedWeapon:getModData().turnedOn = true;
            end
        end
    end
end

Events.OnKeyPressed.Add(SwitchWeaponFlashlight);
