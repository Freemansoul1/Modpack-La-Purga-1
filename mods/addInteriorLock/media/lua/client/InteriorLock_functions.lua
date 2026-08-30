local interiorLock = {}

-------------------------------------------------------------------------------------------------------------- FUNCTIONS
function interiorLock.forceLock(door)
	if interiorTEST then return end
	if door and not door:getModData().CustomLock then
		--door:getProperties():Set("forceLocked", "true")
		local isLocked = door:isLocked() or door:isLockedByKey() --or door:setLockedByPadlock() or door:setLockedByCode()
		if isLocked and door:getKeyId() == -1 then
			if ZombRand(5) == 1 then
				DebugContextMenu.OnSetDoorKeyIDRandom(nil, door)
			else
				DebugContextMenu.OnSetDoorKeyIDBuilding(nil, door)
			end
		end
		door:getModData().CustomLock = true
		if isClient() then door:transmitModData() end
		--print("forceLock "..tostring(door:getModData().CustomLock))
	end
end
--
--
----------------------------------------------------------------
function interiorLock.replaceDoor(player,door)
	local newDoor = door
	if not door:getModData().interChange then
		local cell = player:getCell()
		--local isLocked = door:isLocked() or door:isLockedByKey() or door:setLockedByPadlock() or door:setLockedByCode()
		local square,healtDoor,key,isLocked,isLockedByKey,north,sprite,mData = door:getSquare(),door:getHealth(),door:getKeyId(),door:isLocked(),door:isLockedByKey(),door:getNorth(),door:getSprite(),door:getModData()
		square:transmitRemoveItemFromSquare(door)
		newDoor = IsoDoor.new(cell, square,sprite,north)
		square:AddSpecialObject(newDoor)
		--print("replaceDoor isLocked ".. tostring(isLocked))
		--print("replaceDoor isLockedByKey ".. tostring(isLockedByKey))
		newDoor:setLocked(isLocked)
		newDoor:setLockedByKey(isLockedByKey)
		newDoor:setHealth(healtDoor)
		newDoor:setKeyId(key)
		local NewDoorModData = newDoor:getModData()
		if mData then
			for i,v in pairs(mData) do
           		NewDoorModData[tostring(i)] = v
           	end
        end
        newDoor:getModData()["interChange"] = true
		newDoor:getModData().CustomLock = true

		if isClient() then newDoor:transmitCompleteItemToServer() end

	end
	return newDoor
	--cell:setDrag(nil, self.character:getPlayerNum())	
end
----------------------------------------------------------------
function interiorLock.isInsideDoor(player,cell,door)
	local insidePlayer = not player:getCurrentSquare():Is(IsoFlagType.exterior)
	local insideDoor
	if insidePlayer then  
		local x,y,z = player:getX(),player:getY(),player:getZ()
		local sameSquare = door:getSquare() == player:getSquare()
		local doorNorth = door:getNorth()
		local testSquare
		if 			doorNorth  and 		sameSquare then testSquare = cell:getGridSquare(x, y-1, z)
		elseif 		doorNorth  and not 	sameSquare then testSquare = cell:getGridSquare(x, y+1, z)
		elseif not 	doorNorth  and 		sameSquare then testSquare = cell:getGridSquare(x-1, y, z)
		elseif not 	doorNorth  and not 	sameSquare then testSquare = cell:getGridSquare(x+1, y, z)
		end
		--print("isInsideDoor"..tostring(not testSquare:Is(IsoFlagType.exterior)))
		return not testSquare:Is(IsoFlagType.exterior)
	end
end
----------------------------------------------------------------
function interiorLock.getDoorsAdjacent()
	local player = getSpecificPlayer(0)
	if not player or player:getVehicle() then return end 
	local cell = player:getCell()
	local square = player:getSquare()
	local x,y,z = square:getX(),square:getY(),square:getZ()
	for xx=x-1,x+1 do
		for yy=y-1,y+1 do  
			local sq = cell:getGridSquare(xx,yy,z)
			if sq then
				--local doorTrans = IsoObjectPicker.Instance:PickDoor(x, y, true)
    			--local objs = sq:getObjects()
				local objs = sq:getSpecialObjects()
				for i=0,objs:size()-1  do	-- --	for i = 0, objs:size() - 1, 1				
					local obj = objs:get(i)
					if (instanceof(obj, "IsoDoor") or (instanceof(obj, "IsoThumpable") and obj:isDoor())) then
						interiorLock.forceLock(obj)
					end
				end
			end
		end
	end		
