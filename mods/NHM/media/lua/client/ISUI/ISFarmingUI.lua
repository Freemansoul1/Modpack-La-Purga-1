require "Farming/ISUI/ISFarmingMenu"

NewSeedsMenu = {};

--HERE WE ADD NEW PLANTS OPTIONS TO UI

NewSeedsMenu.haveSeed = function(player)
	local listOfNewSeeds = {};
	listOfNewSeeds.TobaccoSeeds = {};
	listOfNewSeeds.CornSeeds = {};
	listOfNewSeeds.CannabisSeeds = {};
	listOfNewSeeds.RiceSeeds = {};
	
	for i = 0, player:getInventory():getItems():size() - 1 do
		local item = player:getInventory():getItems():get(i);
		if item:getType() == "TobaccoSeeds" or item:getType() == "TobaccoSeeds50" then
			table.insert(listOfNewSeeds.TobaccoSeeds, item);
		end
		if item:getType() == "CornSeeds" or item:getType() == "CornSeeds50" then
			table.insert(listOfNewSeeds.CornSeeds, item);
		end
		if item:getType() == "CannabisSeeds" or item:getType() == "CannabisSeeds50" then
			table.insert(listOfNewSeeds.CannabisSeeds, item);
		end
		if item:getType() == "RiceSeeds" or item:getType() == "RiceSeeds50" then
			table.insert(listOfNewSeeds.RiceSeeds, item);
		end
	end

		return listOfNewSeeds;
end

NewSeedsMenu.doNewSeedsMenu = function(player, context, worldobjects, test)

    	local sq = nil;

    	local player = getSpecificPlayer(player);
	local currentPlant = nil;
	for i,v in ipairs(worldobjects) do
		local plant = CFarmingSystem.instance:getLuaObjectOnSquare(v:getSquare())
		if plant then
			currentPlant = plant
			sq = v:getSquare();
			break
		end
	end

	if test and ISWorldObjectContextMenu.Test then return true end

	local subMenu = nil;
	local farmOption = nil;
	for i,v in ipairs(context.options) do
		if v.name == getText("ContextMenu_Sow_Seed") then
			farmOption = v;
			subMenu = context:getSubMenu(farmOption.subOption);
		end
	end


	if subMenu then
    		local listOfNewSeeds = NewSeedsMenu.haveSeed(player);

		context:addSubMenu(farmOption, subMenu);
		local tobaccoOption = subMenu:addOption(getText("Farming_Tobacco"), worldobjects, ISFarmingMenu.onSeed, listOfNewSeeds.TobaccoSeeds, farming_vegetableconf.props["Tobacco"].seedsRequired, "Tobacco", currentPlant, sq, player);
		local cornOption = subMenu:addOption(getText("Farming_Corn"), worldobjects, ISFarmingMenu.onSeed, listOfNewSeeds.CornSeeds, farming_vegetableconf.props["Corn"].seedsRequired, "Corn", currentPlant, sq, player);
		local cannabisOption = subMenu:addOption(getText("Farming_Cannabis"), worldobjects, ISFarmingMenu.onSeed, listOfNewSeeds.CannabisSeeds, farming_vegetableconf.props["Cannabis"].seedsRequired, "Cannabis", currentPlant, sq, player);
		local riceOption = subMenu:addOption(getText("Farming_Rice"), worldobjects, ISFarmingMenu.onSeed, listOfNewSeeds.RiceSeeds, farming_vegetableconf.props["Rice"].seedsRequired, "Rice", currentPlant, sq, player);
		ISFarmingMenu.canPlow(#listOfNewSeeds.TobaccoSeeds, "Tobacco", tobaccoOption);
		ISFarmingMenu.canPlow(#listOfNewSeeds.CornSeeds, "Corn", cornOption);
		ISFarmingMenu.canPlow(#listOfNewSeeds.CannabisSeeds, "Cannabis", cannabisOption);
		ISFarmingMenu.canPlow(#listOfNewSeeds.RiceSeeds, "Rice", riceOption);
	end
end
