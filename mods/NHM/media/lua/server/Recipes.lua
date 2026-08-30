function pan_OnCreate(items, result, player, selectedItem)
    player:getInventory():AddItem("Base.Pan");
end

--ВОЗВРАТ ХИМ КОЛБ ПРИ КРАФТАХ
function flask_OnCreate(items, result, player, selectedItem)
    player:getInventory():AddItem("NHM.ChemicalFlask");
end

function flask2_OnCreate(items, result, player, selectedItem)
    player:getInventory():AddItems("NHM.ChemicalFlask", 2);
end

function flask3_OnCreate(items, result, player, selectedItem)
    player:getInventory():AddItems("NHM.ChemicalFlask", 3);
end

function flask4_OnCreate(items, result, player, selectedItem)
    player:getInventory():AddItems("NHM.ChemicalFlask", 4);
end

function flask5_OnCreate(items, result, player, selectedItem)
    player:getInventory():AddItems("NHM.ChemicalFlask", 5);
end

function flask6_OnCreate(items, result, player, selectedItem)
    player:getInventory():AddItems("NHM.ChemicalFlask", 6);
end

function flask7_OnCreate(items, result, player, selectedItem)
    player:getInventory():AddItems("NHM.ChemicalFlask", 7);
end

function flask8_OnCreate(items, result, player, selectedItem)
    player:getInventory():AddItems("NHM.ChemicalFlask", 8);
end
-- КОНЕЦ ВОЗВРАТ КОЛБ

--Коксовый уголь рандомный шанс 25%
function CokeCoal_OnCreate(items, result, player, selectedItem)
    x = ZombRand(4)
    if x == 3 then
        player:getInventory():AddItem("NHM.CokeCoal");
    end
end
--Конец коксовый уголь

--Каннибал разделка трупов
function Cannibal_OnCreate(items, result, player, selectedItem)
    local y = ZombRand(10)
    if y == 0 then
        player:getInventory():AddItem("NHM.InfectedSample");
    end
    if player:HasTrait("cannibal") then
        local x = ZombRand(4)
        if x == 1 then
            player:getInventory():AddItem("NHM.ZombieFlesh");
        end
    end
end

-- Конец каннибал

--ВЫДАЧА КОЖИ ПРИ РАЗДЕЛКЕ ЖИВОТНЫХ
function Recipe.OnCreate.CutAnimal1(items, result, player)
    local anim = nil;
    player:getInventory():AddItems("NHM.RawThinLeather", 1);
    player:getXp():AddXP(Perks.Leatherworking, 5 * 4);
    for i = 0, items:size() - 1 do
        if instanceof(items:get(i), "Food") then
            anim = items:get(i);
            break ;
        end
    end
    if anim then
        local new_hunger = anim:getBaseHunger() * 1.05;
        if (new_hunger < -100) then
            new_hunger = -100;
        end
        result:setBaseHunger(new_hunger);
        result:setHungChange(new_hunger);

        result:setCustomWeight(true);
        result:setWeight(anim:getWeight() * 0.7);
        result:setActualWeight(anim:getActualWeight() * 0.7);

        result:setLipids(anim:getLipids() * 0.75);
        result:setProteins(anim:getProteins() * 0.75);
        result:setCalories(anim:getCalories() * 0.75);
        result:setCarbohydrates(anim:getCarbohydrates() * 0.75);
    end
end

function Recipe.OnCreate.CutAnimal(items, result, player)
    local anim = nil;
    for i = 0, items:size() - 1 do
        if instanceof(items:get(i), "Food") then
            anim = items:get(i);
            break ;
        end
    end
    if anim then
        local new_hunger = anim:getBaseHunger() * 1.05;
        if (new_hunger < -100) then
            new_hunger = -100;
        end
        result:setBaseHunger(new_hunger);
        result:setHungChange(new_hunger);

        result:setCustomWeight(true);
        result:setWeight(anim:getWeight() * 0.7);
        result:setActualWeight(anim:getActualWeight() * 0.7);

        result:setLipids(anim:getLipids() * 0.75);
        result:setProteins(anim:getProteins() * 0.75);
        result:setCalories(anim:getCalories() * 0.75);
        result:setCarbohydrates(anim:getCarbohydrates() * 0.75);
    end
end

function Recipe.OnCreate.CraftEmptyBlowTorch(items, result, player)
    result:setDelta(0)
end

function Recipe.OnCreate.CraftEmptyPropaneTank(items, result, player)
    result:setDelta(0)
end
--КОНЕЦ ВЫДАЧА КОЖИ

function SearchWallet(items, result, player)
    local x = ZombRand(15)
    if
    getPlayer():HasTrait('task_start_army3') or getPlayer():HasTrait('task_start_army4')
    then
        player:getInventory():AddItem("NHM.QuestAToken");
    end
    if x <= 2 then
        player:getInventory():AddItem("Base.Money");
    elseif x == 3 or x == 4 then
        player:getInventory():AddItems("Base.Money", 2);
    elseif x == 5 then
        player:getInventory():AddItems("Base.Money", 3);
    end
end

function FixAnyFirearm(items, result, player)
    local zalupa = items:get(0)
    zalupa:setCondition(10)
end

--ВЫСЛЕДИТЬ ЗВЕРЯ
--ВОЛК
function HuntWolf_OnCreate(items, result, player)
    local skill1 = player:getPerkLevel(Perks.Aiming);
    local skill2 = player:getPerkLevel(Perks.Trapping);
    local skill4 = player:getPerkLevel(Perks.Spear);
    local skill3 = skill1 + skill2;
    local skill5 = skill4 + skill2;
    local hunt = skill3 + ZombRand(10);
    local hunt2 = skill5 + ZombRand(10);
    if hunt >= 11 or hunt2 >= 11 then
        player:getInventory():AddItem("NHM.WolfCarcass");
        player:getInventory():Remove("WolfFootprints");
    else
        player:Say(getText("UI_IMissed"));
        player:getInventory():Remove("WolfFootprints");
    end
end
--МЕДВЕДЬ
function HuntBear_OnCreate(items, result, player)
    local skill1 = player:getPerkLevel(Perks.Aiming);
    local skill2 = player:getPerkLevel(Perks.Trapping);
    local skill4 = player:getPerkLevel(Perks.Spear);
    local skill3 = skill1 + skill2;
    local skill5 = skill4 + skill2;
    local hunt = skill3 + ZombRand(10);
    local hunt2 = skill5 + ZombRand(10);
    if hunt >= 16 or hunt2 >= 16 then
        player:getInventory():AddItem("NHM.BearCarcass");
        player:getInventory():Remove("BearFootprints");
    else
        player:Say(getText("UI_IMissed"));
        player:getInventory():Remove("BearFootprints");
    end
end
--КАБАН
function HuntBoar_OnCreate(items, result, player)
    local skill1 = player:getPerkLevel(Perks.Aiming);
    local skill2 = player:getPerkLevel(Perks.Trapping);
    local skill4 = player:getPerkLevel(Perks.Spear);
    local skill3 = skill1 + skill2;
    local skill5 = skill4 + skill2;
    local hunt = skill3 + ZombRand(10);
    local hunt2 = skill5 + ZombRand(10);
    if hunt >= 13 or hunt2 >= 13 then
        player:getInventory():AddItem("NHM.BoarCarcass");
        player:getInventory():Remove("BoarFootprints");
    else
        player:Say(getText("UI_IMissed"));
        player:getInventory():Remove("BoarFootprints");
    end
end

function HuntGoat_OnCreate(items, result, player)
    local skill1 = player:getPerkLevel(Perks.Aiming);
    local skill2 = player:getPerkLevel(Perks.Trapping);
    local skill4 = player:getPerkLevel(Perks.Spear);
    local skill3 = skill1 + skill2;
    local skill5 = skill4 + skill2;
    local hunt = skill3 + ZombRand(10);
    local hunt2 = skill5 + ZombRand(10);
    if hunt >= 12 or hunt2 >= 12 then
        player:getInventory():AddItem("NHM.GoatCarcass");
        player:getInventory():Remove("GoatFootprints");
    else
        player:Say(getText("UI_IMissed"));
        player:getInventory():Remove("GoatFootprints");
    end
end

function HuntCow_OnCreate(items, result, player)
    local skill1 = player:getPerkLevel(Perks.Aiming);
    local skill2 = player:getPerkLevel(Perks.Trapping);
    local skill4 = player:getPerkLevel(Perks.Spear);
    local skill3 = skill1 + skill2;
    local skill5 = skill4 + skill2;
    local hunt = skill3 + ZombRand(10);
    local hunt2 = skill5 + ZombRand(10);
    if hunt >= 12 or hunt2 >= 12 then
        player:getInventory():AddItem("NHM.CowCarcass");
        player:getInventory():Remove("CowFootprints");
    else
        player:Say(getText("UI_IMissed"));
        player:getInventory():Remove("CowFootprints");
    end
end

function HuntFox_OnCreate(items, result, player)
    local skill1 = player:getPerkLevel(Perks.Aiming);
    local skill2 = player:getPerkLevel(Perks.Trapping);
    local skill4 = player:getPerkLevel(Perks.Spear);
    local skill3 = skill1 + skill2;
    local skill5 = skill4 + skill2;
    local hunt = skill3 + ZombRand(10);
    local hunt2 = skill5 + ZombRand(10);
    if hunt >= 9 or hunt2 >= 9 then
        player:getInventory():AddItem("NHM.FoxCarcass");
        player:getInventory():Remove("FoxFootprints");
    else
        player:Say(getText("UI_IMissed"));
        player:getInventory():Remove("FoxFootprints");
    end
end

function HuntODeer_OnCreate(items, result, player)
    local skill1 = player:getPerkLevel(Perks.Aiming);
    local skill2 = player:getPerkLevel(Perks.Trapping);
    local skill4 = player:getPerkLevel(Perks.Spear);
    local skill3 = skill1 + skill2;
    local skill5 = skill4 + skill2;
    local hunt = skill3 + ZombRand(10);
    local hunt2 = skill5 + ZombRand(10);
    if hunt >= 14 or hunt2 >= 14 then
        player:getInventory():AddItem("NHM.ODeerCarcass");
        player:getInventory():Remove("ODeerFootprints");
    else
        player:Say(getText("UI_IMissed"));
        player:getInventory():Remove("ODeerFootprints");
    end
end

function HuntYDeer_OnCreate(items, result, player)
    local skill1 = player:getPerkLevel(Perks.Aiming);
    local skill2 = player:getPerkLevel(Perks.Trapping);
    local skill4 = player:getPerkLevel(Perks.Spear);
    local skill3 = skill1 + skill2;
    local skill5 = skill4 + skill2;
    local hunt = skill3 + ZombRand(10);
    local hunt2 = skill5 + ZombRand(10);
    if hunt >= 15 or hunt2 >= 15 then
        player:getInventory():AddItem("NHM.YDeerCarcass");
        player:getInventory():Remove("YDeerFootprints");
    else
        player:Say(getText("UI_IMissed"));
        player:getInventory():Remove("YDeerFootprints");
    end
end

function HuntDog_OnCreate(items, result, player)
    local skill1 = player:getPerkLevel(Perks.Aiming);
    local skill2 = player:getPerkLevel(Perks.Trapping);
    local skill4 = player:getPerkLevel(Perks.Spear);
    local skill3 = skill1 + skill2;
    local skill5 = skill4 + skill2;
    local hunt = skill3 + ZombRand(10);
    local hunt2 = skill5 + ZombRand(10);
    if hunt >= 10 or hunt2 >= 10 then
        player:getInventory():AddItem("NHM.DogCarcass");
        player:getInventory():Remove("DogFootprints");
    else
        player:Say(getText("UI_IMissed"));
        player:getInventory():Remove("DogFootprints");
    end
end

function HuntMoose_OnCreate(items, result, player)
    local skill1 = player:getPerkLevel(Perks.Aiming);
    local skill2 = player:getPerkLevel(Perks.Trapping);
    local skill4 = player:getPerkLevel(Perks.Spear);
    local skill3 = skill1 + skill2;
    local skill5 = skill4 + skill2;
    local hunt = skill3 + ZombRand(10);
    local hunt2 = skill5 + ZombRand(10);
    if hunt >= 16 or hunt2 >= 16 then
        player:getInventory():AddItem("NHM.MooseCarcass");
        player:getInventory():Remove("MooseFootprints");
    else
        player:Say(getText("UI_IMissed"));
        player:getInventory():Remove("MooseFootprints");
    end
end

function HuntCoyote_OnCreate(items, result, player)
    local skill1 = player:getPerkLevel(Perks.Aiming);
    local skill2 = player:getPerkLevel(Perks.Trapping);
    local skill4 = player:getPerkLevel(Perks.Spear);
    local skill3 = skill1 + skill2;
    local skill5 = skill4 + skill2;
    local hunt = skill3 + ZombRand(10);
    local hunt2 = skill5 + ZombRand(10);
    if hunt >= 11 or hunt2 >= 11 then
        player:getInventory():AddItem("NHM.CoyoteCarcass");
        player:getInventory():Remove("CoyoteFootprints");
    else
        player:Say(getText("UI_IMissed"));
        player:getInventory():Remove("CoyoteFootprints");
    end
end

function HuntHare_OnCreate(items, result, player)
    local skill1 = player:getPerkLevel(Perks.Aiming);
    local skill2 = player:getPerkLevel(Perks.Trapping);
    local skill4 = player:getPerkLevel(Perks.Spear);
    local skill3 = skill1 + skill2;
    local skill5 = skill4 + skill2;
    local hunt = skill3 + ZombRand(10);
    local hunt2 = skill5 + ZombRand(10);
    if hunt >= 8 or hunt2 >= 8 then
        player:getInventory():AddItem("NHM.HareCarcass");
        player:getInventory():Remove("HareFootprints");
    else
        player:Say(getText("UI_IMissed"));
        player:getInventory():Remove("HareFootprints");
    end
end

function HuntChicken_OnCreate(items, result, player)
    local skill1 = player:getPerkLevel(Perks.Aiming);
    local skill2 = player:getPerkLevel(Perks.Trapping);
    local skill4 = player:getPerkLevel(Perks.Spear);
    local skill3 = skill1 + skill2;
    local skill5 = skill4 + skill2;
    local hunt = skill3 + ZombRand(10);
    local hunt2 = skill5 + ZombRand(10);
    if hunt >= 6 or hunt2 >= 6 then
        player:getInventory():AddItem("NHM.ChickenCarcass");
        player:getInventory():Remove("ChickenFootprints");
    else
        player:Say(getText("UI_IMissed"));
        player:getInventory():Remove("ChickenFootprints");
    end
end

function HuntCrow_OnCreate(items, result, player)
    local skill1 = player:getPerkLevel(Perks.Aiming);
    local skill2 = player:getPerkLevel(Perks.Trapping);
    local skill4 = player:getPerkLevel(Perks.Spear);
    local skill3 = skill1 + skill2;
    local skill5 = skill4 + skill2;
    local hunt = skill3 + ZombRand(10);
    local hunt2 = skill5 + ZombRand(10);
    if hunt >= 7 or hunt2 >=7 then
        player:getInventory():AddItem("NHM.CrowCarcass");
        player:getInventory():Remove("CrowFootprints");
    else
        player:Say(getText("UI_IMissed"));
        player:getInventory():Remove("CrowFootprints");
    end
end
--КОНЕЦ ВЫСЛЕДИТЬ ЗВЕРЯ

function GutTheCarcass_OnCreate(items, result, player)
    local povar = player:getPerkLevel(Perks.Cooking);
    local wool = ZombRand(3)
    for i = 0, items:size() - 1 do
        if items:get(i):getType() == "BoarCarcass" then
            -- 7
            player:getInventory():AddItems("NHM.Wool", 4);
            player:getInventory():AddItems("NHM.RawThinLeather", 6);
            player:getInventory():AddItems("NHM.Fat", 6);
            player:getInventory():AddItems("NHM.Bone", 5);
            player:getInventory():AddItems("Base.Steak", 3);

        elseif items:get(i):getType() == "BearCarcass" then
            --  10
            player:getInventory():AddItems("NHM.Wool", 6);
            player:getInventory():AddItems("NHM.RawThinLeather", 8);
            player:getInventory():AddItems("NHM.Fat", 7);
            player:getInventory():AddItems("NHM.Bone", 7);
            player:getInventory():AddItems("Base.Steak", 2);

        elseif items:get(i):getType() == "WolfCarcass" then
            -- 5
            player:getInventory():AddItems("NHM.Wool", 2);
            player:getInventory():AddItems("NHM.RawThinLeather", 4);
            player:getInventory():AddItems("NHM.Fat", 4);
            player:getInventory():AddItems("NHM.Bone", 4);
            player:getInventory():AddItems("Base.Steak", 2);

        elseif items:get(i):getType() == "GoatCarcass" then
            -- 6
            player:getInventory():AddItems("NHM.Wool", 4);
            player:getInventory():AddItems("NHM.RawThinLeather", 5);
            player:getInventory():AddItems("NHM.Fat", 4);
            player:getInventory():AddItems("NHM.Bone", 4);
            player:getInventory():AddItems("Base.Steak", 2);

        elseif items:get(i):getType() == "CowCarcass" then
            -- 6
            player:getInventory():AddItems("NHM.Wool", 1);
            player:getInventory():AddItems("NHM.RawThinLeather", 5);
            player:getInventory():AddItems("NHM.Fat", 5);
            player:getInventory():AddItems("NHM.Bone", 4);
            player:getInventory():AddItems("Base.Steak", 3);

        elseif items:get(i):getType() == "FoxCarcass" then
            -- 3
            player:getInventory():AddItems("NHM.Wool", 3);
            player:getInventory():AddItems("NHM.RawThinLeather", 3);
            player:getInventory():AddItems("NHM.Fat", 2);
            player:getInventory():AddItems("NHM.Bone", 2);
            player:getInventory():AddItems("Base.Steak", 1);

        elseif items:get(i):getType() == "ODeerCarcass" then
            --8
            player:getInventory():AddItems("NHM.Wool", 4);
            player:getInventory():AddItems("NHM.RawThinLeather", 6);
            player:getInventory():AddItems("NHM.Fat", 6);
            player:getInventory():AddItems("NHM.Bone", 5);
            player:getInventory():AddItems("Base.Steak", 3);

        elseif items:get(i):getType() == "YDeerCarcass" then
            --9
            player:getInventory():AddItems("NHM.Wool", 4);
            player:getInventory():AddItems("NHM.RawThinLeather", 7);
            player:getInventory():AddItems("NHM.Fat", 5);
            player:getInventory():AddItems("NHM.Bone", 6);
            player:getInventory():AddItems("Base.Steak", 3);

        elseif items:get(i):getType() == "DogCarcass" then
            --4
            player:getInventory():AddItems("NHM.Wool", 1);
            player:getInventory():AddItems("NHM.RawThinLeather", 3);
            player:getInventory():AddItems("NHM.Fat", 2);
            player:getInventory():AddItems("NHM.Bone", 3);
            player:getInventory():AddItems("Base.Steak", 1);

        elseif items:get(i):getType() == "MooseCarcass" then
            --10
            player:getInventory():AddItems("NHM.Wool", 5);
            player:getInventory():AddItems("NHM.RawThinLeather", 8);
            player:getInventory():AddItems("NHM.Fat", 9);
            player:getInventory():AddItems("NHM.Bone", 7);
            player:getInventory():AddItems("Base.Steak", 4);

        elseif items:get(i):getType() == "CoyoteCarcass" then
            --5
            player:getInventory():AddItems("NHM.Wool", 2);
            player:getInventory():AddItems("NHM.RawThinLeather", 4);
            player:getInventory():AddItems("NHM.Fat", 2);
            player:getInventory():AddItems("NHM.Bone", 3);
            player:getInventory():AddItems("Base.Steak", 2);

        elseif items:get(i):getType() == "HareCarcass" then
            --2
            player:getInventory():AddItems("NHM.Wool", 1);
            player:getInventory():AddItems("NHM.RawThinLeather", 2);
            player:getInventory():AddItems("NHM.Fat", 1);
            player:getInventory():AddItems("NHM.Bone", 2);
            player:getInventory():AddItems("Base.Rabbitmeat", 2);

        elseif items:get(i):getType() == "ChickenCarcass" then
            --1
            player:getInventory():AddItems("NHM.Feather", 4);
            player:getInventory():AddItems("NHM.Bone", 1);
            player:getInventory():AddItems("Base.Smallbirdmeat", 1);
            player:getInventory():AddItems("Base.WildEggs", 1);

        elseif items:get(i):getType() == "CrowCarcass" then
            --2
            player:getInventory():AddItems("NHM.Feather", 6);
            player:getInventory():AddItems("NHM.Bone", 1);
            player:getInventory():AddItems("Base.Smallbirdmeat", 2);
        end

    end
end

function Needles_OnCreate(items, result, player)
    local needle = ZombRand(10)
    if needle == 9 then
        player:getInventory():Remove("Needle");
    end
end

