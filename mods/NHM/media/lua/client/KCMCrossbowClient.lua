local function shootCrossbow(player,item)
	if item:getType() == "Bow" or item:getType() == "CBow" or item:getType() == "RBow" then
		if item:getCondition() == 1 then
		--	item:setName("Crossbow (String Snapped)");
		--	item:setCondition(2);
		--	player:Say("string snapped");
		--	if self.gun:getType() == "CrossbowStrungString" then self.gun:setWeaponSprite("LactoseCrossbow.CrossbowSnappedString"); end
		--	if self.gun:getType() == "CrossbowStrungNylon" or self.gun:getType() == "CrossbowStrungSteel" then self.gun:setWeaponSprite("LactoseCrossbow.CrossbowSnappedNylon"); end
		--	if self.gun:getType() == "ModernCrossbowStrungSteel" or self.gun:getType() == "ModernCrossbowStrungNylon" or self.gun:getType() == "ModernCrossbowStrungString" then self.gun:setWeaponSprite("LactoseCrossbow.ModernCrossbowUnstrung"); end
			player:resetEquippedHandsModels();
			--item:setIcon("LactoseCrossbow.CrossbowUnstrung");	--returns an error message
		end
	end
end

local function KCMOnEquiPrimary(player,item)	
	if item ~= nil then  	
		local itemType = item:getType();
		if itemType == "Bow" or itemType == "CBow" or itemType == "RBow" then
			if item:getCurrentAmmoCount() > 0 then
				if item:getType() == "Bow" then item:setWeaponSprite("Base.Bow3"); end
				if item:getType() == "CBow" then item:setWeaponSprite("Base.CBow3"); end
				if item:getType() == "RBow" then item:setWeaponSprite("Base.RBow3"); end
				player:resetEquippedHandsModels();
			end
		end
	end
end

local function KCMOnLoad()
	local player = getPlayer();	
	local item = player:getPrimaryHandItem();
	if item ~= nil then  	
		local itemType = item:getType();
		if itemType == "Bow" or itemType == "CBow" or itemType == "RBow" then
			if item:getCurrentAmmoCount() > 0 then
				if item:getType() == "Bow" then item:setWeaponSprite("Base.Bow3"); end
				if item:getType() == "CBow" then item:setWeaponSprite("Base.CBow3"); end
				if item:getType() == "RBow" then item:setWeaponSprite("Base.RBow3"); end
				player:resetEquippedHandsModels();
			end
		end
	end
	local modData = player:getModData();
end







--------------------------------------------------------
Events.OnPressReloadButton.Remove(ISReloadWeaponAction.OnPressReloadButton);
local original_OnPressReloadButton = ISReloadWeaponAction.OnPressReloadButton
-- Called when pressing reload button when not already reloading, only called when you have an equipped weapon to reload (with available bullets or clip)
ISReloadWeaponAction.OnPressReloadButton = function(player, gun)
	if gun:getType() == "Bow" or gun:getType() == "CBow" or gun:getType() == "RBow" then
		if gun:getName() ~= "Crossbow (String Snapped)" then
			-- If you press reloading while loading bullets, we stop and rack
			if player:getVariableBoolean("isLoading") then
				ISTimedActionQueue.clear(player);
				ISTimedActionQueue.add(ISKCMReloadCrossbowAction:new(player, gun, true));
			else
				-- if nothing can be loaded in we'll check to insert bullets into mags
				ISKCMReloadCrossbowAction.checkMagazines(player, gun)
				ISTimedActionQueue.add(ISKCMReloadCrossbowAction:new(player, gun, false));
			end
		end
	else
		original_OnPressReloadButton(player, gun);
	end
end

