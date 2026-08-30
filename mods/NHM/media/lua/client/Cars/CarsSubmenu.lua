CarContextMenu = {};

local function removeDuplicates(list)
    local result = {}
    local seen = {}
    for _, item in ipairs(list) do
        if not seen[item] then
            seen[item] = true
            table.insert(result, item)
        end
    end
    return result
end

local function CheckMainInventory(playerObj, checkItem)
    local items = playerObj:getInventory():getAllTypeRecurse(checkItem)
    return items:size()
end

local function predicateBlowTorch(item)
    return item:getType() == "BlowTorch"
end

local function comparatorDrainableUsesInt(item1, item2)
    return item1:getDrainableUsesInt() - item2:getDrainableUsesInt()
end

local function getBlowTorch(playerInv)
    if (playerInv:containsTypeRecurse("BlowTorch") and playerInv:containsEvalRecurse(predicateBlowTorch)) then
        return playerInv:getBestTypeEvalRecurse("Base.BlowTorch", comparatorDrainableUsesInt)
    end

    return nil
end

local function predicateWeldingMask(item)
    return item:getType() == "WeldingMask"
end

local function getWeldingMask(playerInv)
    if (playerInv:containsTypeRecurse("WeldingMask") and playerInv:containsEvalRecurse(predicateWeldingMask)) then
        return playerInv:getItemFromType("WeldingMask", true, true)
    end

    return nil
end

