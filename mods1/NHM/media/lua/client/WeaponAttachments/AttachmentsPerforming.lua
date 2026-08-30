require "TimedActions/ISReloadWeaponAction"

Hook.Attack.Remove(ISReloadWeaponAction.attackHook);
local original_attackHook = ISReloadWeaponAction.attackHook
ISReloadWeaponAction.attackHook = function(character, chargeDelta, weapon)
	if weapon:isRanged() and not IsHandguardAttached(weapon) then
        character:DoAttack(0);
		character:setRangedWeaponEmpty(true);
	else
        original_attackHook(character, chargeDelta, weapon);
	end
end

Events.OnWeaponSwingHitPoint.Remove(ISReloadWeaponAction.onShoot);
local original_onShoot = ISReloadWeaponAction.onShoot
ISReloadWeaponAction.onShoot = function(player, weapon)
    if not weapon:isRanged() then 
        return; 
    end
    if weapon:isRanged() and not IsHandguardAttached(weapon) then
        return;
    end
		original_onShoot(player, weapon);
end

--local function performEffectOnWeapon(player, weapon)
--    if (not weapon) or (not instanceof(weapon, "HandWeapon")) or (not weapon:isRanged()) or (not player) then
--        return
--    end
--    local weaponScriptItem	= weapon:getScriptItem()
--    local weaponSoundLevel	= weaponScriptItem:getSoundVolume()
--    local weaponSoundRadiusLevel	= weaponScriptItem:getSoundRadius()
--    local weaponDefaultSupressionLevel	= 1
--    local weaponSwingSound	= weaponScriptItem:getSwingSound()
--    if IsSuppressorAttached(weapon) then
--        weaponSwingSound = GetWeaponShotSound(weapon);
--        weaponDefaultSupressionLevel = GetWeaponSupressionLevel(weapon);
--        if (weaponDefaultSupressionLevel) then
--            weaponSoundLevel = weaponSoundLevel * weaponDefaultSupressionLevel;
--            weaponSoundRadiusLevel = weaponSoundRadiusLevel * weaponDefaultSupressionLevel;
--        end
--    end
--    weapon:setSoundRadius(weaponSoundRadiusLevel);
--	weapon:setSwingSound(weaponSwingSound);
--    weapon:setSoundVolume(weaponSoundLevel);
--end
--
--Events.OnEquipPrimary.Add(performEffectOnWeapon);

Events.OnWeaponSwingHitPoint.Add(ISReloadWeaponAction.onShoot);
Hook.Attack.Add(ISReloadWeaponAction.attackHook);