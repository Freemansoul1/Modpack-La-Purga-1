require "ISUI/ISToolTip"

require "Vehicles/ISUI/ISVehicleMechanics"
require "Vehicles/ISUI/ISVehicleMenu"
require "Vehicles/ISUI/ISVehiclePartMenu"
require "Vehicles/TimedActions/ISAddGasolineToVehicle"
require "Vehicles/TimedActions/ISTakeGasolineFromVehicle"
require "Vehicles/TimedActions/ISCloseVehicleDoor"
require "Vehicles/TimedActions/ISOpenVehicleDoor"

require "TimedActions/rWaterTrailer/rTransferWater"
require "TimedActions/rWaterTrailer/rWashYourselfWithVehiclePart"

require "luautils"
require "rLib.Client"

rWaterTrailer = rWaterTrailer or {}
rWaterTrailer.Hook = rWaterTrailer.Hook or {}

-- main hooks --

local ISVM_FillPartMenu = ISVehicleMenu.FillPartMenu
function ISVehicleMenu.FillPartMenu(playerIdx, context, radial, trailer, ...)
	ISVM_FillPartMenu(playerIdx, context, radial, trailer, ...)

	local tank = rWaterTrailer.GetWaterStorage(trailer)
	if not tank then
		return
	end

	local player = getSpecificPlayer(playerIdx)
	local playerItems = player:getInventory():getItems() -- non-recursive, aka main inventory only --

	rWaterTrailer.Hook.FillPartMenu(player, playerItems, trailer, tank, context, radial)
end

local ISVM_doTowingMenu = ISVehicleMenu.doTowingMenu
function ISVehicleMenu.doTowingMenu(player, trailer, radial, ...)
	ISVM_doTowingMenu(player, trailer, radial, ...)

	local tank = rWaterTrailer.GetWaterStorage(trailer)
	if not tank then
		return
	end

	local playerItems = player:getInventory():getItems() -- non-recursive, aka main inventory only --

	rWaterTrailer.Hook.DoTowingMenu(player, playerItems, trailer, tank, radial)
end

local ISVM_renderPartDetail = ISVehicleMechanics.renderPartDetail
function ISVehicleMechanics:renderPartDetail(part, ...)
	local vehicle = part:getVehicle()
	local tank = rWaterTrailer.GetWaterStorage(vehicle)
	if tank and part:getId() == tank:getId() then
		local x = self.xCarTexOffset + (self.width - 10 - self.xCarTexOffset) / 2;
		local y = self:titleBarHeight() + 10 + getTextManager():getFontHeight(UIFont.Medium) + 5;

		rWaterTrailer.Hook.RenderPartDetail(self, vehicle, part, x, y, getTextManager():getFontHeight(UIFont.Small))
	else
		ISVM_renderPartDetail(self, part, ...)
	end
end

---