CarContextMenu.doMenu = function(player, context, worldobjects, test)

    local function CarCraftInit(playerObj, materials, skills, CarOption, CarTooltip)

        local BlowTorch = getBlowTorch(playerObj:getInventory())
        if BlowTorch == nil then
            CarTooltip.description = CarTooltip.description .. " <RGB:1,0,0>" .. getItemNameFromFullType("Base.BlowTorch") .. " " .. getText("ContextMenu_Consuming") .. " 0/100" .. " \n";
            CarOption.onSelect = nil;
            CarOption.notAvailable = true;
        elseif BlowTorch ~= nil and BlowTorch:getDrainableUsesInt() < 100 then
            CarTooltip.description = CarTooltip.description .. " <RGB:1,0,0>" .. getItemNameFromFullType("Base.BlowTorch") .. " " .. getText("ContextMenu_Consuming") .. " " .. tostring(BlowTorch:getDrainableUsesInt()) .. "/100" .. " \n";
            CarOption.onSelect = nil;
            CarOption.notAvailable = true;
        else
            CarTooltip.description = CarTooltip.description .. " <RGB:0,1,0>" .. getItemNameFromFullType("Base.BlowTorch") .. " " .. getText("ContextMenu_Consuming") .. " 100/100" .. " \n";
        end

        local WeldingMask = getWeldingMask(playerObj:getInventory())
        if WeldingMask == nil then
            CarTooltip.description = CarTooltip.description .. " <RGB:1,0,0>" .. getItemNameFromFullType("Base.WeldingMask") .. " " .. "0/1" .. " \n";
            CarOption.onSelect = nil;
            CarOption.notAvailable = true;
        else
            CarTooltip.description = CarTooltip.description .. " <RGB:0,1,0>" .. getItemNameFromFullType("Base.WeldingMask") .. " " .. "1/1" .. " \n";
        end

        for i = 1, #materials do
            if CheckMainInventory(playerObj, materials[i][1]) < materials[i][2] then
                CarTooltip.description = CarTooltip.description .. " <RGB:1,0,0>" .. getItemNameFromFullType(tostring("Base." .. materials[i][1])) .. " " .. tostring(CheckMainInventory(playerObj, materials[i][1])) .. "/" .. tostring(materials[i][2]) .. " \n";
                CarOption.onSelect = nil;
                CarOption.notAvailable = true;
            else
                CarTooltip.description = CarTooltip.description .. " <RGB:0,1,0>" .. getItemNameFromFullType(tostring("Base." .. materials[i][1])) .. " " .. tostring(CheckMainInventory(playerObj, materials[i][1])) .. "/" .. tostring(materials[i][2]) .. " \n";
            end
        end

        CarTooltip.description = CarTooltip.description .. "<LINE>"

        for i = 1, #skills do
            if playerObj:getPerkLevel(skills[i][1]) < skills[i][2] then
                CarTooltip.description = CarTooltip.description .. " <RGB:1,0,0>" .. getText("IGUI_perks_" .. tostring(skills[i][1])) .. " " .. tostring(playerObj:getPerkLevel(skills[i][1])) .. "/" .. tostring(skills[i][2]) .. " \n";
                CarOption.onSelect = nil;
                CarOption.notAvailable = true;
            else
                CarTooltip.description = CarTooltip.description .. " <RGB:0,1,0>" .. getText("IGUI_perks_" .. tostring(skills[i][1])) .. " " .. tostring(playerObj:getPerkLevel(skills[i][1])) .. "/" .. tostring(skills[i][2]) .. " \n";
            end
        end

    end

    if test and ISWorldObjectContextMenu.Test then
        return true
    end

    if not getBlowTorch(getPlayer():getInventory()) then
        return
    end

    local square = nil;
    for i, v in ipairs(worldobjects) do
        square = v:getSquare();
        break ;
    end

    for i = 1, square:getObjects():size() do
        table.insert(worldobjects, square:getObjects():get(i - 1))
    end
    worldobjects = removeDuplicates(worldobjects)

    local playerObj = getSpecificPlayer(player)

    local debugOption = context:addOption(getText("ContextMenu_CraftCar"), worldobjects, nil);

    local subMenu = ISContextMenu:getNew(context);
    context:addSubMenu(debugOption, subMenu);

    local CarNormalOption = subMenu:addOption(getText("IGUI_VehicleNameCarNormal"), playerObj, CarContextMenu.onSpawnCarNormal);
    local CarNormalTooltip = ISWorldObjectContextMenu.addToolTip()
    CarNormalTooltip:setName(getText("IGUI_VehicleNameCarNormal"))
    CarNormalTooltip.description = getText("ContextMenu_CarNormalDesc") .. " <LINE><LINE> " .. getText("ContextMenu_CarNeeds") .. ": <LINE>"
    CarNormalTooltip:setTexture("chevalier_nyala");
    CarNormalOption.toolTip = CarNormalTooltip
    local CarNormalMaterials = { { 'SheetMetal', 10 }, { 'MetalPipe', 10 } }
    local CarNormalSkills = { { Perks.Mechanics, 8 }, { Perks.MetalWelding, 6 } }
    CarCraftInit(playerObj, CarNormalMaterials, CarNormalSkills, CarNormalOption, CarNormalTooltip)

    local   SmallCarOption = subMenu:addOption(getText("IGUI_VehicleNameSmallCar"), playerObj, CarContextMenu.onSpawnSmallCar);
    local SmallCarTooltip = ISWorldObjectContextMenu.addToolTip()
    SmallCarTooltip:setName(getText("IGUI_VehicleNameSmallCar"))
    SmallCarTooltip.description = getText("ContextMenu_CarSmallDesc") .. " <LINE><LINE> " .. getText("ContextMenu_CarNeeds") .. ": <LINE>"
    SmallCarTooltip:setTexture("chevalier_dart");
    SmallCarOption.toolTip = SmallCarTooltip
    local SmallCarMaterials = { { 'SheetMetal', 10 }, { 'MetalPipe', 10 } }
    local SmallCarSkills = { { Perks.Mechanics, 8 }, { Perks.MetalWelding, 6 } }
    CarCraftInit(playerObj, SmallCarMaterials, SmallCarSkills, SmallCarOption, SmallCarTooltip)

    local CarStationWagonOption = subMenu:addOption(getText("IGUI_VehicleNameCarStationWagon"), playerObj, CarContextMenu.onSpawnCarStationWagon);
    local CarStationWagonTooltip = ISWorldObjectContextMenu.addToolTip()
    CarStationWagonTooltip:setName(getText("IGUI_VehicleNameCarStationWagon"))
    CarStationWagonTooltip.description = getText("ContextMenu_CarStationWagonDesc") .. " <LINE><LINE> " .. getText("ContextMenu_CarNeeds") .. ": <LINE>"
    CarStationWagonTooltip:setTexture("chevalier_cerice_wagon");
    CarStationWagonOption.toolTip = CarStationWagonTooltip
    local CarStationWagonMaterials = { { 'SheetMetal', 10 }, { 'MetalPipe', 10 } }
    local CarStationWagonSkills = { { Perks.Mechanics, 8 }, { Perks.MetalWelding, 6 } }
    CarCraftInit(playerObj, CarStationWagonMaterials, CarStationWagonSkills, CarStationWagonOption, CarStationWagonTooltip)

    local PickUpTruckOption = subMenu:addOption(getText("IGUI_VehicleNamePickUpTruck"), playerObj, CarContextMenu.onSpawnPickUpTruck);
    local PickUpTruckTooltip = ISWorldObjectContextMenu.addToolTip()
    PickUpTruckTooltip:setName(getText("IGUI_VehicleNamePickUpTruck"))
    PickUpTruckTooltip.description = getText("ContextMenu_CarPickUpTruckDesc") .. " <LINE><LINE> " .. getText("ContextMenu_CarNeeds") .. ": <LINE>"
    PickUpTruckTooltip:setTexture("chevalier_d6");
    PickUpTruckOption.toolTip = PickUpTruckTooltip
    local PickUpTruckMaterials = { { 'SheetMetal', 10 }, { 'MetalPipe', 10 } }
    local PickUpTruckSkills = { { Perks.Mechanics, 10 }, { Perks.MetalWelding, 8 } }
    CarCraftInit(playerObj, PickUpTruckMaterials, PickUpTruckSkills, PickUpTruckOption, PickUpTruckTooltip)

    local PickUpVanOption = subMenu:addOption(getText("IGUI_VehicleNamePickUpVan"), playerObj, CarContextMenu.onSpawnPickUpVan);
    local PickUpVanTooltip = ISWorldObjectContextMenu.addToolTip()
    PickUpVanTooltip:setName(getText("IGUI_VehicleNamePickUpVan"))
    PickUpVanTooltip.description = getText("ContextMenu_CarPickUpVanDesc") .. " <LINE><LINE> " .. getText("ContextMenu_CarNeeds") .. ": <LINE>"
    PickUpVanTooltip:setTexture("dash_bulldriver");
    PickUpVanOption.toolTip = PickUpVanTooltip
    local PickUpVanMaterials = { { 'SheetMetal', 10 }, { 'MetalPipe', 10 } }
    local PickUpVanSkills = { { Perks.Mechanics, 10 }, { Perks.MetalWelding, 8 } }
    CarCraftInit(playerObj, PickUpVanMaterials, PickUpVanSkills, PickUpVanOption, PickUpVanTooltip)

    if playerObj:isOutside() == false then

        debugOption.onSelect = nil;
        debugOption.notAvailable = true;

        CarNormalOption.onSelect = nil;
        CarNormalOption.notAvailable = true;
        CarNormalTooltip.description = CarNormalTooltip.description .. "<LINE><LINE> <RGB:1,0,0>" .. getText("ContextMenu_CarOutside");

        SmallCarOption.onSelect = nil;
        SmallCarOption.notAvailable = true;
        SmallCarTooltip.description = SmallCarTooltip.description .. "<LINE><LINE> <RGB:1,0,0>" .. getText("ContextMenu_CarOutside");

        CarStationWagonOption.onSelect = nil;
        CarStationWagonOption.notAvailable = true;
        CarStationWagonTooltip.description = CarStationWagonTooltip.description .. "<LINE><LINE> <RGB:1,0,0>" .. getText("ContextMenu_CarOutside");

        PickUpTruckOption.onSelect = nil;
        PickUpTruckOption.notAvailable = true;
        PickUpTruckTooltip.description = PickUpTruckTooltip.description .. "<LINE><LINE> <RGB:1,0,0>" .. getText("ContextMenu_CarOutside");

        PickUpVanOption.onSelect = nil;
        PickUpVanOption.notAvailable = true;
        PickUpVanTooltip.description = PickUpVanTooltip.description .. "<LINE><LINE> <RGB:1,0,0>" .. getText("ContextMenu_CarOutside");

    end

