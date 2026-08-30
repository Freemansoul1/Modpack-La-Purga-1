require('NPCs/MainCreationMethods')

local TraitFactory = TraitFactory
local Perks = Perks

local getText = getText
local string = string

local TRAITS_LIST = {
	{
		IdentifierType = "ChemJunkie",
		Cost = -4,
		Profession = false,
		MutualExclusives = {},
	},
	{
		IdentifierType = "ChemExpert",
		Cost = 5,
		Profession = false,
		MutualExclusives = {},
		Callback = function(trait)
			trait:addXPBoost(Perks.Doctor, 1)
		end
	},
}

local function _initTraits()
	for i = 1, #TRAITS_LIST do
		local data = TRAITS_LIST[i]

		local name = getText(string.format("UI_ZL_Trait_%s", data.IdentifierType))
		local desc = getText(string.format("UI_ZL_Trait_%s_Description", data.IdentifierType))
		local newTrait = TraitFactory.addTrait(data.IdentifierType, name, data.Cost, desc, data.Profession)

		if data.Callback then
			data.Callback(newTrait)
		end

		for v = 1, #data.MutualExclusives do
			TraitFactory.setMutualExclusive(data.IdentifierType, data.MutualExclusives[v])
		end
	end
end

Events.OnGameBoot.Add(_initTraits)