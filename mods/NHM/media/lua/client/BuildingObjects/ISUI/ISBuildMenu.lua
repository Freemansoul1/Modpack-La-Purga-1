--***********************************************************
--**                    ROBERT JOHNSON                     **
--**       Contextual menu for building when clicking somewhere on the ground       **
--***********************************************************

ISBuildMenu = {};
ISBuildMenu.planks = 0;
ISBuildMenu.nails = 0;
ISBuildMenu.nailsBox = 0;
ISBuildMenu.hinge = 0;
ISBuildMenu.doorknob = 0;
ISBuildMenu.cheat = false or getDebug();
ISBuildMenu.woodWorkXp = 0;

local function predicateNotBroken(item)
    return not item:isBroken()
end

local function predicateDrainableUsesInt(item, count)
    return item:getDrainableUsesInt() >= count
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

local function CheckMainInventory(playerObj, checkItem)
    local items = playerObj:getInventory():getAllTypeRecurse(checkItem)
    return items:size()
end

local function InitWorkbench(playerObj, materials, option, tooltip, isBlowTorch)
    if isBlowTorch[1] then
        local BlowTorch = getBlowTorch(playerObj:getInventory())
        if BlowTorch == nil then
            tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemNameFromFullType("Base.BlowTorch") .. " " .. getText("ContextMenu_Consuming") .. " 0/" .. isBlowTorch[2] .. " \n";
            option.onSelect = nil;
            option.notAvailable = true;
        elseif BlowTorch ~= nil and BlowTorch:getDrainableUsesInt() < isBlowTorch[2] then
            tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemNameFromFullType("Base.BlowTorch") .. " " .. getText("ContextMenu_Consuming") .. " " .. tostring(BlowTorch:getDrainableUsesInt()) .. "/" .. isBlowTorch[2] .. " \n";
            option.onSelect = nil;
            option.notAvailable = true;
        else
            tooltip.description = tooltip.description .. " <RGB:0,1,0>" .. getItemNameFromFullType("Base.BlowTorch") .. " " .. getText("ContextMenu_Consuming") .. tostring(BlowTorch:getDrainableUsesInt()) .. "/" .. isBlowTorch[2] .. " \n";
        end
    end

    for i = 1, #materials do
        if CheckMainInventory(playerObj, materials[i][1]) < materials[i][2] then
            tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemNameFromFullType(tostring(materials[i][3] .. "." .. materials[i][1])) .. " " .. tostring(CheckMainInventory(playerObj, materials[i][1])) .. "/" .. tostring(materials[i][2]) .. " \n";
            option.onSelect = nil;
            option.notAvailable = true;
        else
            tooltip.description = tooltip.description .. " <RGB:0,1,0>" .. getItemNameFromFullType(tostring(materials[i][3] .. "." .. materials[i][1])) .. " " .. tostring(CheckMainInventory(playerObj, materials[i][1])) .. "/" .. tostring(materials[i][2]) .. " \n";
        end
    end
end

local function MaterialsSync(furniture, materials, isBlowTorch)
    for i = 1, #materials do
        furniture.modData["need:" .. materials[i][3] .. "." .. materials[i][1]] = tostring(materials[i][2])
    end
    if isBlowTorch[1] then
        furniture.modData["use:Base.BlowTorch"] = tostring(isBlowTorch[2])
    end
end

function ISBuildMenu.GetItemInstance(type)
    if not ISBuildMenu.ItemInstances then
        ISBuildMenu.ItemInstances = {}
    end
    local item = ISBuildMenu.ItemInstances[type]
    if not item then
        item = InventoryItemFactory.CreateItem(type)
        if item then
            ISBuildMenu.ItemInstances[type] = item
            ISBuildMenu.ItemInstances[item:getFullType()] = item
        end
    end
    return item
end

ISBuildMenu.doBuildMenu = function(player, context, worldobjects, test)

    if test and ISWorldObjectContextMenu.Test then
        return true
    end

    if getCore():getGameMode() == "LastStand" then
        return ;
    end

    local playerObj = getSpecificPlayer(player)
    local playerInv = playerObj:getInventory()

    if playerObj:getVehicle() then
        return ;
    end

    ISBuildMenu.woodWorkXp = playerObj:getPerkLevel(Perks.Woodwork);
    local thump = nil;

    local square = nil;

    -- we get the thumpable item (like wall/door/furniture etc.) if exist on the tile we right clicked
    for i, v in ipairs(worldobjects) do
        square = v:getSquare();
        if instanceof(v, "IsoThumpable") and not v:isDoor() then
            if not MultiStageBuilding.getStages(playerObj, v, ISBuildMenu.cheat):isEmpty() then
                thump = v
            end
        end
    end

    if thump then
        local stages = MultiStageBuilding.getStages(playerObj, thump, ISBuildMenu.cheat);
        if not stages:isEmpty() then
            local groundItems = buildUtil.getMaterialOnGround(thump:getSquare())
            local groundItemCounts = buildUtil.getMaterialOnGroundCounts(groundItems)
            local groundItemUses = buildUtil.getMaterialOnGroundUses(groundItems)
            for i = 0, stages:size() - 1 do
                local stage = stages:get(i);
                local option = context:addOption(stage:getDisplayName(), worldobjects, ISBuildMenu.onMultiStageBuild, stage, thump, playerObj);
                local items = stage:getItemsLua();
                local perks = stage:getPerksLua();
                local tooltip = ISToolTip:new();
                tooltip:initialise();
                tooltip:setVisible(false);
                tooltip:setName(stage:getDisplayName());
                tooltip.description = "";
                tooltip:setTexture(stage:getSprite());
                local notAvailable = false;
                if not ISBuildMenu.cheat then
                    for x = 0, stage:getItemsToKeep():size() - 1 do
                        local itemString = stage:getItemsToKeep():get(x);
                        if itemString == "Base.Hammer" then
                            local hammer = playerInv:getFirstTagEvalRecurse("Hammer", predicateNotBroken)
                            if hammer then
                                itemString = hammer:getFullType()
                            end
                        end
                        local item = ISBuildMenu.GetItemInstance(itemString);
                        if item then
                            local hasItem = playerInv:containsTypeEvalRecurse(itemString, predicateNotBroken)
                            if not hasItem and groundItems[itemString] then
                                for _, item3 in ipairs(groundItems[itemString]) do
                                    if predicateNotBroken(item3) then
                                        hasItem = true
                                        break
                                    end
                                end
                            end
                            if hasItem then
                                tooltip.description = tooltip.description .. " <RGB:1,1,1> " .. item:getName() .. " <LINE> ";
                            else
                                tooltip.description = tooltip.description .. " <RGB:1,0,0> " .. item:getName() .. " <LINE> ";
                                notAvailable = true;
                            end
                        end
                    end
                    tooltip.description = tooltip.description .. " <LINE> ";
                    for x, v in pairs(items) do
                        local item = ISBuildMenu.GetItemInstance(x);
                        if item then
                            if instanceof(item, "DrainableComboItem") then
                                local useLeft = playerInv:getUsesTypeRecurse(x);
                                if groundItemUses[x] then
                                    useLeft = useLeft + groundItemUses[x]
                                end
                                if useLeft >= tonumber(v) then
                                    tooltip.description = tooltip.description .. " <RGB:1,1,1> " .. item:getName() .. " " .. useLeft .. "/" .. v .. " <LINE> ";
                                else
                                    tooltip.description = tooltip.description .. " <RGB:1,0,0> " .. item:getName() .. " " .. useLeft .. "/" .. v .. " <LINE> ";
                                    notAvailable = true;
                                end
                            else
                                local nbOfItem = playerInv:getCountTypeEvalRecurse(x, buildUtil.predicateMaterial)
                                if groundItemCounts[x] then
                                    nbOfItem = nbOfItem + groundItemCounts[x]
                                end
                                if x == "Base.Nails" then
                                    nbOfItem = nbOfItem + playerInv:getCountTypeEvalRecurse("Base.NailsBox", buildUtil.predicateMaterial) * 100
                                    if groundItemCounts["Base.NailsBox"] then
                                        nbOfItem = nbOfItem + groundItemCounts["Base.NailsBox"] * 100
                                    end
                                end
                                if nbOfItem >= tonumber(v) then
                                    tooltip.description = tooltip.description .. " <RGB:1,1,1> " .. item:getName() .. " " .. nbOfItem .. "/" .. v .. " <LINE> ";
                                else
                                    tooltip.description = tooltip.description .. " <RGB:1,0,0> " .. item:getName() .. " " .. nbOfItem .. "/" .. v .. " <LINE> ";
                                    notAvailable = true;
                                end
                            end
                        end
                    end
                    tooltip.description = tooltip.description .. " <LINE> ";
                    for x, v in pairs(perks) do
                        local perk = PerkFactory.getPerk(x);
                        if playerObj:getPerkLevel(x) >= tonumber(v) then
                            tooltip.description = tooltip.description .. " <RGB:1,1,1> " .. getText("IGUI_perks_" .. perk:getType():toString()) .. " " .. playerObj:getPerkLevel(x) .. "/" .. v .. " <LINE>";
                        else
                            tooltip.description = tooltip.description .. " <RGB:1,0,0> " .. getText("IGUI_perks_" .. perk:getType():toString()) .. " " .. playerObj:getPerkLevel(x) .. "/" .. v .. " <LINE>";
                            notAvailable = true;
                        end
                    end
                    local knownRecipe = stage:getKnownRecipe()
                    if knownRecipe then
                        tooltip.description = tooltip.description .. " <LINE> "
                        if playerObj:isRecipeKnown(stage:getKnownRecipe()) then
                            tooltip.description = tooltip.description .. " <RGB:1,1,1> " .. getText("Tooltip_vehicle_requireRecipe", getRecipeDisplayName(knownRecipe)) .. " <LINE>"
                        else
                            tooltip.description = tooltip.description .. " <RGB:1,0,0> " .. getText("Tooltip_vehicle_requireRecipe", getRecipeDisplayName(knownRecipe)) .. " <LINE>"
                            notAvailable = true
                        end
                    end
                    option.notAvailable = notAvailable;
                end
                option.toolTip = tooltip;
            end
        end
    end

    -- build menu
    -- if we have any thing to build in our inventory
    if ISBuildMenu.haveSomethingtoBuild(player) then

        if test then
            return ISWorldObjectContextMenu.setTest()
        end

        local buildOption = context:addOption(getText("ContextMenu_Build"), worldobjects, nil);
        -- create a brand new context menu wich contain our different material (wood, stone etc.) to build
        local subMenu = ISContextMenu:getNew(context);
        -- We create the different option for this new menu (wood, stone etc.)
        -- check if we can build something in wood material
        if haveSomethingtoBuildWood(player) then
            -- we add the subMenu to our current option (Build)
            context:addSubMenu(buildOption, subMenu);
            --ВЕРСТАКИ
            local WorkbenchOption = subMenu:addOption(getText("ContextMenu_Workbenches"), worldobjects, nil);
            local subMenuWorkbenches = subMenu:getNew(subMenu);
            context:addSubMenu(WorkbenchOption, subMenuWorkbenches);
            ISBuildMenu.buildWorkbenchMenu(subMenuWorkbenches, context, WorkbenchOption, player);
            ------------------ WALL ------------------
            local wallOption = subMenu:addOption(getText("ContextMenu_Wall"), worldobjects, nil);
            local subMenuWall = subMenu:getNew(subMenu);
            -- we add our new menu to the option we want
            context:addSubMenu(wallOption, subMenuWall);
			ISBuildMenu.buildWallMenu(subMenuWall, wallOption, player);
			------------------ DOOR ------------------
			local doorOption = subMenu:addOption(getText("ContextMenu_Door"), worldobjects, nil);
			local subMenuDoor = subMenu:getNew(subMenu);
--			 we add our new menu to the option we want (here door)
			context:addSubMenu(doorOption, subMenuDoor);
			ISBuildMenu.buildDoorMenu(subMenuDoor, doorOption, player);
			------------------ DOOR FRAME ------------------
--			ISBuildMenu.buildDoorFrameMenu(subMenu, player);
--~ 			----------------- WINDOWS FRAME-----------------
--			ISBuildMenu.buildWindowsFrameMenu(subMenu, player);
 			------------------ STAIRS ------------------
--			local stairsOption = subMenu:addOption(getText("ContextMenu_Stairs"), worldobjects, nil);
--			local subMenuStairs = subMenu:getNew(subMenu);
			-- we add our new menu to the option we want (here wood)
--			context:addSubMenu(stairsOption, subMenuStairs);
			ISBuildMenu.buildStairsMenu(subMenu, player);
--~ 			------------------ FLOOR ------------------
			local floorOption = subMenu:addOption(getText("ContextMenu_Floor"), worldobjects, nil);
			local subMenuFloor = subMenu:getNew(subMenu);
			-- we add our new menu to the option we want (here build)
			context:addSubMenu(floorOption, subMenuFloor);
			ISBuildMenu.buildFloorMenu(subMenuFloor, floorOption, player);
			------------------ WOODEN CRATE ------------------
			ISBuildMenu.buildContainerMenu(subMenu, player);
			------------------ BAR ------------------
			local barOption = subMenu:addOption(getText("ContextMenu_Bar"), worldobjects, nil);
			local subMenuBar = subMenu:getNew(subMenu);
			-- we add our new menu to the option we want (here wood)
			context:addSubMenu(barOption, subMenuBar);
			ISBuildMenu.buildBarMenu(subMenuBar, barOption, player);
			------------------ FURNITURE ------------------
			local furnitureOption = subMenu:addOption(getText("ContextMenu_Furniture"), worldobjects, nil);
			local subMenuFurniture = subMenu:getNew(subMenu);
			-- we add our new menu to the option we want (here build)
			context:addSubMenu(furnitureOption, subMenuFurniture);
			ISBuildMenu.buildFurnitureMenu(subMenuFurniture, context, furnitureOption, player);
			------------------ FENCE ------------------
			local fenceOption = subMenu:addOption(getText("ContextMenu_Fence"), worldobjects, nil);
			local subMenuFence = subMenu:getNew(subMenu);
			-- we add our new menu to the option we want (here build)
			context:addSubMenu(fenceOption, subMenuFence);
			ISBuildMenu.buildFenceMenu(subMenuFence, fenceOption, player);
            ------------------ LIGHT SOURCES ------------------
--            local lightOption = subMenu:addOption("Light source", worldobjects, nil);
--            local subMenuLight = subMenu:getNew(subMenu);
            -- we add our new menu to the option we want (here build)
            -- context:addSubMenu(lightOption, subMenuLight);
            -- ISBuildMenu.buildLightMenu(subMenu, lightOption, player);
            ISBuildMenu.buildLightMenu(subMenu, player);
            ------------------ MISC ------------------
            local miscOption = subMenu:addOption(getText("ContextMenu_Misc"), worldobjects, nil);
            local subMenuMisc = subMenu:getNew(subMenu);
            context:addSubMenu(miscOption, subMenuMisc);
            ISBuildMenu.buildMiscMenu(subMenuMisc, miscOption, player);

            --NHM ДЕКОРАЦИИ ПРОДВИНУТОЕ СТРОИТЕЛЬСТВО
            local DecorOption = subMenu:addOption(getText("ContextMenu_Decor"), worldobjects, nil);
            local subMenuDecor = subMenu:getNew(subMenu);
            context:addSubMenu(DecorOption, subMenuDecor);
            ISBuildMenu.buildDecorMenu(subMenuDecor, context, DecorOption, player);

            --NHM АДМИНСКИЕ ТАЙЛЫ - РЕСУРСЫ И НПС
            local AdminOption = subMenu:addOption(getText("ContextMenu_Admin"), worldobjects, nil);
            local subMenuAdmin = subMenu:getNew(subMenu);
            context:addSubMenu(AdminOption, subMenuAdmin);
            ISBuildMenu.buildAdminMenu(subMenuAdmin, context, AdminOption, player);
        end
    end

    -- dismantle stuff
    -- TODO: RJ: removed it for now need to see exactly how it works as now we have a proper right click to dismantle items...
    --	if playerInv:contains("Saw") and playerInv:contains("Screwdriver") then
    --        if test then return ISWorldObjectContextMenu.setTest() end
    --		context:addOption(getText("ContextMenu_Dismantle"), worldobjects, ISBuildMenu.onDismantle, playerObj);
    --	end

    -- destroy item with sledgehammer
    if not isClient() or getServerOptions():getBoolean("AllowDestructionBySledgehammer") then
        local sledgehammer = playerInv:getFirstTypeEvalRecurse("Sledgehammer", predicateNotBroken)
        if not sledgehammer then
            sledgehammer = playerInv:getFirstTypeEvalRecurse("Sledgehammer2", predicateNotBroken)
        end
        if sledgehammer and not sledgehammer:isBroken() then
            if test then
                return ISWorldObjectContextMenu.setTest()
            end
            context:addOption(getText("ContextMenu_Destroy"), worldobjects, ISWorldObjectContextMenu.onDestroy, playerObj, sledgehammer)
        end
    end
end

function ISBuildMenu.haveSomethingtoBuild(player)
    --~ 	return true;
    return haveSomethingtoBuildWood(player);
end

--NH START
ISBuildMenu.buildWorkbenchMenu = function(subMenu, context, option, player)
    --СТОЛ ХИМИКА
    local ChemistryWorkbenchMaterials = {
        { 'Microchip', 1, 'NHM' },
        { 'ChemicalFlask', 5, 'NHM' },
        { 'ElectronicsScrap', 10, 'Base' },
        { 'Plastic', 20, 'NHM' },
        { 'Glass', 5, 'NHM' },
        { 'Screws', 5, 'Base' },
    }

    local ChemistryWorkbenchOption = subMenu:addOption(getText("ContextMenu_Chemistry_Workbench"), worldobjects, ISBuildMenu.onChemistryWorkbenchOption, square, player, ChemistryWorkbenchMaterials, { false, nil });
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, ChemistryWorkbenchOption, player);

    tooltip:setName(getText("ContextMenu_Chemistry_Workbench"));
    tooltip.description = getText("Tooltip_ChemistryWorkbench") .. tooltip.description;
    tooltip:setTexture("WorkbenchChem_1_0");
    ISBuildMenu.requireHammer(ChemistryWorkbenchOption)

    InitWorkbench(getPlayer(), ChemistryWorkbenchMaterials, ChemistryWorkbenchOption, tooltip, { false, nil })

    --СТОЛ ИНЖЕНЕРА
    local EngineerWorkbenchMaterials = {
        { 'Toolbox', 1, 'Base' },
        { 'SheetMetal', 1, 'Base' },
        { 'ScrapMetal', 10, 'Base' },
        { 'SheetPaper2', 5, 'Base' },
        { 'Plank', 4, 'Base' },
        { 'Screws', 4, 'Base' },
        { 'Nails', 8, 'Base' },
    }

    local EngineerWorkbenchOption = subMenu:addOption(getText("ContextMenu_Engineer_Workbench"), worldobjects, ISBuildMenu.onEngineerWorkbenchOption, square, player, EngineerWorkbenchMaterials, { false, nil });
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, EngineerWorkbenchOption, player);

    tooltip:setName(getText("ContextMenu_Engineer_Workbench"));
    tooltip.description = getText("Tooltip_EngineerWorkbench") .. tooltip.description;
    tooltip:setTexture("WorkbenchEngineer_1_0");
    ISBuildMenu.requireHammer(EngineerWorkbenchOption)

    InitWorkbench(getPlayer(), EngineerWorkbenchMaterials, EngineerWorkbenchOption, tooltip, { false, nil })


    --СТОЛ МЕДИКА
    local FirstAidWorkbenchMaterials = {
        { 'ChemicalFlask', 2, 'NHM' },
        { 'SheetMetal', 1, 'Base' },
        { 'MetalBar', 2, 'Base' },
        { 'ScrapMetal', 15, 'Base' },
        { 'Glass', 5, 'NHM' },
        { 'Screws', 8, 'Base' },
    }

    local FirstAidWorkbenchOption = subMenu:addOption(getText("ContextMenu_FirstAid_Workbench"), worldobjects, ISBuildMenu.onFirstAidWorkbenchOption, square, player, FirstAidWorkbenchMaterials, { true, 20 });
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, FirstAidWorkbenchOption, player);

    tooltip:setName(getText("ContextMenu_FirstAid_Workbench"));
    tooltip.description = getText("Tooltip_FirstAidWorkbench") .. tooltip.description;
    tooltip:setTexture("WorkbenchMed_1_0");
    ISBuildMenu.requireHammer(FirstAidWorkbenchOption)

    InitWorkbench(getPlayer(), FirstAidWorkbenchMaterials, FirstAidWorkbenchOption, tooltip, { true, 20 })


    --СТОЛ КУЛИНАРА
    local CookingWorkbenchMaterials = {
        { 'Pot', 1, 'Base' },
        { 'KitchenKnife', 1, 'Base' },
        { 'Plank', 8, 'Base' },
        { 'ScrapMetal', 4, 'Base' },
        { 'Screws', 2, 'Base' },
        { 'Nails', 10, 'Base' },
    }

    local CookingWorkbenchOption = subMenu:addOption(getText("ContextMenu_Cooking_Workbench"), worldobjects, ISBuildMenu.onCookingWorkbenchOption, square, player, CookingWorkbenchMaterials, { false, nil });
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, CookingWorkbenchOption, player);

    tooltip:setName(getText("ContextMenu_Cooking_Workbench"));
    tooltip.description = getText("Tooltip_CookingWorkbench") .. tooltip.description;
    tooltip:setTexture("WorkbenchCook_1_0");

    InitWorkbench(getPlayer(), CookingWorkbenchMaterials, CookingWorkbenchOption, tooltip, { false, nil })

    --СТОЛ АВТОМЕХАНИКА
    local MechanicsWorkbenchMaterials = {
        { 'Jack', 1, 'Base' },
        { 'TirePump', 1, 'Base' },
        { 'RubberTire', 1, 'NHM' },
        { 'SheetMetal', 4, 'Base' },
        { 'MetalBar', 4, 'Base' },
        { 'MetalPipe', 2, 'Base' },
        { 'Screws', 10, 'Base' },
    }

    local MechanicsWorkbenchOption = subMenu:addOption(getText("ContextMenu_Mechanics_Workbench"), worldobjects, ISBuildMenu.onMechanicsWorkbenchOption, square, player, MechanicsWorkbenchMaterials, { true, 50 });
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, MechanicsWorkbenchOption, player);

    tooltip:setName(getText("ContextMenu_Mechanics_Workbench"));
    tooltip.description = getText("Tooltip_MechanicsWorkbench") .. tooltip.description;
    tooltip:setTexture("WorkbenchMech_1_0");
    ISBuildMenu.requireHammer(MechanicsWorkbenchOption)

    InitWorkbench(getPlayer(), MechanicsWorkbenchMaterials, MechanicsWorkbenchOption, tooltip, { true, 50 })

    --СТОЛ КОЖЕВНИКА
    local LeatherworkingWorkbenchMaterials = {
        { 'Garbagebag', 1, 'Base' },
        { 'Rope', 1, 'Base' },
        { 'LeatherStrips', 10, 'Base' },
        { 'Plank', 8, 'Base' },
        { 'ScrapMetal', 4, 'Base' },
        { 'Screws', 2, 'Base' },
        { 'Nails', 10, 'Base' },
    }

    local LeatherworkingWorkbenchOption = subMenu:addOption(getText("ContextMenu_Leatherworking_Workbench"), worldobjects, ISBuildMenu.onLeatherworkingWorkbenchOption, square, player, LeatherworkingWorkbenchMaterials, { false, nil });
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, LeatherworkingWorkbenchOption, player);

    tooltip:setName(getText("ContextMenu_Leatherworking_Workbench"));
    tooltip.description = getText("Tooltip_LeatherworkingWorkbench") .. tooltip.description;
    tooltip:setTexture("WorkbenchLeather_1_0");
    ISBuildMenu.requireHammer(LeatherworkingWorkbenchOption)

    InitWorkbench(getPlayer(), LeatherworkingWorkbenchMaterials, LeatherworkingWorkbenchOption, tooltip, { false, nil })

    --СТОЛ ЭЛЕКТРИКА
    local ElectricWorkbenchMaterials = {
        { 'Microchip', 5, 'NHM' },
        { 'ElectronicsScrap', 10, 'Base' },
        { 'ElectricWire', 5, 'Radio' },
        { 'Toolbox', 1, 'Base' },
        { 'Screwdriver', 1, 'Base' },
        { 'SheetMetal', 4, 'Base' },
        { 'MetalBar', 4, 'Base' },
        { 'MetalPipe', 2, 'Base' },
        { 'Screws', 10, 'Base' },
    }

    local ElectricWorkbenchOption = subMenu:addOption(getText("ContextMenu_Electric_Workbench"), worldobjects, ISBuildMenu.onElectricWorkbenchOption, square, player, ElectricWorkbenchMaterials, { true, 50 });
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, ElectricWorkbenchOption, player);

    tooltip:setName(getText("ContextMenu_Electric_Workbench"));
    tooltip.description = getText("Tooltip_ElectricWorkbench") .. tooltip.description;
    tooltip:setTexture("WorkbenchEng_1_0");
    ISBuildMenu.requireHammer(ElectricWorkbenchOption)

    InitWorkbench(getPlayer(), ElectricWorkbenchMaterials, ElectricWorkbenchOption, tooltip, { true, 50 })

    --СТОЛ ПОРТНОГО
    local TailorWorkbenchMaterials = {
        { 'RippedSheets', 25, 'Base' },
        { 'Rope', 1, 'Base' },
        { 'Needle', 1, 'Base' },
        { 'Scissors', 1, 'Base' },
        { 'Plank', 4, 'Base' },
        { 'MetalBar', 2, 'Base' },
        { 'ScrapMetal', 4, 'Base' },
        { 'Screws', 6, 'Base' },
        { 'Nails', 4, 'Base' },
    }

    local TailorWorkbenchOption = subMenu:addOption(getText("ContextMenu_Tailor_Workbench"), worldobjects, ISBuildMenu.onTailorWorkbenchOption, square, player, TailorWorkbenchMaterials, { false, nil });
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, TailorWorkbenchOption, player);

    tooltip:setName(getText("ContextMenu_Tailor_Workbench"));
    tooltip.description = getText("Tooltip_TailorWorkbench") .. tooltip.description;
    tooltip:setTexture("WorkbenchTailor_1_0");
    ISBuildMenu.requireHammer(TailorWorkbenchOption)

    InitWorkbench(getPlayer(), TailorWorkbenchMaterials, TailorWorkbenchOption, tooltip, { false, nil })

    --САМОГОННЫЙ АППАРАТ
    local NHStillMaterials = {
        { 'SheetMetal', 2, 'Base' },
        { 'Log', 2, 'Base' },
        { 'MetalPipe', 4, 'Base' },
        { 'MetalBar', 4, 'Base' },
    }

    local NHStillOption = subMenu:addOption(getText("ContextMenu_NHStill"), worldobjects, ISBuildMenu.onNHStillOption, square, player, NHStillMaterials, { true, 50 });
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, NHStillOption, player);

    tooltip:setName(getText("ContextMenu_NHStill"));
    tooltip.description = getText("Tooltip_NHStill") .. tooltip.description;
    tooltip:setTexture("Still_1_0");
    ISBuildMenu.requireHammer(NHStillOption)

    InitWorkbench(getPlayer(), NHStillMaterials, NHStillOption, tooltip, { true, 50 })

    --НАКОВАЛЬНЯ
    local NHAnvilMaterials = {
        { 'Log', 1, 'Base' },
        { 'ScrapMetal', 15, 'Base' },
        { 'UnusableMetal', 15, 'Base' },
    }

    local NHAnvilOption = subMenu:addOption(getText("ContextMenu_NHAnvil"), worldobjects, ISBuildMenu.onNHAnvilOption, square, player, NHAnvilMaterials, { true, 50 });
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, NHAnvilOption, player);

    tooltip:setName(getText("ContextMenu_NHAnvil"));
    tooltip.description = getText("Tooltip_NHAnvil") .. tooltip.description;
    tooltip:setTexture("Anvil_1_0");
    ISBuildMenu.requireHammer(NHAnvilOption)

    InitWorkbench(getPlayer(), NHAnvilMaterials, NHAnvilOption, tooltip, { true, 50 })

    --САБМЕНЮ ВЫПЛАВКА
    local SmeltingOption = subMenu:addOption(getText("ContextMenu_Smelting"), worldobjects, nil);
    local subMenuSmelting = subMenu:getNew(subMenu);
    context:addSubMenu(SmeltingOption, subMenuSmelting);

    --КАМЕННАЯ ПЕЧЬ
    local StoneFurnaceMaterials = {
        { 'Stone', 25, 'Base' },
    }

    local StoneFurnaceOption = subMenuSmelting:addOption(getText("ContextMenu_Stone_Furnace"), worldobjects, ISBuildMenu.onStoneFurnaceOption, square, player, StoneFurnaceMaterials, { false, nil });
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, StoneFurnaceOption, player);

    tooltip:setName(getText("ContextMenu_Stone_Furnace"));
    tooltip.description = getText("Tooltip_StoneFurnace") .. tooltip.description;
    tooltip:setTexture("Furnace_1_0");
    ISBuildMenu.requireHammer(StoneFurnaceOption)

    InitWorkbench(getPlayer(), StoneFurnaceMaterials, StoneFurnaceOption, tooltip, { false, nil })

    --ДОМЕННАЯ ПЕЧЬ
    local BlastFurnaceMaterials = {
        { 'SheetMetal', 2, 'Base' },
        { 'MetalPipe', 2, 'Base' },
        { 'ScrapMetal', 20, 'Base' },
        { 'UnusableMetal', 5, 'Base' },
        { 'Stone', 10, 'Base' },
    }

    local BlastFurnaceOption = subMenuSmelting:addOption(getText("ContextMenu_Blast_Furnace"), worldobjects, ISBuildMenu.onBlastFurnaceOption, square, player, BlastFurnaceMaterials, { true, 50 });
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, BlastFurnaceOption, player);

    tooltip:setName(getText("ContextMenu_Blast_Furnace"));
    tooltip.description = getText("Tooltip_BlastFurnace") .. tooltip.description;
    tooltip:setTexture("BlastFurnace_1_0");
    ISBuildMenu.requireHammer(BlastFurnaceOption)

    InitWorkbench(getPlayer(), BlastFurnaceMaterials, BlastFurnaceOption, tooltip, { true, 50 })

    --ТРЕНАЖЕР
    local TrainerMaterials = {
        { 'Microchip', 5, 'NHM' },
        { 'ElectronicsScrap', 20, 'Base' },
        { 'ElectricWire', 5, 'Radio' },
        { 'Rubber', 10, 'NHM' },
        { 'Glass', 2, 'NHM' },
        { 'SheetMetal', 1, 'Base' },
        { 'MetalPipe', 4, 'Base' },
        { 'Screws', 20, 'Base' },
    }

    local TrainerOption = subMenu:addOption(getText("ContextMenu_Trainer"), worldobjects, ISBuildMenu.onTrainerOption, square, player, TrainerMaterials, { false, nil });
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, TrainerOption, player);

    tooltip:setName(getText("ContextMenu_Trainer"));
    tooltip.description = getText("Tooltip_Trainer") .. tooltip.description;
    tooltip:setTexture("WorkbenchAgility_1_0");
    ISBuildMenu.requireHammer(TrainerOption)

    InitWorkbench(getPlayer(), TrainerMaterials, TrainerOption, tooltip, { false, nil })
