function Jar_OnCreate(items, result, player)
    player:getInventory():AddItem("Base.EmptyJar");
end

function sandbag_OnCreate(items, result, player, selectedItem)
	player:getInventory():AddItem("Base.EmptySandbag");
end

function LearnMusic_onCreate(items, result, player, selectedItem)
	if player:HasTrait("FastLearner") then
		player:getXp():AddXP(Perks.Art, (60 / 1.3))
	elseif player:HasTrait("SlowLearner") then
		player:getXp():AddXP(Perks.Art, (60 / 0.7))
	else
		player:getXp():AddXP(Perks.Art, 60);
	end
end

--Переключение меч-бита
function PipeSwordBladeOnCreate(items, result, player, selectedItem)
	local conditionMax = selectedItem:getCondition();
		for i=0,items:size() - 1 do
			if items:get(i):getType() == "PipeSwordBlade" then
				local ps = player:getInventory():AddItem("NHM.PipeSwordBlunt");
				ps:setCondition(conditionMax);		
			end
		end
end

function PipeSwordBluntOnCreate(items, result, player, selectedItem)
	local conditionMax = selectedItem:getCondition();
		for i=0,items:size() - 1 do
			if items:get(i):getType() == "PipeSwordBlunt" then
				local ps = player:getInventory():AddItem("NHM.PipeSwordBlade");
				ps:setCondition(conditionMax);		
			end
		end
end

--ИЗОТОНИК ВОССТАНОВЛЕНИЕ ЭНЕРГИИ
function Isotonic_OnGiveXP(recipe, ingredients, result, player)
	if getPlayer():getPerkLevel(Perks.MineEndurance) < 10 then
		if player:HasTrait("FastLearner") then
			player:getXp():AddXP(Perks.MineEndurance, (30 / 1.3));
		elseif player:HasTrait("SlowLearner") then
			player:getXp():AddXP(Perks.MineEndurance, (30 / 0.7));
		else
			player:getXp():AddXP(Perks.MineEndurance, 30);
		end
	end
end
--КОНЕЦ ИЗОТОНИК

--ОПЫТ ДЛЯ ХИМИИ
function Chemistry1_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Chemistry, 1*4);
end

function Chemistry3_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Chemistry, 3*4);
end

function Chemistry5_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Chemistry, 5*4);
end

function Chemistry7_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Chemistry, 7*4);
end

function Chemistry8_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Chemistry, 8*4);
end

function Chemistry12_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Chemistry, 12*4);
end

function Chemistry15_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Chemistry, 15*4);
end

function Chemistry18_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Chemistry, 18*4);
end

function Chemistry20_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Chemistry, 20*4);
end

function Chemistry24_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Chemistry, 24*4);
end

function Chemistry28_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Chemistry, 28*4);
end
--КОНЕЦ ХИМИЯ

--ОПЫТ ДЛЯ ПЕРВОЙ ПОМОЩИ
function FirstAid3_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Doctor, 3*4);
end

function FirstAid5_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Doctor, 5*4);
end

function FirstAid8_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Doctor, 8*4);
end

function FirstAid12_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Doctor, 12*4);
end

function FirstAid15_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Doctor, 15*4);
end

function FirstAid18_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Doctor, 18*4);
end
--КОНЕЦ ПЕРВАЯ ПОМОЩЬ

--ОПЫТ ШИТЬЕ ПОРТНОЙ
function Tailoring3_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Tailoring, 3*4);
end

function Tailoring5_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Tailoring, 5*4);
end

function Tailoring8_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Tailoring, 8*4);
end

function Tailoring12_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Tailoring, 12*4);
end

function Tailoring15_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Tailoring, 15*4);
end

function Tailoring18_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Tailoring, 18*4);
end
--КОНЕЦ ШИТЬЕ ПОРТНОЙ

--ОПЫТ ДЛЯ МЕТАЛЛООБРАБОТКИ/ГАЗОСВАРКИ
function MetalWelding1_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.MetalWelding, 1*4);
end

function MetalWelding3_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.MetalWelding, 3*4);
end

function MetalWelding4_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.MetalWelding, 4*4);
end

function MetalWelding5_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.MetalWelding, 5*4);
end

function MetalWelding6_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.MetalWelding, 6*4);
end

function MetalWelding8_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.MetalWelding, 8*4);
end

function MetalWelding10_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.MetalWelding, 10*4);
end

function MetalWelding12_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.MetalWelding, 12*4);
end
--КОНЕЦ МЕТАЛЛООБРАБОТКА

--ОПЫТ ДЛЯ ИНЖЕНЕРА
function Engineer2_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Engineering, 2*4);
end

function Engineer3_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Engineering, 3*4);
end

function Engineer4_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Engineering, 4*4);
end

function Engineer5_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Engineering, 5*4);
end

function Engineer6_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Engineering, 6*4);
end

function Engineer7_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Engineering, 7*4);
end

function Engineer8_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Engineering, 8*4);
end

function Engineer10_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Engineering, 10*4);
end

function Engineer15_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Engineering, 15*4);
end

function Engineer25_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Engineering, 25*4);
end
--КОНЕЦ ИНЖЕНЕР

--ОПЫТ КОЖЕВНИЧЕСТВО
function Leatherworking1_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Leatherworking, 1*4);
end

function Leatherworking2_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Leatherworking, 2*4);
end

function Leatherworking3_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Leatherworking, 3*4);
end

function Leatherworking4_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Leatherworking, 4*4);
end

function Leatherworking5_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Leatherworking, 5*4);
end

function Leatherworking6_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Leatherworking, 6*4);
end

function Leatherworking7_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Leatherworking, 7*4);
end

function Leatherworking8_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Leatherworking, 8*4);
end

function Leatherworking9_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Leatherworking, 9*4);
end

function Leatherworking10_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Leatherworking, 10*4);
end

function Leatherworking12_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Leatherworking, 12*4);
end

function Leatherworking15_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Leatherworking, 15*4);
end

function Leatherworking16_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Leatherworking, 16*4);
end

function Leatherworking20_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Leatherworking, 20*4);
end

function Leatherworking30_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Leatherworking, 30*4);
end
--КОНЕЦ КОЖЕВНИЧЕСТВО

--ОПЫТ ЭЛЕКТРИКА

function Electricity3_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Electricity, 3*4);
end

function Electricity5_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Electricity, 5*4);
end

function Electricity8_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Electricity, 8*4);
end

function Electricity12_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Electricity, 12*4);
end

function Electricity15_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Electricity, 15*4);
end

