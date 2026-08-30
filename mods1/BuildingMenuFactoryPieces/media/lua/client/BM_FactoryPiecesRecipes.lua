local BuildingMenu = require("BuildingMenu01_Main")

local function generateGroupAlternatives(groupAlternativesTable, baseCount, groupType)
    local newGroupAlternativesTable = {}

    for _, itemTable in pairs(groupAlternativesTable) do
        table.insert(newGroupAlternativesTable, {[groupType] = itemTable.Item, Amount = BuildingMenu.round(baseCount * itemTable.Multiplier)})
    end

    return unpack(newGroupAlternativesTable)
end

local function initFactoryPiecesBuildingMenuRecipes()
    local metalBarsCount = SandboxVars.BuildingMenuRecipes.metalBarsCount or 4
    local screwsCount = SandboxVars.BuildingMenuRecipes.screwsCount or 10
    local sheetMetalCountForContainers = SandboxVars.BuildingMenuRecipes.sheetMetalCountForDoors or 4
    local sheetMetalCountForFixturesAndAppliances = SandboxVars.BuildingMenuRecipes.sheetMetalCountForFixturesAndAppliances or 4
  	local metalweldingXpPerLevel = SandboxVars.BuildingMenuRecipes.metalweldingXpPerLevel or 3.5
    local electricalXpPerLevel = SandboxVars.BuildingMenuRecipes.electricalXpPerLevel or 5.0


	if getActivatedMods():contains("TheWorkshop(new version1)") then
		BuildingMenu.FactoryPiecesSiloGeneratorRecipe = {
        		neededTools = {
            			"BlowTorch",
            			"Screwdriver",
            			"Wrench",
            			"WeldingMask"
        		},
	        	neededMaterials = {
        	    		{
                			Material = "TW.Motor",
                			Amount = 1
	            		},
	            		{
        	        		Material = "Base.SheetMetal",
                			Amount = 6
            			},
	            		{
        	        		Material = "Base.SmallSheetMetal",
                			Amount = 2
            			},
	            		{
        	        		Material = "Base.ElectronicsScrap",
                			Amount = 10
            			},
	            		{
        	        		Material = "Radio.ElectricWire",
                			Amount = 2
            			},
	            		{
        	        		Material = "Base.MetalBar",
                			Amount = 6
            			},
            			{
                			Material = "Base.MetalPipe",
                			Amount = 2
            			},
	            		{
        	        		Material = "Base.Screws",
                			Amount = BuildingMenu.round(screwsCount*2)
            			}
	        	},
        		useConsumable = {
            			{
                			Consumable = "Base.BlowTorch",
                			Amount = 6
	            		},
        	    		{
                			Consumable = "Base.WeldingRods",
                			Amount = BuildingMenu.weldingRodUses(6)
            			}
        		},
	        	skills = {
	            		{
        	        		Skill = "MetalWelding",
                			Level = 6,
                			Xp = BuildingMenu.round(3*metalweldingXpPerLevel)
            			},
	            		{
        	        		Skill = "Electricity",
                			Level = 5,
                			Xp = BuildingMenu.round(4*electricalXpPerLevel)
            			}
        		}
	    	}
	else
		BuildingMenu.FactoryPiecesSiloGeneratorRecipe = {
        		neededTools = {
            			"BlowTorch",
            			"Screwdriver",
            			"Wrench",
            			"WeldingMask"
        		},
	        	neededMaterials = {
	            		{
        	        		Material = "Base.SheetMetal",
                			Amount = 8
            			},
	            		{
        	        		Material = "Base.SmallSheetMetal",
                			Amount = 2
            			},
	            		{
        	        		Material = "Base.ElectronicsScrap",
                			Amount = 20
            			},
	            		{
        	        		Material = "Radio.ElectricWire",
                			Amount = 4
            			},
	            		{
        	        		Material = "Base.MetalBar",
                			Amount = 8
            			},
            			{
                			Material = "Base.MetalPipe",
                			Amount = 4
            			},
	            		{
        	        		Material = "Base.Screws",
                			Amount = BuildingMenu.round(screwsCount*2)
            			}
	        	},
        		useConsumable = {
            			{
                			Consumable = "Base.BlowTorch",
                			Amount = 6
	            		},
        	    		{
                			Consumable = "Base.WeldingRods",
                			Amount = BuildingMenu.weldingRodUses(6)
            			}
        		},
	        	skills = {
	            		{
        	        		Skill = "MetalWelding",
                			Level = 7,
                			Xp = BuildingMenu.round(3*metalweldingXpPerLevel)
            			},
	            		{
        	        		Skill = "Electricity",
                			Level = 6,
                			Xp = BuildingMenu.round(4*electricalXpPerLevel)
            			}
        		}
	    	}
	end
end

Events.OnInitGlobalModData.Add(initFactoryPiecesBuildingMenuRecipes)