end
--ВЕРСТАКИ ПРОДОЛЖАТЬ ЗДЕСЬ (САБМЕНЮ ВЕРСТАКИ)

ISBuildMenu.buildDecorMenu = function(subMenu, context, option, player)
    --сабменю декорации
    local DecorationOption = subMenu:addOption(getText("ContextMenu_Decoration"), worldobjects, nil);
    local subMenuDecoration = subMenu:getNew(subMenu);
    context:addSubMenu(DecorationOption, subMenuDecoration);
    --сабменю источники света
    local LightOption = subMenu:addOption(getText("ContextMenu_NHLight"), worldobjects, nil);
    local subMenuNHLight = subMenu:getNew(subMenu);
    context:addSubMenu(LightOption, subMenuNHLight);
    --сабменю контейнеры
    local ContainerOption = subMenu:addOption(getText("ContextMenu_NHContainer"), worldobjects, nil);
    local subMenuNHContainer = subMenu:getNew(subMenu);
    context:addSubMenu(ContainerOption, subMenuNHContainer);
    --сабменю игровые автоматы
    local SlotMachinesOption = subMenu:addOption(getText("ContextMenu_SlotMachines"), worldobjects, nil);
    local subMenuSlots = subMenu:getNew(subMenu);
    context:addSubMenu(SlotMachinesOption, subMenuSlots);
    --сабменю бочки для сбора дождевой воды
    local RCOption = subMenu:addOption(getText("ContextMenu_RainCollectors"), worldobjects, nil);
    local subMenuRC = subMenu:getNew(subMenu);
    context:addSubMenu(RCOption, subMenuRC);
    --сабменю плакаты
    local PosterOption = subMenu:addOption(getText("ContextMenu_Posters"), worldobjects, nil);
    local subMenuPosters = subMenu:getNew(subMenu);
    context:addSubMenu(PosterOption, subMenuPosters);

    -- ТЕЛЕСКОП 1 УРОВЕНЬ
    local TelescopeOption = subMenuDecoration:addOption(getText("ContextMenu_Telescope"), worldobjects, ISBuildMenu.onTelescopeOption, square, player);
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 1, TelescopeOption, player);
    tooltip:setName(getText("ContextMenu_Telescope"));
    tooltip.description = getText("Tooltip_Telescope") .. tooltip.description;
    tooltip:setTexture("NHC1_1_0");
    ISBuildMenu.requireHammer(TelescopeOption)
    local Scrap = getSpecificPlayer(player):getInventory():getItemCount("Base.ScrapMetal", true);
    local Glass = getSpecificPlayer(player):getInventory():getItemCount("NHM.Glass", true);
    local Screw = getSpecificPlayer(player):getInventory():getItemCount("Base.Screws", true);
    if Scrap < 5 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("ScrapMetal") .. " " .. Scrap .. "/5 " .. "\n";
        TelescopeOption.onSelect = nil;
        TelescopeOption.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("ScrapMetal") .. " 5/5 " .. "\n";
    end
    if Glass < 3 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("Glass") .. " " .. Glass .. "/3 " .. "\n";
        TelescopeOption.onSelect = nil;
        TelescopeOption.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("Glass") .. " 3/3 " .. "\n";
    end
    if Screw < 3 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("Screws") .. " " .. Screw .. "/3 " .. "\n";
        TelescopeOption.onSelect = nil;
        TelescopeOption.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("Screws") .. " 3/3 " .. "\n";
    end

    --КАМЕРА 2 УРОВЕНЬ
    local CameraOption = subMenuDecoration:addOption(getText("ContextMenu_Camera"), worldobjects, ISBuildMenu.onCameraOption, square, player);
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 2, CameraOption, player);
    tooltip:setName(getText("ContextMenu_Camera"));
    tooltip.description = getText("Tooltip_Camera") .. tooltip.description;
    tooltip:setTexture("NHC2_3_0");
    ISBuildMenu.requireHammer(CameraOption)
    local Scrap = getSpecificPlayer(player):getInventory():getItemCount("Base.ScrapMetal", true);
    local Glass = getSpecificPlayer(player):getInventory():getItemCount("NHM.Glass", true);
    local Screw = getSpecificPlayer(player):getInventory():getItemCount("Base.Screws", true);
    if Scrap < 7 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("ScrapMetal") .. " " .. Scrap .. "/7 " .. "\n";
        CameraOption.onSelect = nil;
        CameraOption.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("ScrapMetal") .. " 7/7 " .. "\n";
    end
    if Glass < 5 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("Glass") .. " " .. Glass .. "/5 " .. "\n";
        CameraOption.onSelect = nil;
        CameraOption.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("Glass") .. " 5/5 " .. "\n";
    end
    if Screw < 3 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("Screws") .. " " .. Screw .. "/3 " .. "\n";
        CameraOption.onSelect = nil;
        CameraOption.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("Screws") .. " 3/3 " .. "\n";
    end

    --ПРОЖЕКТОР 2 УРОВЕНЬ
    local SearchlightOption = subMenuNHLight:addOption(getText("ContextMenu_Searchlight"), worldobjects, ISBuildMenu.onSearchlightOption, square, player);
    local playerObj = getSpecificPlayer(player)
    local playerInv = playerObj:getInventory()
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 2, SearchlightOption, player);
    tooltip:setName(getText("ContextMenu_Searchlight"));
    tooltip.description = getText("Tooltip_Searchlight") .. tooltip.description;
    tooltip:setTexture("NHC2_1_0");
    ISBuildMenu.requireHammer(SearchlightOption)
    local torch = getSpecificPlayer(player):getInventory():getItemCount("Base.Torch", true);
    local Scrap = getSpecificPlayer(player):getInventory():getItemCount("Base.ScrapMetal", true);
    local Glass = getSpecificPlayer(player):getInventory():getItemCount("NHM.Glass", true);
    local Screw = getSpecificPlayer(player):getInventory():getItemCount("Base.Screws", true);
    if not playerInv:containsTypeRecurse("Torch") and not ISBuildMenu.materialOnGround["Torch"] and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemNameFromFullType("Base.Torch") .. " " .. torch .. "/1 " .. "\n";
        SearchlightOption.onSelect = nil;
        SearchlightOption.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemNameFromFullType("Base.Torch") .. " " .. torch .. "/1 " .. "\n";
    end
    if Scrap < 4 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("ScrapMetal") .. " " .. Scrap .. "/4 " .. "\n";
        SearchlightOption.onSelect = nil;
        SearchlightOption.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("ScrapMetal") .. " 4/4 " .. "\n";
    end
    if Glass < 3 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("Glass") .. " " .. Glass .. "/3 " .. "\n";
        SearchlightOption.onSelect = nil;
        SearchlightOption.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("Glass") .. " 3/3 " .. "\n";
    end
    if Screw < 3 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("Screws") .. " " .. Screw .. "/3 " .. "\n";
        SearchlightOption.onSelect = nil;
        SearchlightOption.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("Screws") .. " 3/3 " .. "\n";
    end

    --КНИЖНЫЙ ШКАФ 3 УРОВЕНЬ
    local NHBookCaseOption = subMenuNHContainer:addOption(getText("ContextMenu_NHBookCase"), worldobjects, ISBuildMenu.onNHBookCaseOption, square, player);
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 3, NHBookCaseOption, player);
    tooltip:setName(getText("ContextMenu_NHBookCase"));
    tooltip.description = getText("Tooltip_NHBookCase") .. tooltip.description;
    tooltip:setTexture("NHC3_1_0");
    ISBuildMenu.requireHammer(NHBookCaseOption)
    local Scrap = getSpecificPlayer(player):getInventory():getItemCount("Base.ScrapMetal", true);
    local Plank = getSpecificPlayer(player):getInventory():getItemCount("Base.Plank", true);
    local Nail = getSpecificPlayer(player):getInventory():getItemCount("Base.Nails", true);
    if Scrap < 3 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("ScrapMetal") .. " " .. Scrap .. "/3 " .. "\n";
        NHBookCaseOption.onSelect = nil;
        NHBookCaseOption.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("ScrapMetal") .. " 3/3 " .. "\n";
    end
    if Plank < 4 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("Plank") .. " " .. Plank .. "/4 " .. "\n";
        NHBookCaseOption.onSelect = nil;
        NHBookCaseOption.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("Plank") .. " 4/4 " .. "\n";
    end
    if Nail < 6 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("Nails") .. " " .. Nail .. "/6 " .. "\n";
        NHBookCaseOption.onSelect = nil;
        NHBookCaseOption.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("Nails") .. " 6/6 " .. "\n";
    end

    --КНИЖНЫЙ СТОЛИК 3 УРОВЕНЬ
    local NHSmallBookCaseOption = subMenuNHContainer:addOption(getText("ContextMenu_NHSmallBookCase"), worldobjects, ISBuildMenu.onNHSmallBookCaseOption, square, player);
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 3, NHSmallBookCaseOption, player);
    tooltip:setName(getText("ContextMenu_NHSmallBookCase"));
    tooltip.description = getText("Tooltip_NHSmallBookCase") .. tooltip.description;
    tooltip:setTexture("NHC3_3_0");
    ISBuildMenu.requireHammer(NHSmallBookCaseOption)
    local Scrap = getSpecificPlayer(player):getInventory():getItemCount("Base.ScrapMetal", true);
    local Plank = getSpecificPlayer(player):getInventory():getItemCount("Base.Plank", true);
    local Nail = getSpecificPlayer(player):getInventory():getItemCount("Base.Nails", true);
    if Scrap < 2 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("ScrapMetal") .. " " .. Scrap .. "/2 " .. "\n";
        NHSmallBookCaseOption.onSelect = nil;
        NHSmallBookCaseOption.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("ScrapMetal") .. " 2/2 " .. "\n";
    end
    if Plank < 4 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("Plank") .. " " .. Plank .. "/4 " .. "\n";
        NHSmallBookCaseOption.onSelect = nil;
        NHSmallBookCaseOption.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("Plank") .. " 4/4 " .. "\n";
    end
    if Nail < 2 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("Nails") .. " " .. Nail .. "/2 " .. "\n";
        NHSmallBookCaseOption.onSelect = nil;
        NHSmallBookCaseOption.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("Nails") .. " 2/2 " .. "\n";
    end

    --ШКАФ С ВЕНТИЛЯТОРОМ 3 УРОВЕНЬ
    local FanLockerOption = subMenuNHContainer:addOption(getText("ContextMenu_FanLocker"), worldobjects, ISBuildMenu.onFanLockerOption, square, player);
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 3, FanLockerOption, player);
    tooltip:setName(getText("ContextMenu_FanLocker"));
    tooltip.description = getText("Tooltip_FanLocker") .. tooltip.description;
    tooltip:setTexture("NHC3_5_0");
    ISBuildMenu.requireHammer(FanLockerOption)
    local Scrap = getSpecificPlayer(player):getInventory():getItemCount("Base.ScrapMetal", true);
    local Plank = getSpecificPlayer(player):getInventory():getItemCount("Base.Plank", true);
    local Nail = getSpecificPlayer(player):getInventory():getItemCount("Base.Nails", true);
    if Scrap < 8 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("ScrapMetal") .. " " .. Scrap .. "/8 " .. "\n";
        FanLockerOption.onSelect = nil;
        FanLockerOption.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("ScrapMetal") .. " 8/8 " .. "\n";
    end
    if Plank < 2 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("Plank") .. " " .. Plank .. "/2 " .. "\n";
        FanLockerOption.onSelect = nil;
        FanLockerOption.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("Plank") .. " 2/2 " .. "\n";
    end
    if Nail < 6 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("Nails") .. " " .. Nail .. "/6 " .. "\n";
        FanLockerOption.onSelect = nil;
        FanLockerOption.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("Nails") .. " 6/6 " .. "\n";
    end

    --Игровые автоматы 4 уровень
    --автомат 1
    local SlotMachine1Option = subMenuSlots:addOption(getText("ContextMenu_SlotMachine1"), worldobjects, ISBuildMenu.onSlotMachine1Option, square, player);
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 4, SlotMachine1Option, player);
    tooltip:setName(getText("ContextMenu_SlotMachine1"));
    tooltip.description = getText("Tooltip_SlotMachine1") .. tooltip.description;
    tooltip:setTexture("NHC4_1_0");
    ISBuildMenu.requireHammer(SlotMachine1Option)
    local Scrap = getSpecificPlayer(player):getInventory():getItemCount("Base.ScrapMetal", true);
    local EScrap = getSpecificPlayer(player):getInventory():getItemCount("Base.ElectronicsScrap", true);
    if Scrap < 12 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("ScrapMetal") .. " " .. Scrap .. "/12 " .. "\n";
        SlotMachine1Option.onSelect = nil;
        SlotMachine1Option.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("ScrapMetal") .. " 12/12 " .. "\n";
    end
    if EScrap < 6 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("ElectronicsScrap") .. " " .. EScrap .. "/6 " .. "\n";
        SlotMachine1Option.onSelect = nil;
        SlotMachine1Option.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("ElectronicsScrap") .. " 6/6 " .. "\n";
    end
    --автомат 2
    local SlotMachine2Option = subMenuSlots:addOption(getText("ContextMenu_SlotMachine2"), worldobjects, ISBuildMenu.onSlotMachine2Option, square, player);
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 4, SlotMachine2Option, player);
    tooltip:setName(getText("ContextMenu_SlotMachine2"));
    tooltip.description = getText("Tooltip_SlotMachine2") .. tooltip.description;
    tooltip:setTexture("NHC4_3_0");
    ISBuildMenu.requireHammer(SlotMachine2Option)
    local Scrap = getSpecificPlayer(player):getInventory():getItemCount("Base.ScrapMetal", true);
    local EScrap = getSpecificPlayer(player):getInventory():getItemCount("Base.ElectronicsScrap", true);
    if Scrap < 12 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("ScrapMetal") .. " " .. Scrap .. "/12 " .. "\n";
        SlotMachine2Option.onSelect = nil;
        SlotMachine2Option.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("ScrapMetal") .. " 12/12 " .. "\n";
    end
    if EScrap < 6 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("ElectronicsScrap") .. " " .. EScrap .. "/6 " .. "\n";
        SlotMachine2Option.onSelect = nil;
        SlotMachine2Option.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("ElectronicsScrap") .. " 6/6 " .. "\n";
    end
    --автомат 3
    local SlotMachine3Option = subMenuSlots:addOption(getText("ContextMenu_SlotMachine3"), worldobjects, ISBuildMenu.onSlotMachine3Option, square, player);
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 4, SlotMachine3Option, player);
    tooltip:setName(getText("ContextMenu_SlotMachine3"));
    tooltip.description = getText("Tooltip_SlotMachine3") .. tooltip.description;
    tooltip:setTexture("NHC4_5_0");
    ISBuildMenu.requireHammer(SlotMachine3Option)
    local Scrap = getSpecificPlayer(player):getInventory():getItemCount("Base.ScrapMetal", true);
    local EScrap = getSpecificPlayer(player):getInventory():getItemCount("Base.ElectronicsScrap", true);
    if Scrap < 12 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("ScrapMetal") .. " " .. Scrap .. "/12 " .. "\n";
        SlotMachine3Option.onSelect = nil;
        SlotMachine3Option.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("ScrapMetal") .. " 12/12 " .. "\n";
    end
    if EScrap < 6 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("ElectronicsScrap") .. " " .. EScrap .. "/6 " .. "\n";
        SlotMachine3Option.onSelect = nil;
        SlotMachine3Option.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("ElectronicsScrap") .. " 6/6 " .. "\n";
    end
    --автомат 4
    local SlotMachine4Option = subMenuSlots:addOption(getText("ContextMenu_SlotMachine4"), worldobjects, ISBuildMenu.onSlotMachine4Option, square, player);
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 4, SlotMachine4Option, player);
    tooltip:setName(getText("ContextMenu_SlotMachine4"));
    tooltip.description = getText("Tooltip_SlotMachine4") .. tooltip.description;
    tooltip:setTexture("NHC4_7_0");
    ISBuildMenu.requireHammer(SlotMachine4Option)
    local Scrap = getSpecificPlayer(player):getInventory():getItemCount("Base.ScrapMetal", true);
    local EScrap = getSpecificPlayer(player):getInventory():getItemCount("Base.ElectronicsScrap", true);
    if Scrap < 12 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("ScrapMetal") .. " " .. Scrap .. "/12 " .. "\n";
        SlotMachine4Option.onSelect = nil;
        SlotMachine4Option.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("ScrapMetal") .. " 12/12 " .. "\n";
    end
    if EScrap < 6 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("ElectronicsScrap") .. " " .. EScrap .. "/6 " .. "\n";
        SlotMachine4Option.onSelect = nil;
        SlotMachine4Option.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("ElectronicsScrap") .. " 6/6 " .. "\n";
    end
    --автомат 5
    local SlotMachine5Option = subMenuSlots:addOption(getText("ContextMenu_SlotMachine5"), worldobjects, ISBuildMenu.onSlotMachine5Option, square, player);
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 4, SlotMachine5Option, player);
    tooltip:setName(getText("ContextMenu_SlotMachine5"));
    tooltip.description = getText("Tooltip_SlotMachine5") .. tooltip.description;
    tooltip:setTexture("NHC4_9_0");
    ISBuildMenu.requireHammer(SlotMachine5Option)
    local Scrap = getSpecificPlayer(player):getInventory():getItemCount("Base.ScrapMetal", true);
    local EScrap = getSpecificPlayer(player):getInventory():getItemCount("Base.ElectronicsScrap", true);
    if Scrap < 12 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("ScrapMetal") .. " " .. Scrap .. "/12 " .. "\n";
        SlotMachine5Option.onSelect = nil;
        SlotMachine5Option.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("ScrapMetal") .. " 12/12 " .. "\n";
    end
    if EScrap < 6 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("ElectronicsScrap") .. " " .. EScrap .. "/6 " .. "\n";
        SlotMachine5Option.onSelect = nil;
        SlotMachine5Option.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("ElectronicsScrap") .. " 6/6 " .. "\n";
    end
    --автомат 6
    local SlotMachine6Option = subMenuSlots:addOption(getText("ContextMenu_SlotMachine6"), worldobjects, ISBuildMenu.onSlotMachine6Option, square, player);
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 4, SlotMachine6Option, player);
    tooltip:setName(getText("ContextMenu_SlotMachine6"));
    tooltip.description = getText("Tooltip_SlotMachine6") .. tooltip.description;
    tooltip:setTexture("NHC4_11_0");
    ISBuildMenu.requireHammer(SlotMachine6Option)
    local Scrap = getSpecificPlayer(player):getInventory():getItemCount("Base.ScrapMetal", true);
    local EScrap = getSpecificPlayer(player):getInventory():getItemCount("Base.ElectronicsScrap", true);
    if Scrap < 12 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("ScrapMetal") .. " " .. Scrap .. "/12 " .. "\n";
        SlotMachine6Option.onSelect = nil;
        SlotMachine6Option.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("ScrapMetal") .. " 12/12 " .. "\n";
    end
    if EScrap < 6 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("ElectronicsScrap") .. " " .. EScrap .. "/6 " .. "\n";
        SlotMachine6Option.onSelect = nil;
        SlotMachine6Option.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("ElectronicsScrap") .. " 6/6 " .. "\n";
    end
    --каменный колодец декор 5
    local StoneWell1Option = subMenuDecoration:addOption(getText("ContextMenu_StoneWell1"), worldobjects, ISBuildMenu.onStoneWell1Option, square, player);
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 5, StoneWell1Option, player);
    tooltip:setName(getText("ContextMenu_StoneWell1"));
    tooltip.description = getText("Tooltip_StoneWell1") .. tooltip.description;
    tooltip:setTexture("NHC5_1_0");
    ISBuildMenu.requireHammer(StoneWell1Option)
    local Stone = getSpecificPlayer(player):getInventory():getItemCount("Base.Stone", true);
    if Stone < 40 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("Stone") .. " " .. Stone .. "/40 " .. "\n";
        StoneWell1Option.onSelect = nil;
        StoneWell1Option.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("Stone") .. " 40/40 " .. "\n";
    end
    --каменный колодец 2 декор 5
    local StoneWell2Option = subMenuDecoration:addOption(getText("ContextMenu_StoneWell2"), worldobjects, ISBuildMenu.onStoneWell2Option, square, player);
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 5, StoneWell2Option, player);
    tooltip:setName(getText("ContextMenu_StoneWell2"));
    tooltip.description = getText("Tooltip_StoneWell2") .. tooltip.description;
    tooltip:setTexture("NHC5_2_0");
    ISBuildMenu.requireHammer(StoneWell2Option)
    local Stone = getSpecificPlayer(player):getInventory():getItemCount("Base.Stone", true);
    if Stone < 40 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("Stone") .. " " .. Stone .. "/40 " .. "\n";
        StoneWell2Option.onSelect = nil;
        StoneWell2Option.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("Stone") .. " 40/40 " .. "\n";
    end
    --фермерский декор 1 декор 5
    local FarmDec1Option = subMenuDecoration:addOption(getText("ContextMenu_FarmDec1"), worldobjects, ISBuildMenu.onFarmDec1Option, square, player);
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 5, FarmDec1Option, player);
    tooltip:setName(getText("ContextMenu_FarmDec1"));
    tooltip.description = getText("Tooltip_FarmDec1") .. tooltip.description;
    tooltip:setTexture("NHC5_3_0");
    ISBuildMenu.requireHammer(FarmDec1Option)
    local Plank = getSpecificPlayer(player):getInventory():getItemCount("Base.Plank", true);
    local Nail = getSpecificPlayer(player):getInventory():getItemCount("Base.Nails", true);
    if Plank < 6 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("Plank") .. " " .. Plank .. "/6 " .. "\n";
        FarmDec1Option.onSelect = nil;
        FarmDec1Option.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("Plank") .. " 6/6 " .. "\n";
    end
    if Nail < 10 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("Nails") .. " " .. Nail .. "/10 " .. "\n";
        FarmDec1Option.onSelect = nil;
        FarmDec1Option.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("Nails") .. " 10/10 " .. "\n";
    end
    --фермерский декор 2 декор 5
    local FarmDec2Option = subMenuDecoration:addOption(getText("ContextMenu_FarmDec2"), worldobjects, ISBuildMenu.onFarmDec2Option, square, player);
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 5, FarmDec2Option, player);
    tooltip:setName(getText("ContextMenu_FarmDec2"));
    tooltip.description = getText("Tooltip_FarmDec2") .. tooltip.description;
    tooltip:setTexture("NHC5_5_0");
    ISBuildMenu.requireHammer(FarmDec2Option)
    local Plank = getSpecificPlayer(player):getInventory():getItemCount("Base.Plank", true);
    local Nail = getSpecificPlayer(player):getInventory():getItemCount("Base.Nails", true);
    local Plastic = getSpecificPlayer(player):getInventory():getItemCount("NHM.Plastic", true);
    if Plank < 6 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("Plank") .. " " .. Plank .. "/6 " .. "\n";
        FarmDec2Option.onSelect = nil;
        FarmDec2Option.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("Plank") .. " 6/6 " .. "\n";
    end
    if Nail < 6 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("Nails") .. " " .. Nail .. "/6 " .. "\n";
        FarmDec2Option.onSelect = nil;
        FarmDec2Option.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("Nails") .. " 6/6 " .. "\n";
    end
    if Plastic < 6 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("Plastic") .. " " .. Plastic .. "/6 " .. "\n";
        FarmDec2Option.onSelect = nil;
        FarmDec2Option.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("Plastic") .. " 6/6 " .. "\n";
    end
    --фермерский декор 3 декор 5
    local FarmDec3Option = subMenuDecoration:addOption(getText("ContextMenu_FarmDec3"), worldobjects, ISBuildMenu.onFarmDec3Option, square, player);
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 5, FarmDec3Option, player);
    tooltip:setName(getText("ContextMenu_FarmDec3"));
    tooltip.description = getText("Tooltip_FarmDec3") .. tooltip.description;
    tooltip:setTexture("NHC5_7_0");
    ISBuildMenu.requireHammer(FarmDec3Option)
    local Plank = getSpecificPlayer(player):getInventory():getItemCount("Base.Plank", true);
    local Nail = getSpecificPlayer(player):getInventory():getItemCount("Base.Nails", true);
    if Plank < 6 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("Plank") .. " " .. Plank .. "/6 " .. "\n";
        FarmDec3Option.onSelect = nil;
        FarmDec3Option.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("Plank") .. " 6/6 " .. "\n";
    end
    if Nail < 6 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("Nails") .. " " .. Nail .. "/6 " .. "\n";
        FarmDec3Option.onSelect = nil;
        FarmDec3Option.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("Nails") .. " 6/6 " .. "\n";
    end
    --фермерский декор 4 декор 5
    local FarmDec4Option = subMenuDecoration:addOption(getText("ContextMenu_FarmDec4"), worldobjects, ISBuildMenu.onFarmDec4Option, square, player);
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 5, FarmDec4Option, player);
    tooltip:setName(getText("ContextMenu_FarmDec4"));
    tooltip.description = getText("Tooltip_FarmDec4") .. tooltip.description;
    tooltip:setTexture("NHC5_8_0");
    ISBuildMenu.requireHammer(FarmDec4Option)
    local Plank = getSpecificPlayer(player):getInventory():getItemCount("Base.Plank", true);
    local Nail = getSpecificPlayer(player):getInventory():getItemCount("Base.Nails", true);
    if Plank < 6 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("Plank") .. " " .. Plank .. "/6 " .. "\n";
        FarmDec4Option.onSelect = nil;
        FarmDec4Option.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("Plank") .. " 6/6 " .. "\n";
    end
    if Nail < 6 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("Nails") .. " " .. Nail .. "/6 " .. "\n";
        FarmDec4Option.onSelect = nil;
        FarmDec4Option.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("Nails") .. " 6/6 " .. "\n";
    end
    --шкаф 1 декор 6
    local NHLocker1Option = subMenuDecoration:addOption(getText("ContextMenu_NHLocker1"), worldobjects, ISBuildMenu.onNHLocker1Option, square, player);
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 6, NHLocker1Option, player);
    tooltip:setName(getText("ContextMenu_NHLocker1"));
    tooltip.description = getText("Tooltip_NHLocker1") .. tooltip.description;
    tooltip:setTexture("NHC6_3_0");
    ISBuildMenu.requireHammer(NHLocker1Option)
    local Screw = getSpecificPlayer(player):getInventory():getItemCount("Base.Screws", true);
    local Scrap = getSpecificPlayer(player):getInventory():getItemCount("Base.ScrapMetal", true);
    if Scrap < 15 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("ScrapMetal") .. " " .. Scrap .. "/15 " .. "\n";
        NHLocker1Option.onSelect = nil;
        NHLocker1Option.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("ScrapMetal") .. " 15/15 " .. "\n";
    end
    if Screw < 8 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("Screws") .. " " .. Screw .. "/8 " .. "\n";
        NHLocker1Option.onSelect = nil;
        NHLocker1Option.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("Screws") .. " 8/8 " .. "\n";
    end
    --шкаф 2 контейнер 6
    local NHLocker2Option = subMenuNHContainer:addOption(getText("ContextMenu_NHLocker2"), worldobjects, ISBuildMenu.onNHLocker2Option, square, player);
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 6, NHLocker2Option, player);
    tooltip:setName(getText("ContextMenu_NHLocker2"));
    tooltip.description = getText("Tooltip_NHLocker2") .. tooltip.description;
    tooltip:setTexture("NHC6_5_0");
    ISBuildMenu.requireHammer(NHLocker2Option)
    local Screw = getSpecificPlayer(player):getInventory():getItemCount("Base.Screws", true);
    local Scrap = getSpecificPlayer(player):getInventory():getItemCount("Base.ScrapMetal", true);
    if Scrap < 20 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("ScrapMetal") .. " " .. Scrap .. "/20 " .. "\n";
        NHLocker2Option.onSelect = nil;
        NHLocker2Option.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("ScrapMetal") .. " 20/20 " .. "\n";
    end
    if Screw < 10 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("Screws") .. " " .. Screw .. "/10 " .. "\n";
        NHLocker2Option.onSelect = nil;
        NHLocker2Option.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("Screws") .. " 10/10 " .. "\n";
    end
    --шкаф 3 декор 7
    local NHLocker3Option = subMenuDecoration:addOption(getText("ContextMenu_NHLocker3"), worldobjects, ISBuildMenu.onNHLocker3Option, square, player);
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 7, NHLocker3Option, player);
    tooltip:setName(getText("ContextMenu_NHLocker3"));
    tooltip.description = getText("Tooltip_NHLocker3") .. tooltip.description;
    tooltip:setTexture("NHC7_1_0");
    ISBuildMenu.requireHammer(NHLocker3Option)
    local Screw = getSpecificPlayer(player):getInventory():getItemCount("Base.Screws", true);
    local Scrap = getSpecificPlayer(player):getInventory():getItemCount("Base.ScrapMetal", true);
    if Scrap < 24 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("ScrapMetal") .. " " .. Scrap .. "/24 " .. "\n";
        NHLocker3Option.onSelect = nil;
        NHLocker3Option.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("ScrapMetal") .. " 24/24 " .. "\n";
    end
    if Screw < 12 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("Screws") .. " " .. Screw .. "/12 " .. "\n";
        NHLocker3Option.onSelect = nil;
        NHLocker3Option.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("Screws") .. " 12/12 " .. "\n";
    end
    --шкаф 4 контейнер 7
    local NHLocker4Option = subMenuNHContainer:addOption(getText("ContextMenu_NHLocker4"), worldobjects, ISBuildMenu.onNHLocker4Option, square, player);
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 7, NHLocker4Option, player);
    tooltip:setName(getText("ContextMenu_NHLocker4"));
    tooltip.description = getText("Tooltip_NHLocker4") .. tooltip.description;
    tooltip:setTexture("NHC7_3_0");
    ISBuildMenu.requireHammer(NHLocker4Option)
    local Screw = getSpecificPlayer(player):getInventory():getItemCount("Base.Screws", true);
    local Scrap = getSpecificPlayer(player):getInventory():getItemCount("Base.ScrapMetal", true);
    if Scrap < 28 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("ScrapMetal") .. " " .. Scrap .. "/28 " .. "\n";
        NHLocker4Option.onSelect = nil;
        NHLocker4Option.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("ScrapMetal") .. " 28/28 " .. "\n";
    end
    if Screw < 12 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("Screws") .. " " .. Screw .. "/12 " .. "\n";
        NHLocker4Option.onSelect = nil;
        NHLocker4Option.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("Screws") .. " 12/12 " .. "\n";
    end
    --газонокосилка декор 8
    local LawnMowerOption = subMenuDecoration:addOption(getText("ContextMenu_LawnMower"), worldobjects, ISBuildMenu.onLawnMowerOption, square, player);
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 8, LawnMowerOption, player);
    tooltip:setName(getText("ContextMenu_LawnMower"));
    tooltip.description = getText("Tooltip_LawnMower") .. tooltip.description;
    tooltip:setTexture("NHC8_1_0");
    ISBuildMenu.requireHammer(LawnMowerOption)
    local Screw = getSpecificPlayer(player):getInventory():getItemCount("Base.Screws", true);
    local Scrap = getSpecificPlayer(player):getInventory():getItemCount("Base.ScrapMetal", true);
    if Scrap < 32 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("ScrapMetal") .. " " .. Scrap .. "/32 " .. "\n";
        LawnMowerOption.onSelect = nil;
        LawnMowerOption.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("ScrapMetal") .. " 32/32 " .. "\n";
    end
    if Screw < 14 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("Screws") .. " " .. Screw .. "/14 " .. "\n";
        LawnMowerOption.onSelect = nil;
        LawnMowerOption.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("Screws") .. " 14/14 " .. "\n";
    end
    --тир3бочка бочка 9
    local NHRainCollectorOption = subMenuRC:addOption(getText("ContextMenu_NHRainCollector"), worldobjects, ISBuildMenu.onNHRainCollectorOption, square, player);
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 9, NHRainCollectorOption, player);
    tooltip:setName(getText("ContextMenu_NHRainCollector"));
    tooltip.description = getText("Tooltip_NHRainCollector") .. tooltip.description;
    tooltip:setTexture("NHC9_1_0");
    ISBuildMenu.requireHammer(NHRainCollectorOption)
    local Screw = getSpecificPlayer(player):getInventory():getItemCount("Base.Screws", true);
    local Scrap = getSpecificPlayer(player):getInventory():getItemCount("Base.ScrapMetal", true);
    local Plastic = getSpecificPlayer(player):getInventory():getItemCount("NHM.Plastic", true);
    if Scrap < 24 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("ScrapMetal") .. " " .. Scrap .. "/24 " .. "\n";
        NHRainCollectorOption.onSelect = nil;
        NHRainCollectorOption.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("ScrapMetal") .. " 24/24 " .. "\n";
    end
    if Screw < 8 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("Screws") .. " " .. Screw .. "/8 " .. "\n";
        NHRainCollectorOption.onSelect = nil;
        NHRainCollectorOption.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("Screws") .. " 8/8 " .. "\n";
    end
    if Plastic < 6 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("Plastic") .. " " .. Plastic .. "/6 " .. "\n";
        NHRainCollectorOption.onSelect = nil;
        NHRainCollectorOption.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("Plastic") .. " 6/6 " .. "\n";
    end
    --аниме-плакатик постеры 10
    local AnimePlakatikOption = subMenuPosters:addOption(getText("ContextMenu_AnimePlakatik"), worldobjects, ISBuildMenu.onAnimePlakatikOption, square, player);
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, AnimePlakatikOption, player);
    tooltip:setName(getText("ContextMenu_AnimePlakatik"));
    tooltip.description = getText("Tooltip_AnimePlakatik") .. tooltip.description;
    tooltip:setTexture("PioneerAnime1_0");
    ISBuildMenu.requireHammer(AnimePlakatikOption)
    local Paper = getSpecificPlayer(player):getInventory():getItemCount("Base.SheetPaper2", true);
    if Paper < 20 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("SheetPaper2") .. " " .. Paper .. "/20 " .. "\n";
        AnimePlakatikOption.onSelect = nil;
        AnimePlakatikOption.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("SheetPaper2") .. " 20/20 " .. "\n";
    end

    local RayOption = subMenuPosters:addOption(getText("ContextMenu_RayOfHope"), worldobjects, ISBuildMenu.onRayOption, square, player);
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, RayOption, player);
    tooltip:setName(getText("ContextMenu_RayOfHope"));
    tooltip.description = getText("Tooltip_RayOfHope") .. tooltip.description;
    tooltip:setTexture("RayOfHope_1_0");
    ISBuildMenu.requireHammer(RayOption)
    local Paper = getSpecificPlayer(player):getInventory():getItemCount("Base.SheetPaper2", true);
    if Paper < 20 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("SheetPaper2") .. " " .. Paper .. "/20 " .. "\n";
        RayOption.onSelect = nil;
        RayOption.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("SheetPaper2") .. " 20/20 " .. "\n";
    end

    local ArnoldOption = subMenuPosters:addOption(getText("ContextMenu_Arnold"), worldobjects, ISBuildMenu.onArnoldOption, square, player);
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, ArnoldOption, player);
    tooltip:setName(getText("ContextMenu_Arnold"));
    tooltip.description = getText("Tooltip_Arnold") .. tooltip.description;
    tooltip:setTexture("Arnold_0");
    ISBuildMenu.requireHammer(ArnoldOption)
    local Paper = getSpecificPlayer(player):getInventory():getItemCount("Base.SheetPaper2", true);
    if Paper < 20 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("SheetPaper2") .. " " .. Paper .. "/20 " .. "\n";
        ArnoldOption.onSelect = nil;
        ArnoldOption.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("SheetPaper2") .. " 20/20 " .. "\n";
    end

    local PepeOption = subMenuPosters:addOption(getText("ContextMenu_Pepe"), worldobjects, ISBuildMenu.onPepeOption, square, player);
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, PepeOption, player);
    tooltip:setName(getText("ContextMenu_Pepe"));
    tooltip.description = getText("Tooltip_Pepe") .. tooltip.description;
    tooltip:setTexture("Pepe_0");
    ISBuildMenu.requireHammer(PepeOption)
    local Paper = getSpecificPlayer(player):getInventory():getItemCount("Base.SheetPaper2", true);
    if Paper < 20 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("SheetPaper2") .. " " .. Paper .. "/20 " .. "\n";
        PepeOption.onSelect = nil;
        PepeOption.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("SheetPaper2") .. " 20/20 " .. "\n";
    end

    local VolcharaOption = subMenuPosters:addOption(getText("ContextMenu_Volchara"), worldobjects, ISBuildMenu.onVolcharaOption, square, player);
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, VolcharaOption, player);
    tooltip:setName(getText("ContextMenu_Volchara"));
    tooltip.description = getText("Tooltip_Volchara") .. tooltip.description;
    tooltip:setTexture("Volchara_0");
    ISBuildMenu.requireHammer(VolcharaOption)
    local Paper = getSpecificPlayer(player):getInventory():getItemCount("Base.SheetPaper2", true);
    if Paper < 20 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("SheetPaper2") .. " " .. Paper .. "/20 " .. "\n";
        VolcharaOption.onSelect = nil;
        VolcharaOption.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("SheetPaper2") .. " 20/20 " .. "\n";
    end

    local GayshitOption = subMenuPosters:addOption(getText("ContextMenu_Gayshit"), worldobjects, ISBuildMenu.onGayshitOption, square, player);
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, GayshitOption, player);
    tooltip:setName(getText("ContextMenu_Gayshit"));
    tooltip.description = getText("Tooltip_Gayshit") .. tooltip.description;
    tooltip:setTexture("Gayshit_0");
    ISBuildMenu.requireHammer(GayshitOption)
    local Paper = getSpecificPlayer(player):getInventory():getItemCount("Base.SheetPaper2", true);
    if Paper < 20 and not ISBuildMenu.cheat then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemText("SheetPaper2") .. " " .. Paper .. "/20 " .. "\n";
        GayshitOption.onSelect = nil;
        GayshitOption.notAvailable = true;
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemText("SheetPaper2") .. " 20/20 " .. "\n";
    end
