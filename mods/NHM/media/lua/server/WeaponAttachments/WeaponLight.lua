function ThrowLightFromWeapon(player)
    if player == nil then
        return
    end
    local equipedWeapon = player:getPrimaryHandItem();
    local weaponClip;
    if (equipedWeapon and instanceof(equipedWeapon, "HandWeapon") and equipedWeapon:isAimedFirearm()) then
        weaponClip = equipedWeapon:getClip();
    end

    if (weaponClip and string.find(weaponClip:getType(), "Gunlight") and equipedWeapon:getModData().turnedOn == true) then
        if player:isAiming() then
            equipedWeapon:setTorchCone(true);
            if (weaponClip:getType() == "Gunlight1") then
                equipedWeapon:setLightDistance(8);
                equipedWeapon:setLightStrength(1.4);
            elseif (weaponClip:getType() == "Gunlight2") then
                equipedWeapon:setLightDistance(15);
                equipedWeapon:setLightStrength(1.1);
            end
        else
            equipedWeapon:setTorchCone(false);
            if (weaponClip:getType() == "Gunlight1") then
                equipedWeapon:setLightDistance(2);
                equipedWeapon:setLightStrength(0.6);
            elseif (weaponClip:getType() == "Gunlight2") then
                equipedWeapon:setLightDistance(2.5);
                equipedWeapon:setLightStrength(1.1);
            end
        end
    elseif (equipedWeapon and instanceof(equipedWeapon, "HandWeapon") and equipedWeapon:isAimedFirearm()) then
        equipedWeapon:setTorchCone(false);
        equipedWeapon:setLightDistance(0);
        equipedWeapon:setLightStrength(0);
    end
end

Events.OnPlayerUpdate.Add(ThrowLightFromWeapon);