function Electricity20_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Electricity, 20*4);
end

function Electricity25_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Electricity, 25*4);
end

function Electricity30_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Electricity, 30*4);
end

function Electricity35_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Electricity, 35*4);
end

function Electricity75_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Electricity, 75*4);
end
--КОНЕЦ ЭЛЕКТРИКА

--ВЫДАЧА БРОНИ
function MetalLegPadsOnCreate(items, result, player)
	player:getInventory():AddItem("Base.MetalLegPadL");
	player:getInventory():AddItem("Base.MetalLegPadR");
end

function MetalShoulderPadsOnCreate(items, result, player)
	player:getInventory():AddItem("Base.MetalShoulderPadL");
	player:getInventory():AddItem("Base.MetalShoulderPadR");
end

function MetalShinPlatesOnCreate(items, result, player)
	player:getInventory():AddItem("Base.MetalShinPlateL");
	player:getInventory():AddItem("Base.MetalShinPlateR");
end

function MetalBracersOnCreate(items, result, player)
	player:getInventory():AddItem("Base.MetalBracerL");
	player:getInventory():AddItem("Base.MetalBracerR");
end

function MetalLegPads2OnCreate(items, result, player)
	player:getInventory():AddItem("Base.MetalLegPad2L");
	player:getInventory():AddItem("Base.MetalLegPad2R");
end

function MetalShoulderPads2OnCreate(items, result, player)
	player:getInventory():AddItem("Base.MetalShoulderPad2L");
	player:getInventory():AddItem("Base.MetalShoulderPad2R");
end

function MetalShinPlates2OnCreate(items, result, player)
	player:getInventory():AddItem("Base.MetalShinPlate2L");
	player:getInventory():AddItem("Base.MetalShinPlate2R");
end

function MetalBracers2OnCreate(items, result, player)
	player:getInventory():AddItem("Base.MetalBracer2L");
	player:getInventory():AddItem("Base.MetalBracer2R");
end
--КОНЕЦ ВЫДАЧА БРОНИ

--РАЗБОР МЕТАЛЛ ПРЕДМЕТОВ НА СКРАП
function MakeScrapOnCreate(items, result, player)
	local x = ZombRand(5)
	if x==4 then
	player:getInventory():AddItems("Base.ScrapMetal",2);
	elseif x==3 or x==2 or x==1 then
	player:getInventory():AddItem("Base.ScrapMetal");
	end
	player:getInventory():AddItem("Base.UnusableMetal");
end
--КОНЕЦ РАЗБОР

function UnstackLogs(items, result, player)
	player:getInventory():AddItems("Base.SheetRope", 2);
end

function WaterBottleEmpty(items, result, player)
	player:getInventory():AddItem("Base.WaterBottleEmpty");
end

function Doc2_OnGiveXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Doctor, 2);
end

--УГОЛЬНАЯ ТАБЛЕТКА
function OnEat_CoalPills(food, character)
	character:getInventory():Remove("CoalPills");
	character:getBodyDamage():setFakeInfectionLevel(character:getBodyDamage():getFakeInfectionLevel() - 7.5);
end
--КОНЕЦ

function OnEat_ZombieFlesh(food, character)
	if character:HasTrait("cannibal") then
	character:getBodyDamage():setFakeInfectionLevel(character:getBodyDamage():getFakeInfectionLevel() + 5);
	else
	character:getBodyDamage():setFakeInfectionLevel(character:getBodyDamage():getFakeInfectionLevel() + 25);
	end
end


function OnEat_Isotonic(food, character)
	character:getInventory():Remove("Isotonic");
	character:getInventory():AddItem("Base.WaterBottleEmpty");
	if getPlayer():getPerkLevel(Perks.MineEndurance) < 10 then
		if character:HasTrait("FastLearner") then
			character:getXp():AddXP(Perks.MineEndurance, (60 / 1.3));
		elseif character:HasTrait("SlowLearner") then
			character:getXp():AddXP(Perks.MineEndurance, (60 / 0.7));
		else
			character:getXp():AddXP(Perks.MineEndurance, 60);
		end
	end
end

--БАФФЫ ОТ ЕДЫ
function Taco_OnEat(food, character)
	character:getInventory():Remove("TacoRecipe");
	character:getStats():setEndurance(character:getStats():getEndurance() + 0.2);
end

function Burrito_OnEat(food, character)
	character:getInventory():Remove("BurritoRecipe");
	character:getStats():setEndurance(character:getStats():getEndurance() + 0.2);
end

function Hotdog_OnEat(food, character)
	character:getInventory():Remove("Hotdog");
	character:getStats():setEndurance(character:getStats():getEndurance() + 0.3);
end

function Pizza_OnEat(food, character)
	character:getInventory():Remove("Pizza");
	character:getStats():setEndurance(character:getStats():getEndurance() + 0.3);
end

function Pie_OnEat(food, character)
	character:getInventory():Remove("Pie");
	character:getStats():setEndurance(character:getStats():getEndurance() + 0.4);
end

function Cake_OnEat(food, character)
	character:getInventory():Remove("CakeSlice");
	character:getStats():setEndurance(character:getStats():getEndurance() + 0.4);
end
--КОНЕЦ

--СИГАРЕТЫ
function OnEat_Cigarettes(food, character)
character:getBodyDamage():setTemperature(character:getBodyDamage():getTemperature() + 0.6);
character:getStats():setFatigue(character:getStats():getFatigue() - 0.05);
    if character:HasTrait("Smoker") then
        character:getBodyDamage():setUnhappynessLevel(character:getBodyDamage():getUnhappynessLevel() - 10);
        if character:getBodyDamage():getUnhappynessLevel() < 0 then
            character:getBodyDamage():setUnhappynessLevel(0);
        end
        character:getStats():setStress(character:getStats():getStress() - 10);
        if character:getStats():getStress() then
            character:getStats():setStress(0);
        end
        character:getStats():setStressFromCigarettes(0);
        character:setTimeSinceLastSmoke(0);
    end
end
--КОНЕЦ

