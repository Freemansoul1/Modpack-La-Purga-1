
ISEmptyMoats = ISBuildingObject:derive("ISEmptyMoats");

--************************************************************************--
--** ISEmptyMoats:new
--**
--************************************************************************--
function ISEmptyMoats:create(x, y, z, north, sprite)
    local cell = getCell();
    local sqSE = cell:getGridSquare(x, y, z);
    if not sqSE then return end

    local spriteNameSE = sprite
    self:setInfo(sqSE, north, spriteNameSE, cell, "sprite1");
    local moatsArgsSE = {exterior=sqSE:isOutside(), taintedWater=false, waterAmount=0.0, waterMax=RainCollectorBarrel.largeWaterMax, spriteName=spriteNameSE}
    ShGO.createCGO(Moats.key, sqSE, nil, moatsArgsSE)--create the global object for flooding

    local xa, ya, za = self:getSquare2Pos(sqSE, north)
    local sqNW = cell:getGridSquare(xa, ya, za);
    if sqNW == nil then
        sqNW = IsoGridSquare.new(cell, nil, xa, ya, za);
        cell:ConnectNewSquare(sqNW, false);
    end

    if sqNW then
        local spriteNameNW = north and self.northSpriteMoats or self.westSpriteMoats
        self:setInfo(sqNW, north, spriteNameNW, cell, "sprite2");
        local moatsArgsNW = {exterior=sqNW:isOutside(), taintedWater=false, waterAmount=0.0, waterMax=RainCollectorBarrel.largeWaterMax, spriteName=spriteNameNW}
        ShGO.createCGO(Moats.key, sqNW, nil, moatsArgsNW)--create the global object for flooding
    end
end

function ISEmptyMoats:walkTo(x, y, z)
	local playerObj = getSpecificPlayer(self.player)
	local square = getCell():getGridSquare(x, y, z)
	local square2 = self:getSquare2(square, self.north)
	if square:DistToProper(playerObj) < square2:DistToProper(playerObj) then
		return luautils.walkAdj(playerObj, square)
	end
	return luautils.walkAdj(playerObj, square2)
end

function ISEmptyMoats:setInfo(square, north, sprite, cell, spriteType)
	for i=0,square:getObjects():size()-1 do
		local object = square:getObjects():get(i);
		if object:getProperties() and object:getProperties():Is(IsoFlagType.canBeRemoved) then
			square:transmitRemoveItemFromSquare(object)
			square:RemoveTileObject(object);
			break
		end
	end
	square:disableErosion();
	local args = { x = square:getX(), y = square:getY(), z = square:getZ() }
	sendClientCommand('erosion', 'disableForSquare', args)
--	
--	self.javaObject = IsoThumpable.new(cell, square, sprite, north, self);
--	square:RecalcAllWithNeighbours(true);
--	self.javaObject:setName("EmptyMoats");
--	self.javaObject:setCanBarricade(false);
--	self.javaObject:setIsThumpable(false)
--	self.javaObject:getModData()["spriteType"] = spriteType;
--	square:AddSpecialObject(self.javaObject);
--	self.javaObject:transmitCompleteItemToServer();
end

function ISEmptyMoats:new(eastSprite, westSprite, southSprite, northSprite, shovel)
	local o = {};
	setmetatable(o, self);
	self.__index = self;
	o:init();
	o:setSprite(eastSprite);
	o:setNorthSprite(southSprite);
	o.westSpriteMoats = westSprite;
	o.northSpriteMoats = northSprite;
	o.noNeedHammer = true;
	o.ignoreNorth = true;
	o.equipBothHandItem = shovel;
	o.maxTime = 150;
	o.actionAnim = ISFarmingMenu.getShovelAnim(shovel);
	o.craftingBank = "Shoveling";
	return o;
end

-- return the health of the new EmptyMoats, it's 500
function ISEmptyMoats:getHealth()
    return 500
end