end

ISBuildMenu.buildAdminMenu = function(subMenu, context, option, player)
    if ISBuildMenu.cheat then
        --сабменю ресурсы
        local ResourceOption = subMenu:addOption(getText("ContextMenu_Resources"), worldobjects, nil);
        local subMenuResources = subMenu:getNew(subMenu);
        context:addSubMenu(ResourceOption, subMenuResources);
        --сабменю НПС
        local NPCOption = subMenu:addOption(getText("ContextMenu_NPCs"), worldobjects, nil);
        local subMenuNPCs = subMenu:getNew(subMenu);
        context:addSubMenu(NPCOption, subMenuNPCs);

        local Copper = subMenuResources:addOption(getText("ContextMenu_CopperMine"), worldobjects, ISBuildMenu.CopperMine, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, Copper, player);
        tooltip:setName(getText("ContextMenu_CopperMine"));
        --tooltip.description = getText("Tooltip_craft_stoneFurnaceDesc") .. " <LINE> ";
        tooltip:setTexture("NHCopper_0");

        local Tin = subMenuResources:addOption(getText("ContextMenu_TinMine"), worldobjects, ISBuildMenu.TinMine, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, Tin, player);
        tooltip:setName(getText("ContextMenu_TinMine"));
        --tooltip.description = getText("Tooltip_craft_stoneFurnaceDesc") .. " <LINE> ";
        tooltip:setTexture("NHTin_0");

        local Iron = subMenuResources:addOption(getText("ContextMenu_IronMine"), worldobjects, ISBuildMenu.IronMine, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, Iron, player);
        tooltip:setName(getText("ContextMenu_IronMine"));
        --tooltip.description = getText("Tooltip_craft_stoneFurnaceDesc") .. " <LINE> ";
        tooltip:setTexture("NHIron_0");

        local Lead = subMenuResources:addOption(getText("ContextMenu_LeadMine"), worldobjects, ISBuildMenu.LeadMine, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, Lead, player);
        tooltip:setName(getText("ContextMenu_LeadMine"));
        --tooltip.description = getText("Tooltip_craft_stoneFurnaceDesc") .. " <LINE> ";
        tooltip:setTexture("NHLead_0");

        local Chromium = subMenuResources:addOption(getText("ContextMenu_ChromiumMine"), worldobjects, ISBuildMenu.ChromiumMine, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, Chromium, player);
        tooltip:setName(getText("ContextMenu_ChromiumMine"));
        --tooltip.description = getText("Tooltip_craft_stoneFurnaceDesc") .. " <LINE> ";
        tooltip:setTexture("NHChromium_0");

        local Nickel = subMenuResources:addOption(getText("ContextMenu_NickelMine"), worldobjects, ISBuildMenu.NickelMine, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, Nickel, player);
        tooltip:setName(getText("ContextMenu_NickelMine"));
        --tooltip.description = getText("Tooltip_craft_stoneFurnaceDesc") .. " <LINE> ";
        tooltip:setTexture("NHNickel_0");

        local Gas = subMenuResources:addOption(getText("ContextMenu_GasStation"), worldobjects, ISBuildMenu.GasStation, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, Gas, player);
        tooltip:setName(getText("ContextMenu_GasStation"));
        --tooltip.description = getText("Tooltip_craft_stoneFurnaceDesc") .. " <LINE> ";
        tooltip:setTexture("NHGasL_0");

        local Limestone = subMenuResources:addOption(getText("ContextMenu_LimeMine"), worldobjects, ISBuildMenu.LimeMine, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, Limestone, player);
        tooltip:setName(getText("ContextMenu_LimeMine"));
        --tooltip.description = getText("Tooltip_craft_stoneFurnaceDesc") .. " <LINE> ";
        tooltip:setTexture("NHLimestone_0");

        local Coal = subMenuResources:addOption(getText("ContextMenu_CoalMine"), worldobjects, ISBuildMenu.CoalMine, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, Coal, player);
        tooltip:setName(getText("ContextMenu_CoalMine"));
        --tooltip.description = getText("Tooltip_craft_stoneFurnaceDesc") .. " <LINE> ";
        tooltip:setTexture("NHCoal_0");

        local Salt = subMenuResources:addOption(getText("ContextMenu_SaltMine"), worldobjects, ISBuildMenu.SaltMine, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, Salt, player);
        tooltip:setName(getText("ContextMenu_SaltMine"));
        --tooltip.description = getText("Tooltip_craft_stoneFurnaceDesc") .. " <LINE> ";
        tooltip:setTexture("NHSalt_1_0");

        local Sulfur = subMenuResources:addOption(getText("ContextMenu_SulfurMine"), worldobjects, ISBuildMenu.SulfurMine, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, Sulfur, player);
        tooltip:setName(getText("ContextMenu_SulfurMine"));
        --tooltip.description = getText("Tooltip_craft_stoneFurnaceDesc") .. " <LINE> ";
        tooltip:setTexture("NHSulfur_0");

        local Stone = subMenuResources:addOption(getText("ContextMenu_StoneMine"), worldobjects, ISBuildMenu.StoneMine, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, Stone, player);
        tooltip:setName(getText("ContextMenu_StoneMine"));
        --tooltip.description = getText("Tooltip_craft_stoneFurnaceDesc") .. " <LINE> ";
        tooltip:setTexture("NHStone_1_0");

        local DemiurgeNPC = subMenuNPCs:addOption(getText("ContextMenu_Demiurge"), worldobjects, ISBuildMenu.Demiurge, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, DemiurgeNPC, player);
        tooltip:setName(getText("ContextMenu_Demiurge"));
        --tooltip.description = getText("Tooltip_craft_stoneFurnaceDesc") .. " <LINE> ";
        tooltip:setTexture("Demiurge_0");

        local MVK = subMenuNPCs:addOption(getText("MVK"), worldobjects, ISBuildMenu.MVK, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, MVK, player);
        tooltip:setName(getText("MVK"));
        tooltip:setTexture("A1 psih_5_1");

        local NurseNPC = subMenuNPCs:addOption(getText("ContextMenu_Nurse"), worldobjects, ISBuildMenu.Nurse, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, NurseNPC, player);
        tooltip:setName(getText("ContextMenu_Nurse"));
        --tooltip.description = getText("Tooltip_craft_stoneFurnaceDesc") .. " <LINE> ";
        tooltip:setTexture("Nurse_0");

        local SentryNPC = subMenuNPCs:addOption(getText("ContextMenu_Sentry"), worldobjects, ISBuildMenu.Sentry, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, SentryNPC, player);
        tooltip:setName(getText("ContextMenu_Sentry"));
        --tooltip.description = getText("Tooltip_craft_stoneFurnaceDesc") .. " <LINE> ";
        tooltip:setTexture("Sentry_0");

        local GhostNPC = subMenuNPCs:addOption(getText("ContextMenu_Ghost"), worldobjects, ISBuildMenu.Ghost, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, GhostNPC, player);
        tooltip:setName(getText("ContextMenu_Ghost"));
        --tooltip.description = getText("Tooltip_craft_stoneFurnaceDesc") .. " <LINE> ";
        tooltip:setTexture("Ghost_0");

        local HermitNPC = subMenuNPCs:addOption(getText("ContextMenu_Hermit"), worldobjects, ISBuildMenu.Hermit, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, HermitNPC, player);
        tooltip:setName(getText("ContextMenu_Hermit"));
        --tooltip.description = getText("Tooltip_craft_stoneFurnaceDesc") .. " <LINE> ";
        tooltip:setTexture("Hermit_0");

        local PharmacistNPC = subMenuNPCs:addOption(getText("ContextMenu_Pharmacist"), worldobjects, ISBuildMenu.Pharmacist, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, PharmacistNPC, player);
        tooltip:setName(getText("ContextMenu_Pharmacist"));
        --tooltip.description = getText("Tooltip_craft_stoneFurnaceDesc") .. " <LINE> ";
        tooltip:setTexture("Pharmacist_0");

        local AssistantNPC = subMenuNPCs:addOption(getText("ContextMenu_Assistant"), worldobjects, ISBuildMenu.Assistant, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, AssistantNPC, player);
        tooltip:setName(getText("ContextMenu_Assistant"));
        --tooltip.description = getText("Tooltip_craft_stoneFurnaceDesc") .. " <LINE> ";
        tooltip:setTexture("Assistant_0");

        local HeadNPC = subMenuNPCs:addOption(getText("ContextMenu_Head"), worldobjects, ISBuildMenu.Head, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, HeadNPC, player);
        tooltip:setName(getText("ContextMenu_Head"));
        --tooltip.description = getText("Tooltip_craft_stoneFurnaceDesc") .. " <LINE> ";
        tooltip:setTexture("Head_0");

        local CleanerNPC = subMenuNPCs:addOption(getText("ContextMenu_Cleaner"), worldobjects, ISBuildMenu.Cleaner, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, CleanerNPC, player);
        tooltip:setName(getText("ContextMenu_Cleaner"));
        --tooltip.description = getText("Tooltip_craft_stoneFurnaceDesc") .. " <LINE> ";
        tooltip:setTexture("Cleaner_0");

        local CookNPC = subMenuNPCs:addOption(getText("ContextMenu_Cook"), worldobjects, ISBuildMenu.Cook, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, CookNPC, player);
        tooltip:setName(getText("ContextMenu_Cook"));
        --tooltip.description = getText("Tooltip_craft_stoneFurnaceDesc") .. " <LINE> ";
        tooltip:setTexture("Cook_0");

        local CainNPC = subMenuNPCs:addOption(getText("ContextMenu_Cain"), worldobjects, ISBuildMenu.Cain, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, CainNPC, player);
        tooltip:setName(getText("ContextMenu_Cain"));
        --tooltip.description = getText("Tooltip_craft_stoneFurnaceDesc") .. " <LINE> ";
        tooltip:setTexture("Cain_0");

        local AbelNPC = subMenuNPCs:addOption(getText("ContextMenu_Abel"), worldobjects, ISBuildMenu.Abel, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, AbelNPC, player);
        tooltip:setName(getText("ContextMenu_Abel"));
        --tooltip.description = getText("Tooltip_craft_stoneFurnaceDesc") .. " <LINE> ";
        tooltip:setTexture("Abel_0");

        local TraderNPC = subMenuNPCs:addOption(getText("ContextMenu_Trader"), worldobjects, ISBuildMenu.Trader, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, TraderNPC, player);
        tooltip:setName(getText("ContextMenu_Trader"));
        --tooltip.description = getText("Tooltip_craft_stoneFurnaceDesc") .. " <LINE> ";
        tooltip:setTexture("Trader_0");

        local AspirinNPC = subMenuNPCs:addOption(getText("ContextMenu_Aspirin"), worldobjects, ISBuildMenu.Aspirin, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, AspirinNPC, player);
        tooltip:setName(getText("ContextMenu_Aspirin"));
        --tooltip.description = getText("Tooltip_craft_stoneFurnaceDesc") .. " <LINE> ";
        tooltip:setTexture("Aspirin_0");

        local NerdNPC = subMenuNPCs:addOption(getText("ContextMenu_Nerd"), worldobjects, ISBuildMenu.Nerd, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, NerdNPC, player);
        tooltip:setName(getText("ContextMenu_Nerd"));
        --tooltip.description = getText("Tooltip_craft_stoneFurnaceDesc") .. " <LINE> ";
        tooltip:setTexture("Nerd_0");

        local SparkleNPC = subMenuNPCs:addOption(getText("ContextMenu_Sparkle"), worldobjects, ISBuildMenu.Sparkle, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, SparkleNPC, player);
        tooltip:setName(getText("ContextMenu_Sparkle"));
        --tooltip.description = getText("Tooltip_craft_stoneFurnaceDesc") .. " <LINE> ";
        tooltip:setTexture("Sparkle_0");

        local SilkNPC = subMenuNPCs:addOption(getText("ContextMenu_Silk"), worldobjects, ISBuildMenu.Silk, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, SilkNPC, player);
        tooltip:setName(getText("ContextMenu_Silk"));
        --tooltip.description = getText("Tooltip_craft_stoneFurnaceDesc") .. " <LINE> ";
        tooltip:setTexture("Silk_0");

        local KioshiNPC = subMenuNPCs:addOption(getText("ContextMenu_Kioshi"), worldobjects, ISBuildMenu.Kioshi, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, KioshiNPC, player);
        tooltip:setName(getText("ContextMenu_Kioshi"));
        --tooltip.description = getText("Tooltip_craft_stoneFurnaceDesc") .. " <LINE> ";
        tooltip:setTexture("Kioshi_0");

        local HoundNPC = subMenuNPCs:addOption(getText("ContextMenu_Hound"), worldobjects, ISBuildMenu.Hound, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, HoundNPC, player);
        tooltip:setName(getText("ContextMenu_Hound"));
        --tooltip.description = getText("Tooltip_craft_stoneFurnaceDesc") .. " <LINE> ";
        tooltip:setTexture("Hound_0");

        local Shop = subMenuNPCs:addOption(getText("Shop"), worldobjects, ISBuildMenu.Shop, square, player);
        local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, Shop, player);
        tooltip:setName(getText("Shop"));
        tooltip:setTexture("ShopCrafts_0");
    end
end

ISBuildMenu.Shop = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("ShopCrafts", "ShopCrafts_0", "ShopCrafts_0");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end

--NHM START функции для админского (нпс и ресурсы)
ISBuildMenu.CopperMine = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("Copper Mine", "NHCopper_0", "NHCopper_0");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.TinMine = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("Tin Mine", "NHTin_0", "NHTin_0");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.IronMine = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("Iron Mine", "NHIron_0", "NHIron_0");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.LeadMine = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("Lead Mine", "NHLead_0", "NHLead_0");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.ChromiumMine = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("Chromium Mine", "NHChromium_0", "NHChromium_0");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.NickelMine = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("Nickel Mine", "NHNickel_0", "NHNickel_0");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.GasStation = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("Gas Station", "NHGasL_0", "NHGasR_0");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.LimeMine = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("Limestone Mine", "NHLimestone_0", "NHLimestone_0");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.SaltMine = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("Salt Mine", "NHSalt_1_0", "NHSalt_2_0");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.CoalMine = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("Coal Mine", "NHCoal_0", "NHCoal_0");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.StoneMine = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("Stone Mine", "NHStone_1_0", "NHStone_2_0");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.SulfurMine = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("Sulfur Mine", "NHSulfur_0", "NHSulfur_0");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.Demiurge = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("Demiurge", "Demiurge_0", "Demiurge_0");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.MVK = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("MVK", "A1 psih_5_1", "A1 psih_5_1");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.Sentry = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("Sentry", "Sentry_0", "Sentry_0");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.Ghost = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("Ghost", "Ghost_0", "Ghost_0");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.Hermit = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("Hermit", "Hermit_0", "Hermit_0");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.Nurse = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("Nurse", "Nurse_0", "Nurse_0");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.Assistant = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("Assistant", "Assistant_0", "Assistant_0");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.Head = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("Head", "Head_0", "Head_0");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.Cook = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("Cook", "Cook_0", "Cook_0");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.Pharmacist = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("Pharmacist", "Pharmacist_0", "Pharmacist_0");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.Cleaner = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("Cleaner", "Cleaner_0", "Cleaner_0");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.Cain = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("Cain", "Cain_0", "Cain_0");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.Abel = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("Abel", "Abel_0", "Abel_0");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.Trader = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("Trader", "Trader_0", "Trader_0");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.Sparkle = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("Sparkle", "Sparkle_0", "Sparkle_0");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.Silk = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("Silk", "Silk_0", "Silk_0");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.Nerd = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("Nerd", "Nerd_0", "Nerd_0");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.Aspirin = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("Aspirin", "Aspirin_0", "Aspirin_0");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.Kioshi = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("Kioshi", "Kioshi_0", "Kioshi_0");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.Hound = function(worldobjects, square, player)
    local furniture = ISNHFurniture:new("Hound", "Hound_0", "Hound_0");
    furniture.player = player;
    furniture.maxTime = 1;
    getCell():setDrag(furniture, player);
end
--КОНЕЦ АДМИНСКОГО