--КВЕСТОВЫЕ ЖУРНАЛЫ НА ОПЫТ ЭЛЕКТРИКА ИНЖЕНЕНРИЯ ХИМИЯ КОЖЕВНИЧЕСТВО ШИТЬЕ ОХОТА ПЕРВАЯ ПОМОЩЬ
function OnEat_QChemistry(food, character) 
	if character:getPerkLevel(Perks.Chemistry) < 1 then
		character:getXp():AddXP(Perks.Chemistry, 40);
	elseif character:getPerkLevel(Perks.Chemistry) < 2 then
		character:getXp():AddXP(Perks.Chemistry, 80);
	elseif character:getPerkLevel(Perks.Chemistry) < 3 then
		character:getXp():AddXP(Perks.Chemistry, 140);
	elseif character:getPerkLevel(Perks.Chemistry) < 4 then
		character:getXp():AddXP(Perks.Chemistry, 280);
	elseif character:getPerkLevel(Perks.Chemistry) < 5 then
		character:getXp():AddXP(Perks.Chemistry, 520);
	elseif character:getPerkLevel(Perks.Chemistry) < 6 then
		character:getXp():AddXP(Perks.Chemistry, 720);
	elseif character:getPerkLevel(Perks.Chemistry) < 7 then
		character:getXp():AddXP(Perks.Chemistry, 1200);
	elseif character:getPerkLevel(Perks.Chemistry) < 8 then
		character:getXp():AddXP(Perks.Chemistry, 1400);
	elseif character:getPerkLevel(Perks.Chemistry) < 9 then
		character:getXp():AddXP(Perks.Chemistry, 1500);
	elseif character:getPerkLevel(Perks.Chemistry) < 10 then
		character:getXp():AddXP(Perks.Chemistry, 1560);
	end
end

function OnEat_QElectric(food, character) 
	if character:getPerkLevel(Perks.Electricity) < 1 then
		character:getXp():AddXP(Perks.Electricity, 40);
	elseif character:getPerkLevel(Perks.Electricity) < 2 then
		character:getXp():AddXP(Perks.Electricity, 80);
	elseif character:getPerkLevel(Perks.Electricity) < 3 then
		character:getXp():AddXP(Perks.Electricity, 140);
	elseif character:getPerkLevel(Perks.Electricity) < 4 then
		character:getXp():AddXP(Perks.Electricity, 280);
	elseif character:getPerkLevel(Perks.Electricity) < 5 then
		character:getXp():AddXP(Perks.Electricity, 520);
	elseif character:getPerkLevel(Perks.Electricity) < 6 then
		character:getXp():AddXP(Perks.Electricity, 720);
	elseif character:getPerkLevel(Perks.Electricity) < 7 then
		character:getXp():AddXP(Perks.Electricity, 1200);
	elseif character:getPerkLevel(Perks.Electricity) < 8 then
		character:getXp():AddXP(Perks.Electricity, 1400);
	elseif character:getPerkLevel(Perks.Electricity) < 9 then
		character:getXp():AddXP(Perks.Electricity, 1500);
	elseif character:getPerkLevel(Perks.Electricity) < 10 then
		character:getXp():AddXP(Perks.Electricity, 1560);
	end
end

function OnEat_QEngineering(food, character) 
	if character:getPerkLevel(Perks.Engineering) < 1 then
		character:getXp():AddXP(Perks.Engineering, 40);
	elseif character:getPerkLevel(Perks.Engineering) < 2 then
		character:getXp():AddXP(Perks.Engineering, 80);
	elseif character:getPerkLevel(Perks.Engineering) < 3 then
		character:getXp():AddXP(Perks.Engineering, 140);
	elseif character:getPerkLevel(Perks.Engineering) < 4 then
		character:getXp():AddXP(Perks.Engineering, 280);
	elseif character:getPerkLevel(Perks.Engineering) < 5 then
		character:getXp():AddXP(Perks.Engineering, 520);
	elseif character:getPerkLevel(Perks.Engineering) < 6 then
		character:getXp():AddXP(Perks.Engineering, 720);
	elseif character:getPerkLevel(Perks.Engineering) < 7 then
		character:getXp():AddXP(Perks.Engineering, 1200);
	elseif character:getPerkLevel(Perks.Engineering) < 8 then
		character:getXp():AddXP(Perks.Engineering, 1400);
	elseif character:getPerkLevel(Perks.Engineering) < 9 then
		character:getXp():AddXP(Perks.Engineering, 1500);
	elseif character:getPerkLevel(Perks.Engineering) < 10 then
		character:getXp():AddXP(Perks.Engineering, 1560);
	end
end

function OnEat_QHunting(food, character) 
	if character:getPerkLevel(Perks.Trapping) < 1 then
		character:getXp():AddXP(Perks.Trapping, 40);
	elseif character:getPerkLevel(Perks.Trapping) < 2 then
		character:getXp():AddXP(Perks.Trapping, 80);
	elseif character:getPerkLevel(Perks.Trapping) < 3 then
		character:getXp():AddXP(Perks.Trapping, 140);
	elseif character:getPerkLevel(Perks.Trapping) < 4 then
		character:getXp():AddXP(Perks.Trapping, 280);
	elseif character:getPerkLevel(Perks.Trapping) < 5 then
		character:getXp():AddXP(Perks.Trapping, 520);
	elseif character:getPerkLevel(Perks.Trapping) < 6 then
		character:getXp():AddXP(Perks.Trapping, 720);
	elseif character:getPerkLevel(Perks.Trapping) < 7 then
		character:getXp():AddXP(Perks.Trapping, 1200);
	elseif character:getPerkLevel(Perks.Trapping) < 8 then
		character:getXp():AddXP(Perks.Trapping, 1400);
	elseif character:getPerkLevel(Perks.Trapping) < 9 then
		character:getXp():AddXP(Perks.Trapping, 1500);
	elseif character:getPerkLevel(Perks.Trapping) < 10 then
		character:getXp():AddXP(Perks.Trapping, 1560);
	end
end

function OnEat_QLeatherworking(food, character) 
	if character:getPerkLevel(Perks.Leatherworking) < 1 then
		character:getXp():AddXP(Perks.Leatherworking, 40);
	elseif character:getPerkLevel(Perks.Leatherworking) < 2 then
		character:getXp():AddXP(Perks.Leatherworking, 80);
	elseif character:getPerkLevel(Perks.Leatherworking) < 3 then
		character:getXp():AddXP(Perks.Leatherworking, 140);
	elseif character:getPerkLevel(Perks.Leatherworking) < 4 then
		character:getXp():AddXP(Perks.Leatherworking, 280);
	elseif character:getPerkLevel(Perks.Leatherworking) < 5 then
		character:getXp():AddXP(Perks.Leatherworking, 520);
	elseif character:getPerkLevel(Perks.Leatherworking) < 6 then
		character:getXp():AddXP(Perks.Leatherworking, 720);
	elseif character:getPerkLevel(Perks.Leatherworking) < 7 then
		character:getXp():AddXP(Perks.Leatherworking, 1200);
	elseif character:getPerkLevel(Perks.Leatherworking) < 8 then
		character:getXp():AddXP(Perks.Leatherworking, 1400);
	elseif character:getPerkLevel(Perks.Leatherworking) < 9 then
		character:getXp():AddXP(Perks.Leatherworking, 1500);
	elseif character:getPerkLevel(Perks.Leatherworking) < 10 then
		character:getXp():AddXP(Perks.Leatherworking, 1560);
	end
