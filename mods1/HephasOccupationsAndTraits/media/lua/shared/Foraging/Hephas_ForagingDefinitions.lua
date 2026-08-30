require "Foraging/forageSystem"

forageSkills = {

	tracker = {
		name                    = "tracker",
		type                    = "occupation",
		visionBonus             = 1.75,
		weatherEffect           = 40,
		darknessEffect          = 30,
		specialisations         = {
			["Animals"]         = 45,
			["DeadAnimals"]		= 45,
			["Trash"]           = 25,
			["Junk"]            = 25,
			["WildHerbs"]		= 35,
			["Berries"]         = 25,
			["WildPlants"]		= 35,
			["Crops"]           = 35,
			["Vegetables"]      = 35,
			["Mushrooms"]       = 45,
			["Fishbait"]     	= 35,
			["Herbs"]     		= 35,
			["ForestRarities"]  = 35,
			["Firewood"]     	= 45,
			["Stones"]          = 45,
			["Insects"]      	= 35,
		},
	},
	MushroomGatherer = {
		name                    = "MushroomGatherer",
		type                    = "trait",
		visionBonus             = 0.25,
		weatherEffect           = 0,
		darknessEffect          = 0,
		specialisations         = {
			["Mushrooms"]      = 40,
		},
	},
	AllHailCaesar = {
		name                    = "AllHailCaesar",
		type                    = "trait",
		visionBonus             = 0.05,
		weatherEffect           = 0,
		darknessEffect          = 0,
		specialisations         = {
			["Firewood"]      = 50,
			["Stones"]        = 50,

		},
	},
	InsectHunter = {
		name                    = "InsectHunter",
		type                    = "trait",
		visionBonus             = 0.25,
		weatherEffect           = 0,
		darknessEffect          = 0,
		specialisations         = {
			["Insects"]      	= 40,
			["FishBait"]        = 40,
		},
	},

};