--ШИТЬЕ ОТКЛЮЧИТЬ ДРОП НИТОК
function Recipe.OnCreate.RipClothing(items, result, player, selectedItem)
    local item = items:get(0) -- assumes any tool comes after this in recipes.txt

    -- either we come from clothingrecipesdefinitions or we simply check number of covered parts by the clothing and add
    local materials = nil
    local nbrOfCoveredParts = nil
    local maxTime = 0 -- TODO: possibly allow recipe to call Lua function to get maxTime for actions
    if ClothingRecipesDefinitions[item:getType()] then
        local recipe = ClothingRecipesDefinitions[item:getType()]
        materials = luautils.split(recipe.materials, ":");
        maxTime = tonumber(materials[2]) * 20;
    elseif ClothingRecipesDefinitions["FabricType"][item:getFabricType()] then
        materials = {};
        materials[1] = ClothingRecipesDefinitions["FabricType"][item:getFabricType()].material;
        nbrOfCoveredParts = item:getNbrOfCoveredParts();
        local minMaterial = 2;
        local maxMaterial = nbrOfCoveredParts;
        if nbrOfCoveredParts == 1 then
            minMaterial = 1;
        end

        local nbr = ZombRand(minMaterial, maxMaterial + 1);
        nbr = nbr + (player:getPerkLevel(Perks.Tailoring) / 2);
        if nbr > nbrOfCoveredParts then
            nbr = nbrOfCoveredParts;
        end
        materials[2] = nbr;

        maxTime = nbrOfCoveredParts * 20;
    else
        error "Recipe.OnCreate.RipClothing"
    end

    for i = 1, tonumber(materials[2]) do
        local item2;
        local dirty = false;
        if instanceof(item, "Clothing") then
            dirty = (ZombRand(100) <= item:getDirtyness()) or (ZombRand(100) <= item:getBloodlevel());
        end
        if not dirty then
            item2 = InventoryItemFactory.CreateItem(materials[1]);
        elseif getScriptManager():FindItem(materials[1] .. "Dirty") then
            item2 = InventoryItemFactory.CreateItem(materials[1] .. "Dirty");
        else
            item2 = InventoryItemFactory.CreateItem(materials[1])
        end
        player:getInventory():AddItem(item2);
    end

    -- add thread sometimes, depending on tailoring level
    --[[ if ZombRand(7) < player:getPerkLevel(Perks.Tailoring) + 1 then
        local max = 2;
        if nbrOfCoveredParts then
            max = nbrOfCoveredParts;
            if max > 6 then
                max = 6;
            end
        end
        max = ZombRand(2, max);
        local thread = InventoryItemFactory.CreateItem("Base.Thread");
        for i=1,10-max do
            thread:Use();
        end
        player:getInventory():AddItem(thread);
        player:getXp():AddXP(Perks.Tailoring, 1);
    end ]]
end
--КОНЕЦ ОТКЛЮЧИТЬ НИТКИ


function pot_OnCreate(items, result, player, selectedItem)
    player:getInventory():AddItem("Base.Pot");
end

function RoastingPan_OnCreate(items, result, player, selectedItem)
    player:getInventory():Add("Base.RoastingPan");
end

function BakingTray_OnCreate(items, result, player, selectedItem)
    player:getInventory():Add("Base.BakingTray");
end

function GhostQuest1_onCreate(items, result, player, selectedItem)
    local x = player:getX()
    local y = player:getY()
    local formula = math.floor(math.sqrt(((9332 - x) ^ 2) + (6611 - y) ^ 2))
    if formula < 5 then
        local loot = ZombRand(30)
        if loot == 0 then
            --НАБОР КОЖЕВНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_HockeyMask", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jacket_Black", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGlovesBlack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_BlackBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 1 then
            -- НАБОР СТРОИТЕЛЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NailsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hammer", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Woodglue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.GardenSaw", 1, 1, 0);
        elseif loot == 2 then
            -- НАБОР РЫБАКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingLine", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFishing1", 1, 1, 0);
        elseif loot == 3 then
            -- НАБОР АВТОМЕХАНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrewsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MechanicMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.LugWrench", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wrench", 1, 1, 0);
        elseif loot == 4 then
            -- НАБОР ПОВАРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.RollingPin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Flour", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WineWaterFull", 1, 1, 0);
        elseif loot == 5 then
            -- НАБОР ЭЛЕКТРИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Screwdriver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectronicsMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoiseTrap", 1, 1, 0);
        elseif loot == 6 then
            -- НАБОР ХИРУРГА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scalpel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JacketLong_Doctor", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
        elseif loot == 7 then
            -- НАБОР ВЫЖИВАЛЬЩИКА С ЛОМОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.Crowbar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_RidingBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shorts_CamoGreenLong", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGloves", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shirt_CamoUrban", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glasses_Sun", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BaseballCapArmy", 1, 1, 0);
        elseif loot == 8 then
            -- НАБОР МЕДИКАМЕНТОВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsAntiDep", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsBeta", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Disinfectant", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedleHolder", 1, 1, 0);
        elseif loot == 9 then
            -- НАБОР ОХОТНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Raccoon", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vest_Hunting_Grey", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AmmoStrap_Shells", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HuntingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularKnife", 1, 1, 0);
        elseif loot == 10 then
            -- НАБОР КОВБОЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Revolver1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HolsterSimple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Cowboy", 1, 1, 0);
        elseif loot == 11 then
            -- НАБОР ЛВК
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
        elseif loot == 12 then
            -- НАБОР КОНСЕРВЫ
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedSardines", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPotato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPineapple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBolognese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TunaTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPeas", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedTomato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCornedBeef", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCorn", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedChili", 1, 1, 0);
        elseif loot == 13 then
            -- НАБОР СБИТЫЙ ПИЛОТ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolB1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolMag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bag_Satchel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Boilersuit_Flying", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_SPHhelmet", 1, 1, 0);
        elseif loot == 14 then
            -- НАБОР ДРОЧКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Underpants_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bra_Strapless_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BunnyEarsWhite", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Choker", 1, 1, 0);
        elseif loot == 15 then
            -- НАБОР ДЛЯ КОНСЕРВИРОВАНИЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BoxOfJars", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Pan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.OilVegetable", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wine2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
        elseif loot == 16 then
            -- НАБОР АЛКАША
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 17 then
            -- АПТЕКАРСКИЙ НАБОР
            player:getCurrentSquare():AddWorldInventoryItem("NHM.AntizinTier3", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.VirusTester", 1, 1, 0);
        elseif loot == 18 then
            -- ДЖЕНЕРИК НАБОР 1
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HandTorch", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 19 then
            -- НАБОР САМУРАЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularSword", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
        elseif loot == 20 then
            -- НАБОР БРОНЯ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Hat_BoneHelmet", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.BoneLegPads", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeHelbard", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeBigHammer", 1, 1, 0);
        elseif loot == 21 then
            --ДЖЕНЕРИК НАБОР 2
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBellPepper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsVitamins", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 22 then
            -- НАБОР ШАХТЕРА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotBronze", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 23 then
            -- НАБОР СТАЛКЕРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
        elseif loot == 24 then
            -- НАБОР ДОБЫТЧИКА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Kotomka", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Macandcheese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 25 then
            -- НАБОР БАЗОВЫХ РЕСУРСОВ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scotchtape", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
        elseif loot == 26 then
            -- НАБОР МЕТАЛЛОЛОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
        elseif loot == 27 then
            -- ДЖЕНЕРИК НАБОР 3
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
        elseif loot == 28 then
            --  НАБОР ПНВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBleachBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_PNV", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 29 then
            -- НАБОР СОКРОВИЩА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
        end
    else
        player:getInventory():AddItem("NHM.GhostQuest1");
        player:Say(getText("UI_Treasure") .. tostring(formula));
    end
end

function GhostQuest2_onCreate(items, result, player, selectedItem)
    local x = player:getX()
    local y = player:getY()
    local formula = math.floor(math.sqrt(((11768 - x) ^ 2) + (8951 - y) ^ 2))
    if formula < 5 then
        local loot = ZombRand(30)
        if loot == 0 then
            --НАБОР КОЖЕВНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_HockeyMask", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jacket_Black", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGlovesBlack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_BlackBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 1 then
            -- НАБОР СТРОИТЕЛЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NailsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hammer", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Woodglue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.GardenSaw", 1, 1, 0);
        elseif loot == 2 then
            -- НАБОР РЫБАКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingLine", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFishing1", 1, 1, 0);
        elseif loot == 3 then
            -- НАБОР АВТОМЕХАНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrewsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MechanicMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.LugWrench", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wrench", 1, 1, 0);
        elseif loot == 4 then
            -- НАБОР ПОВАРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.RollingPin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Flour", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WineWaterFull", 1, 1, 0);
        elseif loot == 5 then
            -- НАБОР ЭЛЕКТРИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Screwdriver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectronicsMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoiseTrap", 1, 1, 0);
        elseif loot == 6 then
            -- НАБОР ХИРУРГА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scalpel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JacketLong_Doctor", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
        elseif loot == 7 then
            -- НАБОР ВЫЖИВАЛЬЩИКА С ЛОМОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.Crowbar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_RidingBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shorts_CamoGreenLong", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGloves", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shirt_CamoUrban", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glasses_Sun", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BaseballCapArmy", 1, 1, 0);
        elseif loot == 8 then
            -- НАБОР МЕДИКАМЕНТОВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsAntiDep", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsBeta", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Disinfectant", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedleHolder", 1, 1, 0);
        elseif loot == 9 then
            -- НАБОР ОХОТНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Raccoon", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vest_Hunting_Grey", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AmmoStrap_Shells", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HuntingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularKnife", 1, 1, 0);
        elseif loot == 10 then
            -- НАБОР КОВБОЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Revolver1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HolsterSimple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Cowboy", 1, 1, 0);
        elseif loot == 11 then
            -- НАБОР ЛВК
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
        elseif loot == 12 then
            -- НАБОР КОНСЕРВЫ
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedSardines", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPotato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPineapple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBolognese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TunaTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPeas", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedTomato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCornedBeef", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCorn", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedChili", 1, 1, 0);
        elseif loot == 13 then
            -- НАБОР СБИТЫЙ ПИЛОТ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolB1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolMag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bag_Satchel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Boilersuit_Flying", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_SPHhelmet", 1, 1, 0);
        elseif loot == 14 then
            -- НАБОР ДРОЧКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Underpants_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bra_Strapless_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BunnyEarsWhite", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Choker", 1, 1, 0);
        elseif loot == 15 then
            -- НАБОР ДЛЯ КОНСЕРВИРОВАНИЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BoxOfJars", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Pan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.OilVegetable", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wine2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
        elseif loot == 16 then
            -- НАБОР АЛКАША
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 17 then
            -- АПТЕКАРСКИЙ НАБОР
            player:getCurrentSquare():AddWorldInventoryItem("NHM.AntizinTier3", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.VirusTester", 1, 1, 0);
        elseif loot == 18 then
            -- ДЖЕНЕРИК НАБОР 1
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HandTorch", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 19 then
            -- НАБОР САМУРАЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularSword", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
        elseif loot == 20 then
            -- НАБОР БРОНЯ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Hat_BoneHelmet", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.BoneLegPads", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeHelbard", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeBigHammer", 1, 1, 0);
        elseif loot == 21 then
            --ДЖЕНЕРИК НАБОР 2
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBellPepper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsVitamins", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 22 then
            -- НАБОР ШАХТЕРА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotBronze", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 23 then
            -- НАБОР СТАЛКЕРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
        elseif loot == 24 then
            -- НАБОР ДОБЫТЧИКА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Kotomka", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Macandcheese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 25 then
            -- НАБОР БАЗОВЫХ РЕСУРСОВ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scotchtape", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
        elseif loot == 26 then
            -- НАБОР МЕТАЛЛОЛОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
        elseif loot == 27 then
            -- ДЖЕНЕРИК НАБОР 3
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
        elseif loot == 28 then
            --  НАБОР ПНВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBleachBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_PNV", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 29 then
            -- НАБОР СОКРОВИЩА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
        end
    else
        player:getInventory():AddItem("NHM.GhostQuest2");
        player:Say(getText("UI_Treasure") .. tostring(formula));
    end
end

function GhostQuest3_onCreate(items, result, player, selectedItem)
    local x = player:getX()
    local y = player:getY()
    local formula = math.floor(math.sqrt(((6281 - x) ^ 2) + (6264 - y) ^ 2))
    if formula < 5 then
        local loot = ZombRand(30)
        if loot == 0 then
            --НАБОР КОЖЕВНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_HockeyMask", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jacket_Black", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGlovesBlack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_BlackBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 1 then
            -- НАБОР СТРОИТЕЛЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NailsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hammer", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Woodglue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.GardenSaw", 1, 1, 0);
        elseif loot == 2 then
            -- НАБОР РЫБАКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingLine", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFishing1", 1, 1, 0);
        elseif loot == 3 then
            -- НАБОР АВТОМЕХАНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrewsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MechanicMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.LugWrench", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wrench", 1, 1, 0);
        elseif loot == 4 then
            -- НАБОР ПОВАРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.RollingPin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Flour", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WineWaterFull", 1, 1, 0);
        elseif loot == 5 then
            -- НАБОР ЭЛЕКТРИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Screwdriver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectronicsMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoiseTrap", 1, 1, 0);
        elseif loot == 6 then
            -- НАБОР ХИРУРГА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scalpel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JacketLong_Doctor", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
        elseif loot == 7 then
            -- НАБОР ВЫЖИВАЛЬЩИКА С ЛОМОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.Crowbar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_RidingBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shorts_CamoGreenLong", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGloves", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shirt_CamoUrban", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glasses_Sun", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BaseballCapArmy", 1, 1, 0);
        elseif loot == 8 then
            -- НАБОР МЕДИКАМЕНТОВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsAntiDep", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsBeta", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Disinfectant", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedleHolder", 1, 1, 0);
        elseif loot == 9 then
            -- НАБОР ОХОТНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Raccoon", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vest_Hunting_Grey", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AmmoStrap_Shells", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HuntingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularKnife", 1, 1, 0);
        elseif loot == 10 then
            -- НАБОР КОВБОЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Revolver1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HolsterSimple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Cowboy", 1, 1, 0);
        elseif loot == 11 then
            -- НАБОР ЛВК
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
        elseif loot == 12 then
            -- НАБОР КОНСЕРВЫ
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedSardines", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPotato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPineapple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBolognese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TunaTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPeas", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedTomato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCornedBeef", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCorn", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedChili", 1, 1, 0);
        elseif loot == 13 then
            -- НАБОР СБИТЫЙ ПИЛОТ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolB1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolMag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bag_Satchel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Boilersuit_Flying", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_SPHhelmet", 1, 1, 0);
        elseif loot == 14 then
            -- НАБОР ДРОЧКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Underpants_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bra_Strapless_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BunnyEarsWhite", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Choker", 1, 1, 0);
        elseif loot == 15 then
            -- НАБОР ДЛЯ КОНСЕРВИРОВАНИЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BoxOfJars", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Pan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.OilVegetable", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wine2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
        elseif loot == 16 then
            -- НАБОР АЛКАША
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 17 then
            -- АПТЕКАРСКИЙ НАБОР
            player:getCurrentSquare():AddWorldInventoryItem("NHM.AntizinTier3", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.VirusTester", 1, 1, 0);
        elseif loot == 18 then
            -- ДЖЕНЕРИК НАБОР 1
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HandTorch", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 19 then
            -- НАБОР САМУРАЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularSword", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
        elseif loot == 20 then
            -- НАБОР БРОНЯ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Hat_BoneHelmet", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.BoneLegPads", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeHelbard", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeBigHammer", 1, 1, 0);
        elseif loot == 21 then
            --ДЖЕНЕРИК НАБОР 2
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBellPepper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsVitamins", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 22 then
            -- НАБОР ШАХТЕРА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotBronze", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 23 then
            -- НАБОР СТАЛКЕРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
        elseif loot == 24 then
            -- НАБОР ДОБЫТЧИКА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Kotomka", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Macandcheese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 25 then
            -- НАБОР БАЗОВЫХ РЕСУРСОВ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scotchtape", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
        elseif loot == 26 then
            -- НАБОР МЕТАЛЛОЛОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
        elseif loot == 27 then
            -- ДЖЕНЕРИК НАБОР 3
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
        elseif loot == 28 then
            --  НАБОР ПНВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBleachBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_PNV", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 29 then
            -- НАБОР СОКРОВИЩА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
        end
    else
        player:getInventory():AddItem("NHM.GhostQuest3");
        player:Say(getText("UI_Treasure") .. tostring(formula));
    end
end

function GhostQuest4_onCreate(items, result, player, selectedItem)
    local x = player:getX()
    local y = player:getY()
    local formula = math.floor(math.sqrt(((7913 - x) ^ 2) + (8172 - y) ^ 2))
    if formula < 5 then
        local loot = ZombRand(30)
        if loot == 0 then
            --НАБОР КОЖЕВНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_HockeyMask", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jacket_Black", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGlovesBlack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_BlackBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 1 then
            -- НАБОР СТРОИТЕЛЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NailsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hammer", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Woodglue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.GardenSaw", 1, 1, 0);
        elseif loot == 2 then
            -- НАБОР РЫБАКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingLine", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFishing1", 1, 1, 0);
        elseif loot == 3 then
            -- НАБОР АВТОМЕХАНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrewsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MechanicMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.LugWrench", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wrench", 1, 1, 0);
        elseif loot == 4 then
            -- НАБОР ПОВАРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.RollingPin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Flour", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WineWaterFull", 1, 1, 0);
        elseif loot == 5 then
            -- НАБОР ЭЛЕКТРИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Screwdriver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectronicsMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoiseTrap", 1, 1, 0);
        elseif loot == 6 then
            -- НАБОР ХИРУРГА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scalpel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JacketLong_Doctor", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
        elseif loot == 7 then
            -- НАБОР ВЫЖИВАЛЬЩИКА С ЛОМОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.Crowbar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_RidingBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shorts_CamoGreenLong", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGloves", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shirt_CamoUrban", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glasses_Sun", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BaseballCapArmy", 1, 1, 0);
        elseif loot == 8 then
            -- НАБОР МЕДИКАМЕНТОВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsAntiDep", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsBeta", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Disinfectant", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedleHolder", 1, 1, 0);
        elseif loot == 9 then
            -- НАБОР ОХОТНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Raccoon", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vest_Hunting_Grey", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AmmoStrap_Shells", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HuntingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularKnife", 1, 1, 0);
        elseif loot == 10 then
            -- НАБОР КОВБОЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Revolver1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HolsterSimple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Cowboy", 1, 1, 0);
        elseif loot == 11 then
            -- НАБОР ЛВК
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
        elseif loot == 12 then
            -- НАБОР КОНСЕРВЫ
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedSardines", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPotato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPineapple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBolognese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TunaTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPeas", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedTomato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCornedBeef", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCorn", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedChili", 1, 1, 0);
        elseif loot == 13 then
            -- НАБОР СБИТЫЙ ПИЛОТ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolB1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolMag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bag_Satchel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Boilersuit_Flying", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_SPHhelmet", 1, 1, 0);
        elseif loot == 14 then
            -- НАБОР ДРОЧКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Underpants_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bra_Strapless_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BunnyEarsWhite", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Choker", 1, 1, 0);
        elseif loot == 15 then
            -- НАБОР ДЛЯ КОНСЕРВИРОВАНИЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BoxOfJars", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Pan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.OilVegetable", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wine2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
        elseif loot == 16 then
            -- НАБОР АЛКАША
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 17 then
            -- АПТЕКАРСКИЙ НАБОР
            player:getCurrentSquare():AddWorldInventoryItem("NHM.AntizinTier3", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.VirusTester", 1, 1, 0);
        elseif loot == 18 then
            -- ДЖЕНЕРИК НАБОР 1
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HandTorch", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 19 then
            -- НАБОР САМУРАЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularSword", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
        elseif loot == 20 then
            -- НАБОР БРОНЯ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Hat_BoneHelmet", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.BoneLegPads", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeHelbard", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeBigHammer", 1, 1, 0);
        elseif loot == 21 then
            --ДЖЕНЕРИК НАБОР 2
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBellPepper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsVitamins", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 22 then
            -- НАБОР ШАХТЕРА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotBronze", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 23 then
            -- НАБОР СТАЛКЕРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
        elseif loot == 24 then
            -- НАБОР ДОБЫТЧИКА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Kotomka", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Macandcheese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 25 then
            -- НАБОР БАЗОВЫХ РЕСУРСОВ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scotchtape", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
        elseif loot == 26 then
            -- НАБОР МЕТАЛЛОЛОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
        elseif loot == 27 then
            -- ДЖЕНЕРИК НАБОР 3
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
        elseif loot == 28 then
            --  НАБОР ПНВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBleachBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_PNV", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 29 then
            -- НАБОР СОКРОВИЩА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
        end
    else
        player:getInventory():AddItem("NHM.GhostQuest4");
        player:Say(getText("UI_Treasure") .. tostring(formula));
    end
end