end

function OnEat_QTailoring(food, character) 
	if character:getPerkLevel(Perks.Tailoring) < 1 then
		character:getXp():AddXP(Perks.Tailoring, 40);
	elseif character:getPerkLevel(Perks.Tailoring) < 2 then
		character:getXp():AddXP(Perks.Tailoring, 80);
	elseif character:getPerkLevel(Perks.Tailoring) < 3 then
		character:getXp():AddXP(Perks.Tailoring, 140);
	elseif character:getPerkLevel(Perks.Tailoring) < 4 then
		character:getXp():AddXP(Perks.Tailoring, 280);
	elseif character:getPerkLevel(Perks.Tailoring) < 5 then
		character:getXp():AddXP(Perks.Tailoring, 520);
	elseif character:getPerkLevel(Perks.Tailoring) < 6 then
		character:getXp():AddXP(Perks.Tailoring, 720);
	elseif character:getPerkLevel(Perks.Tailoring) < 7 then
		character:getXp():AddXP(Perks.Tailoring, 1200);
	elseif character:getPerkLevel(Perks.Tailoring) < 8 then
		character:getXp():AddXP(Perks.Tailoring, 1400);
	elseif character:getPerkLevel(Perks.Tailoring) < 9 then
		character:getXp():AddXP(Perks.Tailoring, 1500);
	elseif character:getPerkLevel(Perks.Tailoring) < 10 then
		character:getXp():AddXP(Perks.Tailoring, 1560);
	end
end

function OnEat_QFirstAid(food, character) 
	if character:getPerkLevel(Perks.Doctor) < 1 then
		character:getXp():AddXP(Perks.Doctor, 40);
	elseif character:getPerkLevel(Perks.Doctor) < 2 then
		character:getXp():AddXP(Perks.Doctor, 80);
	elseif character:getPerkLevel(Perks.Doctor) < 3 then
		character:getXp():AddXP(Perks.Doctor, 140);
	elseif character:getPerkLevel(Perks.Doctor) < 4 then
		character:getXp():AddXP(Perks.Doctor, 280);
	elseif character:getPerkLevel(Perks.Doctor) < 5 then
		character:getXp():AddXP(Perks.Doctor, 520);
	elseif character:getPerkLevel(Perks.Doctor) < 6 then
		character:getXp():AddXP(Perks.Doctor, 720);
	elseif character:getPerkLevel(Perks.Doctor) < 7 then
		character:getXp():AddXP(Perks.Doctor, 1200);
	elseif character:getPerkLevel(Perks.Doctor) < 8 then
		character:getXp():AddXP(Perks.Doctor, 1400);
	elseif character:getPerkLevel(Perks.Doctor) < 9 then
		character:getXp():AddXP(Perks.Doctor, 1500);
	elseif character:getPerkLevel(Perks.Doctor) < 10 then
		character:getXp():AddXP(Perks.Doctor, 1560);
	end
end

--АНАЛИЗ РАДИАЦИЯ
function PoisonAnalyzer_OnCreate(items, result, player)
	local x = math.ceil(player:getBodyDamage():getFakeInfectionLevel())
	player:Say(getText("UI_FakeInf")..x);
end
--КОНЕЦ

Sound_Laugh = function()
	if getPlayer():getDescriptor():isFemale() then
	getSoundManager():PlayWorldSound("female_laugh", false, getPlayer():getCurrentSquare(), 0.2, 60, 0.2, false) ;
	else
	getSoundManager():PlayWorldSound("male_laugh", false, getPlayer():getCurrentSquare(), 0.2, 60, 0.2, false) ;
	end
end

Sound_Ohhh = function()
	if getPlayer():getDescriptor():isFemale() then
	getSoundManager():PlayWorldSound("female_oh", false, getPlayer():getCurrentSquare(), 0.2, 60, 0.2, false) ;
	else
	getSoundManager():PlayWorldSound("male_oh", false, getPlayer():getCurrentSquare(), 0.2, 60, 0.2, false) ;
	end
end

Sound_Hmmm = function()
if getPlayer():getDescriptor():isFemale() then
	getSoundManager():PlayWorldSound("female_hmm", false, getPlayer():getCurrentSquare(), 0.2, 60, 0.2, false) ;
	else
	getSoundManager():PlayWorldSound("male_hmm", false, getPlayer():getCurrentSquare(), 0.2, 60, 0.2, false) ;
	end
end

Sound_Cry = function()
	if getPlayer():getDescriptor():isFemale() then
		getSoundManager():PlaySound("female_cry", true, 1);
	else
		getSoundManager():PlaySound("male_cry", true, 1);
	end
end

Sound_Scream = function()
	if getPlayer():getDescriptor():isFemale() then
		getSoundManager():PlaySound("female_scream", true, 1);
	else
		getSoundManager():PlaySound("male_scream", true, 1);
	end
end

function ChipStone(items, result, player)
local stone = ZombRand(3);
	if stone == 0 then
	player:getInventory():AddItem("Base.SharpedStone");
	Sound_Hmmm(true)
	elseif stone == 1 then
	Sound_Cry(true)
	else
	Sound_Ohhh(true)
	end
end

function MakeHat(items, result, player)
for i=0,items:size() - 1 do
		if items:get(i):getType() == "Newspaper" then
		player:getInventory():AddItem("Base.Hat_NewspaperHat");
		elseif items:get(i):getType() == "Aluminum" then
		player:getInventory():AddItem("Base.Hat_TinFoilHat");
		end
	end
end

function OpenTinCan(items, result, player)
for i=0,items:size() - 1 do
		if items:get(i):getType() == "TunaTin" then
		player:getInventory():AddItem("Base.TunaTinOpen");
		elseif items:get(i):getType() == "CannedSardines" then
		player:getInventory():AddItem("Base.CannedSardinesOpen");
		elseif items:get(i):getType() == "CannedCornedBeef" then
		player:getInventory():AddItem("Base.CannedCornedBeefOpen");
		end
	end
end

