if isClient() then return end

require 'recipecode'
local stateMap, CheckAndUpdateSprite = unpack(require 'SteamGeneratorLEDs')

function Recipe.OnCreate.SteamGenerator(items, result, player)
	result:getModData().water = 0
end

local AllSteamGenerators = {}

local function ReplaceExistingObject(object, fuel, condition)
	local cell = getWorld():getCell()
	local sq = object:getSquare()
	
	local item = InventoryItemFactory.CreateItem("SteamGenerator.Generator")
	if not item then
		return
	end
	
	item:setCondition(condition)
	local modData = item:getModData()
	modData.fuel = fuel
	modData.water = modData.water or 0
	
	sq:transmitRemoveItemFromSquare(object)
	local javaObject = IsoGenerator.new(item, cell, square)
	local modData = javaObject:getModData()
	modData.water = modData.water
	javaObject:setSprite(getSprite(stateMap.off))
	javaObject:transmitCompleteItemToClients()
	return javaObject
end

local function NewSteamGenerator(object)
	object = instanceof(object, 'IsoGenerator') and object or ReplaceExistingObject(object, 0, 100)
	AllSteamGenerators[object] = true
end

local function LoadSteamGenerator(object)
	AllSteamGenerators[object] = true
end

local function CheckWaterLevelAndDamage(generator)
	local modData = generator:getModData()
	modData.water = modData.water and math.max(0, modData.water - 0.01) or 0
	if modData.water < 30 then
		-- If it totally runs out of water, wreck it.
		generator:setCondition(modData.water <= 0 and 0 or generator:getCondition() - 0.1)
	end
	generator:transmitModData()
end

Events.EveryTenMinutes.Add(function()
	for k,_ in pairs(AllSteamGenerators) do
		if k:getModData().water then
			if k:isActivated() then
				CheckWaterLevelAndDamage(k)
				CheckAndUpdateSprite(k)
			end
		else
			AllSteamGenerators[k] = nil
		end
	end
end)

local PRIORITY = 5
for _,v in pairs(stateMap) do
	MapObjects.OnNewWithSprite(v, NewSteamGenerator, PRIORITY)
	MapObjects.OnLoadWithSprite(v, LoadSteamGenerator, PRIORITY)
end

Events.OnObjectAdded.Add(function(isoObject)
	if instanceof(isoObject, 'IsoGenerator')then
		NewSteamGenerator(isoObject)
	end
end)

Events.OnObjectAboutToBeRemoved.Add(function(isoObject)
	AllSteamGenerators[isoObject] = nil
end)