function GhostQuest5_onCreate(items, result, player, selectedItem)
    local x = player:getX()
    local y = player:getY()
    local formula = math.floor(math.sqrt(((6827 - x) ^ 2) + (7380 - y) ^ 2))
    if formula < 5 then
        local loot = ZombRand(30)
        if loot == 0 then
            --НАБОР КОЖЕВНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_HockeyMask", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jacket_Black", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGlovesBlack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_BlackBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 1 then
            -- НАБОР СТРОИТЕЛЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NailsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hammer", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Woodglue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.GardenSaw", 1, 1, 0);
        elseif loot == 2 then
            -- НАБОР РЫБАКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingLine", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFishing1", 1, 1, 0);
        elseif loot == 3 then
            -- НАБОР АВТОМЕХАНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrewsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MechanicMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.LugWrench", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wrench", 1, 1, 0);
        elseif loot == 4 then
            -- НАБОР ПОВАРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.RollingPin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Flour", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WineWaterFull", 1, 1, 0);
        elseif loot == 5 then
            -- НАБОР ЭЛЕКТРИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Screwdriver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectronicsMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoiseTrap", 1, 1, 0);
        elseif loot == 6 then
            -- НАБОР ХИРУРГА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scalpel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JacketLong_Doctor", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
        elseif loot == 7 then
            -- НАБОР ВЫЖИВАЛЬЩИКА С ЛОМОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.Crowbar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_RidingBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shorts_CamoGreenLong", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGloves", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shirt_CamoUrban", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glasses_Sun", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BaseballCapArmy", 1, 1, 0);
        elseif loot == 8 then
            -- НАБОР МЕДИКАМЕНТОВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsAntiDep", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsBeta", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Disinfectant", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedleHolder", 1, 1, 0);
        elseif loot == 9 then
            -- НАБОР ОХОТНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Raccoon", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vest_Hunting_Grey", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AmmoStrap_Shells", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HuntingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularKnife", 1, 1, 0);
        elseif loot == 10 then
            -- НАБОР КОВБОЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Revolver1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HolsterSimple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Cowboy", 1, 1, 0);
        elseif loot == 11 then
            -- НАБОР ЛВК
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
        elseif loot == 12 then
            -- НАБОР КОНСЕРВЫ
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedSardines", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPotato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPineapple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBolognese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TunaTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPeas", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedTomato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCornedBeef", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCorn", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedChili", 1, 1, 0);
        elseif loot == 13 then
            -- НАБОР СБИТЫЙ ПИЛОТ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolB1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolMag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bag_Satchel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Boilersuit_Flying", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_SPHhelmet", 1, 1, 0);
        elseif loot == 14 then
            -- НАБОР ДРОЧКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Underpants_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bra_Strapless_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BunnyEarsWhite", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Choker", 1, 1, 0);
        elseif loot == 15 then
            -- НАБОР ДЛЯ КОНСЕРВИРОВАНИЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BoxOfJars", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Pan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.OilVegetable", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wine2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
        elseif loot == 16 then
            -- НАБОР АЛКАША
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 17 then
            -- АПТЕКАРСКИЙ НАБОР
            player:getCurrentSquare():AddWorldInventoryItem("NHM.AntizinTier3", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.VirusTester", 1, 1, 0);
        elseif loot == 18 then
            -- ДЖЕНЕРИК НАБОР 1
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HandTorch", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 19 then
            -- НАБОР САМУРАЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularSword", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
        elseif loot == 20 then
            -- НАБОР БРОНЯ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Hat_BoneHelmet", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.BoneLegPads", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeHelbard", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeBigHammer", 1, 1, 0);
        elseif loot == 21 then
            --ДЖЕНЕРИК НАБОР 2
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBellPepper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsVitamins", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 22 then
            -- НАБОР ШАХТЕРА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotBronze", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 23 then
            -- НАБОР СТАЛКЕРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
        elseif loot == 24 then
            -- НАБОР ДОБЫТЧИКА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Kotomka", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Macandcheese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 25 then
            -- НАБОР БАЗОВЫХ РЕСУРСОВ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scotchtape", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
        elseif loot == 26 then
            -- НАБОР МЕТАЛЛОЛОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
        elseif loot == 27 then
            -- ДЖЕНЕРИК НАБОР 3
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
        elseif loot == 28 then
            --  НАБОР ПНВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBleachBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_PNV", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 29 then
            -- НАБОР СОКРОВИЩА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
        end
    else
        player:getInventory():AddItem("NHM.GhostQuest5");
        player:Say(getText("UI_Treasure") .. tostring(formula));
    end
end

function GhostQuest6_onCreate(items, result, player, selectedItem)
    local x = player:getX()
    local y = player:getY()
    local formula = math.floor(math.sqrt(((13941 - x) ^ 2) + (7401 - y) ^ 2))
    if formula < 5 then
        local loot = ZombRand(30)
        if loot == 0 then
            --НАБОР КОЖЕВНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_HockeyMask", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jacket_Black", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGlovesBlack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_BlackBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 1 then
            -- НАБОР СТРОИТЕЛЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NailsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hammer", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Woodglue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.GardenSaw", 1, 1, 0);
        elseif loot == 2 then
            -- НАБОР РЫБАКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingLine", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFishing1", 1, 1, 0);
        elseif loot == 3 then
            -- НАБОР АВТОМЕХАНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrewsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MechanicMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.LugWrench", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wrench", 1, 1, 0);
        elseif loot == 4 then
            -- НАБОР ПОВАРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.RollingPin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Flour", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WineWaterFull", 1, 1, 0);
        elseif loot == 5 then
            -- НАБОР ЭЛЕКТРИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Screwdriver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectronicsMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoiseTrap", 1, 1, 0);
        elseif loot == 6 then
            -- НАБОР ХИРУРГА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scalpel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JacketLong_Doctor", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
        elseif loot == 7 then
            -- НАБОР ВЫЖИВАЛЬЩИКА С ЛОМОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.Crowbar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_RidingBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shorts_CamoGreenLong", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGloves", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shirt_CamoUrban", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glasses_Sun", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BaseballCapArmy", 1, 1, 0);
        elseif loot == 8 then
            -- НАБОР МЕДИКАМЕНТОВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsAntiDep", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsBeta", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Disinfectant", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedleHolder", 1, 1, 0);
        elseif loot == 9 then
            -- НАБОР ОХОТНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Raccoon", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vest_Hunting_Grey", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AmmoStrap_Shells", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HuntingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularKnife", 1, 1, 0);
        elseif loot == 10 then
            -- НАБОР КОВБОЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Revolver1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HolsterSimple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Cowboy", 1, 1, 0);
        elseif loot == 11 then
            -- НАБОР ЛВК
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
        elseif loot == 12 then
            -- НАБОР КОНСЕРВЫ
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedSardines", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPotato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPineapple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBolognese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TunaTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPeas", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedTomato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCornedBeef", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCorn", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedChili", 1, 1, 0);
        elseif loot == 13 then
            -- НАБОР СБИТЫЙ ПИЛОТ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolB1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolMag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bag_Satchel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Boilersuit_Flying", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_SPHhelmet", 1, 1, 0);
        elseif loot == 14 then
            -- НАБОР ДРОЧКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Underpants_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bra_Strapless_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BunnyEarsWhite", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Choker", 1, 1, 0);
        elseif loot == 15 then
            -- НАБОР ДЛЯ КОНСЕРВИРОВАНИЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BoxOfJars", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Pan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.OilVegetable", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wine2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
        elseif loot == 16 then
            -- НАБОР АЛКАША
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 17 then
            -- АПТЕКАРСКИЙ НАБОР
            player:getCurrentSquare():AddWorldInventoryItem("NHM.AntizinTier3", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.VirusTester", 1, 1, 0);
        elseif loot == 18 then
            -- ДЖЕНЕРИК НАБОР 1
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HandTorch", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 19 then
            -- НАБОР САМУРАЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularSword", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
        elseif loot == 20 then
            -- НАБОР БРОНЯ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Hat_BoneHelmet", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.BoneLegPads", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeHelbard", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeBigHammer", 1, 1, 0);
        elseif loot == 21 then
            --ДЖЕНЕРИК НАБОР 2
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBellPepper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsVitamins", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 22 then
            -- НАБОР ШАХТЕРА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotBronze", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 23 then
            -- НАБОР СТАЛКЕРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
        elseif loot == 24 then
            -- НАБОР ДОБЫТЧИКА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Kotomka", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Macandcheese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 25 then
            -- НАБОР БАЗОВЫХ РЕСУРСОВ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scotchtape", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
        elseif loot == 26 then
            -- НАБОР МЕТАЛЛОЛОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
        elseif loot == 27 then
            -- ДЖЕНЕРИК НАБОР 3
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
        elseif loot == 28 then
            --  НАБОР ПНВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBleachBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_PNV", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 29 then
            -- НАБОР СОКРОВИЩА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
        end
    else
        player:getInventory():AddItem("NHM.GhostQuest6");
        player:Say(getText("UI_Treasure") .. tostring(formula));
    end
end

function GhostQuest7_onCreate(items, result, player, selectedItem)
    local x = player:getX()
    local y = player:getY()
    local formula = math.floor(math.sqrt(((13089 - x) ^ 2) + (6199 - y) ^ 2))
    if formula < 5 then
        local loot = ZombRand(30)
        if loot == 0 then
            --НАБОР КОЖЕВНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_HockeyMask", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jacket_Black", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGlovesBlack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_BlackBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 1 then
            -- НАБОР СТРОИТЕЛЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NailsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hammer", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Woodglue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.GardenSaw", 1, 1, 0);
        elseif loot == 2 then
            -- НАБОР РЫБАКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingLine", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFishing1", 1, 1, 0);
        elseif loot == 3 then
            -- НАБОР АВТОМЕХАНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrewsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MechanicMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.LugWrench", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wrench", 1, 1, 0);
        elseif loot == 4 then
            -- НАБОР ПОВАРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.RollingPin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Flour", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WineWaterFull", 1, 1, 0);
        elseif loot == 5 then
            -- НАБОР ЭЛЕКТРИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Screwdriver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectronicsMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoiseTrap", 1, 1, 0);
        elseif loot == 6 then
            -- НАБОР ХИРУРГА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scalpel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JacketLong_Doctor", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
        elseif loot == 7 then
            -- НАБОР ВЫЖИВАЛЬЩИКА С ЛОМОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.Crowbar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_RidingBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shorts_CamoGreenLong", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGloves", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shirt_CamoUrban", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glasses_Sun", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BaseballCapArmy", 1, 1, 0);
        elseif loot == 8 then
            -- НАБОР МЕДИКАМЕНТОВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsAntiDep", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsBeta", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Disinfectant", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedleHolder", 1, 1, 0);
        elseif loot == 9 then
            -- НАБОР ОХОТНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Raccoon", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vest_Hunting_Grey", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AmmoStrap_Shells", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HuntingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularKnife", 1, 1, 0);
        elseif loot == 10 then
            -- НАБОР КОВБОЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Revolver1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HolsterSimple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Cowboy", 1, 1, 0);
        elseif loot == 11 then
            -- НАБОР ЛВК
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
        elseif loot == 12 then
            -- НАБОР КОНСЕРВЫ
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedSardines", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPotato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPineapple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBolognese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TunaTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPeas", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedTomato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCornedBeef", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCorn", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedChili", 1, 1, 0);
        elseif loot == 13 then
            -- НАБОР СБИТЫЙ ПИЛОТ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolB1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolMag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bag_Satchel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Boilersuit_Flying", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_SPHhelmet", 1, 1, 0);
        elseif loot == 14 then
            -- НАБОР ДРОЧКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Underpants_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bra_Strapless_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BunnyEarsWhite", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Choker", 1, 1, 0);
        elseif loot == 15 then
            -- НАБОР ДЛЯ КОНСЕРВИРОВАНИЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BoxOfJars", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Pan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.OilVegetable", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wine2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
        elseif loot == 16 then
            -- НАБОР АЛКАША
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 17 then
            -- АПТЕКАРСКИЙ НАБОР
            player:getCurrentSquare():AddWorldInventoryItem("NHM.AntizinTier3", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.VirusTester", 1, 1, 0);
        elseif loot == 18 then
            -- ДЖЕНЕРИК НАБОР 1
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HandTorch", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 19 then
            -- НАБОР САМУРАЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularSword", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
        elseif loot == 20 then
            -- НАБОР БРОНЯ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Hat_BoneHelmet", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.BoneLegPads", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeHelbard", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeBigHammer", 1, 1, 0);
        elseif loot == 21 then
            --ДЖЕНЕРИК НАБОР 2
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBellPepper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsVitamins", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 22 then
            -- НАБОР ШАХТЕРА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotBronze", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 23 then
            -- НАБОР СТАЛКЕРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
        elseif loot == 24 then
            -- НАБОР ДОБЫТЧИКА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Kotomka", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Macandcheese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 25 then
            -- НАБОР БАЗОВЫХ РЕСУРСОВ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scotchtape", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
        elseif loot == 26 then
            -- НАБОР МЕТАЛЛОЛОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
        elseif loot == 27 then
            -- ДЖЕНЕРИК НАБОР 3
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
        elseif loot == 28 then
            --  НАБОР ПНВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBleachBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_PNV", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 29 then
            -- НАБОР СОКРОВИЩА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
        end
    else
        player:getInventory():AddItem("NHM.GhostQuest7");
        player:Say(getText("UI_Treasure") .. tostring(formula));
    end
end

function GhostQuest8_onCreate(items, result, player, selectedItem)
    local x = player:getX()
    local y = player:getY()
    local formula = math.floor(math.sqrt(((9440 - x) ^ 2) + (8205 - y) ^ 2))
    if formula < 5 then
        local loot = ZombRand(30)
        if loot == 0 then
            --НАБОР КОЖЕВНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_HockeyMask", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jacket_Black", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGlovesBlack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_BlackBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 1 then
            -- НАБОР СТРОИТЕЛЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NailsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hammer", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Woodglue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.GardenSaw", 1, 1, 0);
        elseif loot == 2 then
            -- НАБОР РЫБАКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingLine", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFishing1", 1, 1, 0);
        elseif loot == 3 then
            -- НАБОР АВТОМЕХАНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrewsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MechanicMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.LugWrench", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wrench", 1, 1, 0);
        elseif loot == 4 then
            -- НАБОР ПОВАРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.RollingPin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Flour", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WineWaterFull", 1, 1, 0);
        elseif loot == 5 then
            -- НАБОР ЭЛЕКТРИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Screwdriver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectronicsMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoiseTrap", 1, 1, 0);
        elseif loot == 6 then
            -- НАБОР ХИРУРГА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scalpel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JacketLong_Doctor", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
        elseif loot == 7 then
            -- НАБОР ВЫЖИВАЛЬЩИКА С ЛОМОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.Crowbar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_RidingBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shorts_CamoGreenLong", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGloves", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shirt_CamoUrban", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glasses_Sun", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BaseballCapArmy", 1, 1, 0);
        elseif loot == 8 then
            -- НАБОР МЕДИКАМЕНТОВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsAntiDep", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsBeta", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Disinfectant", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedleHolder", 1, 1, 0);
        elseif loot == 9 then
            -- НАБОР ОХОТНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Raccoon", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vest_Hunting_Grey", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AmmoStrap_Shells", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HuntingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularKnife", 1, 1, 0);
        elseif loot == 10 then
            -- НАБОР КОВБОЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Revolver1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HolsterSimple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Cowboy", 1, 1, 0);
        elseif loot == 11 then
            -- НАБОР ЛВК
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
        elseif loot == 12 then
            -- НАБОР КОНСЕРВЫ
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedSardines", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPotato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPineapple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBolognese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TunaTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPeas", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedTomato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCornedBeef", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCorn", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedChili", 1, 1, 0);
        elseif loot == 13 then
            -- НАБОР СБИТЫЙ ПИЛОТ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolB1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolMag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bag_Satchel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Boilersuit_Flying", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_SPHhelmet", 1, 1, 0);
        elseif loot == 14 then
            -- НАБОР ДРОЧКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Underpants_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bra_Strapless_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BunnyEarsWhite", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Choker", 1, 1, 0);
        elseif loot == 15 then
            -- НАБОР ДЛЯ КОНСЕРВИРОВАНИЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BoxOfJars", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Pan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.OilVegetable", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wine2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
        elseif loot == 16 then
            -- НАБОР АЛКАША
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 17 then
            -- АПТЕКАРСКИЙ НАБОР
            player:getCurrentSquare():AddWorldInventoryItem("NHM.AntizinTier3", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.VirusTester", 1, 1, 0);
        elseif loot == 18 then
            -- ДЖЕНЕРИК НАБОР 1
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HandTorch", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 19 then
            -- НАБОР САМУРАЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularSword", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
        elseif loot == 20 then
            -- НАБОР БРОНЯ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Hat_BoneHelmet", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.BoneLegPads", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeHelbard", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeBigHammer", 1, 1, 0);
        elseif loot == 21 then
            --ДЖЕНЕРИК НАБОР 2
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBellPepper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsVitamins", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 22 then
            -- НАБОР ШАХТЕРА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotBronze", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 23 then
            -- НАБОР СТАЛКЕРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
        elseif loot == 24 then
            -- НАБОР ДОБЫТЧИКА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Kotomka", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Macandcheese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 25 then
            -- НАБОР БАЗОВЫХ РЕСУРСОВ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scotchtape", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
        elseif loot == 26 then
            -- НАБОР МЕТАЛЛОЛОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
        elseif loot == 27 then
            -- ДЖЕНЕРИК НАБОР 3
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
        elseif loot == 28 then
            --  НАБОР ПНВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBleachBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_PNV", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 29 then
            -- НАБОР СОКРОВИЩА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
        end
    else
        player:getInventory():AddItem("NHM.GhostQuest8");
        player:Say(getText("UI_Treasure") .. tostring(formula));
    end
end

function GhostQuest9_onCreate(items, result, player, selectedItem)
    local x = player:getX()
    local y = player:getY()
    local formula = math.floor(math.sqrt(((11635 - x) ^ 2) + (10202 - y) ^ 2))
    if formula < 5 then
        local loot = ZombRand(30)
        if loot == 0 then
            --НАБОР КОЖЕВНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_HockeyMask", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jacket_Black", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGlovesBlack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_BlackBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 1 then
            -- НАБОР СТРОИТЕЛЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NailsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hammer", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Woodglue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.GardenSaw", 1, 1, 0);
        elseif loot == 2 then
            -- НАБОР РЫБАКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingLine", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFishing1", 1, 1, 0);
        elseif loot == 3 then
            -- НАБОР АВТОМЕХАНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrewsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MechanicMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.LugWrench", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wrench", 1, 1, 0);
        elseif loot == 4 then
            -- НАБОР ПОВАРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.RollingPin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Flour", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WineWaterFull", 1, 1, 0);
        elseif loot == 5 then
            -- НАБОР ЭЛЕКТРИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Screwdriver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectronicsMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoiseTrap", 1, 1, 0);
        elseif loot == 6 then
            -- НАБОР ХИРУРГА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scalpel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JacketLong_Doctor", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
        elseif loot == 7 then
            -- НАБОР ВЫЖИВАЛЬЩИКА С ЛОМОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.Crowbar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_RidingBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shorts_CamoGreenLong", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGloves", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shirt_CamoUrban", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glasses_Sun", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BaseballCapArmy", 1, 1, 0);
        elseif loot == 8 then
            -- НАБОР МЕДИКАМЕНТОВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsAntiDep", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsBeta", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Disinfectant", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedleHolder", 1, 1, 0);
        elseif loot == 9 then
            -- НАБОР ОХОТНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Raccoon", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vest_Hunting_Grey", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AmmoStrap_Shells", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HuntingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularKnife", 1, 1, 0);
        elseif loot == 10 then
            -- НАБОР КОВБОЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Revolver1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HolsterSimple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Cowboy", 1, 1, 0);
        elseif loot == 11 then
            -- НАБОР ЛВК
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
        elseif loot == 12 then
            -- НАБОР КОНСЕРВЫ
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedSardines", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPotato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPineapple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBolognese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TunaTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPeas", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedTomato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCornedBeef", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCorn", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedChili", 1, 1, 0);
        elseif loot == 13 then
            -- НАБОР СБИТЫЙ ПИЛОТ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolB1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolMag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bag_Satchel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Boilersuit_Flying", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_SPHhelmet", 1, 1, 0);
        elseif loot == 14 then
            -- НАБОР ДРОЧКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Underpants_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bra_Strapless_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BunnyEarsWhite", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Choker", 1, 1, 0);
        elseif loot == 15 then
            -- НАБОР ДЛЯ КОНСЕРВИРОВАНИЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BoxOfJars", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Pan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.OilVegetable", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wine2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
        elseif loot == 16 then
            -- НАБОР АЛКАША
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 17 then
            -- АПТЕКАРСКИЙ НАБОР
            player:getCurrentSquare():AddWorldInventoryItem("NHM.AntizinTier3", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.VirusTester", 1, 1, 0);
        elseif loot == 18 then
            -- ДЖЕНЕРИК НАБОР 1
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HandTorch", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 19 then
            -- НАБОР САМУРАЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularSword", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
        elseif loot == 20 then
            -- НАБОР БРОНЯ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Hat_BoneHelmet", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.BoneLegPads", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeHelbard", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeBigHammer", 1, 1, 0);
        elseif loot == 21 then
            --ДЖЕНЕРИК НАБОР 2
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBellPepper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsVitamins", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 22 then
            -- НАБОР ШАХТЕРА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotBronze", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 23 then
            -- НАБОР СТАЛКЕРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
        elseif loot == 24 then
            -- НАБОР ДОБЫТЧИКА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Kotomka", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Macandcheese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 25 then
            -- НАБОР БАЗОВЫХ РЕСУРСОВ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scotchtape", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
        elseif loot == 26 then
            -- НАБОР МЕТАЛЛОЛОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
        elseif loot == 27 then
            -- ДЖЕНЕРИК НАБОР 3
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
        elseif loot == 28 then
            --  НАБОР ПНВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBleachBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_PNV", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 29 then
            -- НАБОР СОКРОВИЩА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
        end
    else
        player:getInventory():AddItem("NHM.GhostQuest9");
        player:Say(getText("UI_Treasure") .. tostring(formula));
    end