--NHM START ФУНКЦИИ ДЛЯ ВЕРСТАКОВ
ISBuildMenu.onChemistryWorkbenchOption = function(worldobjects, square, player, materials, isBlowTorch)
    local furniture = ISWoodenContainer:new("WorkbenchChem_1_0", "WorkbenchChem_2_0")
    furniture.name = "Chemistry Workbench"
    furniture.containerType = "WorkbenchChem"
    MaterialsSync(furniture, materials, isBlowTorch)
    furniture.player = player;
    furniture.completionSound = "BuildWoodenStructureLarge";
    furniture.maxTime = 1000;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onCookingWorkbenchOption = function(worldobjects, square, player, materials, isBlowTorch)
    local furniture = ISWoodenContainer:new("WorkbenchCook_1_0", "WorkbenchCook_2_0")
    furniture.name = "Cooking Workbench"
    furniture.containerType = "WorkbenchCook"
    MaterialsSync(furniture, materials, isBlowTorch)
    furniture.player = player;
    furniture.completionSound = "BuildWoodenStructureLarge";
    furniture.maxTime = 1000;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onMechanicsWorkbenchOption = function(worldobjects, square, player, materials, isBlowTorch)
    local furniture = ISWoodenContainer:new("WorkbenchMech_1_0", "WorkbenchMech_2_0")
    furniture.name = "Mechanics Workbench"
    furniture.firstItem = "BlowTorch";
    furniture.craftingBank = "BlowTorch";
    furniture.noNeedHammer = true;
    furniture.buildLow = false;
    furniture.containerType = "WorkbenchMech"
    MaterialsSync(furniture, materials, isBlowTorch)
    furniture.player = player;
    furniture.completionSound = "BuildWoodenStructureLarge";
    furniture.maxTime = 1000;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onFirstAidWorkbenchOption = function(worldobjects, square, player, materials, isBlowTorch)
    local furniture = ISWoodenContainer:new("WorkbenchMed_1_0", "WorkbenchMed_2_0")
    furniture.firstItem = "BlowTorch";
    furniture.craftingBank = "BlowTorch";
    furniture.noNeedHammer = true;
    furniture.buildLow = false;
    furniture.name = "FirstAid Workbench"
    furniture.containerType = "WorkbenchMed"
    MaterialsSync(furniture, materials, isBlowTorch)
    furniture.player = player;
    furniture.completionSound = "BuildWoodenStructureLarge";
    furniture.maxTime = 1000;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onLeatherworkingWorkbenchOption = function(worldobjects, square, player, materials, isBlowTorch)
    local furniture = ISWoodenContainer:new("WorkbenchLeather_1_0", "WorkbenchLeather_2_0")
    furniture.name = "Leatherworking Workbench"
    furniture.containerType = "WorkbenchLeather"
    MaterialsSync(furniture, materials, isBlowTorch)
    furniture.player = player;
    furniture.completionSound = "BuildWoodenStructureLarge";
    furniture.maxTime = 1000;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onElectricWorkbenchOption = function(worldobjects, square, player, materials, isBlowTorch)
    local furniture = ISWoodenContainer:new("WorkbenchEng_1_0", "WorkbenchEng_2_0")
    furniture.name = "Electric Workbench"
    furniture.firstItem = "BlowTorch";
    furniture.craftingBank = "BlowTorch";
    furniture.noNeedHammer = true;
    furniture.buildLow = false;
    furniture.containerType = "WorkbenchEng"
    MaterialsSync(furniture, materials, isBlowTorch)
    furniture.player = player;
    furniture.completionSound = "BuildWoodenStructureLarge";
    furniture.maxTime = 1000;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onTailorWorkbenchOption = function(worldobjects, square, player, materials, isBlowTorch)
    local furniture = ISWoodenContainer:new("WorkbenchTailor_1_0", "WorkbenchTailor_2_0")
    furniture.name = "Tailor Workbench"
    furniture.containerType = "WorkbenchTailor"
    MaterialsSync(furniture, materials, isBlowTorch)
    furniture.player = player;
    furniture.completionSound = "BuildWoodenStructureLarge";
    furniture.maxTime = 1000;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onNHStillOption = function(worldobjects, square, player, materials, isBlowTorch)
    local furniture = ISNHStill:new("NHStill", getSpecificPlayer(player), "Still_1_0", "Still_2_0");
    furniture.firstItem = "BlowTorch";
    furniture.craftingBank = "BlowTorch";
    furniture.noNeedHammer = true;
    furniture.buildLow = false;
    MaterialsSync(furniture, materials, isBlowTorch)
    furniture.player = player;
    furniture.completionSound = "BuildWoodenStructureLarge";
    furniture.maxTime = 1000;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onEngineerWorkbenchOption = function(worldobjects, square, player, materials, isBlowTorch)
    local furniture = ISWoodenContainer:new("WorkbenchEngineer_1_0", "WorkbenchEngineer_2_0")
    furniture.name = "Engineer Workbench"
    furniture.containerType = "WorkbenchEngineer"
    MaterialsSync(furniture, materials, isBlowTorch)
    furniture.player = player;
    furniture.completionSound = "BuildWoodenStructureLarge";
    furniture.maxTime = 1000;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onResearchWorkbenchOption = function(worldobjects, square, player)
    local furniture = ISResearchWorkbench:new("Research Workbench", getSpecificPlayer(player), "WorkbenchResearch_1_0", "WorkbenchResearch_2_0");
    furniture.modData["need:Base.ScrapMetal"] = "10";
    furniture.player = player;
    furniture.completionSound = "BuildWoodenStructureLarge";
    furniture.maxTime = 1000;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onNHAnvilOption = function(worldobjects, square, player, materials, isBlowTorch)
    local furniture = ISNHAnvil:new("NHAnvil", getSpecificPlayer(player), "Anvil_1_0", "Anvil_2_0");
    furniture.firstItem = "BlowTorch";
    furniture.craftingBank = "BlowTorch";
    furniture.noNeedHammer = true;
    furniture.buildLow = false;
    MaterialsSync(furniture, materials, isBlowTorch)
    furniture.canBeAlwaysPlaced = true;
    furniture.player = player;
    furniture.completionSound = "BuildWoodenStructureLarge";
    furniture.maxTime = 1000;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onStoneFurnaceOption = function(worldobjects, square, player, materials, isBlowTorch)
    local furniture = ISWoodenContainer:new("Furnace_1_0", "Furnace_2_0")
    furniture.name = "Stone Furnace"
    furniture.containerType = "Furnace"
    MaterialsSync(furniture, materials, isBlowTorch)
    furniture.player = player;
    furniture.completionSound = "BuildWoodenStructureLarge";
    furniture.maxTime = 1000;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onBlastFurnaceOption = function(worldobjects, square, player, materials, isBlowTorch)
    local furniture = ISWoodenContainer:new("BlastFurnace_1_0", "BlastFurnace_2_0")
    furniture.name = "Blast Furnace"
    furniture.containerType = "BlastFurnace"
    furniture.firstItem = "BlowTorch";
    furniture.craftingBank = "BlowTorch";
    furniture.noNeedHammer = true;
    furniture.buildLow = false;
    MaterialsSync(furniture, materials, isBlowTorch)
    furniture.player = player;
    furniture.completionSound = "BuildWoodenStructureLarge";
    furniture.maxTime = 1000;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onTrainerOption = function(worldobjects, square, player, materials, isBlowTorch)
    local furniture = ISSimpleFurniture:new("Trainer", "WorkbenchAgility_1_0", "WorkbenchAgility_2_0");
    MaterialsSync(furniture, materials, isBlowTorch)
    furniture.player = player;
    furniture.completionSound = "BuildWoodenStructureLarge";
    furniture.maxTime = 1000;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onTelescopeOption = function(worldobjects, square, player)
    local furniture = ISSimpleFurniture:new("NHTelescope", "NHC1_1_0", "NHC1_2_0");
    furniture.modData["need:Base.ScrapMetal"] = "5";
    furniture.modData["need:Base.Screws"] = "3";
    furniture.modData["need:NHM.Glass"] = "3";
    furniture.modData["xp:Woodwork"] = 5;
    furniture.blockAllTheSquare = true;
    furniture.player = player;
    furniture.maxTime = 250;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onCameraOption = function(worldobjects, square, player)
    local furniture = ISSimpleFurniture:new("NHCamera", "NHC2_3_0", "NHC2_4_0");
    furniture.modData["need:Base.ScrapMetal"] = "7";
    furniture.modData["need:Base.Screws"] = "5";
    furniture.modData["need:NHM.Glass"] = "3";
    furniture.blockAllTheSquare = true;
    furniture.player = player;
    furniture.maxTime = 250;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onSearchlightOption = function(worldobjects, square, player)
    -- sprite, northSprite
    local lamp = ISLightSource:new("NHC2_1_0", "NHC2_2_0", getSpecificPlayer(player));
    lamp.offsetX = 0;
    lamp.offsetY = 0;
    lamp.modData["xp:Woodwork"] = 5;
    lamp.name = "NHSearchlight";
    lamp.modData["need:Base.ScrapMetal"] = "4";
    lamp.modData["need:NHM.Glass"] = "3";
    lamp.modData["need:Base.Screws"] = "3";
    lamp.modData["xp:Woodwork"] = 5;
    --    lamp.modData["need:Base.Torch"] = "1";
    lamp.fuel = "Base.Battery";
    lamp.baseItem = "Base.Torch";
    lamp.blockAllTheSquare = true;
    lamp.radius = 6;
    lamp.player = player;
    lamp.completionSound = "BuildWoodenStructureLarge"
    getCell():setDrag(lamp, player);
end

ISBuildMenu.onNHBookCaseOption = function(worldobjects, sprite, player)
    -- sprite, northSprite
    local bc = ISSimpleFurniture:new("NHBookCase", "NHC3_1_0", "NHC3_2_0");
    bc.canBeAlwaysPlaced = true;
    bc.isContainer = true;
    bc.blockAllTheSquare = true;
    bc.modData["xp:Woodwork"] = 5;
    bc.modData["need:Base.ScrapMetal"] = "3";
    bc.modData["need:Base.Plank"] = "4";
    bc.modData["need:Base.Nails"] = "6";
    bc.player = player;
    bc.renderFloorHelper = true;
    bc.completionSound = "BuildWoodenStructureMedium";
    getCell():setDrag(bc, player);
end

ISBuildMenu.onNHSmallBookCaseOption = function(worldobjects, sprite, player)
    -- sprite, northSprite
    local bc = ISSimpleFurniture:new("NHSmallBookCase", "NHC3_3_0", "NHC3_4_0");
    bc.canBeAlwaysPlaced = true;
    bc.isContainer = true;
    bc.modData["xp:Woodwork"] = 5;
    bc.modData["need:Base.ScrapMetal"] = "2";
    bc.modData["need:Base.Plank"] = "4";
    bc.modData["need:Base.Nails"] = "2";
    bc.blockAllTheSquare = true;
    bc.player = player;
    bc.renderFloorHelper = true;
    bc.completionSound = "BuildWoodenStructureMedium";
    getCell():setDrag(bc, player);
end

ISBuildMenu.onFanLockerOption = function(worldobjects, sprite, player)
    -- sprite, northSprite
    local bc = ISSimpleFurniture:new("NHFanLocker", "NHC3_5_0", "NHC3_6_0");
    bc.canBeAlwaysPlaced = true;
    bc.isContainer = true;
    bc.modData["xp:Woodwork"] = 5;
    bc.modData["need:Base.ScrapMetal"] = "8";
    bc.modData["need:Base.Plank"] = "2";
    bc.modData["need:Base.Nails"] = "6";
    bc.blockAllTheSquare = true;
    bc.player = player;
    bc.renderFloorHelper = true;
    bc.completionSound = "BuildWoodenStructureMedium";
    getCell():setDrag(bc, player);
end

ISBuildMenu.onSlotMachine1Option = function(worldobjects, square, player)
    -- sprite, northSprite
    local furniture = ISSimpleFurniture:new("SM1", "NHC4_1_0", "NHC4_2_0");
    furniture.modData["xp:Woodwork"] = 5;
    furniture.modData["need:Base.ScrapMetal"] = "12";
    furniture.modData["need:Base.ElectronicsScrap"] = "6";
    furniture.blockAllTheSquare = true;
    furniture.player = player;
    furniture.maxTime = 250;
    furniture.renderFloorHelper = true;
    furniture.completionSound = "BuildWoodenStructureMedium";
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onSlotMachine2Option = function(worldobjects, square, player)
    -- sprite, northSprite
    local furniture = ISSimpleFurniture:new("SM2", "NHC4_3_0", "NHC4_4_0");
    furniture.modData["xp:Woodwork"] = 5;
    furniture.modData["need:Base.ScrapMetal"] = "12";
    furniture.modData["need:Base.ElectronicsScrap"] = "6";
    furniture.blockAllTheSquare = true;
    furniture.player = player;
    furniture.maxTime = 250;
    furniture.renderFloorHelper = true;
    furniture.completionSound = "BuildWoodenStructureMedium";
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onSlotMachine3Option = function(worldobjects, square, player)
    -- sprite, northSprite
    local furniture = ISSimpleFurniture:new("SM3", "NHC4_5_0", "NHC4_6_0");
    furniture.modData["xp:Woodwork"] = 5;
    furniture.modData["need:Base.ScrapMetal"] = "12";
    furniture.modData["need:Base.ElectronicsScrap"] = "6";
    furniture.blockAllTheSquare = true;
    furniture.player = player;
    furniture.maxTime = 250;
    furniture.renderFloorHelper = true;
    furniture.completionSound = "BuildWoodenStructureMedium";
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onSlotMachine4Option = function(worldobjects, square, player)
    -- sprite, northSprite
    local furniture = ISSimpleFurniture:new("SM4", "NHC4_7_0", "NHC4_8_0");
    furniture.modData["xp:Woodwork"] = 5;
    furniture.modData["need:Base.ScrapMetal"] = "12";
    furniture.modData["need:Base.ElectronicsScrap"] = "6";
    furniture.blockAllTheSquare = true;
    furniture.player = player;
    furniture.maxTime = 250;
    furniture.renderFloorHelper = true;
    furniture.completionSound = "BuildWoodenStructureMedium";
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onSlotMachine5Option = function(worldobjects, square, player)
    -- sprite, northSprite
    local furniture = ISSimpleFurniture:new("SM5", "NHC4_9_0", "NHC4_10_0");
    furniture.modData["xp:Woodwork"] = 5;
    furniture.modData["need:Base.ScrapMetal"] = "12";
    furniture.modData["need:Base.ElectronicsScrap"] = "6";
    furniture.blockAllTheSquare = true;
    furniture.player = player;
    furniture.maxTime = 250;
    furniture.renderFloorHelper = true;
    furniture.completionSound = "BuildWoodenStructureMedium";
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onSlotMachine6Option = function(worldobjects, square, player)
    -- sprite, northSprite
    local furniture = ISSimpleFurniture:new("SM6", "NHC4_11_0", "NHC4_12_0");
    furniture.modData["xp:Woodwork"] = 5;
    furniture.modData["need:Base.ScrapMetal"] = "12";
    furniture.modData["need:Base.ElectronicsScrap"] = "6";
    furniture.blockAllTheSquare = true;
    furniture.player = player;
    furniture.maxTime = 250;
    furniture.renderFloorHelper = true;
    furniture.completionSound = "BuildWoodenStructureMedium";
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onStoneWell1Option = function(worldobjects, square, player)
    local furniture = ISSimpleFurniture:new("NHStoneWell1", "NHC5_1_0", "NHC5_1_0");
    furniture.modData["need:Base.Stone"] = "40";
    furniture.modData["xp:Woodwork"] = 5;
    furniture.blockAllTheSquare = true;
    furniture.player = player;
    furniture.maxTime = 250;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onStoneWell2Option = function(worldobjects, square, player)
    local furniture = ISSimpleFurniture:new("NHStoneWell2", "NHC5_2_0", "NHC5_2_0");
    furniture.modData["need:Base.Stone"] = "40";
    furniture.modData["xp:Woodwork"] = 5;
    furniture.blockAllTheSquare = true;
    furniture.player = player;
    furniture.maxTime = 250;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onFarmDec1Option = function(worldobjects, square, player)
    local furniture = ISSimpleFurniture:new("NHFarmDec1", "NHC5_3_0", "NHC5_4_0");
    furniture.modData["need:Base.Plank"] = "6";
    furniture.modData["need:Base.Nails"] = "10";
    furniture.modData["xp:Woodwork"] = 5;
    furniture.blockAllTheSquare = true;
    furniture.player = player;
    furniture.maxTime = 250;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onFarmDec2Option = function(worldobjects, square, player)
    local furniture = ISSimpleFurniture:new("NHFarmDec2", "NHC5_5_0", "NHC5_6_0");
    furniture.modData["need:Base.Plank"] = "6";
    furniture.modData["need:Base.Nails"] = "6";
    furniture.modData["need:NHM.Plastic"] = "6";
    furniture.modData["xp:Woodwork"] = 5;
    furniture.blockAllTheSquare = true;
    furniture.player = player;
    furniture.maxTime = 250;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onFarmDec3Option = function(worldobjects, square, player)
    local furniture = ISSimpleFurniture:new("NHFarmDec3", "NHC5_7_0", "NHC5_7_0");
    furniture.modData["need:Base.Plank"] = "6";
    furniture.modData["need:Base.Nails"] = "6";
    furniture.modData["xp:Woodwork"] = 5;
    furniture.blockAllTheSquare = true;
    furniture.player = player;
    furniture.maxTime = 250;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onFarmDec4Option = function(worldobjects, square, player)
    local furniture = ISSimpleFurniture:new("NHFarmDec4", "NHC5_8_0", "NHC5_8_0");
    furniture.modData["need:Base.Plank"] = "6";
    furniture.modData["need:Base.Nails"] = "6";
    furniture.modData["xp:Woodwork"] = 5;
    furniture.blockAllTheSquare = true;
    furniture.player = player;
    furniture.maxTime = 250;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onNHLocker1Option = function(worldobjects, square, player)
    local furniture = ISSimpleFurniture:new("NHLocker1", "NHC6_3_0", "NHC6_4_0");
    furniture.modData["need:Base.ScrapMetal"] = "15";
    furniture.modData["need:Base.Screws"] = "8";
    furniture.modData["xp:Woodwork"] = 5;
    furniture.blockAllTheSquare = true;
    furniture.player = player;
    furniture.maxTime = 250;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onNHLocker2Option = function(worldobjects, square, player)
    local furniture = ISSimpleFurniture:new("NHLocker2", "NHC6_5_0", "NHC6_6_0");
    furniture.canBeAlwaysPlaced = true;
    furniture.blockAllTheSquare = true;
    furniture.isContainer = true;
    furniture.modData["need:Base.ScrapMetal"] = "20";
    furniture.modData["need:Base.Screws"] = "10";
    furniture.modData["xp:Woodwork"] = 5;
    furniture.player = player;
    furniture.maxTime = 250;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onNHLocker3Option = function(worldobjects, square, player)
    local furniture = ISSimpleFurniture:new("NHLocker3", "NHC7_1_0", "NHC7_2_0");
    furniture.blockAllTheSquare = true;
    furniture.modData["need:Base.ScrapMetal"] = "24";
    furniture.modData["need:Base.Screws"] = "12";
    furniture.modData["xp:Woodwork"] = 5;
    furniture.player = player;
    furniture.maxTime = 250;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onNHLocker4Option = function(worldobjects, square, player)
    local furniture = ISSimpleFurniture:new("NHLocker4", "NHC7_3_0", "NHC7_4_0");
    furniture.canBeAlwaysPlaced = true;
    furniture.blockAllTheSquare = true;
    furniture.isContainer = true;
    furniture.modData["need:Base.ScrapMetal"] = "28";
    furniture.modData["need:Base.Screws"] = "12";
    furniture.modData["xp:Woodwork"] = 5;
    furniture.player = player;
    furniture.maxTime = 250;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onLawnMowerOption = function(worldobjects, square, player)
    local furniture = ISSimpleFurniture:new("LawnMower", "NHC8_1_0", "NHC8_2_0");
    furniture.blockAllTheSquare = true;
    furniture.modData["need:Base.ScrapMetal"] = "32";
    furniture.modData["need:Base.Screws"] = "14";
    furniture.modData["xp:Woodwork"] = 5;
    furniture.player = player;
    furniture.maxTime = 250;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onNHRainCollectorOption = function(worldobjects, square, player, waterMax)
    local barrel = RainCollectorBarrel:new(player, "NHC9_1_0", 2000);
    barrel.modData["need:Base.ScrapMetal"] = "24";
    barrel.modData["need:Base.Screws"] = "8";
    barrel.modData["need:NHM.Plastic"] = "6";
    barrel.modData["xp:Woodwork"] = 5;
    barrel.player = player;
    barrel.completionSound = "BuildWoodenStructureMedium";
    getCell():setDrag(barrel, player);
end

ISBuildMenu.onAnimePlakatikOption = function(worldobjects, square, player)
    local furniture = ISSimpleFurniture:new("AnimePlakatik", "PioneerAnime1_0", "PioneerAnime2_0");
    furniture.modData["need:Base.SheetPaper2"] = "20";
    furniture.needToBeAgainstWall = true;
    furniture.buildLow = false;
    furniture.blockAllTheSquare = false;
    furniture.isWallLike = true
    furniture.modData["xp:Woodwork"] = 5;
    furniture.player = player;
    furniture.maxTime = 250;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onRayOption = function(worldobjects, square, player)
    local furniture = ISSimpleFurniture:new("RayOfHope", "RayOfHope_1_0", "RayOfHope_2_0");
    furniture.modData["need:Base.SheetPaper2"] = "20";
    furniture.needToBeAgainstWall = true;
    furniture.buildLow = false;
    furniture.blockAllTheSquare = false;
    furniture.isWallLike = true
    furniture.modData["xp:Woodwork"] = 5;
    furniture.player = player;
    furniture.maxTime = 250;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onArnoldOption = function(worldobjects, square, player)
    local furniture = ISSimpleFurniture:new("Arnold", "Arnold_0", "Arnold2_0");
    furniture.modData["need:Base.SheetPaper2"] = "20";
    furniture.needToBeAgainstWall = true;
    furniture.buildLow = false;
    furniture.blockAllTheSquare = false;
    furniture.isWallLike = true
    furniture.modData["xp:Woodwork"] = 5;
    furniture.player = player;
    furniture.maxTime = 250;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onPepeOption = function(worldobjects, square, player)
    local furniture = ISSimpleFurniture:new("Pepe", "Pepe_0", "Pepe2_0");
    furniture.modData["need:Base.SheetPaper2"] = "20";
    furniture.needToBeAgainstWall = true;
    furniture.buildLow = false;
    furniture.blockAllTheSquare = false;
    furniture.isWallLike = true
    furniture.modData["xp:Woodwork"] = 5;
    furniture.player = player;
    furniture.maxTime = 250;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onVolcharaOption = function(worldobjects, square, player)
    local furniture = ISSimpleFurniture:new("Volchara", "LVK_0", "LVK2_0");
    furniture.modData["need:Base.SheetPaper2"] = "20";
    furniture.needToBeAgainstWall = true;
    furniture.buildLow = false;
    furniture.blockAllTheSquare = false;
    furniture.isWallLike = true
    furniture.modData["xp:Woodwork"] = 5;
    furniture.player = player;
    furniture.maxTime = 250;
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onGayshitOption = function(worldobjects, square, player)
    local furniture = ISSimpleFurniture:new("Gayshit", "Gayshit_0", "Gayshit2_0");
    furniture.modData["need:Base.SheetPaper2"] = "20";
    furniture.needToBeAgainstWall = true;
    furniture.buildLow = false;
    furniture.blockAllTheSquare = false;
    furniture.isWallLike = true
    furniture.modData["xp:Woodwork"] = 5;
    furniture.player = player;
    furniture.maxTime = 250;
    getCell():setDrag(furniture, player);
end
--NHM END


function haveSomethingtoBuildWood(player)
    local playerObj = getSpecificPlayer(player)
    local playerInv = playerObj:getInventory()
    ISBuildMenu.materialOnGround = buildUtil.checkMaterialOnGround(playerObj:getCurrentSquare())
    if ISBuildMenu.cheat then
        return true;
    end
    ISBuildMenu.planks = 0;
    ISBuildMenu.nails = 0;
    ISBuildMenu.nailsBox = 0;
    ISBuildMenu.hinge = 0;
    ISBuildMenu.doorknob = 0;
    ISBuildMenu.hasHammer = playerInv:containsTagEvalRecurse("Hammer", predicateNotBroken)
    if ISBuildMenu.hasHammer then
        -- most objects require a hammer
    elseif ISBuildMenu.countMaterial(player, "Base.Sandbag") >= 3 or ISBuildMenu.countMaterial(player, "Base.Gravelbag") >= 3 then
        -- no hammer required
    elseif ISBuildMenu.canBuildLogWall(player) then
        -- no hammer required
    else
        return false
    end
    ISBuildMenu.planks = ISBuildMenu.countMaterial(player, "Base.Plank")
    --nails boxes have 100 nails in them, these are added to the nails count to allow for automatic opening of nails boxes when building objects
    ISBuildMenu.nailsBox = ISBuildMenu.countMaterial(player, "Base.NailsBox")
    ISBuildMenu.nails = ISBuildMenu.countMaterial(player, "Base.Nails") + (ISBuildMenu.nailsBox * 100)
    ISBuildMenu.hinge = ISBuildMenu.countMaterial(player, "Base.Hinge")
    ISBuildMenu.doorknob = ISBuildMenu.countMaterial(player, "Base.Doorknob")
    return true;
end

ISBuildMenu.isNailsBoxNeededOpening = function(nailsRequired)
    if ISBuildMenu.nails - (ISBuildMenu.nailsBox * 100) < nailsRequired then
        return true;
    end
end

ISBuildMenu.onMultiStageBuildSelected = function(cursor, square)
    local worldobjects = ISBuildMenu.cursor.worldobjects;
    local stage = ISBuildMenu.cursor.stage;
    local item = ISBuildMenu.cursor.item;
    local playerObj = ISBuildMenu.cursor.character;
    local player = ISBuildMenu.cursor.player;
    local playerInv = playerObj:getInventory()
    --if luautils.walkAdjWall(playerObj, item:getSquare(), item:getNorth(), false) then
    if not ISBuildMenu.cheat then
        local groundItems = buildUtil.getMaterialOnGround(item:getSquare())
        local itemsRequired = stage:getItemsLua()
        -- equip required items
        local first = true;
        for i = 0, stage:getItemsToKeep():size() - 1 do
            local itemToEquip = stage:getItemsToKeep():get(i);
            if itemToEquip == "Base.Hammer" then
                local hammer = playerInv:getFirstTagEvalRecurse("Hammer", predicateNotBroken)
                if hammer then
                    itemToEquip = hammer:getFullType()
                end
            end
            local item2 = playerInv:getFirstTypeEvalRecurse(itemToEquip, predicateNotBroken)
            if item2 then
                ISInventoryPaneContextMenu.transferIfNeeded(playerObj, item2)
            else
                for _, item3 in ipairs(groundItems[itemToEquip]) do
                    if predicateNotBroken(item3) then
                        item2 = item3
                        break
                    end
                end
                local time = ISWorldObjectContextMenu.grabItemTime(playerObj, item2:getWorldItem())
                ISTimedActionQueue.add(ISGrabItemAction:new(playerObj, item2:getWorldItem(), time))
            end
            if not playerObj:hasEquipped(itemToEquip) and item2 then
                ISInventoryPaneContextMenu.equipWeapon(item2, first, false, player)
            end
            if not first then
                break ;
            end
            first = false;
        end
        --[[
                        -- Move required items to main inventory.
                        -- Not doing this because carpentry code doesn't.
                        for x,v in pairs(itemsRequired) do
                            local item = ISBuildMenu.GetItemInstance(x);
                            if item then
                                if instanceof(item, "DrainableComboItem") then
                                    local drainable = playerInv:getFirstTypeEvalArgRecurse(x, predicateDrainableUsesInt, tonumber(v))
                                    ISInventoryPaneContextMenu.transferIfNeeded(playerObj, drainable)
                                else
                                    local required = playerInv:getSomeTypeRecurse(x, tonumber(v))
                                    ISInventoryPaneContextMenu.transferIfNeeded(playerObj, required)
                                end
                            end
                        end
            --]]
    end
    ISTimedActionQueue.add(ISMultiStageBuild:new(playerObj, stage, item, stage:getTimeNeeded(playerObj)));
    --end
end

ISBuildMenu.isMultiStageValid = function()
    if not ISBuildMenu.cursor or not ISBuildMenu.cursor.sq then
        return false;
    end
    local available = true;
    local tooltipTxt = "";
    local cursor = ISBuildMenu.cursor;
    cursor.tooltipTxt = nil;
    cursor.sprite = nil;
    local stage = cursor.stage;
    local playerObj = cursor.character;
    local playerInv = playerObj:getInventory();
    local items = stage:getItemsLua();
    local perks = stage:getPerksLua();
    local sq = cursor.sq;
    local thump;
    local stages;
    for i = 0, sq:getSpecialObjects():size() - 1 do
        local object = sq:getSpecialObjects():get(i);
        if instanceof(object, "IsoThumpable") and not object:isDoor() then
            stages = MultiStageBuilding.getStages(playerObj, object, ISBuildMenu.cheat);
            if stages and not stages:isEmpty() and stages:contains(stage) then
                thump = object;
                break ;
            end
        end
    end

    if not thump then
        return false;
    end

    if not ISBuildMenu.cheat then
        local groundItems = buildUtil.getMaterialOnGround(sq)
        local groundItemCounts = buildUtil.getMaterialOnGroundCounts(groundItems)
        local groundItemUses = buildUtil.getMaterialOnGroundUses(groundItems)
        for x = 0, stage:getItemsToKeep():size() - 1 do
            local itemString = stage:getItemsToKeep():get(x);
            if itemString == "Base.Hammer" then
                local hammer = playerInv:getFirstTagEvalRecurse("Hammer", predicateNotBroken)
                if hammer then
                    itemString = hammer:getFullType()
                end
            end
            local item = ISBuildMenu.GetItemInstance(itemString);
            if item then
                local hasItem = playerInv:containsTypeEvalRecurse(itemString, predicateNotBroken)
                if not hasItem and groundItems[itemString] then
                    for _, item3 in ipairs(groundItems[itemString]) do
                        if predicateNotBroken(item3) then
                            hasItem = true
                            break
                        end
                    end
                end
                if hasItem then
                    tooltipTxt = tooltipTxt .. " <RGB:1,1,1> " .. item:getName() .. " <LINE> ";
                else
                    tooltipTxt = tooltipTxt .. " <RGB:1,0,0> " .. item:getName() .. " <LINE> ";
                    available = false;
                end
            end
        end
        tooltipTxt = tooltipTxt .. " <LINE> ";
        for x, v in pairs(items) do
            local item = ISBuildMenu.GetItemInstance(x);
            if item then
                if instanceof(item, "DrainableComboItem") then
                    local useLeft = playerInv:getUsesTypeRecurse(x);
                    if groundItemUses[x] then
                        useLeft = useLeft + groundItemUses[x];
                    end
                    if useLeft >= tonumber(v) then
                        tooltipTxt = tooltipTxt .. " <RGB:1,1,1> " .. item:getName() .. " " .. useLeft .. "/" .. v .. " <LINE> ";
                    else
                        tooltipTxt = tooltipTxt .. " <RGB:1,0,0> " .. item:getName() .. " " .. useLeft .. "/" .. v .. " <LINE> ";
                        available = false;
                    end
                else
                    local nbOfItem = playerInv:getCountTypeEvalRecurse(x, buildUtil.predicateMaterial);
                    if groundItemCounts[x] then
                        nbOfItem = nbOfItem + groundItemCounts[x];
                    end
                    if x == "Base.Nails" then
                        nbOfItem = nbOfItem + playerInv:getCountTypeEvalRecurse("Base.NailsBox", buildUtil.predicateMaterial) * 100;
                        if groundItemCounts["Base.NailsBox"] then
                            nbOfItem = nbOfItem + groundItemCounts["Base.NailsBox"] * 100;
                        end
                    end
                    if nbOfItem >= tonumber(v) then
                        tooltipTxt = tooltipTxt .. " <RGB:1,1,1> " .. item:getName() .. " " .. nbOfItem .. "/" .. v .. " <LINE> ";
                    else
                        tooltipTxt = tooltipTxt .. " <RGB:1,0,0> " .. item:getName() .. " " .. nbOfItem .. "/" .. v .. " <LINE> ";
                        available = false;
                    end
                end
            end
        end
        tooltipTxt = tooltipTxt .. " <LINE> ";
        for x, v in pairs(perks) do
            local perk = PerkFactory.getPerk(x);
            if playerObj:getPerkLevel(x) >= tonumber(v) then
                tooltipTxt = tooltipTxt .. " <RGB:1,1,1> " .. getText("IGUI_perks_" .. perk:getType():toString()) .. " " .. playerObj:getPerkLevel(x) .. "/" .. v .. " <LINE>";
            else
                tooltipTxt = tooltipTxt .. " <RGB:1,0,0> " .. getText("IGUI_perks_" .. perk:getType():toString()) .. " " .. playerObj:getPerkLevel(x) .. "/" .. v .. " <LINE>";
                available = false;
            end
        end
        local knownRecipe = stage:getKnownRecipe()
        if knownRecipe then
            tooltipTxt = tooltipTxt .. " <LINE> "
            if playerObj:isRecipeKnown(stage:getKnownRecipe()) then
                tooltipTxt = tooltipTxt .. " <RGB:1,1,1> " .. getText("Tooltip_vehicle_requireRecipe", getRecipeDisplayName(knownRecipe)) .. " <LINE>"
            else
                tooltipTxt = tooltipTxt .. " <RGB:1,0,0> " .. getText("Tooltip_vehicle_requireRecipe", getRecipeDisplayName(knownRecipe)) .. " <LINE>"
                available = false;
            end
        end
    end

    if cursor.tooltipTxt ~= "" then
        cursor.tooltipTxt = tooltipTxt;
    end
    if thump and stage then
        cursor.item = thump;
        if thump:getNorth() then
            cursor.sprite = stage:getNorthSprite();
        else
            cursor.sprite = stage:getSprite();
        end
    end
    return available;
