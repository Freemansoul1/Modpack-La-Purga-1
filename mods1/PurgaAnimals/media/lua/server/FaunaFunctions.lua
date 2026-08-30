FaunaRecipe = {}
FaunaRecipe.GetItemTypes = {}
FaunaRecipe.OnCanPerform = {}
FaunaRecipe.OnCreate = {}
FaunaRecipe.OnGiveXP = {}
FaunaRecipe.OnTest = {}

function FaunaRecipe.OnCreate.GetMilk(items, result, player)
	player:getInventory():AddItems("Milk" , 1);
end

function FaunaRecipe.OnCreate.GetEggs(items, result, player)
	player:getInventory():AddItems("Egg" , 4);
end

function FaunaRecipe.OnCreate.KeepName(items, result, _)
local item = items:get(0)
local itemName = item:getDisplayName()
-- print("Display nome: ", itemName)
    if itemName then
        result:setName(itemName)
	end
end

function FaunaRecipe.PetCat(items, result, player)
    -- Reduce Boredom, unhappyness and boredom
    player = getPlayer();
    bodyDamage = player:getBodyDamage();
	Stats = player:getStats();
    bodyDamage:setBoredomLevel(bodyDamage:getBoredomLevel() - 5);
	Stats:setStress(Stats:getStress() - 0.1);
	bodyDamage:setUnhappynessLevel(bodyDamage:getUnhappynessLevel() - 5);
	-- keep the name after petting 
	FaunaRecipe.OnCreate.KeepName(items, result, _);
	player:Say("Buen chico!")
end

function FaunaRecipe.PetDog(items, result, player)
    -- Reduce Boredom, unhappyness and boredom
    player = getPlayer();
    bodyDamage = player:getBodyDamage();
	Stats = player:getStats();
    bodyDamage:setBoredomLevel(bodyDamage:getBoredomLevel() - 10);
	Stats:setStress(Stats:getStress() - 0.1);
	bodyDamage:setUnhappynessLevel(bodyDamage:getUnhappynessLevel() - 10);
	-- keep the name after petting 
	FaunaRecipe.OnCreate.KeepName(items, result, _);
	player:Say("Buen chico!")
end