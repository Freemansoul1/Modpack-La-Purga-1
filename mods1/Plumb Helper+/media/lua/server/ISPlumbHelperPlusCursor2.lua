ISPlumbHelperCursor2 = ISBuildingObject:derive("ISPlumbHelperCursor2")

function ISPlumbHelperCursor2:create(x, y, z, north, sprite)
	local square = getWorld():getCell():getGridSquare(x, y, z)
	ISTimedActionQueue.clear(self.character)
	ISTimedActionQueue.add(ISWalkToTimedAction:new(self.character, square))
end


function ISPlumbHelperCursor2:isValid(square)
	local x,y,z = square:getX(),square:getY(),square:getZ()-1
	local squareA = getCell():getGridSquare(x, y, z)
	if not squareA then return false end
	local objects = squareA:getObjects()
	for index=0, objects:size()-1 do
		local object = objects:get(index)
		if (object:hasModData() and object:getModData().canBeWaterPiped) or (instanceof(object, "IsoObject") and object:getSprite() and object:getSprite():getProperties() and object:getSprite():getProperties():Is(IsoFlagType.waterPiped)) then
			return true
		end
	end
	return false
end

function ISPlumbHelperCursor2:render(x, y, z, square)
	if not ISPlumbHelperCursor2.floorSprite then
		ISPlumbHelperCursor2.floorSprite = IsoSprite.new()
		ISPlumbHelperCursor2.floorSprite:LoadFramesNoDirPageSimple('media/ui/WaterFloorTileCursor.png')
	end
	local color = {r=1,g=1,b=1}
	if self:isValid(square) then
		ISPlumbHelperCursor2.floorSprite = IsoSprite.new()
		ISPlumbHelperCursor2.floorSprite:LoadFramesNoDirPageSimple('media/ui/FaucetFloorTileCursor.png')
		color = {r=1,g=1,b=1}
	else
		ISPlumbHelperCursor2.floorSprite = IsoSprite.new()
		ISPlumbHelperCursor2.floorSprite:LoadFramesNoDirPageSimple('media/ui/FaucetFloorTileCursor2.png')
		color = {r=1,g=1,b=1}
	end	
	ISPlumbHelperCursor2.floorSprite:RenderGhostTileColor(x, y, z, color.r, color.g, color.b, 0.8)
end

function ISPlumbHelperCursor2:new(sprite, northSprite, character)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o:init()
	o:setSprite(sprite)
	o:setNorthSprite(northSprite)
	o.character = character
	o.player = character:getPlayerNum()
	o.noNeedHammer = true
	o.skipBuildAction = true
	return o
end