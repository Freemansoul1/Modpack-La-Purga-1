-- ISWEARING CLOTHING EVENTS
-- by NinjaWizard

local vadermasktimer = 0;
--local lightByPlayer = {}


-- Wear Clothing Action
local ISWearClothing_perform = ISWearClothing.perform;
function ISWearClothing:perform(...)
    ISWearClothing_perform(self, ...);
local player = getPlayer();

    if self.item:getFullType() == "Base.Wiz_DarthVaderHelmet" then
		print("Testing..WEAR")
	
		player:getModData().VaderMaskIsOn = true
	
	elseif self.item:getFullType() == "Base.Wiz_RomanShield" then
		print("Testing..SHIELD EQUIPED")
	
		player:getModData().FakeShieldEquiped = true
		
	elseif self.item:getFullType() == "Base.Wiz_WWShield" then
		print("Testing..SHIELD EQUIPED")
	
		player:getModData().FakeShieldEquiped = true
		

	
	else
	end

end
 

	
	
	
 
-- Unequip Action
local ISUnequipAction_perform = ISUnequipAction.perform;
function ISUnequipAction:perform(...)
    ISUnequipAction_perform(self, ...);
local player = getPlayer();

    if self.item:getFullType() == "Base.Wiz_DarthVaderHelmet" then
        print("Testing...UNEQUIP")	
		player:getModData().VaderMaskIsOn = false
	
	elseif self.item:getFullType() == "Base.Wiz_RomanShield" then
		print("Testing..SHIELD UNEQUIPED")
	
		player:getModData().FakeShieldEquiped = false
		
	elseif self.item:getFullType() == "Base.Wiz_WWShield" then
		print("Testing..SHIELD UNEQUIPED")
	
		player:getModData().FakeShieldEquiped = false
		

	else	
    end
	
end
 
 

 -- VADER MASK BREATH SOUND
function vadermask_idle()

	local player = getPlayer();

	  --if player:getClothingItem_Head() == "Base.Wiz_DarthVaderHelmet" then
	  
		if player:getModData().VaderMaskIsOn == true then 
			 --print("Ping...")
			 
              vadermasktimer = vadermasktimer - 1;
			if vadermasktimer <= 0 then 
				vadermasktimer = 400;
			end
			if vadermasktimer == 390 then
				getSoundManager():PlayWorldSoundWav('vader_breath', false, getPlayer():getSquare(), 0, 0, 0, false);
			end

			
			
			
		else
		end
		
	--else
	--end
		
end
	
-- Make the current weapon Not Unequip WIP
--local ISUnequipAction_isValid = ISUnequipAction.isValid;
--function ISUnequipAction:isValid(...)
--    if self.item:getFullType() ~= "Base.Wiz_Lightsaber_Luke" then
--    return ISUnequipAction_isValid(self, ...);
--	else
--	end
--end








-- EVENTS
Events.OnPlayerUpdate.Add(vadermask_idle);
Events.OnKeyPressed.Add(WizardClothLight);