---@diagnostic disable: duplicate-set-field
local function calculatePowerUsage(object)
    local powerUsage = 0;
    if instanceof(object, "IsoTelevision") and object:getDeviceData():getIsTurnedOn() then
        powerUsage = 0.03;
    elseif instanceof(object, "IsoRadio") and object:getDeviceData():getIsTurnedOn() and not object:getDeviceData():getIsBatteryPowered() then
        powerUsage = 0.01;
    elseif instanceof(object, "IsoStove") and object:Activated() then
        powerUsage = 0.09;
    elseif instanceof(object, "IsoClothingDryer") and object:isActivated() then
        powerUsage = 0.09;
    elseif instanceof(object, "IsoClothingWasher") and object:isActivated() then
        powerUsage = 0.09;
    elseif instanceof(object, "IsoCombinationWasherDryer") and object:isActivated() then
        powerUsage = 0.09;
    elseif instanceof(object, "IsoStackedWasherDryer") then
        if object:isDryerActivated() then
            powerUsage = powerUsage + 0.09;
        elseif object:isWasherActivated() then
            powerUsage = powerUsage + 0.09;
        end
    end

    local hasFridgeContainer = object:getContainerByType("fridge") ~= nil;
    local hasFreezerContainer = object:getContainerByType("freezer") ~= nil;
    if hasFridgeContainer and hasFreezerContainer then
        powerUsage = 0.13;
    elseif hasFridgeContainer or hasFreezerContainer then
        powerUsage = 0.08;
    end

    if instanceof(object, "IsoLightSwitch") and object:isActivated() then
        powerUsage = 0.002;
    end
    return powerUsage;
end


local poweredObjectsByGenerator = {};
local generatorPositions = {};

local function updateHighlight(object, highlight)
    if highlight then
        object:setOutlineHighlight(true);
        object:setOutlineHlBlink(true);
        object:setOutlineHighlightCol(0.157, 0.157, 0.878, 1);
        object:setOutlineThickness(0.1);
    else
        object:setOutlineHighlight(false);
        object:setOutlineHlBlink(false);
        object:setOutlineHighlightCol(nil);
    end
end

local RANGE_SQUARED = 20 * 20;
local function onObjectAddedOrRemoved(object)
    if not object then return; end
    local square = object:getSquare();
    if not square then return; end
    local x, y, z = square:getX(), square:getY(), square:getZ();
    local powerUsage = calculatePowerUsage(object);
    local shouldHighlight = powerUsage > 0;

    for generatorKey, pos in pairs(generatorPositions) do
        local gx, gy, gz = unpack(pos);
        local distanceSquared = (gx - x) ^ 2 + (gy - y) ^ 2 + (gz - z) ^ 2;

        if distanceSquared <= RANGE_SQUARED then
            updateHighlight(object, shouldHighlight);
            local poweredObjects = poweredObjectsByGenerator[generatorKey] or {};
            poweredObjects[object] = shouldHighlight;
            poweredObjectsByGenerator[generatorKey] = poweredObjects;
            return;
        end
    end
    updateHighlight(object, false);
end
Events.OnObjectAdded.Add(onObjectAddedOrRemoved);
Events.OnTileRemoved.Add(onObjectAddedOrRemoved);
Events.OnObjectAboutToBeRemoved.Add(onObjectAddedOrRemoved);


local function highlightPoweredAppliances(worldobjects, generatorObj, player, enableHighlight)
    local cell = generatorObj:getCell();
    local square = generatorObj:getSquare();
    if not square then return; end

    local x, y, z = square:getX(), square:getY(), square:getZ();
    local generatorKey = string.format("%d_%d_%d", x, y, z);
    local range = 20;
    local zRange = 3 -- check three floors up and down

    generatorPositions[generatorKey] = { x, y, z };

    if not enableHighlight or poweredObjectsByGenerator[generatorKey] then
        for obj, _ in pairs(poweredObjectsByGenerator[generatorKey] or {}) do
            updateHighlight(obj, false);
        end
        poweredObjectsByGenerator[generatorKey] = nil;
        generatorPositions[generatorKey] = nil;
        if not enableHighlight then return; end
    end

    local newPoweredObjects = {};
    for dx = -range, range do
        for dy = -range, range do
            for dz = z - zRange, z + zRange do
                if (dx * dx + dy * dy <= RANGE_SQUARED) and dz >= 0 and dz <= 8 then
                    local gridSquare = cell:getGridSquare(x + dx, y + dy, dz);
                    if gridSquare then
                        local objects = gridSquare:getObjects();
                        for i = 0, objects:size() - 1 do
                            local object = objects:get(i);
                            if object and not instanceof(object, "IsoWorldInventoryObject") then
                                local highlight = calculatePowerUsage(object) > 0;
                                updateHighlight(object, highlight);
                                newPoweredObjects[object] = highlight;
                            end
                        end
                    end
                end
            end
        end
    end
    poweredObjectsByGenerator[generatorKey] = newPoweredObjects;
end

