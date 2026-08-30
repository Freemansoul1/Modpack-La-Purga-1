require 'TimedActions/ISUnequipAction'
require 'TimedActions/ISCraftAction'
require 'TimedActions/ISDropItemAction'
require 'TimedActions/ISDropWorldItemAction'
require 'TimedActions/ISInventoryTransferAction'

require 'ISUI/ISGeneratorInfoWindow'
require 'ISUI/ISWorldObjectContextMenu'

require 'DebugUIs/DebugContextMenu'

local stateMap = unpack(require 'SteamGeneratorLEDs')

local function updateSpriteAndModData(object, invItem)
	object:setSprite(getSprite(stateMap.off))
	local genData = object:getModData()
	genData.water = genData.water or 0
	if invItem then
		local invData = invItem:getModData()
		genData.water = invData.water or 0
	end
	object:transmitUpdatedSprite()
	object:transmitModData()
	triggerEvent('OnObjectAdded', object) -- for single player
end

local function genPerform(oldPerform)
	return function(self, ...)
		local ret = {oldPerform(self, ...)}
		if self.item:getFullType() == "SteamGenerator.Generator" then
			local gen = self.character:getCurrentSquare():getGenerator()
			if gen then
				updateSpriteAndModData(gen, self.item)
			end
		end
		return unpack(ret)
	end
end

ISUnequipAction.perform = genPerform(ISUnequipAction.perform)
ISDropItemAction.perform = genPerform(ISDropItemAction.perform)
ISDropWorldItemAction.perform = genPerform(ISDropWorldItemAction.perform)

local oldAddOrDropItem = ISCraftAction.addOrDropItem
function ISCraftAction:addOrDropItem(item, ...)
	local ret = {oldAddOrDropItem(self, item, ...)}
	if item:getFullType() == 'SteamGenerator.Generator' then
		local gen = self.character:getCurrentSquare():getGenerator()
		if gen then
			updateSpriteAndModData(gen, item)
		end
	end
	return unpack(ret)
end

local oldTransferItem = ISInventoryTransferAction.transferItem
function ISInventoryTransferAction:transferItem(...)
	local isSteamGen = self.item:getFullType() == 'SteamGenerator.Generator'
	local isDropping = not self.destContainer or self.destContainer:getType() == 'floor'
	local sqOccupied = self.character:getCurrentSquare():getGenerator()
	if isSteamGen and isDropping and sqOccupied then
		return
	end
	local ret = {oldTransferItem(self, ...)}
	if isSteamGen and isDropping then
		local gen = self.character:getCurrentSquare():getGenerator()
		if gen then
			updateSpriteAndModData(gen, item)
		end
	end
	return unpack(ret)
end

local function onAddCorpse(worldobjects, corpse, generator, playerObj)
	if luautils.walkAdj(playerObj, generator:getSquare(), true) then
		ISTimedActionQueue.add(ISSteamGeneratorAddCorpse:new(playerObj, generator, corpse, 200))
	end
end

local function onAddLogs(worldobjects, log, generator, playerObj)
	if luautils.walkAdj(playerObj, generator:getSquare(), true) then
		ISTimedActionQueue.add(ISSteamGeneratorAddFuel:new(playerObj, generator, log, 100))
	end
end

local function onAddWater(worldobject, water, generator, playerObj)
	if luautils.walkAdj(playerObj, generator:getSquare(), true) then
		ISTimedActionQueue.add(ISSteamGeneratorAddWater:new(playerObj, generator, water, 30))
	end
end

local function onFixGenerator(worldobject, generator, playerObj)
	if luautils.walkAdj(playerObj, generator:getSquare(), true) then
		ISTimedActionQueue.add(ISFixSteamGenerator:new(playerObj, generator, 30))
	end
end

local generator
Events.OnPreFillWorldObjectContextMenu.Add(function(player, context, worldobjects)
local isSteamGen = _G.generator and (_G.generator:getModData().water or _G.generator:getSprite():getName():find('steamgenerator_01'))
	if isSteamGen then
		generator = _G.generator
		_G.generator = nil
	end
end)