end
Events.OnFillWorldObjectContextMenu.Add(CarContextMenu.doMenu);

CarContextMenu.onSpawnCarNormal = function(playerObj)

    local CarMaterials = { { 'SheetMetal', 10 }, { 'MetalPipe', 10 } }

    local WeldingMask = getWeldingMask(playerObj:getInventory())
    local BlowTorch = getBlowTorch(playerObj:getInventory())

    if WeldingMask ~= nil and BlowTorch ~= nil then
        ISInventoryPaneContextMenu.wearItem(WeldingMask, playerObj:getPlayerNum())
        ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), BlowTorch, true, true)
    end

    ISTimedActionQueue.add(CraftVehicleAction:new(playerObj, CarMaterials, BlowTorch, 1000, "Base.CarNormal"))

end

CarContextMenu.onSpawnSmallCar = function(playerObj)

    local CarMaterials = { { 'SheetMetal', 10 }, { 'MetalPipe', 10 } }

    local WeldingMask = getWeldingMask(playerObj:getInventory())
    local BlowTorch = getBlowTorch(playerObj:getInventory())

    if WeldingMask ~= nil and BlowTorch ~= nil then
        ISInventoryPaneContextMenu.wearItem(WeldingMask, playerObj:getPlayerNum())
        ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), BlowTorch, true, true)
    end

    ISTimedActionQueue.add(CraftVehicleAction:new(playerObj, CarMaterials, BlowTorch, 1000, "Base.SmallCar"))

