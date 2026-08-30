-- ***********************************************************
-- **                    THE INDIE STONE                    **
-- ***********************************************************
require "TimedActions/ISBaseTimedAction"
local SafehouseController = require "LandClaim/SafehouseController"

ISDestroyLandClaim = ISBaseTimedAction:derive("ISDestroyLandClaim");

function ISDestroyLandClaim:isValid()
    return IsoUtils.DistanceTo(self.square:getX(), self.square:getY(), self.character:getX(), self.character:getY()) <=
    2
end

function ISDestroyLandClaim:stop()
    ISBaseTimedAction.stop(self);
end

function ISDestroyLandClaim:perform()
    for i = 0, self.square:getObjects():size() - 1 do
        local landClaim = self.square:getObjects():get(i)
        local sprite = landClaim:getSprite()

        if sprite:getName() == LandClaimConfig.LCItemType then
            self.square:transmitRemoveItemFromSquare(landClaim)
            self.square:RemoveTileObject(landClaim)
            SafehouseController.DeleteSafehouse(self.square, self.character, true)
            self.character:setHaloNote("Land Claim destroyed!");
            ISBaseTimedAction.perform(self);
            return
        end
    end

    self.character:setHaloNote("Land Claim not found!");
    ISBaseTimedAction.perform(self);
end

function ISDestroyLandClaim:new(character, square, safehouse)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character;
    o.square = square;
    o.safehouse = safehouse;

    o.stopOnWalk = true;
    o.stopOnRun = true;

    o.maxTime = SandboxVars.LC.DestroyLandClaimTimedActionTime;
    return o
end
