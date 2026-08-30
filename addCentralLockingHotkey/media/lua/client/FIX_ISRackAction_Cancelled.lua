
require "TimedActions/ISRackFirearm"
-------------------------------------------------------------------------------------------------------------------------------------------------------------
local upperLayer = {}
upperLayer.ISRackFirearm = {}

--if (isKeyDown(42) == true) or (isKeyDown(54) == true)  then player:Say("2") return end

--processSayMessage("1") 
--print("isValid") 

upperLayer.ISRackFirearm.isValid = ISRackFirearm.isValid
function ISRackFirearm:isValid()
	 upperLayer.ISRackFirearm.isValid(self)
	if (isKeyDown(42) or isKeyDown(54)) and (not (isKeyDown(Keyboard.KEY_A) and isKeyDown(Keyboard.KEY_Z) and isKeyDown(Keyboard.KEY_Q) and isKeyDown(Keyboard.KEY_D) and isKeyDown(Keyboard.KEY_S))) then return false end

	return true 
end

