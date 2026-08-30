require('NPCs/MainCreationMethods');


local function AddTraitProfessionItems(_player)

    local player = _player;
    local inv = player:getInventory();

    local hasAddict             = player:HasTrait("ChemJunkie");

end
local function InitChemTraitPlayerData(_player)
    _player:getModData().HoursSinceChem = 0;
    _player:getModData().ChemTemp = 0;
    _player:getModData().ChemPerm = 0;
    _player:getModData().CatVision = 5;
    --if _player:getModData().HoursSinceChem == nil then
        --_player:setModData().HoursSinceChem = 0;
    --end
    --if _player:getModData().ChemTemp == nil then
        --_player:setModData().ChemTemp = 0;
    --end
    --if  _player:getModData().ChemPerm == nil then
        --_player:setModData().ChemPerm = 0;
    --end
end

local function UpdateChemTraitPlayerData( _player)
    if _player:getModData().CatVision == nil then
        _player:getModData().HoursSinceChem = 0;
        _player:getModData().ChemTemp = 0;
        _player:getModData().ChemPerm = 0;
        _player:getModData().CatVision = 5;
    else return
    end
end


local function SetAddictTrait(player)
    local CE = 1;
    if player:HasTrait("ChemExpert") then
        CE = 2;
    end
    if player:getModData().ChemTemp >= 8 * CE then
        player:Say("*Cough* *Cough*");
        local perm = player:getModData().ChemPerm;
        player:getModData().ChemPerm = perm + 1;
        player:getModData().ChemTemp = 0;
        if player:getModData().ChemPerm >= 3 then
            player:getTraits():add("ChemJunkie");
            player:getModData().ChemPerm = 0;
        end
    else return
    end
end

local function SetAddictTime(player)
    if player:getModData().HoursSinceChem >= 8 and player:getModData().ChemTemp > 1 then
        local temp0 = player:getModData().ChemTemp;
        player:getModData().ChemTemp = temp0  - 1;
    end
    if player:getModData().HoursSinceChem >= 48 and player:getModData().ChemPerm > 0 then
        local temp1 = player:getModData().ChemPerm;
        player:getModData().ChemPerm = temp1 - 1;
    end
end

local function HandleOneHourUpdate()
    local player = getPlayer();

    if player:isZombie() then
        return
    end

    player:getModData().HoursSinceChem = player:getModData().HoursSinceChem + 1;
    if player:getModData().CatVision < 5 then
        player:getModData().CatVision = player:getModData().CatVision - 1;
    end
    if not player:HasTrait("ChemJunkie") and not player:isDead() then
        SetAddictTime(player);
    else return
    end
end

local function HandleOnTickUpdate()
    local player = getPlayer();

    if player:isZombie() then
        return
    end

    UpdateChemTraitPlayerData(player)
    if player:getModData().CatVision < 5 then
        if not player:getModData().CatVision then return end
        if player:getModData().CatVision < 1 then
            player:getTraits():remove("NightVision");
        end
    end
    if not player:HasTrait("ChemJunkie") and not player:isDead() and player:getBodyDamage():getHealth() > 2.0 * 4 then
        SetAddictTrait(player);
    else return
    end
end

Events.OnNewGame.Add(AddTraitProfessionItems);
Events.OnNewGame.Add(InitChemTraitPlayerData);
Events.EveryHours.Add(HandleOneHourUpdate);
Events.OnTick.Add(HandleOnTickUpdate)