local function hasSomeWater(playerInv)
	local items = playerInv:getItems()
	for i = 0, items:size() - 1 do
		local item = items:get(i)
		if item.canStoreWater and item:canStoreWater() and item.getUseDelta and item:getUseDelta() > 0.001 then
			return item
		end
	end
end

local oldOnTakeGenerator = ISWorldObjectContextMenu.onTakeGenerator
function ISWorldObjectContextMenu.onTakeGenerator(worldobjects, generator, ...)
	local ret
	if generator:getModData().water then
		local oldTakeGenerator = ISTakeGenerator
		ISTakeGenerator = ISTakeSteamGenerator
		ret = {oldOnTakeGenerator(worldobject, generator, ...)}
		ISTakeGenerator = oldTakeGenerator
		return unpack(ret)
	end
	return oldOnTakeGenerator(worldobjects, generator, ...)
end

local function onActivateSteamGenerator(worldobjects, enable, generator, player)
	local playerObj = getSpecificPlayer(player)
	if luautils.walkAdj(playerObj, generator:getSquare()) then
		ISTimedActionQueue.add(ISActivateSteamGenerator:new(player, generator, enable, 30))
	end
end



Events.OnFillWorldObjectContextMenu.Add(function(player, context, worldobjects)
	if generator then
		local playerObj = getSpecificPlayer(player)
		local playerInv = playerObj:getInventory()
		local option = context:addOption(getText("ContextMenu_GeneratorInfo"), worldobjects, ISWorldObjectContextMenu.onInfoGenerator, generator, player)
		if playerObj:DistToSquared(generator:getX() + 0.5, generator:getY() + 0.5) < 2 * 2 then
			local tooltip = ISWorldObjectContextMenu.addToolTip()
			tooltip:setName(getText('IGUI_Generator_TypeSteam'))
			tooltip.description = ISGeneratorInfoWindow.getRichText(generator, true)
			option.toolTip = tooltip
		end
-- 	TESTA UN ULTIMA VOLTA TOGLIENDO TUTTI I COMMENTI, POI PROCEDI RIGA PER RIGA
		local corpse = nil
		local primaryHandItem = playerObj:getPrimaryHandItem() 
		local secondaryHandItem = playerObj:getSecondaryHandItem() 
		if primaryHandItem and primaryHandItem == secondaryHandItem then
			 if primaryHandItem:getType() == "CorpseMale" or primaryHandItem:getType() == "CorpseFemale" then
			 	corpse = primaryHandItem 
			 end
		end
		local coalOrLogs = playerInv:getFirstTypeRecurse('Base.Charcoal') or playerInv:getFirstTypeRecurse('Base.Log')
		if generator:getFuel() < 100 then 
			if corpse then
				context:addOption(getText("ContextMenu_GeneratorAddFuel"), worldobjects, onAddCorpse, corpse, generator, playerObj)
			elseif coalOrLogs then
				context:addOption(getText("ContextMenu_GeneratorAddFuel"), worldobjects, onAddLogs, coalOrLogs, generator, playerObj)
			end
		end
		local isConnected = generator:isConnected()
		local isOn = generator:isActivated()
		local modData = generator:getModData()
		local water = modData.water or 0
		if isConnected then
			if generator:getFuel() > 0 then
				local option = context:addOption(getText('ContextMenu_Turn_' .. (isOn and 'Off' or 'On')), worldobjects, 
				onActivateSteamGenerator,
				not isOn, generator, player)
				local hasLight = playerInv:getUsesTypeRecurse('Lighter') >=1 or
								 playerInv:getUsesTypeRecurse('Matches') >=1
				if not hasLight and not isOn then
					option.notAvailable = true
					option.toolTip = ISWorldObjectContextMenu.addToolTip()
					option.toolTip.description = getText("ContextMenu_SteamGeneratorNeedFlame")
				end
			end
		elseif not isOn then
			context:addOption(getText('ContextMenu_GeneratorTake'), worldobjects, ISWorldObjectContextMenu.onTakeGenerator, generator, player)
		end
		local waterContainer = hasSomeWater(playerInv)
		if not isOn and water < 100 and waterContainer then
			context:addOption(getText('ContextMenu_GeneratorAddWater'), worldobjects, onAddWater, waterContainer, generator, playerObj)
		end
		local knowsRecipe = playerObj:isRecipeKnown('Generator')
		if not isOn and generator:getCondition() < 100 then
			local option = context:addOption(getText('ContextMenu_GeneratorFix'), worldObjects, onFixGenerator, generator, playerObj)
			local notAvailable = not knowsRecipe or not playerInv:containsTypeRecurse('ScrapMetal')
			option.notAvailable = notAvailable
			local tooltip = ISWorldObjectContextMenu.addToolTip()
			tooltip.description = getText("ContextMenu_GeneratorFixSteam")
			option.toolTip = notAvailable and tooltip or nil
		end
		if not isOn then
			local option = context:addOption(getText('ContextMenu_Generator' .. (isConnected and 'Unplug' or 'Plug')),
				worldobjects, ISWorldObjectContextMenu.onPlugGenerator, generator, player, not isConnected)
			local tooltip = ISWorldObjectContextMenu.addToolTip()
			option.notAvailable = not knowsRecipe
			tooltip.description = getText('ContextMenu_GeneratorPlugTT')
			option.toolTip = option.notAvailable and tooltip or nil
		end
	end
	generator = nil
end)