function OpenWithCanOpener(items, result, player)
for i=0,items:size() - 1 do
		if items:get(i):getType() == "TinnedSoup" then
		player:getInventory():AddItem("Base.TinnedSoupOpen");
		elseif items:get(i):getType() == "TinnedBeans" then
		player:getInventory():AddItem("Base.OpenBeans");
		elseif items:get(i):getType() == "Dogfood" then
		player:getInventory():AddItem("Base.DogfoodOpen");
		elseif items:get(i):getType() == "CannedCorn" then
		player:getInventory():AddItem("Base.CannedCornOpen");
		elseif items:get(i):getType() == "CannedBolognese" then
		player:getInventory():AddItem("Base.CannedBologneseOpen");
		elseif items:get(i):getType() == "CannedChili" then
		player:getInventory():AddItem("Base.CannedChiliOpen");
		elseif items:get(i):getType() == "CannedMushroomSoup" then
		player:getInventory():AddItem("Base.CannedMushroomSoupOpen");
		elseif items:get(i):getType() == "CannedPeas" then
		player:getInventory():AddItem("Base.CannedPeasOpen");
		elseif items:get(i):getType() == "CannedPotato2" then
		player:getInventory():AddItem("Base.CannedPotatoOpen");
		elseif items:get(i):getType() == "CannedTomato2" then
		player:getInventory():AddItem("Base.CannedTomatoOpen");
		elseif items:get(i):getType() == "CannedCarrots2" then
		player:getInventory():AddItem("Base.CannedCarrotsOpen");
	    elseif items:get(i):getType() == "CannedFruitCocktail" then
		player:getInventory():AddItem("Base.CannedFruitCocktailOpen");
		elseif items:get(i):getType() == "CannedPeaches" then
		player:getInventory():AddItem("Base.CannedPeachesOpen");
		elseif items:get(i):getType() == "CannedPineapple" then
		player:getInventory():AddItem("Base.CannedPineappleOpen");
		end
	end
end

function OpenDamagedTinCan(items, result, player)
for i=0,items:size() - 1 do
		if items:get(i):getType() == "TinnedSoup" then
		player:getInventory():AddItem("Base.TinnedSoupOpenDamaged");
		elseif items:get(i):getType() == "TinnedBeans" then
		player:getInventory():AddItem("Base.OpenBeansDamaged");
		elseif items:get(i):getType() == "Dogfood" then
		player:getInventory():AddItem("Base.DogfoodOpenDamaged");
		elseif items:get(i):getType() == "CannedCorn" then
		player:getInventory():AddItem("Base.CannedCornOpenDamaged");
		elseif items:get(i):getType() == "CannedBolognese" then
		player:getInventory():AddItem("Base.CannedBologneseOpenDamaged");
		elseif items:get(i):getType() == "CannedChili" then
		player:getInventory():AddItem("Base.CannedChiliOpenDamaged");
		elseif items:get(i):getType() == "CannedMushroomSoup" then
		player:getInventory():AddItem("Base.CannedMushroomSoupOpenDamaged");
		elseif items:get(i):getType() == "CannedPeas" then
		player:getInventory():AddItem("Base.CannedPeasOpenDamaged");
		elseif items:get(i):getType() == "CannedPotato2" then
		player:getInventory():AddItem("Base.CannedPotatoOpenDamaged");
		elseif items:get(i):getType() == "CannedTomato2" then
		player:getInventory():AddItem("Base.CannedTomatoOpenDamaged");
		elseif items:get(i):getType() == "CannedCarrots2" then
		player:getInventory():AddItem("Base.CannedCarrotsOpenDamaged");
	    elseif items:get(i):getType() == "CannedFruitCocktail" then
		player:getInventory():AddItem("Base.CannedFruitCocktailOpen");
		elseif items:get(i):getType() == "CannedPeaches" then
		player:getInventory():AddItem("Base.CannedPeachesOpen");
		elseif items:get(i):getType() == "CannedPineapple" then
		player:getInventory():AddItem("Base.CannedPineappleOpen");
		end
	end
end

function SpearUpgrade(items, result, player, selectedItem)
local conditionMax = selectedItem:getCondition();
	for i=0,items:size() - 1 do
		if items:get(i):getType() == "BreadKnife" then
			local spear = player:getInventory():AddItem("Base.SpearBreadKnife");
			spear:setCondition(conditionMax);		
		elseif items:get(i):getType() == "ButterKnife" then
			local spear = player:getInventory():AddItem("Base.SpearButterKnife");
			spear:setCondition(conditionMax);		
		elseif items:get(i):getType() == "LetterOpener" then
			local spear = player:getInventory():AddItem("Base.SpearLetterOpener");
			spear:setCondition(conditionMax);		
		elseif items:get(i):getType() == "Fork" then
			local spear = player:getInventory():AddItem("Base.SpearFork");
			spear:setCondition(conditionMax);		
		elseif items:get(i):getType() == "Scalpel" then
			local spear = player:getInventory():AddItem("Base.SpearScalpel");
			spear:setCondition(conditionMax);		
		elseif items:get(i):getType() == "Spoon" then
			local spear = player:getInventory():AddItem("Base.SpearSpoon");
			spear:setCondition(conditionMax);		
		elseif items:get(i):getType() == "Scissors" then
			local spear = player:getInventory():AddItem("Base.SpearScissors");
			spear:setCondition(conditionMax);		
		elseif items:get(i):getType() == "HandFork" then
			local spear = player:getInventory():AddItem("Base.SpearHandFork");
			spear:setCondition(conditionMax);		
		elseif items:get(i):getType() == "Screwdriver" then
			local spear = player:getInventory():AddItem("Base.SpearScrewdriver");
			spear:setCondition(conditionMax);		
		elseif items:get(i):getType() == "HuntingKnife" then
			local spear = player:getInventory():AddItem("Base.SpearHuntingKnife");
			spear:setCondition(conditionMax);		
		elseif items:get(i):getType() == "KitchenKnife" then
			local spear = player:getInventory():AddItem("Base.SpearKnife");	
			spear:setCondition(conditionMax);				
		elseif items:get(i):getType() == "Machete" then
			local spear = player:getInventory():AddItem("Base.SpearMachete");
			spear:setCondition(conditionMax);			
		elseif items:get(i):getType() == "IcePick" then
			local spear = player:getInventory():AddItem("Base.SpearIcePick");
			spear:setCondition(conditionMax);		
		end
	end
end

