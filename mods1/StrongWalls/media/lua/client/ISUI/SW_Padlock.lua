function SW_Padlock (player, context, worldobjects, test)
	local playerObj = getSpecificPlayer(player)
	local playerInv = playerObj:getInventory()
		
	for i,v in ipairs(worldobjects) do
				if instanceof(v, "IsoThumpable") and v:isDoor() and (v:getSprite():getProperties():Is("DoubleDoor")) == false then
					thump = v;            
					if  not v:isLockedByPadlock() and not v:isLockedByKey() and v:getLockedByCode() == 0 then
						padlockThump = v;
					end
					if v:isLockedByPadlock() then
						padlockedThump = v;
					end
					if v:getLockedByCode() > 0 then
						digitalPadlockedThump = v;
					end
					
				end	
	end
end

function ISWorldObjectContextMenu:onSetDigitalCode(button, player, padlock, thumpable)
    local dialog = button.parent
    if button.internal == "OK" and dialog:getCode() ~= 0 then
        player:getInventory():Remove(padlock);
        thumpable:setLockedByCode(dialog:getCode());
        local pdata = getPlayerData(player:getPlayerNum());
        pdata.playerInventory:refreshBackpacks();
        pdata.lootInventory:refreshBackpacks()
		
		if thumpable:isDoor() then
			print("Locked?")
			thumpable:setLockedByKey(true)
			thumpable:setKeyId(dialog:getCode())
			player:playSound("UnlockDoor")
		end
    end
end

function ISWorldObjectContextMenu:onCheckDigitalCode(button, player, padlock, thumpable)
    local dialog = button.parent
    if button.internal == "OK" then
        if thumpable:getLockedByCode() == dialog:getCode() then
            thumpable:setLockedByCode(0);
            player:getInventory():AddItem("Base.CombinationPadlock");
            local pdata = getPlayerData(player:getPlayerNum());
            pdata.playerInventory:refreshBackpacks();
            pdata.lootInventory:refreshBackpacks()
			if thumpable:isDoor() then
				print("Unocked?")
				thumpable:setLockedByKey(false)
				player:playSound("UnlockDoor")
			end
        end
    end
end

Events.OnPreFillWorldObjectContextMenu.Add(SW_Padlock)	