local oldSetObject = ISGeneratorInfoWindow.setObject
function ISGeneratorInfoWindow:setObject(object, ...)
	local ret = {oldSetObject(self, object, ...)}
	if object:getModData().water then
		self.panel:setName(getText("IGUI_Generator_TypeSteam"))
	end
end

local oldGetRichText = ISGeneratorInfoWindow.getRichText
function ISGeneratorInfoWindow.getRichText(object, displayStats, ...)
	local ret = {oldGetRichText(object, displayStats, ...)}
	if object:getModData().water then
		local water = string.format('%.0f', object:getModData().water or 0)
		ret[1] = getText('IGUI_Generator_Water', water) .. ' <LINE> ' .. ret[1]
	end
	return unpack(ret)
end

-- Debug set water

local function DoSetFuel(target, button, obj)
	if button.internal == 'OK' then
		local val = tonumber(button.parent.entry:getText()) or 0
		val = math.min(math.max(val, 0), 100)
		obj:getModData().water = val
		obj:transmitModData()
	end
end

local function OnGeneratorSetWater(obj)
	local modal = ISTextBox:new(0, 0, 280, 180, 'Water: (0-100)', tostring(obj:getModData().water or 0), nil, DoSetFuel, nil, obj)
	modal:initialise()
	modal:addToUIManager()
end

local function removeDuplicates(tbl)
	local ret = {}
	for _,v in ipairs(tbl) do
		ret[v] = true
	end
	tbl = {}
	for k,_ in pairs(ret) do
		table.insert(tbl, k)
	end
	return tbl
end

local oldDoDebugObjectMenu = DebugContextMenu.doDebugObjectMenu
function DebugContextMenu.doDebugObjectMenu(player, ctx, objects, ...)
	local oldGetNew = ISContextMenu.getNew
	local subMenu
	function ISContextMenu.getNew(...)
		local ret = {oldGetNew(...)}
		subMenu = ret[1]
		return unpack(ret)
	end
	local ret = {oldDoDebugObjectMenu(player, ctx, objects, ...)}
	ISContextMenu.getNew = oldGetNew
	for _,obj in ipairs(removeDuplicates(objects)) do
		if instanceof(obj, 'IsoGenerator') and obj:getTextureName():find('steamgenerator_01') then
			subMenu:addOption('Steam Generator: Set Water', obj, OnGeneratorSetWater)
		end
	end
	return unpack(ret)
end
