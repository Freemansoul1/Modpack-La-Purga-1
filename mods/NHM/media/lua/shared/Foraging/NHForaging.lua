require 'Foraging/forageSystem'

Events.onAddForageDefs.Add(function()
    
--Следы
	local WolfFootprints = {
	type="NHM.WolfFootprints",
    perks={ "Trapping" },
	skill=5,
	xp=6,
    maxCount = 1,
	categories={ "Animals" },
	zones=	{		
        DeepForest      = 10,
            Forest          = 10,
            Vegitation      = 15,
            FarmLand        = 10,
            Farm            = 5,
            TrailerPark     = 5,
            },
	};

    local BearFootprints = {
        type="NHM.BearFootprints",
        perks={ "Trapping" },
        skill=10,
        xp=6,
        maxCount = 1,
        categories={ "Animals" },
        zones=	{		
            DeepForest      = 10,
                Forest          = 10,
                Vegitation      = 15,
                FarmLand        = 10,
                Farm            = 5,
                TrailerPark     = 5,
                },
        };

    local BoarFootprints = {
        type="NHM.BoarFootprints",
        perks={ "Trapping" },
        skill=7,
        xp=6,
        maxCount = 1,
        categories={ "Animals" },
        zones=	{		
            DeepForest      = 10,
                Forest          = 10,
                Vegitation      = 15,
                FarmLand        = 10,
                Farm            = 5,
                TrailerPark     = 5,
                },
        };

    local GoatFootprints = {
        type="NHM.GoatFootprints",
        perks={ "Trapping" },
        skill=6,
        xp=6,
        maxCount = 1,
        categories={ "Animals" },
        zones=	{		
            DeepForest      = 10,
                Forest          = 10,
                Vegitation      = 15,
                FarmLand        = 10,
                Farm            = 5,
                TrailerPark     = 5,
                },
        };

    local CowFootprints = {
        type="NHM.CowFootprints",
        perks={ "Trapping" },
        skill=6,
        xp=6,
        maxCount = 1,
        categories={ "Animals" },
        zones=	{		
            DeepForest      = 10,
                Forest          = 10,
                Vegitation      = 15,
                FarmLand        = 10,
                Farm            = 5,
                TrailerPark     = 5,
                },
        };


    local FoxFootprints = {
        type="NHM.FoxFootprints",
        perks={ "Trapping" },
        skill=3,
        xp=6,
        maxCount = 1,
        categories={ "Animals" },
        zones=	{		
            DeepForest      = 20,
                Forest          = 20,
                Vegitation      = 25,
                FarmLand        = 20,
                Farm            = 15,
                TrailerPark     = 15,
                },
        };

    local ODeerFootprints = {
        type="NHM.ODeerFootprints",
        perks={ "Trapping" },
        skill=8,
        xp=6,
        maxCount = 1,
        categories={ "Animals" },
        zones=	{		
            DeepForest      = 10,
                Forest          = 10,
                Vegitation      = 15,
                FarmLand        = 10,
                Farm            = 5,
                TrailerPark     = 5,
                },
        };

        local YDeerFootprints = {
            type="NHM.YDeerFootprints",
            perks={ "Trapping" },
            skill=9,
            xp=6,
            maxCount = 1,
            categories={ "Animals" },
            zones=	{		
                DeepForest      = 10,
                    Forest          = 10,
                    Vegitation      = 15,
                    FarmLand        = 10,
                    Farm            = 5,
                    TrailerPark     = 5,
                    },
            };

            local DogFootprints = {
                type="NHM.DogFootprints",
                perks={ "Trapping" },
                skill=4,
                xp=6,
                maxCount = 1,
                categories={ "Animals" },
                zones=	{		
                    DeepForest      = 20,
                        Forest          = 20,
                        Vegitation      = 25,
                        FarmLand        = 20,
                        Farm            = 15,
                        TrailerPark     = 15,
                        },
                };

    local MooseFootprints = {
        type="NHM.MooseFootprints",
        perks={ "Trapping" },
        skill=10,
        xp=6,
        maxCount = 1,
        categories={ "Animals" },
        zones=	{		
            DeepForest      = 10,
                Forest          = 10,
                Vegitation      = 15,
                FarmLand        = 10,
                Farm            = 5,
                TrailerPark     = 5,
                },
        };

        local CoyoteFootprints = {
            type="NHM.CoyoteFootprints",
            perks={ "Trapping" },
            skill=5,
            xp=6,
            maxCount = 1,
            categories={ "Animals" },
            zones=	{		
                DeepForest      = 20,
                    Forest          = 20,
                    Vegitation      = 25,
                    FarmLand        = 20,
                    Farm            = 15,
                    TrailerPark     = 15,
                    },
            };

            local HareFootprints = {
                type="NHM.HareFootprints",
                perks={ "Trapping" },
                skill=2,
                xp=6,
                maxCount = 1,
                categories={ "Animals" },
                zones=	{		
                    DeepForest      = 20,
                        Forest          = 20,
                        Vegitation      = 25,
                        FarmLand        = 20,
                        Farm            = 15,
                        TrailerPark     = 15,
                        },
                };

    local ChickenFootprints = {
        type="NHM.ChickenFootprints",
        perks={ "Trapping" },
        skill=1,
        xp=6,
        maxCount = 1,
        categories={ "Animals" },
        zones=	{		
            DeepForest      = 20,
                Forest          = 20,
                Vegitation      = 25,
                FarmLand        = 20,
                Farm            = 15,
                TrailerPark     = 15,
                },
        };

        local CrowFootprints = {
            type="NHM.CrowFootprints",
            perks={ "Trapping" },
            skill=2,
            xp=6,
            maxCount = 1,
            categories={ "Animals" },
            zones=	{		
                DeepForest      = 20,
                    Forest          = 20,
                    Vegitation      = 25,
                    FarmLand        = 20,
                    Farm            = 15,
                    TrailerPark     = 15,
                    },
            };

    local SulfurOre = {
        type="NHM.SulfurOre",
        skill=1,
        xp=0.5,
        maxCount = 3,
        categories={ "Stones" },
        zones = {
			Forest      = 5,
			DeepForest  = 5,
			Vegitation  = 5,
			FarmLand    = 5,
			Farm        = 5,
			TrailerPark = 5,
			TownZone    = 5,
			Nav         = 5,
		},
    };

        local Coal = {
            type="NHM.Coal",
            skill=1,
            xp=0.5,
            maxCount = 4,
            categories={ "Stones" },
            zones = {
                Forest      = 5,
                DeepForest  = 5,
                Vegitation  = 5,
                FarmLand    = 5,
                Farm        = 5,
                TrailerPark = 5,
                TownZone    = 5,
                Nav         = 5,
            },
    };


	
forageSystem.addItemDef(WolfFootprints);
forageSystem.addItemDef(BearFootprints);
forageSystem.addItemDef(BoarFootprints);
forageSystem.addItemDef(GoatFootprints);
forageSystem.addItemDef(CowFootprints);
forageSystem.addItemDef(FoxFootprints);
forageSystem.addItemDef(ODeerFootprints);
forageSystem.addItemDef(YDeerFootprints);
forageSystem.addItemDef(DogFootprints);
forageSystem.addItemDef(MooseFootprints);
forageSystem.addItemDef(CoyoteFootprints);
forageSystem.addItemDef(HareFootprints);
forageSystem.addItemDef(ChickenFootprints);
forageSystem.addItemDef(CrowFootprints);
forageSystem.addItemDef(SulfurOre);
forageSystem.addItemDef(Coal);
end)