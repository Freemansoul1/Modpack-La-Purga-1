ISPlumbHelperCursor = ISBuildingObject:derive("ISPlumbHelperCursor")


function ISPlumbHelperCursor:create(x, y, z, north, sprite)
	local square = getWorld():getCell():getGridSquare(x, y, z)
	ISTimedActionQueue.clear(self.character)
	ISTimedActionQueue.add(ISWalkToTimedAction:new(self.character, square))
end

function ISPlumbHelperCursor:isValid(square)
	return IsoObject.FindExternalWaterSource(square) 	
end

function ISPlumbHelperCursor:render(x, y, z, square)
	if not ISPlumbHelperCursor.floorSprite then
		ISPlumbHelperCursor.floorSprite = IsoSprite.new()
		ISPlumbHelperCursor.floorSprite:LoadFramesNoDirPageSimple('media/ui/WaterFloorTileCursor.png')
	end
	local color = {r=1,g=.2,b=.2}
	if self:isValid(square) then
		if square:isInARoom() then
			ISPlumbHelperCursor.floorSprite = IsoSprite.new()
			ISPlumbHelperCursor.floorSprite:LoadFramesNoDirPageSimple('media/ui/WaterFloorTileCursor.png')
			color = {r=1,g=1,b=1}
		else
			ISPlumbHelperCursor.floorSprite = IsoSprite.new()
			ISPlumbHelperCursor.floorSprite:LoadFramesNoDirPageSimple('media/ui/WaterFloorTileCursor2.png')
			color = {r=1,g=1,b=1}
		end
	else
		if square:isInARoom() then
			local objects = square:getObjects()
			for index=0, objects:size()-1 do
				local preWaterShutoff = getGameTime():getNightsSurvived() < getSandboxOptions():getOptionByName("WaterShutModifier"):getValue();
				local object = objects:get(index)
				if object:getSquare():getRoom() and preWaterShutoff and object:hasModData() and object:getModData().canBeWaterPiped then
					ISPlumbHelperCursor.floorSprite = IsoSprite.new()
					ISPlumbHelperCursor.floorSprite:LoadFramesNoDirPageSimple('media/ui/WaterFloorTileCursor5.png')
					color = {r=1,g=1,b=1}
				else
					ISPlumbHelperCursor.floorSprite = IsoSprite.new()
					ISPlumbHelperCursor.floorSprite:LoadFramesNoDirPageSimple('media/ui/WaterFloorTileCursor3.png')
					color = {r=1,g=1,b=1}
				end
			end
		else
			ISPlumbHelperCursor.floorSprite = IsoSprite.new()
			ISPlumbHelperCursor.floorSprite:LoadFramesNoDirPageSimple('media/ui/WaterFloorTileCursor4.png')
			color = {r=1,g=1,b=1}
		end
	end	
	ISPlumbHelperCursor.floorSprite:RenderGhostTileColor(x, y, z,color.r, color.g, color.b, 0.8)
end

function ISPlumbHelperCursor:new(sprite, northSprite, character)
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