end

ISBuildMenu.onMultiStageBuild = function(worldobjects, stage, item, player)
    ISBuildMenu.cursor = ISBuildCursorMouse:new(player, ISBuildMenu.onMultiStageBuildSelected, ISBuildMenu.isMultiStageValid)
    ISBuildMenu.cursor.isWallLike = true;
    getCell():setDrag(ISBuildMenu.cursor, player:getPlayerNum())
    ISBuildMenu.cursor.worldobjects = worldobjects;
    ISBuildMenu.cursor.stage = stage;
    ISBuildMenu.cursor.item = item;
    if item:getNorth() then
        ISBuildMenu.cursor.sprite = stage:getNorthSprite();
    else
        ISBuildMenu.cursor.sprite = stage:getSprite();
    end
end

ISBuildMenu.canDoStage = function(player, stage)
    local playerInv = player:getInventory()
    if ISBuildMenu.cheat then
        return true;
    end
    if stage:getKnownRecipe() and not player:isRecipeKnown(stage:getKnownRecipe()) then
        return false
    end
    local groundItems = buildUtil.getMaterialOnGround(player:getCurrentSquare())
    local groundItemCounts = buildUtil.getMaterialOnGroundCounts(groundItems)
    local groundItemUses = buildUtil.getMaterialOnGroundUses(groundItems)
    local items = stage:getItemsLua();
    for x = 0, stage:getItemsToKeep():size() - 1 do
        local itemString = stage:getItemsToKeep():get(x)
        if itemString == "Base.Hammer" then
            local hammer = playerInv:getFirstTagEvalRecurse("Hammer", predicateNotBroken)
            if hammer then
                itemString = hammer:getFullType()
            end
        end
        local item = ISBuildMenu.GetItemInstance(itemString);
        if item then
            local hasItem = playerInv:containsTypeEvalRecurse(itemString, predicateNotBroken)
            if not hasItem and groundItems[itemString] then
                for _, item3 in ipairs(groundItems[itemString]) do
                    if predicateNotBroken(item3) then
                        hasItem = true
                        break
                    end
                end
            end
            if not hasItem then
                return false;
            end
        end
    end
    for x, v in pairs(items) do
        local item = ISBuildMenu.GetItemInstance(x);
        if item then
            if instanceof(item, "DrainableComboItem") then
                local useLeft = playerInv:getUsesTypeRecurse(x);
                if groundItemUses[x] then
                    useLeft = useLeft + groundItemUses[x];
                end
                if useLeft < tonumber(v) then
                    return false;
                end
            else
                local nbOfItem = playerInv:getCountTypeEvalRecurse(x, buildUtil.predicateMaterial)
                if groundItemCounts[x] then
                    nbOfItem = nbOfItem + groundItemCounts[x]
                end
                if x == "Base.Nails" then
                    nbOfItem = nbOfItem + playerInv:getCountTypeEvalRecurse("Base.NailsBox", buildUtil.predicateMaterial) * 100
                    if groundItemCounts["Base.NailsBox"] then
                        nbOfItem = nbOfItem + groundItemCounts["Base.NailsBox"] * 100
                    end
                end
                if nbOfItem < tonumber(v) then
                    return false;
                end
            end
        end
    end
    return true;
end

-- **********************************************
-- **                   *MISC*                  **
-- **********************************************
ISBuildMenu.buildMiscMenu = function(subMenu, option, player)
    local crossOption = subMenu:addOption(getText("ContextMenu_Wooden_Cross"), worldobjects, ISBuildMenu.onWoodenCross, square, player);
    local toolTip = ISBuildMenu.canBuild(2, 2, 0, 0, 0, 0, crossOption, player);
    toolTip.description = getText("Tooltip_craft_woodenCrossDesc") .. toolTip.description;
    toolTip:setName(getText("ContextMenu_Wooden_Cross"));
    toolTip:setTexture("location_community_cemetary_01_23");
    ISBuildMenu.requireHammer(crossOption);

    local stonePileOption = subMenu:addOption(getText("ContextMenu_Stone_Pile"), worldobjects, ISBuildMenu.onStonePile, square, player);
    local toolTip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, stonePileOption, player);
    toolTip.description = getText("Tooltip_craft_stonePileDesc") .. toolTip.description;
    -- we add that we need stone too
    local stones = getSpecificPlayer(player):getInventory():getItemCount("Base.Stone", true);
    if stones < 6 then
        toolTip.description = toolTip.description .. " <RGB:1,0,0>" .. getItemNameFromFullType("Base.Stone") .. " " .. stones .. "/6 ";
        if not ISBuildMenu.cheat then
            stonePileOption.onSelect = nil;
            stonePileOption.notAvailable = true;
        end
    else
        toolTip.description = toolTip.description .. " <RGB:1,1,1>" .. getItemNameFromFullType("Base.Stone") .. " " .. stones .. "/6 ";
    end
    toolTip:setName(getText("ContextMenu_Stone_Pile"));
    toolTip:setTexture("location_community_cemetary_01_30");

    local woodenPicketOption = subMenu:addOption(getText("ContextMenu_Wooden_Picket"), worldobjects, ISBuildMenu.onWoodenPicket, square, player);
    local toolTip = ISBuildMenu.canBuild(1, 0, 0, 0, 0, 0, woodenPicketOption, player);
    toolTip.description = getText("Tooltip_craft_woodenPicketDesc") .. toolTip.description;
    local ropes = tonumber(getSpecificPlayer(player):getInventory():getItemCount("Base.SheetRope", true));
    -- we add that we need rope too
    if ropes == 0 then
        toolTip.description = toolTip.description .. " <RGB:1,0,0>" .. getItemNameFromFullType("Base.SheetRope") .. " " .. ropes .. "/1 ";
        if not ISBuildMenu.cheat then
            woodenPicketOption.onSelect = nil;
            woodenPicketOption.notAvailable = true;
        end
    else
        toolTip.description = toolTip.description .. " <RGB:1,1,1>" .. getItemNameFromFullType("Base.SheetRope") .. " " .. ropes .. "/1 ";
    end
    toolTip:setName(getText("ContextMenu_Wooden_Picket"));
    toolTip:setTexture("location_community_cemetary_01_31");

    if crossOption.notAvailable and stonePileOption.notAvailable and woodenPicketOption.notAvailable then
        option.notAvailable = true;
    end
end

ISBuildMenu.onWoodenCross = function(worldobjects, square, player)
    local cross = ISSimpleFurniture:new("Wooden Cross", "location_community_cemetary_01_22", "location_community_cemetary_01_23");
    cross.canPassThrough = true;
    cross.canBarricade = false;
    cross.ignoreNorth = true;
    cross.canBeAlwaysPlaced = false;
    cross.isThumpable = true;
    cross.modData["xp:Woodwork"] = 5;
    cross.modData["need:Base.Plank"] = "2";
    cross.modData["need:Base.Nails"] = "2";
    cross.player = player
    cross.maxTime = 80;
    cross.completionSound = "BuildWoodenStructureSmall";
    getCell():setDrag(cross, player);
end

ISBuildMenu.onStonePile = function(worldobjects, square, player)
    -- sprite, northSprite, corner
    local cross = ISSimpleFurniture:new("Stone Pile", "location_community_cemetary_01_30", "location_community_cemetary_01_30");
    cross.canPassThrough = true;
    cross.canBarricade = false;
    cross.ignoreNorth = true;
    cross.canBeAlwaysPlaced = false;
    cross.isThumpable = true;
    cross.modData["need:Base.Stone"] = "6";
    cross.player = player
    cross.maxTime = 50;
    cross.noNeedHammer = true;
    cross.completionSound = "BuildFenceCairn";
    getCell():setDrag(cross, player);
end

ISBuildMenu.onWoodenPicket = function(worldobjects, square, player)
    local cross = ISSimpleFurniture:new("Wooden Picket", "location_community_cemetary_01_31", "location_community_cemetary_01_31");
    cross.canPassThrough = true;
    cross.canBarricade = false;
    cross.ignoreNorth = true;
    cross.canBeAlwaysPlaced = false;
    cross.isThumpable = true;
    cross.modData["xp:Woodwork"] = 5;
    cross.modData["need:Base.Plank"] = "1";
    cross.modData["need:Base.SheetRope"] = "1";
    cross.player = player
    cross.maxTime = 50;
    cross.noNeedHammer = true;
    cross.completionSound = "BuildWoodenStructureSmall";
    getCell():setDrag(cross, player);
end

-- **********************************************
-- **                   *BAR*                  **
-- **********************************************

ISBuildMenu.buildBarMenu = function(subMenu, option, player)
    local barElemSprite = ISBuildMenu.getBarElementSprites(player);
    local barElemOption = subMenu:addOption(getText("ContextMenu_Bar_Element"), worldobjects, ISBuildMenu.onBarElement, barElemSprite, player);
    local tooltip = ISBuildMenu.canBuild(4, 4, 0, 0, 0, 7, barElemOption, player);
    tooltip:setName(getText("ContextMenu_Bar_Element"));
    tooltip.description = getText("Tooltip_craft_barElementDesc") .. tooltip.description;
    tooltip:setTexture(barElemSprite.sprite);
    ISBuildMenu.requireHammer(barElemOption)

    local barCornerSprite = ISBuildMenu.getBarCornerSprites(player);
    local barCornerOption = subMenu:addOption(getText("ContextMenu_Bar_Corner"), worldobjects, ISBuildMenu.onBarElement, barCornerSprite, player);
    local tooltip2 = ISBuildMenu.canBuild(4, 4, 0, 0, 0, 7, barCornerOption, player);
    tooltip2:setName(getText("ContextMenu_Bar_Corner"));
    tooltip2.description = getText("Tooltip_craft_barElementDesc") .. tooltip2.description;
    tooltip2:setTexture(barCornerSprite.sprite);
    ISBuildMenu.requireHammer(barCornerOption)

    if barElemOption.notAvailable and barCornerOption.notAvailable then
        option.notAvailable = true;
    end
end

ISBuildMenu.onBarElement = function(worldobjects, sprite, player)
    -- sprite, northSprite
    local bar = ISWoodenContainer:new(sprite.sprite, sprite.northSprite);
    bar.name = "Bar";
    bar:setEastSprite(sprite.eastSprite);
    bar:setSouthSprite(sprite.southSprite);
    bar.modData["xp:Woodwork"] = 5;
    bar.modData["need:Base.Plank"] = "4";
    bar.modData["need:Base.Nails"] = "4";
    bar.player = player
    bar.renderFloorHelper = true
    bar.completionSound = "BuildWoodenStructureMedium";
    getCell():setDrag(bar, player);
end

-- **********************************************
-- **                  *FENCE*                 **
-- **********************************************

ISBuildMenu.buildFenceMenu = function(subMenu, option, player)
    local playerObj = getSpecificPlayer(player)
    local playerInv = playerObj:getInventory()
    local stakeOption = subMenu:addOption(getText("ContextMenu_Wooden_Stake"), worldobjects, ISBuildMenu.onWoodenFenceStake, square, player);
    local toolTip = ISBuildMenu.canBuild(1, 2, 0, 0, 0, 5, stakeOption, player);
    toolTip:setName(getText("ContextMenu_Wooden_Stake"));
    toolTip.description = getText("Tooltip_craft_woodenStakeDesc") .. toolTip.description;
    toolTip:setTexture("fencing_01_19");
    ISBuildMenu.requireHammer(stakeOption)

    local barbedOption = subMenu:addOption(getText("ContextMenu_Barbed_Fence"), worldobjects, ISBuildMenu.onBarbedFence, square, player);
    local tooltip2 = ISBuildMenu.canBuild(0, 0, 0, 0, 1, 5, barbedOption, player);
    -- we add that we need a Barbed wire too
    local barbedWire = ISBuildMenu.countMaterial(player, "Base.BarbedWire");
    if not playerInv:containsTypeRecurse("BarbedWire") then
        tooltip2.description = tooltip2.description .. " <RGB:1,0,0>" .. getItemNameFromFullType("Base.BarbedWire") .. " " .. barbedWire .. "/1 ";
        if not ISBuildMenu.cheat then
            barbedOption.onSelect = nil;
            barbedOption.notAvailable = true;
        end
    else
        tooltip2.description = tooltip2.description .. " <RGB:1,1,1>" .. getItemNameFromFullType("Base.BarbedWire") .. " " .. barbedWire .. "/1 ";
    end
    tooltip2:setName(getText("ContextMenu_Barbed_Fence"));
    tooltip2.description = getText("Tooltip_craft_barbedFenceDesc") .. tooltip2.description;
    tooltip2:setTexture("fencing_01_20");
    ISBuildMenu.requireHammer(barbedOption)

    local woodenFenceSprite = ISBuildMenu.getWoodenFenceSprites(player);
    local fenceOption = subMenu:addOption(getText("ContextMenu_Wooden_Fence"), worldobjects, ISBuildMenu.onWoodenFence, square, woodenFenceSprite, player);
    local tooltip3 = ISBuildMenu.canBuild(2, 3, 0, 0, 0, 2, fenceOption, player);
    tooltip3:setName(getText("ContextMenu_Wooden_Fence"));
    tooltip3.description = getText("Tooltip_craft_woodenFenceDesc") .. tooltip3.description;
    tooltip3:setTexture(woodenFenceSprite.sprite);
    ISBuildMenu.requireHammer(fenceOption)

    local sandBagOption = subMenu:addOption(getText("ContextMenu_Sang_Bag_Wall"), worldobjects, ISBuildMenu.onSangBagWall, square, player);
    local tooltip4 = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, sandBagOption, player);
    -- we add that we need 3 sand bag too
    local sandbag = ISBuildMenu.countMaterial(player, "Base.Sandbag");
    if sandbag < 3 then
        tooltip4.description = tooltip4.description .. " <RGB:1,0,0>" .. getItemNameFromFullType("Base.Sandbag") .. " " .. sandbag .. "/3 ";
        if not ISBuildMenu.cheat then
            sandBagOption.onSelect = nil;
            sandBagOption.notAvailable = true;
        end
    else
        tooltip4.description = tooltip4.description .. " <RGB:1,1,1>" .. getItemNameFromFullType("Base.Sandbag") .. " " .. sandbag .. "/3 ";
    end
    tooltip4:setName(getText("ContextMenu_Sang_Bag_Wall"));
    tooltip4.description = getText("Tooltip_craft_sandBagDesc") .. tooltip4.description;
    tooltip4:setTexture("carpentry_02_12");

    local gravelBagOption = subMenu:addOption(getText("ContextMenu_Gravel_Bag_Wall"), worldobjects, ISBuildMenu.onGravelBagWall, square, player);
    local tooltip5 = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, gravelBagOption, player);
    -- we add that we need 3 gravel bag too
    local gravelbag = ISBuildMenu.countMaterial(player, "Base.Gravelbag");
    if gravelbag < 3 then
        tooltip5.description = tooltip5.description .. " <RGB:1,0,0>" .. getItemNameFromFullType("Base.Gravelbag") .. " " .. gravelbag .. "/3 ";
        if not ISBuildMenu.cheat then
            gravelBagOption.onSelect = nil;
            gravelBagOption.notAvailable = true;
        end
    else
        tooltip5.description = tooltip5.description .. " <RGB:1,1,1>" .. getItemNameFromFullType("Base.Gravelbag") .. " " .. gravelbag .. "/3 ";
    end
    tooltip5:setName(getText("ContextMenu_Gravel_Bag_Wall"));
    tooltip5.description = getText("Tooltip_craft_gravelBagDesc") .. tooltip5.description;
    tooltip5:setTexture("carpentry_02_12");

    if stakeOption.notAvailable and barbedOption.notAvailable and fenceOption.notAvailable and sandBagOption.notAvailable and gravelBagOption.notAvailable then
        option.notAvailable = true;
    end
end

ISBuildMenu.onBarbedFence = function(worldobjects, square, player)
    -- sprite, northSprite, corner
    local fence = ISBarbedWire:new("fencing_01_20", "fencing_01_21");
    -- we can place our fence every where
    --	fence.canBeAlwaysPlaced = true;
    fence.isThumpable = false;
    fence.hoppable = true;
    fence.canBarricade = false
    fence.modData["xp:Woodwork"] = 5;
    fence.modData["need:Base.BarbedWire"] = "1";
    fence.player = player
    fence.name = "Barbed Fence"
    fence.completionSound = "BuildMetalStructureSmallWiredFence";
    getCell():setDrag(fence, player);
end

ISBuildMenu.onWoodenFenceStake = function(worldobjects, square, player)
    -- sprite, northSprite, corner
    local fence = ISWoodenWall:new("fencing_01_19", "fencing_01_19", nil);
    fence.canPassThrough = true;
    fence.isThumpable = false;
    fence.canBarricade = false
    -- we can place our fence every where
    fence.canBeAlwaysPlaced = true;
    fence.modData["xp:Woodwork"] = 5;
    fence.modData["need:Base.Plank"] = "1";
    fence.modData["need:Base.Nails"] = "2";
    fence.player = player
    fence.name = "Wooden Stake"
    fence.completionSound = "BuildWoodenStructureSmall";
    getCell():setDrag(fence, player);
end

ISBuildMenu.onSangBagWall = function(worldobjects, square, player)
    -- sprite, northSprite, corner
    local fence = ISWoodenWall:new("carpentry_02_12", "carpentry_02_13", nil);
    fence:setEastSprite("carpentry_02_14");
    fence:setSouthSprite("carpentry_02_15");
    fence.hoppable = true;
    fence.canBarricade = false
    fence.isWallLike = false
    -- but it slow you
    --	fence.crossSpeed = 0.3;
    fence.modData["need:Base.Sandbag"] = "3";
    fence.modData["xp:Woodwork"] = 5;
    fence.player = player
    fence.renderFloorHelper = true
    fence.noNeedHammer = true
    fence.name = "Sand Bag Wall"
    fence.completionSound = "BuildFenceSandbag";
    getCell():setDrag(fence, player);
end

ISBuildMenu.onGravelBagWall = function(worldobjects, square, player)
    -- sprite, northSprite, corner
    local fence = ISWoodenWall:new("carpentry_02_12", "carpentry_02_13", nil);
    fence:setEastSprite("carpentry_02_14");
    fence:setSouthSprite("carpentry_02_15");
    fence.hoppable = true;
    fence.canBarricade = false
    fence.isWallLike = false
    -- but it slow you
    --    fence.crossSpeed = 0.3;
    fence.modData["need:Base.Gravelbag"] = "3";
    fence.modData["xp:Woodwork"] = 5;
    fence.player = player
    fence.renderFloorHelper = true
    fence.noNeedHammer = true
    fence.name = "Gravel Bag Wall"
    fence.completionSound = "BuildFenceGravelbag";
    getCell():setDrag(fence, player);
end

ISBuildMenu.onWoodenFence = function(worldobjects, square, sprite, player)
    -- sprite, northSprite, corner
    local fence = ISWoodenWall:new(sprite.sprite, sprite.northSprite, sprite.corner);
    -- you can hopp a fence
    fence.hoppable = true;
    fence.isThumpable = false;
    fence.canBarricade = false
    fence.modData["xp:Woodwork"] = 5;
    fence.modData["need:Base.Plank"] = "2";
    fence.modData["need:Base.Nails"] = "3";
    fence.player = player
    fence.name = "Wooden Fence"
    fence.completionSound = "BuildWoodenStructureSmall";
    getCell():setDrag(fence, player);
end

-- **********************************************
-- **          *LIGHT SOURCES*                 **
-- **********************************************
ISBuildMenu.buildLightMenu = function(subMenu, player)
    local playerObj = getSpecificPlayer(player)
    local playerInv = playerObj:getInventory()
    local sprite = ISBuildMenu.getPillarLampSprite(player);
    local lampOption = subMenu:addOption(getText("ContextMenu_Lamp_on_Pillar"), worldobjects, ISBuildMenu.onPillarLamp, square, sprite, player);
    local toolTip = ISBuildMenu.canBuild(2, 4, 0, 0, 0, 4, lampOption, player);
    local torch = getSpecificPlayer(player):getInventory():getItemCount("Base.Torch", true);
    if not playerInv:containsTypeRecurse("Torch") and not ISBuildMenu.materialOnGround["Torch"] then
        toolTip.description = toolTip.description .. " <RGB:1,0,0>" .. getItemNameFromFullType("Base.Torch") .. " " .. torch .. "/1 ";
        if not ISBuildMenu.cheat then
            lampOption.onSelect = nil;
            lampOption.notAvailable = true;
        end
    else
        toolTip.description = toolTip.description .. " <RGB:1,1,1>" .. getItemNameFromFullType("Base.Torch") .. " " .. torch .. "/1 ";
    end
    local rope = getSpecificPlayer(player):getInventory():getItemCount("Base.Rope", true);
    if not playerInv:containsTypeRecurse("Rope") and not ISBuildMenu.materialOnGround["Rope"] then
        toolTip.description = toolTip.description .. " <LINE> <RGB:1,0,0>" .. getItemNameFromFullType("Base.Rope") .. " " .. rope .. "/1 ";
        if not ISBuildMenu.cheat then
            lampOption.onSelect = nil;
            lampOption.notAvailable = true;
        end
    else
        toolTip.description = toolTip.description .. " <LINE> <RGB:1,1,1>" .. getItemNameFromFullType("Base.Rope") .. " " .. rope .. "/1 ";
    end
    toolTip:setName(getText("ContextMenu_Lamp_on_Pillar"));
    toolTip.description = getText("ContextMenu_Lamp_on_Pillar") .. " " .. toolTip.description;
    toolTip:setTexture("carpentry_02_59");
    ISBuildMenu.requireHammer(lampOption)

    --    if lampOption.notAvailable then
    --        option.notAvailable = true;
    --    end
end

ISBuildMenu.onPillarLamp = function(worldobjects, square, sprite, player)
    -- sprite, northSprite
    local lamp = ISLightSource:new(sprite.sprite, sprite.northSprite, getSpecificPlayer(player));
    lamp.offsetX = 5;
    lamp.offsetY = 5;
    lamp.modData["need:Base.Plank"] = "2";
    lamp.modData["need:Base.Rope"] = "1";
    lamp.modData["need:Base.Nails"] = "4";
    lamp.modData["xp:Woodwork"] = 5;
    --    lamp.modData["need:Base.Torch"] = "1";
    lamp:setEastSprite(sprite.eastSprite);
    lamp:setSouthSprite(sprite.southSprite);
    lamp.fuel = "Base.Battery";
    lamp.baseItem = "Base.Torch";
    lamp.radius = 10;
    lamp.player = player
    lamp.completionSound = "BuildWoodenStructureLarge"
    getCell():setDrag(lamp, player);
end

-- **********************************************
-- **                  *WALL*                  **
-- **********************************************

ISBuildMenu.buildWallMenu = function(subMenu, option, player)
    local sprite = ISBuildMenu.getWoodenWallFrameSprites(player);
    local wallOption = subMenu:addOption(getText("ContextMenu_Wooden_Wall_Frame"), worldobjects, ISBuildMenu.onWoodenWallFrame, sprite, player);
    local tooltip = ISBuildMenu.canBuild(2, 2, 0, 0, 0, 2, wallOption, player);
    tooltip:setName(getText("ContextMenu_Wooden_Wall_Frame"));
    tooltip.description = getText("Tooltip_craft_woodenWallFrameDesc") .. tooltip.description;
    tooltip:setTexture(sprite.sprite);
    ISBuildMenu.requireHammer(wallOption)

    --	local sprite = ISBuildMenu.getWoodenWallSprites(player);
    --	local wallOption = subMenu:addOption(getText("ContextMenu_Wooden_Wall"), worldobjects, ISBuildMenu.onWoodenWall, sprite, player);
    --	local tooltip = ISBuildMenu.canBuild(3, 3, 0, 0, 0, 2, wallOption, player);
    --	tooltip:setName(getText("ContextMenu_Wooden_Wall"));
    --	tooltip.description = getText("Tooltip_craft_woodenWallDesc") .. tooltip.description;
    --	tooltip:setTexture(sprite.sprite);
    --	ISBuildMenu.requireHammer(wallOption)

    local pillarOption = subMenu:addOption(getText("ContextMenu_Wooden_Pillar"), worldobjects, ISBuildMenu.onWoodenPillar, player);
    local tooltip = ISBuildMenu.canBuild(2, 3, 0, 0, 0, 2, pillarOption, player);
    tooltip:setName(getText("ContextMenu_Wooden_Pillar"));
    tooltip.description = getText("Tooltip_craft_woodenPillarDesc") .. tooltip.description;
    tooltip:setTexture("walls_exterior_wooden_01_27");
    ISBuildMenu.requireHammer(pillarOption)

    local logOption = subMenu:addOption(getText("ContextMenu_Log_Wall"), worldobjects, ISBuildMenu.onLogWall, player);
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, logOption, player);
    tooltip:setName(getText("ContextMenu_Log_Wall"));
    local numLog = ISBuildMenu.countMaterial(player, "Base.Log")
    if numLog < 4 then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemNameFromFullType("Base.Log") .. " " .. numLog .. "/4 <LINE> ";
        if not ISBuildMenu.cheat then
            logOption.onSelect = nil;
            logOption.notAvailable = true;
        end
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemNameFromFullType("Base.Log") .. " " .. numLog .. "/4 <LINE> ";
    end
    tooltip:setTexture("carpentry_02_80");

    -- log wall require either 4 ripped sheet, 4 twine or 2 ropes
    local numRippedSheets = ISBuildMenu.countMaterial(player, "Base.RippedSheets") + ISBuildMenu.countMaterial(player, "Base.RippedSheetsDirty")
    local numTwine = ISBuildMenu.countMaterial(player, "Base.Twine")
    local numRope = ISBuildMenu.countMaterial(player, "Base.Rope")
    if numRippedSheets >= 4 then
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemNameFromFullType("Base.RippedSheets") .. " " .. numRippedSheets .. "/4 ";
    elseif numTwine >= 4 then
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemNameFromFullType("Base.Twine") .. " " .. numTwine .. "/4 ";
    elseif numRope >= 2 then
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemNameFromFullType("Base.Rope") .. " " .. numRope .. "/2 ";
    else
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemNameFromFullType("Base.RippedSheets") .. " " .. numRippedSheets .. "/4 <LINE> " .. getText("ContextMenu_or") .. " " .. getItemNameFromFullType("Base.Twine") .. " " .. numTwine .. "/4 <LINE> " .. getText("ContextMenu_or") .. " " .. getItemNameFromFullType("Base.Rope") .. " " .. numRope .. "/2 ";
        if not ISBuildMenu.cheat then
            logOption.onSelect = nil;
            logOption.notAvailable = true;
        end
    end
    tooltip.description = getText("Tooltip_craft_wallLogDesc") .. tooltip.description;

    if wallOption.notAvailable and logOption.notAvailable and pillarOption.notAvailable then
        option.notAvailable = true;
    end
end

ISBuildMenu.onWoodenPillar = function(worldobjects, player)
    local wall = ISWoodenWall:new("walls_exterior_wooden_01_27", "walls_exterior_wooden_01_27", nil);
    wall.modData["need:Base.Plank"] = "2";
    wall.modData["need:Base.Nails"] = "3";
    wall.modData["xp:Woodwork"] = 3;
    wall.modData["wallType"] = "pillar";
    wall.canBePlastered = true;
    wall.canPassThrough = true;
    wall.canBarricade = false
    wall.player = player;
    wall.isCorner = true;
    wall.name = "Wooden Pillar"
    wall.completionSound = "BuildWoodenStructureMedium";
    getCell():setDrag(wall, player);
end

ISBuildMenu.canBuildLogWall = function(player)
    local logs = ISBuildMenu.countMaterial(player, "Base.Log")
    local sheets = ISBuildMenu.countMaterial(player, "Base.RippedSheets") + ISBuildMenu.countMaterial(player, "Base.RippedSheetsDirty")
    local twine = ISBuildMenu.countMaterial(player, "Base.Twine")
    local rope = ISBuildMenu.countMaterial(player, "Base.Rope")
    return logs >= 4 and (sheets >= 4 or twine >= 4 or rope >= 2)
end

