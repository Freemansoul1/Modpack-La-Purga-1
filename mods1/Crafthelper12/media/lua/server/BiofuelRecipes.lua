---
--- BiofuelRecipes.lua
--- 24/11/2022
---
---@param items Food (Mostly)
---@param result DrainableComboItem
function Recipe.OnCreate.CreateBiofuelGasoline(items, result, player)
	local fuelMade = 0.0

	for i=0,items:size() - 1 do
		local item = items:get(i)
		if(item:getType() == "PetrolCan") then
			fuelMade = item:getUsedDelta()
		end
	end

	for i=0,items:size() - 1 do
		local item = items:get(i)
		if(item:getType() == "Z2Bacteria") then
			local playerObj = getSpecificPlayer(playerIndex)
			local Perk = playerObj:getPerkLevel(Perks.Chemistry)
			if playerObj:getProfession("electrician") then
				fuelMade = fuelMade + (0.030 * Perk)
			else
			    fuelMade = fuelMade + (0.020 * Perk)
			end
			playerObj:getInventory():AddItem("warpbiofuel.DirtyPetridish");
		end
	end

	if player:getInventory():containsTypeRecurse("warpbiofuel.ResearchNotes") then
		fuelMade = fuelMade * 1.5
	end

	if(result) then
		if(fuelMade > 1.0) then
			fuelMade = 1.0
		end
		result:setUsedDelta(fuelMade)
	end
end


function Recipe.OnCreate.CreateBiofuelPropane(items, result, player)
	local fuelMade = 0.0
	for i=0,items:size() - 1 do
		local item = items:get(i)
		if(item:getType() == "PropaneTank") then
			fuelMade = item:getUsedDelta()
		end
	end

	for i=0,items:size() - 1 do
		local item = items:get(i)
		if(item:getType() == "Z5Bacteria") then
			local playerObj = getSpecificPlayer(playerIndex)
			local Perk = playerObj:getPerkLevel(Perks.Chemistry)
			if playerObj:getProfession("electrician") then
				fuelMade = fuelMade + (0.030 * Perk)
			else
			    fuelMade = fuelMade + (0.020 * Perk)
			end
			playerObj:getInventory():AddItem("warpbiofuel.DirtyPetridish");
		end
	end

	if player:getInventory():containsTypeRecurse("warpbiofuel.ResearchNotes") then
		fuelMade = fuelMade * 1.5
	end

	if(result) then
		if(fuelMade > 1.0) then
			fuelMade = 1.0
		end
		result:setUsedDelta(fuelMade)
	end
end

function Recipe.OnCreate.CultivateBacteria(items, result, player)
	if(result) then
		result:setAge(0)
	end
end