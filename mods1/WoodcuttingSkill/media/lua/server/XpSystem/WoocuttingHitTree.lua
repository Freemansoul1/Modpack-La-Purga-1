


local function addWoodcuttingXP(character, handWeapon)
	if handWeapon and handWeapon:getType() ~= "BareHands" then
		if handWeapon:getType() == "Axe" then
			character:getXp():AddXP(Perks.Woodcutting, 0.2*Woodcutting.Settings.xpMultiplier)
		else
	    	character:getXp():AddXP(Perks.Woodcutting, 0.1*Woodcutting.Settings.xpMultiplier)
		end
	end
end

Events.OnWeaponHitTree.Add(addWoodcuttingXP)