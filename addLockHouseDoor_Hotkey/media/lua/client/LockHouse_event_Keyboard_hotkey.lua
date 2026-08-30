local function getOutsideInsideDoor(playerObj,door)
		local cell = playerObj:getCell() 
		local x = playerObj:getX()
		local y = playerObj:getY()
		local z = playerObj:getZ()
		local sameSquare = (door:getSquare() == playerObj:getSquare())
		local doorNorth = (door:getNorth())
		local playerInside = not playerObj:getCurrentSquare():Is(IsoFlagType.exterior)
		local insideDoor = false
	
		if playerInside then  
				local testSquare = nil
				if 					doorNorth  and 	 		sameSquare 	then testSquare = cell:getGridSquare(x, y-1, z)
				elseif 			doorNorth  and (not sameSquare) then testSquare = cell:getGridSquare(x, y+1, z)
				elseif (not doorNorth) and 			sameSquare 	then testSquare = cell:getGridSquare(x-1, y, z)
				elseif (not doorNorth) and (not sameSquare) then testSquare = cell:getGridSquare(x+1, y, z)
				end

				return testSquare:Is(IsoFlagType.exterior)
		end
end
-----------------------------------------------------------------------------------------------------------------------------------------	
local function LockHouseDoor()
		local var = {}
		var.lockHouseCounter = 0	
		while var.lockHouseCounter < 2 do
		-----------------------------------------------------------------------------------------------------------------------------------------						
				local playerObj = getSpecificPlayer(0)
				local vehicle = playerObj:getVehicle()
				if vehicle then return end
		    local currentGS = playerObj:getCurrentSquare()
		    local dir = playerObj:getDir()
				local cx = currentGS:getX()
				local cy = currentGS:getY()
				local cz = currentGS:getZ()
				x1 = 0 - var.lockHouseCounter-------------------LOOK WEST SIDE------------------------------------
				if dir == IsoDirections.NW or dir == IsoDirections.W or dir == IsoDirections.SW then x1 = -1 + var.lockHouseCounter end
				x2 = 0 + var.lockHouseCounter-------------------LOOK EAST SIDE------------------------------------
				if dir == IsoDirections.NE or dir == IsoDirections.E or dir == IsoDirections.SE then x2 = 1 - var.lockHouseCounter end
				y1 = 0 - var.lockHouseCounter-------------------LOOK NORD SIDE------------------------------------
				if dir == IsoDirections.NW or dir == IsoDirections.N or dir == IsoDirections.NE then y1 = -1 + var.lockHouseCounter end
				y2 = 0 + var.lockHouseCounter-------------------LOOK SUD SIDE------------------------------------
				if dir == IsoDirections.SW or dir == IsoDirections.S or dir == IsoDirections.SE then y2 = 1 - var.lockHouseCounter end
				---------------------------------------------------------------------------------------------------------------------------------		
				for x = cx +x1, cx +x2 do
						for y = cy +y1, cy +y2 do
						-----------------------------------------------------------------------------------------------------------------------------	
								local square = getCell():getGridSquare(x, y, cz)
								if square then
										local objs = square:getObjects()
										local objs_size = objs:size()
										if objs_size > 0 then
												for i = 0, objs_size - 1 do 
														local obj = objs:get(i)
														if instanceof(obj, "IsoDoor") or (instanceof(obj, "IsoThumpable") and obj:isDoor()) then
																local keyId = obj:getKeyId()
																local outsideDoor = getOutsideInsideDoor(playerObj,obj)
																local locked = obj:isLocked()
																if locked then 
																		getSoundManager():PlayWorldSound("DoorIsLocked", obj:getSquare(), 0, 10, 10.0, false);
																elseif outsideDoor or playerObj:getInventory():haveThisKeyId(keyId) then 
																		if obj:IsOpen() then obj:ToggleDoor(playerObj) end
																		if not obj:isLocked() then
																				ISTimedActionQueue.add(ISLockDoor:new(playerObj, obj, true)) 
																		end
																end
																return   
														end
												end
										end
								end
						end
				end
				var.lockHouseCounter = var.lockHouseCounter +1
		end
end
-----------------------------------------------------------------------------------------------------------------------------------------
local KEY_DATA = {
  key = Keyboard.KEY_X,
  name = "lockDoorHotkey",  
}
local function HotKey(_key)
		if (isKeyDown(42) or isKeyDown(54)) and _key == KEY_DATA.key and (not (isKeyDown(Keyboard.KEY_A) and isKeyDown(Keyboard.KEY_Z) and isKeyDown(Keyboard.KEY_Q) and isKeyDown(Keyboard.KEY_D) and isKeyDown(Keyboard.KEY_S))) then
    		LockHouseDoor()
		end
end
Events.OnKeyPressed.Add(HotKey)
-----------------------------------------------------------------------------------------------------------------------------------------		