function SpearReclaim(items, result, player, selectedItem)
	x1=selectedItem:getCondition();
	x2=selectedItem:getConditionMax();
	x3=5*x1/x2
    local spear = player:getInventory():AddItem("Base.SpearCrafted");
    spear:setCondition(x3);
	for i=0,items:size() - 1 do
		if items:get(i):getType() == "SpearBreadKnife" then
			local resultweapon = getPlayer():getInventory():AddItem("Base.BreadKnife");
			resultweapon:setCondition(x1);
		elseif items:get(i):getType() == "SpearButterKnife" then
			local resultweapon = getPlayer():getInventory():AddItem("Base.ButterKnife");
			resultweapon:setCondition(x1);
		elseif items:get(i):getType() == "SpearLetterOpener" then
			local resultweapon = getPlayer():getInventory():AddItem("Base.LetterOpener");
			resultweapon:setCondition(x1);
		elseif items:get(i):getType() == "SpearFork" then
			local resultweapon = getPlayer():getInventory():AddItem("Base.Fork");
			resultweapon:setCondition(x1);
		elseif items:get(i):getType() == "SpearScalpel" then
			local resultweapon = getPlayer():getInventory():AddItem("Base.Scalpel");
			resultweapon:setCondition(x1);
		elseif items:get(i):getType() == "SpearSpoon" then
			local resultweapon = getPlayer():getInventory():AddItem("Base.Spoon");
			resultweapon:setCondition(x1);
		elseif items:get(i):getType() == "SpearScissors" then
			local resultweapon = getPlayer():getInventory():AddItem("Base.Scissors");
			resultweapon:setCondition(x1);
		elseif items:get(i):getType() == "SpearHandFork" then
			local resultweapon = getPlayer():getInventory():AddItem("Base.HandFork");
			resultweapon:setCondition(x1);
		elseif items:get(i):getType() == "SpearScrewdriver" then
			local resultweapon = getPlayer():getInventory():AddItem("Base.Screwdriver");
			resultweapon:setCondition(x1);
		elseif items:get(i):getType() == "SpearKnife" then
			local resultweapon = getPlayer():getInventory():AddItem("Base.KitchenKnife");
			resultweapon:setCondition(x1);
		elseif items:get(i):getType() == "SpearHuntingKnife" then
			local resultweapon = getPlayer():getInventory():AddItem("Base.HuntingKnife");
			resultweapon:setCondition(x1);
		elseif items:get(i):getType() == "SpearMachete" then
			local resultweapon = getPlayer():getInventory():AddItem("Base.Machete");
			resultweapon:setCondition(x1);
		elseif items:get(i):getType() == "SpearIcePick" then
			local resultweapon = getPlayer():getInventory():AddItem("Base.IcePick");
			resultweapon:setCondition(x1);
		end
	end
end

function DisElectro(items, result, player, selectedItem)
local success = 50 + (player:getPerkLevel(Perks.Electricity)*5);
for i=0,items:size() - 1 do
	if items:get(i):getType() == "HamRadio1" or items:get(i):getType() == "HamRadio2" then
		local success = 50 + (player:getPerkLevel(Perks.Electricity)*5);
		player:getInventory():AddItems("Base.ElectronicsScrap", 6);
		if ZombRand(0,100)<success then
			player:getInventory():AddItem("Radio.RadioTransmitter");
		end
		if ZombRand(0,100)<success then
			player:getInventory():AddItem("Base.LightBulbGreen");
		end
	
	elseif items:get(i):getType() == "WalkieTalkie1" or items:get(i):getType() == "WalkieTalkie2" or items:get(i):getType() == "WalkieTalkie3" or items:get(i):getType() == "WalkieTalkie4" or items:get(i):getType() == "WalkieTalkie5" then
	local success = 50 + (player:getPerkLevel(Perks.Electricity)*5);
		if ZombRand(0,100)<success then
			player:getInventory():AddItem("Radio.RadioTransmitter");
		end
		if ZombRand(0,100)<success then
			player:getInventory():AddItem("Base.LightBulbGreen");
		end

	elseif items:get(i):getType() == "RadioRed" or items:get(i):getType() == "RadioBlack" then
		for i=1,ZombRand(1,4) do
			local r = ZombRand(1,4);
			if r==1 then
				player:getInventory():AddItem("Base.ElectronicsScrap");
			elseif r==2 then
				player:getInventory():AddItem("Radio.ElectricWire");
			elseif r==3 then
				player:getInventory():AddItem("Base.Aluminum");
			end
		end
		if ZombRand(0,100)<success then
			player:getInventory():AddItem("Base.Amplifier");
		end
		if ZombRand(0,100)<success then
			player:getInventory():AddItem("Base.LightBulb");
		end
		if ZombRand(0,100)<success then
			player:getInventory():AddItem("Radio.RadioReceiver");
		end
    --if selectedItem then
        --print("Main item "..selectedItem:getName());
    --end
		for i=1,items:size() do
			local item = items:get(i-1)
			if instanceof(item, "Radio") then
				item:getDeviceData():getBattery(player:getInventory())
				item:getDeviceData():getHeadphones(player:getInventory())
				break
			end
		end
	
	elseif items:get(i):getType() == "TvAntique" or items:get(i):getType() == "TvWideScreen" or items:get(i):getType() == "TvBlack" then
		for i=1,ZombRand(1,6) do
			local r = ZombRand(1,4);
			if r==1 then
				player:getInventory():AddItem("Base.ElectronicsScrap");
			elseif r==2 then
				player:getInventory():AddItem("Radio.ElectricWire");
			elseif r==3 then
				player:getInventory():AddItem("Base.Aluminum");
			end
		end
		if ZombRand(0,100)<success then
			player:getInventory():AddItem("Base.Amplifier");
		end
		if ZombRand(0,100)<success then
			player:getInventory():AddItem("Base.LightBulb");
		end
		if selectedItem then
			--print("Main item "..selectedItem:getName());
			if selectedItem:getType()~="TvAntique" then
				if ZombRand(0,100)<success then
					player:getInventory():AddItem("Base.LightBulbRed");
				end
				if ZombRand(0,100)<success then
					player:getInventory():AddItem("Base.LightBulbGreen");
				end
			end
		end
	elseif items:get(i):getType() == "HomeAlarm" then
		player:getInventory():AddItem("Base.MotionSensor");
	elseif items:get(i):getType() == "Speaker" then
		player:getInventory():AddItem("Base.Amplifier");
	end
end
end

