local Stairs = {}

Stairs.topOfStairs = 'TopOfStairs'

function Stairs.getStairsObject(square)
	local objects = square:getObjects()
	for i = 0, objects:size() - 1 do
		local object = objects:get(i)
		local sprite = object:getSprite()
		if sprite then
			local prop = sprite:getProperties()
			if prop:Is(IsoFlagType.climbSheetN) or prop:Is(IsoFlagType.climbSheetS) or prop:Is(IsoFlagType.climbSheetE) or prop:Is(IsoFlagType.climbSheetW) then
				return object
			end
		end
	end
end

function Stairs.setFlags(square, sprite, flag)
	sprite:getProperties():Set(flag)
	square:getProperties():Set(flag)
end

function Stairs.unsetFlags(square, sprite, flag)
	sprite:getProperties():UnSet(flag)
	square:getProperties():UnSet(flag)
end

function Stairs.setTopOfStairsFlags(square, sprite, north)

	if north then
		Stairs.setFlags(square, sprite, IsoFlagType.climbSheetTopN)
		Stairs.setFlags(square, sprite, IsoFlagType.HoppableN)
	else
		Stairs.setFlags(square, sprite, IsoFlagType.climbSheetTopW)
		Stairs.setFlags(square, sprite, IsoFlagType.HoppableW)
	end
end

function Stairs.addTopOfStairs(square, north)

	local props = square:getProperties()
	if props:Is(IsoFlagType.WallN) or props:Is(IsoFlagType.WallW) or props:Is(IsoFlagType.WallNW) then
		return
	end

	local objects = square:getObjects()
	for i = 0, objects:size() - 1 do
		local object = objects:get(i)
		local name = object:getName()
		if name == Stairs.topOfStairs then
			Stairs.setTopOfStairsFlags(square, object:getSprite(), north)
			return
		end
	end

	local sprite = IsoSprite.new()
	Stairs.setTopOfStairsFlags(square, sprite, north)
	object = IsoObject.new(getCell(), square, sprite)
	object:setName(Stairs.topOfStairs)
	square:transmitAddObjectToSquare(object, -1)
end

function Stairs.removeTopOfStairs(square)

	local x = square:getX()
	local y = square:getY()

	for z = square:getZ() + 1, 8 do
		local aboveSquare = getSquare(x, y, z)
		if not aboveSquare then
			return
		end
		local objects = aboveSquare:getObjects()
		for i = 0, objects:size() - 1 do
			local object = objects:get(i)
			local name = object:getName()
			if name == Stairs.topOfStairs then
				aboveSquare:transmitRemoveItemFromSquare(object)
				return
			end
		end
	end
end

function Stairs.makeStairsClimbable(square, north)

	local x, y = square:getX(), square:getY()

	local topObject = nil
	local topSquare = square
	for z = square:getZ(), 8 do

		local aboveSquare = getSquare(x, y, z + 1)
		if not aboveSquare then
			return
		end
		local object = Stairs.getStairsObject(aboveSquare)
		if not object then
			Stairs.addTopOfStairs(aboveSquare, north)
			break
		end
	end
end

function Stairs.makeStairsClimbableFromTop(square)

	local x = square:getX()
	local y = square:getY()
	local z = square:getZ() - 1

	local belowSquare = getSquare(x, y, z)
	if belowSquare then
		Stairs.makeStairsClimbableFromBottom(getSquare(x - 1, y,     z))
		Stairs.makeStairsClimbableFromBottom(getSquare(x + 1, y,     z))
		Stairs.makeStairsClimbableFromBottom(getSquare(x,     y - 1, z))
		Stairs.makeStairsClimbableFromBottom(getSquare(x,     y + 1, z))
	end
end

function Stairs.makeStairsClimbableFromBottom(square)

	if not square then
		return
	end

	local objects = square:getObjects()
	for i = 0, objects:size() - 1 do
		local object = objects:get(i)
		local sprite = object:getSprite()
		if sprite then
			local prop = sprite:getProperties()
			if prop:Is(IsoFlagType.climbSheetN) then
				Stairs.makeStairsClimbable(square, true)
				break
			elseif prop:Is(IsoFlagType.climbSheetW) then
				Stairs.makeStairsClimbable(square, false)
				break
			end
		end
	end
end

function Stairs.OnKeyPressed(key)
    if key == Keyboard.KEY_E then
		local square = getPlayer():getSquare()
		Stairs.makeStairsClimbableFromTop(square)
		Stairs.makeStairsClimbableFromBottom(square)
	end
end

Events.OnKeyPressed.Add(Stairs.OnKeyPressed)

-- Some tiles for stairs are missing the proper flags to
-- make them climbable so we add the missing flags here.

Stairs.tileFlags = {}
Stairs.tileFlags.location_sewer_01_32    = IsoFlagType.climbSheetW
Stairs.tileFlags.location_sewer_01_33    = IsoFlagType.climbSheetN
Stairs.tileFlags.industry_railroad_05_20 = IsoFlagType.climbSheetW
Stairs.tileFlags.industry_railroad_05_21 = IsoFlagType.climbSheetN
Stairs.tileFlags.industry_railroad_05_36 = IsoFlagType.climbSheetW
Stairs.tileFlags.industry_railroad_05_37 = IsoFlagType.climbSheetN

Stairs.holeTiles = {}
Stairs.holeTiles.floors_interior_carpet_01_24 = true

Stairs.poleTiles = {}
Stairs.poleTiles.recreational_sports_01_32 = true
Stairs.poleTiles.recreational_sports_01_33 = true

function Stairs.LoadGridsquare(square)

	local objects = square:getObjects()
	for i = 0, objects:size() - 1 do

		local sprite = objects:get(i):getSprite()
		if sprite then
			local name = sprite:getName()
			if Stairs.tileFlags[name] then
				Stairs.setFlags(square, sprite, Stairs.tileFlags[name])
			elseif Stairs.holeTiles[name] then
				Stairs.setFlags(square, sprite, IsoFlagType.HoppableW)
				Stairs.setFlags(square, sprite, IsoFlagType.climbSheetTopW)
				Stairs.unsetFlags(square, sprite, IsoFlagType.solidfloor)
			elseif Stairs.poleTiles[name] and square:getZ() == 0 then
				Stairs.setFlags(square, sprite, IsoFlagType.climbSheetW)
			end
		end
	end
end