ISBuildMenu.onLogWall = function(worldobjects, player)
    local wall = ISWoodenWall:new("carpentry_02_80", "carpentry_02_81", nil);
    wall.modData["need:Base.Log"] = "4";
    local sheets = ISBuildMenu.countMaterial(player, "Base.RippedSheets");
    local sheetsDirty = ISBuildMenu.countMaterial(player, "Base.RippedSheetsDirty");
    if sheets > 4 then
        sheets = 4;
        sheetsDirty = 0
    end
    if sheetsDirty > 4 then
        sheetsDirty = 4;
        sheets = 0
    end
    if sheets < 4 and sheetsDirty > 0 then
        sheetsDirty = 4 - sheets;
    end
    if sheets + sheetsDirty >= 4 then
        if sheets > 0 then
            wall.modData["need:Base.RippedSheets"] = tostring(sheets);
        end
        if sheetsDirty > 0 then
            wall.modData["need:Base.RippedSheetsDirty"] = tostring(sheetsDirty);
        end
    elseif ISBuildMenu.countMaterial(player, "Base.Twine") >= 4 then
        wall.modData["need:Base.Twine"] = "4";
    elseif ISBuildMenu.countMaterial(player, "Base.Rope") >= 2 then
        wall.modData["need:Base.Rope"] = "2";
    end
    wall.modData["xp:Woodwork"] = 5;
    wall.player = player;
    wall.noNeedHammer = true
    wall.canBarricade = false
    wall.name = "Log Wall"
    wall.completionSound = "BuildWoodenStructureLarge"
    getCell():setDrag(wall, player);
end

ISBuildMenu.onWoodenWall = function(worldobjects, sprite, player)
    -- sprite, northSprite, corner
    local wall = ISWoodenWall:new(sprite.sprite, sprite.northSprite, sprite.corner);
    if getSpecificPlayer(player):getPerkLevel(Perks.Woodwork) >= 8 then
        wall.canBePlastered = true;
    end
    wall.canBarricade = false
    -- set up the required material
    wall.modData["wallType"] = "wall";
    wall.modData["xp:Woodwork"] = 5;
    wall.modData["need:Base.Plank"] = "3";
    wall.modData["need:Base.Nails"] = "3";
    wall.player = player;
    getCell():setDrag(wall, player);
end

ISBuildMenu.onWoodenWallFrame = function(worldobjects, sprite, player)
    -- sprite, northSprite, corner
    local wall = ISWoodenWall:new(sprite.sprite, sprite.northSprite, sprite.corner);
    wall.canBarricade = false
    wall.name = "WoodenWallFrame";
    -- set up the required material
    wall.modData["xp:Woodwork"] = 5;
    wall.modData["need:Base.Plank"] = "2";
    wall.modData["need:Base.Nails"] = "2";
    wall.health = 50;
    wall.player = player;
    wall.completionSound = "BuildWoodenStructureLarge";
    getCell():setDrag(wall, player);
end

-- **********************************************
-- **              *WINDOWS FRAME*             **
-- **********************************************
ISBuildMenu.buildWindowsFrameMenu = function(subMenu, player)
    local sprite = ISBuildMenu.getWoodenWindowsFrameSprites(player);
    local wallOption = subMenu:addOption(getText("ContextMenu_Windows_Frame"), worldobjects, ISBuildMenu.onWoodenWindowsFrame, square, sprite, player);
    local tooltip = ISBuildMenu.canBuild(4, 4, 0, 0, 0, 2, wallOption, player);
    tooltip:setName(getText("ContextMenu_Windows_Frame"));
    tooltip.description = getText("Tooltip_craft_woodenFrameDesc") .. tooltip.description;
    tooltip:setTexture(sprite.sprite);
    ISBuildMenu.requireHammer(wallOption)
end

ISBuildMenu.onWoodenWindowsFrame = function(worldobjects, square, sprite, player)
    -- sprite, northSprite, corner
    local frame = ISWoodenWall:new(sprite.sprite, sprite.northSprite, sprite.corner);
    if getSpecificPlayer(player):getPerkLevel(Perks.Woodwork) >= 8 then
        frame.canBePlastered = true;
    end
    frame.hoppable = true;
    frame.isThumpable = false
    -- set up the required material
    frame.modData["xp:Woodwork"] = 5;
    frame.modData["wallType"] = "windowsframe";
    frame.modData["need:Base.Plank"] = "4";
    frame.modData["need:Base.Nails"] = "4";
    frame.player = player
    frame.name = "Window Frame"
    getCell():setDrag(frame, player);
end

-- **********************************************
-- **                  *FLOOR*                 **
-- **********************************************

ISBuildMenu.buildFloorMenu = function(subMenu, option, player)
	-- simple wooden floor
    local floorSprite = ISBuildMenu.getWoodenFloorSprites(player);
	local floorOption = subMenu:addOption(getText("ContextMenu_Wooden_Floor"), worldobjects, ISBuildMenu.onWoodenFloor, square, floorSprite, player);
	local tooltip = ISBuildMenu.canBuild(1,1,0,0,0,1,floorOption, player);
	tooltip:setName(getText("ContextMenu_Wooden_Floor"));
	tooltip.description = getText("Tooltip_craft_woodenFloorDesc") .. tooltip.description;
	tooltip:setTexture(floorSprite.sprite);
	ISBuildMenu.requireHammer(floorOption)

	local floor2Option = subMenu:addOption(getText("ContextMenu_Wooden_Floor"), worldobjects, ISBuildMenu.onWoodenCustomFloor, square, player);
	local tooltip = ISBuildMenu.canBuild(1,1,0,0,0,1,floor2Option, player);
	tooltip:setName(getText("ContextMenu_Wooden_Floor"));
	tooltip.description = getText("Tooltip_craft_woodenFloorDesc") .. tooltip.description;
	tooltip:setTexture("floors_interior_tilesandwood_01_7");
	ISBuildMenu.requireHammer(floor2Option)

	local floor3Option = subMenu:addOption(getText("ContextMenu_Wooden_Floor"), worldobjects, ISBuildMenu.onWoodenCustomFloor2, square, player);
	local tooltip = ISBuildMenu.canBuild(1,1,0,0,0,1,floor3Option, player);
	tooltip:setName(getText("ContextMenu_Wooden_Floor"));
	tooltip.description = getText("Tooltip_craft_woodenFloorDesc") .. tooltip.description;
	tooltip:setTexture("industry_railroad_05_47");
	ISBuildMenu.requireHammer(floor3Option)

	local floor4Option = subMenu:addOption(getText("ContextMenu_Wooden_Floor"), worldobjects, ISBuildMenu.onWoodenCustomFloor3, square, player);
	local tooltip = ISBuildMenu.canBuild(1,1,0,0,0,1,floor4Option, player);
	tooltip:setName(getText("ContextMenu_Wooden_Floor"));
	tooltip.description = getText("Tooltip_craft_woodenFloorDesc") .. tooltip.description;
	tooltip:setTexture("floors_interior_tilesandwood_01_42");
	ISBuildMenu.requireHammer(floor4Option)

	local floor5Option = subMenu:addOption(getText("ContextMenu_Wooden_Floor"), worldobjects, ISBuildMenu.onWoodenCustomFloor4, square, player);
	local tooltip = ISBuildMenu.canBuild(1,1,0,0,0,1,floor5Option, player);
	tooltip:setName(getText("ContextMenu_Wooden_Floor"));
	tooltip.description = getText("Tooltip_craft_woodenFloorDesc") .. tooltip.description;
	tooltip:setTexture("floors_interior_tilesandwood_01_43");
	ISBuildMenu.requireHammer(floor5Option)

	local floor6Option = subMenu:addOption(getText("ContextMenu_Wooden_Floor"), worldobjects, ISBuildMenu.onWoodenCustomFloor5, square, player);
	local tooltip = ISBuildMenu.canBuild(1,1,0,0,0,1,floor6Option, player);
	tooltip:setName(getText("ContextMenu_Wooden_Floor"));
	tooltip.description = getText("Tooltip_craft_woodenFloorDesc") .. tooltip.description;
	tooltip:setTexture("floors_interior_tilesandwood_01_46");
	ISBuildMenu.requireHammer(floor6Option)

--[[ 	local floor7Option = subMenu:addOption(getText("ContextMenu_Wooden_Floor"), worldobjects, ISBuildMenu.onWoodenCustomFloor6, square, player);
	local tooltip = ISBuildMenu.canBuild(1,1,0,0,0,1,floor7Option, player);
	tooltip:setName(getText("ContextMenu_Wooden_Floor"));
	tooltip.description = getText("Tooltip_craft_woodenFloorDesc") .. tooltip.description;
	tooltip:setTexture("industry_01_12");
	ISBuildMenu.requireHammer(floor7Option)

	local floor8Option = subMenu:addOption(getText("ContextMenu_Wooden_Floor"), worldobjects, ISBuildMenu.onWoodenCustomFloor7, square, player);
	local tooltip = ISBuildMenu.canBuild(1,1,0,0,0,1,floor8Option, player);
	tooltip:setName(getText("ContextMenu_Wooden_Floor"));
	tooltip.description = getText("Tooltip_craft_woodenFloorDesc") .. tooltip.description;
	tooltip:setTexture("industry_01_37");
	ISBuildMenu.requireHammer(floor8Option)

	local floor9Option = subMenu:addOption(getText("ContextMenu_Wooden_Floor"), worldobjects, ISBuildMenu.onWoodenCustomFloor8, square, player);
	local tooltip = ISBuildMenu.canBuild(1,1,0,0,0,1,floor9Option, player);
	tooltip:setName(getText("ContextMenu_Wooden_Floor"));
	tooltip.description = getText("Tooltip_craft_woodenFloorDesc") .. tooltip.description;
	tooltip:setTexture("industry_01_39");
	ISBuildMenu.requireHammer(floor9Option) ]]

	local floor10Option = subMenu:addOption(getText("ContextMenu_Wooden_Floor"), worldobjects, ISBuildMenu.onWoodenCustomFloor9, square, player);
	local tooltip = ISBuildMenu.canBuild(1,1,0,0,0,1,floor10Option, player);
	tooltip:setName(getText("ContextMenu_Wooden_Floor"));
	tooltip.description = getText("Tooltip_craft_woodenFloorDesc") .. tooltip.description;
	tooltip:setTexture("floors_interior_tilesandwood_01_28");
	ISBuildMenu.requireHammer(floor10Option)

	local floor11Option = subMenu:addOption(getText("ContextMenu_Wooden_Floor"), worldobjects, ISBuildMenu.onWoodenCustomFloor10, square, player);
	local tooltip = ISBuildMenu.canBuild(1,1,0,0,0,1,floor11Option, player);
	tooltip:setName(getText("ContextMenu_Wooden_Floor"));
	tooltip.description = getText("Tooltip_craft_woodenFloorDesc") .. tooltip.description;
	tooltip:setTexture("floors_exterior_tilesandstone_01_5");
	ISBuildMenu.requireHammer(floor11Option)
end

ISBuildMenu.onWoodenFloor = function(worldobjects, square, sprite, player)
    -- sprite, northSprite
    local foor = ISWoodenFloor:new(sprite.sprite, sprite.northSprite)
    foor.modData["need:Base.Plank"] = "1";
    foor.modData["xp:Woodwork"] = 3;
    foor.modData["need:Base.Nails"] = "1";
    foor.player = player
    foor.completionSound = "BuildWoodenStructureMedium";
    getCell():setDrag(foor, player);
end

ISBuildMenu.onWoodenCustomFloor = function(worldobjects, square, player)
	-- sprite, northSprite
	local foor = ISWoodenFloor:new("floors_interior_tilesandwood_01_7", "floors_interior_tilesandwood_01_7")
	foor.modData["need:Base.Plank"] = "1";
    foor.modData["xp:Woodwork"] = 3;
    foor.modData["need:Base.Nails"] = "1";
    foor.completionSound = "BuildWoodenStructureMedium";
    getCell():setDrag(foor, player);
end

ISBuildMenu.onWoodenCustomFloor2 = function(worldobjects, square, player)
	-- sprite, northSprite
	local foor = ISWoodenFloor:new("industry_railroad_05_47", "industry_railroad_05_47")
	foor.modData["need:Base.Plank"] = "1";
    foor.modData["xp:Woodwork"] = 3;
	foor.modData["need:Base.Nails"] = "1";
	foor.completionSound = "BuildWoodenStructureMedium";
	getCell():setDrag(foor, player);
end

ISBuildMenu.onWoodenCustomFloor3 = function(worldobjects, square, player)
	-- sprite, northSprite
	local foor = ISWoodenFloor:new("floors_interior_tilesandwood_01_42", "floors_interior_tilesandwood_01_42")
	foor.modData["need:Base.Plank"] = "1";
    foor.modData["xp:Woodwork"] = 3;
	foor.modData["need:Base.Nails"] = "1";
	foor.completionSound = "BuildWoodenStructureMedium";
	getCell():setDrag(foor, player);
end

ISBuildMenu.onWoodenCustomFloor4 = function(worldobjects, square, player)
	-- sprite, northSprite
	local foor = ISWoodenFloor:new("floors_interior_tilesandwood_01_43", "floors_interior_tilesandwood_01_43")
	foor.modData["need:Base.Plank"] = "1";
    foor.modData["xp:Woodwork"] = 3;
	foor.modData["need:Base.Nails"] = "1";
	foor.completionSound = "BuildWoodenStructureMedium";
	getCell():setDrag(foor, player);
end

ISBuildMenu.onWoodenCustomFloor5 = function(worldobjects, square, player)
	-- sprite, northSprite
	local foor = ISWoodenFloor:new("floors_interior_tilesandwood_01_46", "floors_interior_tilesandwood_01_46")
	foor.modData["need:Base.Plank"] = "1";
    foor.modData["xp:Woodwork"] = 3;
	foor.modData["need:Base.Nails"] = "1";
	foor.completionSound = "BuildWoodenStructureMedium";
	getCell():setDrag(foor, player);
end

--[[ ISBuildMenu.onWoodenCustomFloor6 = function(worldobjects, square, player)
	-- sprite, northSprite
	local foor = ISWoodenFloor:new("industry_01_12", "industry_01_12")
	foor.modData["need:Base.Plank"] = "1";
    foor.modData["xp:Woodwork"] = 3;
	foor.modData["need:Base.Nails"] = "1";
	foor.completionSound = "BuildWoodenStructureMedium";
	getCell():setDrag(foor, player);
end

ISBuildMenu.onWoodenCustomFloor7 = function(worldobjects, square, player)
	-- sprite, northSprite
	local foor = ISWoodenFloor:new("industry_01_37", "industry_01_38")
	foor.modData["need:Base.Plank"] = "1";
    foor.modData["xp:Woodwork"] = 3;
	foor.modData["need:Base.Nails"] = "1";
	foor.completionSound = "BuildWoodenStructureMedium";
	getCell():setDrag(foor, player);
end

ISBuildMenu.onWoodenCustomFloor8 = function(worldobjects, square, player)
	-- sprite, northSprite
	local foor = ISWoodenFloor:new("industry_01_39", "industry_01_39")
	foor.modData["need:Base.Plank"] = "1";
    foor.modData["xp:Woodwork"] = 3;
	foor.modData["need:Base.Nails"] = "1";
	foor.completionSound = "BuildWoodenStructureMedium";
	getCell():setDrag(foor, player);
end ]]

ISBuildMenu.onWoodenCustomFloor9 = function(worldobjects, square, player)
	-- sprite, northSprite
	local foor = ISWoodenFloor:new("floors_interior_tilesandwood_01_28", "floors_interior_tilesandwood_01_28")
	foor.modData["need:Base.Plank"] = "1";
    foor.modData["xp:Woodwork"] = 3;
	foor.modData["need:Base.Nails"] = "1";
	foor.completionSound = "BuildWoodenStructureMedium";
	getCell():setDrag(foor, player);
end

ISBuildMenu.onWoodenCustomFloor10 = function(worldobjects, square, player)
	-- sprite, northSprite
	local foor = ISWoodenFloor:new("floors_exterior_tilesandstone_01_5", "floors_exterior_tilesandstone_01_5")
	foor.modData["need:Base.Plank"] = "1";
    foor.modData["xp:Woodwork"] = 3;
	foor.modData["need:Base.Nails"] = "1";
	foor.completionSound = "BuildWoodenStructureMedium";
	getCell():setDrag(foor, player);
end



-- **********************************************
-- **               *CONTAINER*                **
-- **********************************************

ISBuildMenu.buildContainerMenu = function(subMenu, player)
    local crateSprite = ISBuildMenu.getWoodenCrateSprites(player);
    local crateOption = subMenu:addOption(getText("ContextMenu_Wooden_Crate"), worldobjects, ISBuildMenu.onWoodenCrate, square, crateSprite, player);
    local toolTip = ISBuildMenu.canBuild(3, 3, 0, 0, 0, 3, crateOption, player);
    toolTip:setName(getText("ContextMenu_Wooden_Crate"));
    toolTip.description = getText("Tooltip_craft_woodenCrateDesc") .. toolTip.description;
    toolTip:setTexture(crateSprite.sprite);
    ISBuildMenu.requireHammer(crateOption)
end

ISBuildMenu.onWoodenCrate = function(worldobjects, square, crateSprite, player)
    -- sprite, northSprite
    local crate = ISWoodenContainer:new(crateSprite.sprite, crateSprite.northSprite);
    crate.renderFloorHelper = true
    crate.canBeAlwaysPlaced = true;
    crate.modData["xp:Woodwork"] = 3;
    crate.modData["need:Base.Plank"] = "3";
    crate.modData["need:Base.Nails"] = "3";
    crate:setEastSprite(crateSprite.eastSprite);
    crate.player = player
    crate.completionSound = "BuildWoodenStructureMedium";
    getCell():setDrag(crate, player);
end

-- **********************************************
-- **              *FURNITURE*                 **
-- **********************************************

ISBuildMenu.buildFurnitureMenu = function(subMenu, context, option, player)
    local playerObj = getSpecificPlayer(player)
    local playerInv = playerObj:getInventory()
    -- add the table submenu
    local tableOption = subMenu:addOption(getText("ContextMenu_Table"), worldobjects, nil);
    local subMenuTable = subMenu:getNew(subMenu);
    context:addSubMenu(tableOption, subMenuTable);

    -- add all our table option
    local tableSprite = ISBuildMenu.getWoodenTableSprites(player);
    local smallTableOption = subMenuTable:addOption(getText("ContextMenu_Small_Table"), worldobjects, ISBuildMenu.onSmallWoodTable, square, tableSprite, player);
    local tooltip = ISBuildMenu.canBuild(5, 4, 0, 0, 0, 3, smallTableOption, player);
    tooltip:setName(getText("ContextMenu_Small_Table"));
    tooltip.description = getText("Tooltip_craft_smallTableDesc") .. tooltip.description;
    tooltip:setTexture(tableSprite.sprite);
    ISBuildMenu.requireHammer(smallTableOption)

    local largeTableSprite = ISBuildMenu.getLargeWoodTableSprites(player);
    local largeTableOption = subMenuTable:addOption(getText("ContextMenu_Large_Table"), worldobjects, ISBuildMenu.onLargeWoodTable, square, largeTableSprite, player);
    local tooltip2 = ISBuildMenu.canBuild(6, 4, 0, 0, 0, 4, largeTableOption, player);
    tooltip2:setName(getText("ContextMenu_Large_Table"));
    tooltip2.description = getText("Tooltip_craft_largeTableDesc") .. tooltip2.description;
    tooltip2:setTexture(largeTableSprite.sprite1);
    ISBuildMenu.requireHammer(largeTableOption)

    local drawerSprite = ISBuildMenu.getTableWithDrawerSprites(player);
    local drawerTableOption = subMenuTable:addOption(getText("ContextMenu_Table_with_Drawer"), worldobjects, ISBuildMenu.onSmallWoodTableWithDrawer, square, drawerSprite, player);
    local tooltip3 = ISBuildMenu.canBuild(5, 4, 0, 0, 0, 5, drawerTableOption, player);
    -- we add that we need a Drawer too
    local drawer = ISBuildMenu.countMaterial(player, "Base.Drawer");
    if not playerInv:containsTypeRecurse("Drawer") then
        tooltip3.description = tooltip3.description .. " <RGB:1,0,0>" .. getItemNameFromFullType("Base.Drawer") .. " " .. drawer .. "/1 <LINE>";
        if not ISBuildMenu.cheat then
            drawerTableOption.onSelect = nil;
            drawerTableOption.notAvailable = true;
        end
    else
        tooltip3.description = tooltip3.description .. " <RGB:1,1,1>" .. getItemNameFromFullType("Base.Drawer") .. " " .. drawer .. "/1 <LINE>";
    end
    tooltip3:setName(getText("ContextMenu_Table_with_Drawer"));
    tooltip3.description = getText("Tooltip_craft_tableDrawerDesc") .. tooltip3.description;
    tooltip3:setTexture(drawerSprite.sprite);
    ISBuildMenu.requireHammer(drawerTableOption)

    if smallTableOption.notAvailable and largeTableOption.notAvailable and drawerTableOption.notAvailable then
        tableOption.notAvailable = true;
    end

    -- now the chair
    local chairSprite = ISBuildMenu.getWoodenChairSprites(player);
    local chairOption = subMenu:addOption(getText("ContextMenu_Wooden_Chair"), worldobjects, ISBuildMenu.onWoodChair, square, chairSprite, player);
    local tooltip4 = ISBuildMenu.canBuild(5, 4, 0, 0, 0, 2, chairOption, player);
    tooltip4:setName(getText("ContextMenu_Wooden_Chair"));
    tooltip4.description = getText("Tooltip_craft_woodenChairDesc") .. tooltip4.description;
    tooltip4:setTexture(chairSprite.northSprite);
    ISBuildMenu.requireHammer(chairOption)

    -- rain collector barrel
    local barrelOption = subMenu:addOption(getText("ContextMenu_Rain_Collector_Barrel"), worldobjects, ISBuildMenu.onCreateBarrel, player, "carpentry_02_54", RainCollectorBarrel.smallWaterMax);
    local tooltip = ISBuildMenu.canBuild(4, 4, 0, 0, 0, 4, barrelOption, player);
    -- we add that we need 4 garbage bag too
    local garbagebag = ISBuildMenu.countMaterial(player, "Base.Garbagebag");
    if garbagebag < 4 then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemNameFromFullType("Base.Garbagebag") .. " " .. garbagebag .. "/4 ";
        if not ISBuildMenu.cheat then
            barrelOption.onSelect = nil;
            barrelOption.notAvailable = true;
        end
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemNameFromFullType("Base.Garbagebag") .. " " .. garbagebag .. "/4 ";
    end
    tooltip:setName(getText("ContextMenu_Rain_Collector_Barrel"));
    tooltip.description = getText("Tooltip_craft_rainBarrelDesc") .. tooltip.description;
    tooltip:setTexture("carpentry_02_54");
    ISBuildMenu.requireHammer(barrelOption)

    -- rain collector barrel
    local barrel2Option = subMenu:addOption(getText("ContextMenu_Rain_Collector_Barrel"), worldobjects, ISBuildMenu.onCreateBarrel, player, "carpentry_02_52", RainCollectorBarrel.largeWaterMax);
    local tooltip = ISBuildMenu.canBuild(4, 4, 0, 0, 0, 7, barrel2Option, player);
    -- we add that we need 4 garbage bag too
    if garbagebag < 4 then
        -- garbagebag declared further up, no need to redeclare it here
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemNameFromFullType("Base.Garbagebag") .. " " .. garbagebag .. "/4 ";
        if not ISBuildMenu.cheat then
            barrel2Option.onSelect = nil;
            barrel2Option.notAvailable = true;
        end
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemNameFromFullType("Base.Garbagebag") .. " " .. garbagebag .. "/4 ";
    end
    tooltip:setName(getText("ContextMenu_Rain_Collector_Barrel"));
    tooltip.description = getText("Tooltip_craft_rainBarrelDesc") .. tooltip.description;
    tooltip:setTexture("carpentry_02_52");
    ISBuildMenu.requireHammer(barrel2Option)

    -- compost
    local compostOption = subMenu:addOption(getText("ContextMenu_Compost"), worldobjects, ISBuildMenu.onCompost, player, "camping_01_19");
    local tooltip4 = ISBuildMenu.canBuild(5, 4, 0, 0, 0, 2, compostOption, player);
    tooltip4:setName(getText("ContextMenu_Compost"));
    tooltip4.description = getText("Tooltip_craft_compostDesc") .. tooltip4.description;
    tooltip4:setTexture("camping_01_19");
    ISBuildMenu.requireHammer(compostOption)

    local bookSprite = ISBuildMenu.getBookcaseSprite(player);
    local bookOption = subMenu:addOption(getText("ContextMenu_Bookcase"), worldobjects, ISBuildMenu.onBookcase, square, bookSprite, player);
    local tooltip5 = ISBuildMenu.canBuild(5, 4, 0, 0, 0, 5, bookOption, player);
    tooltip5:setName(getText("ContextMenu_Bookcase"));
    tooltip5.description = getText("Tooltip_craft_bookcaseDesc") .. tooltip5.description;
    tooltip5:setTexture(bookSprite.sprite);
    ISBuildMenu.requireHammer(bookOption)

    local book2Sprite = ISBuildMenu.getSmallBookcaseSprite(player);
    local book2Option = subMenu:addOption(getText("ContextMenu_SmallBookcase"), worldobjects, ISBuildMenu.onSmallBookcase, square, book2Sprite, player);
    local tooltip7 = ISBuildMenu.canBuild(3, 3, 0, 0, 0, 3, book2Option, player);
    tooltip7:setName(getText("ContextMenu_SmallBookcase"));
    tooltip7.description = getText("Tooltip_craft_smallBookcaseDesc") .. tooltip7.description;
    tooltip7:setTexture(book2Sprite.sprite);
    ISBuildMenu.requireHammer(book2Option)

    local shelveSprite = ISBuildMenu.getShelveSprite(player);
    local shelveOption = subMenu:addOption(getText("ContextMenu_Shelves"), worldobjects, ISBuildMenu.onShelve, square, shelveSprite, player);
    local tooltip6 = ISBuildMenu.canBuild(1, 2, 0, 0, 0, 2, shelveOption, player);
    tooltip6:setName(getText("ContextMenu_Shelves"));
    tooltip6.description = getText("Tooltip_craft_shelvesDesc") .. tooltip6.description;
    tooltip6:setTexture(shelveSprite.sprite);
    ISBuildMenu.requireHammer(shelveOption)

    local shelve2Sprite = ISBuildMenu.getDoubleShelveSprite(player);
    local shelve2Option = subMenu:addOption(getText("ContextMenu_DoubleShelves"), worldobjects, ISBuildMenu.onDoubleShelve, square, shelve2Sprite, player);
    local tooltip8 = ISBuildMenu.canBuild(2, 4, 0, 0, 0, 2, shelve2Option, player);
    tooltip8:setName(getText("ContextMenu_DoubleShelves"));
    tooltip8.description = getText("Tooltip_craft_doubleShelvesDesc") .. tooltip8.description;
    tooltip8:setTexture(shelve2Sprite.sprite);
    ISBuildMenu.requireHammer(shelve2Option)

    -- bed
    local bedSprite = ISBuildMenu.getBedSprite(player);
    local bedOption = subMenu:addOption(getText("ContextMenu_Bed"), worldobjects, ISBuildMenu.onBed, square, bedSprite, player);
    local tooltip9 = ISBuildMenu.canBuild(6, 4, 0, 0, 0, 4, bedOption, player);
    -- we add that we need a mattress too
    local mattress = ISBuildMenu.countMaterial(player, "Base.Mattress");
    if mattress < 1 then
        tooltip9.description = tooltip9.description .. " <RGB:1,0,0>" .. getItemNameFromFullType("Base.Mattress") .. " " .. mattress .. "/1 ";
        if not ISBuildMenu.cheat then
            bedOption.onSelect = nil;
            bedOption.notAvailable = true;
        end
    else
        tooltip9.description = tooltip9.description .. " <RGB:1,1,1>" .. getItemNameFromFullType("Base.Mattress") .. " " .. mattress .. "/1 ";
    end
    tooltip9:setName(getText("ContextMenu_Bed"));
    tooltip9.description = getText("Tooltip_craft_bedDesc") .. tooltip9.description;
    tooltip9:setTexture(bedSprite.northSprite1);
    ISBuildMenu.requireHammer(bedOption)

    local signSprite = ISBuildMenu.getSignSprite(player);
    local signOption = subMenu:addOption(getText("ContextMenu_Sign"), worldobjects, ISBuildMenu.onSign, square, signSprite, player);
    local tooltip10 = ISBuildMenu.canBuild(3, 3, 0, 0, 0, 1, signOption, player);
    tooltip10:setName(getText("ContextMenu_Sign"));
    tooltip10.description = getText("Tooltip_craft_signDesc") .. tooltip10.description;
    tooltip10:setTexture(signSprite.sprite);
    ISBuildMenu.requireHammer(signOption)

    if tableOption.notAvailable and signOption.notAvailable and bedOption.notAvailable
            and shelve2Option.notAvailable and shelveOption.notAvailable and book2Option.notAvailable
            and bookOption.notAvailable and barrel2Option.notAvailable and barrelOption.notAvailable
            and chairOption.notAvailable then
        option.notAvailable = true;
    end
end

-- create a new barrel to drag a ghost render of the barrel under the mouse
ISBuildMenu.onCreateBarrel = function(worldobjects, player, sprite, waterMax)
    local barrel = RainCollectorBarrel:new(player, sprite, waterMax);
    -- we now set his the mod data the needed material
    -- by doing this, all will be automatically consummed, drop on the ground if destoryed etc.
    barrel.modData["need:Base.Plank"] = "4";
    barrel.modData["need:Base.Nails"] = "4";
    barrel.modData["need:Base.Garbagebag"] = "4";
    barrel.modData["xp:Woodwork"] = 5;
    -- and now allow the item to be dragged by mouse
    barrel.player = player
    barrel.completionSound = "BuildWoodenStructureMedium";
    getCell():setDrag(barrel, player);
end

ISBuildMenu.onCompost = function(worldobjects, player, sprite)
    local compost = ISCompost:new(player, sprite);
    compost.modData["need:Base.Plank"] = "5";
    compost.modData["need:Base.Nails"] = "4";
    compost.modData["xp:Woodwork"] = 5;
    compost.player = player
    compost.notExterior = true;
    compost.completionSound = "BuildWoodenStructureMedium";
    getCell():setDrag(compost, player);