Hook.Attack.Remove(ISReloadWeaponAction.attackHook);
local original_attackHook = ISReloadWeaponAction.attackHook
-- can we attack?
-- need a chambered round
ISReloadWeaponAction.attackHook = function(character, chargeDelta, weapon)
	if weapon:getType() == "Bow" or weapon:getType() == "CBow" or weapon:getType() == "RBow" then
		ISTimedActionQueue.clear(character)
		if character:isAttackStarted() then return; end
		if weapon:isRanged() then
			if ISKCMReloadCrossbowAction.canShoot(weapon) then
				character:playSound(weapon:getSwingSound());
				AddWorldSound(character, weapon:getSoundRadius(), weapon:getSoundVolume());
				character:DoAttack(0);
			else
				character:DoAttack(0);
				character:setRangedWeaponEmpty(true);
			end
		else
			ISTimedActionQueue.clear(character)
			if(chargeDelta == nil) then
				character:DoAttack(0);
			else
				character:DoAttack(chargeDelta);
			end
		end
	else
		original_attackHook(character, chargeDelta, weapon);
	end
end

Events.OnWeaponSwingHitPoint.Remove(ISReloadWeaponAction.onShoot);
local original_onShoot = ISReloadWeaponAction.onShoot
-- shoot shoot bang bang
-- handle ammo removal, new chamber & jam chance
ISReloadWeaponAction.onShoot = function(player, weapon)
	if not weapon:isRanged() then return; end
	if weapon:getType() == "Bow" or weapon:getType() == "CBow" or weapon:getType() == "RBow" then
		if weapon:haveChamber() then
			weapon:setRoundChambered(false);
		end
		-- remove ammo, add one to chamber if we still have some
		if weapon:getCurrentAmmoCount() >= weapon:getAmmoPerShoot() then
			if weapon:haveChamber() then
				weapon:setRoundChambered(true);
			end
			weapon:setCurrentAmmoCount(weapon:getCurrentAmmoCount() - weapon:getAmmoPerShoot())
		end
		if weapon:isRackAfterShoot() then -- shotgun need to be rack after each shot to rechamber round
			player:setVariable("RackWeapon", weapon:getWeaponReloadType());
		end
		if weapon:getType() == "Bow" then weapon:setWeaponSprite("Base.Bow"); end
		if weapon:getType() == "CBow" then weapon:setWeaponSprite("Base.CBow"); end
		if weapon:getType() == "RBow" then weapon:setWeaponSprite("Base.RBow"); end
		player:resetEquippedHandsModels();
	else
		original_onShoot(player, weapon);
	end
end

Events.OnWeaponSwingHitPoint.Remove(ISReloadWeaponAction.OnPressRackButton);
local original_OnPressRackButton = ISReloadWeaponAction.OnPressRackButton
-- Called when pressing rack (if you rack while having a clip/bullets, we simply remove it and don't reload a new one)
ISReloadWeaponAction.OnPressRackButton = function(player, gun)
	if gun:getType() == "Bow" or gun:getType() == "CBow" or gun:getType() == "RBow" then
		-- if you press rack while loading bullets, we stop and rack
		if player:getVariableBoolean("isLoading") and not gun:isRoundChambered() then
			ISTimedActionQueue.clear(player);
		end
		ISTimedActionQueue.add(ISKCMReloadCrossbowAction:new(player, gun, true));
	else
		original_OnPressRackButton(player, gun);
	end
end

Events.OnPressReloadButton.Add(ISReloadWeaponAction.OnPressReloadButton);
Events.OnWeaponSwingHitPoint.Add(ISReloadWeaponAction.onShoot);
Hook.Attack.Add(ISReloadWeaponAction.attackHook);
--------------------------------------------------------


Events.OnZombieDead.Add(KCMOnZombieDead);
Events.OnLoad.Add(KCMOnLoad);
Events.OnWeaponSwingHitPoint.Add(shootCrossbow);
Events.OnWeaponHitCharacter.Add(hitCrossbow);
Events.OnEquipPrimary.Add(KCMOnEquiPrimary);
Events.OnCreateSurvivor.Add(KCMOnCreateSurvivor);