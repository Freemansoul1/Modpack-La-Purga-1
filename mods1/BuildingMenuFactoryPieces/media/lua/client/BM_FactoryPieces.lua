local BuildingMenu = require("BuildingMenu01_Main")
require("BuildingMenu04_CategoriesDefinitions")


local function addSiloGeneratorPiecesToMenu()
    	local SiloGeneratorPieces = {
        	BuildingMenu.createObject(
            		"",
            		"Tooltip_FPSiloGenerator",
            		BuildingMenu.onBuildEigthTileFurniture,
            		BuildingMenu.FactoryPiecesSiloGeneratorRecipe,
            		true,
            		{
                		completionSound = "BuildMetalStructureMedium"
            		},
            		{sprite = "industry_02_71", sprite2 = "industry_02_67", sprite3 = "industry_02_66", sprite8 = "industry_02_70", 
			sprite7 = "industry_02_69", sprite4 = "industry_02_65", sprite5 = "industry_02_64", sprite6 = "industry_02_68"} -- Silo Generator
        	)
    	}
    
	BuildingMenu.addObjectsToCategories(
    		"Factory Pieces",
    		getText("IGUI_BuildingMenuCat_FactoryPieces_All"),
    		"security_01_1",
    		getText("IGUI_BuildingMenuSubCat_FactoryPieces_Generators"),
    		"industry_02_67",
    		SiloGeneratorPieces
	)
end

local function addFactoryPiecesCategoriesToBuildingMenu()
    addSiloGeneratorPiecesToMenu()
end

Events.OnGameStart.Add(addFactoryPiecesCategoriesToBuildingMenu)