function rWaterTrailer.Hook.FillPartMenu(player, playerItems, trailer, tank, context, radial)
	local item = nil

	local contextOption
	local contextMenu
	local waterToTank = {}
	local waterToItem = {}

	local lid = trailer:getPartById("WaterTankLid")

	if lid and lid:getInventoryItem() then
		if radial then
			radial:addSlice(getText(lid:getDoor():isOpen() and getText("ContextMenu_Close_TankLid") or getText("ContextMenu_Open_TankLid")), getTexture("media/ui/rWaterTrailer/vehicle_tank_lid.png"), rWaterTrailer.OnLidOpenClose, player, trailer, lid)
		elseif context then
			context:addOption(getText(lid:getDoor():isOpen() and getText("ContextMenu_Close_TankLid") or getText("ContextMenu_Open_TankLid")), player, rWaterTrailer.OnLidOpenClose, trailer, lid)
		end
	end

	if tank:getContainerContentAmount() < tank:getContainerCapacity() then -- tank not full --
		if rWaterTrailer.IsNearRiver(trailer) then
			if radial then
				radial:addSlice(getText("ContextMenu_Add_Water_To_Trailer"), getTexture("media/ui/rWaterTrailer/vehicle_water_pump.png"), rWaterTrailer.OnTransferWater, player, trailer, tank, "<-", "void", tank:getArea())
			elseif context then
				context:addOption(getText("ContextMenu_Add_Water_To_Trailer"), player, rWaterTrailer.OnTransferWater, trailer, tank, "<-", "void", tank:getArea())
			end
		end

		for idx = 0,playerItems:size()-1 do
			item = playerItems:get(idx)
			if rWaterTrailer.IsWaterItemState(item, "not empty") then
				table.insert(waterToTank, item)
			end
		end
	end

	if tank:getContainerContentAmount() > 0 then -- tank not empty --
		if radial then
			radial:addSlice(getText("ContextMenu_Drain_Tank"), getTexture("media/ui/rWaterTrailer/vehicle_drain_tank.png"), rWaterTrailer.OnTransferWater, player, trailer, tank, "->", "void", tank:getArea())
		elseif context then
			context:addOption(getText("ContextMenu_Drain_Tank"), player, rWaterTrailer.OnTransferWater, trailer, tank, "->", "void", tank:getArea())
		end

		if rLib.Washing.GetBloodAndDirt(player) > 0 then
			local soapList = rLib.Washing.GetSoapItems(player)

			if radial then
				local washTexture = "media/ui/rWaterTrailer/vehicle_wash_yourself_" .. player:getHumanVisual():getSkinTextureIndex() .. ".png"
				radial:addSlice(getText("ContextMenu_Wash") .. " " .. getText("ContextMenu_Yourself"), getTexture(washTexture), rWaterTrailer.OnWashYourself, player, trailer, tank, soapList)
			elseif context then
				context:addOption(getText("ContextMenu_Wash") .. " " .. getText("ContextMenu_Yourself"), player, rWaterTrailer.OnWashYourself, trailer, tank, soapList)
			end
		end

		if rWaterTrailer.IsTankWaterDrinkable(trailer, tank) then
			local waterNeed = math.floor((player:getStats():getThirst() + 0.005) / 0.1)
			local waterHave = math.min(waterNeed, tank:getContainerContentAmount())
			rLib.dhalo(player, "waterNeed=%d waterHave=%d", waterNeed, waterHave)

			if waterHave > 0 then
				if radial then
					radial:addSlice(getText("Drink"), getTexture("media/ui/rWaterTrailer/vehicle_faucet.png"), rWaterTrailer.OnTransferWater, player, trailer, tank, "->", player, tank:getArea())
				else
					context:addOption(getText("Drink"), player, rWaterTrailer.OnTransferWater, trailer, tank, "->", player, tank:getArea())
				end
			end
		end

		for idx = 0,playerItems:size()-1 do
			item = playerItems:get(idx)
			if rWaterTrailer.IsWaterItemState(item, "not full") or rWaterTrailer.IsWaterItemState(item, "empty") then
				table.insert(waterToItem, item)
			end
		end
	end

	if #waterToItem > 0 then
		if radial then
			local text = getText("ContextMenu_VehicleAddWaterToItem")
			local texture = getTexture("media/ui/rWaterTrailer/vehicle_take_water.png")
			local func = rWaterTrailer.OnRadialSubMenu

			if #waterToItem == 1 then
				waterToItem = waterToItem[1]
				text = getText("ContextMenu_Fill") .. waterToItem:getName() .. getText("ContextMenu_VehicleAddWaterToSingleItem")
				texture = waterToItem:getTexture()
				func = rWaterTrailer.OnTransferWater
			end

			radial:addSlice(text, texture, func, player, trailer, tank, "->", waterToItem)
		elseif context then
			contextOption = context:addOption(getText("ContextMenu_Fill"), player, nil)
			contextMenu = ISContextMenu:getNew(context)
			context:addSubMenu(contextOption, contextMenu)

			for idx,item in ipairs(waterToItem) do
				rWaterTrailer.SetWaterTooltip(contextMenu:addOption(item:getName(), player, rWaterTrailer.OnTransferWater, trailer, tank, "->", item), item)
			end
		end
	end

	if #waterToTank > 0 then
		if radial then
			local text = getText("ContextMenu_AddWaterFromItem")
			local texture = getTexture("media/ui/rWaterTrailer/vehicle_add_water.png")
			local func = rWaterTrailer.OnRadialSubMenu

			if #waterToTank == 1 then
				waterToTank = waterToTank[1]
				text = getText("ContextMenu_VehicleAddSingleWater") .. waterToTank:getName()
				texture = waterToTank:getTexture()
				func = rWaterTrailer.OnTransferWater
			end

			radial:addSlice(text, texture, func, player, trailer, tank, "<-", waterToTank)
		elseif context then
			contextOption = context:addOption(luautils.trim(getText("ContextMenu_AddWaterFromItem")), player, nil)
			contextMenu = ISContextMenu:getNew(context)
			context:addSubMenu(contextOption, contextMenu)

			for idx,item in ipairs(waterToTank) do
				rWaterTrailer.SetWaterTooltip(contextMenu:addOption(item:getName(), player, rWaterTrailer.OnTransferWater, trailer, tank, "<-", item), item)
			end
		end
	end
