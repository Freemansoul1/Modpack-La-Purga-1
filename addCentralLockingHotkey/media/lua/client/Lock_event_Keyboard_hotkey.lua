
local KEY_DATA = {
  key = Keyboard.KEY_X,
  name = "lockVehicleDoorHotkey",  
}
--if ModOptions and ModOptions.AddKeyBinding then
--	ModOptions:AddKeyBinding("lockVehicleDoorHotkey",KEY_DATA)
--end
---------------------------------------------------------------------------------------------------------------------------------------------------------
function LockVehicleDoor_HotKey(_key)--()

	if (isKeyDown(42) or isKeyDown(54)) and _key == KEY_DATA.key and (not (isKeyDown(Keyboard.KEY_A) and isKeyDown(Keyboard.KEY_Z) and isKeyDown(Keyboard.KEY_Q) and isKeyDown(Keyboard.KEY_D) and isKeyDown(Keyboard.KEY_S))) then -- LSHIFT/RSHIFT, see lwjgl codes if _key == KEY_DATA.key then

    local playerObj = getSpecificPlayer(0)
    
	    local vehicle = playerObj:getUseableVehicle()

	    if vehicle then
		    local doorPart = vehicle:getUseablePart(playerObj)
			if doorPart and doorPart:getDoor() and doorPart:getInventoryItem() then
				
				if vehicle:canUnlockDoor(doorPart, playerObj) then
					ISTimedActionQueue.add(CentralizedUnLockVehicleDoor:new(playerObj, doorPart,vehicle))
				elseif vehicle:canLockDoor(doorPart, playerObj) then
					ISTimedActionQueue.add(CentralizedLockVehicleDoor:new(playerObj, doorPart,vehicle))
				end
			end
		end
	end 	
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------
Events.OnKeyPressed.Add(LockVehicleDoor_HotKey)