end

-------------------------------------------------------------------------------------------------------------- ON KEY PRESSED
function interiorLock.OnKeyKeepPressed() 
	if isKeyDown(getCore():getKey("Interact")) then 
		interiorLock.getDoorsAdjacent() 
	end 
end
Events.OnKeyKeepPressed.Add(interiorLock.OnKeyKeepPressed)

-------------------------------------------------------------------------------------------------------------- ON MOUSE CLIC DOWN
function interiorLock.OnMouseDown(object, xMouse, yMouse)
    if (instanceof(object, "IsoDoor") or (instanceof(object, "IsoThumpable") and object:isDoor())) then  
        interiorLock.forceLock(object)
    end
end
Events.OnObjectLeftMouseButtonDown.Add(interiorLock.OnMouseDown);
Events.OnObjectRightMouseButtonDown.Add(interiorLock.OnMouseDown);

Events.OnGameBoot.Add(function()
	-------------------------------------------------------------------------------------------------------------- ON LOCK DOOR
	require "TimedActions/ISLockDoor"

	interiorLock.ISLockDoor_isValid = ISLockDoor.isValid
	function ISLockDoor:isValid()
		local keyID = instanceof(self.door, "IsoDoor") and self.door:checkKeyId() or self.door:getKeyId()
		local haveKey = self.character:getInventory():haveThisKeyId(keyID)
		self.cell = self.cell or self.character:getCell()
		if haveKey then
			--print("ISLockDoor:isValid 1")
			return true
		elseif SandboxVars.interiorLock.KeepMainDoorLockableWithoutKey and not interiorLock.isInsideDoor(self.character,self.cell,self.door) then 
			--print("ISLockDoor:isValid 2")
			return not self.character:getCurrentSquare():Is(IsoFlagType.exterior)--interiorLock.ISLockDoor_isValid(self)  
		else
			--print("ISLockDoor:isValid 3")
			self.character:getEmitter():playSound("DoorIsLocked") 
			return false
		end
	end
	function interiorLock.setParam(player,door)
		local door = interiorLock.replaceDoor(player,door)
		--interiorLock.forceLock(door)
	end
	----------------------------------------------------------------
	interiorLock.ISLockDoor_perform = ISLockDoor.perform
	function ISLockDoor:perform()
		interiorLock.ISLockDoor_perform(self)
		if not self.door:getModData().interChange or not self.door:getModData().CustomLock then
			local specialDoor
			local doubleDoorObjects = buildUtil.getDoubleDoorObjects(self.door)
			for i=1,#doubleDoorObjects do
				interiorLock.setParam(self.character,doubleDoorObjects[i])
				specialDoor = true
			end
			local garageDoorObjects = buildUtil.getGarageDoorObjects(self.door)
			for i=1,#garageDoorObjects do
				interiorLock.setParam(self.character,garageDoorObjects[i])
				specialDoor = true
			end
			if not specialDoor then interiorLock.setParam(self.character,self.door) end
		end
	end
	-------------------------------------------------------------------------------------------------------------- ON OPEN DOOR
	require "TimedActions/ISOpenCloseDoor"	

	interiorLock.ISOpenCloseDoor_isValid = ISOpenCloseDoor.isValid
	function ISOpenCloseDoor:isValid()
		interiorLock.forceLock(self.item) 
		return interiorLock.ISOpenCloseDoor_isValid(self)
	end
	-------------------------------------------------------------------------------------------------------------- ON WALK
	require "TimedActions/ISWalkToTimedAction"

	interiorLock.ISWalkToTimedAction_update = ISWalkToTimedAction.update  
	function ISWalkToTimedAction:update()   
	    interiorLock.ISWalkToTimedAction_update(self) 
	    interiorLock.getDoorsAdjacent()
	end

end)

return interiorLock