end

function GhostQuest10_onCreate(items, result, player, selectedItem)
    local x = player:getX()
    local y = player:getY()
    local formula = math.floor(math.sqrt(((11028 - x) ^ 2) + (10264 - y) ^ 2))
    if formula < 5 then
        local loot = ZombRand(30)
        if loot == 0 then
            --НАБОР КОЖЕВНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_HockeyMask", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jacket_Black", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGlovesBlack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_BlackBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 1 then
            -- НАБОР СТРОИТЕЛЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NailsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hammer", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Woodglue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.GardenSaw", 1, 1, 0);
        elseif loot == 2 then
            -- НАБОР РЫБАКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingLine", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFishing1", 1, 1, 0);
        elseif loot == 3 then
            -- НАБОР АВТОМЕХАНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrewsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MechanicMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.LugWrench", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wrench", 1, 1, 0);
        elseif loot == 4 then
            -- НАБОР ПОВАРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.RollingPin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Flour", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WineWaterFull", 1, 1, 0);
        elseif loot == 5 then
            -- НАБОР ЭЛЕКТРИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Screwdriver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectronicsMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoiseTrap", 1, 1, 0);
        elseif loot == 6 then
            -- НАБОР ХИРУРГА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scalpel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JacketLong_Doctor", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
        elseif loot == 7 then
            -- НАБОР ВЫЖИВАЛЬЩИКА С ЛОМОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.Crowbar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_RidingBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shorts_CamoGreenLong", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGloves", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shirt_CamoUrban", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glasses_Sun", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BaseballCapArmy", 1, 1, 0);
        elseif loot == 8 then
            -- НАБОР МЕДИКАМЕНТОВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsAntiDep", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsBeta", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Disinfectant", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedleHolder", 1, 1, 0);
        elseif loot == 9 then
            -- НАБОР ОХОТНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Raccoon", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vest_Hunting_Grey", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AmmoStrap_Shells", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HuntingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularKnife", 1, 1, 0);
        elseif loot == 10 then
            -- НАБОР КОВБОЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Revolver1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HolsterSimple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Cowboy", 1, 1, 0);
        elseif loot == 11 then
            -- НАБОР ЛВК
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
        elseif loot == 12 then
            -- НАБОР КОНСЕРВЫ
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedSardines", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPotato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPineapple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBolognese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TunaTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPeas", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedTomato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCornedBeef", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCorn", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedChili", 1, 1, 0);
        elseif loot == 13 then
            -- НАБОР СБИТЫЙ ПИЛОТ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolB1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolMag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bag_Satchel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Boilersuit_Flying", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_SPHhelmet", 1, 1, 0);
        elseif loot == 14 then
            -- НАБОР ДРОЧКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Underpants_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bra_Strapless_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BunnyEarsWhite", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Choker", 1, 1, 0);
        elseif loot == 15 then
            -- НАБОР ДЛЯ КОНСЕРВИРОВАНИЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BoxOfJars", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Pan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.OilVegetable", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wine2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
        elseif loot == 16 then
            -- НАБОР АЛКАША
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 17 then
            -- АПТЕКАРСКИЙ НАБОР
            player:getCurrentSquare():AddWorldInventoryItem("NHM.AntizinTier3", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.VirusTester", 1, 1, 0);
        elseif loot == 18 then
            -- ДЖЕНЕРИК НАБОР 1
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HandTorch", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 19 then
            -- НАБОР САМУРАЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularSword", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
        elseif loot == 20 then
            -- НАБОР БРОНЯ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Hat_BoneHelmet", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.BoneLegPads", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeHelbard", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeBigHammer", 1, 1, 0);
        elseif loot == 21 then
            --ДЖЕНЕРИК НАБОР 2
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBellPepper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsVitamins", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 22 then
            -- НАБОР ШАХТЕРА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotBronze", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 23 then
            -- НАБОР СТАЛКЕРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
        elseif loot == 24 then
            -- НАБОР ДОБЫТЧИКА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Kotomka", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Macandcheese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 25 then
            -- НАБОР БАЗОВЫХ РЕСУРСОВ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scotchtape", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
        elseif loot == 26 then
            -- НАБОР МЕТАЛЛОЛОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
        elseif loot == 27 then
            -- ДЖЕНЕРИК НАБОР 3
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
        elseif loot == 28 then
            --  НАБОР ПНВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBleachBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_PNV", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 29 then
            -- НАБОР СОКРОВИЩА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
        end
    else
        player:getInventory():AddItem("NHM.GhostQuest10");
        player:Say(getText("UI_Treasure") .. tostring(formula));
    end
end

function GhostQuest11_onCreate(items, result, player, selectedItem)
    local x = player:getX()
    local y = player:getY()
    local formula = math.floor(math.sqrt(((7322 - x) ^ 2) + (9736 - y) ^ 2))
    if formula < 5 then
        local loot = ZombRand(30)
        if loot == 0 then
            --НАБОР КОЖЕВНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_HockeyMask", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jacket_Black", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGlovesBlack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_BlackBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 1 then
            -- НАБОР СТРОИТЕЛЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NailsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hammer", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Woodglue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.GardenSaw", 1, 1, 0);
        elseif loot == 2 then
            -- НАБОР РЫБАКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingLine", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFishing1", 1, 1, 0);
        elseif loot == 3 then
            -- НАБОР АВТОМЕХАНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrewsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MechanicMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.LugWrench", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wrench", 1, 1, 0);
        elseif loot == 4 then
            -- НАБОР ПОВАРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.RollingPin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Flour", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WineWaterFull", 1, 1, 0);
        elseif loot == 5 then
            -- НАБОР ЭЛЕКТРИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Screwdriver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectronicsMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoiseTrap", 1, 1, 0);
        elseif loot == 6 then
            -- НАБОР ХИРУРГА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scalpel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JacketLong_Doctor", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
        elseif loot == 7 then
            -- НАБОР ВЫЖИВАЛЬЩИКА С ЛОМОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.Crowbar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_RidingBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shorts_CamoGreenLong", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGloves", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shirt_CamoUrban", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glasses_Sun", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BaseballCapArmy", 1, 1, 0);
        elseif loot == 8 then
            -- НАБОР МЕДИКАМЕНТОВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsAntiDep", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsBeta", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Disinfectant", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedleHolder", 1, 1, 0);
        elseif loot == 9 then
            -- НАБОР ОХОТНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Raccoon", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vest_Hunting_Grey", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AmmoStrap_Shells", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HuntingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularKnife", 1, 1, 0);
        elseif loot == 10 then
            -- НАБОР КОВБОЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Revolver1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HolsterSimple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Cowboy", 1, 1, 0);
        elseif loot == 11 then
            -- НАБОР ЛВК
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
        elseif loot == 12 then
            -- НАБОР КОНСЕРВЫ
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedSardines", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPotato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPineapple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBolognese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TunaTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPeas", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedTomato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCornedBeef", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCorn", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedChili", 1, 1, 0);
        elseif loot == 13 then
            -- НАБОР СБИТЫЙ ПИЛОТ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolB1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolMag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bag_Satchel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Boilersuit_Flying", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_SPHhelmet", 1, 1, 0);
        elseif loot == 14 then
            -- НАБОР ДРОЧКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Underpants_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bra_Strapless_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BunnyEarsWhite", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Choker", 1, 1, 0);
        elseif loot == 15 then
            -- НАБОР ДЛЯ КОНСЕРВИРОВАНИЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BoxOfJars", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Pan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.OilVegetable", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wine2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
        elseif loot == 16 then
            -- НАБОР АЛКАША
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 17 then
            -- АПТЕКАРСКИЙ НАБОР
            player:getCurrentSquare():AddWorldInventoryItem("NHM.AntizinTier3", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.VirusTester", 1, 1, 0);
        elseif loot == 18 then
            -- ДЖЕНЕРИК НАБОР 1
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HandTorch", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 19 then
            -- НАБОР САМУРАЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularSword", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
        elseif loot == 20 then
            -- НАБОР БРОНЯ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Hat_BoneHelmet", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.BoneLegPads", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeHelbard", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeBigHammer", 1, 1, 0);
        elseif loot == 21 then
            --ДЖЕНЕРИК НАБОР 2
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBellPepper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsVitamins", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 22 then
            -- НАБОР ШАХТЕРА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotBronze", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 23 then
            -- НАБОР СТАЛКЕРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
        elseif loot == 24 then
            -- НАБОР ДОБЫТЧИКА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Kotomka", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Macandcheese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 25 then
            -- НАБОР БАЗОВЫХ РЕСУРСОВ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scotchtape", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
        elseif loot == 26 then
            -- НАБОР МЕТАЛЛОЛОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
        elseif loot == 27 then
            -- ДЖЕНЕРИК НАБОР 3
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
        elseif loot == 28 then
            --  НАБОР ПНВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBleachBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_PNV", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 29 then
            -- НАБОР СОКРОВИЩА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
        end
    else
        player:getInventory():AddItem("NHM.GhostQuest11");
        player:Say(getText("UI_Treasure") .. tostring(formula));
    end
end

function GhostQuest12_onCreate(items, result, player, selectedItem)
    local x = player:getX()
    local y = player:getY()
    local formula = math.floor(math.sqrt(((6793 - x) ^ 2) + (11602 - y) ^ 2))
    if formula < 5 then
        local loot = ZombRand(30)
        if loot == 0 then
            --НАБОР КОЖЕВНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_HockeyMask", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jacket_Black", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGlovesBlack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_BlackBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 1 then
            -- НАБОР СТРОИТЕЛЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NailsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hammer", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Woodglue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.GardenSaw", 1, 1, 0);
        elseif loot == 2 then
            -- НАБОР РЫБАКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingLine", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFishing1", 1, 1, 0);
        elseif loot == 3 then
            -- НАБОР АВТОМЕХАНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrewsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MechanicMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.LugWrench", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wrench", 1, 1, 0);
        elseif loot == 4 then
            -- НАБОР ПОВАРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.RollingPin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Flour", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WineWaterFull", 1, 1, 0);
        elseif loot == 5 then
            -- НАБОР ЭЛЕКТРИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Screwdriver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectronicsMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoiseTrap", 1, 1, 0);
        elseif loot == 6 then
            -- НАБОР ХИРУРГА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scalpel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JacketLong_Doctor", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
        elseif loot == 7 then
            -- НАБОР ВЫЖИВАЛЬЩИКА С ЛОМОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.Crowbar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_RidingBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shorts_CamoGreenLong", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGloves", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shirt_CamoUrban", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glasses_Sun", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BaseballCapArmy", 1, 1, 0);
        elseif loot == 8 then
            -- НАБОР МЕДИКАМЕНТОВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsAntiDep", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsBeta", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Disinfectant", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedleHolder", 1, 1, 0);
        elseif loot == 9 then
            -- НАБОР ОХОТНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Raccoon", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vest_Hunting_Grey", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AmmoStrap_Shells", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HuntingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularKnife", 1, 1, 0);
        elseif loot == 10 then
            -- НАБОР КОВБОЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Revolver1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HolsterSimple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Cowboy", 1, 1, 0);
        elseif loot == 11 then
            -- НАБОР ЛВК
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
        elseif loot == 12 then
            -- НАБОР КОНСЕРВЫ
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedSardines", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPotato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPineapple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBolognese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TunaTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPeas", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedTomato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCornedBeef", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCorn", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedChili", 1, 1, 0);
        elseif loot == 13 then
            -- НАБОР СБИТЫЙ ПИЛОТ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolB1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolMag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bag_Satchel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Boilersuit_Flying", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_SPHhelmet", 1, 1, 0);
        elseif loot == 14 then
            -- НАБОР ДРОЧКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Underpants_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bra_Strapless_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BunnyEarsWhite", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Choker", 1, 1, 0);
        elseif loot == 15 then
            -- НАБОР ДЛЯ КОНСЕРВИРОВАНИЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BoxOfJars", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Pan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.OilVegetable", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wine2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
        elseif loot == 16 then
            -- НАБОР АЛКАША
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 17 then
            -- АПТЕКАРСКИЙ НАБОР
            player:getCurrentSquare():AddWorldInventoryItem("NHM.AntizinTier3", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.VirusTester", 1, 1, 0);
        elseif loot == 18 then
            -- ДЖЕНЕРИК НАБОР 1
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HandTorch", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 19 then
            -- НАБОР САМУРАЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularSword", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
        elseif loot == 20 then
            -- НАБОР БРОНЯ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Hat_BoneHelmet", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.BoneLegPads", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeHelbard", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeBigHammer", 1, 1, 0);
        elseif loot == 21 then
            --ДЖЕНЕРИК НАБОР 2
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBellPepper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsVitamins", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 22 then
            -- НАБОР ШАХТЕРА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotBronze", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 23 then
            -- НАБОР СТАЛКЕРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
        elseif loot == 24 then
            -- НАБОР ДОБЫТЧИКА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Kotomka", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Macandcheese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 25 then
            -- НАБОР БАЗОВЫХ РЕСУРСОВ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scotchtape", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
        elseif loot == 26 then
            -- НАБОР МЕТАЛЛОЛОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
        elseif loot == 27 then
            -- ДЖЕНЕРИК НАБОР 3
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
        elseif loot == 28 then
            --  НАБОР ПНВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBleachBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_PNV", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 29 then
            -- НАБОР СОКРОВИЩА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
        end
    else
        player:getInventory():AddItem("NHM.GhostQuest12");
        player:Say(getText("UI_Treasure") .. tostring(formula));
    end
end

function GhostQuest13_onCreate(items, result, player, selectedItem)
    local x = player:getX()
    local y = player:getY()
    local formula = math.floor(math.sqrt(((6349 - x) ^ 2) + (8190 - y) ^ 2))
    if formula < 5 then
        local loot = ZombRand(30)
        if loot == 0 then
            --НАБОР КОЖЕВНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_HockeyMask", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jacket_Black", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGlovesBlack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_BlackBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 1 then
            -- НАБОР СТРОИТЕЛЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NailsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hammer", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Woodglue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.GardenSaw", 1, 1, 0);
        elseif loot == 2 then
            -- НАБОР РЫБАКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingLine", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFishing1", 1, 1, 0);
        elseif loot == 3 then
            -- НАБОР АВТОМЕХАНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrewsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MechanicMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.LugWrench", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wrench", 1, 1, 0);
        elseif loot == 4 then
            -- НАБОР ПОВАРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.RollingPin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Flour", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WineWaterFull", 1, 1, 0);
        elseif loot == 5 then
            -- НАБОР ЭЛЕКТРИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Screwdriver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectronicsMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoiseTrap", 1, 1, 0);
        elseif loot == 6 then
            -- НАБОР ХИРУРГА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scalpel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JacketLong_Doctor", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
        elseif loot == 7 then
            -- НАБОР ВЫЖИВАЛЬЩИКА С ЛОМОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.Crowbar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_RidingBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shorts_CamoGreenLong", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGloves", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shirt_CamoUrban", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glasses_Sun", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BaseballCapArmy", 1, 1, 0);
        elseif loot == 8 then
            -- НАБОР МЕДИКАМЕНТОВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsAntiDep", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsBeta", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Disinfectant", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedleHolder", 1, 1, 0);
        elseif loot == 9 then
            -- НАБОР ОХОТНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Raccoon", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vest_Hunting_Grey", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AmmoStrap_Shells", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HuntingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularKnife", 1, 1, 0);
        elseif loot == 10 then
            -- НАБОР КОВБОЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Revolver1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HolsterSimple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Cowboy", 1, 1, 0);
        elseif loot == 11 then
            -- НАБОР ЛВК
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
        elseif loot == 12 then
            -- НАБОР КОНСЕРВЫ
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedSardines", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPotato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPineapple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBolognese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TunaTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPeas", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedTomato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCornedBeef", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCorn", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedChili", 1, 1, 0);
        elseif loot == 13 then
            -- НАБОР СБИТЫЙ ПИЛОТ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolB1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolMag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bag_Satchel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Boilersuit_Flying", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_SPHhelmet", 1, 1, 0);
        elseif loot == 14 then
            -- НАБОР ДРОЧКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Underpants_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bra_Strapless_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BunnyEarsWhite", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Choker", 1, 1, 0);
        elseif loot == 15 then
            -- НАБОР ДЛЯ КОНСЕРВИРОВАНИЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BoxOfJars", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Pan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.OilVegetable", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wine2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
        elseif loot == 16 then
            -- НАБОР АЛКАША
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 17 then
            -- АПТЕКАРСКИЙ НАБОР
            player:getCurrentSquare():AddWorldInventoryItem("NHM.AntizinTier3", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.VirusTester", 1, 1, 0);
        elseif loot == 18 then
            -- ДЖЕНЕРИК НАБОР 1
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HandTorch", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 19 then
            -- НАБОР САМУРАЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularSword", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
        elseif loot == 20 then
            -- НАБОР БРОНЯ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Hat_BoneHelmet", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.BoneLegPads", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeHelbard", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeBigHammer", 1, 1, 0);
        elseif loot == 21 then
            --ДЖЕНЕРИК НАБОР 2
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBellPepper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsVitamins", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 22 then
            -- НАБОР ШАХТЕРА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotBronze", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 23 then
            -- НАБОР СТАЛКЕРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
        elseif loot == 24 then
            -- НАБОР ДОБЫТЧИКА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Kotomka", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Macandcheese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 25 then
            -- НАБОР БАЗОВЫХ РЕСУРСОВ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scotchtape", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
        elseif loot == 26 then
            -- НАБОР МЕТАЛЛОЛОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
        elseif loot == 27 then
            -- ДЖЕНЕРИК НАБОР 3
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
        elseif loot == 28 then
            --  НАБОР ПНВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBleachBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_PNV", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 29 then
            -- НАБОР СОКРОВИЩА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
        end
    else
        player:getInventory():AddItem("NHM.GhostQuest13");
        player:Say(getText("UI_Treasure") .. tostring(formula));
    end
end

function GhostQuest14_onCreate(items, result, player, selectedItem)
    local x = player:getX()
    local y = player:getY()
    local formula = math.floor(math.sqrt(((6768 - x) ^ 2) + (6218 - y) ^ 2))
    if formula < 5 then
        local loot = ZombRand(30)
        if loot == 0 then
            --НАБОР КОЖЕВНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_HockeyMask", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jacket_Black", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGlovesBlack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_BlackBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 1 then
            -- НАБОР СТРОИТЕЛЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NailsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hammer", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Woodglue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.GardenSaw", 1, 1, 0);
        elseif loot == 2 then
            -- НАБОР РЫБАКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingLine", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFishing1", 1, 1, 0);
        elseif loot == 3 then
            -- НАБОР АВТОМЕХАНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrewsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MechanicMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.LugWrench", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wrench", 1, 1, 0);
        elseif loot == 4 then
            -- НАБОР ПОВАРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.RollingPin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Flour", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WineWaterFull", 1, 1, 0);
        elseif loot == 5 then
            -- НАБОР ЭЛЕКТРИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Screwdriver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectronicsMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoiseTrap", 1, 1, 0);
        elseif loot == 6 then
            -- НАБОР ХИРУРГА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scalpel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JacketLong_Doctor", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
        elseif loot == 7 then
            -- НАБОР ВЫЖИВАЛЬЩИКА С ЛОМОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.Crowbar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_RidingBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shorts_CamoGreenLong", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGloves", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shirt_CamoUrban", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glasses_Sun", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BaseballCapArmy", 1, 1, 0);
        elseif loot == 8 then
            -- НАБОР МЕДИКАМЕНТОВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsAntiDep", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsBeta", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Disinfectant", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedleHolder", 1, 1, 0);
        elseif loot == 9 then
            -- НАБОР ОХОТНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Raccoon", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vest_Hunting_Grey", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AmmoStrap_Shells", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HuntingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularKnife", 1, 1, 0);
        elseif loot == 10 then
            -- НАБОР КОВБОЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Revolver1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HolsterSimple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Cowboy", 1, 1, 0);
        elseif loot == 11 then
            -- НАБОР ЛВК
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
        elseif loot == 12 then
            -- НАБОР КОНСЕРВЫ
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedSardines", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPotato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPineapple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBolognese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TunaTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPeas", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedTomato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCornedBeef", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCorn", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedChili", 1, 1, 0);
        elseif loot == 13 then
            -- НАБОР СБИТЫЙ ПИЛОТ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolB1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolMag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bag_Satchel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Boilersuit_Flying", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_SPHhelmet", 1, 1, 0);
        elseif loot == 14 then
            -- НАБОР ДРОЧКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Underpants_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bra_Strapless_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BunnyEarsWhite", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Choker", 1, 1, 0);
        elseif loot == 15 then
            -- НАБОР ДЛЯ КОНСЕРВИРОВАНИЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BoxOfJars", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Pan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.OilVegetable", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wine2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
        elseif loot == 16 then
            -- НАБОР АЛКАША
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 17 then
            -- АПТЕКАРСКИЙ НАБОР
            player:getCurrentSquare():AddWorldInventoryItem("NHM.AntizinTier3", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.VirusTester", 1, 1, 0);
        elseif loot == 18 then
            -- ДЖЕНЕРИК НАБОР 1
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HandTorch", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 19 then
            -- НАБОР САМУРАЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularSword", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
        elseif loot == 20 then
            -- НАБОР БРОНЯ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Hat_BoneHelmet", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.BoneLegPads", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeHelbard", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeBigHammer", 1, 1, 0);
        elseif loot == 21 then
            --ДЖЕНЕРИК НАБОР 2
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBellPepper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsVitamins", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 22 then
            -- НАБОР ШАХТЕРА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotBronze", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 23 then
            -- НАБОР СТАЛКЕРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
        elseif loot == 24 then
            -- НАБОР ДОБЫТЧИКА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Kotomka", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Macandcheese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 25 then
            -- НАБОР БАЗОВЫХ РЕСУРСОВ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scotchtape", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
        elseif loot == 26 then
            -- НАБОР МЕТАЛЛОЛОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
        elseif loot == 27 then
            -- ДЖЕНЕРИК НАБОР 3
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
        elseif loot == 28 then
            --  НАБОР ПНВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBleachBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_PNV", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 29 then
            -- НАБОР СОКРОВИЩА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
        end
    else
        player:getInventory():AddItem("NHM.GhostQuest14");
        player:Say(getText("UI_Treasure") .. tostring(formula));
    end
