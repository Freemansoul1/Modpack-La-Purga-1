RU_Recipe = {}
RU_Recipe.OnGiveXp = {}

function RU_Recipe.OnGiveXp.AssembleAdvancedScrap(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Electricity, 10)
end

function RU_Recipe.OnGiveXp.Tier1Fuse(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Electricity, 5)
end

function RU_Recipe.OnGiveXp.Tier2Fuse(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Electricity, 15)
end