local SafehouseController = require "LandClaim/SafehouseController_Server"
require "BuildingObjects/ISDestroyCursor"

local stairsSpriteTypes = {
    [IsoObjectType.stairsBN] = true,
    [IsoObjectType.stairsBW] = true,
    [IsoObjectType.stairsMN] = true,
    [IsoObjectType.stairsMW] = true,
    [IsoObjectType.stairsTN] = true,
    [IsoObjectType.stairsTW] = true
}

local function isObjectValid(object)
    local sprite = object:getSprite()
    local type = sprite:getType()

    -- can't destroy land claim object
    if sprite:getName() == LandClaimConfig.LCItemType then return false end

    -- static stairs check, player can only dismantle stairs
    if not instanceof(object, "IsoThumpable") and stairsSpriteTypes[type] then
        return false
    end

    -- floor check, player can only dismantle floors
    local properties = sprite:getProperties()
    if properties:Is(IsoFlagType.solidfloor) then
        return false
    end

    return true
end
local oldISDestroyCursor_canDestroy = ISDestroyCursor.canDestroy

function ISDestroyCursor:canDestroy(object)
    if not SafehouseController.CanDestroy(self.player, object:getSquare()) then return false end

	if not isObjectValid(object) then return false end

	return oldISDestroyCursor_canDestroy(self, object)
end