end

function GhostQuest15_onCreate(items, result, player, selectedItem)
    local x = player:getX()
    local y = player:getY()
    local formula = math.floor(math.sqrt(((7871 - x) ^ 2) + (7260 - y) ^ 2))
    if formula < 5 then
        local loot = ZombRand(30)
        if loot == 0 then
            --НАБОР КОЖЕВНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_HockeyMask", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jacket_Black", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGlovesBlack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_BlackBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 1 then
            -- НАБОР СТРОИТЕЛЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NailsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hammer", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Woodglue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.GardenSaw", 1, 1, 0);
        elseif loot == 2 then
            -- НАБОР РЫБАКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingLine", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFishing1", 1, 1, 0);
        elseif loot == 3 then
            -- НАБОР АВТОМЕХАНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrewsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MechanicMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.LugWrench", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wrench", 1, 1, 0);
        elseif loot == 4 then
            -- НАБОР ПОВАРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.RollingPin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Flour", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WineWaterFull", 1, 1, 0);
        elseif loot == 5 then
            -- НАБОР ЭЛЕКТРИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Screwdriver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectronicsMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoiseTrap", 1, 1, 0);
        elseif loot == 6 then
            -- НАБОР ХИРУРГА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scalpel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JacketLong_Doctor", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
        elseif loot == 7 then
            -- НАБОР ВЫЖИВАЛЬЩИКА С ЛОМОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.Crowbar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_RidingBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shorts_CamoGreenLong", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGloves", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shirt_CamoUrban", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glasses_Sun", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BaseballCapArmy", 1, 1, 0);
        elseif loot == 8 then
            -- НАБОР МЕДИКАМЕНТОВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsAntiDep", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsBeta", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Disinfectant", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedleHolder", 1, 1, 0);
        elseif loot == 9 then
            -- НАБОР ОХОТНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Raccoon", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vest_Hunting_Grey", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AmmoStrap_Shells", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HuntingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularKnife", 1, 1, 0);
        elseif loot == 10 then
            -- НАБОР КОВБОЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Revolver1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HolsterSimple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Cowboy", 1, 1, 0);
        elseif loot == 11 then
            -- НАБОР ЛВК
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
        elseif loot == 12 then
            -- НАБОР КОНСЕРВЫ
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedSardines", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPotato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPineapple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBolognese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TunaTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPeas", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedTomato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCornedBeef", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCorn", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedChili", 1, 1, 0);
        elseif loot == 13 then
            -- НАБОР СБИТЫЙ ПИЛОТ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolB1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolMag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bag_Satchel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Boilersuit_Flying", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_SPHhelmet", 1, 1, 0);
        elseif loot == 14 then
            -- НАБОР ДРОЧКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Underpants_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bra_Strapless_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BunnyEarsWhite", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Choker", 1, 1, 0);
        elseif loot == 15 then
            -- НАБОР ДЛЯ КОНСЕРВИРОВАНИЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BoxOfJars", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Pan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.OilVegetable", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wine2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
        elseif loot == 16 then
            -- НАБОР АЛКАША
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 17 then
            -- АПТЕКАРСКИЙ НАБОР
            player:getCurrentSquare():AddWorldInventoryItem("NHM.AntizinTier3", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.VirusTester", 1, 1, 0);
        elseif loot == 18 then
            -- ДЖЕНЕРИК НАБОР 1
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HandTorch", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 19 then
            -- НАБОР САМУРАЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularSword", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
        elseif loot == 20 then
            -- НАБОР БРОНЯ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Hat_BoneHelmet", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.BoneLegPads", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeHelbard", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeBigHammer", 1, 1, 0);
        elseif loot == 21 then
            --ДЖЕНЕРИК НАБОР 2
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBellPepper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsVitamins", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 22 then
            -- НАБОР ШАХТЕРА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotBronze", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 23 then
            -- НАБОР СТАЛКЕРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
        elseif loot == 24 then
            -- НАБОР ДОБЫТЧИКА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Kotomka", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Macandcheese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 25 then
            -- НАБОР БАЗОВЫХ РЕСУРСОВ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scotchtape", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
        elseif loot == 26 then
            -- НАБОР МЕТАЛЛОЛОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
        elseif loot == 27 then
            -- ДЖЕНЕРИК НАБОР 3
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
        elseif loot == 28 then
            --  НАБОР ПНВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBleachBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_PNV", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 29 then
            -- НАБОР СОКРОВИЩА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
        end
    else
        player:getInventory():AddItem("NHM.GhostQuest15");
        player:Say(getText("UI_Treasure") .. tostring(formula));
    end
end

function GhostQuest16_onCreate(items, result, player, selectedItem)
    local x = player:getX()
    local y = player:getY()
    local formula = math.floor(math.sqrt(((12863 - x) ^ 2) + (5758 - y) ^ 2))
    if formula < 5 then
        local loot = ZombRand(30)
        if loot == 0 then
            --НАБОР КОЖЕВНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_HockeyMask", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jacket_Black", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGlovesBlack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_BlackBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 1 then
            -- НАБОР СТРОИТЕЛЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NailsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hammer", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Woodglue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.GardenSaw", 1, 1, 0);
        elseif loot == 2 then
            -- НАБОР РЫБАКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingLine", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFishing1", 1, 1, 0);
        elseif loot == 3 then
            -- НАБОР АВТОМЕХАНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrewsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MechanicMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.LugWrench", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wrench", 1, 1, 0);
        elseif loot == 4 then
            -- НАБОР ПОВАРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.RollingPin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Flour", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WineWaterFull", 1, 1, 0);
        elseif loot == 5 then
            -- НАБОР ЭЛЕКТРИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Screwdriver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectronicsMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoiseTrap", 1, 1, 0);
        elseif loot == 6 then
            -- НАБОР ХИРУРГА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scalpel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JacketLong_Doctor", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
        elseif loot == 7 then
            -- НАБОР ВЫЖИВАЛЬЩИКА С ЛОМОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.Crowbar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_RidingBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shorts_CamoGreenLong", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGloves", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shirt_CamoUrban", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glasses_Sun", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BaseballCapArmy", 1, 1, 0);
        elseif loot == 8 then
            -- НАБОР МЕДИКАМЕНТОВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsAntiDep", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsBeta", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Disinfectant", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedleHolder", 1, 1, 0);
        elseif loot == 9 then
            -- НАБОР ОХОТНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Raccoon", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vest_Hunting_Grey", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AmmoStrap_Shells", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HuntingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularKnife", 1, 1, 0);
        elseif loot == 10 then
            -- НАБОР КОВБОЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Revolver1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HolsterSimple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Cowboy", 1, 1, 0);
        elseif loot == 11 then
            -- НАБОР ЛВК
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
        elseif loot == 12 then
            -- НАБОР КОНСЕРВЫ
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedSardines", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPotato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPineapple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBolognese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TunaTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPeas", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedTomato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCornedBeef", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCorn", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedChili", 1, 1, 0);
        elseif loot == 13 then
            -- НАБОР СБИТЫЙ ПИЛОТ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolB1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolMag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bag_Satchel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Boilersuit_Flying", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_SPHhelmet", 1, 1, 0);
        elseif loot == 14 then
            -- НАБОР ДРОЧКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Underpants_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bra_Strapless_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BunnyEarsWhite", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Choker", 1, 1, 0);
        elseif loot == 15 then
            -- НАБОР ДЛЯ КОНСЕРВИРОВАНИЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BoxOfJars", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Pan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.OilVegetable", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wine2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
        elseif loot == 16 then
            -- НАБОР АЛКАША
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 17 then
            -- АПТЕКАРСКИЙ НАБОР
            player:getCurrentSquare():AddWorldInventoryItem("NHM.AntizinTier3", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.VirusTester", 1, 1, 0);
        elseif loot == 18 then
            -- ДЖЕНЕРИК НАБОР 1
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HandTorch", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 19 then
            -- НАБОР САМУРАЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularSword", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
        elseif loot == 20 then
            -- НАБОР БРОНЯ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Hat_BoneHelmet", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.BoneLegPads", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeHelbard", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeBigHammer", 1, 1, 0);
        elseif loot == 21 then
            --ДЖЕНЕРИК НАБОР 2
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBellPepper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsVitamins", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 22 then
            -- НАБОР ШАХТЕРА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotBronze", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 23 then
            -- НАБОР СТАЛКЕРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
        elseif loot == 24 then
            -- НАБОР ДОБЫТЧИКА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Kotomka", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Macandcheese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 25 then
            -- НАБОР БАЗОВЫХ РЕСУРСОВ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scotchtape", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
        elseif loot == 26 then
            -- НАБОР МЕТАЛЛОЛОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
        elseif loot == 27 then
            -- ДЖЕНЕРИК НАБОР 3
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
        elseif loot == 28 then
            --  НАБОР ПНВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBleachBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_PNV", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 29 then
            -- НАБОР СОКРОВИЩА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
        end
    else
        player:getInventory():AddItem("NHM.GhostQuest16");
        player:Say(getText("UI_Treasure") .. tostring(formula));
    end
end

function GhostQuest17_onCreate(items, result, player, selectedItem)
    local x = player:getX()
    local y = player:getY()
    local formula = math.floor(math.sqrt(((13943 - x) ^ 2) + (4570 - y) ^ 2))
    if formula < 5 then
        local loot = ZombRand(30)
        if loot == 0 then
            --НАБОР КОЖЕВНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_HockeyMask", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jacket_Black", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGlovesBlack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_BlackBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 1 then
            -- НАБОР СТРОИТЕЛЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NailsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hammer", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Woodglue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.GardenSaw", 1, 1, 0);
        elseif loot == 2 then
            -- НАБОР РЫБАКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingLine", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFishing1", 1, 1, 0);
        elseif loot == 3 then
            -- НАБОР АВТОМЕХАНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrewsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MechanicMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.LugWrench", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wrench", 1, 1, 0);
        elseif loot == 4 then
            -- НАБОР ПОВАРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.RollingPin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Flour", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WineWaterFull", 1, 1, 0);
        elseif loot == 5 then
            -- НАБОР ЭЛЕКТРИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Screwdriver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectronicsMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoiseTrap", 1, 1, 0);
        elseif loot == 6 then
            -- НАБОР ХИРУРГА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scalpel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JacketLong_Doctor", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
        elseif loot == 7 then
            -- НАБОР ВЫЖИВАЛЬЩИКА С ЛОМОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.Crowbar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_RidingBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shorts_CamoGreenLong", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGloves", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shirt_CamoUrban", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glasses_Sun", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BaseballCapArmy", 1, 1, 0);
        elseif loot == 8 then
            -- НАБОР МЕДИКАМЕНТОВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsAntiDep", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsBeta", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Disinfectant", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedleHolder", 1, 1, 0);
        elseif loot == 9 then
            -- НАБОР ОХОТНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Raccoon", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vest_Hunting_Grey", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AmmoStrap_Shells", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HuntingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularKnife", 1, 1, 0);
        elseif loot == 10 then
            -- НАБОР КОВБОЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Revolver1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HolsterSimple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Cowboy", 1, 1, 0);
        elseif loot == 11 then
            -- НАБОР ЛВК
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
        elseif loot == 12 then
            -- НАБОР КОНСЕРВЫ
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedSardines", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPotato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPineapple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBolognese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TunaTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPeas", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedTomato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCornedBeef", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCorn", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedChili", 1, 1, 0);
        elseif loot == 13 then
            -- НАБОР СБИТЫЙ ПИЛОТ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolB1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolMag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bag_Satchel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Boilersuit_Flying", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_SPHhelmet", 1, 1, 0);
        elseif loot == 14 then
            -- НАБОР ДРОЧКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Underpants_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bra_Strapless_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BunnyEarsWhite", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Choker", 1, 1, 0);
        elseif loot == 15 then
            -- НАБОР ДЛЯ КОНСЕРВИРОВАНИЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BoxOfJars", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Pan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.OilVegetable", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wine2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
        elseif loot == 16 then
            -- НАБОР АЛКАША
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 17 then
            -- АПТЕКАРСКИЙ НАБОР
            player:getCurrentSquare():AddWorldInventoryItem("NHM.AntizinTier3", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.VirusTester", 1, 1, 0);
        elseif loot == 18 then
            -- ДЖЕНЕРИК НАБОР 1
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HandTorch", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 19 then
            -- НАБОР САМУРАЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularSword", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
        elseif loot == 20 then
            -- НАБОР БРОНЯ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Hat_BoneHelmet", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.BoneLegPads", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeHelbard", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeBigHammer", 1, 1, 0);
        elseif loot == 21 then
            --ДЖЕНЕРИК НАБОР 2
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBellPepper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsVitamins", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 22 then
            -- НАБОР ШАХТЕРА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotBronze", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 23 then
            -- НАБОР СТАЛКЕРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
        elseif loot == 24 then
            -- НАБОР ДОБЫТЧИКА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Kotomka", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Macandcheese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 25 then
            -- НАБОР БАЗОВЫХ РЕСУРСОВ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scotchtape", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
        elseif loot == 26 then
            -- НАБОР МЕТАЛЛОЛОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
        elseif loot == 27 then
            -- ДЖЕНЕРИК НАБОР 3
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
        elseif loot == 28 then
            --  НАБОР ПНВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBleachBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_PNV", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 29 then
            -- НАБОР СОКРОВИЩА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
        end
    else
        player:getInventory():AddItem("NHM.GhostQuest17");
        player:Say(getText("UI_Treasure") .. tostring(formula));
    end
end

function GhostQuest18_onCreate(items, result, player, selectedItem)
    local x = player:getX()
    local y = player:getY()
    local formula = math.floor(math.sqrt(((12739 - x) ^ 2) + (4197 - y) ^ 2))
    if formula < 5 then
        local loot = ZombRand(30)
        if loot == 0 then
            --НАБОР КОЖЕВНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_HockeyMask", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jacket_Black", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGlovesBlack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_BlackBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 1 then
            -- НАБОР СТРОИТЕЛЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NailsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hammer", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Woodglue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.GardenSaw", 1, 1, 0);
        elseif loot == 2 then
            -- НАБОР РЫБАКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingLine", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFishing1", 1, 1, 0);
        elseif loot == 3 then
            -- НАБОР АВТОМЕХАНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrewsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MechanicMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.LugWrench", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wrench", 1, 1, 0);
        elseif loot == 4 then
            -- НАБОР ПОВАРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.RollingPin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Flour", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WineWaterFull", 1, 1, 0);
        elseif loot == 5 then
            -- НАБОР ЭЛЕКТРИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Screwdriver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectronicsMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoiseTrap", 1, 1, 0);
        elseif loot == 6 then
            -- НАБОР ХИРУРГА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scalpel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JacketLong_Doctor", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
        elseif loot == 7 then
            -- НАБОР ВЫЖИВАЛЬЩИКА С ЛОМОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.Crowbar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_RidingBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shorts_CamoGreenLong", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGloves", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shirt_CamoUrban", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glasses_Sun", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BaseballCapArmy", 1, 1, 0);
        elseif loot == 8 then
            -- НАБОР МЕДИКАМЕНТОВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsAntiDep", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsBeta", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Disinfectant", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedleHolder", 1, 1, 0);
        elseif loot == 9 then
            -- НАБОР ОХОТНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Raccoon", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vest_Hunting_Grey", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AmmoStrap_Shells", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HuntingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularKnife", 1, 1, 0);
        elseif loot == 10 then
            -- НАБОР КОВБОЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Revolver1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HolsterSimple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Cowboy", 1, 1, 0);
        elseif loot == 11 then
            -- НАБОР ЛВК
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
        elseif loot == 12 then
            -- НАБОР КОНСЕРВЫ
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedSardines", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPotato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPineapple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBolognese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TunaTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPeas", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedTomato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCornedBeef", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCorn", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedChili", 1, 1, 0);
        elseif loot == 13 then
            -- НАБОР СБИТЫЙ ПИЛОТ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolB1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolMag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bag_Satchel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Boilersuit_Flying", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_SPHhelmet", 1, 1, 0);
        elseif loot == 14 then
            -- НАБОР ДРОЧКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Underpants_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bra_Strapless_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BunnyEarsWhite", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Choker", 1, 1, 0);
        elseif loot == 15 then
            -- НАБОР ДЛЯ КОНСЕРВИРОВАНИЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BoxOfJars", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Pan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.OilVegetable", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wine2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
        elseif loot == 16 then
            -- НАБОР АЛКАША
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 17 then
            -- АПТЕКАРСКИЙ НАБОР
            player:getCurrentSquare():AddWorldInventoryItem("NHM.AntizinTier3", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.VirusTester", 1, 1, 0);
        elseif loot == 18 then
            -- ДЖЕНЕРИК НАБОР 1
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HandTorch", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 19 then
            -- НАБОР САМУРАЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularSword", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
        elseif loot == 20 then
            -- НАБОР БРОНЯ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Hat_BoneHelmet", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.BoneLegPads", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeHelbard", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeBigHammer", 1, 1, 0);
        elseif loot == 21 then
            --ДЖЕНЕРИК НАБОР 2
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBellPepper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsVitamins", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 22 then
            -- НАБОР ШАХТЕРА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotBronze", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 23 then
            -- НАБОР СТАЛКЕРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
        elseif loot == 24 then
            -- НАБОР ДОБЫТЧИКА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Kotomka", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Macandcheese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 25 then
            -- НАБОР БАЗОВЫХ РЕСУРСОВ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scotchtape", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
        elseif loot == 26 then
            -- НАБОР МЕТАЛЛОЛОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
        elseif loot == 27 then
            -- ДЖЕНЕРИК НАБОР 3
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
        elseif loot == 28 then
            --  НАБОР ПНВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBleachBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_PNV", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 29 then
            -- НАБОР СОКРОВИЩА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
        end
    else
        player:getInventory():AddItem("NHM.GhostQuest18");
        player:Say(getText("UI_Treasure") .. tostring(formula));
    end
end

function GhostQuest19_onCreate(items, result, player, selectedItem)
    local x = player:getX()
    local y = player:getY()
    local formula = math.floor(math.sqrt(((13189 - x) ^ 2) + (3801 - y) ^ 2))
    if formula < 5 then
        local loot = ZombRand(30)
        if loot == 0 then
            --НАБОР КОЖЕВНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_HockeyMask", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jacket_Black", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGlovesBlack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_BlackBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 1 then
            -- НАБОР СТРОИТЕЛЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NailsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hammer", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Woodglue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.GardenSaw", 1, 1, 0);
        elseif loot == 2 then
            -- НАБОР РЫБАКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingLine", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFishing1", 1, 1, 0);
        elseif loot == 3 then
            -- НАБОР АВТОМЕХАНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrewsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MechanicMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.LugWrench", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wrench", 1, 1, 0);
        elseif loot == 4 then
            -- НАБОР ПОВАРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.RollingPin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Flour", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WineWaterFull", 1, 1, 0);
        elseif loot == 5 then
            -- НАБОР ЭЛЕКТРИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Screwdriver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectronicsMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoiseTrap", 1, 1, 0);
        elseif loot == 6 then
            -- НАБОР ХИРУРГА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scalpel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JacketLong_Doctor", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
        elseif loot == 7 then
            -- НАБОР ВЫЖИВАЛЬЩИКА С ЛОМОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.Crowbar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_RidingBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shorts_CamoGreenLong", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGloves", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shirt_CamoUrban", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glasses_Sun", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BaseballCapArmy", 1, 1, 0);
        elseif loot == 8 then
            -- НАБОР МЕДИКАМЕНТОВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsAntiDep", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsBeta", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Disinfectant", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedleHolder", 1, 1, 0);
        elseif loot == 9 then
            -- НАБОР ОХОТНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Raccoon", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vest_Hunting_Grey", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AmmoStrap_Shells", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HuntingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularKnife", 1, 1, 0);
        elseif loot == 10 then
            -- НАБОР КОВБОЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Revolver1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HolsterSimple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Cowboy", 1, 1, 0);
        elseif loot == 11 then
            -- НАБОР ЛВК
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
        elseif loot == 12 then
            -- НАБОР КОНСЕРВЫ
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedSardines", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPotato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPineapple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBolognese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TunaTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPeas", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedTomato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCornedBeef", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCorn", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedChili", 1, 1, 0);
        elseif loot == 13 then
            -- НАБОР СБИТЫЙ ПИЛОТ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolB1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolMag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bag_Satchel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Boilersuit_Flying", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_SPHhelmet", 1, 1, 0);
        elseif loot == 14 then
            -- НАБОР ДРОЧКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Underpants_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bra_Strapless_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BunnyEarsWhite", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Choker", 1, 1, 0);
        elseif loot == 15 then
            -- НАБОР ДЛЯ КОНСЕРВИРОВАНИЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BoxOfJars", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Pan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.OilVegetable", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wine2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
        elseif loot == 16 then
            -- НАБОР АЛКАША
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 17 then
            -- АПТЕКАРСКИЙ НАБОР
            player:getCurrentSquare():AddWorldInventoryItem("NHM.AntizinTier3", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.VirusTester", 1, 1, 0);
        elseif loot == 18 then
            -- ДЖЕНЕРИК НАБОР 1
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HandTorch", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 19 then
            -- НАБОР САМУРАЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularSword", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
        elseif loot == 20 then
            -- НАБОР БРОНЯ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Hat_BoneHelmet", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.BoneLegPads", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeHelbard", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeBigHammer", 1, 1, 0);
        elseif loot == 21 then
            --ДЖЕНЕРИК НАБОР 2
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBellPepper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsVitamins", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 22 then
            -- НАБОР ШАХТЕРА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotBronze", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 23 then
            -- НАБОР СТАЛКЕРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
        elseif loot == 24 then
            -- НАБОР ДОБЫТЧИКА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Kotomka", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Macandcheese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 25 then
            -- НАБОР БАЗОВЫХ РЕСУРСОВ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scotchtape", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
        elseif loot == 26 then
            -- НАБОР МЕТАЛЛОЛОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
        elseif loot == 27 then
            -- ДЖЕНЕРИК НАБОР 3
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
        elseif loot == 28 then
            --  НАБОР ПНВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBleachBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_PNV", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 29 then
            -- НАБОР СОКРОВИЩА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
        end
    else
        player:getInventory():AddItem("NHM.GhostQuest19");
        player:Say(getText("UI_Treasure") .. tostring(formula));
    end
