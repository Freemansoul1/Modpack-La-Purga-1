local FasterRacking = function(character, inventoryItem, player)
if SandboxVars.FasterRacking == true then
	if inventoryItem ~= nil then
		if inventoryItem:getStringItemType() == "RangedWeapon" then
			if inventoryItem:getWeaponReloadType() then
				print("It has reloadtype")
			local Reloadtype = inventoryItem:getWeaponReloadType()
				if Reloadtype  == "boltactionnomag" then
					if inventoryItem:getRecoilDelay() > 60 then
					print("Before recoild adjustment")
					inventoryItem:setRecoilDelay(60)
					print("Increased Fire rate")
					else return end
				end
			end
		end
	end
end
end




Events.OnEquipPrimary.Add(FasterRacking)
Events.OnGameStart.Add(function()
	local player = getPlayer()
	FasterRacking(player, player:getPrimaryHandItem())
end)

