if isServer() then return end
local CAMmod = require "CorpsesAutoMove/CorpsesAutoMove_Functions"
--CAMmod = CAMmod or {}
--***********************************************************
--**                    ROBERT JOHNSON                     **
--***********************************************************
CAMmod.ISSelectCursor = ISBuildingObject:derive("CAMmod.ISSelectCursor")

function CAMmod.ISSelectCursor:create(x, y, z, north, sprite)
	self.ui:onSquareSelected(getWorld():getCell():getGridSquare(x, y, z),self.actionType)
end
function CAMmod.ISSelectCursor:isValid(square)
	return self.ui.cursor ~= nil
end
function CAMmod.ISSelectCursor:render(x, y, z, square)
	if not CAMmod.ISSelectCursor.floorSprite then
		CAMmod.ISSelectCursor.floorSprite = IsoSprite.new()
		local texture = "FloorTileCursor"
		CAMmod.ISSelectCursor.floorSprite:LoadFramesNoDirPageSimple('media/ui/'..texture..'.png')
	end	
	local actionType,color = CAMmod.getActionType(square)
	self.actionType = actionType
	CAMmod.ISSelectCursor.floorSprite:RenderGhostTileColor(x, y, z, color.r, color.g, color.b, 0.8)
end
function CAMmod.ISSelectCursor:walkTo(x, y, z)
	return true
end
function CAMmod.ISSelectCursor:new(character,ui)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o:init()
	o.ui = ui;
	o.character = character
	o.player = character:getPlayerNum()
	o.noNeedHammer = true
	o.skipBuildAction = true
	return o
end

return CAMmod