function DisinfectRags(items, result, player, selectedItem)
	for i=0,items:size() - 1 do
		if items:get(i):getType() == "RippedSheets" then
			getPlayer():getInventory():AddItem("Base.AlcoholRippedSheets");
		elseif items:get(i):getType() == "Bandage" then
			getPlayer():getInventory():AddItem("Base.AlcoholBandage");
		elseif items:get(i):getType() == "CottonBalls" then
			getPlayer():getInventory():AddItem("Base.AlcoholedCottonBalls");
		end
	end
end

function MakePoultice(items, result, player, selectedItem)
	for i=0,items:size() - 1 do
		if items:get(i):getType() == "Plantain" then
			getPlayer():getInventory():AddItem("Base.PlantainCataplasm");
		elseif items:get(i):getType() == "Comfrey" then
			getPlayer():getInventory():AddItem("Base.ComfreyCataplasm");
		elseif items:get(i):getType() == "WildGarlic2" then
			getPlayer():getInventory():AddItem("Base.WildGarlicCataplasm");
		end
	end
end

function BuildSpikedWeapon(items, result, player, selectedItem)
	for i=0,items:size() - 1 do
		if items:get(i):getType() == "BaseballBat" then
			getPlayer():getInventory():AddItem("Base.BaseballBatNails");
		elseif items:get(i):getType() == "Plank" then
			getPlayer():getInventory():AddItem("Base.PlankNail");
		end
	end
end

function OpenPacketofSeeds(items, result, player, selectedItem)
	for i=0,items:size() - 1 do
		if items:get(i):getType() == "CabbageBagSeed" then		
			player:getInventory():AddItems("farming.CabbageSeed", 50);
		elseif items:get(i):getType() == "TomatoBagSeed" then
			player:getInventory():AddItems("farming.TomatoSeed", 50);
		elseif items:get(i):getType() == "PotatoBagSeed" then
			player:getInventory():AddItems("farming.PotatoSeed", 50);
		elseif items:get(i):getType() == "StrewberrieBagSeed" then
			player:getInventory():AddItems("farming.StrewberrieSeed", 50);
		elseif items:get(i):getType() == "RedRadishBagSeed" then
			player:getInventory():AddItems("farming.RedRadishSeed", 50);
		elseif items:get(i):getType() == "BroccoliBagSeed" then
			player:getInventory():AddItems("farming.BroccoliSeed", 50);
		elseif items:get(i):getType() == "CarrotBagSeed" then
			player:getInventory():AddItems("farming.CarrotSeed", 50);
		end
	end
end

function OpenBoxofBullets(items, result, player, selectedItem)
	for i=0,items:size() - 1 do
		if items:get(i):getType() == "556Box" then		
			player:getInventory():AddItems("Base.556Bullets", 12);
		elseif items:get(i):getType() == "ShotgunShellsBox" then
			player:getInventory():AddItems("Base.ShotgunShells", 4);
		elseif items:get(i):getType() == "308Box" then
			player:getInventory():AddItems("Base.308Bullets", 8);
		elseif items:get(i):getType() == "223Box" then
			player:getInventory():AddItems("Base.223Bullets", 8);
		elseif items:get(i):getType() == "Bullets44Box" then
			player:getInventory():AddItems("Base.Bullets44", 4);
		elseif items:get(i):getType() == "Bullets38Box" then
			player:getInventory():AddItems("Base.Bullets38", 6);
		elseif items:get(i):getType() == "Bullets45Box" then
			player:getInventory():AddItems("Base.Bullets45", 6);
		elseif items:get(i):getType() == "Bullets9mmBox" then
			player:getInventory():AddItems("Base.Bullets9mm", 6);
		end
	end
end

--[[ function UseUmbrella(items, result, player, umbrella, firstHand, secondHand)
	for i=0,items:size() - 1 do
		if items:get(i):getType() == "UmbrellaBlue" then		
			getPlayer():getInventory():AddItem("Base.ClosedUmbrellaBlue");
			result:setCondition(umbrella:getCondition());
				if secondHand then player:setSecondaryHandItem(result);
				elseif firstHand and not secondHand then player:setPrimaryHandItem(result);
				end
		elseif items:get(i):getType() == "UmbrellaRed" then
			getPlayer():getInventory():AddItem("Base.ClosedUmbrellaRed");
			result:setCondition(umbrella:getCondition());if secondHand then player:setSecondaryHandItem(result);elseif firstHand and not secondHand then player:setPrimaryHandItem(result);end
		elseif items:get(i):getType() == "UmbrellaBlack" then
			getPlayer():getInventory():AddItem("Base.ClosedUmbrellaBlack");
			result:setCondition(umbrella:getCondition());if secondHand then player:setSecondaryHandItem(result);elseif firstHand and not secondHand then player:setPrimaryHandItem(result);end
		elseif items:get(i):getType() == "UmbrellaWhite" then
			getPlayer():getInventory():AddItem("Base.ClosedUmbrellaWhite");
			result:setCondition(umbrella:getCondition());if secondHand then player:setSecondaryHandItem(result);elseif firstHand and not secondHand then player:setPrimaryHandItem(result);end
		elseif items:get(i):getType() == "ClosedUmbrellaBlue" then
			getPlayer():getInventory():AddItem("Base.UmbrellaBlue");
			result:setCondition(umbrella:getCondition());if secondHand then player:setSecondaryHandItem(result);elseif firstHand and not secondHand then player:setPrimaryHandItem(result);end
		elseif items:get(i):getType() == "ClosedUmbrellaRed" then
			getPlayer():getInventory():AddItem("Base.UmbrellaRed");
			result:setCondition(umbrella:getCondition());if secondHand then player:setSecondaryHandItem(result);elseif firstHand and not secondHand then player:setPrimaryHandItem(result);end
		elseif items:get(i):getType() == "ClosedUmbrellaBlack" then
			getPlayer():getInventory():AddItem("Base.UmbrellaBlack");
			result:setCondition(umbrella:getCondition());if secondHand then player:setSecondaryHandItem(result);elseif firstHand and not secondHand then player:setPrimaryHandItem(result);end
		elseif items:get(i):getType() == "ClosedUmbrellaWhite" then
			getPlayer():getInventory():AddItem("Base.UmbrellaWhite");
			result:setCondition(umbrella:getCondition());if secondHand then player:setSecondaryHandItem(result);elseif firstHand and not secondHand then player:setPrimaryHandItem(result);end
		end
	end ]]
---end

function OpenBox(items, result, player, selectedItem)
	for i=0,items:size() - 1 do
		if items:get(i):getType() == "BoxOfJars" then		
			player:getInventory():AddItems("Base.EmptyJar", 6);
		elseif items:get(i):getType() == "NailsBox" then
			player:getInventory():AddItems("Base.Nails", 20);
		elseif items:get(i):getType() == "ScrewsBox" then
			player:getInventory():AddItems("Base.Screws", 20);
		elseif items:get(i):getType() == "PaperclipBox" then
			player:getInventory():AddItems("Base.Paperclip", 40);
		end
	end