end

function GhostQuest20_onCreate(items, result, player, selectedItem)
    local x = player:getX()
    local y = player:getY()
    local formula = math.floor(math.sqrt(((7670 - x) ^ 2) + (11882 - y) ^ 2))
    if formula < 5 then
        local loot = ZombRand(30)
        if loot == 0 then
            --НАБОР КОЖЕВНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_HockeyMask", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jacket_Black", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGlovesBlack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_BlackBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 1 then
            -- НАБОР СТРОИТЕЛЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NailsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hammer", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Woodglue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.GardenSaw", 1, 1, 0);
        elseif loot == 2 then
            -- НАБОР РЫБАКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingLine", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFishing1", 1, 1, 0);
        elseif loot == 3 then
            -- НАБОР АВТОМЕХАНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrewsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MechanicMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.LugWrench", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wrench", 1, 1, 0);
        elseif loot == 4 then
            -- НАБОР ПОВАРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.RollingPin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Flour", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WineWaterFull", 1, 1, 0);
        elseif loot == 5 then
            -- НАБОР ЭЛЕКТРИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Screwdriver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectronicsMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoiseTrap", 1, 1, 0);
        elseif loot == 6 then
            -- НАБОР ХИРУРГА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scalpel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JacketLong_Doctor", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
        elseif loot == 7 then
            -- НАБОР ВЫЖИВАЛЬЩИКА С ЛОМОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.Crowbar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_RidingBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shorts_CamoGreenLong", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGloves", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shirt_CamoUrban", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glasses_Sun", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BaseballCapArmy", 1, 1, 0);
        elseif loot == 8 then
            -- НАБОР МЕДИКАМЕНТОВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsAntiDep", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsBeta", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Disinfectant", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedleHolder", 1, 1, 0);
        elseif loot == 9 then
            -- НАБОР ОХОТНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Raccoon", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vest_Hunting_Grey", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AmmoStrap_Shells", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HuntingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularKnife", 1, 1, 0);
        elseif loot == 10 then
            -- НАБОР КОВБОЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Revolver1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HolsterSimple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Cowboy", 1, 1, 0);
        elseif loot == 11 then
            -- НАБОР ЛВК
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
        elseif loot == 12 then
            -- НАБОР КОНСЕРВЫ
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedSardines", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPotato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPineapple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBolognese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TunaTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPeas", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedTomato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCornedBeef", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCorn", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedChili", 1, 1, 0);
        elseif loot == 13 then
            -- НАБОР СБИТЫЙ ПИЛОТ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolB1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolMag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bag_Satchel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Boilersuit_Flying", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_SPHhelmet", 1, 1, 0);
        elseif loot == 14 then
            -- НАБОР ДРОЧКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Underpants_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bra_Strapless_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BunnyEarsWhite", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Choker", 1, 1, 0);
        elseif loot == 15 then
            -- НАБОР ДЛЯ КОНСЕРВИРОВАНИЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BoxOfJars", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Pan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.OilVegetable", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wine2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
        elseif loot == 16 then
            -- НАБОР АЛКАША
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 17 then
            -- АПТЕКАРСКИЙ НАБОР
            player:getCurrentSquare():AddWorldInventoryItem("NHM.AntizinTier3", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.VirusTester", 1, 1, 0);
        elseif loot == 18 then
            -- ДЖЕНЕРИК НАБОР 1
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HandTorch", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 19 then
            -- НАБОР САМУРАЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularSword", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
        elseif loot == 20 then
            -- НАБОР БРОНЯ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Hat_BoneHelmet", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.BoneLegPads", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeHelbard", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeBigHammer", 1, 1, 0);
        elseif loot == 21 then
            --ДЖЕНЕРИК НАБОР 2
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBellPepper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsVitamins", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 22 then
            -- НАБОР ШАХТЕРА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotBronze", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 23 then
            -- НАБОР СТАЛКЕРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
        elseif loot == 24 then
            -- НАБОР ДОБЫТЧИКА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Kotomka", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Macandcheese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 25 then
            -- НАБОР БАЗОВЫХ РЕСУРСОВ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scotchtape", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
        elseif loot == 26 then
            -- НАБОР МЕТАЛЛОЛОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
        elseif loot == 27 then
            -- ДЖЕНЕРИК НАБОР 3
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
        elseif loot == 28 then
            --  НАБОР ПНВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBleachBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_PNV", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 29 then
            -- НАБОР СОКРОВИЩА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
        end
    else
        player:getInventory():AddItem("NHM.GhostQuest20");
        player:Say(getText("UI_Treasure") .. tostring(formula));
    end
end

function GhostQuest21_onCreate(items, result, player, selectedItem)
    local x = player:getX()
    local y = player:getY()
    local formula = math.floor(math.sqrt(((10444 - x) ^ 2) + (12605 - y) ^ 2))
    if formula < 5 then
        local loot = ZombRand(30)
        if loot == 0 then
            --НАБОР КОЖЕВНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_HockeyMask", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jacket_Black", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGlovesBlack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_BlackBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 1 then
            -- НАБОР СТРОИТЕЛЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NailsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hammer", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Woodglue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.GardenSaw", 1, 1, 0);
        elseif loot == 2 then
            -- НАБОР РЫБАКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingLine", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFishing1", 1, 1, 0);
        elseif loot == 3 then
            -- НАБОР АВТОМЕХАНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrewsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MechanicMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.LugWrench", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wrench", 1, 1, 0);
        elseif loot == 4 then
            -- НАБОР ПОВАРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.RollingPin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Flour", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WineWaterFull", 1, 1, 0);
        elseif loot == 5 then
            -- НАБОР ЭЛЕКТРИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Screwdriver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectronicsMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoiseTrap", 1, 1, 0);
        elseif loot == 6 then
            -- НАБОР ХИРУРГА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scalpel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JacketLong_Doctor", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
        elseif loot == 7 then
            -- НАБОР ВЫЖИВАЛЬЩИКА С ЛОМОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.Crowbar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_RidingBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shorts_CamoGreenLong", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGloves", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shirt_CamoUrban", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glasses_Sun", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BaseballCapArmy", 1, 1, 0);
        elseif loot == 8 then
            -- НАБОР МЕДИКАМЕНТОВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsAntiDep", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsBeta", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Disinfectant", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedleHolder", 1, 1, 0);
        elseif loot == 9 then
            -- НАБОР ОХОТНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Raccoon", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vest_Hunting_Grey", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AmmoStrap_Shells", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HuntingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularKnife", 1, 1, 0);
        elseif loot == 10 then
            -- НАБОР КОВБОЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Revolver1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HolsterSimple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Cowboy", 1, 1, 0);
        elseif loot == 11 then
            -- НАБОР ЛВК
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
        elseif loot == 12 then
            -- НАБОР КОНСЕРВЫ
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedSardines", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPotato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPineapple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBolognese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TunaTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPeas", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedTomato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCornedBeef", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCorn", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedChili", 1, 1, 0);
        elseif loot == 13 then
            -- НАБОР СБИТЫЙ ПИЛОТ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolB1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolMag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bag_Satchel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Boilersuit_Flying", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_SPHhelmet", 1, 1, 0);
        elseif loot == 14 then
            -- НАБОР ДРОЧКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Underpants_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bra_Strapless_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BunnyEarsWhite", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Choker", 1, 1, 0);
        elseif loot == 15 then
            -- НАБОР ДЛЯ КОНСЕРВИРОВАНИЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BoxOfJars", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Pan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.OilVegetable", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wine2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
        elseif loot == 16 then
            -- НАБОР АЛКАША
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 17 then
            -- АПТЕКАРСКИЙ НАБОР
            player:getCurrentSquare():AddWorldInventoryItem("NHM.AntizinTier3", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.VirusTester", 1, 1, 0);
        elseif loot == 18 then
            -- ДЖЕНЕРИК НАБОР 1
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HandTorch", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 19 then
            -- НАБОР САМУРАЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularSword", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
        elseif loot == 20 then
            -- НАБОР БРОНЯ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Hat_BoneHelmet", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.BoneLegPads", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeHelbard", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeBigHammer", 1, 1, 0);
        elseif loot == 21 then
            --ДЖЕНЕРИК НАБОР 2
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBellPepper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsVitamins", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 22 then
            -- НАБОР ШАХТЕРА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotBronze", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 23 then
            -- НАБОР СТАЛКЕРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
        elseif loot == 24 then
            -- НАБОР ДОБЫТЧИКА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Kotomka", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Macandcheese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 25 then
            -- НАБОР БАЗОВЫХ РЕСУРСОВ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scotchtape", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
        elseif loot == 26 then
            -- НАБОР МЕТАЛЛОЛОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
        elseif loot == 27 then
            -- ДЖЕНЕРИК НАБОР 3
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
        elseif loot == 28 then
            --  НАБОР ПНВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBleachBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_PNV", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 29 then
            -- НАБОР СОКРОВИЩА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
        end
    else
        player:getInventory():AddItem("NHM.GhostQuest21");
        player:Say(getText("UI_Treasure") .. tostring(formula));
    end
end

function GhostQuest22_onCreate(items, result, player, selectedItem)
    local x = player:getX()
    local y = player:getY()
    local formula = math.floor(math.sqrt(((9286 - x) ^ 2) + (12199 - y) ^ 2))
    if formula < 5 then
        local loot = ZombRand(30)
        if loot == 0 then
            --НАБОР КОЖЕВНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_HockeyMask", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jacket_Black", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGlovesBlack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_BlackBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 1 then
            -- НАБОР СТРОИТЕЛЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NailsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hammer", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Woodglue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.GardenSaw", 1, 1, 0);
        elseif loot == 2 then
            -- НАБОР РЫБАКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingLine", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFishing1", 1, 1, 0);
        elseif loot == 3 then
            -- НАБОР АВТОМЕХАНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrewsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MechanicMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.LugWrench", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wrench", 1, 1, 0);
        elseif loot == 4 then
            -- НАБОР ПОВАРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.RollingPin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Flour", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WineWaterFull", 1, 1, 0);
        elseif loot == 5 then
            -- НАБОР ЭЛЕКТРИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Screwdriver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectronicsMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoiseTrap", 1, 1, 0);
        elseif loot == 6 then
            -- НАБОР ХИРУРГА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scalpel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JacketLong_Doctor", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
        elseif loot == 7 then
            -- НАБОР ВЫЖИВАЛЬЩИКА С ЛОМОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.Crowbar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_RidingBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shorts_CamoGreenLong", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGloves", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shirt_CamoUrban", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glasses_Sun", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BaseballCapArmy", 1, 1, 0);
        elseif loot == 8 then
            -- НАБОР МЕДИКАМЕНТОВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsAntiDep", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsBeta", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Disinfectant", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedleHolder", 1, 1, 0);
        elseif loot == 9 then
            -- НАБОР ОХОТНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Raccoon", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vest_Hunting_Grey", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AmmoStrap_Shells", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HuntingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularKnife", 1, 1, 0);
        elseif loot == 10 then
            -- НАБОР КОВБОЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Revolver1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HolsterSimple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Cowboy", 1, 1, 0);
        elseif loot == 11 then
            -- НАБОР ЛВК
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
        elseif loot == 12 then
            -- НАБОР КОНСЕРВЫ
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedSardines", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPotato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPineapple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBolognese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TunaTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPeas", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedTomato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCornedBeef", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCorn", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedChili", 1, 1, 0);
        elseif loot == 13 then
            -- НАБОР СБИТЫЙ ПИЛОТ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolB1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolMag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bag_Satchel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Boilersuit_Flying", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_SPHhelmet", 1, 1, 0);
        elseif loot == 14 then
            -- НАБОР ДРОЧКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Underpants_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bra_Strapless_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BunnyEarsWhite", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Choker", 1, 1, 0);
        elseif loot == 15 then
            -- НАБОР ДЛЯ КОНСЕРВИРОВАНИЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BoxOfJars", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Pan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.OilVegetable", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wine2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
        elseif loot == 16 then
            -- НАБОР АЛКАША
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 17 then
            -- АПТЕКАРСКИЙ НАБОР
            player:getCurrentSquare():AddWorldInventoryItem("NHM.AntizinTier3", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.VirusTester", 1, 1, 0);
        elseif loot == 18 then
            -- ДЖЕНЕРИК НАБОР 1
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HandTorch", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 19 then
            -- НАБОР САМУРАЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularSword", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
        elseif loot == 20 then
            -- НАБОР БРОНЯ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Hat_BoneHelmet", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.BoneLegPads", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeHelbard", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeBigHammer", 1, 1, 0);
        elseif loot == 21 then
            --ДЖЕНЕРИК НАБОР 2
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBellPepper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsVitamins", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 22 then
            -- НАБОР ШАХТЕРА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotBronze", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 23 then
            -- НАБОР СТАЛКЕРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
        elseif loot == 24 then
            -- НАБОР ДОБЫТЧИКА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Kotomka", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Macandcheese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 25 then
            -- НАБОР БАЗОВЫХ РЕСУРСОВ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scotchtape", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
        elseif loot == 26 then
            -- НАБОР МЕТАЛЛОЛОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
        elseif loot == 27 then
            -- ДЖЕНЕРИК НАБОР 3
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
        elseif loot == 28 then
            --  НАБОР ПНВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBleachBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_PNV", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 29 then
            -- НАБОР СОКРОВИЩА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
        end
    else
        player:getInventory():AddItem("NHM.GhostQuest22");
        player:Say(getText("UI_Treasure") .. tostring(formula));
    end
end

function GhostQuest23_onCreate(items, result, player, selectedItem)
    local x = player:getX()
    local y = player:getY()
    local formula = math.floor(math.sqrt(((9501 - x) ^ 2) + (10362 - y) ^ 2))
    if formula < 5 then
        local loot = ZombRand(30)
        if loot == 0 then
            --НАБОР КОЖЕВНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_HockeyMask", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jacket_Black", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGlovesBlack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_BlackBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 1 then
            -- НАБОР СТРОИТЕЛЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NailsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hammer", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Woodglue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.GardenSaw", 1, 1, 0);
        elseif loot == 2 then
            -- НАБОР РЫБАКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingLine", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFishing1", 1, 1, 0);
        elseif loot == 3 then
            -- НАБОР АВТОМЕХАНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrewsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MechanicMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.LugWrench", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wrench", 1, 1, 0);
        elseif loot == 4 then
            -- НАБОР ПОВАРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.RollingPin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Flour", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WineWaterFull", 1, 1, 0);
        elseif loot == 5 then
            -- НАБОР ЭЛЕКТРИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Screwdriver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectronicsMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoiseTrap", 1, 1, 0);
        elseif loot == 6 then
            -- НАБОР ХИРУРГА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scalpel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JacketLong_Doctor", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
        elseif loot == 7 then
            -- НАБОР ВЫЖИВАЛЬЩИКА С ЛОМОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.Crowbar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_RidingBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shorts_CamoGreenLong", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGloves", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shirt_CamoUrban", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glasses_Sun", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BaseballCapArmy", 1, 1, 0);
        elseif loot == 8 then
            -- НАБОР МЕДИКАМЕНТОВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsAntiDep", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsBeta", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Disinfectant", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedleHolder", 1, 1, 0);
        elseif loot == 9 then
            -- НАБОР ОХОТНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Raccoon", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vest_Hunting_Grey", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AmmoStrap_Shells", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HuntingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularKnife", 1, 1, 0);
        elseif loot == 10 then
            -- НАБОР КОВБОЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Revolver1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HolsterSimple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Cowboy", 1, 1, 0);
        elseif loot == 11 then
            -- НАБОР ЛВК
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
        elseif loot == 12 then
            -- НАБОР КОНСЕРВЫ
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedSardines", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPotato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPineapple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBolognese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TunaTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPeas", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedTomato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCornedBeef", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCorn", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedChili", 1, 1, 0);
        elseif loot == 13 then
            -- НАБОР СБИТЫЙ ПИЛОТ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolB1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolMag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bag_Satchel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Boilersuit_Flying", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_SPHhelmet", 1, 1, 0);
        elseif loot == 14 then
            -- НАБОР ДРОЧКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Underpants_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bra_Strapless_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BunnyEarsWhite", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Choker", 1, 1, 0);
        elseif loot == 15 then
            -- НАБОР ДЛЯ КОНСЕРВИРОВАНИЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BoxOfJars", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Pan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.OilVegetable", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wine2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
        elseif loot == 16 then
            -- НАБОР АЛКАША
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 17 then
            -- АПТЕКАРСКИЙ НАБОР
            player:getCurrentSquare():AddWorldInventoryItem("NHM.AntizinTier3", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.VirusTester", 1, 1, 0);
        elseif loot == 18 then
            -- ДЖЕНЕРИК НАБОР 1
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HandTorch", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 19 then
            -- НАБОР САМУРАЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularSword", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
        elseif loot == 20 then
            -- НАБОР БРОНЯ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Hat_BoneHelmet", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.BoneLegPads", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeHelbard", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeBigHammer", 1, 1, 0);
        elseif loot == 21 then
            --ДЖЕНЕРИК НАБОР 2
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBellPepper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsVitamins", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 22 then
            -- НАБОР ШАХТЕРА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotBronze", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 23 then
            -- НАБОР СТАЛКЕРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
        elseif loot == 24 then
            -- НАБОР ДОБЫТЧИКА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Kotomka", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Macandcheese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 25 then
            -- НАБОР БАЗОВЫХ РЕСУРСОВ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scotchtape", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
        elseif loot == 26 then
            -- НАБОР МЕТАЛЛОЛОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
        elseif loot == 27 then
            -- ДЖЕНЕРИК НАБОР 3
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
        elseif loot == 28 then
            --  НАБОР ПНВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBleachBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_PNV", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 29 then
            -- НАБОР СОКРОВИЩА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
        end
    else
        player:getInventory():AddItem("NHM.GhostQuest23");
        player:Say(getText("UI_Treasure") .. tostring(formula));
    end
end