end

ISBuildMenu.onBed = function(worldobjects, square, sprite, player)
    local furniture = ISDoubleTileFurniture:new("Bed", sprite.sprite1, sprite.sprite2, sprite.northSprite1, sprite.northSprite2);
    furniture.modData["xp:Woodwork"] = 5;
    furniture.modData["need:Base.Plank"] = "6";
    furniture.modData["need:Base.Nails"] = "4";
    furniture.modData["need:Base.Mattress"] = "1";
    furniture.player = player
    furniture.completionSound = "BuildWoodenStructureLarge";
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onSmallWoodTable = function(worldobjects, square, sprite, player)
    -- name, sprite, northSprite
    local furniture = ISSimpleFurniture:new("Small Table", sprite.sprite, sprite.sprite);
    furniture.modData["xp:Woodwork"] = 3;
    furniture.modData["need:Base.Plank"] = "5";
    furniture.modData["need:Base.Nails"] = "4";
    furniture.player = player
    furniture.completionSound = "BuildWoodenStructureSmall";
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onSmallWoodTableWithDrawer = function(worldobjects, square, sprite, player)
    -- name, sprite, northSprite
    local furniture = ISSimpleFurniture:new("Small Table with Drawer", sprite.sprite, sprite.northSprite);
    furniture.modData["xp:Woodwork"] = 5;
    furniture.modData["need:Base.Plank"] = "5";
    furniture.modData["need:Base.Nails"] = "4";
    furniture.modData["need:Base.Drawer"] = "1";
    furniture:setEastSprite(sprite.eastSprite);
    furniture:setSouthSprite(sprite.southSprite);
    furniture.isContainer = true;
    furniture.player = player
    furniture.completionSound = "BuildWoodenStructureSmall";
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onLargeWoodTable = function(worldobjects, square, sprite, player)
    -- name, sprite, northSprite
    local furniture = ISDoubleTileFurniture:new("Large Table", sprite.sprite1, sprite.sprite2, sprite.northSprite1, sprite.northSprite2);
    furniture.modData["xp:Woodwork"] = 5;
    furniture.modData["need:Base.Plank"] = "6";
    furniture.modData["need:Base.Nails"] = "4";
    furniture.player = player
    furniture.completionSound = "BuildWoodenStructureLarge";
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onWoodChair = function(worldobjects, square, sprite, player)
    -- name, sprite, northSprite
    local furniture = ISSimpleFurniture:new("Wooden Chair", sprite.sprite, sprite.northSprite);
    furniture.modData["xp:Woodwork"] = 3;
    furniture.modData["need:Base.Plank"] = "5";
    furniture.modData["need:Base.Nails"] = "4";
    -- our chair have 4 tiles (north, east, south and west)
    -- then we define our east and south sprite
    furniture:setEastSprite(sprite.eastSprite);
    furniture:setSouthSprite(sprite.southSprite);
    furniture.canPassThrough = true;
    furniture.player = player
    furniture.completionSound = "BuildWoodenStructureMedium";
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onBookcase = function(worldobjects, square, sprite, player)
    -- name, sprite, northSprite
    local furniture = ISSimpleFurniture:new("Bookcase", sprite.sprite, sprite.northSprite);
    furniture.canBeAlwaysPlaced = true;
    furniture.isContainer = true;
    furniture.containerType = "shelves";
    furniture.modData["xp:Woodwork"] = 5;
    furniture.modData["need:Base.Plank"] = "5";
    furniture.modData["need:Base.Nails"] = "4";
    -- our chair have 4 tiles (north, east, south and west)
    -- then we define our east and south sprite
    furniture:setEastSprite(sprite.eastSprite);
    furniture:setSouthSprite(sprite.southSprite);
    furniture.player = player
    furniture.completionSound = "BuildWoodenStructureLarge";
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onSmallBookcase = function(worldobjects, square, sprite, player)
    -- name, sprite, northSprite
    local furniture = ISSimpleFurniture:new("Small Bookcase", sprite.sprite, sprite.northSprite);
    furniture.canBeAlwaysPlaced = true;
    furniture.isContainer = true;
    furniture.containerType = "shelves";
    furniture.modData["xp:Woodwork"] = 3;
    furniture.modData["need:Base.Plank"] = "3";
    furniture.modData["need:Base.Nails"] = "3";
    -- our chair have 4 tiles (north, east, south and west)
    -- then we define our east and south sprite
    furniture:setEastSprite(sprite.eastSprite);
    furniture:setSouthSprite(sprite.southSprite);
    furniture.player = player
    furniture.completionSound = "BuildWoodenStructureMedium";
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onShelve = function(worldobjects, square, sprite, player)
    -- name, sprite, northSprite
    local furniture = ISSimpleFurniture:new("Shelves", sprite.sprite, sprite.northSprite);
    furniture.isContainer = true;
    furniture.needToBeAgainstWall = true;
    furniture.buildLow = false;
    furniture.blockAllTheSquare = false;
    furniture.isWallLike = true
    furniture.containerType = "shelves";
    furniture.modData["xp:Woodwork"] = 3;
    furniture.modData["need:Base.Plank"] = "1";
    furniture.modData["need:Base.Nails"] = "2";
    furniture.player = player
    furniture.completionSound = "BuildWoodenStructureSmall";
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onSign = function(worldobjects, square, sprite, player)
    -- name, sprite, northSprite
    local furniture = ISSimpleFurniture:new("Wooden Sign", sprite.sprite, sprite.northSprite);
    furniture.blockAllTheSquare = false;
    furniture.isWallLike = true
    furniture.modData["xp:Woodwork"] = 3;
    furniture.modData["need:Base.Plank"] = "3";
    furniture.modData["need:Base.Nails"] = "3";
    furniture.player = player
    furniture.completionSound = "BuildWoodenStructureSmall";
    getCell():setDrag(furniture, player);
end

ISBuildMenu.onDoubleShelve = function(worldobjects, square, sprite, player)
    -- name, sprite, northSprite
    local furniture = ISSimpleFurniture:new("Double Shelves", sprite.sprite, sprite.northSprite);
    furniture.isContainer = true;
    furniture.needToBeAgainstWall = true;
    furniture.buildLow = false;
    furniture.blockAllTheSquare = false;
    furniture.isWallLike = true
    furniture.containerType = "shelves";
    furniture.modData["xp:Woodwork"] = 5;
    furniture.modData["need:Base.Plank"] = "2";
    furniture.modData["need:Base.Nails"] = "4";
    furniture.player = player
    furniture.completionSound = "BuildWoodenStructureSmall";
    getCell():setDrag(furniture, player);
end

-- **********************************************
-- **                 *STAIRS*                 **
-- **********************************************

ISBuildMenu.buildStairsMenu = function(subMenu, player)
    --	local darkStairsOption = subMenu:addOption(getText("ContextMenu_Dark_Wooden_Stairs"), worldobjects, ISBuildMenu.onDarkWoodenStairs, square, player);
    --	local tooltip = ISBuildMenu.canBuild(8,8,0,0,0,3,darkStairsOption, player);
    --	tooltip:setName(getText("ContextMenu_Dark_Wooden_Stairs"));
    --	tooltip.description = getText("Tooltip_craft_stairsDesc") .. tooltip.description;
    --	tooltip:setTexture("fixtures_stairs_01_16");

    local stairsOption = subMenu:addOption(getText("ContextMenu_Stairs"), worldobjects, ISBuildMenu.onBrownWoodenStairs, square, player);
    local tooltip2 = ISBuildMenu.canBuild(15, 50, 0, 0, 0, 6, stairsOption, player);
    tooltip2:setName(getText("ContextMenu_Stairs"));
    tooltip2.description = getText("Tooltip_craft_stairsDesc") .. tooltip2.description;
    tooltip2:setTexture("carpentry_02_88");
    ISBuildMenu.requireHammer(stairsOption)

    --	local lightStairsOption = subMenu:addOption(getText("ContextMenu_Light_Brown_Wooden_Stairs"), worldobjects, ISBuildMenu.onLightBrownWoodenStairs, square, player);
    --	local tooltip3 = ISBuildMenu.canBuild(8,8,0,0,0,3,lightStairsOption, player);
    --	tooltip3:setName(getText("ContextMenu_Light_Brown_Wooden_Stairs"));
    --	tooltip3.description = getText("Tooltip_craft_stairsDesc") .. tooltip3.description;
    --	tooltip3:setTexture("fixtures_stairs_01_32");

    --    if darkStairsOption.notAvailable and stairsOption.notAvailable and lightStairsOption.notAvailable then
    --        option.notAvailable = true;
    --    end
end

ISBuildMenu.onDarkWoodenStairs = function(worldobjects, square, player)
    local stairs = ISWoodenStairs:new("fixtures_stairs_01_16", "fixtures_stairs_01_17", "fixtures_stairs_01_18", "fixtures_stairs_01_24", "fixtures_stairs_01_25", "fixtures_stairs_01_26", "fixtures_stairs_01_22", "fixtures_stairs_01_23");
    stairs.modData["xp:Woodwork"] = 5;
    stairs.modData["need:Base.Plank"] = "15";
    stairs.modData["need:Base.Nails"] = "50";
    stairs.isThumpable = false;
    stairs.player = player
    stairs.completionSound = "BuildWoodenStructureLarge";
    getCell():setDrag(stairs, player);
end

ISBuildMenu.onBrownWoodenStairs = function(worldobjects, square, player)
    local stairs = ISWoodenStairs:new("carpentry_02_88", "carpentry_02_89", "carpentry_02_90", "carpentry_02_96", "carpentry_02_97", "carpentry_02_98", "carpentry_02_94", "carpentry_02_95");
    stairs.modData["xp:Woodwork"] = 5;
    stairs.modData["need:Base.Plank"] = "15";
    stairs.modData["need:Base.Nails"] = "50";
    stairs.player = player
    stairs.completionSound = "BuildWoodenStructureLarge";
    getCell():setDrag(stairs, player);
end

ISBuildMenu.onLightBrownWoodenStairs = function(worldobjects, square, player)
    local stairs = ISWoodenStairs:new("fixtures_stairs_01_32", "fixtures_stairs_01_33", "fixtures_stairs_01_34", "fixtures_stairs_01_40", "fixtures_stairs_01_41", "fixtures_stairs_01_42", "fixtures_stairs_01_38", "fixtures_stairs_01_39");
    stairs.modData["xp:Woodwork"] = 5;
    stairs.modData["need:Base.Plank"] = "15";
    stairs.modData["need:Base.Nails"] = "50";
    stairs.player = player
    stairs.completionSound = "BuildWoodenStructureLarge";
    getCell():setDrag(stairs, player);
end

-- **********************************************
-- **                 *DOOR*                   **
-- **********************************************

ISBuildMenu.buildDoorMenu = function(subMenu, option, player)
    local frameSprite = ISBuildMenu.getWoodenDoorFrameSprites(player);
    local doorFrameOption = subMenu:addOption(getText("ContextMenu_Door_Frame"), worldobjects, ISBuildMenu.onWoodenDoorFrame, square, frameSprite, player);
    local tooltip = ISBuildMenu.canBuild(4, 4, 0, 0, 0, 2, doorFrameOption, player);
    tooltip:setName(getText("ContextMenu_Door_Frame"));
    tooltip.description = getText("Tooltip_craft_doorFrameDesc") .. tooltip.description;
    tooltip:setTexture(frameSprite.sprite);
    ISBuildMenu.requireHammer(doorFrameOption)

    local doorFrame1Option = subMenu:addOption(getText("ContextMenu_Blue_Wooden_Door"), worldobjects, ISBuildMenu.doorFrame1, square, frameSprite, player);
    local tooltip = ISBuildMenu.canBuild(4, 4, 0, 0, 0, 2, doorFrame1Option, player);
    tooltip:setName(getText("ContextMenu_Door_Frame"));
    tooltip.description = getText("Tooltip_craft_doorFrameDesc") .. tooltip.description;
    tooltip:setTexture("location_barn_01_10");
    ISBuildMenu.requireHammer(doorFrame1Option)

    local doorFrame2Option = subMenu:addOption(getText("ContextMenu_Blue_Wooden_Door"), worldobjects, ISBuildMenu.doorFrame2, square, frameSprite, player);
    local tooltip = ISBuildMenu.canBuild(4, 4, 0, 0, 0, 2, doorFrame2Option, player);
    tooltip:setName(getText("ContextMenu_Door_Frame"));
    tooltip.description = getText("Tooltip_craft_doorFrameDesc") .. tooltip.description;
    tooltip:setTexture("location_community_church_small_01_10");
    ISBuildMenu.requireHammer(doorFrame2Option)

    local doorFrame3Option = subMenu:addOption(getText("ContextMenu_Blue_Wooden_Door"), worldobjects, ISBuildMenu.doorFrame3, square, frameSprite, player);
    local tooltip = ISBuildMenu.canBuild(4, 4, 0, 0, 0, 2, doorFrame3Option, player);
    tooltip:setName(getText("ContextMenu_Door_Frame"));
    tooltip.description = getText("Tooltip_craft_doorFrameDesc") .. tooltip.description;
    tooltip:setTexture("location_community_church_small_01_14");
    ISBuildMenu.requireHammer(doorFrame3Option)

    local doorFrame4Option = subMenu:addOption(getText("ContextMenu_Blue_Wooden_Door"), worldobjects, ISBuildMenu.doorFrame4, square, frameSprite, player);
    local tooltip = ISBuildMenu.canBuild(4, 4, 0, 0, 0, 2, doorFrame4Option, player);
    tooltip:setName(getText("ContextMenu_Door_Frame"));
    tooltip.description = getText("Tooltip_craft_doorFrameDesc") .. tooltip.description;
    tooltip:setTexture("location_restaurant_bar_01_54");
    ISBuildMenu.requireHammer(doorFrame4Option)

    local doorFrame5Option = subMenu:addOption(getText("ContextMenu_Blue_Wooden_Door"), worldobjects, ISBuildMenu.doorFrame5, square, frameSprite, player);
    local tooltip = ISBuildMenu.canBuild(4, 4, 0, 0, 0, 2, doorFrame5Option, player);
    tooltip:setName(getText("ContextMenu_Door_Frame"));
    tooltip.description = getText("Tooltip_craft_doorFrameDesc") .. tooltip.description;
    tooltip:setTexture("location_restaurant_pileocrepe_01_10");
    ISBuildMenu.requireHammer(doorFrame5Option)

    local doorFrame6Option = subMenu:addOption(getText("ContextMenu_Blue_Wooden_Door"), worldobjects, ISBuildMenu.doorFrame6, square, frameSprite, player);
    local tooltip = ISBuildMenu.canBuild(4, 4, 0, 0, 0, 2, doorFrame6Option, player);
    tooltip:setName(getText("ContextMenu_Door_Frame"));
    tooltip.description = getText("Tooltip_craft_doorFrameDesc") .. tooltip.description;
    tooltip:setTexture("location_shop_bargNclothes_01_34");
    ISBuildMenu.requireHammer(doorFrame6Option)

    local doorFrame7Option = subMenu:addOption(getText("ContextMenu_Blue_Wooden_Door"), worldobjects, ISBuildMenu.doorFrame7, square, frameSprite, player);
    local tooltip = ISBuildMenu.canBuild(4, 4, 0, 0, 0, 2, doorFrame7Option, player);
    tooltip:setName(getText("ContextMenu_Door_Frame"));
    tooltip.description = getText("Tooltip_craft_doorFrameDesc") .. tooltip.description;
    tooltip:setTexture("aza_morewalls01_10");
    ISBuildMenu.requireHammer(doorFrame7Option)

    local doorFrame8Option = subMenu:addOption(getText("ContextMenu_Blue_Wooden_Door"), worldobjects, ISBuildMenu.doorFrame8, square, frameSprite, player);
    local tooltip = ISBuildMenu.canBuild(4, 4, 0, 0, 0, 2, doorFrame8Option, player);
    tooltip:setName(getText("ContextMenu_Door_Frame"));
    tooltip.description = getText("Tooltip_craft_doorFrameDesc") .. tooltip.description;
    tooltip:setTexture("aza_morewalls01_30");
    ISBuildMenu.requireHammer(doorFrame8Option)

    local doorFrame9Option = subMenu:addOption(getText("ContextMenu_Blue_Wooden_Door"), worldobjects, ISBuildMenu.doorFrame9, square, frameSprite, player);
    local tooltip = ISBuildMenu.canBuild(4, 4, 0, 0, 0, 2, doorFrame9Option, player);
    tooltip:setName(getText("ContextMenu_Door_Frame"));
    tooltip.description = getText("Tooltip_craft_doorFrameDesc") .. tooltip.description;
    tooltip:setTexture("aza_morewalls01_26");
    ISBuildMenu.requireHammer(doorFrame9Option)


    local sprite = ISBuildMenu.getWoodenDoorSprites(player);
    local doorsOption = subMenu:addOption(getText("ContextMenu_Wooden_Door"), worldobjects, ISBuildMenu.onWoodenDoor, square, sprite, player);
    local tooltip = ISBuildMenu.canBuild(4, 4, 2, 1, 0, 3, doorsOption, player);
    tooltip:setName(getText("ContextMenu_Wooden_Door"));
    tooltip.description = getText("Tooltip_craft_woodenDoorDesc") .. tooltip.description;
    tooltip:setTexture(sprite.sprite);
    ISBuildMenu.requireHammer(doorsOption)

    local BlueWoodenDoorOption = subMenu:addOption(getText("ContextMenu_Blue_Wooden_Door"), worldobjects, ISBuildMenu.BlueWoodenDoor, square, player);
    local tooltip = ISBuildMenu.canBuild(4, 4, 2, 1, 0, 0, BlueWoodenDoorOption, player);
    tooltip:setName(getText("ContextMenu_Blue_Wooden_Door"));
    tooltip.description = getText("Tooltip_craft_woodenDoorDesc") .. tooltip.description;
    tooltip:setTexture("fixtures_doors_02_0");
    ISBuildMenu.requireHammer(BlueWoodenDoorOption)

    local BrownWoodenDoorOption = subMenu:addOption(getText("ContextMenu_Brown_Wooden_Door"), worldobjects, ISBuildMenu.BrownWoodenDoor, square, player);
    local tooltip = ISBuildMenu.canBuild(4, 4, 2, 1, 0, 0, BrownWoodenDoorOption, player);
    tooltip:setName(getText("ContextMenu_Brown_Wooden_Door"));
    tooltip.description = getText("Tooltip_craft_woodenDoorDesc") .. tooltip.description;
    tooltip:setTexture("fixtures_doors_01_4");
    ISBuildMenu.requireHammer(BrownWoodenDoorOption)

    local DarkBrownWoodenDoorOption = subMenu:addOption(getText("ContextMenu_Dark_Brown_Wooden_Door"), worldobjects, ISBuildMenu.DarkBrownWoodenDoor, square, player);
    local tooltip = ISBuildMenu.canBuild(4, 4, 2, 1, 0, 0, DarkBrownWoodenDoorOption, player);
    tooltip:setName(getText("ContextMenu_Dark_Brown_Wooden_Door"));
    tooltip.description = getText("Tooltip_craft_woodenDoorDesc") .. tooltip.description;
    tooltip:setTexture("fixtures_doors_01_12");
    ISBuildMenu.requireHammer(DarkBrownWoodenDoorOption)

    local WhiteWoodenDoorOption = subMenu:addOption(getText("ContextMenu_White_Wooden_Door"), worldobjects, ISBuildMenu.WhiteWoodenDoor, square, player);
    local tooltip = ISBuildMenu.canBuild(4, 4, 2, 1, 0, 0, WhiteWoodenDoorOption, player);
    tooltip:setName(getText("ContextMenu_White_Wooden_Door"));
    tooltip.description = getText("Tooltip_craft_woodenDoorDesc") .. tooltip.description;
    tooltip:setTexture("fixtures_doors_01_0");
    ISBuildMenu.requireHammer(WhiteWoodenDoorOption)

    local MetalBeigeDoorOption = subMenu:addOption(getText("ContextMenu_Metal_Beige_Door"), worldobjects, ISBuildMenu.MetalBeigeDoor, square, player);
    local tooltip = ISBuildMenu.canBuild(4, 4, 2, 1, 0, 0, MetalBeigeDoorOption, player);
    tooltip:setName(getText("ContextMenu_Metal_Beige_Door"));
    tooltip.description = getText("Tooltip_craft_woodenDoorDesc") .. tooltip.description;
    tooltip:setTexture("fixtures_doors_01_56");
    ISBuildMenu.requireHammer(MetalBeigeDoorOption)

    local MetalGreyDoorOption = subMenu:addOption(getText("ContextMenu_Metal_Grey_Door"), worldobjects, ISBuildMenu.MetalGreyDoor, square, player);
    local tooltip = ISBuildMenu.canBuild(4, 4, 2, 1, 0, 0, MetalGreyDoorOption, player);
    tooltip:setName(getText("ContextMenu_Metal_Grey_Door"));
    tooltip.description = getText("Tooltip_craft_woodenDoorDesc") .. tooltip.description;
    tooltip:setTexture("fixtures_doors_01_52");
    ISBuildMenu.requireHammer(MetalGreyDoorOption)

    local MetalOrangeDoorOption = subMenu:addOption(getText("ContextMenu_Metal_Orange_Door"), worldobjects, ISBuildMenu.MetalOrangeDoor, square, player);
    local tooltip = ISBuildMenu.canBuild(4, 4, 2, 1, 0, 0, MetalOrangeDoorOption, player);
    tooltip:setName(getText("ContextMenu_Metal_Orange_Door"));
    tooltip.description = getText("Tooltip_craft_woodenDoorDesc") .. tooltip.description;
    tooltip:setTexture("fixtures_doors_01_64");
    ISBuildMenu.requireHammer(MetalOrangeDoorOption)

    local BrownWindowWoodenDoorOption = subMenu:addOption(getText("ContextMenu_Brown_Window_Wooden_Door"), worldobjects, ISBuildMenu.BrownWindowWoodenDoor, square, player);
    local tooltip = ISBuildMenu.canBuild(4, 4, 2, 1, 0, 0, BrownWindowWoodenDoorOption, player);
    tooltip:setName(getText("ContextMenu_Brown_Window_Wooden_Door"));
    tooltip.description = getText("Tooltip_craft_woodenDoorDesc") .. tooltip.description;
    tooltip:setTexture("fixtures_doors_02_4");
    ISBuildMenu.requireHammer(BrownWindowWoodenDoorOption)

    local WhiteWindowWoodenDoorOption = subMenu:addOption(getText("ContextMenu_White_Window_Wooden_Door"), worldobjects, ISBuildMenu.WhiteWindowWoodenDoor, square, player);
    local tooltip = ISBuildMenu.canBuild(4, 4, 2, 1, 0, 0, WhiteWindowWoodenDoorOption, player);
    tooltip:setName(getText("ContextMenu_White_Window_Wooden_Door"));
    tooltip.description = getText("Tooltip_craft_woodenDoorDesc") .. tooltip.description;
    tooltip:setTexture("fixtures_doors_01_44");
    ISBuildMenu.requireHammer(WhiteWindowWoodenDoorOption)

    local StrongDoorOption = subMenu:addOption(getText("ContextMenu_Strong_Door"), worldobjects, ISBuildMenu.StrongDoor, square, player);
    local tooltip = ISBuildMenu.canBuild(4, 8, 2, 1, 0, 0, StrongDoorOption, player);
    tooltip:setName(getText("ContextMenu_Strong_Door"));
    tooltip.description = getText("Tooltip_craft_woodenDoorDesc") .. tooltip.description;
    tooltip:setTexture("fixtures_doors_01_32");
    ISBuildMenu.requireHammer(StrongDoorOption)

    local sprite = {};
    sprite.sprite = "fixtures_doors_fences_01_";

    local doorsOption2 = subMenu:addOption(getText("ContextMenu_Double_Wooden_Door"), worldobjects, ISBuildMenu.onDoubleWoodenDoor, square, sprite, 104, player);
    local tooltip = ISBuildMenu.canBuild(12, 12, 4, 2, 0, 6, doorsOption2, player);
    tooltip:setName(getText("ContextMenu_Double_Wooden_Door"));
    tooltip.description = getText("Tooltip_craft_doubleWoodenDoorDesc") .. tooltip.description;
    tooltip:setTexture(sprite.sprite .. "105");
    ISBuildMenu.requireHammer(doorsOption2)

    if doorFrameOption.notAvailable and doorsOption.notAvailable and doorsOption2.notAvailable then
        option.notAvailable = true;
    end
end

ISBuildMenu.onDoubleWoodenDoor = function(worldobjects, square, sprite, spriteIndex, player)
    local door = ISDoubleDoor:new(sprite.sprite, spriteIndex);
    door.modData["xp:Woodwork"] = 6;
    door.modData["need:Base.Plank"] = "12";
    door.modData["need:Base.Nails"] = "12";
    door.modData["need:Base.Hinge"] = "4";
    door.modData["need:Base.Doorknob"] = "2";
    door.player = player
    door.completionSound = "BuildWoodenStructureLarge";
    getCell():setDrag(door, player);
end

ISBuildMenu.onWoodenDoor = function(worldobjects, square, sprite, player)
    -- sprite, northsprite, openSprite, openNorthSprite
    local door = ISWoodenDoor:new(sprite.sprite, sprite.northSprite, sprite.openSprite, sprite.openNorthSprite);
    door.canBarricade = true;
    door.modData["xp:Woodwork"] = 3;
    door.modData["need:Base.Plank"] = "4";
    door.modData["need:Base.Nails"] = "4";
    door.modData["need:Base.Hinge"] = "2";
    door.modData["need:Base.Doorknob"] = "1";
    door.player = player
    door.completionSound = "BuildWoodenStructureLarge";
    getCell():setDrag(door, player);
end
--START КАСТОМНЫЕ ДВЕРИ
ISBuildMenu.BlueWoodenDoor = function(worldobjects, square, player)
    local door = ISWoodenDoor:new("fixtures_doors_02_0", "fixtures_doors_02_1", "fixtures_doors_02_2", "fixtures_doors_02_3");
    door.modData["xp:Woodwork"] = 3;
    door.modData["need:Base.Plank"] = "4";
    door.modData["need:Base.Nails"] = "4";
    door.modData["need:Base.Hinge"] = "2";
    door.modData["need:Base.Doorknob"] = "1";
    door.player = player
    -- check if the doorknob have a keyid
    local doorknob = getSpecificPlayer(player):getInventory():FindAndReturn("Base.Doorknob");
    if doorknob and doorknob:getKeyId() ~= -1 then
        door.keyId = doorknob:getKeyId();
    end
    getCell():setDrag(door, player);
end

ISBuildMenu.BrownWoodenDoor = function(worldobjects, square, player)
    local door = ISWoodenDoor:new("fixtures_doors_01_4", "fixtures_doors_01_5", "fixtures_doors_01_6", "fixtures_doors_01_7");
    door.modData["xp:Woodwork"] = 3;
    door.modData["need:Base.Plank"] = "4";
    door.modData["need:Base.Nails"] = "4";
    door.modData["need:Base.Hinge"] = "2";
    door.modData["need:Base.Doorknob"] = "1";
    door.player = player
    -- check if the doorknob have a keyid
    local doorknob = getSpecificPlayer(player):getInventory():FindAndReturn("Base.Doorknob");
    if doorknob and doorknob:getKeyId() ~= -1 then
        door.keyId = doorknob:getKeyId();
    end
    getCell():setDrag(door, player);
end

ISBuildMenu.DarkBrownWoodenDoor = function(worldobjects, square, player)
    local door = ISWoodenDoor:new("fixtures_doors_01_12", "fixtures_doors_01_13", "fixtures_doors_01_14", "fixtures_doors_01_15");
    door.modData["xp:Woodwork"] = 3;
    door.modData["need:Base.Plank"] = "4";
    door.modData["need:Base.Nails"] = "4";
    door.modData["need:Base.Hinge"] = "2";
    door.modData["need:Base.Doorknob"] = "1";
    door.player = player
    -- check if the doorknob have a keyid
    local doorknob = getSpecificPlayer(player):getInventory():FindAndReturn("Base.Doorknob");
    if doorknob and doorknob:getKeyId() ~= -1 then
        door.keyId = doorknob:getKeyId();
    end
    getCell():setDrag(door, player);
end

ISBuildMenu.WhiteWoodenDoor = function(worldobjects, square, player)
    local door = ISWoodenDoor:new("fixtures_doors_01_0", "fixtures_doors_01_1", "fixtures_doors_01_2", "fixtures_doors_01_3");
    door.modData["xp:Woodwork"] = 3;
    door.modData["need:Base.Plank"] = "4";
    door.modData["need:Base.Nails"] = "4";
    door.modData["need:Base.Hinge"] = "2";
    door.modData["need:Base.Doorknob"] = "1";
    door.player = player
    -- check if the doorknob have a keyid
    local doorknob = getSpecificPlayer(player):getInventory():FindAndReturn("Base.Doorknob");
    if doorknob and doorknob:getKeyId() ~= -1 then
        door.keyId = doorknob:getKeyId();
    end
    getCell():setDrag(door, player);
end

ISBuildMenu.MetalBeigeDoor = function(worldobjects, square, player)
    local door = ISWoodenDoor:new("fixtures_doors_01_56", "fixtures_doors_01_57", "fixtures_doors_01_58", "fixtures_doors_01_59");
    door.modData["xp:Woodwork"] = 3;
    door.modData["need:Base.Plank"] = "4";
    door.modData["need:Base.Nails"] = "4";
    door.modData["need:Base.Hinge"] = "2";
    door.modData["need:Base.Doorknob"] = "1";
    door.player = player
    -- check if the doorknob have a keyid
    local doorknob = getSpecificPlayer(player):getInventory():FindAndReturn("Base.Doorknob");
    if doorknob and doorknob:getKeyId() ~= -1 then
        door.keyId = doorknob:getKeyId();
    end
    getCell():setDrag(door, player);
