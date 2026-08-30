require "Farming/SFarmingSystem"
require "Farming/farming_vegetableconf"

if isClient() and not isServer() then return end

-- grow the plants
function SFarmingSystem:growPlant(luaObject, nextGrowing, updateNbOfGrow)
	if(luaObject.state == "seeded") then
		local new = luaObject.nbOfGrow <= 0
		if(luaObject.typeOfSeed == "Carrots") then
			luaObject = farming_vegetableconf.growCarrots(luaObject, nextGrowing, updateNbOfGrow)
		elseif(luaObject.typeOfSeed == "Broccoli") then
			luaObject = farming_vegetableconf.growBroccoli(luaObject, nextGrowing, updateNbOfGrow)
		elseif(luaObject.typeOfSeed == "Strawberry plant") then
			luaObject = farming_vegetableconf.growStrewberries(luaObject, nextGrowing, updateNbOfGrow)
		elseif(luaObject.typeOfSeed == "Radishes") then
			luaObject = farming_vegetableconf.growRedRadish(luaObject, nextGrowing, updateNbOfGrow)
		elseif(luaObject.typeOfSeed == "Tomato") then
			luaObject = farming_vegetableconf.growTomato(luaObject, nextGrowing, updateNbOfGrow)
		elseif(luaObject.typeOfSeed == "Potatoes") then
			luaObject = farming_vegetableconf.growPotato(luaObject, nextGrowing, updateNbOfGrow)
		elseif(luaObject.typeOfSeed == "Cabbages") then
			luaObject = farming_vegetableconf.growCabbage(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "SoyBean") then
            luaObject = farming_vegetableconf.growSoyBean(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Olive") then
            luaObject = farming_vegetableconf.growOlive(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Leek") then
            luaObject = farming_vegetableconf.growLeek(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Lettuce") then
            luaObject = farming_vegetableconf.growLettuce(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Onion") then
            luaObject = farming_vegetableconf.growOnion(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "GrapeFruit") then
            luaObject = farming_vegetableconf.growGrapeFruit(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "BerryBlue") then
            luaObject = farming_vegetableconf.growBerryBlue(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "BerryBlack") then
            luaObject = farming_vegetableconf.growBerryBlack(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "SugarCane") then
            luaObject = farming_vegetableconf.growSugarCane(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Ginger") then
            luaObject = farming_vegetableconf.growGinger(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Ginseng") then
            luaObject = farming_vegetableconf.growGinseng(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Pumpkin") then
            luaObject = farming_vegetableconf.growPumpkin(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Watermelon") then
            luaObject = farming_vegetableconf.growWatermelon(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Zucchini") then
            luaObject = farming_vegetableconf.growZucchini(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Corn") then
            luaObject = farming_vegetableconf.growCorn(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Lemongrass") then
            luaObject = farming_vegetableconf.growLemongrass(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Mushroom") then
            luaObject = farming_vegetableconf.growMushroom(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "BellPepper") then
            luaObject = farming_vegetableconf.growBellPepper(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Eggplant") then
            luaObject = farming_vegetableconf.growEggplant(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Grape") then
            luaObject = farming_vegetableconf.growGrape(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Peach") then
            luaObject = farming_vegetableconf.growPeach(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Lemon") then
            luaObject = farming_vegetableconf.growLemon(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Orange") then
            luaObject = farming_vegetableconf.growOrange(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Apple") then
            luaObject = farming_vegetableconf.growApple(luaObject, nextGrowing, updateNbOfGrow)    
        elseif(luaObject.typeOfSeed == "Banana") then
            luaObject = farming_vegetableconf.growBanana(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Cherry") then
            luaObject = farming_vegetableconf.growCherry(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Pineapple") then
            luaObject = farming_vegetableconf.growPineapple(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Lime") then
            luaObject = farming_vegetableconf.growLime(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Avocado") then
            luaObject = farming_vegetableconf.growAvocado(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Wheat") then
            luaObject = farming_vegetableconf.growWheat(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Mango") then
            luaObject = farming_vegetableconf.growMango(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Rice") then
            luaObject = farming_vegetableconf.growRice(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "PepperPlant") then
            luaObject = farming_vegetableconf.growPepperPlant(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Honey") then
            luaObject = farming_vegetableconf.growHoney(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Milk") then
            luaObject = farming_vegetableconf.growMilk(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Egg") then
            luaObject = farming_vegetableconf.growEgg(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Wool") then
            luaObject = farming_vegetableconf.growCattle(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Beef") then
            luaObject = farming_vegetableconf.growCattle(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Pork") then
            luaObject = farming_vegetableconf.growCattle(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Mutton") then
            luaObject = farming_vegetableconf.growCattle(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Bird") then
            luaObject = farming_vegetableconf.growCattle(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Cotton") then
            luaObject = farming_vegetableconf.growCotton(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Hops") then
            luaObject = farming_vegetableconf.growHops(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Rose") then
            luaObject = farming_vegetableconf.growFlowers(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Carnation") then
            luaObject = farming_vegetableconf.growFlowers(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Larkspur") then
            luaObject = farming_vegetableconf.growFlowers(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Dahlia") then
            luaObject = farming_vegetableconf.growFlowers(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Delphi") then
            luaObject = farming_vegetableconf.growFlowers(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Daisy") then
            luaObject = farming_vegetableconf.growFlowers(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Penta") then
            luaObject = farming_vegetableconf.growFlowers(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Geranium") then
            luaObject = farming_vegetableconf.growFlowers(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Latex") then
            luaObject = farming_vegetableconf.growTree(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Tea") then
            luaObject = farming_vegetableconf.growTea(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Coffee") then
            luaObject = farming_vegetableconf.growTree(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Sativa") then
            luaObject = farming_vegetableconf.growFlowers(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Indica") then
            luaObject = farming_vegetableconf.growFlowers(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Tobacco") then
            luaObject = farming_vegetableconf.growFlowers(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Pear") then
            luaObject = farming_vegetableconf.growTree(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "CommonMallow") then
            luaObject = farming_vegetableconf.growFlowers(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Comfrey") then
            luaObject = farming_vegetableconf.growFlowers(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Plantain") then
            luaObject = farming_vegetableconf.growFlowers(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Sage") then
            luaObject = farming_vegetableconf.growFlowers(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Coca") then
            luaObject = farming_vegetableconf.growFlowers(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Kief") then
            luaObject = farming_vegetableconf.growFlowers(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Amapola") then
            luaObject = farming_vegetableconf.growFlowers(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Mongui") then
            luaObject = farming_vegetableconf.growMushroom(luaObject, nextGrowing, updateNbOfGrow)
        elseif(luaObject.typeOfSeed == "Garlic") then
            luaObject = farming_vegetableconf.growFlowers(luaObject, nextGrowing, updateNbOfGrow)
            
            if farming_vegetableconf.props[luaObject.typeOfSeed].growCode ~= nil then
			    local growCode = farming_vegetableconf.props[luaObject.typeOfSeed].growCode
			    luaObject = assert(loadstring('return '..growCode..'(...)'))(luaObject, nextGrowing, updateNbOfGrow)
            end
        end
		-- maybe this plant gonna be disease
		if not new and luaObject.nbOfGrow > 0 then
			self:diseaseThis(luaObject, true)
		end
		luaObject.nbOfGrow = luaObject.nbOfGrow + 1
	end
end


function SFarmingSystem:harvest(luaObject, player)
	local props = farming_vegetableconf.props[luaObject.typeOfSeed]
	local numberOfVeg = getVegetablesNumber(props.minVeg, props.maxVeg, props.minVegAutorized, props.maxVegAutorized, luaObject)
	if player then
		player:sendObjectChange('addItemOfType', { type = props.vegetableName, count = numberOfVeg })
	end

	if luaObject.hasSeed and player then
		player:sendObjectChange('addItemOfType', { type = props.seedName, count = (props.seedPerVeg * numberOfVeg) })
	end

	luaObject.hasVegetable = false
	luaObject.hasSeed = false

	-- these don't disapear, it goes on phase 5 again
	if luaObject.typeOfSeed == "Apple" then
		luaObject.nbOfGrow = 4
		luaObject.fertilizer = 0;
		self:growPlant(luaObject, nil, true)
		luaObject:saveData()
    elseif luaObject.typeOfSeed == "Orange"  then
        luaObject.nbOfGrow = 4
        luaObject.fertilizer = 0;
        self:growPlant(luaObject, nil, true)
        luaObject:saveData()
    elseif luaObject.typeOfSeed ==  "Olive"  then
        luaObject.nbOfGrow = 4
        luaObject.fertilizer = 0;
        self:growPlant(luaObject, nil, true)
        luaObject:saveData()
    elseif luaObject.typeOfSeed ==  "Mango"  then
        luaObject.nbOfGrow = 4
        luaObject.fertilizer = 0;
        self:growPlant(luaObject, nil, true)
        luaObject:saveData()
    elseif luaObject.typeOfSeed ==  "GrapeFruit"  then
        luaObject.nbOfGrow = 4
        luaObject.fertilizer = 0;
        self:growPlant(luaObject, nil, true)
        luaObject:saveData()
    elseif luaObject.typeOfSeed ==  "Peach"  then
        luaObject.nbOfGrow = 4
        luaObject.fertilizer = 0;
        self:growPlant(luaObject, nil, true)
        luaObject:saveData()
    elseif luaObject.typeOfSeed ==   "Avocado"  then
        luaObject.nbOfGrow = 4
        luaObject.fertilizer = 0;
        self:growPlant(luaObject, nil, true)
        luaObject:saveData()
    elseif luaObject.typeOfSeed ==  "Banana"  then
        luaObject.nbOfGrow = 4
        luaObject.fertilizer = 0;
        self:growPlant(luaObject, nil, true)
        luaObject:saveData()
    elseif luaObject.typeOfSeed ==  "Cherry"  then
        luaObject.nbOfGrow = 4
        luaObject.fertilizer = 0;
        self:growPlant(luaObject, nil, true)
        luaObject:saveData()
    elseif luaObject.typeOfSeed ==  "Lemon"  then
        luaObject.nbOfGrow = 4
        luaObject.fertilizer = 0;
        self:growPlant(luaObject, nil, true)
        luaObject:saveData()
    elseif luaObject.typeOfSeed ==  "Lime"  then
        luaObject.nbOfGrow = 4
        luaObject.fertilizer = 0;
        self:growPlant(luaObject, nil, true)
        luaObject:saveData()
    elseif luaObject.typeOfSeed ==  "Strawberry plant" then
        luaObject.nbOfGrow = 4
        luaObject.fertilizer = 0;
        self:growPlant(luaObject, nil, true)
        luaObject:saveData()
    elseif luaObject.typeOfSeed ==  "BerryBlue"  then
        luaObject.nbOfGrow = 4
        luaObject.fertilizer = 0;
        self:growPlant(luaObject, nil, true)
        luaObject:saveData()
    elseif luaObject.typeOfSeed ==  "BerryBlack"  then
        luaObject.nbOfGrow = 4
        luaObject.fertilizer = 0;
        self:growPlant(luaObject, nil, true)
        luaObject:saveData()
    elseif luaObject.typeOfSeed ==  "Pineapple" then
        luaObject.nbOfGrow = 4
        luaObject.fertilizer = 0;
        self:growPlant(luaObject, nil, true)
        luaObject:saveData()
        luaObject:saveData()
    elseif luaObject.typeOfSeed ==  "Honey" then
        luaObject.nbOfGrow = 4
        luaObject.fertilizer = 0;
        self:growPlant(luaObject, nil, true)
        luaObject:saveData()
    elseif luaObject.typeOfSeed ==  "Milk" then
        luaObject.nbOfGrow = 4
        luaObject.fertilizer = 0;
        self:growPlant(luaObject, nil, true)
        luaObject:saveData()
    elseif luaObject.typeOfSeed ==  "Egg" then
        luaObject.nbOfGrow = 4
        luaObject.fertilizer = 0;
        self:growPlant(luaObject, nil, true)
        luaObject:saveData()
    elseif luaObject.typeOfSeed ==  "Wool" then
        luaObject.nbOfGrow = 4
        luaObject.fertilizer = 0;
        self:growPlant(luaObject, nil, true)
        luaObject:saveData()
	elseif luaObject.typeOfSeed ==  "Grape" then
        luaObject.nbOfGrow = 4
        luaObject.fertilizer = 0;
        self:growPlant(luaObject, nil, true)
        luaObject:saveData()
	elseif luaObject.typeOfSeed ==  "SugarCane" then
        luaObject.nbOfGrow = 4
        luaObject.fertilizer = 0;
        self:growPlant(luaObject, nil, true)
        luaObject:saveData()
    elseif luaObject.typeOfSeed ==  "Latex" then
        luaObject.nbOfGrow = 4
        luaObject.fertilizer = 0;
        self:growPlant(luaObject, nil, true)
        luaObject:saveData()
    elseif luaObject.typeOfSeed ==  "Coffee" then
        luaObject.nbOfGrow = 4
        luaObject.fertilizer = 0;
        self:growPlant(luaObject, nil, true)
        luaObject:saveData()
    elseif luaObject.typeOfSeed ==  "Pear" then
        luaObject.nbOfGrow = 4
        luaObject.fertilizer = 0;
        self:growPlant(luaObject, nil, true)
        luaObject:saveData()
	else
		self:removePlant(luaObject)
	end
end

farming_vegetableconf.getObjectName = function(plant)
	if plant.state == "plow" then return getText("Farming_Plowed_Land") end
	if plant.state == "destroy" then return getText("Farming_Destroyed") .. " " .. getText("Farming_" .. plant.typeOfSeed) end
	if plant.state == "dry" then 
		if plant.typeOfSeed == "Milk" or plant.typeOfSeed ==  "Egg" or plant.typeOfSeed ==  "Wool" or plant.typeOfSeed ==  "Beef" or plant.typeOfSeed ==  "Mutton" or plant.typeOfSeed ==  "Pork" or plant.typeOfSeed ==  "Bird" then
			return getText("Farming_WonderedOff") .. " " .. getText("Farming_" ..plant.typeOfSeed);
		end 
		if plant.typeOfSeed == "Honey" then
			return getText("Farming_DeadHive") .. " " .. getText("Farming_" ..plant.typeOfSeed);
		end 
    return getText("Farming_Receding") .. " " .. getText("Farming_" .. plant.typeOfSeed) end
	if plant.state == "rotten" then
		if plant.typeOfSeed == "Milk" or plant.typeOfSeed ==  "Egg" or plant.typeOfSeed ==  "Wool" or plant.typeOfSeed ==  "Beef" or plant.typeOfSeed ==  "Mutton" or plant.typeOfSeed ==  "Pork" or plant.typeOfSeed ==  "Bird" then
			return getText("Farming_WonderedOff") .. " " .. getText("Farming_" ..plant.typeOfSeed);
		end 
		if plant.typeOfSeed == "Honey" then
			return getText("Farming_DeadHive") .. " " .. getText("Farming_" ..plant.typeOfSeed);
		end 
	return getText("Farming_Rotten") .. " " .. getText("Farming_" .. plant.typeOfSeed) end
	
	
	if plant.nbOfGrow <= 1 then
		if plant.typeOfSeed == "Milk" or plant.typeOfSeed ==  "Egg" or plant.typeOfSeed == "Honey" or plant.typeOfSeed ==  "Wool" or plant.typeOfSeed ==  "Beef" or plant.typeOfSeed ==  "Mutton" or plant.typeOfSeed ==  "Pork" or plant.typeOfSeed ==  "Bird" then
			return getText("Farming_WaitingFor") .. " " .. getText("Farming_" ..plant.typeOfSeed);
		end 
		return getText("Farming_Seedling") .. " " .. getText("Farming_" ..plant.typeOfSeed);
	elseif plant.nbOfGrow <= 2 then
		if plant.typeOfSeed == "Milk" or plant.typeOfSeed ==  "Egg" or plant.typeOfSeed ==  "Wool" or plant.typeOfSeed ==  "Beef" or plant.typeOfSeed ==  "Mutton" or plant.typeOfSeed ==  "Pork" or plant.typeOfSeed ==  "Bird" then
            return getText("Farming_WaitingFor") .. " " .. getText("Farming_" ..plant.typeOfSeed);
		end
		if plant.typeOfSeed == "Honey" then
            return getText("Farming_Making_Product") .. " " .. getText("Farming_" ..plant.typeOfSeed);
		end
		return getText("Farming_Growing") .. " " .. getText("Farming_" ..plant.typeOfSeed); 
	elseif plant.nbOfGrow <= 4 then
		if plant.typeOfSeed == "Milk" or plant.typeOfSeed ==  "Egg" or plant.typeOfSeed ==  "Honey" or plant.typeOfSeed ==  "Wool" or plant.typeOfSeed ==  "Beef" or plant.typeOfSeed ==  "Mutton" or plant.typeOfSeed ==  "Pork" or plant.typeOfSeed ==  "Bird"  then
            return getText("Farming_Making_Product") .. " " .. getText("Farming_" ..plant.typeOfSeed);
		end
		return getText("Farming_Growing") .. " " .. getText("Farming_" ..plant.typeOfSeed); 
	elseif plant.nbOfGrow == 4 then
		if plant.typeOfSeed == "Milk" or plant.typeOfSeed ==  "Egg" or plant.typeOfSeed ==  "Honey" or plant.typeOfSeed ==  "Wool" or plant.typeOfSeed ==  "Beef" or plant.typeOfSeed ==  "Mutton" or plant.typeOfSeed ==  "Pork" or plant.typeOfSeed ==  "Bird" then
            return getText("Farming_Making_Product") .. " " .. getText("Farming_" ..plant.typeOfSeed);
		end
		return getText("Farming_Young") .. " " .. getText("Farming_" ..plant.typeOfSeed); 
	elseif plant.nbOfGrow == 5 then
		if plant.nbOfGrow == 5 and plant.typeOfSeed == "Milk" or plant.typeOfSeed ==   "Egg" or plant.typeOfSeed ==   "Honey" or plant.typeOfSeed ==  "Wool" or plant.typeOfSeed ==  "Beef" or plant.typeOfSeed ==  "Mutton" or plant.typeOfSeed ==  "Pork" or plant.typeOfSeed ==  "Bird" then
            return getText("Farming_Making_Product") .. " " .. getText("Farming_" ..plant.typeOfSeed);
		end
        return getText("Farming_Blooming") .. " " .. getText("Farming_" ..plant.typeOfSeed);
	elseif plant.nbOfGrow == 6 then
		return getText("Farming_Ready for Harvest") .. " " .. getText("Farming_" ..plant.typeOfSeed); 
	end
	return "Mystery"
end

