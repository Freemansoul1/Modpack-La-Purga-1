---
--- BioFuelXPFunctions.lua
--- 25/11/2022
---

function Recipe.OnGiveXP.Doctor3(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Doctor, 3);
end

function Recipe.OnGiveXP.Doctor1(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Doctor, 1);
end

-- These functions are defined to avoid breaking mods.
Give3DoctorXP = Recipe.OnGiveXP.Doctor3
Give1DoctorXP = Recipe.OnGiveXP.Doctor1


function Recipe.OnGiveXP.MetalWelding5(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.MetalWelding, 5);
end

Give5MetalWeldingXP = Recipe.OnGiveXP.MetalWelding5