--save as local to not call creation on every render cycle
local renderSpriteSE = nil --south or east sprite: ref sprite
local renderSpriteNW = nil --north or west sprite: secondary sprite, spriteA
function ISEmptyMoats:render(x, y, z, square)-- render the first part
    local floor = square:getFloor();
    if not floor then return; end

    local spriteName = self:getSprite()
    if renderSpriteSE == nil then renderSpriteSE = IsoSprite.new() end
    renderSpriteSE:LoadFramesNoDirPageSimple(spriteName)

    local spriteFree = ISBuildingObject.isValid(self, square)
                   and ISEmptyMoats.isDiggableFloorTexture(floor:getTextureName())
                   and ISEmptyMoats.shovelledFloorCanDig(square);

    if spriteFree and z==0 then
        renderSpriteSE:RenderGhostTile(x, y, z);
    else
        renderSpriteSE:RenderGhostTileRed(x, y, z);
    end

    -- we get the x and y of our next tile (depend if we're placing the moats north or not)
    local xa, ya = self:getSquare2Pos(square, self.north)
    local squareA = getCell():getGridSquare(xa, ya, z);
    if squareA == nil and getWorld():isValidSquare(xa, ya, z) then
        squareA = IsoGridSquare.new(getCell(), nil, xa, ya, z);
        getCell():ConnectNewSquare(squareA, false);
    end

    local floorA = squareA:getFloor();
    if not floorA then return; end
    -- test if the square are free to add our moats
    local spriteAFree = buildUtil.canBePlace(self, squareA)
              and ISEmptyMoats.isDiggableFloorTexture(floorA:getTextureName())
              and ISEmptyMoats.shovelledFloorCanDig(squareA);
    local spriteAName = self.north and self.northSpriteMoats or self.westSpriteMoats;
    -- render our second stage of the moats
    renderSpriteNW = IsoSprite.new();
    renderSpriteNW:LoadFramesNoDirPageSimple(spriteAName);
    if spriteAFree and z==0 then
        renderSpriteNW:RenderGhostTile(xa, ya, z);
    else
        renderSpriteNW:RenderGhostTileRed(xa, ya, z);
    end
end

function ISEmptyMoats:isValid(square)
    if square:getZ() > 0 or square:isSolidTrans() then
        return false
    end
    local floor = square:getFloor();
    if not ISBuildingObject.isValid(self, square) or not ISEmptyMoats.isDiggableFloorTexture(floor:getTextureName()) then
        return false
    end
    local xa, ya, za = self:getSquare2Pos(square, self.north)
    local squareA = getCell():getGridSquare(xa, ya, za)
    if not squareA or squareA:isSolidTrans() or not buildUtil.canBePlace(self, squareA) then
        return false
    end
    local floorA = squareA:getFloor();
    if not ISEmptyMoats.isDiggableFloorTexture(floorA:getTextureName()) then
        return false;
    end
    if not ISEmptyMoats.shovelledFloorCanDig(square) or not ISEmptyMoats.shovelledFloorCanDig(squareA) then
        return false;
    end

    return true
end

function ISEmptyMoats.shovelledFloorCanDig(square)
	if not square or square:isInARoom() or square:isSolidTrans() then return false; end
	local floor = square:getFloor();
    if not floor then return false end
    if ShGO.getFirstObject(square,Moats.key) ~= nil then return false end
    local floorMd = floor:getModData()
	local sprites = floorMd and floorMd.shovelledSprites;
	if sprites then
		for i=1,#sprites do
			local sprite = sprites[i];
			if ISEmptyMoats.isDiggableFloorTexture(sprite) then
				return true;
			end
		end
		return false;
	else
		return true;
	end
end

function ISEmptyMoats:getSquare2Pos(square, isNorthSouthAxis)
    local x = square:getX()
    local y = square:getY()
    local z = square:getZ()
    if isNorthSouthAxis then
        y = y - 1--square is south, square2 is north
    else
        x = x - 1--square is east, square2 is west
    end
    return x, y, z
end

function ISEmptyMoats:getSquare2(square, north)
	local x, y, z = self:getSquare2Pos(square, north)
	return getCell():getGridSquare(x, y, z)
end

function ISEmptyMoats.canDigHere(worldObjects)
	local squares = {}
	local didSquare = {}
	for _,worldObj in ipairs(worldObjects) do
		if not didSquare[worldObj:getSquare()] then
			table.insert(squares, worldObj:getSquare())
			didSquare[worldObj:getSquare()] = true
		end
	end
	for _,square in ipairs(squares) do
		if square:getZ() > 0 then
			return false
		end
		local floor = square:getFloor()
		if floor and ISEmptyMoats.isDiggableFloorTexture(floor:getTextureName()) then
			return true
		end
	end
	return false
end

function ISEmptyMoats.isDiggableFloorTexture(textureName)
    return textureName and (luautils.stringStarts(textureName, "floors_exterior_natural") or luautils.stringStarts(textureName, "blends_natural_01"))
end
