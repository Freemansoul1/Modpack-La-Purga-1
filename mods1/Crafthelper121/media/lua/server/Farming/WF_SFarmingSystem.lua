local original_ISObjectClickHandler_doClickLightSwitch = ISObjectClickHandler.doClickLightSwitch
function ISObjectClickHandler.doClickLightSwitch(object, playerNum, playerObj)
    if WFGrowLampUtilities.isGrowLampLight(object) then
        if isClient() then
            local args = {
                x = object:getSquare():getX(),
                y = object:getSquare():getY(),
                z = object:getSquare():getZ(),
                s = not object:isActivated()
            }
            sendClientCommand(playerObj, 'farming', 'toggleGrowLamp', args)
        else
            WFGrowLampUtilities.toggleGrowLamp(object:getSquare(), not object:isActivated())
        end
        return true
    end
    return original_ISObjectClickHandler_doClickLightSwitch(object, playerNum, playerObj)
end

if isClient() then return end

require "Farming/SFarmingSystem"
require "Farming/SGFarmingSystem"

if farming_vegetableconf.props["Coca"] then farming_vegetableconf.props["Coca"].seedPerVegVar = {0,0} end
if farming_vegetableconf.props["Kief"] then farming_vegetableconf.props["Kief"].seedPerVegVar = {0,0} end
if farming_vegetableconf.props["Amapola"] then farming_vegetableconf.props["Amapola"].seedPerVegVar = {0,0} end
if farming_vegetableconf.props["Mongui"] then farming_vegetableconf.props["Mongui"].seedPerVegVar = {0,0} end
if farming_vegetableconf.props["Tea"] then farming_vegetableconf.props["Tea"].seedPerVegVar = {1,5} end
if farming_vegetableconf.props["Coffee"] then farming_vegetableconf.props["Coffee"].seedPerVegVar = {1,5} end
if farming_vegetableconf.props["Latex"] then farming_vegetableconf.props["Latex"].seedPerVegVar = {1,5} end
if farming_vegetableconf.props["Rose"] then farming_vegetableconf.props["Rose"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Carnation"] then farming_vegetableconf.props["Carnation"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Larkspur"] then farming_vegetableconf.props["Larkspur"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Dahlia"] then farming_vegetableconf.props["Dahlia"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Delphi"] then farming_vegetableconf.props["Delphi"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Daisy"] then farming_vegetableconf.props["Daisy"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Penta"] then farming_vegetableconf.props["Penta"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Geranium"] then farming_vegetableconf.props["Geranium"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Bird"] then farming_vegetableconf.props["Bird"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Mutton"] then farming_vegetableconf.props["Mutton"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Pork"] then farming_vegetableconf.props["Pork"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Beef"] then farming_vegetableconf.props["Beef"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Wool"] then farming_vegetableconf.props["Wool"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Milk"] then farming_vegetableconf.props["Milk"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Egg"] then farming_vegetableconf.props["Egg"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Honey"] then farming_vegetableconf.props["Honey"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Leek"] then farming_vegetableconf.props["Leek"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Lettuce"] then farming_vegetableconf.props["Lettuce"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Onion"] then farming_vegetableconf.props["Onion"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["SoyBean"] then farming_vegetableconf.props["SoyBean"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Pumpkin"] then farming_vegetableconf.props["Pumpkin"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Watermelon"] then farming_vegetableconf.props["Watermelon"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Zucchini"] then farming_vegetableconf.props["Zucchini"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Corn"] then farming_vegetableconf.props["Corn"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Ginger"] then farming_vegetableconf.props["Ginger"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Pineapple"] then farming_vegetableconf.props["Pineapple"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Wheat"] then farming_vegetableconf.props["Wheat"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["SugarCane"] then farming_vegetableconf.props["SugarCane"].seedPerVegVar = {1,5} end
if farming_vegetableconf.props["Ginseng"] then farming_vegetableconf.props["Ginseng"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Mushroom"] then farming_vegetableconf.props["Mushroom"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["BellPepper"] then farming_vegetableconf.props["BellPepper"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["BerryBlack"] then farming_vegetableconf.props["BerryBlack"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["BerryBlue"] then farming_vegetableconf.props["BerryBlue"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Lemongrass"] then farming_vegetableconf.props["Lemongrass"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Eggplant"] then farming_vegetableconf.props["Eggplant"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Grape"] then farming_vegetableconf.props["Grape"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Rice"] then farming_vegetableconf.props["Rice"].seedPerVegVar = {1,5} end
if farming_vegetableconf.props["PepperPlant"] then farming_vegetableconf.props["PepperPlant"].seedPerVegVar = {1,5} end
if farming_vegetableconf.props["Hops"] then farming_vegetableconf.props["Hops"].seedPerVegVar = {1,5} end
if farming_vegetableconf.props["Cotton"] then farming_vegetableconf.props["Cotton"].seedPerVegVar = {1,5} end
if farming_vegetableconf.props["Pear"] then farming_vegetableconf.props["Pear"].seedPerVegVar = {1,5} end
if farming_vegetableconf.props["CommonMallow"] then farming_vegetableconf.props["CommonMallow"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Plantain"] then farming_vegetableconf.props["Plantain"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Comfrey"] then farming_vegetableconf.props["Comfrey"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Garlic"] then farming_vegetableconf.props["Garlic"].seedPerVegVar = {1,3} end
if farming_vegetableconf.props["Sage"] then farming_vegetableconf.props["Sage"].seedPerVegVar = {1,3} end


-- Override to attach luaObject temporarily so
-- that we can use the amount of fertilizer on the plant to
-- reduce the grow time.
local original_SFarmingSystem_growPlant = SFarmingSystem.growPlant
function SFarmingSystem:growPlant(luaObject, nextGrowing, updateNbOfGrow)
    SFarmingSystem.WF_currentLuaObject = luaObject
    original_SFarmingSystem_growPlant(self, luaObject, nextGrowing, updateNbOfGrow)
    SFarmingSystem.WF_currentLuaObject = nil
end

-- Override to reduce the grow time of the plant based on the
-- amount of fertilizer on the plant.
function calcNextGrowing(nextGrowing, nextTime)
	if nextGrowing then
		return nextGrowing;
	end
    if SandboxVars.Farming == 1 then -- very fast
        nextTime = nextTime / 3;
    end
    if SandboxVars.Farming == 2 then -- fast
        nextTime = nextTime / 1.5;
    end
    if SandboxVars.Farming == 4 then -- slow
        nextTime = nextTime * 1.5;
    end
    if SandboxVars.Farming == 5 then -- very slow
        nextTime = nextTime * 3;
    end
    if SFarmingSystem.WF_currentLuaObject then
        local reduction = 0
        if SFarmingSystem.WF_currentLuaObject.fertilizer then
            reduction = SFarmingSystem.WF_currentLuaObject.fertilizer * 0.1 -- fertilizer reduces grow time by 10% per point
        end
        if SFarmingSystem.WF_currentLuaObject.lightEnabled then
            reduction = reduction + 0.1 -- grow lamp reduces grow time by 10%
        end
        if reduction > 0 then
            nextTime = nextTime - (nextTime * reduction)
        end
    end
	return SFarmingSystem.instance.hoursElapsed + nextTime;
end

-- Override to attach player to the luaObject temporarily so
-- that we can use the player's farming skill to determine
-- the yield of the plant.
-- Also will adjust the seedsPerVeg if a range is specified.
local original_SFarmingSystem_harvest = SFarmingSystem.harvest
function SFarmingSystem:harvest(luaObject, player)
    luaObject.harvestPlayer = player
    local props = farming_vegetableconf.props[luaObject.typeOfSeed]
    if props.seedPerVegVar ~= nil then
        props.seedPerVeg = ZombRand(props.seedPerVegVar[1], props.seedPerVegVar[2] + 1)
    end
    original_SFarmingSystem_harvest(self, luaObject, player)
    luaObject.harvestPlayer = nil
end

-- Override checking plants to reset the grow time for level 7 plants
-- to prevent in-ground rotting
local original_SFarmingSystem_checkPlant = SFarmingSystem.checkPlant
function SFarmingSystem:checkPlant()
    local toRemove = {}
    for i=1,self:getLuaObjectCount() do
        local luaObject = self:getLuaObjectByIndex(i)
        if luaObject then
            if luaObject.state == "rotten" or luaObject.state == "dry" or luaObject.state == "destroy" then
                if not luaObject.deadTime then -- fix for old saves
                    luaObject:deadPlant()
                end
                -- remove rotten plants after 7 days
                if (getTimestamp() - luaObject.deadTime) > 7 * 24 * 60 * 60 then
                    table.insert(toRemove, luaObject)
                end
            elseif luaObject.nbOfGrow == 7 then
                luaObject.nextGrowing = self.hoursElapsed + 9999
            end
        end
    end
    for i, luaObject in ipairs(toRemove) do
        luaObject:removeObject()
    end
    original_SFarmingSystem_checkPlant(self)
end

-- Kill plants in winter

local winterPlants = ArrayList.new()
winterPlants:add("Olive")
winterPlants:add("GrapeFruit")
winterPlants:add("Lemon")
winterPlants:add("Lime")
winterPlants:add("Orange")
winterPlants:add("Apple")
winterPlants:add("Banana")
winterPlants:add("Cherry")
winterPlants:add("Mango")
winterPlants:add("Pear")
winterPlants:add("Peach")
winterPlants:add("Milk")
winterPlants:add("Egg")
winterPlants:add("Wool")
winterPlants:add("Beef")
winterPlants:add("Pork")
winterPlants:add("Mutton")
winterPlants:add("Bird")
winterPlants:add("Honey")
winterPlants:add("Latex")
winterPlants:add("Coca")
winterPlants:add("Amapola")
winterPlants:add("Kief")
winterPlants:add("Mongui")

local function survivesWinter(luaObject)
    return winterPlants:contains(luaObject.typeOfSeed) and luaObject.nbOfGrow >= 4
end

local function hasPoweredLamp(sq)
    if not sq or not sq:haveElectricity() then return false end

    local objects = sq:getObjects()
    for i=0,objects:size()-1 do
        if WFGrowLampUtilities.isGrowLamp(objects:get(i)) then
            return true
        end
    end
    return false
end

function SFarmingSystem:CheckSquare(luaObject)
    local square = luaObject:getSquare()
    if square then
        local wasOutside = luaObject.isOutside
        local wasEnabled = luaObject.lightEnabled
        luaObject.isOutside = square:isOutside()
        luaObject.lightEnabled = false

        for x=square:getX()-1,square:getX()+1 do
            for y=square:getY()-1,square:getY()+1 do
                local checkSquare = getCell():getGridSquare(x, y, square:getZ())
                if checkSquare then
                    luaObject.lightEnabled = luaObject.lightEnabled or hasPoweredLamp(checkSquare)
                end
            end
        end

        if wasOutside ~= luaObject.isOutside or wasEnabled ~= luaObject.lightEnabled then
            luaObject:saveData()
        end
    end
end

function SFarmingSystem:CheckTemperture(luaObject)
    if luaObject and luaObject.state ~= "seeded" and not survivesWinter(luaObject) and luaObject.isOutside and luaObject:isAlive() then
        local temp = getClimateManager():getTemperature()
        if temp > 0 then return end -- if temp is above 0, then we don't need to check plants
        local damage = temp * 0.5 -- damage is half of temp
        luaObject.health = luaObject.health + damage -- damage is negative, so we add it
        if luaObject.health <= 0 then
            luaObject:rottenThis()
        end
        luaObject:saveData()
    end
end

-- will lower health of any plant that is inside and not under a grow lamp
function SFarmingSystem:CheckGrowLamp(luaObject)
    if luaObject.state ~= "seeded" then return end
    if luaObject.isOutside then return end
    if luaObject.lightEnabled then return end

    luaObject.health = luaObject.health - 0.05
    if luaObject.health <= 0 then
        luaObject:rottenThis()
    end
    luaObject:saveData()
end

function SFarmingSystem:WFEveryTenMinutes()
    for i=1,self:getLuaObjectCount() do
		local luaObject = self:getLuaObjectByIndex(i)
        if luaObject then
            self:CheckSquare(luaObject)
            self:CheckTemperture(luaObject)
            if SandboxVars.WastelandFarming.EnableIndoorPenaltyWithoutLamp then
                self:CheckGrowLamp(luaObject)
            end
        end
    end
end

local function EveryTenMinutes()
	SFarmingSystem.instance:WFEveryTenMinutes()
end

if not isClient() then
    Events.EveryTenMinutes.Add(EveryTenMinutes)
end

Events.OnClientCommand.Add(function (module, command, player, args)
    if module == "farming" then
        if command == "tend" then
            local x = tonumber(args.x)
            local y = tonumber(args.y)
            local z = tonumber(args.z)
            local square = getCell():getGridSquare(x, y, z)
            if square then
                local luaObject = SFarmingSystem.instance:getLuaObjectOnSquare(square)
                if luaObject and luaObject.state == "seeded" and luaObject.nbOfGrow < 7 then
                    luaObject.lastTendHour = SFarmingSystem.instance.hoursElapsed
                    local timeRemaining = luaObject.nextGrowing - SFarmingSystem.instance.hoursElapsed
                    if timeRemaining > 0 then
                        local reduction = player:getPerkLevel(Perks.Farming) * 0.01 -- farming skill reduces grow time by 1% per level
                        luaObject.nextGrowing = SFarmingSystem.instance.hoursElapsed + (timeRemaining * (1 - reduction))
                    end
                    luaObject:saveData()
                end
            end
        end

        if command == "addGrowLamp" then
            local x = tonumber(args.x)
            local y = tonumber(args.y)
            local z = tonumber(args.z)
            local square = getCell():getGridSquare(x, y, z)
            if square then
                WFGrowLampUtilities.doPlaceGrowLamp(square)
            end
        end

        if command == "removeGrowLamp" then
            local x = tonumber(args.x)
            local y = tonumber(args.y)
            local z = tonumber(args.z)
            local square = getCell():getGridSquare(x, y, z)
            if square then
                local objects = square:getObjects()
                for i=0,objects:size()-1 do
                    if WFGrowLampUtilities.isGrowLamp(objects:get(i)) then
                        WFGrowLampUtilities.doRemoveGrowLamp(player, objects:get(i))
                        return
                    end
                end
            end
        end

        if command == "toggleGrowLamp" then
            local x = tonumber(args.x)
            local y = tonumber(args.y)
            local z = tonumber(args.z)
            local s = args.s
            local square = getCell():getGridSquare(x, y, z)
            if square then
               WFGrowLampUtilities.toggleGrowLamp(square, s)
            end
        end

        if command == "superCheat" then
            local x = tonumber(args.x)
            local y = tonumber(args.y)
            local z = tonumber(args.z)
            local level = tonumber(args.level)
            local square = getCell():getGridSquare(x, y, z)
            if square then
                local luaObject = SFarmingSystem.instance:getLuaObjectOnSquare(square)
                if luaObject then
                    luaObject.state = "seeded"
                    luaObject.nbOfGrow = level - 1
                    luaObject.nextGrowing = SFarmingSystem.instance.hoursElapsed
                    luaObject.health = 100
                    luaObject.fliesLvl = 0
                    luaObject.mildewLvl = 0
                    luaObject.aphidLvl = 0
                    luaObject.waterLvl = 100
                    luaObject:addIcon()
                    luaObject:checkStat()
                    luaObject:saveData()
                end
            end
        end
    end
end)

local original_SPlantGlobalObject_fromModData = SPlantGlobalObject.fromModData
function SPlantGlobalObject:fromModData(modData)
    original_SPlantGlobalObject_fromModData(self, modData)
	self.lastTendHour = modData.lastTendHour
	self.lightEnabled = modData.lightEnabled
    self.deadTime = modData.deadTime
end

local original_SPlantGlobalObject_toModData = SPlantGlobalObject.toModData
function SPlantGlobalObject:toModData(modData)
    original_SPlantGlobalObject_toModData(self, modData)
	modData.lastTendHour = self.lastTendHour
	modData.lightEnabled = self.lightEnabled
    modData.deadTime = self.deadTime
end

local original_SFarmingSystem_initSystem = SFarmingSystem.initSystem
function SFarmingSystem:initSystem()
    original_SFarmingSystem_initSystem(self)
    self.system:setObjectModDataKeys({
		'state', 'nbOfGrow', 'typeOfSeed', 'fertilizer', 'mildewLvl',
		'aphidLvl', 'fliesLvl', 'waterLvl', 'waterNeeded', 'waterNeededMax',
		'lastWaterHour', 'nextGrowing', 'hasSeed', 'hasVegetable',
		'health', 'badCare', 'exterior', 'spriteName', 'objectName',
        'lastTendHour', 'lightEnabled', 'deadTime'})
end

local original_SPlantGlobalObject_aphid = SPlantGlobalObject.aphid
function SPlantGlobalObject:aphid()
    original_SPlantGlobalObject_aphid(self)
    if self.lastTendHour and self.aphidLvl == 1 and SFarmingSystem.instance.hoursElapsed - self.lastTendHour < 12 then
        self.aphidLvl = 0
    end
end

local original_SPlantGlobalObject_flies = SPlantGlobalObject.flies
function SPlantGlobalObject:flies()
    original_SPlantGlobalObject_flies(self)
    if self.lastTendHour and self.fliesLvl == 1 and SFarmingSystem.instance.hoursElapsed - self.lastTendHour < 12 then
        self.fliesLvl = 0
    end
end

local original_SPlantGlobalObject_mildew = SPlantGlobalObject.mildew
function SPlantGlobalObject:mildew()
    original_SPlantGlobalObject_mildew(self)
    if self.lastTendHour and self.mildewLvl == 1 and SFarmingSystem.instance.hoursElapsed - self.lastTendHour < 12 then
        self.mildewLvl = 0
    end
end

local original_SPlantGlobalObject_deadPlant = SPlantGlobalObject.deadPlant
function SPlantGlobalObject:deadPlant()
    if not self.deadTime then
        self.deadTime = getTimestamp()
    end
    original_SPlantGlobalObject_deadPlant(self)
end