function GhostQuest24_onCreate(items, result, player, selectedItem)
    local x = player:getX()
    local y = player:getY()
    local formula = math.floor(math.sqrt(((11845 - x) ^ 2) + (6642 - y) ^ 2))
    if formula < 5 then
        local loot = ZombRand(30)
        if loot == 0 then
            --НАБОР КОЖЕВНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_HockeyMask", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jacket_Black", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGlovesBlack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_BlackBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 1 then
            -- НАБОР СТРОИТЕЛЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NailsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hammer", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Woodglue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.GardenSaw", 1, 1, 0);
        elseif loot == 2 then
            -- НАБОР РЫБАКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingLine", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFishing1", 1, 1, 0);
        elseif loot == 3 then
            -- НАБОР АВТОМЕХАНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrewsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MechanicMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.LugWrench", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wrench", 1, 1, 0);
        elseif loot == 4 then
            -- НАБОР ПОВАРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.RollingPin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Flour", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WineWaterFull", 1, 1, 0);
        elseif loot == 5 then
            -- НАБОР ЭЛЕКТРИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Screwdriver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectronicsMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoiseTrap", 1, 1, 0);
        elseif loot == 6 then
            -- НАБОР ХИРУРГА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scalpel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JacketLong_Doctor", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
        elseif loot == 7 then
            -- НАБОР ВЫЖИВАЛЬЩИКА С ЛОМОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.Crowbar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_RidingBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shorts_CamoGreenLong", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGloves", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shirt_CamoUrban", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glasses_Sun", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BaseballCapArmy", 1, 1, 0);
        elseif loot == 8 then
            -- НАБОР МЕДИКАМЕНТОВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsAntiDep", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsBeta", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Disinfectant", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedleHolder", 1, 1, 0);
        elseif loot == 9 then
            -- НАБОР ОХОТНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Raccoon", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vest_Hunting_Grey", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AmmoStrap_Shells", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HuntingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularKnife", 1, 1, 0);
        elseif loot == 10 then
            -- НАБОР КОВБОЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Revolver1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HolsterSimple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Cowboy", 1, 1, 0);
        elseif loot == 11 then
            -- НАБОР ЛВК
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
        elseif loot == 12 then
            -- НАБОР КОНСЕРВЫ
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedSardines", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPotato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPineapple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBolognese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TunaTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPeas", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedTomato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCornedBeef", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCorn", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedChili", 1, 1, 0);
        elseif loot == 13 then
            -- НАБОР СБИТЫЙ ПИЛОТ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolB1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolMag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bag_Satchel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Boilersuit_Flying", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_SPHhelmet", 1, 1, 0);
        elseif loot == 14 then
            -- НАБОР ДРОЧКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Underpants_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bra_Strapless_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BunnyEarsWhite", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Choker", 1, 1, 0);
        elseif loot == 15 then
            -- НАБОР ДЛЯ КОНСЕРВИРОВАНИЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BoxOfJars", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Pan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.OilVegetable", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wine2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
        elseif loot == 16 then
            -- НАБОР АЛКАША
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 17 then
            -- АПТЕКАРСКИЙ НАБОР
            player:getCurrentSquare():AddWorldInventoryItem("NHM.AntizinTier3", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.VirusTester", 1, 1, 0);
        elseif loot == 18 then
            -- ДЖЕНЕРИК НАБОР 1
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HandTorch", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 19 then
            -- НАБОР САМУРАЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularSword", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
        elseif loot == 20 then
            -- НАБОР БРОНЯ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Hat_BoneHelmet", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.BoneLegPads", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeHelbard", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeBigHammer", 1, 1, 0);
        elseif loot == 21 then
            --ДЖЕНЕРИК НАБОР 2
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBellPepper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsVitamins", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 22 then
            -- НАБОР ШАХТЕРА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotBronze", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 23 then
            -- НАБОР СТАЛКЕРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
        elseif loot == 24 then
            -- НАБОР ДОБЫТЧИКА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Kotomka", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Macandcheese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 25 then
            -- НАБОР БАЗОВЫХ РЕСУРСОВ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scotchtape", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
        elseif loot == 26 then
            -- НАБОР МЕТАЛЛОЛОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
        elseif loot == 27 then
            -- ДЖЕНЕРИК НАБОР 3
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
        elseif loot == 28 then
            --  НАБОР ПНВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBleachBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_PNV", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 29 then
            -- НАБОР СОКРОВИЩА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
        end
    else
        player:getInventory():AddItem("NHM.GhostQuest24");
        player:Say(getText("UI_Treasure") .. tostring(formula));
    end
end

function GhostQuest25_onCreate(items, result, player, selectedItem)
    local x = player:getX()
    local y = player:getY()
    local formula = math.floor(math.sqrt(((8342 - x) ^ 2) + (11348 - y) ^ 2))
    if formula < 5 then
        local loot = ZombRand(30)
        if loot == 0 then
            --НАБОР КОЖЕВНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_HockeyMask", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jacket_Black", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGlovesBlack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_BlackBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 1 then
            -- НАБОР СТРОИТЕЛЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NailsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hammer", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Woodglue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.GardenSaw", 1, 1, 0);
        elseif loot == 2 then
            -- НАБОР РЫБАКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingLine", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFishing1", 1, 1, 0);
        elseif loot == 3 then
            -- НАБОР АВТОМЕХАНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrewsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MechanicMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.LugWrench", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wrench", 1, 1, 0);
        elseif loot == 4 then
            -- НАБОР ПОВАРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.RollingPin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Flour", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WineWaterFull", 1, 1, 0);
        elseif loot == 5 then
            -- НАБОР ЭЛЕКТРИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Screwdriver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectronicsMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoiseTrap", 1, 1, 0);
        elseif loot == 6 then
            -- НАБОР ХИРУРГА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scalpel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JacketLong_Doctor", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
        elseif loot == 7 then
            -- НАБОР ВЫЖИВАЛЬЩИКА С ЛОМОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.Crowbar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_RidingBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shorts_CamoGreenLong", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGloves", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shirt_CamoUrban", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glasses_Sun", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BaseballCapArmy", 1, 1, 0);
        elseif loot == 8 then
            -- НАБОР МЕДИКАМЕНТОВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsAntiDep", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsBeta", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Disinfectant", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedleHolder", 1, 1, 0);
        elseif loot == 9 then
            -- НАБОР ОХОТНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Raccoon", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vest_Hunting_Grey", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AmmoStrap_Shells", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HuntingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularKnife", 1, 1, 0);
        elseif loot == 10 then
            -- НАБОР КОВБОЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Revolver1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HolsterSimple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Cowboy", 1, 1, 0);
        elseif loot == 11 then
            -- НАБОР ЛВК
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
        elseif loot == 12 then
            -- НАБОР КОНСЕРВЫ
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedSardines", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPotato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPineapple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBolognese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TunaTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPeas", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedTomato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCornedBeef", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCorn", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedChili", 1, 1, 0);
        elseif loot == 13 then
            -- НАБОР СБИТЫЙ ПИЛОТ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolB1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolMag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bag_Satchel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Boilersuit_Flying", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_SPHhelmet", 1, 1, 0);
        elseif loot == 14 then
            -- НАБОР ДРОЧКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Underpants_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bra_Strapless_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BunnyEarsWhite", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Choker", 1, 1, 0);
        elseif loot == 15 then
            -- НАБОР ДЛЯ КОНСЕРВИРОВАНИЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BoxOfJars", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Pan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.OilVegetable", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wine2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
        elseif loot == 16 then
            -- НАБОР АЛКАША
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 17 then
            -- АПТЕКАРСКИЙ НАБОР
            player:getCurrentSquare():AddWorldInventoryItem("NHM.AntizinTier3", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.VirusTester", 1, 1, 0);
        elseif loot == 18 then
            -- ДЖЕНЕРИК НАБОР 1
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HandTorch", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 19 then
            -- НАБОР САМУРАЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularSword", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
        elseif loot == 20 then
            -- НАБОР БРОНЯ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Hat_BoneHelmet", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.BoneLegPads", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeHelbard", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeBigHammer", 1, 1, 0);
        elseif loot == 21 then
            --ДЖЕНЕРИК НАБОР 2
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBellPepper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsVitamins", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 22 then
            -- НАБОР ШАХТЕРА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotBronze", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 23 then
            -- НАБОР СТАЛКЕРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
        elseif loot == 24 then
            -- НАБОР ДОБЫТЧИКА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Kotomka", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Macandcheese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 25 then
            -- НАБОР БАЗОВЫХ РЕСУРСОВ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scotchtape", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
        elseif loot == 26 then
            -- НАБОР МЕТАЛЛОЛОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
        elseif loot == 27 then
            -- ДЖЕНЕРИК НАБОР 3
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
        elseif loot == 28 then
            --  НАБОР ПНВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBleachBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_PNV", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 29 then
            -- НАБОР СОКРОВИЩА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
        end
    else
        player:getInventory():AddItem("NHM.GhostQuest25");
        player:Say(getText("UI_Treasure") .. tostring(formula));
    end
end

function GhostQuest26_onCreate(items, result, player, selectedItem)
    local x = player:getX()
    local y = player:getY()
    local formula = math.floor(math.sqrt(((10532 - x) ^ 2) + (11318 - y) ^ 2))
    if formula < 5 then
        local loot = ZombRand(30)
        if loot == 0 then
            --НАБОР КОЖЕВНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_HockeyMask", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jacket_Black", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGlovesBlack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_BlackBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 1 then
            -- НАБОР СТРОИТЕЛЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NailsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hammer", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Woodglue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.GardenSaw", 1, 1, 0);
        elseif loot == 2 then
            -- НАБОР РЫБАКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingLine", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFishing1", 1, 1, 0);
        elseif loot == 3 then
            -- НАБОР АВТОМЕХАНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrewsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MechanicMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.LugWrench", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wrench", 1, 1, 0);
        elseif loot == 4 then
            -- НАБОР ПОВАРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.RollingPin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Flour", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WineWaterFull", 1, 1, 0);
        elseif loot == 5 then
            -- НАБОР ЭЛЕКТРИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Screwdriver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectronicsMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoiseTrap", 1, 1, 0);
        elseif loot == 6 then
            -- НАБОР ХИРУРГА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scalpel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JacketLong_Doctor", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
        elseif loot == 7 then
            -- НАБОР ВЫЖИВАЛЬЩИКА С ЛОМОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.Crowbar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_RidingBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shorts_CamoGreenLong", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGloves", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shirt_CamoUrban", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glasses_Sun", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BaseballCapArmy", 1, 1, 0);
        elseif loot == 8 then
            -- НАБОР МЕДИКАМЕНТОВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsAntiDep", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsBeta", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Disinfectant", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedleHolder", 1, 1, 0);
        elseif loot == 9 then
            -- НАБОР ОХОТНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Raccoon", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vest_Hunting_Grey", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AmmoStrap_Shells", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HuntingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularKnife", 1, 1, 0);
        elseif loot == 10 then
            -- НАБОР КОВБОЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Revolver1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HolsterSimple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Cowboy", 1, 1, 0);
        elseif loot == 11 then
            -- НАБОР ЛВК
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
        elseif loot == 12 then
            -- НАБОР КОНСЕРВЫ
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedSardines", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPotato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPineapple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBolognese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TunaTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPeas", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedTomato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCornedBeef", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCorn", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedChili", 1, 1, 0);
        elseif loot == 13 then
            -- НАБОР СБИТЫЙ ПИЛОТ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolB1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolMag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bag_Satchel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Boilersuit_Flying", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_SPHhelmet", 1, 1, 0);
        elseif loot == 14 then
            -- НАБОР ДРОЧКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Underpants_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bra_Strapless_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BunnyEarsWhite", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Choker", 1, 1, 0);
        elseif loot == 15 then
            -- НАБОР ДЛЯ КОНСЕРВИРОВАНИЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BoxOfJars", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Pan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.OilVegetable", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wine2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
        elseif loot == 16 then
            -- НАБОР АЛКАША
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 17 then
            -- АПТЕКАРСКИЙ НАБОР
            player:getCurrentSquare():AddWorldInventoryItem("NHM.AntizinTier3", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.VirusTester", 1, 1, 0);
        elseif loot == 18 then
            -- ДЖЕНЕРИК НАБОР 1
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HandTorch", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 19 then
            -- НАБОР САМУРАЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularSword", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
        elseif loot == 20 then
            -- НАБОР БРОНЯ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Hat_BoneHelmet", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.BoneLegPads", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeHelbard", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeBigHammer", 1, 1, 0);
        elseif loot == 21 then
            --ДЖЕНЕРИК НАБОР 2
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBellPepper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsVitamins", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 22 then
            -- НАБОР ШАХТЕРА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotBronze", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 23 then
            -- НАБОР СТАЛКЕРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
        elseif loot == 24 then
            -- НАБОР ДОБЫТЧИКА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Kotomka", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Macandcheese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 25 then
            -- НАБОР БАЗОВЫХ РЕСУРСОВ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scotchtape", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
        elseif loot == 26 then
            -- НАБОР МЕТАЛЛОЛОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
        elseif loot == 27 then
            -- ДЖЕНЕРИК НАБОР 3
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
        elseif loot == 28 then
            --  НАБОР ПНВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBleachBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_PNV", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 29 then
            -- НАБОР СОКРОВИЩА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
        end
    else
        player:getInventory():AddItem("NHM.GhostQuest26");
        player:Say(getText("UI_Treasure") .. tostring(formula));
    end
end

function GhostQuest27_onCreate(items, result, player, selectedItem)
    local x = player:getX()
    local y = player:getY()
    local formula = math.floor(math.sqrt(((12429 - x) ^ 2) + (8924 - y) ^ 2))
    if formula < 5 then
        local loot = ZombRand(30)
        if loot == 0 then
            --НАБОР КОЖЕВНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_HockeyMask", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jacket_Black", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGlovesBlack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_BlackBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 1 then
            -- НАБОР СТРОИТЕЛЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NailsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hammer", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Woodglue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.GardenSaw", 1, 1, 0);
        elseif loot == 2 then
            -- НАБОР РЫБАКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingLine", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFishing1", 1, 1, 0);
        elseif loot == 3 then
            -- НАБОР АВТОМЕХАНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrewsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MechanicMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.LugWrench", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wrench", 1, 1, 0);
        elseif loot == 4 then
            -- НАБОР ПОВАРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.RollingPin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Flour", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WineWaterFull", 1, 1, 0);
        elseif loot == 5 then
            -- НАБОР ЭЛЕКТРИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Screwdriver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectronicsMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoiseTrap", 1, 1, 0);
        elseif loot == 6 then
            -- НАБОР ХИРУРГА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scalpel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JacketLong_Doctor", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
        elseif loot == 7 then
            -- НАБОР ВЫЖИВАЛЬЩИКА С ЛОМОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.Crowbar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_RidingBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shorts_CamoGreenLong", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGloves", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shirt_CamoUrban", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glasses_Sun", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BaseballCapArmy", 1, 1, 0);
        elseif loot == 8 then
            -- НАБОР МЕДИКАМЕНТОВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsAntiDep", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsBeta", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Disinfectant", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedleHolder", 1, 1, 0);
        elseif loot == 9 then
            -- НАБОР ОХОТНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Raccoon", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vest_Hunting_Grey", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AmmoStrap_Shells", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HuntingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularKnife", 1, 1, 0);
        elseif loot == 10 then
            -- НАБОР КОВБОЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Revolver1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HolsterSimple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Cowboy", 1, 1, 0);
        elseif loot == 11 then
            -- НАБОР ЛВК
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
        elseif loot == 12 then
            -- НАБОР КОНСЕРВЫ
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedSardines", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPotato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPineapple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBolognese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TunaTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPeas", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedTomato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCornedBeef", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCorn", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedChili", 1, 1, 0);
        elseif loot == 13 then
            -- НАБОР СБИТЫЙ ПИЛОТ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolB1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolMag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bag_Satchel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Boilersuit_Flying", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_SPHhelmet", 1, 1, 0);
        elseif loot == 14 then
            -- НАБОР ДРОЧКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Underpants_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bra_Strapless_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BunnyEarsWhite", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Choker", 1, 1, 0);
        elseif loot == 15 then
            -- НАБОР ДЛЯ КОНСЕРВИРОВАНИЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BoxOfJars", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Pan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.OilVegetable", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wine2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
        elseif loot == 16 then
            -- НАБОР АЛКАША
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 17 then
            -- АПТЕКАРСКИЙ НАБОР
            player:getCurrentSquare():AddWorldInventoryItem("NHM.AntizinTier3", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.VirusTester", 1, 1, 0);
        elseif loot == 18 then
            -- ДЖЕНЕРИК НАБОР 1
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HandTorch", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 19 then
            -- НАБОР САМУРАЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularSword", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
        elseif loot == 20 then
            -- НАБОР БРОНЯ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Hat_BoneHelmet", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.BoneLegPads", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeHelbard", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeBigHammer", 1, 1, 0);
        elseif loot == 21 then
            --ДЖЕНЕРИК НАБОР 2
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBellPepper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsVitamins", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 22 then
            -- НАБОР ШАХТЕРА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotBronze", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 23 then
            -- НАБОР СТАЛКЕРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
        elseif loot == 24 then
            -- НАБОР ДОБЫТЧИКА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Kotomka", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Macandcheese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 25 then
            -- НАБОР БАЗОВЫХ РЕСУРСОВ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scotchtape", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
        elseif loot == 26 then
            -- НАБОР МЕТАЛЛОЛОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
        elseif loot == 27 then
            -- ДЖЕНЕРИК НАБОР 3
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
        elseif loot == 28 then
            --  НАБОР ПНВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBleachBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_PNV", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 29 then
            -- НАБОР СОКРОВИЩА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
        end
    else
        player:getInventory():AddItem("NHM.GhostQuest27");
        player:Say(getText("UI_Treasure") .. tostring(formula));
    end
end

function GhostQuest28_onCreate(items, result, player, selectedItem)
    local x = player:getX()
    local y = player:getY()
    local formula = math.floor(math.sqrt(((6348 - x) ^ 2) + (10542 - y) ^ 2))
    if formula < 5 then
        local loot = ZombRand(30)
        if loot == 0 then
            --НАБОР КОЖЕВНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_HockeyMask", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jacket_Black", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGlovesBlack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_BlackBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 1 then
            -- НАБОР СТРОИТЕЛЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NailsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hammer", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Woodglue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.GardenSaw", 1, 1, 0);
        elseif loot == 2 then
            -- НАБОР РЫБАКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingLine", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFishing1", 1, 1, 0);
        elseif loot == 3 then
            -- НАБОР АВТОМЕХАНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrewsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MechanicMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.LugWrench", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wrench", 1, 1, 0);
        elseif loot == 4 then
            -- НАБОР ПОВАРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.RollingPin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Flour", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WineWaterFull", 1, 1, 0);
        elseif loot == 5 then
            -- НАБОР ЭЛЕКТРИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Screwdriver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectronicsMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoiseTrap", 1, 1, 0);
        elseif loot == 6 then
            -- НАБОР ХИРУРГА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scalpel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JacketLong_Doctor", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
        elseif loot == 7 then
            -- НАБОР ВЫЖИВАЛЬЩИКА С ЛОМОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.Crowbar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_RidingBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shorts_CamoGreenLong", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGloves", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shirt_CamoUrban", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glasses_Sun", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BaseballCapArmy", 1, 1, 0);
        elseif loot == 8 then
            -- НАБОР МЕДИКАМЕНТОВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsAntiDep", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsBeta", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Disinfectant", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedleHolder", 1, 1, 0);
        elseif loot == 9 then
            -- НАБОР ОХОТНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Raccoon", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vest_Hunting_Grey", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AmmoStrap_Shells", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HuntingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularKnife", 1, 1, 0);
        elseif loot == 10 then
            -- НАБОР КОВБОЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Revolver1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HolsterSimple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Cowboy", 1, 1, 0);
        elseif loot == 11 then
            -- НАБОР ЛВК
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
        elseif loot == 12 then
            -- НАБОР КОНСЕРВЫ
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedSardines", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPotato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPineapple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBolognese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TunaTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPeas", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedTomato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCornedBeef", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCorn", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedChili", 1, 1, 0);
        elseif loot == 13 then
            -- НАБОР СБИТЫЙ ПИЛОТ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolB1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolMag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bag_Satchel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Boilersuit_Flying", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_SPHhelmet", 1, 1, 0);
        elseif loot == 14 then
            -- НАБОР ДРОЧКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Underpants_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bra_Strapless_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BunnyEarsWhite", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Choker", 1, 1, 0);
        elseif loot == 15 then
            -- НАБОР ДЛЯ КОНСЕРВИРОВАНИЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BoxOfJars", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Pan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.OilVegetable", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wine2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
        elseif loot == 16 then
            -- НАБОР АЛКАША
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 17 then
            -- АПТЕКАРСКИЙ НАБОР
            player:getCurrentSquare():AddWorldInventoryItem("NHM.AntizinTier3", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.VirusTester", 1, 1, 0);
        elseif loot == 18 then
            -- ДЖЕНЕРИК НАБОР 1
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HandTorch", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 19 then
            -- НАБОР САМУРАЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularSword", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
        elseif loot == 20 then
            -- НАБОР БРОНЯ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Hat_BoneHelmet", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.BoneLegPads", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeHelbard", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeBigHammer", 1, 1, 0);
        elseif loot == 21 then
            --ДЖЕНЕРИК НАБОР 2
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBellPepper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsVitamins", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 22 then
            -- НАБОР ШАХТЕРА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotBronze", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 23 then
            -- НАБОР СТАЛКЕРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
        elseif loot == 24 then
            -- НАБОР ДОБЫТЧИКА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Kotomka", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Macandcheese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 25 then
            -- НАБОР БАЗОВЫХ РЕСУРСОВ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scotchtape", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
        elseif loot == 26 then
            -- НАБОР МЕТАЛЛОЛОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
        elseif loot == 27 then
            -- ДЖЕНЕРИК НАБОР 3
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
        elseif loot == 28 then
            --  НАБОР ПНВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBleachBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_PNV", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 29 then
            -- НАБОР СОКРОВИЩА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
        end
    else
        player:getInventory():AddItem("NHM.GhostQuest28");
        player:Say(getText("UI_Treasure") .. tostring(formula));
    end
end