end

CarContextMenu.onSpawnCarStationWagon = function(playerObj)

    local CarMaterials = { { 'SheetMetal', 10 }, { 'MetalPipe', 10 } }

    local WeldingMask = getWeldingMask(playerObj:getInventory())
    local BlowTorch = getBlowTorch(playerObj:getInventory())

    if WeldingMask ~= nil and BlowTorch ~= nil then
        ISInventoryPaneContextMenu.wearItem(WeldingMask, playerObj:getPlayerNum())
        ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), BlowTorch, true, true)
    end

    ISTimedActionQueue.add(CraftVehicleAction:new(playerObj, CarMaterials, BlowTorch, 1000, "Base.CarStationWagon"))

end

CarContextMenu.onSpawnPickUpTruck = function(playerObj)

    local CarMaterials = { { 'SheetMetal', 10 }, { 'MetalPipe', 10 } }

    local WeldingMask = getWeldingMask(playerObj:getInventory())
    local BlowTorch = getBlowTorch(playerObj:getInventory())

    if WeldingMask ~= nil and BlowTorch ~= nil then
        ISInventoryPaneContextMenu.wearItem(WeldingMask, playerObj:getPlayerNum())
        ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), BlowTorch, true, true)
    end

    ISTimedActionQueue.add(CraftVehicleAction:new(playerObj, CarMaterials, BlowTorch, 1000, "Base.PickUpTruck"))

end

CarContextMenu.onSpawnPickUpVan = function(playerObj)

    local CarMaterials = { { 'SheetMetal', 10 }, { 'MetalPipe', 10 } }

    local WeldingMask = getWeldingMask(playerObj:getInventory())
    local BlowTorch = getBlowTorch(playerObj:getInventory())

    if WeldingMask ~= nil and BlowTorch ~= nil then
        ISInventoryPaneContextMenu.wearItem(WeldingMask, playerObj:getPlayerNum())
        ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), BlowTorch, true, true)
    end

    ISTimedActionQueue.add(CraftVehicleAction:new(playerObj, CarMaterials, BlowTorch, 1000, "Base.PickUpVan"))

end