local function onFillWorldObjectContextMenu(player, context, worldobjects, test)
    if test then return; end
    local generatorObj = nil;
    for _, worldObj in ipairs(worldobjects) do
        if instanceof(worldObj, "IsoGenerator") then
            if worldObj:isConnected() and worldObj:isActivated() then
                generatorObj = worldObj;
                break;
            end
        end
    end

    if generatorObj then
        local x, y, z = generatorObj:getX(), generatorObj:getY(), generatorObj:getZ();
        local generatorKey = string.format("%d_%d_%d", x, y, z);
        local isHighlighted = poweredObjectsByGenerator[generatorKey] ~= nil;
        local optionText = isHighlighted and "Disable Highlight Powered Appliances" or "Highlight Powered Appliances";
        local option = context:insertOptionAfter(getText("ContextMenu_GeneratorInfo"), optionText, worldobjects,
            highlightPoweredAppliances, generatorObj, player, not isHighlighted);
        option.iconTexture = getTexture("media/ui/highlight_blue_plug.png");

        local genTurnOffContextOption = context:getOptionFromName(getText("ContextMenu_Turn_Off"));
        if genTurnOffContextOption then
            local originalSelect = genTurnOffContextOption.onSelect;
            genTurnOffContextOption.onSelect = function(...)
                originalSelect(...)
                highlightPoweredAppliances(worldobjects, generatorObj, player, false)
            end
        end
    end
end
Events.OnFillWorldObjectContextMenu.Add(onFillWorldObjectContextMenu);


local function checkPlayerDistanceAndUpdateHighlight(playerObj)
    local playerSquare = playerObj:getSquare();
    if not playerSquare then return; end

    local px, py, pz = playerSquare:getX(), playerSquare:getY(), playerSquare:getZ();

    for generatorKey, pos in pairs(generatorPositions) do
        local gx, gy, gz = unpack(pos);
        local distanceSquared = (gx - px) ^ 2 + (gy - py) ^ 2 + (gz - pz) ^ 2;

        if distanceSquared > RANGE_SQUARED * 1.5 then
            for obj, _ in pairs(poweredObjectsByGenerator[generatorKey] or {}) do
                updateHighlight(obj, false);
            end
            poweredObjectsByGenerator[generatorKey] = nil;
            generatorPositions[generatorKey] = nil;
            playerObj:Say(getText("IGUI_PlayerText_HPA_OutOfRange"));
        end
    end
end
Events.OnPlayerMove.Add(function()
    local playerObj = getPlayer();
    if #generatorPositions == 0 then return; end
    if playerObj then
        checkPlayerDistanceAndUpdateHighlight(playerObj)
    end
end)



local function wrapMethodWithPostHook(originalMethod, postHook)
    return function(...)
        local args = { ... }
        local result = originalMethod(unpack(args))
        postHook(unpack(args))
        return result
    end
end

Events.OnGameStart.Add(function()
    ISObjectClickHandler.doClickLightSwitch = wrapMethodWithPostHook(ISObjectClickHandler.doClickLightSwitch,
        function(object, playerNum, playerObj)
            onObjectAddedOrRemoved(object)
        end)

    ISToggleLightAction.perform = wrapMethodWithPostHook(ISToggleLightAction.perform, function(self)
        onObjectAddedOrRemoved(self.object)
    end)

    ISToggleStoveAction.perform = wrapMethodWithPostHook(ISToggleStoveAction.perform, function(self)
        onObjectAddedOrRemoved(self.object)
    end)

    ISInventoryPage.toggleStove = wrapMethodWithPostHook(ISInventoryPage.toggleStove, function(self)
        local object = self.inventoryPane.inventory:getParent()
        onObjectAddedOrRemoved(object)
    end)

    ISInventoryPage.syncToggleStove = wrapMethodWithPostHook(ISInventoryPage.syncToggleStove, function(self)
        local stove = self.inventoryPane.inventory:getParent()
        onObjectAddedOrRemoved(stove)
    end)

    ISWorldObjectContextMenu.onToggleThumpableLight = wrapMethodWithPostHook(
        ISWorldObjectContextMenu.onToggleThumpableLight, function(lightSource, player)
            onObjectAddedOrRemoved(lightSource)
        end)

    ISWorldObjectContextMenu.onToggleStove = wrapMethodWithPostHook(ISWorldObjectContextMenu.onToggleStove,
        function(worldobjects, stove, player)
            onObjectAddedOrRemoved(stove)
        end)

    ISWorldObjectContextMenu.onToggleLight = wrapMethodWithPostHook(ISWorldObjectContextMenu.onToggleLight,
        function(worldobjects, light, player)
            onObjectAddedOrRemoved(light)
        end)

    ISWorldObjectContextMenu.onToggleClothingDryer = wrapMethodWithPostHook(
        ISWorldObjectContextMenu.onToggleClothingDryer, function(worldobjects, object, playerId)
            onObjectAddedOrRemoved(object)
        end)

    ISWorldObjectContextMenu.onToggleClothingWasher = wrapMethodWithPostHook(
        ISWorldObjectContextMenu.onToggleClothingWasher, function(worldobjects, object, playerId)
            onObjectAddedOrRemoved(object)
        end)

    ISWorldObjectContextMenu.onToggleComboWasherDryer = wrapMethodWithPostHook(
        ISWorldObjectContextMenu.onToggleComboWasherDryer, function(playerObj, object)
            onObjectAddedOrRemoved(object)
        end)

    ISMicrowaveUI.onClick = wrapMethodWithPostHook(ISMicrowaveUI.onClick, function(self, button)
        if button.internal == "OK" then
            onObjectAddedOrRemoved(self.oven)
        end
    end)

    ISOvenUI.onClick = wrapMethodWithPostHook(ISOvenUI.onClick, function(self, button)
        if button.internal == "OK" then
            onObjectAddedOrRemoved(self.oven)
        end
    end)
end)
