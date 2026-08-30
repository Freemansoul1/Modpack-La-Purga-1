-- On weapon hit by Ninjawizard

function WizSyringeHitZombie()

	local player = getPlayer()    
	local inv = player:getInventory();
	
	if getPlayer():getPrimaryHandItem() then 
	
		if player:getPrimaryHandItem():getType() == "Wiz_SyringeEmpty" then
			getSoundManager():PlayWorldSoundWav('IcePickBreak', false, player:getSquare(), 0, 0, 0, true);
			player:setPrimaryHandItem(nil);
			inv:Remove("Wiz_SyringeEmpty");
			inv:AddItem("Wiz_SyringeBlood_zombie");
		end
	else
	end
end

Events.OnWeaponHitCharacter.Add(WizSyringeHitZombie);