end

ISBuildMenu.MetalGreyDoor = function(worldobjects, square, player)
    local door = ISWoodenDoor:new("fixtures_doors_01_52", "fixtures_doors_01_53", "fixtures_doors_01_54", "fixtures_doors_01_55");
    door.modData["xp:Woodwork"] = 3;
    door.modData["need:Base.Plank"] = "4";
    door.modData["need:Base.Nails"] = "4";
    door.modData["need:Base.Hinge"] = "2";
    door.modData["need:Base.Doorknob"] = "1";
    door.player = player
    -- check if the doorknob have a keyid
    local doorknob = getSpecificPlayer(player):getInventory():FindAndReturn("Base.Doorknob");
    if doorknob and doorknob:getKeyId() ~= -1 then
        door.keyId = doorknob:getKeyId();
    end
    getCell():setDrag(door, player);
end

ISBuildMenu.MetalOrangeDoor = function(worldobjects, square, player)
    local door = ISWoodenDoor:new("fixtures_doors_01_64", "fixtures_doors_01_65", "fixtures_doors_01_66", "fixtures_doors_01_67");
    door.modData["xp:Woodwork"] = 3;
    door.modData["need:Base.Plank"] = "4";
    door.modData["need:Base.Nails"] = "4";
    door.modData["need:Base.Hinge"] = "2";
    door.modData["need:Base.Doorknob"] = "1";
    door.player = player
    -- check if the doorknob have a keyid
    local doorknob = getSpecificPlayer(player):getInventory():FindAndReturn("Base.Doorknob");
    if doorknob and doorknob:getKeyId() ~= -1 then
        door.keyId = doorknob:getKeyId();
    end
    getCell():setDrag(door, player);
end

ISBuildMenu.BrownWindowWoodenDoor = function(worldobjects, square, player)
    local door = ISWoodenDoor:new("fixtures_doors_02_4", "fixtures_doors_02_5", "fixtures_doors_02_6", "fixtures_doors_02_7");
    door.modData["xp:Woodwork"] = 3;
    door.modData["need:Base.Plank"] = "4";
    door.modData["need:Base.Nails"] = "4";
    door.modData["need:Base.Hinge"] = "2";
    door.modData["need:Base.Doorknob"] = "1";
    door.player = player
    -- check if the doorknob have a keyid
    local doorknob = getSpecificPlayer(player):getInventory():FindAndReturn("Base.Doorknob");
    if doorknob and doorknob:getKeyId() ~= -1 then
        door.keyId = doorknob:getKeyId();
    end
    getCell():setDrag(door, player);
end

ISBuildMenu.WhiteWindowWoodenDoor = function(worldobjects, square, player)
    local door = ISWoodenDoor:new("fixtures_doors_01_44", "fixtures_doors_01_45", "fixtures_doors_01_46", "fixtures_doors_01_47");
    door.modData["xp:Woodwork"] = 3;
    door.modData["need:Base.Plank"] = "4";
    door.modData["need:Base.Nails"] = "4";
    door.modData["need:Base.Hinge"] = "2";
    door.modData["need:Base.Doorknob"] = "1";
    door.player = player
    -- check if the doorknob have a keyid
    local doorknob = getSpecificPlayer(player):getInventory():FindAndReturn("Base.Doorknob");
    if doorknob and doorknob:getKeyId() ~= -1 then
        door.keyId = doorknob:getKeyId();
    end
    getCell():setDrag(door, player);
end

ISBuildMenu.StrongDoor = function(worldobjects, square, player)
    local door = ISWoodenDoor:new("fixtures_doors_01_32", "fixtures_doors_01_33", "fixtures_doors_01_34", "fixtures_doors_01_35");
    door.modData["xp:Woodwork"] = 3;
    door.modData["need:Base.Plank"] = "4";
    door.modData["need:Base.Nails"] = "8";
    door.modData["need:Base.Hinge"] = "2";
    door.modData["need:Base.Doorknob"] = "1";
    door.player = player
    -- check if the doorknob have a keyid
    local doorknob = getSpecificPlayer(player):getInventory():FindAndReturn("Base.Doorknob");
    if doorknob and doorknob:getKeyId() ~= -1 then
        door.keyId = doorknob:getKeyId();
    end
    getCell():setDrag(door, player);
end
--END КАСТОМНЫЕ ДВЕРИ
ISBuildMenu.onFarmDoor = function(worldobjects, square, player)
    -- sprite, northsprite, openSprite, openNorthSprite
    getCell():setDrag(ISWoodenDoor:new("TileDoors_8", "TileDoors_9", "TileDoors_10", "TileDoors_11"), player);
end

-- **********************************************
-- **              *DOOR FRAME*                **
-- **********************************************

ISBuildMenu.buildDoorFrameMenu = function(subMenu, player)
    local frameSprite = ISBuildMenu.getWoodenDoorFrameSprites(player);
    local doorFrameOption = subMenu:addOption(getText("ContextMenu_Door_Frame"), worldobjects, ISBuildMenu.onWoodenDoorFrame, square, frameSprite, player);
    local tooltip = ISBuildMenu.canBuild(4, 4, 0, 0, 0, 2, doorFrameOption, player);
    tooltip:setName(getText("ContextMenu_Door_Frame"));
    tooltip.description = getText("Tooltip_craft_doorFrameDesc") .. tooltip.description;
    tooltip:setTexture(frameSprite.sprite);
    ISBuildMenu.requireHammer(doorFrameOption)
end

ISBuildMenu.onWoodenDoorFrame = function(worldobjects, square, sprite, player)
    -- sprite, northSprite, corner
    local doorFrame = ISWoodenDoorFrame:new(sprite.sprite, sprite.northSprite, sprite.corner)
    if getSpecificPlayer(player):getPerkLevel(Perks.Woodwork) >= 7 then
        doorFrame.canBePlastered = true;
    end
    doorFrame.modData["xp:Woodwork"] = 5;
    doorFrame.modData["wallType"] = "doorframe";
    doorFrame.modData["need:Base.Plank"] = "4";
    doorFrame.modData["need:Base.Nails"] = "4";
    doorFrame.player = player
    doorFrame.name = "WoodenDoorFrameLvl"
    doorFrame.completionSound = "BuildWoodenStructureLarge";
    getCell():setDrag(doorFrame, player);
end


ISBuildMenu.doorFrame1 = function(worldobjects, square, sprite, player)
    -- sprite, northSprite, corner
    local doorFrame = ISWoodenDoorFrame:new("location_barn_01_10", "location_barn_01_11", "walls_exterior_wooden_01_27")
    doorFrame.modData["xp:Woodwork"] = 5;
    doorFrame.modData["wallType"] = "doorframe";
    doorFrame.modData["need:Base.Plank"] = "4";
    doorFrame.modData["need:Base.Nails"] = "4";
    doorFrame.player = player
    doorFrame.completionSound = "BuildWoodenStructureLarge";
    doorFrame.name = "WoodenDoorFrameLvl"
    getCell():setDrag(doorFrame, player);
end

ISBuildMenu.doorFrame2 = function(worldobjects, square, sprite, player)
    -- sprite, northSprite, corner
    local doorFrame = ISWoodenDoorFrame:new("location_community_church_small_01_10", "location_community_church_small_01_11", "walls_exterior_wooden_01_27")
    doorFrame.modData["xp:Woodwork"] = 5;
    doorFrame.modData["wallType"] = "doorframe";
    doorFrame.modData["need:Base.Plank"] = "4";
    doorFrame.modData["need:Base.Nails"] = "4";
    doorFrame.player = player
    doorFrame.completionSound = "BuildWoodenStructureLarge";
    doorFrame.name = "WoodenDoorFrameLvl"
    getCell():setDrag(doorFrame, player);
end

ISBuildMenu.doorFrame3 = function(worldobjects, square, sprite, player)
    -- sprite, northSprite, corner
    local doorFrame = ISWoodenDoorFrame:new("location_community_church_small_01_14", "location_community_church_small_01_15", "walls_exterior_wooden_01_27")
    doorFrame.modData["xp:Woodwork"] = 5;
    doorFrame.modData["wallType"] = "doorframe";
    doorFrame.modData["need:Base.Plank"] = "4";
    doorFrame.modData["need:Base.Nails"] = "4";
    doorFrame.player = player
    doorFrame.completionSound = "BuildWoodenStructureLarge";
    doorFrame.name = "WoodenDoorFrameLvl" 
    getCell():setDrag(doorFrame, player);
end

ISBuildMenu.doorFrame4 = function(worldobjects, square, sprite, player)
    -- sprite, northSprite, corner
    local doorFrame = ISWoodenDoorFrame:new("location_restaurant_bar_01_54", "location_restaurant_bar_01_55", "walls_exterior_wooden_01_27")
    doorFrame.modData["xp:Woodwork"] = 5;
    doorFrame.modData["wallType"] = "doorframe";
    doorFrame.modData["need:Base.Plank"] = "4";
    doorFrame.modData["need:Base.Nails"] = "4";
    doorFrame.player = player
    doorFrame.completionSound = "BuildWoodenStructureLarge";
    getCell():setDrag(doorFrame, player);
end

ISBuildMenu.doorFrame5 = function(worldobjects, square, sprite, player)
    -- sprite, northSprite, corner
    local doorFrame = ISWoodenDoorFrame:new("location_restaurant_pileocrepe_01_10", "location_restaurant_pileocrepe_01_11", "walls_exterior_wooden_01_27")
    doorFrame.modData["xp:Woodwork"] = 5;
    doorFrame.modData["wallType"] = "doorframe";
    doorFrame.modData["need:Base.Plank"] = "4";
    doorFrame.modData["need:Base.Nails"] = "4";
    doorFrame.player = player
    doorFrame.completionSound = "BuildWoodenStructureLarge";
    getCell():setDrag(doorFrame, player);
end

ISBuildMenu.doorFrame6 = function(worldobjects, square, sprite, player)
    -- sprite, northSprite, corner
    local doorFrame = ISWoodenDoorFrame:new("location_shop_bargNclothes_01_34", "location_shop_bargNclothes_01_35", "walls_exterior_wooden_01_27")
    doorFrame.modData["xp:Woodwork"] = 5;
    doorFrame.modData["wallType"] = "doorframe";
    doorFrame.modData["need:Base.Plank"] = "4";
    doorFrame.modData["need:Base.Nails"] = "4";
    doorFrame.player = player
    doorFrame.completionSound = "BuildWoodenStructureLarge";
    getCell():setDrag(doorFrame, player);
end

ISBuildMenu.doorFrame7 = function(worldobjects, square, sprite, player)
    -- sprite, northSprite, corner
    local doorFrame = ISWoodenDoorFrame:new("aza_morewalls01_10", "aza_morewalls01_11", "walls_exterior_wooden_01_27")
    doorFrame.modData["xp:Woodwork"] = 5;
    doorFrame.modData["wallType"] = "doorframe";
    doorFrame.modData["need:Base.Plank"] = "4";
    doorFrame.modData["need:Base.Nails"] = "4";
    doorFrame.player = player
    doorFrame.completionSound = "BuildWoodenStructureLarge";
    getCell():setDrag(doorFrame, player);
end

ISBuildMenu.doorFrame8 = function(worldobjects, square, sprite, player)
    -- sprite, northSprite, corner
    local doorFrame = ISWoodenDoorFrame:new("aza_morewalls01_30", "aza_morewalls01_31", "walls_exterior_wooden_01_27")
    doorFrame.modData["xp:Woodwork"] = 5;
    doorFrame.modData["wallType"] = "doorframe";
    doorFrame.modData["need:Base.Plank"] = "4";
    doorFrame.modData["need:Base.Nails"] = "4";
    doorFrame.player = player
    doorFrame.completionSound = "BuildWoodenStructureLarge";
    getCell():setDrag(doorFrame, player);
end

ISBuildMenu.doorFrame9 = function(worldobjects, square, sprite, player)
    -- sprite, northSprite, corner
    local doorFrame = ISWoodenDoorFrame:new("aza_morewalls01_26", "aza_morewalls01_27", "walls_exterior_wooden_01_27")
    doorFrame.modData["xp:Woodwork"] = 5;
    doorFrame.modData["wallType"] = "doorframe";
    doorFrame.modData["need:Base.Plank"] = "4";
    doorFrame.modData["need:Base.Nails"] = "4";
    doorFrame.player = player
    doorFrame.completionSound = "BuildWoodenStructureLarge";
    getCell():setDrag(doorFrame, player);
end

-- **********************************************
-- **            SPRITE FUNCTIONS              **
-- **********************************************

ISBuildMenu.getBedSprite = function(player)
    local sprite = {};
    sprite.sprite1 = "carpentry_02_73";
    sprite.sprite2 = "carpentry_02_72";
    sprite.northSprite1 = "carpentry_02_74";
    sprite.northSprite2 = "carpentry_02_75";
    return sprite;
end

ISBuildMenu.getLargeWoodTableSprites = function(player)
    local spriteLvl = ISBuildMenu.getSpriteLvl(player);
    local sprite = {};
    if spriteLvl == 1 then
        sprite.sprite1 = "carpentry_01_25";
        sprite.sprite2 = "carpentry_01_24";
        sprite.northSprite1 = "carpentry_01_26";
        sprite.northSprite2 = "carpentry_01_27";
    elseif spriteLvl == 2 then
        sprite.sprite1 = "carpentry_01_29";
        sprite.sprite2 = "carpentry_01_28";
        sprite.northSprite1 = "carpentry_01_30";
        sprite.northSprite2 = "carpentry_01_31";
    else
        sprite.sprite1 = "carpentry_01_33";
        sprite.sprite2 = "carpentry_01_32";
        sprite.northSprite1 = "carpentry_01_34";
        sprite.northSprite2 = "carpentry_01_35";
    end
    return sprite;
end

ISBuildMenu.getTableWithDrawerSprites = function(player)
    local spriteLvl = ISBuildMenu.getSpriteLvl(player);
    local sprite = {};
    if spriteLvl == 1 then
        sprite.sprite = "carpentry_02_0";
        sprite.northSprite = "carpentry_02_2";
        sprite.southSprite = "carpentry_02_1";
        sprite.eastSprite = "carpentry_02_3";
    elseif spriteLvl == 2 then
        sprite.sprite = "carpentry_02_4";
        sprite.northSprite = "carpentry_02_6";
        sprite.southSprite = "carpentry_02_5";
        sprite.eastSprite = "carpentry_02_7";
    else
        sprite.sprite = "carpentry_02_8";
        sprite.northSprite = "carpentry_02_10";
        sprite.southSprite = "carpentry_02_9";
        sprite.eastSprite = "carpentry_02_11";
    end
    return sprite;
end

ISBuildMenu.getWoodenFenceSprites = function(player)
    local spriteLvl = ISBuildMenu.getSpriteLvl(player);
    local sprite = {};
    if spriteLvl == 1 then
        sprite.sprite = "carpentry_02_40";
        sprite.northSprite = "carpentry_02_41";
        sprite.corner = "carpentry_02_43";
    elseif spriteLvl == 2 then
        sprite.sprite = "carpentry_02_44";
        sprite.northSprite = "carpentry_02_45";
        sprite.corner = "carpentry_02_47";
    else
        sprite.sprite = "carpentry_02_48";
        sprite.northSprite = "carpentry_02_49";
        sprite.corner = "carpentry_02_51";
    end
    return sprite;
end

ISBuildMenu.getWoodenFloorSprites = function(player)
    local spriteLvl = ISBuildMenu.getSpriteLvl(player);
    local sprite = {};
    if spriteLvl == 1 then
        sprite.sprite = "carpentry_02_58";
        sprite.northSprite = "carpentry_02_58";
    elseif spriteLvl == 2 then
        sprite.sprite = "carpentry_02_57";
        sprite.northSprite = "carpentry_02_57";
    else
        sprite.sprite = "carpentry_02_56";
        sprite.northSprite = "carpentry_02_56";
    end
    if ISBuildMenu.cheat then
        sprite.sprite = "carpentry_02_56";
        sprite.northSprite = "carpentry_02_56";
    end
    return sprite;
end

ISBuildMenu.getWoodenCrateSprites = function(player)
    local spriteLvl = ISBuildMenu.getSpriteLvl(player);
    local sprite = {};
    if spriteLvl <= 2 then
        sprite.sprite = "carpentry_01_19";
        sprite.northSprite = "carpentry_01_19";
    else
        sprite.sprite = "carpentry_01_16";
        sprite.northSprite = "carpentry_01_16";
    end
    return sprite;
end

ISBuildMenu.getWoodenChairSprites = function(player)
    local spriteLvl = ISBuildMenu.getSpriteLvl(player);
    local sprite = {};
    if spriteLvl == 1 then
        sprite.sprite = "carpentry_01_36";
        sprite.northSprite = "carpentry_01_38";
        sprite.southSprite = "carpentry_01_39";
        sprite.eastSprite = "carpentry_01_37";
    elseif spriteLvl == 2 then
        sprite.sprite = "carpentry_01_40";
        sprite.northSprite = "carpentry_01_42";
        sprite.southSprite = "carpentry_01_41";
        sprite.eastSprite = "carpentry_01_43";
    else
        sprite.sprite = "carpentry_01_45";
        sprite.northSprite = "carpentry_01_44";
        sprite.southSprite = "carpentry_01_46";
        sprite.eastSprite = "carpentry_01_47";
    end
    return sprite;
end

ISBuildMenu.getWoodenDoorSprites = function(player)
    local spriteLvl = ISBuildMenu.getSpriteLvl(player);
    local sprite = {};
    if spriteLvl == 1 then
        sprite.sprite = "carpentry_01_48";
        sprite.northSprite = "carpentry_01_49";
        sprite.openSprite = "carpentry_01_50";
        sprite.openNorthSprite = "carpentry_01_51";
    elseif spriteLvl == 2 then
        sprite.sprite = "carpentry_01_52";
        sprite.northSprite = "carpentry_01_53";
        sprite.openSprite = "carpentry_01_54";
        sprite.openNorthSprite = "carpentry_01_55";
    else
        sprite.sprite = "carpentry_01_56";
        sprite.northSprite = "carpentry_01_57";
        sprite.openSprite = "carpentry_01_58";
        sprite.openNorthSprite = "carpentry_01_59";
    end
    return sprite;
end

ISBuildMenu.getWoodenTableSprites = function(player)
    local spriteLvl = ISBuildMenu.getSpriteLvl(player);
    local sprite = {};
    if spriteLvl == 1 then
        sprite.sprite = "carpentry_01_60";
    elseif spriteLvl == 2 then
        sprite.sprite = "carpentry_01_61";
    else
        sprite.sprite = "carpentry_01_62";
    end
    return sprite;
end

ISBuildMenu.getSmallBookcaseSprite = function(player)
    local sprite = {};
    sprite.sprite = "furniture_shelving_01_23";
    sprite.northSprite = "furniture_shelving_01_19";
    return sprite;
end

ISBuildMenu.getBookcaseSprite = function(player)
    local spriteLvl = ISBuildMenu.getSpriteLvl(player);
    local sprite = {};
    if spriteLvl <= 2 then
        sprite.northSprite = "carpentry_02_64";
        sprite.sprite = "carpentry_02_65";
        sprite.eastSprite = "carpentry_02_66";
        sprite.southSprite = "carpentry_02_67";
    else
        sprite.northSprite = "furniture_shelving_01_40";
        sprite.sprite = "furniture_shelving_01_41";
        sprite.eastSprite = "furniture_shelving_01_42";
        sprite.southSprite = "furniture_shelving_01_43";
    end
    return sprite;
end

ISBuildMenu.getSignSprite = function(player)
    local sprite = {};
    sprite.sprite = "constructedobjects_signs_01_27";
    sprite.northSprite = "constructedobjects_signs_01_11";
    return sprite;
end

ISBuildMenu.getDoubleShelveSprite = function(player)
    local sprite = {};
    sprite.sprite = "furniture_shelving_01_2";
    sprite.northSprite = "furniture_shelving_01_1";
    return sprite;
end

ISBuildMenu.getShelveSprite = function(player)
    local sprite = {};
    sprite.sprite = "carpentry_02_68";
    sprite.northSprite = "carpentry_02_69";
    return sprite;
end

ISBuildMenu.getPillarLampSprite = function(player)
    local sprite = {};
    sprite.sprite = "carpentry_02_61";
    sprite.northSprite = "carpentry_02_60";
    sprite.southSprite = "carpentry_02_59";
    sprite.eastSprite = "carpentry_02_62";
    return sprite;
end

ISBuildMenu.getWoodenWallFrameSprites = function(player)
    local sprite = {};
    sprite.sprite = "carpentry_02_100";
    sprite.northSprite = "carpentry_02_101";
    return sprite;
end

ISBuildMenu.getWoodenWallSprites = function(player)
    local spriteLvl = ISBuildMenu.getSpriteLvl(player);
    local sprite = {};
    if spriteLvl == 1 then
        sprite.sprite = "walls_exterior_wooden_01_44";
        sprite.northSprite = "walls_exterior_wooden_01_45";
    elseif spriteLvl == 2 then
        sprite.sprite = "walls_exterior_wooden_01_40";
        sprite.northSprite = "walls_exterior_wooden_01_41";
    else
        sprite.sprite = "walls_exterior_wooden_01_24";
        sprite.northSprite = "walls_exterior_wooden_01_25";
    end
    if ISBuildMenu.cheat then
        sprite.sprite = "walls_exterior_wooden_01_24";
        sprite.northSprite = "walls_exterior_wooden_01_25";
    end
    sprite.corner = "walls_exterior_wooden_01_27";
    return sprite;
end

ISBuildMenu.getWoodenWindowsFrameSprites = function(player)
    local spriteLvl = ISBuildMenu.getSpriteLvl(player);
    local sprite = {};
    if spriteLvl == 1 then
        sprite.sprite = "walls_exterior_wooden_01_52";
        sprite.northSprite = "walls_exterior_wooden_01_53";
    elseif spriteLvl == 2 then
        sprite.sprite = "walls_exterior_wooden_01_48";
        sprite.northSprite = "walls_exterior_wooden_01_49";
    else
        sprite.sprite = "walls_exterior_wooden_01_32";
        sprite.northSprite = "walls_exterior_wooden_01_33";
    end
    sprite.corner = "walls_exterior_wooden_01_27";
    return sprite;
end

ISBuildMenu.getWoodenDoorFrameSprites = function(player)
    local spriteLvl = ISBuildMenu.getSpriteLvl(player);
    local sprite = {};
    if spriteLvl == 1 then
        sprite.sprite = "walls_exterior_wooden_01_54";
        sprite.northSprite = "walls_exterior_wooden_01_55";
    elseif spriteLvl == 2 then
        sprite.sprite = "walls_exterior_wooden_01_50";
        sprite.northSprite = "walls_exterior_wooden_01_51";
    else
        sprite.sprite = "walls_exterior_wooden_01_34";
        sprite.northSprite = "walls_exterior_wooden_01_35";
    end
    sprite.corner = "walls_exterior_wooden_01_27";
    return sprite;
end

ISBuildMenu.getBarCornerSprites = function(player)
    local spriteLvl = ISBuildMenu.getSpriteLvl(player);
    local sprite = {};
    if spriteLvl == 1 then
        sprite.southSprite = "carpentry_02_32";
        sprite.sprite = "carpentry_02_34";
        sprite.northSprite = "carpentry_02_36";
        sprite.eastSprite = "carpentry_02_38";
    elseif spriteLvl == 2 then
        sprite.southSprite = "carpentry_02_24";
        sprite.sprite = "carpentry_02_26";
        sprite.northSprite = "carpentry_02_28";
        sprite.eastSprite = "carpentry_02_30";
    else
        sprite.southSprite = "carpentry_02_16";
        sprite.sprite = "carpentry_02_18";
        sprite.northSprite = "carpentry_02_20";
        sprite.eastSprite = "carpentry_02_22";
    end
    return sprite;
end

ISBuildMenu.getBarElementSprites = function(player)
    local spriteLvl = ISBuildMenu.getSpriteLvl(player);
    local sprite = {};
    if spriteLvl == 1 then
        sprite.southSprite = "carpentry_02_33";
        sprite.sprite = "carpentry_02_35";
        sprite.northSprite = "carpentry_02_37";
        sprite.eastSprite = "carpentry_02_39";
    elseif spriteLvl == 2 then
        sprite.southSprite = "carpentry_02_25";
        sprite.sprite = "carpentry_02_27";
        sprite.northSprite = "carpentry_02_29";
        sprite.eastSprite = "carpentry_02_31";
    else
        sprite.southSprite = "carpentry_02_17";
        sprite.sprite = "carpentry_02_19";
        sprite.northSprite = "carpentry_02_21";
        sprite.eastSprite = "carpentry_02_23";
    end
    return sprite;
end

ISBuildMenu.getSpriteLvl = function(player)
    -- 0 to 1 wood work xp mean lvl 1 sprite
    if getSpecificPlayer(player):getPerkLevel(Perks.Woodwork) <= 3 then
        return 1;
        -- 2 to 3 wood work xp mean lvl 2 sprite
    elseif getSpecificPlayer(player):getPerkLevel(Perks.Woodwork) <= 6 then
        return 2;
        -- 4 to 5 wood work xp mean lvl 3 sprite
    else
        return 3;
    end
end



-- **********************************************
-- **                DISMANTLE                 **
-- **********************************************

ISBuildMenu.onDismantle = function(worldobjects, player)
    local bo = ISDestroyCursor:new(player, true)
    getCell():setDrag(bo, bo.player)
end

-- **********************************************
-- **                  OTHER                   **
-- **********************************************

-- Create our toolTip, depending on the required material
ISBuildMenu.canBuild = function(plankNb, nailsNb, hingeNb, doorknobNb, baredWireNb, carpentrySkill, option, player)
    -- create a new tooltip
    local tooltip = ISBuildMenu.addToolTip();
    -- add it to our current option
    option.toolTip = tooltip;
    local result = true;
    tooltip.description = "<LINE> <LINE>" .. getText("Tooltip_craft_Needs") .. ": <LINE>";
    -- now we gonna test all the needed material, if we don't have it, they'll be in red into our toolip
    if ISBuildMenu.planks < plankNb then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemNameFromFullType("Base.Plank") .. " " .. ISBuildMenu.planks .. "/" .. plankNb .. " <LINE>";
        result = false;
    elseif plankNb > 0 then
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemNameFromFullType("Base.Plank") .. " " .. ISBuildMenu.planks .. "/" .. plankNb .. " <LINE>";
    end
    if ISBuildMenu.nails < nailsNb then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemNameFromFullType("Base.Nails") .. " " .. ISBuildMenu.nails .. "/" .. nailsNb .. " <LINE>";
        result = false;
    elseif nailsNb > 0 then
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemNameFromFullType("Base.Nails") .. " " .. ISBuildMenu.nails .. "/" .. nailsNb .. " <LINE>";
    end
    if ISBuildMenu.doorknob < doorknobNb then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemNameFromFullType("Base.Doorknob") .. " " .. ISBuildMenu.doorknob .. "/" .. doorknobNb .. " <LINE>";
        result = false;
    elseif doorknobNb > 0 then
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemNameFromFullType("Base.Doorknob") .. " " .. ISBuildMenu.doorknob .. "/" .. doorknobNb .. " <LINE>";
    end
    if ISBuildMenu.hinge < hingeNb then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemNameFromFullType("Base.Hinge") .. " " .. ISBuildMenu.hinge .. "/" .. hingeNb .. " <LINE>";
        result = false;
    elseif hingeNb > 0 then
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemNameFromFullType("Base.Hinge") .. " " .. ISBuildMenu.hinge .. "/" .. hingeNb .. " <LINE>";
    end
    if getSpecificPlayer(player):getPerkLevel(Perks.Woodwork) < carpentrySkill then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getText("IGUI_perks_Carpentry") .. " " .. getSpecificPlayer(player):getPerkLevel(Perks.Woodwork) .. "/" .. carpentrySkill .. " <LINE>";
        result = false;
    elseif carpentrySkill > 0 then
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getText("IGUI_perks_Carpentry") .. " " .. getSpecificPlayer(player):getPerkLevel(Perks.Woodwork) .. "/" .. carpentrySkill .. " <LINE>";
    end
    if ISBuildMenu.cheat then
        return tooltip;
    end
    if not result then
        option.onSelect = nil;
        option.notAvailable = true;
    end
    tooltip.description = " " .. tooltip.description .. " "
    return tooltip;
end

ISBuildMenu.addToolTip = function()
    local toolTip = ISWorldObjectContextMenu.addToolTip();
    toolTip.footNote = getText("Tooltip_craft_pressToRotate", Keyboard.getKeyName(getCore():getKey("Rotate building")))
    return toolTip;
end

ISBuildMenu.countMaterial = function(player, fullType)
    local inv = getSpecificPlayer(player):getInventory()
    local count = 0
    local items = inv:getItemsFromFullType(fullType, true)
    for i = 1, items:size() do
        local item = items:get(i - 1)
        if not instanceof(item, "InventoryContainer") or item:getInventory():getItems():isEmpty() then
            count = count + 1
        end
    end
    local type = string.split(fullType, "\\.")[2]
    for k, v in pairs(ISBuildMenu.materialOnGround) do
        if k == type then
            count = count + v
        end
    end
    return count
end

ISBuildMenu.requireHammer = function(option)
    if not ISBuildMenu.hasHammer and not ISBuildMenu.cheat then
        option.notAvailable = true
        option.onSelect = nil
    end
end

Events.OnFillWorldObjectContextMenu.Add(ISBuildMenu.doBuildMenu);
