-------------------------------------------------------------------------
--  ON EQUIPED fire-once or tag events by NinjaWizard						
--------------------------------------------------------------------------

local function wizEquiped()
    local player = getPlayer()  
	
		if getPlayer():getPrimaryHandItem() then         
      
			if player:getPrimaryHandItem():getType() == "Wiz_TOSComunicator_Off" then 
	    

					getSoundManager():PlayWorldSoundWav('TOS_comunicator1', false, player:getSquare(), 0, 0, 0, true);
		
					
			end
		else
		end
			
		--if getPlayer():getSecondaryHandItem() then 
		
		--	if player:getSecondaryHandItem():getType() == "Wiz_TOSComunicator_Off" then 
	    

					--getSoundManager():PlayWorldSoundWav('TOS_comunicator1', false, player:getSquare(), 0, 0, 0, true);
		
		--	end
		--else		
		--end
		
		
	   
end
 


Events.OnEquipPrimary.Add(wizEquiped)



-- Prevent Equip secondary when shield is equiped
local function wizShieldOcupy ()
	local player = getPlayer()

		if player:getModData().FakeShieldEquiped == true then 
		player:setSecondaryHandItem(nil);
		else
	end
end
Events.OnEquipSecondary.Add(wizShieldOcupy)