function GhostQuest29_onCreate(items, result, player, selectedItem)
    local x = player:getX()
    local y = player:getY()
    local formula = math.floor(math.sqrt(((8648 - x) ^ 2) + (9644 - y) ^ 2))
    if formula < 5 then
        local loot = ZombRand(30)
        if loot == 0 then
            --НАБОР КОЖЕВНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_HockeyMask", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jacket_Black", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGlovesBlack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_BlackBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 1 then
            -- НАБОР СТРОИТЕЛЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NailsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hammer", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Woodglue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.GardenSaw", 1, 1, 0);
        elseif loot == 2 then
            -- НАБОР РЫБАКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingLine", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFishing1", 1, 1, 0);
        elseif loot == 3 then
            -- НАБОР АВТОМЕХАНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrewsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MechanicMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.LugWrench", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wrench", 1, 1, 0);
        elseif loot == 4 then
            -- НАБОР ПОВАРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.RollingPin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Flour", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WineWaterFull", 1, 1, 0);
        elseif loot == 5 then
            -- НАБОР ЭЛЕКТРИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Screwdriver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectronicsMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoiseTrap", 1, 1, 0);
        elseif loot == 6 then
            -- НАБОР ХИРУРГА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scalpel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JacketLong_Doctor", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
        elseif loot == 7 then
            -- НАБОР ВЫЖИВАЛЬЩИКА С ЛОМОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.Crowbar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_RidingBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shorts_CamoGreenLong", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGloves", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shirt_CamoUrban", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glasses_Sun", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BaseballCapArmy", 1, 1, 0);
        elseif loot == 8 then
            -- НАБОР МЕДИКАМЕНТОВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsAntiDep", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsBeta", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Disinfectant", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedleHolder", 1, 1, 0);
        elseif loot == 9 then
            -- НАБОР ОХОТНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Raccoon", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vest_Hunting_Grey", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AmmoStrap_Shells", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HuntingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularKnife", 1, 1, 0);
        elseif loot == 10 then
            -- НАБОР КОВБОЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Revolver1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HolsterSimple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Cowboy", 1, 1, 0);
        elseif loot == 11 then
            -- НАБОР ЛВК
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
        elseif loot == 12 then
            -- НАБОР КОНСЕРВЫ
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedSardines", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPotato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPineapple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBolognese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TunaTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPeas", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedTomato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCornedBeef", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCorn", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedChili", 1, 1, 0);
        elseif loot == 13 then
            -- НАБОР СБИТЫЙ ПИЛОТ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolB1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolMag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bag_Satchel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Boilersuit_Flying", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_SPHhelmet", 1, 1, 0);
        elseif loot == 14 then
            -- НАБОР ДРОЧКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Underpants_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bra_Strapless_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BunnyEarsWhite", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Choker", 1, 1, 0);
        elseif loot == 15 then
            -- НАБОР ДЛЯ КОНСЕРВИРОВАНИЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BoxOfJars", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Pan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.OilVegetable", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wine2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
        elseif loot == 16 then
            -- НАБОР АЛКАША
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 17 then
            -- АПТЕКАРСКИЙ НАБОР
            player:getCurrentSquare():AddWorldInventoryItem("NHM.AntizinTier3", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.VirusTester", 1, 1, 0);
        elseif loot == 18 then
            -- ДЖЕНЕРИК НАБОР 1
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HandTorch", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 19 then
            -- НАБОР САМУРАЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularSword", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
        elseif loot == 20 then
            -- НАБОР БРОНЯ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Hat_BoneHelmet", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.BoneLegPads", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeHelbard", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeBigHammer", 1, 1, 0);
        elseif loot == 21 then
            --ДЖЕНЕРИК НАБОР 2
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBellPepper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsVitamins", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 22 then
            -- НАБОР ШАХТЕРА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotBronze", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 23 then
            -- НАБОР СТАЛКЕРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
        elseif loot == 24 then
            -- НАБОР ДОБЫТЧИКА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Kotomka", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Macandcheese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 25 then
            -- НАБОР БАЗОВЫХ РЕСУРСОВ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scotchtape", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
        elseif loot == 26 then
            -- НАБОР МЕТАЛЛОЛОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
        elseif loot == 27 then
            -- ДЖЕНЕРИК НАБОР 3
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
        elseif loot == 28 then
            --  НАБОР ПНВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBleachBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_PNV", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 29 then
            -- НАБОР СОКРОВИЩА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
        end
    else
        player:getInventory():AddItem("NHM.GhostQuest29");
        player:Say(getText("UI_Treasure") .. tostring(formula));
    end
end

function GhostQuest30_onCreate(items, result, player, selectedItem)
    local x = player:getX()
    local y = player:getY()
    local formula = math.floor(math.sqrt(((10956 - x) ^ 2) + (9941 - y) ^ 2))
    if formula < 5 then
        local loot = ZombRand(30)
        if loot == 0 then
            --НАБОР КОЖЕВНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_HockeyMask", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jacket_Black", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGlovesBlack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_BlackBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 1 then
            -- НАБОР СТРОИТЕЛЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookCarpentry2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NailsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hammer", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Woodglue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.GardenSaw", 1, 1, 0);
        elseif loot == 2 then
            -- НАБОР РЫБАКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingTackle2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingLine", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFishing1", 1, 1, 0);
        elseif loot == 3 then
            -- НАБОР АВТОМЕХАНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.EngineParts", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrewsBox", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MechanicMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.LugWrench", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Jack", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wrench", 1, 1, 0);
        elseif loot == 4 then
            -- НАБОР ПОВАРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.RollingPin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CookingMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Flour", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeefJerky", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WineWaterFull", 1, 1, 0);
        elseif loot == 5 then
            -- НАБОР ЭЛЕКТРИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Screwdriver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookElectrician2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectronicsMag2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ElectricWire", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoiseTrap", 1, 1, 0);
        elseif loot == 6 then
            -- НАБОР ХИРУРГА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scalpel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JacketLong_Doctor", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BookFirstAid2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AlcoholWipes", 1, 1, 0);
        elseif loot == 7 then
            -- НАБОР ВЫЖИВАЛЬЩИКА С ЛОМОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.Crowbar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shoes_RidingBoots", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shorts_CamoGreenLong", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Gloves_LeatherGloves", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Shirt_CamoUrban", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glasses_Sun", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BaseballCapArmy", 1, 1, 0);
        elseif loot == 8 then
            -- НАБОР МЕДИКАМЕНТОВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsAntiDep", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tweezers", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsBeta", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Disinfectant", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SutureNeedleHolder", 1, 1, 0);
        elseif loot == 9 then
            -- НАБОР ОХОТНИКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Raccoon", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vest_Hunting_Grey", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.AmmoStrap_Shells", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HuntingMag1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularKnife", 1, 1, 0);
        elseif loot == 10 then
            -- НАБОР КОВБОЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Revolver1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HolsterSimple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Cowboy", 1, 1, 0);
        elseif loot == 11 then
            -- НАБОР ЛВК
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Dogfood", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
        elseif loot == 12 then
            -- НАБОР КОНСЕРВЫ
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinOpener", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedSardines", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPotato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPineapple", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBolognese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TunaTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedPeas", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedTomato2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCornedBeef", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedCorn", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedChili", 1, 1, 0);
        elseif loot == 13 then
            -- НАБОР СБИТЫЙ ПИЛОТ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolB1", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.PistolMag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bag_Satchel", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Boilersuit_Flying", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_SPHhelmet", 1, 1, 0);
        elseif loot == 14 then
            -- НАБОР ДРОЧКА
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HottieZ", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ComicBook", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Tissue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Underpants_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bra_Strapless_AnimalPrint", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_BunnyEarsWhite", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Choker", 1, 1, 0);
        elseif loot == 15 then
            -- НАБОР ДЛЯ КОНСЕРВИРОВАНИЯ
            player:getCurrentSquare():AddWorldInventoryItem("Base.BoxOfJars", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.JarLid", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Pan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Salt", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.OilVegetable", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Wine2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Vinegar", 1, 1, 0);
        elseif loot == 16 then
            -- НАБОР АЛКАША
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BeerCan", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WhiskeyFull", 1, 1, 0);
        elseif loot == 17 then
            -- АПТЕКАРСКИЙ НАБОР
            player:getCurrentSquare():AddWorldInventoryItem("NHM.AntizinTier3", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FullBloodBag", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.FlaskActiveComp", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.VirusTester", 1, 1, 0);
        elseif loot == 18 then
            -- ДЖЕНЕРИК НАБОР 1
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.HandTorch", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 19 then
            -- НАБОР САМУРАЙ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularSword", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SushiFish", 1, 1, 0);
        elseif loot == 20 then
            -- НАБОР БРОНЯ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Hat_BoneHelmet", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.BoneLegPads", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Bone", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeHelbard", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeBigHammer", 1, 1, 0);
        elseif loot == 21 then
            --ДЖЕНЕРИК НАБОР 2
            player:getCurrentSquare():AddWorldInventoryItem("Base.KitchenKnife", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.CannedBellPepper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PillsVitamins", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 22 then
            -- НАБОР ШАХТЕРА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotBronze", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotCopper", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.IngotTin", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 23 then
            -- НАБОР СТАЛКЕРА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.RegularGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
        elseif loot == 24 then
            -- НАБОР ДОБЫТЧИКА
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Kotomka", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.PickAxe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_Gasmask2", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.HandmadeGasMaskFilter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Macandcheese", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
        elseif loot == 25 then
            -- НАБОР БАЗОВЫХ РЕСУРСОВ
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.Plastic", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Rope", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Glue", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Scotchtape", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("NHM.SiliconOre", 1, 1, 0);
        elseif loot == 26 then
            -- НАБОР МЕТАЛЛОЛОМ
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.ScrapMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.SheetMetal", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Nails", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.MetalPipe", 1, 1, 0);
        elseif loot == 27 then
            -- ДЖЕНЕРИК НАБОР 3
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBottleFull", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.BaseballBat", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.FishingRod", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.TinnedBeans", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bandage", 1, 1, 0);
        elseif loot == 28 then
            --  НАБОР ПНВ
            player:getCurrentSquare():AddWorldInventoryItem("Base.WaterBleachBottle", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Hat_PNV", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Battery", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Lighter", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.StackCigarettes", 1, 1, 0);
        elseif loot == 29 then
            -- НАБОР СОКРОВИЩА
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Earring_LoopMed_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NoseRing_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Necklace_Silver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.NecklaceLong_Gold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightGold", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Bracelet_BangleRightSilver", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_GoldRuby", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
            player:getCurrentSquare():AddWorldInventoryItem("Base.Ring_Right_MiddleFinger_SilverDiamond", 1, 1, 0);
        end
    else
        player:getInventory():AddItem("NHM.GhostQuest30");
        player:Say(getText("UI_Treasure") .. tostring(formula));
    end
end

function PotGood_IsValid (a, b, c, d)
    return a:getUnhappyChange() <= 10;
end

function NHIsMaterialValid(item)
    if item:getCategory() == "Container" then
        return item:getInventory():isEmpty()
    else
        return true
    end
end


function CheckForWalter(item)
    local playerObj = getPlayer()
    if playerObj:getUsername() == "WalterTheFox" then
        print(playerObj:getUsername())
        return true
    else
        return false
    end
end

function OpenJar(items, result, player, selectedItem)
    for i = 0, items:size() - 1 do
        if items:get(i):getType() == "CannedTomato" then
            player:getInventory():AddItems("farming.Tomato", 5);
            player:getInventory():AddItem("Base.EmptyJar");
        elseif items:get(i):getType() == "CannedCarrots" then
            player:getInventory():AddItems("Base.Carrots", 5);
            player:getInventory():AddItem("Base.EmptyJar");
        elseif items:get(i):getType() == "CannedPotato" then
            player:getInventory():AddItems("farming.Potato", 5);
            player:getInventory():AddItem("Base.EmptyJar");
        elseif items:get(i):getType() == "CannedEggplant" then
            player:getInventory():AddItems("Base.Eggplant", 5);
            player:getInventory():AddItem("Base.EmptyJar");
        elseif items:get(i):getType() == "CannedLeek" then
            player:getInventory():AddItems("Base.Leek", 5);
            player:getInventory():AddItem("Base.EmptyJar");
        elseif items:get(i):getType() == "CannedRedRadish" then
            player:getInventory():AddItems("farming.RedRadish", 5);
            player:getInventory():AddItem("Base.EmptyJar");
        elseif items:get(i):getType() == "CannedBellPepper" then
            player:getInventory():AddItems("Base.BellPepper", 5);
            player:getInventory():AddItem("Base.EmptyJar");
        elseif items:get(i):getType() == "CannedCabbage" then
            player:getInventory():AddItems("farming.Cabbage", 5);
            player:getInventory():AddItem("Base.EmptyJar");
        elseif items:get(i):getType() == "CannedBroccoli" then
            player:getInventory():AddItems("Base.Broccoli", 5);
            player:getInventory():AddItem("Base.EmptyJar");
        end
    end
end

function OpenedSackProduce(items, result, player, selectedItem)
    for i = 0, items:size() - 1 do
        if items:get(i):getType() == "SackProduce_Tomato" then
            player:getInventory():AddItems("farming.Tomato", 12);
            player:getInventory():AddItem("Base.EmptySandbag");
        elseif items:get(i):getType() == "SackProduce_Carrot" then
            player:getInventory():AddItems("Base.Carrots", 12);
            player:getInventory():AddItem("Base.EmptySandbag");
        elseif items:get(i):getType() == "SackProduce_Potato" then
            player:getInventory():AddItems("farming.Potato", 12);
            player:getInventory():AddItem("Base.EmptySandbag");
        elseif items:get(i):getType() == "SackProduce_Eggplant" then
            player:getInventory():AddItems("Base.Eggplant", 12);
            player:getInventory():AddItem("Base.EmptySandbag");
        elseif items:get(i):getType() == "SackProduce_Leek" then
            player:getInventory():AddItems("Base.Leek", 12);
            player:getInventory():AddItem("Base.EmptySandbag");
        elseif items:get(i):getType() == "SackProduce_RedRadish" then
            player:getInventory():AddItems("farming.RedRadish", 12);
            player:getInventory():AddItem("Base.EmptySandbag");
        elseif items:get(i):getType() == "SackProduce_BellPepper" then
            player:getInventory():AddItems("Base.BellPepper", 12);
            player:getInventory():AddItem("Base.EmptySandbag");
        elseif items:get(i):getType() == "SackProduce_Cabbage" then
            player:getInventory():AddItems("farming.Cabbage", 8);
            player:getInventory():AddItem("Base.EmptySandbag");
        elseif items:get(i):getType() == "SackProduce_Strawberry" then
            player:getInventory():AddItems("farming.Strewberrie", 16);
            player:getInventory():AddItem("Base.EmptySandbag");
        elseif items:get(i):getType() == "SackProduce_Pear" then
            player:getInventory():AddItems("Base.Pear", 12);
            player:getInventory():AddItem("Base.EmptySandbag");
        elseif items:get(i):getType() == "SackProduce_Peach" then
            player:getInventory():AddItems("Base.Peach", 12);
            player:getInventory():AddItem("Base.EmptySandbag");
        elseif items:get(i):getType() == "SackProduce_Onion" then
            player:getInventory():AddItems("Base.Onion", 12);
            player:getInventory():AddItem("Base.EmptySandbag");
        elseif items:get(i):getType() == "SackProduce_Lettuce" then
            player:getInventory():AddItems("Base.Lettuce", 8);
            player:getInventory():AddItem("Base.EmptySandbag");
        elseif items:get(i):getType() == "SackProduce_Grapes" then
            player:getInventory():AddItems("Base.Grapes", 12);
            player:getInventory():AddItem("Base.EmptySandbag");
        elseif items:get(i):getType() == "SackProduce_Corn" then
            player:getInventory():AddItems("Base.Corn", 12);
            player:getInventory():AddItem("Base.EmptySandbag");
        elseif items:get(i):getType() == "SackProduce_Cherry" then
            player:getInventory():AddItems("Base.Cherry", 16);
            player:getInventory():AddItem("Base.EmptySandbag");
        elseif items:get(i):getType() == "SackProduce_Broccoli" then
            player:getInventory():AddItems("Base.Broccoli", 12);
            player:getInventory():AddItem("Base.EmptySandbag");
        elseif items:get(i):getType() == "SackProduce_Apple" then
            player:getInventory():AddItems("Base.Apple", 12);
            player:getInventory():AddItem("Base.EmptySandbag");
        end
    end
end

function UnpackSandbag(items, result, player, selectedItem)
    for i = 0, items:size() - 1 do
        if items:get(i):getType() == "CopperOreSandbag" then
            player:getInventory():AddItems("NHM.CopperOre", 10);

        elseif items:get(i):getType() == "TinOreSandbag" then
            player:getInventory():AddItems("NHM.TinOre", 10);

        elseif items:get(i):getType() == "IronOreSandbag" then
            player:getInventory():AddItems("NHM.IronOre", 10);

        elseif items:get(i):getType() == "GalenaOreSandbag" then
            player:getInventory():AddItems("NHM.GalenaOre", 10);

        elseif items:get(i):getType() == "ChromiumOreSandbag" then
            player:getInventory():AddItems("NHM.ChromiumOre", 10);

        elseif items:get(i):getType() == "NickelOreSandbag" then
            player:getInventory():AddItems("NHM.NickelOre", 10);


        elseif items:get(i):getType() == "IngotCopperSandbag" then
            player:getInventory():AddItems("NHM.IngotCopper", 10);

        elseif items:get(i):getType() == "IngotTinSandbag" then
            player:getInventory():AddItems("NHM.IngotTin", 10);

        elseif items:get(i):getType() == "IngotIronSandbag" then
            player:getInventory():AddItems("NHM.IngotIron", 10);

        elseif items:get(i):getType() == "IngotLeadSandbag" then
            player:getInventory():AddItems("NHM.IngotLead", 10);

        elseif items:get(i):getType() == "IngotChromiumSandbag" then
            player:getInventory():AddItems("NHM.IngotChromium", 10);

        elseif items:get(i):getType() == "IngotNickelSandbag" then
            player:getInventory():AddItems("NHM.IngotNickel", 10);

        elseif items:get(i):getType() == "IngotBronzeSandbag" then
            player:getInventory():AddItems("NHM.IngotBronze", 10);

        elseif items:get(i):getType() == "IngotSteelSandbag" then
            player:getInventory():AddItems("NHM.IngotSteel", 10);


        elseif items:get(i):getType() == "SulfurOreSandbag" then
            player:getInventory():AddItems("NHM.SulfurOre", 30);

        elseif items:get(i):getType() == "StoneSandbag" then
            player:getInventory():AddItems("Base.Stone", 50);

        elseif items:get(i):getType() == "LimestoneSandbag" then
            player:getInventory():AddItems("NHM.Limestone", 30);

        elseif items:get(i):getType() == "CoalSandbag" then
            player:getInventory():AddItems("NHM.Coal", 50);

        elseif items:get(i):getType() == "SulfurPowderSandbag" then
            player:getInventory():AddItems("NHM.SulfurPowder", 30);

        elseif items:get(i):getType() == "SaltPinchSandbag" then
            player:getInventory():AddItems("NHM.SaltPinch", 30);


        elseif items:get(i):getType() == "LemonGrassSandbag" then
            player:getInventory():AddItems("Base.LemonGrass", 40);

        elseif items:get(i):getType() == "GinsengSandbag" then
            player:getInventory():AddItems("Base.Ginseng", 40);

        elseif items:get(i):getType() == "ComfreySandbag" then
            player:getInventory():AddItems("Base.Comfrey", 40);

        elseif items:get(i):getType() == "PlantainSandbag" then
            player:getInventory():AddItems("Base.Plantain", 40);

        elseif items:get(i):getType() == "WildGarlicSandbag" then
            player:getInventory():AddItems("Base.WildGarlic2", 40);

        elseif items:get(i):getType() == "BlackSageSandbag" then
            player:getInventory():AddItems("Base.BlackSage", 40);

        elseif items:get(i):getType() == "Msheetstack" then
            player:getInventory():AddItems("Base.SheetMetal", 5);

        elseif items:get(i):getType() == "Pipestack" then
            player:getInventory():AddItems("Base.MetalPipe", 5);
            
        elseif items:get(i):getType() == "Mbarstack" then
            player:getInventory():AddItems("Base.MetalBar", 5);

        
        elseif items:get(i):getType() == "Sugar" or items:get(i):getType() == "SugarBrown" then
            player:getInventory():AddItems("NHM.Sugarcube", 50);

        end
    end
end

function Mech20XP(recipe, ingredients, result, player)
    s = player:getPerkLevel(Perks.Mechanics);
    --player:getXp():AddXP(Perks.Mechanics, 300*(s+1)*(s+1));
    player:getXp():AddXP(Perks.Mechanics, 2 * (s + 1));
end

function MWaMEXP(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Mechanics, 4 * 2);
end

function unHotwire()
    -- looking into VehicleCommands unhotwire debug cheat

    local player = getPlayer();
    local car = player:getVehicle();

    if not car then
        player:Say("Not in a vehicle...");
    else
        ISVehicleMechanics.onCheatHotwire(player, car, false, false) -- should work in multiplayer since sendClientCommand
    end
end

function addKey()
    local player = getPlayer();
    local car = player:getVehicle();
    local inv = player:getInventory();

    if not car then
        player:Say("Not in a vehicle...");
        inv:AddItem("Base.SheetMetal");
    else
        inv:AddItem(car:createVehicleKey());
    end
end

function GuitarPlay(items, result, player, selectedItem)
    local playerObj = getSpecificPlayer(player),
    ISTimedActionQueue.add(ISPlayGuitar:new(playerObj, item, 500));
end