end

function rWaterTrailer.Hook.DoTowingMenu(player, playerItems, trailer, tank, radial)
	-- ISVehicleMenu.showRadialMenuOutside() thinks trunks lids on small trailer are doors, due to custom parts names --

	if radial and radial.slices then
		for idx,slice in ipairs(radial.slices) do
			if slice.text == getText("ContextMenu_Open_door") then
				radial:setSliceText(idx, getText("IGUI_OpenTrunk"))
			elseif slice.text == getText("ContextMenu_Close_door") then
				radial:setSliceText(idx, getText("IGUI_CloseTrunk"))
			elseif slice.text == getText("ContextMenu_LockDoor") then
				radial:setSliceText(idx, getText("IGUI_LockTrunk"))
			end
		end
	end
end

function rWaterTrailer.Hook.RenderPartDetail(ui, trailer, tank, x, y, h)
	-- just like vanilla (except debug mode string) --

	local capacity = ui:roundContainerContentAmount(tank) .. " / " .. tank:getContainerCapacity();
	if tank:getItemContainer() then
		capacity = round(tank:getItemContainer():getCapacityWeight(), 2) .. " / " .. tank:getContainerCapacity(self.chr);
	end
	local label = getTextOrNull("IGUI_Vehicle_ContainerCapacity_" .. tank:getContainerContentType(), capacity)
	if not label then
		label = getText("IGUI_Vehicle_ContainerCapacity_Other", tank:getContainerContentType(), capacity)
	end
	if round(tank:getContainerContentAmount(), 2) < 5 then
		ui:drawText(label, x, y, 1, 0, 0, 1);
	else
		ui:drawText(label, x, y, 1, 1, 1, 1);
	end
	y = y + h;

	-- custom --

	if tank:getModData().Tainted then
		ui:drawText(getText("Tooltip_item_TaintedWater"), x, y, 1, 0.5, 0.5, 1) -- not so sure about that, it might look meh in other langs --
		y = y + h * 2
	else
		ui:drawText(getText("Tooltip_item_DrinkableWater"), x, y, 1, 1, 1, 1) -- hmm --
		y = y + h
	end
end

---

function rWaterTrailer.Find(square, distance)
	for y = square:getY() - distance, square:getY() + distance do
		for x = square:getX() - distance, square:getX() + distance do
			local otherSquare = getCell():getGridSquare(x, y, square:getZ())
			if otherSquare then
				for i=0, otherSquare:getMovingObjects():size()-1 do
					local object = otherSquare:getMovingObjects():get(i)
					local tank = rWaterTrailer.GetWaterStorage(object)
					if object and tank then
						return object
					end
				end
			end
		end
	end
end

function rWaterTrailer.GetWaterStorage(trailer)
	if not trailer or not instanceof(trailer, "BaseVehicle") then
		return nil
	end

	for i=0, trailer:getPartCount()-1 do
		local part = trailer:getPartByIndex(i)
		local category = part:getCategory() or "NOT A CAT"
		if category == "watertank" and part:getInventoryItem() and part:isContainer() and part:getContainerContentType() == "Water Storage" then
			return part
		end
	end

	return nil
