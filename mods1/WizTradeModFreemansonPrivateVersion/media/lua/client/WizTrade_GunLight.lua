-------------------------------------------------------------------------
--  GUN WEAPON LIGHT by NinjaWizard						
--------------------------------------------------------------------------

local function WizardWeaponLight(key)
    local player = getPlayer()  
	
    if key == Keyboard.KEY_INSERT  then  -- activate light
      
		if getPlayer():getPrimaryHandItem() then         -- check if the player have a item on his hand in the first place
      
			if player:getPrimaryHandItem():getType() == "Wiz_RobocopGun" then -- this is needed or the flashlight itself on the hand can crash
	    
				if (player:getPrimaryHandItem():getCanon()) and (string.find(player:getPrimaryHandItem():getCanon():getType(), "Wiz_RobocopGun_Light")) then
	  
					getSoundManager():PlayWorldSoundWav('light_tick', false, player:getSquare(), 0, 0, 0, true);
		
					-- LIGHT ON/OFF
					if player:getPrimaryHandItem():getModData().LightIsOff == true then   
						player:getPrimaryHandItem():getModData().LightIsOff = false
						player:Say("Gun Light On")
					else 	
						player:getPrimaryHandItem():getModData().LightIsOff = true
						player:Say("Gun Light Off")
					end
		

				end
			
			
				
			elseif player:getPrimaryHandItem():getType() == "Wiz_WaltherPPK" then -- this is needed or the flashlight itself on the hand can crash
			
				if (player:getPrimaryHandItem():getScope()) and (string.find(player:getPrimaryHandItem():getScope():getType(), "Wiz_SmallPistol_Light")) then
	  
					getSoundManager():PlayWorldSoundWav('light_tick', false, player:getSquare(), 0, 0, 0, true);
		
					-- LIGHT ON/OFF
					if player:getPrimaryHandItem():getModData().LightIsOff == true then   
						player:getPrimaryHandItem():getModData().LightIsOff = false
						player:Say("Gun Light On")
					else 	
						player:getPrimaryHandItem():getModData().LightIsOff = true
						player:Say("Gun Light Off")
					end
		

				end
				
			elseif player:getPrimaryHandItem():getType() == "Wiz_Mp5" then -- this is needed or the flashlight itself on the hand can crash
			
				if (player:getPrimaryHandItem():getScope()) and (string.find(player:getPrimaryHandItem():getScope():getType(), "Wiz_SmallPistol_Light")) then
	  
					getSoundManager():PlayWorldSoundWav('light_tick', false, player:getSquare(), 0, 0, 0, true);
		
					-- LIGHT ON/OFF
					if player:getPrimaryHandItem():getModData().LightIsOff == true then   
						player:getPrimaryHandItem():getModData().LightIsOff = false
						player:Say("Gun Light On")
					else 	
						player:getPrimaryHandItem():getModData().LightIsOff = true
						player:Say("Gun Light Off")
					end
		

				end
				
			else
			end
		else	   
		end
	   
    end
 end




local function WizardWeaponLightBeam()
	local player = getPlayer() 
	
		if player:getPrimaryHandItem() then        -- check if the player have a item on his hand in the first place
		
			--if (player:getPrimaryHandItem():getCanon()) and (string.find(player:getPrimaryHandItem():getCanon():getType(), "Wiz_RobocopGun_Light")) then
			
				if player:getPrimaryHandItem():getModData().LightIsOff == false then 

					if player:isAiming() then                                   
						player:getPrimaryHandItem():setTorchCone(true)
						player:getPrimaryHandItem():setLightDistance(10)
						player:getPrimaryHandItem():setLightStrength(0.8)
					else
						player:getPrimaryHandItem():setTorchCone(false)
						player:getPrimaryHandItem():setLightDistance(3)
						player:getPrimaryHandItem():setLightStrength(0.2)
					end
		
				elseif player:getPrimaryHandItem():getModData().LightIsOff == true then

					player:getPrimaryHandItem():setTorchCone(false)
					player:getPrimaryHandItem():setLightDistance(0)
					player:getPrimaryHandItem():setLightStrength(0)
				end
			
			--end
		else
		end
end



Events.OnKeyPressed.Add(WizardWeaponLight)
Events.OnPlayerUpdate.Add(WizardWeaponLightBeam)