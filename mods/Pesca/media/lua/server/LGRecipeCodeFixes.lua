require ("recipecode");

function Recipe.OnCreate.CutFillet(items, result, player)
    local fish = nil
    for i=0,items:size() - 1 do
        if items:get(i):getType() == "FishFillet" then
            fish = items:get(i)
            break
        end
    end
    if fish then
		local number = 2;
		if fish:getHungerChange() >= (-0.4) then
			--nothing only received two fillet
		elseif fish:getHungerChange() < (-2) then
			number = 10
		elseif fish:getHungerChange() < (-1) then
			number = 4
		elseif fish:getHungerChange() < (-0.8) then
			number = 3
		elseif fish:getHungerChange() < (-0.4) then
			number = 2
		else
		end

		--player:Say(tostring(fish:getUnhappyChange()))
		if number >= 3 then
			for i=1,(number -2) do
				--player:Say(tostring(result:getFullType()))
				local Slice = InventoryItemFactory.CreateItem(result:getFullType())
				local fhunger = math.max(fish:getBaseHunger(), fish:getHungChange())
				Slice:setBaseHunger(fhunger / number);
				Slice:setHungChange(fhunger / number);
				Slice:setUnhappyChange(fish:getUnhappyChange()/ number)
				Slice:setActualWeight((fish:getActualWeight() * 0.9) / number)
				Slice:setWeight(Slice:getActualWeight());
				Slice:setCustomWeight(true)
				Slice:setCarbohydrates(fish:getCarbohydrates() / number);
				Slice:setLipids(fish:getLipids() / number);
				Slice:setProteins(fish:getProteins() / number);
				Slice:setCalories(fish:getCalories() / number);
				Slice:setCooked(fish:isCooked());
				Slice:setAge(fish:getAge());
				Slice:setBurnt(fish:isBurnt());
				player:getInventory():AddItem(Slice);
			end
		end
        local hunger = math.max(fish:getBaseHunger(), fish:getHungChange())
        result:setBaseHunger(hunger / number);
        result:setHungChange(hunger / number);
		result:setUnhappyChange(fish:getUnhappyChange()/ number)
        result:setActualWeight((fish:getActualWeight() * 0.9) / number)
        result:setWeight(result:getActualWeight());
        result:setCustomWeight(true)
        result:setCarbohydrates(fish:getCarbohydrates() / number);
        result:setLipids(fish:getLipids() / number);
        result:setProteins(fish:getProteins() / number);
        result:setCalories(fish:getCalories() / number);
		result:setCooked(fish:isCooked());
		result:setAge(fish:getAge());
		result:setBurnt(fish:isBurnt());
    end
end
