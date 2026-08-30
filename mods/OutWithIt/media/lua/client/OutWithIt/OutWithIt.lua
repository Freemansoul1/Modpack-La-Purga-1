OutWithIt = OutWithIt or {}

OutWithIt.throwTypeWindow = 'OutTheWindow'
OutWithIt.throwTypeFence = 'OverFence'

function OutWithIt.getThrowTypeAndTarget(player, object)
	if instanceof(object, 'IsoWindow') then
		if (object:IsOpen() or object:isSmashed()) and not object:isBarricaded() then
			return OutWithIt.throwTypeWindow, object
		end
	elseif instanceof(object, 'IsoThumpable') and not object:isDoor() then
		if object:isWindow() and object:canClimbThrough(player) then
			return OutWithIt.throwTypeWindow, object
		elseif object:isHoppable() and object:canClimbOver(player) then
			return OutWithIt.throwTypeFence, object
		end
	elseif instanceof(object, 'IsoObject') then
		if IsoWindowFrame.isWindowFrame(object) and IsoWindowFrame.canClimbThrough(object, player) and not OutWithIt.hasWindow(object:getSquare()) then
			return OutWithIt.throwTypeWindow, object
		end

		local hoppable = OutWithIt.findHoppable(object:getSquare())
		if hoppable then
			return OutWithIt.throwTypeFence, hoppable
		end
	end
end

function OutWithIt.hasWindow(square)
	local objects = square:getObjects()
	for i = 0, objects:size() - 1 do
		local object = objects:get(i)
		if instanceof(object, 'IsoWindow') then
			return true
		end
	end
end

function OutWithIt.findHoppable(square)
	local objects = square:getObjects()
	for i = 0, objects:size() - 1 do
		local object = objects:get(i)
		if instanceof(object, 'IsoObject') and object:isHoppable() then
			return object
		end
	end
end

function OutWithIt.getDropSquare(player, window)

	local sq1, sq2, selected

	local playerSquare = player:getSquare()
	local px, py = playerSquare:getX(), playerSquare:getY()

	local windowSquare = window:getSquare()
	local wx, wy, wz = windowSquare:getX(), windowSquare:getY(), windowSquare:getZ()

	if window.getNorth and window:getNorth() or window:isNorthHoppable() then
		sq1 = getSquare(wx, wy + 1, wz)
		sq2 = getSquare(wx, wy - 1, wz)
		selected = (py >= wy) and sq2 or sq1
	else
		sq1 = getSquare(wx + 1, wy, wz)
		sq2 = getSquare(wx - 1, wy, wz)
		selected = (px >= wx) and sq2 or sq1
	end

	local x = selected:getX()
	local y = selected:getY()

	for z = selected:getZ(), 0, -1 do
		local floorSquare = getSquare(x, y, z)
		if floorSquare:isSolidFloor() then
			return floorSquare
		end
	end

	error('Unexpected drop square state!')
end

function OutWithIt.onThrow(table, player, target, items)
	if luautils.walkAdjWindowOrDoor(player, target:getSquare(), target) then
		if (type(items) == "table") then
			for _, item in ipairs(items) do
				ISTimedActionQueue.add(ISThrow:new(player, target, item, 50 * (1 + item:getUnequippedWeight())))
			end
		else
			local item = items
			ISTimedActionQueue.add(ISThrow:new(player, target, item, 50 * (1 + item:getEquippedWeight())))
		end
	end
end