end

function InsertBattery(items, result, player, selectedItem)
	for i=0,items:size()-1 do
		if items:get(i):getType() == "Rubberducky2" then		
			getPlayer():getInventory():AddItem("Base.Rubberducky2");
			for l=0, items:size()-1 do if items:get(l):getType() == "Battery" then result:setUsedDelta(items:get(l):getUsedDelta());end end
		elseif items:get(i):getType() == "Torch" then
			getPlayer():getInventory():AddItem("Base.Torch");
			for l=0, items:size()-1 do if items:get(l):getType() == "Battery" then result:setUsedDelta(items:get(l):getUsedDelta());end end
		elseif items:get(i):getType() == "HandTorch" then
			getPlayer():getInventory():AddItem("Base.HandTorch");
			for l=0, items:size()-1 do if items:get(l):getType() == "Battery" then result:setUsedDelta(items:get(l):getUsedDelta());end end
		end
	end
end 


-- Return true if recipe is valid, false otherwise
function Recipe.OnTest.TorchBatteryInsert(sourceItem, result, player, selectedItem)
	if sourceItem:getType() == "Torch" or sourceItem:getType() == "HandTorch" or sourceItem:getType() == "Rubberducky2" then
		return sourceItem:getUsedDelta() == 0; -- Only allow the battery inserting if the flashlight has no battery left in it.
	end
	return true -- the battery
end

function Recipe.OnTest.comprobarenergiaginseng(result, player)
	if playerObj:getPerkLevel(Perks.MineEndurance) >= 1 then
	    return true
	else
		return false
	end
end

function Recipe.OnCreate.quitarenergiaginseng(result, player)
	playerObj:LoseLevel(Perks.MineEndurance);
end

-- When creating item in result box of crafting panel.
function Recipe.OnCreate.TorchBatteryInsert(items, result, player)
	for i=0, items:size()-1 do
	-- we found the battery, we change his used delta according to the battery
		if items:get(i):getType() == "Battery" then
			result:setUsedDelta(items:get(i):getUsedDelta());
		end
	end
end

function PaintHair(items, result, player)
	for i=0,items:size() - 1 do
			if items:get(i):getType() == "DyeYellow" then
			player:getInventory():AddItem("Base.HairDyeYellow");
			elseif items:get(i):getType() == "DyeGreen" then
			player:getInventory():AddItem("Base.HairDyeGreen");
			elseif items:get(i):getType() == "DyeRed" then
			player:getInventory():AddItem("Base.HairDyeRed");
			elseif items:get(i):getType() == "DyePink" then
			player:getInventory():AddItem("Base.HairDyePink");
			elseif items:get(i):getType() == "DyeLightBrown" then
			player:getInventory():AddItem("Base.HairDyeLightBrown");
			elseif items:get(i):getType() == "DyeOrange" then
			player:getInventory():AddItem("Base.HairDyeGinger");
			elseif items:get(i):getType() == "DyeGrey" then
			player:getInventory():AddItem("Base.HairDyeBlonde");
			elseif items:get(i):getType() == "DyeBlue" then
			player:getInventory():AddItem("Base.HairDyeBlue");
			elseif items:get(i):getType() == "DyeBlack" then
			player:getInventory():AddItem("Base.HairDyeBlack");
			end
		end
	end

	function PaintBucket(items, result, player)
		for i=0,items:size() - 1 do
				if items:get(i):getType() == "DyeYellow" then
				player:getInventory():AddItem("Base.PaintYellow");
				elseif items:get(i):getType() == "DyeGreen" then
				player:getInventory():AddItem("Base.PaintGreen");
				elseif items:get(i):getType() == "DyeRed" then
				player:getInventory():AddItem("Base.PaintRed");
				elseif items:get(i):getType() == "DyePink" then
				player:getInventory():AddItem("Base.PaintPink");
				elseif items:get(i):getType() == "DyeLightBrown" then
				player:getInventory():AddItem("Base.PaintLightBrown");
				elseif items:get(i):getType() == "DyeOrange" then
				player:getInventory():AddItem("Base.PaintOrange");
				elseif items:get(i):getType() == "DyeGrey" then
				player:getInventory():AddItem("Base.PaintGrey");
				elseif items:get(i):getType() == "DyeBlue" then
				player:getInventory():AddItem("Base.PaintBlue");
				elseif items:get(i):getType() == "DyeBlack" then
				player:getInventory():AddItem("Base.PaintBlack");
				elseif items:get(i):getType() == "DyeTurquoise" then
				player:getInventory():AddItem("Base.PaintTurquoise");
				elseif items:get(i):getType() == "DyePurple" then
				player:getInventory():AddItem("Base.PaintPurple");
				elseif items:get(i):getType() == "DyeBrown" then
				player:getInventory():AddItem("Base.PaintBrown");
				elseif items:get(i):getType() == "DyeLightBlue" then
				player:getInventory():AddItem("Base.PaintLightBlue");
				elseif items:get(i):getType() == "DyeCyan" then
				player:getInventory():AddItem("Base.PaintCyan");
				end
			end
		end

		function PaintBulb(items, result, player)
			for i=0,items:size() - 1 do
					if items:get(i):getType() == "DyeYellow" then
					player:getInventory():AddItem("Base.LightBulbYellow");
					elseif items:get(i):getType() == "DyeGreen" then
					player:getInventory():AddItem("Base.LightBulbGreen");
					elseif items:get(i):getType() == "DyeRed" then
					player:getInventory():AddItem("Base.LightBulbRed");
					elseif items:get(i):getType() == "DyePink" then
					player:getInventory():AddItem("Base.LightBulbPink");
					elseif items:get(i):getType() == "DyeOrange" then
					player:getInventory():AddItem("Base.LightBulbOrange");
					elseif items:get(i):getType() == "DyeBlue" then
					player:getInventory():AddItem("Base.LightBulbBlue");
					elseif items:get(i):getType() == "DyePurple" then
					player:getInventory():AddItem("Base.LightBulbPurple");
					elseif items:get(i):getType() == "DyeCyan" then
					player:getInventory():AddItem("Base.LightBulbCyan");
					elseif items:get(i):getType() == "DyeMagenta" then
					player:getInventory():AddItem("Base.LightBulbMagenta");
					end
				end
			end