end

function rWaterTrailer.GetWaterFilter(trailer)
	if not trailer or not instanceof(trailer, "BaseVehicle") then
		return nil
	end

	local filter = trailer:getPartById("WaterTankFilter")
	if not filter or not filter:getInventoryItem() then
		return nil
	end

	return filter
end

function rWaterTrailer.GetPumpRange(trailer)
	return 6
end

function rWaterTrailer.GetSquares(trailer, mode, param)
	local squares = {}
	if mode ~= nil and mode ~= "" and param ~= nil then
		local trailerSquare = trailer:getCurrentSquare()

		if mode == "range" then -- param=distance
			for y = trailerSquare:getY() - param, trailerSquare:getY() + param do
				for x=trailerSquare:getX() - param, trailerSquare:getX()+ param do
					local square = getCell():getGridSquare(x, y, trailerSquare:getZ())
					if square then
						table.insert(squares, square)
					end
				end
			end
		end
		if getDebug() then
			--print("GetSquares:" .. mode .. "," .. param .. " = " .. #squares)
		end
	end

	return squares
end

function rWaterTrailer.GetSquaresClosest(targetSquare, squares) -- TODO rLib --
	local closest = nil
	local closestDist = 1000000
	for _,square in ipairs(squares) do
		local dist = IsoUtils.DistanceTo(targetSquare:getX(), targetSquare:getY(), square:getX() + 0.5, square:getY() + 0.5)
		if dist < closestDist then
			closest = square
			closestDist = dist
		end
	end

	return closest
end

function rWaterTrailer.GetSquaresRiver(trailer)
	function isWater(square)
		return square ~= nil and square:Is(IsoFlagType.water)
	end

	local result = {}
	local squares = rWaterTrailer.GetSquares(trailer, "range", rWaterTrailer.GetPumpRange(trailer))
	for _,square in ipairs(squares) do
		if isWater(square) then
			table.insert(result, square)
		end
	end

	return result
end

function rWaterTrailer.GetSquaresBarrels(trailer)
	function isBarrel(object)
		if not object then
			return false
		end
		if not instanceof(object, "IsoThumpable") then
			return false
		end
		if object:getWaterMax() <= 0 then
			return false
		end

		local prop = object:getProperties()

		if prop and prop:Val("GroupName") == "Water" and prop:Val("CustomName") == "Dispenser" then
			return false
		end

		return true
	end

	local resultSquares = {}
	local resultBarrels = {}
	local squares = rWaterTrailer.GetSquares(trailer, "range", rWaterTrailer.GetPumpRange(trailer))
	for _,square in ipairs(squares) do
		local objects = square:getObjects()
		for o=0, objects:size()-1 do
			local object = objects:get(o)
			if isBarrel(object) then
				table.insert(resultSquares, square)
				table.insert(resultBarrels, object)
			end
		end
	end

	return resultSquares, resultBarrels
end

function rWaterTrailer.SetWaterTooltip(option, item)
	if not instanceof(item, "DrainableComboItem") then
		return
	end

	local tooltip = ISToolTip:new()
	local tx = getTextManager():MeasureStringX(tooltip.font, getText("ContextMenu_WaterName") .. ":") + 20
	tooltip.description = string.format("%s: <SETX:%d> %d / %d", getText("ContextMenu_WaterName"), tx, item:getDrainableUsesInt(), 1.0 / item:getUseDelta() + 0.0001)
	if item:isWaterSource() and item:isTaintedWater() then
		tooltip.description = tooltip.description .. " <BR> <RGB:1,0.5,0.5>" .. getText("Tooltip_item_TaintedWater")
	end

	option.toolTip = tooltip
end

function rWaterTrailer.IsNearRiver(trailer)
	local squares = rWaterTrailer.GetSquaresRiver(trailer)

	return #squares > 0
end

function rWaterTrailer.IsNearBarrels(trailer)
	local squares, barrels = rWaterTrailer.GetSquaresBarrels(trailer)

	return #squares > 0 and #barrels > 0
end

function rWaterTrailer.IsLidOpen(trailer)
	if not rWaterTrailer.GetWaterStorage(trailer) then
		return nil
	end

	if trailer:getPartById("WaterTankLid"):getInventoryItem() then
		return lid:getDoor():isOpen()
	end

	return true
end

function rWaterTrailer.IsTankWaterDrinkable(vehicle, tank)
	if tank:getContainerContentAmount() <= 0 then
		return false
	end

	if tank:getModData().Tainted then
		local filter = rWaterTrailer.GetWaterFilter(vehicle)
		if not filter or filter:getCondition() <= 0 then
			return false
		end
	end

	return true
end

function rWaterTrailer.IsWaterItemState(item, state) -- because i don't want to research this again, ever --
	if item == nil or state == nil then
		return false
	end

	if state == "empty" and item:canStoreWater() and not item:isWaterSource() and not item:isBroken() then
		return true
	elseif state == "not empty" and item:IsDrainable() and item:canStoreWater() and item:isWaterSource() and not item:isBroken() then
		return true
	elseif state == "not full" and item:IsDrainable() and item:canStoreWater() and item:isWaterSource() and not item:isBroken() and item:getUsedDelta() < 1 then
		return true
	elseif state == "full" and item:IsDrainable() and item:canStoreWater() and item:isWaterSource() and not item:isBroken() and item:getUsedDelta() == 1 then
		return true
	end

	return false
end

function rWaterTrailer.WalkToTarget(player, trailer, target, onFail)
	if instanceof(target, "IsoThumpable") then
		if not luautils.walkAdj(player, item:getSquare(), true) then
			rLib.dhalo(player, "WalkToTarget : walkAdj fail")
			return false
		else
			rLib.dhalo(player, "WalkToTarget : walkAdj")
		end
	elseif type(target) == "string" then
		rLib.dhalo(player, "WalkToTarget : pathToVehicleArea : %s", target)
		local action = ISPathFindAction:pathToVehicleArea(player, trailer, target)
		if onFail then
			action:setOnFail(onFail, player)
		end
		ISTimedActionQueue.add(action)
	else
		rLib.dhalo(player, "WalkToTarget : ???")
		target = rWaterTrailer.GetWaterStorage(trailer)
		rWaterTrailer.WalkToTarget(player, trailer, target:getArea(), onFail)
	end
end

rWaterTrailer.DebugMarkers = {}
function rWaterTrailer.OnLidOpenClose(player, trailer, lid)
	if player:getVehicle() then
		ISVehicleMenu.onExit(player)
	end

	-- tank lid is locked
	if lid:getDoor():isLocked() then
		rWaterTrailer.WalkToTarget(player, trailer, lid:getArea())
		ISTimedActionQueue.add(ISUnlockVehicleDoor:new(player, lid))
		return
	end

	if lid:getDoor():isOpen() then
		rWaterTrailer.WalkToTarget(player, trailer, lid:getArea())
		ISTimedActionQueue.add(ISCloseVehicleDoor:new(player, trailer, lid))

		if getDebug() then
			for _,marker in ipairs(rWaterTrailer.DebugMarkers) do
				getWorldMarkers():removeGridSquareMarker(marker);
			end
		end
	else
		rWaterTrailer.WalkToTarget(player, trailer, lid:getArea())
		ISTimedActionQueue.add(ISOpenVehicleDoor:new(player, trailer, lid))

		if getDebug() then -- TODO rLib --
			function addMarker(square, r, g, b)
				local marker = getWorldMarkers():addGridSquareMarker(square, r, g, b, true, 0.5)
				marker:setScaleCircleTexture(true);
				table.insert(rWaterTrailer.DebugMarkers, marker)
			end

			local riverSquares = rWaterTrailer.GetSquaresRiver(trailer)
			for _,square in ipairs(riverSquares) do
				addMarker(square, 0, 0, 0.5)
			end
			local barrelSquares, barrels = rWaterTrailer.GetSquaresBarrels(trailer)
			for _,square in ipairs(barrelSquares) do
				addMarker(square, 0, 0.5, 0)
			end

			rLib.dprint("riverSquares=%d barrelSquares=%d", #riverSquares, #barrelSquares)
		end
	end
end

function rWaterTrailer.OnRadialSubMenu(player, trailer, tank, flow, items)
	local radial = getPlayerRadialMenu(player:getPlayerNum())

	radial:clear()
	radial:addSlice(getText("IGUI_Emote_Back"), getTexture("media/ui/emotes/back.png"), rLib.UI.UpdateAndCall, ISVehicleMenu.showRadialMenu, player)

	for _,item in ipairs(items) do
		radial:addSlice(item:getName(), item:getTexture(), rWaterTrailer.OnTransferWater, player, trailer, tank, flow, item)
	end

	radial:center()
	radial:addToUIManager()
end

function rWaterTrailer.OnTransferWater(player, trailer, tank, flow, item, area)
	if player:getVehicle() then
		ISVehicleMenu.onExit(player)
	end

	if tank and flow and item then
		rWaterTrailer.WalkToTarget(player, trailer, area or item)
		if item and (instanceof(item, "DrainableComboItem") or instanceof(item, "InventoryItem")) then
			ISVehiclePartMenu.toPlayerInventory(player, item)
		end
		ISTimedActionQueue.add(rTransferWater:new(player, tank, flow, item))
	end
end

function rWaterTrailer.OnWashYourself(player, trailer, tank, soapList)
	if player:getVehicle() then
		ISVehicleMenu.onExit(player)
	end

	if tank then
		rWaterTrailer.WalkToTarget(player, trailer, tank:getArea())
		ISTimedActionQueue.add(rWashYourselfWithVehiclePart:new(player, trailer, tank, soapList))
	end
end

--- Sync Tail Lights ---

function rWaterTrailer.ToggleHeadlights(player, vehicle)
	assert(instanceof(player, "IsoPlayer"))
	assert(instanceof(vehicle, "BaseVehicle"))

	local trailer = vehicle:getVehicleTowing()
	if not trailer or trailer:getScript():getFullName() ~= "Rotators.TrailerWaterSmall" then
		return
	end

	rLib.Commands.SendToServer(player, "SetVehicleHeadlights", {vehicleId = trailer:getId(), set = not vehicle:getHeadlightsOn()}, true)
end

function rWaterTrailer.AttachDetachVehicle(player, vehicleA, vehicleB)
	assert(instanceof(player, "IsoPlayer"))
	assert(instanceof(vehicleA, "BaseVehicle"))
	assert(instanceof(vehicleB, "BaseVehicle"))

	if vehicleB:getScript():getFullName() ~= "Rotators.TrailerWaterSmall" then
		return
	end

	local batteryPart = vehicleA:getPartById("Battery")
	if batteryPart then
		local batteryInv = batteryPart:getInventoryItem()
		local batteryVar = batteryInv and batteryInv:getUsedDelta() or 0
		if batteryInv and batteryVar > 0 then
			rLib.Commands.SendToServer(player, "SetVehicleBattery",
			{
				vehicleId = vehicleB:getId(),
				battery = rLib.Events.Current == "Vehicle.AttachVehicle" and batteryVar or 0
			}, true)
		end
	end

	rLib.Commands.SendToServer(player, "SetVehicleHeadlights",
	{
		vehicleId = vehicleB:getId(),
		set = rLib.Events.Current == "Vehicle.AttachVehicle" and vehicleA:getHeadlightsOn() or false
	}, true)
end

rLib.Events.On("Vehicle.ToggleHeadlights", rWaterTrailer.ToggleHeadlights)
rLib.Events.On("Vehicle.AttachVehicle", rWaterTrailer.AttachDetachVehicle)
rLib.Events.On("Vehicle.DetachVehicle", rWaterTrailer.AttachDetachVehicle)
