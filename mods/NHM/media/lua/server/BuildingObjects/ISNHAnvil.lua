--***********************************************************
--**                    ROBERT JOHNSON                     **
--***********************************************************
require "BuildingObjects/ISBuildingObject"

ISNHAnvil = ISBuildingObject:derive("ISNHAnvil");

--************************************************************************--
--** ISNHAnvil:new
--**
--************************************************************************--
function ISNHAnvil:create(x, y, z, north, sprite)
    local cell = getWorld():getCell();
    self.sq = cell:getGridSquare(x, y, z);
    self.javaObject = IsoThumpable.new(cell, self.sq, sprite, north, self);
    self.javaObject:setName("NHAnvil");
    buildUtil.consumeMaterial(self);
    -- remove the needed metal
    --[[local ingots = ISBlacksmithMenu.getMetal(self.character, ISBlacksmithMenu.metalForAnvil);
    local metalUsed = 0;
    for i=1,#ingots do
        local ingot = ingots[i];
        if round(metalUsed,0) >= ISBlacksmithMenu.metalForAnvil then
            local leftToUse = round(ISBlacksmithMenu.metalForAnvil - metalUsed, 0);
            for x=1,leftToUse do
                ingot:Use();
            end
        else
            metalUsed = round(metalUsed,0);
            ingot:getContainer():Remove(ingot);
        end
    end]]

    self.sq:AddSpecialObject(self.javaObject);
    self.javaObject:transmitCompleteItemToServer();
end

function ISNHAnvil:removeFromGround(square)
    for i = 0, square:getSpecialObjects():size() do
        local thump = square:getSpecialObjects():get(i);
        if instanceof(thump, "NHAnvil") then
            square:transmitRemoveItemFromSquare(thump);
            square:getObjects():remove(thump);
            square:getSpecialObjects():remove(thump);
        end
    end
end

function ISNHAnvil:new(name, character, sprite, northSprite)
    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o:init();
    o:setSprite(sprite);
    o.character = character;
    o:setNorthSprite(northSprite);
    o.name = name;
    o.blockAllTheSquare = true;
    o.canBeAlwaysPlaced = true;
    return o;
end

function ISNHAnvil:isValid(square)
    if not ISBuildingObject.isValid(self, square) then return false; end
    --строка чтоб нельзя было строить в тайлах где уже есть объекты
    if not square:isFreeOrMidair(false) then return false end
--    if not ISBlacksmithMenu.getMetal(self.character, ISBlacksmithMenu.metalForAnvil) then return false; end
    if self.needToBeAgainstWall then
        for i=0,square:getObjects():size()-1 do
            local obj = square:getObjects():get(i);
            if (self.north and obj:getProperties():Is("WallN")) or (not self.north and obj:getProperties():Is("WallW")) then
                return true;
            end
        end
        return false;
    else
        if buildUtil.stairIsBlockingPlacement( square, true ) then return false; end
    end
    return true;
end

function ISNHAnvil:render(x, y, z, square)
    ISBuildingObject.render(self, x, y, z, square)
end