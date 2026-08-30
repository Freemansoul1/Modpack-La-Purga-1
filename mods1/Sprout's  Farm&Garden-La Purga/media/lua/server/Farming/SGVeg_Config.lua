require "Farming/farming_vegetableconf"


farming_vegetableconf.getSpriteName = function(plant)
	if plant.state == "plow" then return "vegetation_farming_01_1" end
	if plant.nbOfGrow <= 0 then
		return farming_vegetableconf.sprite[plant.typeOfSeed][1]
	elseif plant.nbOfGrow <= 4 then
		return farming_vegetableconf.sprite[plant.typeOfSeed][1 + plant.nbOfGrow]
	elseif plant.nbOfGrow == 5 then
		return farming_vegetableconf.sprite[plant.typeOfSeed][6]
	elseif plant.nbOfGrow == 6 then
		return farming_vegetableconf.sprite[plant.typeOfSeed][7]
	else -- rotten
		return farming_vegetableconf.sprite[plant.typeOfSeed][8]
	end
end

farming_vegetableconf.growTea = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 65;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
			if nbOfGrow == 4 then
				planting:setObjectName(farming_vegetableconf.getObjectName(planting))
				planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			end
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = false;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 236);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
			planting.hasSeed = true;
	    else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end


farming_vegetableconf.growTree = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 75;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
			if nbOfGrow == 4 then
				planting:setObjectName(farming_vegetableconf.getObjectName(planting))
				planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			end
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = false;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 236);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
			planting.hasSeed = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end


farming_vegetableconf.growFlowers = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 85;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 48);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
			planting.hasSeed = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end



------------------------------------------------------------------------------------------MEATS-----------------------------------------------------------------------------------------------------------------------

-- Cattle

farming_vegetableconf.growCattle = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water);
		planting.waterNeeded = 30;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 ) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
		else
			badPlant(water, nil, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasCompost = true;
		else
			badPlant(water, nil, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 ) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 120);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
		else
			badPlant(water, nil, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
    end
	return planting;
end

-- Egg

farming_vegetableconf.growEgg = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water);
		planting.waterNeeded = 20;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
		else
			badPlant(water, nil, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasCompost = true;
		else
			badPlant(water, nil, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 120);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
		else
			badPlant(water, nil, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()	
    end
	return planting;
end

-- Milk

farming_vegetableconf.growMilk= function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 10;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 120);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end
-- Honey

farming_vegetableconf.growHoney = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 10;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 120);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()	
    end
	return planting;
end



-------------------------------------------------------------------------------------------------------- Vegetable  ----------------------------------------------------------------------------------------------------




-- Rice

farming_vegetableconf.growRice = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 90;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 48);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
			planting.hasSeed = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end

-- PepperPlant

farming_vegetableconf.growPepperPlant = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 80;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 48);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
			planting.hasSeed = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end
-- Leek

farming_vegetableconf.growLeek = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 80;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 48);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
			planting.hasSeed = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end
---------------------------------------------------------------------------------------------------------
-- Lettuce

farming_vegetableconf.growLettuce = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 80;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 48);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
			planting.hasSeed = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end
---------------------------------------------------------------------------------------------------------
-- Onion

farming_vegetableconf.growOnion = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 60;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 224);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
			planting.hasSeed = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end
-----------------------------------------------------------------------
-- SoyBean

farming_vegetableconf.growSoyBean = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 60;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 224);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
			planting.hasSeed = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end
---------------------------------------------------------------------------------------------------------
-- Pumpkin

farming_vegetableconf.growPumpkin = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 80;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
			if nbOfGrow == 4 then
				planting:setObjectName(farming_vegetableconf.getObjectName(planting))
				planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			end
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 224);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
			planting.hasSeed = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end
---------------------------------------------------------------------------------------------------------
-- Watermelon

farming_vegetableconf.growWatermelon = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 80;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
			if nbOfGrow == 4 then
				planting:setObjectName(farming_vegetableconf.getObjectName(planting))
				planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			end
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 224);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
			planting.hasSeed = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end
-------------------------------------------------------------------------------------------
-- Zucchini
farming_vegetableconf.growZucchini = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 80;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
			if nbOfGrow == 4 then
				planting:setObjectName(farming_vegetableconf.getObjectName(planting))
				planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			end
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 224);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
			planting.hasSeed = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end
--------------------------------------------------------------------------------------------------------
-- Corn

farming_vegetableconf.growCorn = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 60;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 224);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
			planting.hasSeed = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end
---------------------------------------------------------------------------------------
-- Ginger

farming_vegetableconf.growGinger = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local waterMax = farming_vegetableconf.calcWater(planting.waterLvl, planting.waterNeededMax);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if nbOfGrow == 0 then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + waterMax + diseaseLvl);
		planting.waterNeeded = 85;
	elseif (nbOfGrow <= 4) then -- young
		if water >= 0 and waterMax >= 0 and diseaseLvl >= 0 then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + waterMax + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
			planting.waterNeededMax = farming_vegetableconf.props[planting.typeOfSeed].waterLvlMax;
		else
			badPlant(water, waterMax, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and waterMax >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + waterMax + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
		else
			badPlant(water, waterMax, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and waterMax >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 224);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
			planting.hasSeed = true;
		else
			badPlant(water, waterMax, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end
--------------------------------------------------------------------------------------------------
-- Pineapple

farming_vegetableconf.growPineapple = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 75;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 248);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
			planting.hasSeed = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end

--------------------------------------------------------------------------------------------
-- BellPepper

farming_vegetableconf.growBellPepper = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 75;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 248);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
			planting.hasSeed = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end

---------------------------------------------------------------------------------------------
-- Wheat

farming_vegetableconf.growWheat = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local waterMax = farming_vegetableconf.calcWater(planting.waterLvl, planting.waterNeededMax);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if nbOfGrow == 0 then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + waterMax + diseaseLvl);
		planting.waterNeeded = 85;
	elseif (nbOfGrow <= 4) then -- young
		if water >= 0 and waterMax >= 0 and diseaseLvl >= 0 then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + waterMax + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
			planting.waterNeededMax = farming_vegetableconf.props[planting.typeOfSeed].waterLvlMax;
		else
			badPlant(water, waterMax, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and waterMax >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + waterMax + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
		else
			badPlant(water, waterMax, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and waterMax >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 248);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
			planting.hasSeed = true;
		else
			badPlant(water, waterMax, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end
----------------------------------------------------------------------------------------------
-- SugarCane

farming_vegetableconf.growSugarCane = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local waterMax = farming_vegetableconf.calcWater(planting.waterLvl, planting.waterNeededMax);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if nbOfGrow == 0 then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + waterMax + diseaseLvl);
		planting.waterNeeded = 85;
	elseif (nbOfGrow <= 4) then -- young
		if water >= 0 and waterMax >= 0 and diseaseLvl >= 0 then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + waterMax + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
			planting.waterNeededMax = farming_vegetableconf.props[planting.typeOfSeed].waterLvlMax;
		else
			badPlant(water, waterMax, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and waterMax >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + waterMax + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
		else
			badPlant(water, waterMax, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and waterMax >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 248);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
			planting.hasSeed = true;
		else
			badPlant(water, waterMax, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end
----------------------------------------------------------------------------------------------
-- Ginseng

farming_vegetableconf.growGinseng = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local waterMax = farming_vegetableconf.calcWater(planting.waterLvl, planting.waterNeededMax);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if nbOfGrow == 0 then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + waterMax + diseaseLvl);
		planting.waterNeeded = 85;
	elseif (nbOfGrow <= 4) then -- young
		if water >= 0 and waterMax >= 0 and diseaseLvl >= 0 then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + waterMax + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
			planting.waterNeededMax = farming_vegetableconf.props[planting.typeOfSeed].waterLvlMax;
		else
			badPlant(water, waterMax, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and waterMax >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + waterMax + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
		else
			badPlant(water, waterMax, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and waterMax >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 96);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
			planting.hasSeed = true;
		else
			badPlant(water, waterMax, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end
----------------------------------------------------------------------------------------------------
-- BerryBlack
farming_vegetableconf.growBerryBlack= function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local waterMax = farming_vegetableconf.calcWater(planting.waterLvl, planting.waterNeededMax);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if nbOfGrow == 0 then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + waterMax + diseaseLvl);
		planting.waterNeeded = 85;
	elseif (nbOfGrow <= 4) then -- young
		if water >= 0 and waterMax >= 0 and diseaseLvl >= 0 then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + waterMax + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
			planting.waterNeededMax = farming_vegetableconf.props[planting.typeOfSeed].waterLvlMax;
		else
			badPlant(water, waterMax, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and waterMax >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + waterMax + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
		else
			badPlant(water, waterMax, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and waterMax >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 96);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
			planting.hasSeed = true;
		else
			badPlant(water, waterMax, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end

----------------------------------------------------------------------------------------------------
-- BerryBlue

farming_vegetableconf.growBerryBlue = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 80;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
			if nbOfGrow == 4 then
				planting:setObjectName(farming_vegetableconf.getObjectName(planting))
				planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			end
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 248);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
			planting.hasSeed = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end

----------------------------------------------------------------------------------------------------
-- Lemongrass

farming_vegetableconf.growLemongrass = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 80;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
			if nbOfGrow == 4 then
				planting:setObjectName(farming_vegetableconf.getObjectName(planting))
				planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			end
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 248);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
			planting.hasSeed = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end

---------------------------------------------------------------------------------------------------------
-- Mushroom

farming_vegetableconf.growMushroom = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 80;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
			if nbOfGrow == 4 then
				planting:setObjectName(farming_vegetableconf.getObjectName(planting))
				planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			end
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 224);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
			planting.hasSeed = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end
---------------------------------------------------------------------------------------------
-- Eggplant

farming_vegetableconf.growEggplant = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 80;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 96);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
			planting.hasSeed = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end
-----------------------------------------------------------------------------------------
-- Grape

farming_vegetableconf.growGrape = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 80;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 96);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
			planting.hasSeed = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end


------------------------------  Trees  -----------------------------
-- Lemon

farming_vegetableconf.growLemon = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 85;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = false;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 236);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end

farming_vegetableconf.growOrange = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 85;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = false;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 236);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end

farming_vegetableconf.growApple = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 85;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = false;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 236);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end

farming_vegetableconf.growOlive = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 85;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = false;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 236);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end

farming_vegetableconf.growPeach = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
	    planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 85;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = false;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
	    if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 236);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end

farming_vegetableconf.growBanana = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 85;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);		
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = false;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 236);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end

farming_vegetableconf.growCherry = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 85;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = false;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 236);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end

farming_vegetableconf.growLime = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 85;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = false;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 236);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end

farming_vegetableconf.growAvocado = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 85;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
			if nbOfGrow == 4 then
				planting:setObjectName(farming_vegetableconf.getObjectName(planting))
				planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			end
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = false;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 236);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end

farming_vegetableconf.growGrapeFruit = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 85;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
			if nbOfGrow == 4 then
				planting:setObjectName(farming_vegetableconf.getObjectName(planting))
				planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			end
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = false;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 236);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end

farming_vegetableconf.growMango = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 85;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
			if nbOfGrow == 4 then
				planting:setObjectName(farming_vegetableconf.getObjectName(planting))
				planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			end
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = false;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 236);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end


farming_vegetableconf.growCotton = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 65;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
			if nbOfGrow == 4 then
				planting:setObjectName(farming_vegetableconf.getObjectName(planting))
				planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			end
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = false;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 236);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
			planting.hasSeed = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end


farming_vegetableconf.growHops = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow == 0) then -- young
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 75;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
			if nbOfGrow == 4 then
				planting:setObjectName(farming_vegetableconf.getObjectName(planting))
				planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			end
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = false;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature 
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 236);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
			planting.hasSeed = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end






--Icons

farming_vegetableconf.icons["Mongui"] = "media/textures/Item_Mongui.png";
farming_vegetableconf.icons["Opio"] = "media/textures/Item_Opium_Latex.png";
farming_vegetableconf.icons["Coca"] = "media/textures/Item_HojadeCoca.png";

farming_vegetableconf.icons["Kief"] = "media/textures/Item_WetBuds.png";
farming_vegetableconf.icons["Sativa"] = "media/textures/Item_WetBuds.png";
farming_vegetableconf.icons["Indica"] = "media/textures/Item_WetBuds.png";
farming_vegetableconf.icons["Tobacco"] = "media/textures/Item_Tobaccoleaf.png";

farming_vegetableconf.icons["Tea"] = "media/textures/Item_TeaLeaf.png";
farming_vegetableconf.icons["Coffee"] = "media/textures/Item_CoffeeBeans.png";
farming_vegetableconf.icons["Latex"] = "media/textures/Item_TreeLatex.png";

farming_vegetableconf.icons["Rose"] = "media/textures/Item_RedRose.png";
farming_vegetableconf.icons["Carnation"] = "media/textures/Item_PinkCarnation.png";
farming_vegetableconf.icons["Larkspur"] = "media/textures/Item_WhiteLarkspur.png";
farming_vegetableconf.icons["Dahlia"] = "media/textures/Item_OrangeDahlia.png";
farming_vegetableconf.icons["Delphi"] = "media/textures/Item_BlueDelphinium.png";
farming_vegetableconf.icons["Daisy"] = "media/textures/Item_YellowDaisy.png";
farming_vegetableconf.icons["Penta"] = "media/textures/Item_MagentaPenta.png";
farming_vegetableconf.icons["Geranium"] = "media/textures/Item_BlackGeranium.png";


farming_vegetableconf.icons["Bird"] = "Item_Chicken";
farming_vegetableconf.icons["Mutton"] = "media/textures/WorldItems/MuttonChop.png";
farming_vegetableconf.icons["Pork"] = "Item_Ham";
farming_vegetableconf.icons["Beef"] = "Item_Steak";


farming_vegetableconf.icons["Wool"] = "media/textures/Item_Wool.png";
farming_vegetableconf.icons["Milk"] = "Item_Milk";
farming_vegetableconf.icons["Egg"] = "Item_Egg";
farming_vegetableconf.icons["Honey"] = "Item_Honey";


farming_vegetableconf.icons["Radishes"] = "Item_Radish";
farming_vegetableconf.icons["Strawberry plant"] = "Item_BerryStraw";
farming_vegetableconf.icons["Tomato"] = "Item_Tomato";
farming_vegetableconf.icons["Potatoes"] = "Item_Potato";
farming_vegetableconf.icons["Cabbages"] = "Item_Cabbage";

farming_vegetableconf.icons["Leek"] = "Item_Leek";
farming_vegetableconf.icons["Lettuce"] = "Item_Lettuce";
farming_vegetableconf.icons["Onion"] = "Item_Onion";
farming_vegetableconf.icons["SoyBean"] = "media/textures/Item_SoyBean.png";
farming_vegetableconf.icons["Pumpkin"] = "Item_Pumpkin";

farming_vegetableconf.icons["Watermelon"] = "Item_Watermelon";
farming_vegetableconf.icons["Zucchini"] = "Item_Zucchini";
farming_vegetableconf.icons["Corn"] = "Item_Corn";
farming_vegetableconf.icons["Ginger"] = "media/textures/Ginger.png";

farming_vegetableconf.icons["Pineapple"] = "Item_Pineapple";
farming_vegetableconf.icons["Wheat"] = "media/textures/Item_Wheat.png";
farming_vegetableconf.icons["SugarCane"] = "media/textures/Item_SugarCane.png";
farming_vegetableconf.icons["Ginseng"] = "Item_Ginseng";

farming_vegetableconf.icons["Mushroom"] = "Item_Mushroom_Generic_1";
farming_vegetableconf.icons["BellPepper"] = "Item_BellPepper";
farming_vegetableconf.icons["Eggplant"] = "Item_Eggplant";
farming_vegetableconf.icons["Grape"] = "Item_Grapes";

farming_vegetableconf.icons["BerryBlack"] = "Item_BerryBlack";
farming_vegetableconf.icons["BerryBlue"] = "Item_BerryBlue";
farming_vegetableconf.icons["Lemongrass"] = "media/textures/WorldItems/Lemongrass.png";

farming_vegetableconf.icons["Lemon"] = "Item_Lemon";
farming_vegetableconf.icons["Orange"] = "Item_Orange";
farming_vegetableconf.icons["Apple"] = "Item_Apple";
farming_vegetableconf.icons["Olive"] = "media/textures/Item_olive.png";
farming_vegetableconf.icons["Peach"] = "Item_Peach";
farming_vegetableconf.icons["Banana"] = "Item_Banana";
farming_vegetableconf.icons["Cherry"] = "Item_Cherry";
farming_vegetableconf.icons["Lime"] = "Item_Lime";
farming_vegetableconf.icons["Avocado"] = "media/textures/WorldItems/Avocado.png";
farming_vegetableconf.icons["Mango"] = "Item_Mango";
farming_vegetableconf.icons["GrapeFruit"] = "Item_Grapefruit";

farming_vegetableconf.icons["Rice"] = "Item_Rice";
farming_vegetableconf.icons["PepperPlant"] = "media/textures/Item_PepperPlant.png";
farming_vegetableconf.icons["Cotton"] = "media/textures/Item_Cotton.png";
farming_vegetableconf.icons["Hops"] = "media/textures/Item_Hops.png";


--props


-- Tea
farming_vegetableconf.props["Tea"] = {};
farming_vegetableconf.props["Tea"].seedsRequired = 4;
farming_vegetableconf.props["Tea"].texture = "trees2_01_6";
farming_vegetableconf.props["Tea"].waterLvl = 85;
farming_vegetableconf.props["Tea"].timeToGrow = ZombRand(80, 100);
farming_vegetableconf.props["Tea"].minVeg = 4;
farming_vegetableconf.props["Tea"].maxVeg = 6;
farming_vegetableconf.props["Tea"].minVegAutorized = 8;
farming_vegetableconf.props["Tea"].maxVegAutorized = 10;
farming_vegetableconf.props["Tea"].vegetableName = "Sprout.TeaLeaf";
farming_vegetableconf.props["Tea"].growCode = "farming_vegetableconf.growTea";
farming_vegetableconf.props["Tea"].seedName = "Sprout.TeaSeed";
farming_vegetableconf.props["Tea"].seedPerVeg = ZombRand(1,5);
farming_vegetableconf.props["Tea"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Tea"].phaseName6 = "Farming_Ready for Harvest";

-- Coffee
farming_vegetableconf.props["Coffee"] = {};
farming_vegetableconf.props["Coffee"].seedsRequired = 6;
farming_vegetableconf.props["Coffee"].texture = "trees2_01_14";
farming_vegetableconf.props["Coffee"].waterLvl = 85;
farming_vegetableconf.props["Coffee"].timeToGrow = ZombRand(80, 100);
farming_vegetableconf.props["Coffee"].minVeg = 4;
farming_vegetableconf.props["Coffee"].maxVeg = 6;
farming_vegetableconf.props["Coffee"].minVegAutorized = 8;
farming_vegetableconf.props["Coffee"].maxVegAutorized = 10;
farming_vegetableconf.props["Coffee"].vegetableName = "Sprout.CoffeeBeans";
farming_vegetableconf.props["Coffee"].growCode = "farming_vegetableconf.growTree";
farming_vegetableconf.props["Coffee"].seedName = "Sprout.CoffeeSeed";
farming_vegetableconf.props["Coffee"].seedPerVeg = ZombRand(1,5);
farming_vegetableconf.props["Coffee"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Coffee"].phaseName6 = "Farming_Ready for Harvest";

-- Latex
farming_vegetableconf.props["Latex"] = {};
farming_vegetableconf.props["Latex"].seedsRequired = 6;
farming_vegetableconf.props["Latex"].texture = "trees2_01_22";
farming_vegetableconf.props["Latex"].waterLvl = 85;
farming_vegetableconf.props["Latex"].timeToGrow = ZombRand(80, 100);
farming_vegetableconf.props["Latex"].minVeg = 4;
farming_vegetableconf.props["Latex"].maxVeg = 6;
farming_vegetableconf.props["Latex"].minVegAutorized = 8;
farming_vegetableconf.props["Latex"].maxVegAutorized = 10;
farming_vegetableconf.props["Latex"].vegetableName = "Sprout.TreeLatex";
farming_vegetableconf.props["Latex"].growCode = "farming_vegetableconf.growTree";
farming_vegetableconf.props["Latex"].seedName = "Sprout.RubberSeed";
farming_vegetableconf.props["Latex"].seedPerVeg = ZombRand(1,5);
farming_vegetableconf.props["Latex"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Latex"].phaseName6 = "Farming_Ready for Harvest";


farming_vegetableconf.props["Sativa"] = {};
farming_vegetableconf.props["Sativa"].seedsRequired = 4;
farming_vegetableconf.props["Sativa"].texture = "weed_01_6";
farming_vegetableconf.props["Sativa"].waterLvl = 85;
farming_vegetableconf.props["Sativa"].timeToGrow = ZombRand(46, 52);
farming_vegetableconf.props["Sativa"].vegetableName = "Sprout.SativaBuds";
farming_vegetableconf.props["Sativa"].seedName = "Sprout.SativaSeeds";
farming_vegetableconf.props["Sativa"].growCode = "farming_vegetableconf.growFlowers";
farming_vegetableconf.props["Sativa"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Sativa"].minVeg = 3;
farming_vegetableconf.props["Sativa"].maxVeg = 6;
farming_vegetableconf.props["Sativa"].minVegAutorized = 10;
farming_vegetableconf.props["Sativa"].maxVegAutorized = 15;
farming_vegetableconf.props["Sativa"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Sativa"].phaseName6 = "Farming_Ready for Harvest";

farming_vegetableconf.props["Kief"] = {};
farming_vegetableconf.props["Kief"].seedsRequired = 6;
farming_vegetableconf.props["Kief"].texture = "weed_01_6";
farming_vegetableconf.props["Kief"].waterLvl = 85;
farming_vegetableconf.props["Kief"].timeToGrow = ZombRand(46, 52);
farming_vegetableconf.props["Kief"].vegetableName = "Sprout.KiefBuds";
farming_vegetableconf.props["Kief"].seedName = "Sprout.KiefSeeds";
farming_vegetableconf.props["Kief"].growCode = "farming_vegetableconf.growFlowers";
farming_vegetableconf.props["Kief"].seedPerVeg = ZombRand(0,0);
farming_vegetableconf.props["Kief"].minVeg = 3;
farming_vegetableconf.props["Kief"].maxVeg = 6;
farming_vegetableconf.props["Kief"].minVegAutorized = 10;
farming_vegetableconf.props["Kief"].maxVegAutorized = 15;
farming_vegetableconf.props["Kief"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Kief"].phaseName6 = "Farming_Ready for Harvest";

farming_vegetableconf.props["Indica"] = {};
farming_vegetableconf.props["Indica"].seedsRequired = 4;
farming_vegetableconf.props["Indica"].texture = "weed_01_14";
farming_vegetableconf.props["Indica"].waterLvl = 85;
farming_vegetableconf.props["Indica"].timeToGrow = ZombRand(46, 52);
farming_vegetableconf.props["Indica"].vegetableName = "Sprout.IndicaBuds";
farming_vegetableconf.props["Indica"].seedName = "Sprout.IndicaSeeds";
farming_vegetableconf.props["Indica"].growCode = "farming_vegetableconf.growFlowers";
farming_vegetableconf.props["Indica"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Indica"].minVeg = 3;
farming_vegetableconf.props["Indica"].maxVeg = 6;
farming_vegetableconf.props["Indica"].minVegAutorized = 10;
farming_vegetableconf.props["Indica"].maxVegAutorized = 15;
farming_vegetableconf.props["Indica"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Indica"].phaseName6 = "Farming_Ready for Harvest";

farming_vegetableconf.props["Tobacco"] = {};
farming_vegetableconf.props["Tobacco"].seedsRequired = 4;
farming_vegetableconf.props["Tobacco"].texture = "weed_01_22";
farming_vegetableconf.props["Tobacco"].waterLvl = 85;
farming_vegetableconf.props["Tobacco"].timeToGrow = ZombRand(46, 52);
farming_vegetableconf.props["Tobacco"].vegetableName = "Sprout.Tobaccoleaf";
farming_vegetableconf.props["Tobacco"].seedName = "Sprout.TobaccoSeeds";
farming_vegetableconf.props["Tobacco"].growCode = "farming_vegetableconf.growFlowers";
farming_vegetableconf.props["Tobacco"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Tobacco"].minVeg = 3;
farming_vegetableconf.props["Tobacco"].maxVeg = 6;
farming_vegetableconf.props["Tobacco"].minVegAutorized = 10;
farming_vegetableconf.props["Tobacco"].maxVegAutorized = 15;
farming_vegetableconf.props["Tobacco"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Tobacco"].phaseName6 = "Farming_Ready for Harvest";

farming_vegetableconf.props["Rose"] = {};
farming_vegetableconf.props["Rose"].seedsRequired = 6;
farming_vegetableconf.props["Rose"].texture = "flowergarden_01_46";
farming_vegetableconf.props["Rose"].waterLvl = 85;
farming_vegetableconf.props["Rose"].timeToGrow = ZombRand(46, 52);
farming_vegetableconf.props["Rose"].vegetableName = "Sprout.RedRose";
farming_vegetableconf.props["Rose"].seedName = "Sprout.RedRoseSeed";
farming_vegetableconf.props["Rose"].growCode = "farming_vegetableconf.growFlowers";
farming_vegetableconf.props["Rose"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Rose"].minVeg = 3;
farming_vegetableconf.props["Rose"].maxVeg = 6;
farming_vegetableconf.props["Rose"].minVegAutorized = 10;
farming_vegetableconf.props["Rose"].maxVegAutorized = 15;
farming_vegetableconf.props["Rose"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Rose"].phaseName6 = "Farming_Ready for Harvest";


farming_vegetableconf.props["Carnation"] = {};
farming_vegetableconf.props["Carnation"].seedsRequired = 6;
farming_vegetableconf.props["Carnation"].texture = "flowergarden_01_6";
farming_vegetableconf.props["Carnation"].waterLvl = 85;
farming_vegetableconf.props["Carnation"].timeToGrow = ZombRand(46, 52);
farming_vegetableconf.props["Carnation"].vegetableName = "Sprout.PinkCarnation";
farming_vegetableconf.props["Carnation"].seedName = "Sprout.PinkCarnationSeed";
farming_vegetableconf.props["Carnation"].growCode = "farming_vegetableconf.growFlowers";
farming_vegetableconf.props["Carnation"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Carnation"].minVeg = 3;
farming_vegetableconf.props["Carnation"].maxVeg = 6;
farming_vegetableconf.props["Carnation"].minVegAutorized = 10;
farming_vegetableconf.props["Carnation"].maxVegAutorized = 15;
farming_vegetableconf.props["Carnation"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Carnation"].phaseName6 = "Farming_Ready for Harvest";

farming_vegetableconf.props["Larkspur"] = {};
farming_vegetableconf.props["Larkspur"].seedsRequired = 6;
farming_vegetableconf.props["Larkspur"].texture = "flowergarden_01_38";
farming_vegetableconf.props["Larkspur"].waterLvl = 85;
farming_vegetableconf.props["Larkspur"].timeToGrow = ZombRand(46, 52);
farming_vegetableconf.props["Larkspur"].vegetableName = "Sprout.WhiteLarkspur";
farming_vegetableconf.props["Larkspur"].seedName = "Sprout.WhiteLarkspurSeed";
farming_vegetableconf.props["Larkspur"].growCode = "farming_vegetableconf.growFlowers";
farming_vegetableconf.props["Larkspur"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Larkspur"].minVeg = 3;
farming_vegetableconf.props["Larkspur"].maxVeg = 6;
farming_vegetableconf.props["Larkspur"].minVegAutorized = 10;
farming_vegetableconf.props["Larkspur"].maxVegAutorized = 15;
farming_vegetableconf.props["Larkspur"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Larkspur"].phaseName6 = "Farming_Ready for Harvest";

farming_vegetableconf.props["Dahlia"] = {};
farming_vegetableconf.props["Dahlia"].seedsRequired = 6;
farming_vegetableconf.props["Dahlia"].texture = "flowergarden_01_15";
farming_vegetableconf.props["Dahlia"].waterLvl = 85;
farming_vegetableconf.props["Dahlia"].timeToGrow = ZombRand(46, 52);
farming_vegetableconf.props["Dahlia"].vegetableName = "Sprout.OrangeDahlia";
farming_vegetableconf.props["Dahlia"].seedName = "Sprout.OrangeDahliaSeed";
farming_vegetableconf.props["Dahlia"].growCode = "farming_vegetableconf.growFlowers";
farming_vegetableconf.props["Dahlia"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Dahlia"].minVeg = 3;
farming_vegetableconf.props["Dahlia"].maxVeg = 6;
farming_vegetableconf.props["Dahlia"].minVegAutorized = 10;
farming_vegetableconf.props["Dahlia"].maxVegAutorized = 15;
farming_vegetableconf.props["Dahlia"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Dahlia"].phaseName6 = "Farming_Ready for Harvest";

farming_vegetableconf.props["Delphi"] = {};
farming_vegetableconf.props["Delphi"].seedsRequired = 6;
farming_vegetableconf.props["Delphi"].texture = "flowergarden_01_30";
farming_vegetableconf.props["Delphi"].waterLvl = 85;
farming_vegetableconf.props["Delphi"].timeToGrow = ZombRand(46, 52);
farming_vegetableconf.props["Delphi"].vegetableName = "Sprout.BlueDelphinium";
farming_vegetableconf.props["Delphi"].seedName = "Sprout.BlueDelphiniumSeed";
farming_vegetableconf.props["Delphi"].growCode = "farming_vegetableconf.growFlowers";
farming_vegetableconf.props["Delphi"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Delphi"].minVeg = 3;
farming_vegetableconf.props["Delphi"].maxVeg = 6;
farming_vegetableconf.props["Delphi"].minVegAutorized = 10;
farming_vegetableconf.props["Delphi"].maxVegAutorized = 15;
farming_vegetableconf.props["Delphi"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Delphi"].phaseName6 = "Farming_Ready for Harvest";

farming_vegetableconf.props["Daisy"] = {};
farming_vegetableconf.props["Daisy"].seedsRequired = 6;
farming_vegetableconf.props["Daisy"].texture = "flowergarden_01_22";
farming_vegetableconf.props["Daisy"].waterLvl = 85;
farming_vegetableconf.props["Daisy"].timeToGrow = ZombRand(46, 52);
farming_vegetableconf.props["Daisy"].vegetableName = "Sprout.YellowDaisy";
farming_vegetableconf.props["Daisy"].seedName = "Sprout.YellowDaisySeed";
farming_vegetableconf.props["Daisy"].growCode = "farming_vegetableconf.growFlowers";
farming_vegetableconf.props["Daisy"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Daisy"].minVeg = 3;
farming_vegetableconf.props["Daisy"].maxVeg = 6;
farming_vegetableconf.props["Daisy"].minVegAutorized = 10;
farming_vegetableconf.props["Daisy"].maxVegAutorized = 15;
farming_vegetableconf.props["Daisy"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Daisy"].phaseName6 = "Farming_Ready for Harvest";

farming_vegetableconf.props["Penta"] = {};
farming_vegetableconf.props["Penta"].seedsRequired = 6;
farming_vegetableconf.props["Penta"].texture = "flowergarden_01_54";
farming_vegetableconf.props["Penta"].waterLvl = 85;
farming_vegetableconf.props["Penta"].timeToGrow = ZombRand(46, 52);
farming_vegetableconf.props["Penta"].vegetableName = "Sprout.MagentaPenta";
farming_vegetableconf.props["Penta"].seedName = "Sprout.MagentaPentaSeed";
farming_vegetableconf.props["Penta"].growCode = "farming_vegetableconf.growFlowers";
farming_vegetableconf.props["Penta"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Penta"].minVeg = 3;
farming_vegetableconf.props["Penta"].maxVeg = 6;
farming_vegetableconf.props["Penta"].minVegAutorized = 10;
farming_vegetableconf.props["Penta"].maxVegAutorized = 15;
farming_vegetableconf.props["Penta"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Penta"].phaseName6 = "Farming_Ready for Harvest";

farming_vegetableconf.props["Amapola"] = {};
farming_vegetableconf.props["Amapola"].seedsRequired = 6;
farming_vegetableconf.props["Amapola"].texture = "flowergarden_01_54";
farming_vegetableconf.props["Amapola"].waterLvl = 85;
farming_vegetableconf.props["Amapola"].timeToGrow = ZombRand(46, 52);
farming_vegetableconf.props["Amapola"].vegetableName = "Sprout.Opio";
farming_vegetableconf.props["Amapola"].seedName = "Sprout.AmapolaSeeds";
farming_vegetableconf.props["Amapola"].growCode = "farming_vegetableconf.growFlowers";
farming_vegetableconf.props["Amapola"].seedPerVeg = ZombRand(0,0);
farming_vegetableconf.props["Amapola"].minVeg = 3;
farming_vegetableconf.props["Amapola"].maxVeg = 6;
farming_vegetableconf.props["Amapola"].minVegAutorized = 10;
farming_vegetableconf.props["Amapola"].maxVegAutorized = 15;
farming_vegetableconf.props["Amapola"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Amapola"].phaseName6 = "Farming_Ready for Harvest";

farming_vegetableconf.props["Geranium"] = {};
farming_vegetableconf.props["Geranium"].seedsRequired = 6;
farming_vegetableconf.props["Geranium"].texture = "flowergarden_01_62";
farming_vegetableconf.props["Geranium"].waterLvl = 85;
farming_vegetableconf.props["Geranium"].timeToGrow = ZombRand(46, 52);
farming_vegetableconf.props["Geranium"].vegetableName = "Sprout.BlackGeranium";
farming_vegetableconf.props["Geranium"].seedName = "Sprout.BlackGeraniumSeed";
farming_vegetableconf.props["Geranium"].growCode = "farming_vegetableconf.growFlowers";
farming_vegetableconf.props["Geranium"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Geranium"].minVeg = 3;
farming_vegetableconf.props["Geranium"].maxVeg = 6;
farming_vegetableconf.props["Geranium"].minVegAutorized = 10;
farming_vegetableconf.props["Geranium"].maxVegAutorized = 15;
farming_vegetableconf.props["Geranium"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Geranium"].phaseName6 = "Farming_Ready for Harvest";

---------------------------------------------------------MEATS---------------------------------------------------


-- Bird 
farming_vegetableconf.props["Bird"] = {};
farming_vegetableconf.props["Bird"].seedsRequired = 1;
farming_vegetableconf.props["Bird"].texture = "milk_and_honey_02_62";
farming_vegetableconf.props["Bird"].waterLvl = 10;
farming_vegetableconf.props["Bird"].timeToGrow = ZombRand(24, 48);
farming_vegetableconf.props["Bird"].vegetableName = "Sprout.BirdMeat";
farming_vegetableconf.props["Bird"].seedName = "Sprout.BirdFeed";
farming_vegetableconf.props["Bird"].growCode = "farming_vegetableconf.growCattle";
farming_vegetableconf.props["Bird"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Bird"].minVeg = 3;
farming_vegetableconf.props["Bird"].maxVeg = 6;
farming_vegetableconf.props["Bird"].minVegAutorized = 10;
farming_vegetableconf.props["Bird"].maxVegAutorized = 15;
farming_vegetableconf.props["Bird"].phaseName1 = "Farming_WaitingFor";
farming_vegetableconf.props["Bird"].phaseName2 = "Farming_WaitingFor";
farming_vegetableconf.props["Bird"].phaseName3 = "Farming_Getting_Settled";
farming_vegetableconf.props["Bird"].phaseName4 = "Farming_Making_Product";
farming_vegetableconf.props["Bird"].phaseName5 = "Farming_Making_Product";
farming_vegetableconf.props["Bird"].phaseName6 = "Farming_Ready for Harvest";
farming_vegetableconf.props["Bird"].phaseNameDry = "Farming_WonderedOff";
farming_vegetableconf.props["Bird"].phaseNameRotten = "Farming_WonderedOff";

-- Mutton 
farming_vegetableconf.props["Mutton"] = {};
farming_vegetableconf.props["Mutton"].seedsRequired = 1;
farming_vegetableconf.props["Mutton"].texture = "milk_and_honey_02_54";
farming_vegetableconf.props["Mutton"].waterLvl = 10;
farming_vegetableconf.props["Mutton"].timeToGrow = ZombRand(24, 48);
farming_vegetableconf.props["Mutton"].vegetableName = "Base.MuttonChop";
farming_vegetableconf.props["Mutton"].seedName = "Sprout.MuttonFeed";
farming_vegetableconf.props["Mutton"].growCode = "farming_vegetableconf.growCattle";
farming_vegetableconf.props["Mutton"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Mutton"].minVeg = 3;
farming_vegetableconf.props["Mutton"].maxVeg = 6;
farming_vegetableconf.props["Mutton"].minVegAutorized = 10;
farming_vegetableconf.props["Mutton"].maxVegAutorized = 15;
farming_vegetableconf.props["Mutton"].phaseName1 = "Farming_WaitingFor";
farming_vegetableconf.props["Mutton"].phaseName2 = "Farming_WaitingFor";
farming_vegetableconf.props["Mutton"].phaseName3 = "Farming_Getting_Settled";
farming_vegetableconf.props["Mutton"].phaseName4 = "Farming_Making_Product";
farming_vegetableconf.props["Mutton"].phaseName5 = "Farming_Making_Product";
farming_vegetableconf.props["Mutton"].phaseName6 = "Farming_Ready for Harvest";
farming_vegetableconf.props["Mutton"].phaseNameDry = "Farming_WonderedOff";
farming_vegetableconf.props["Mutton"].phaseNameRotten = "Farming_WonderedOff";

-- Pork 
farming_vegetableconf.props["Pork"] = {};
farming_vegetableconf.props["Pork"].seedsRequired = 1;
farming_vegetableconf.props["Pork"].texture = "milk_and_honey_02_46";
farming_vegetableconf.props["Pork"].waterLvl = 10;
farming_vegetableconf.props["Pork"].timeToGrow = ZombRand(24, 48);
farming_vegetableconf.props["Pork"].vegetableName = "Base.Ham";
farming_vegetableconf.props["Pork"].seedName = "Sprout.PigFeed";
farming_vegetableconf.props["Pork"].growCode = "farming_vegetableconf.growCattle";
farming_vegetableconf.props["Pork"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Pork"].minVeg = 3;
farming_vegetableconf.props["Pork"].maxVeg = 6;
farming_vegetableconf.props["Pork"].minVegAutorized = 10;
farming_vegetableconf.props["Pork"].maxVegAutorized = 15;
farming_vegetableconf.props["Pork"].phaseName1 = "Farming_WaitingFor";
farming_vegetableconf.props["Pork"].phaseName2 = "Farming_WaitingFor";
farming_vegetableconf.props["Pork"].phaseName3 = "Farming_Getting_Settled";
farming_vegetableconf.props["Pork"].phaseName4 = "Farming_Making_Product";
farming_vegetableconf.props["Pork"].phaseName5 = "Farming_Making_Product";
farming_vegetableconf.props["Pork"].phaseName6 = "Farming_Ready for Harvest";
farming_vegetableconf.props["Pork"].phaseNameDry = "Farming_WonderedOff";
farming_vegetableconf.props["Pork"].phaseNameRotten = "Farming_WonderedOff";

-- Beef 
farming_vegetableconf.props["Beef"] = {};
farming_vegetableconf.props["Beef"].seedsRequired = 1;
farming_vegetableconf.props["Beef"].texture = "milk_and_honey_02_38";
farming_vegetableconf.props["Beef"].waterLvl = 10;
farming_vegetableconf.props["Beef"].timeToGrow = ZombRand(24, 48);
farming_vegetableconf.props["Beef"].vegetableName = "Base.Steak";
farming_vegetableconf.props["Beef"].seedName = "Sprout.CattleFeed";
farming_vegetableconf.props["Beef"].growCode = "farming_vegetableconf.growCattle";
farming_vegetableconf.props["Beef"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Beef"].minVeg = 3;
farming_vegetableconf.props["Beef"].maxVeg = 6;
farming_vegetableconf.props["Beef"].minVegAutorized = 10;
farming_vegetableconf.props["Beef"].maxVegAutorized = 15;
farming_vegetableconf.props["Beef"].phaseName1 = "Farming_WaitingFor";
farming_vegetableconf.props["Beef"].phaseName2 = "Farming_WaitingFor";
farming_vegetableconf.props["Beef"].phaseName3 = "Farming_Getting_Settled";
farming_vegetableconf.props["Beef"].phaseName4 = "Farming_Making_Product";
farming_vegetableconf.props["Beef"].phaseName5 = "Farming_Making_Product";
farming_vegetableconf.props["Beef"].phaseName6 = "Farming_Ready for Harvest";
farming_vegetableconf.props["Beef"].phaseNameDry = "Farming_WonderedOff";
farming_vegetableconf.props["Beef"].phaseNameRotten = "Farming_WonderedOff";


--------------------------------------------------------- NON MEATS ---------------------------------------------------


-- Wool 
farming_vegetableconf.props["Wool"] = {};
farming_vegetableconf.props["Wool"].seedsRequired = 1;
farming_vegetableconf.props["Wool"].texture = "milk_and_honey_02_30";
farming_vegetableconf.props["Wool"].waterLvl = 10;
farming_vegetableconf.props["Wool"].timeToGrow = ZombRand(24, 48);
farming_vegetableconf.props["Wool"].vegetableName = "Sprout.Wool";
farming_vegetableconf.props["Wool"].seedName = "Sprout.SheepFeed";
farming_vegetableconf.props["Wool"].growCode = "farming_vegetableconf.growCattle";
farming_vegetableconf.props["Wool"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Wool"].minVeg = 3;
farming_vegetableconf.props["Wool"].maxVeg = 6;
farming_vegetableconf.props["Wool"].minVegAutorized = 10;
farming_vegetableconf.props["Wool"].maxVegAutorized = 15;
farming_vegetableconf.props["Wool"].phaseName1 = "Farming_WaitingFor";
farming_vegetableconf.props["Wool"].phaseName2 = "Farming_WaitingFor";
farming_vegetableconf.props["Wool"].phaseName3 = "Farming_Getting_Settled";
farming_vegetableconf.props["Wool"].phaseName4 = "Farming_Making_Product";
farming_vegetableconf.props["Wool"].phaseName5 = "Farming_Making_Product";
farming_vegetableconf.props["Wool"].phaseName6 = "Farming_Ready for Harvest";
farming_vegetableconf.props["Wool"].phaseNameDry = "Farming_WonderedOff";
farming_vegetableconf.props["Wool"].phaseNameRotten = "Farming_WonderedOff";

-- Milk 
farming_vegetableconf.props["Milk"] = {};
farming_vegetableconf.props["Milk"].seedsRequired = 1;
farming_vegetableconf.props["Milk"].texture = "milk_and_honey_02_8";
farming_vegetableconf.props["Milk"].waterLvl = 10;
farming_vegetableconf.props["Milk"].timeToGrow = ZombRand(24, 48);
farming_vegetableconf.props["Milk"].vegetableName = "Base.Milk";
farming_vegetableconf.props["Milk"].seedName = "Sprout.CowFeed";
farming_vegetableconf.props["Milk"].growCode = "farming_vegetableconf.growMilk";
farming_vegetableconf.props["Milk"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Milk"].minVeg = 3;
farming_vegetableconf.props["Milk"].maxVeg = 6;
farming_vegetableconf.props["Milk"].minVegAutorized = 10;
farming_vegetableconf.props["Milk"].maxVegAutorized = 15;
farming_vegetableconf.props["Milk"].phaseName1 = "Farming_WaitingFor";
farming_vegetableconf.props["Milk"].phaseName2 = "Farming_WaitingFor";
farming_vegetableconf.props["Milk"].phaseName3 = "Farming_Getting_Settled";
farming_vegetableconf.props["Milk"].phaseName4 = "Farming_Making_Product";
farming_vegetableconf.props["Milk"].phaseName5 = "Farming_Making_Product";
farming_vegetableconf.props["Milk"].phaseName6 = "Farming_Ready for Harvest";
farming_vegetableconf.props["Milk"].phaseNameDry = "Farming_WonderedOff";
farming_vegetableconf.props["Milk"].phaseNameRotten = "Farming_WonderedOff";

-- Egg 
farming_vegetableconf.props["Egg"] = {};
farming_vegetableconf.props["Egg"].seedsRequired = 1;
farming_vegetableconf.props["Egg"].texture = "milk_and_honey_02_16";
farming_vegetableconf.props["Egg"].waterLvl = 10;
farming_vegetableconf.props["Egg"].timeToGrow = ZombRand(24, 48);
farming_vegetableconf.props["Egg"].vegetableName = "Base.Egg";
farming_vegetableconf.props["Egg"].CompostName = "Base.Fertilizer";
farming_vegetableconf.props["Egg"].seedName = "Sprout.ChickenFeed";
farming_vegetableconf.props["Egg"].growCode = "farming_vegetableconf.growEgg";
farming_vegetableconf.props["Egg"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Egg"].minVeg = 3;
farming_vegetableconf.props["Egg"].maxVeg = 6;
farming_vegetableconf.props["Egg"].minVegAutorized = 10;
farming_vegetableconf.props["Egg"].maxVegAutorized = 15;
farming_vegetableconf.props["Egg"].phaseName1 = "Farming_WaitingFor";
farming_vegetableconf.props["Egg"].phaseName2 = "Farming_WaitingFor";
farming_vegetableconf.props["Egg"].phaseName3 = "Farming_Getting_Settled";
farming_vegetableconf.props["Egg"].phaseName4 = "Farming_Making_Product";
farming_vegetableconf.props["Egg"].phaseName5 = "Farming_Making_Product";
farming_vegetableconf.props["Egg"].phaseName6 = "Farming_Ready for Harvest";
farming_vegetableconf.props["Egg"].phaseNameDry = "Farming_WonderedOff";
farming_vegetableconf.props["Egg"].phaseNameRotten = "Farming_WonderedOff";

-- Honey 
farming_vegetableconf.props["Honey"] = {};
farming_vegetableconf.props["Honey"].seedsRequired = 1;
farming_vegetableconf.props["Honey"].texture = "milk_and_honey_02_0";
farming_vegetableconf.props["Honey"].waterLvl = 10;
farming_vegetableconf.props["Honey"].timeToGrow = ZombRand(46, 52);
farming_vegetableconf.props["Honey"].vegetableName = "Base.Honey";
farming_vegetableconf.props["Honey"].seedName = "Sprout.BeeBox";
farming_vegetableconf.props["Honey"].growCode = "farming_vegetableconf.growHoney";
farming_vegetableconf.props["Honey"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Honey"].minVeg = 3;
farming_vegetableconf.props["Honey"].maxVeg = 6;
farming_vegetableconf.props["Honey"].minVegAutorized = 10;
farming_vegetableconf.props["Honey"].maxVegAutorized = 15;
farming_vegetableconf.props["Honey"].phaseName1 = "Farming_WaitingFor";
farming_vegetableconf.props["Honey"].phaseName2 = "Farming_WaitingFor";
farming_vegetableconf.props["Honey"].phaseName3 = "Farming_Getting_Settled";
farming_vegetableconf.props["Honey"].phaseName4 = "Farming_Making_Honey";
farming_vegetableconf.props["Honey"].phaseName5 = "Farming_Making_Honey";
farming_vegetableconf.props["Honey"].phaseName6 = "Farming_Ready for Harvest";
farming_vegetableconf.props["Honey"].phaseNameDry = "Farming_DeadHive";
farming_vegetableconf.props["Honey"].phaseNameRotten = "Farming_DeadHive";


--------------------------------------------------------- Vegetable  ---------------------------------------------------


-- Leek 
farming_vegetableconf.props["Leek"] = {};
farming_vegetableconf.props["Leek"].seedsRequired = 6;
farming_vegetableconf.props["Leek"].texture = "crop_farming_02_6";
farming_vegetableconf.props["Leek"].waterLvl = 85;
farming_vegetableconf.props["Leek"].timeToGrow = ZombRand(46, 52);
farming_vegetableconf.props["Leek"].vegetableName = "Base.Leek";
farming_vegetableconf.props["Leek"].seedName = "Sprout.LeekSeed";
farming_vegetableconf.props["Leek"].growCode = "farming_vegetableconf.growLeek";
farming_vegetableconf.props["Leek"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Leek"].minVeg = 3;
farming_vegetableconf.props["Leek"].maxVeg = 6;
farming_vegetableconf.props["Leek"].minVegAutorized = 10;
farming_vegetableconf.props["Leek"].maxVegAutorized = 15;
farming_vegetableconf.props["Leek"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Leek"].phaseName6 = "Farming_Ready for Harvest";




-- Lettuce 
farming_vegetableconf.props["Lettuce"] = {};
farming_vegetableconf.props["Lettuce"].seedsRequired = 6;
farming_vegetableconf.props["Lettuce"].texture = "trees_farming_02_38";
farming_vegetableconf.props["Lettuce"].waterLvl = 85;
farming_vegetableconf.props["Lettuce"].timeToGrow = ZombRand(46, 52);
farming_vegetableconf.props["Lettuce"].vegetableName = "Lettuce";
farming_vegetableconf.props["Lettuce"].seedName = "Sprout.LettuceSeed";
farming_vegetableconf.props["Lettuce"].growCode = "farming_vegetableconf.growLettuce";
farming_vegetableconf.props["Lettuce"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Lettuce"].minVeg = 2;
farming_vegetableconf.props["Lettuce"].maxVeg = 4;
farming_vegetableconf.props["Lettuce"].minVegAutorized = 5;
farming_vegetableconf.props["Lettuce"].maxVegAutorized = 8;
farming_vegetableconf.props["Lettuce"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Lettuce"].phaseName6 = "Farming_Ready for Harvest";


-- Onion 
farming_vegetableconf.props["Onion"] = {};
farming_vegetableconf.props["Onion"].seedsRequired = 6;
farming_vegetableconf.props["Onion"].texture = "crop_farming_01_62";
farming_vegetableconf.props["Onion"].waterLvl = 65;
farming_vegetableconf.props["Onion"].timeToGrow = ZombRand(89, 103);
farming_vegetableconf.props["Onion"].minVeg = 2;
farming_vegetableconf.props["Onion"].maxVeg = 4;
farming_vegetableconf.props["Onion"].minVegAutorized = 5;
farming_vegetableconf.props["Onion"].maxVegAutorized = 8;
farming_vegetableconf.props["Onion"].vegetableName = "Onion";
farming_vegetableconf.props["Onion"].seedName = "Sprout.OnionSeed";
farming_vegetableconf.props["Onion"].growCode = "farming_vegetableconf.growOnion";
farming_vegetableconf.props["Onion"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Onion"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Onion"].phaseName6 = "Farming_Ready for Harvest";


-- SoyBeans 
farming_vegetableconf.props["SoyBean"] = {};
farming_vegetableconf.props["SoyBean"].seedsRequired = 6;
farming_vegetableconf.props["SoyBean"].texture = "crop_farming_01_30";
farming_vegetableconf.props["SoyBean"].waterLvl = 50;
farming_vegetableconf.props["SoyBean"].waterLvlMax = 85;
farming_vegetableconf.props["SoyBean"].timeToGrow = ZombRand(54, 68);
farming_vegetableconf.props["SoyBean"].minVeg = 2;
farming_vegetableconf.props["SoyBean"].maxVeg = 4;
farming_vegetableconf.props["SoyBean"].minVegAutorized = 5;
farming_vegetableconf.props["SoyBean"].maxVegAutorized = 8;
farming_vegetableconf.props["SoyBean"].vegetableName = "Sprout.SoyBean";
farming_vegetableconf.props["SoyBean"].growCode = "farming_vegetableconf.growSoyBean";
farming_vegetableconf.props["SoyBean"].seedName = "Sprout.SoyBeanSeed";
farming_vegetableconf.props["SoyBean"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["SoyBean"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["SoyBean"].phaseName6 = "Farming_Ready for Harvest";


-- Pumpkin 
farming_vegetableconf.props["Pumpkin"] = {};
farming_vegetableconf.props["Pumpkin"].seedsRequired = 6;
farming_vegetableconf.props["Pumpkin"].texture = "trees_farming_02_30";
farming_vegetableconf.props["Pumpkin"].waterLvl = 75;
farming_vegetableconf.props["Pumpkin"].timeToGrow = ZombRand(89, 103);
farming_vegetableconf.props["Pumpkin"].minVeg = 1;
farming_vegetableconf.props["Pumpkin"].maxVeg = 2;
farming_vegetableconf.props["Pumpkin"].minVegAutorized = 4;
farming_vegetableconf.props["Pumpkin"].maxVegAutorized = 5;
farming_vegetableconf.props["Pumpkin"].vegetableName = "Pumpkin";
farming_vegetableconf.props["Pumpkin"].growCode = "farming_vegetableconf.growPumpkin";
farming_vegetableconf.props["Pumpkin"].seedName = "Sprout.PumpkinSeed";
farming_vegetableconf.props["Pumpkin"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Pumpkin"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Pumpkin"].phaseName6 = "Farming_Ready for Harvest";


-- Watermelon 
farming_vegetableconf.props["Watermelon"] = {};
farming_vegetableconf.props["Watermelon"].seedsRequired = 6;
farming_vegetableconf.props["Watermelon"].texture = "trees_farming_02_54";
farming_vegetableconf.props["Watermelon"].waterLvl = 75;
farming_vegetableconf.props["Watermelon"].timeToGrow = ZombRand(89, 103);
farming_vegetableconf.props["Watermelon"].minVeg = 2;
farming_vegetableconf.props["Watermelon"].maxVeg = 4;
farming_vegetableconf.props["Watermelon"].minVegAutorized = 5;
farming_vegetableconf.props["Watermelon"].maxVegAutorized = 6;
farming_vegetableconf.props["Watermelon"].vegetableName = "Watermelon";
farming_vegetableconf.props["Watermelon"].growCode = "farming_vegetableconf.growWatermelon";
farming_vegetableconf.props["Watermelon"].seedName = "Sprout.WatermelonSeed";
farming_vegetableconf.props["Watermelon"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Watermelon"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Watermelon"].phaseName6 = "Farming_Ready for Harvest";


-- Zucchini 
farming_vegetableconf.props["Zucchini"] = {};
farming_vegetableconf.props["Zucchini"].seedsRequired = 6;
farming_vegetableconf.props["Zucchini"].texture = "trees_farming_02_62";
farming_vegetableconf.props["Zucchini"].waterLvl = 65;
farming_vegetableconf.props["Zucchini"].waterLvlMax = 85;
farming_vegetableconf.props["Zucchini"].timeToGrow = ZombRand(56, 62);
farming_vegetableconf.props["Zucchini"].minVeg = 2;
farming_vegetableconf.props["Zucchini"].maxVeg = 4;
farming_vegetableconf.props["Zucchini"].minVegAutorized = 5;
farming_vegetableconf.props["Zucchini"].maxVegAutorized = 8;
farming_vegetableconf.props["Zucchini"].vegetableName = "Zucchini";
farming_vegetableconf.props["Zucchini"].growCode = "farming_vegetableconf.growZucchini";
farming_vegetableconf.props["Zucchini"].seedName = "Sprout.ZucchiniSeed";
farming_vegetableconf.props["Zucchini"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Zucchini"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Zucchini"].phaseName6 = "Farming_Ready for Harvest";



-- Corn 
farming_vegetableconf.props["Corn"] = {};
farming_vegetableconf.props["Corn"].seedsRequired = 4;
farming_vegetableconf.props["Corn"].texture = "vegetation_farming_01_78";
farming_vegetableconf.props["Corn"].waterLvl = 65;
farming_vegetableconf.props["Corn"].waterLvlMax = 85;
farming_vegetableconf.props["Corn"].timeToGrow = ZombRand(56, 62);
farming_vegetableconf.props["Corn"].minVeg = 2;
farming_vegetableconf.props["Corn"].maxVeg = 4;
farming_vegetableconf.props["Corn"].minVegAutorized = 5;
farming_vegetableconf.props["Corn"].maxVegAutorized = 8;
farming_vegetableconf.props["Corn"].vegetableName = "Base.Corn";
farming_vegetableconf.props["Corn"].growCode = "farming_vegetableconf.growCorn";
farming_vegetableconf.props["Corn"].seedName = "Sprout.CornSeed";
farming_vegetableconf.props["Corn"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Corn"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Corn"].phaseName6 = "Farming_Ready for Harvest";

-- Ginger 
farming_vegetableconf.props["Ginger"] = {};
farming_vegetableconf.props["Ginger"].seedsRequired = 6;
farming_vegetableconf.props["Ginger"].texture = "crop_farming_01_22";
farming_vegetableconf.props["Ginger"].waterLvl = 75;
farming_vegetableconf.props["Ginger"].waterLvlMax = 95;
farming_vegetableconf.props["Ginger"].timeToGrow = ZombRand(54, 62);
farming_vegetableconf.props["Ginger"].minVeg = 4;
farming_vegetableconf.props["Ginger"].maxVeg = 6;
farming_vegetableconf.props["Ginger"].minVegAutorized = 7;
farming_vegetableconf.props["Ginger"].maxVegAutorized = 9;
farming_vegetableconf.props["Ginger"].vegetableName = "Base.GingerRoot";
farming_vegetableconf.props["Ginger"].growCode = "farming_vegetableconf.growGinger";
farming_vegetableconf.props["Ginger"].seedName = "Sprout.GingerSeed";
farming_vegetableconf.props["Ginger"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Ginger"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Ginger"].phaseName6 = "Farming_Ready for Harvest";


-- Pineapple 
farming_vegetableconf.props["Pineapple"] = {};
farming_vegetableconf.props["Pineapple"].seedsRequired = 1;
farming_vegetableconf.props["Pineapple"].texture = "crop_farming_01_38";
farming_vegetableconf.props["Pineapple"].waterLvl = 75;
farming_vegetableconf.props["Pineapple"].waterLvlMax = 85;
farming_vegetableconf.props["Pineapple"].timeToGrow = ZombRand(56, 62);
farming_vegetableconf.props["Pineapple"].minVeg = 1;
farming_vegetableconf.props["Pineapple"].maxVeg = 1;
farming_vegetableconf.props["Pineapple"].minVegAutorized = 1;
farming_vegetableconf.props["Pineapple"].maxVegAutorized = 1;
farming_vegetableconf.props["Pineapple"].vegetableName = "Pineapple";
farming_vegetableconf.props["Pineapple"].growCode = "farming_vegetableconf.growPineapple";
farming_vegetableconf.props["Pineapple"].seedName = "Sprout.PineappleSeed";
farming_vegetableconf.props["Pineapple"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Pineapple"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Pineapple"].phaseName6 = "Farming_Ready for Harvest";

-- Wheat 
farming_vegetableconf.props["Wheat"] = {};
farming_vegetableconf.props["Wheat"].seedsRequired = 4;
farming_vegetableconf.props["Wheat"].texture = "crop_farming_02_61";
farming_vegetableconf.props["Wheat"].waterLvl = 75;
farming_vegetableconf.props["Wheat"].waterLvlMax = 95;
farming_vegetableconf.props["Wheat"].timeToGrow = ZombRand(54, 62);
farming_vegetableconf.props["Wheat"].minVeg = 4;
farming_vegetableconf.props["Wheat"].maxVeg = 6;
farming_vegetableconf.props["Wheat"].minVegAutorized = 7;
farming_vegetableconf.props["Wheat"].maxVegAutorized = 9;
farming_vegetableconf.props["Wheat"].vegetableName = "Sprout.Wheat";
farming_vegetableconf.props["Wheat"].growCode = "farming_vegetableconf.growWheat";
farming_vegetableconf.props["Wheat"].seedName = "Sprout.WheatSeed";
farming_vegetableconf.props["Wheat"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Wheat"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Wheat"].phaseName6 = "Farming_Ready for Harvest";


-- SugarCane 
farming_vegetableconf.props["SugarCane"] = {};
farming_vegetableconf.props["SugarCane"].seedsRequired = 4;
farming_vegetableconf.props["SugarCane"].texture = "crop_farming_02_54";
farming_vegetableconf.props["SugarCane"].waterLvl = 75;
farming_vegetableconf.props["SugarCane"].waterLvlMax = 95;
farming_vegetableconf.props["SugarCane"].timeToGrow = ZombRand(54, 62);
farming_vegetableconf.props["SugarCane"].minVeg = 1;
farming_vegetableconf.props["SugarCane"].maxVeg = 3;
farming_vegetableconf.props["SugarCane"].minVegAutorized = 1;
farming_vegetableconf.props["SugarCane"].maxVegAutorized = 3;
farming_vegetableconf.props["SugarCane"].vegetableName = "Sprout.SugarCane";
farming_vegetableconf.props["SugarCane"].growCode = "farming_vegetableconf.growSugarCane";
farming_vegetableconf.props["SugarCane"].seedName = "Sprout.SugarCaneSeed";
farming_vegetableconf.props["SugarCane"].seedPerVeg = ZombRand(1,5);
farming_vegetableconf.props["SugarCane"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["SugarCane"].phaseName6 = "Farming_Ready for Harvest";


-- Ginseng 
farming_vegetableconf.props["Ginseng"] = {};
farming_vegetableconf.props["Ginseng"].seedsRequired = 6;
farming_vegetableconf.props["Ginseng"].texture = "crop_farming_01_54";
farming_vegetableconf.props["Ginseng"].waterLvl = 75;
farming_vegetableconf.props["Ginseng"].waterLvlMax = 95;
farming_vegetableconf.props["Ginseng"].timeToGrow = ZombRand(54, 62);
farming_vegetableconf.props["Ginseng"].minVeg = 4;
farming_vegetableconf.props["Ginseng"].maxVeg = 8;
farming_vegetableconf.props["Ginseng"].minVegAutorized = 4;
farming_vegetableconf.props["Ginseng"].maxVegAutorized = 8;
farming_vegetableconf.props["Ginseng"].vegetableName = "Ginseng";
farming_vegetableconf.props["Ginseng"].growCode = "farming_vegetableconf.growGinseng";
farming_vegetableconf.props["Ginseng"].seedName = "Sprout.GinsengSeed";
farming_vegetableconf.props["Ginseng"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Ginseng"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Ginseng"].phaseName6 = "Farming_Ready for Harvest";


-- Mushroom 
farming_vegetableconf.props["Mushroom"] = {};
farming_vegetableconf.props["Mushroom"].seedsRequired = 6;
farming_vegetableconf.props["Mushroom"].texture = "trees_farming_02_46";
farming_vegetableconf.props["Mushroom"].waterLvl = 75;
farming_vegetableconf.props["Mushroom"].timeToGrow = ZombRand(89, 103);
farming_vegetableconf.props["Mushroom"].minVeg = 6;
farming_vegetableconf.props["Mushroom"].maxVeg = 8;
farming_vegetableconf.props["Mushroom"].minVegAutorized = 9;
farming_vegetableconf.props["Mushroom"].maxVegAutorized = 10;
farming_vegetableconf.props["Mushroom"].vegetableName = "Base.MushroomGeneric1";
farming_vegetableconf.props["Mushroom"].growCode = "farming_vegetableconf.growMushroom";
farming_vegetableconf.props["Mushroom"].seedName = "Sprout.MushroomSpores";
farming_vegetableconf.props["Mushroom"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Mushroom"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Mushroom"].phaseName6 = "Farming_Ready for Harvest";

-- Mongui
farming_vegetableconf.props["Mongui"] = {};
farming_vegetableconf.props["Mongui"].seedsRequired = 6;
farming_vegetableconf.props["Mongui"].texture = "trees_farming_02_46";
farming_vegetableconf.props["Mongui"].waterLvl = 75;
farming_vegetableconf.props["Mongui"].timeToGrow = ZombRand(89, 103);
farming_vegetableconf.props["Mongui"].minVeg = 6;
farming_vegetableconf.props["Mongui"].maxVeg = 8;
farming_vegetableconf.props["Mongui"].minVegAutorized = 9;
farming_vegetableconf.props["Mongui"].maxVegAutorized = 10;
farming_vegetableconf.props["Mongui"].vegetableName = "Sprout.Monguis";
farming_vegetableconf.props["Mongui"].growCode = "farming_vegetableconf.growMushroom";
farming_vegetableconf.props["Mongui"].seedName = "Sprout.MonguiSpores";
farming_vegetableconf.props["Mongui"].seedPerVeg = ZombRand(0,0);
farming_vegetableconf.props["Mongui"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Mongui"].phaseName6 = "Farming_Ready for Harvest";

-- Bell Peppers 
farming_vegetableconf.props["BellPepper"] = {};
farming_vegetableconf.props["BellPepper"].seedsRequired = 4;
farming_vegetableconf.props["BellPepper"].texture = "crop_farming_02_22";
farming_vegetableconf.props["BellPepper"].waterLvl = 70;
farming_vegetableconf.props["BellPepper"].timeToGrow = ZombRand(54, 68);
farming_vegetableconf.props["BellPepper"].minVeg = 2;
farming_vegetableconf.props["BellPepper"].maxVeg = 4;
farming_vegetableconf.props["BellPepper"].minVegAutorized = 5;
farming_vegetableconf.props["BellPepper"].maxVegAutorized = 8;
farming_vegetableconf.props["BellPepper"].vegetableName = "BellPepper";
farming_vegetableconf.props["BellPepper"].growCode = "farming_vegetableconf.growBellPepper";
farming_vegetableconf.props["BellPepper"].seedName = "Sprout.BellPepperSeed";
farming_vegetableconf.props["BellPepper"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["BellPepper"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["BellPepper"].phaseName6 = "Farming_Ready for Harvest";

-- BerryBlack 
farming_vegetableconf.props["BerryBlack"] = {};
farming_vegetableconf.props["BerryBlack"].seedsRequired = 4;
farming_vegetableconf.props["BerryBlack"].texture = "crop_farming_01_6";
farming_vegetableconf.props["BerryBlack"].waterLvl = 70;
farming_vegetableconf.props["BerryBlack"].timeToGrow = ZombRand(54, 68);
farming_vegetableconf.props["BerryBlack"].minVeg = 2;
farming_vegetableconf.props["BerryBlack"].maxVeg = 4;
farming_vegetableconf.props["BerryBlack"].minVegAutorized = 5;
farming_vegetableconf.props["BerryBlack"].maxVegAutorized = 8;
farming_vegetableconf.props["BerryBlack"].vegetableName = "BerryBlack";
farming_vegetableconf.props["BerryBlack"].growCode = "farming_vegetableconf.growBerryBlack";
farming_vegetableconf.props["BerryBlack"].seedName = "Sprout.BerryBlackSeed";
farming_vegetableconf.props["BerryBlack"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["BerryBlack"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["BerryBlack"].phaseName6 = "Farming_Ready for Harvest";

-- BerryBlue 
farming_vegetableconf.props["BerryBlue"] = {};
farming_vegetableconf.props["BerryBlue"].seedsRequired = 4;
farming_vegetableconf.props["BerryBlue"].texture = "crop_farming_01_14";
farming_vegetableconf.props["BerryBlue"].waterLvl = 70;
farming_vegetableconf.props["BerryBlue"].timeToGrow = ZombRand(54, 68);
farming_vegetableconf.props["BerryBlue"].minVeg = 2;
farming_vegetableconf.props["BerryBlue"].maxVeg = 4;
farming_vegetableconf.props["BerryBlue"].minVegAutorized = 5;
farming_vegetableconf.props["BerryBlue"].maxVegAutorized = 8;
farming_vegetableconf.props["BerryBlue"].vegetableName = "BerryBlue";
farming_vegetableconf.props["BerryBlue"].growCode = "farming_vegetableconf.growBerryBlue";
farming_vegetableconf.props["BerryBlue"].seedName = "Sprout.BerryBlueSeed";
farming_vegetableconf.props["BerryBlue"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["BerryBlue"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["BerryBlue"].phaseName6 = "Farming_Ready for Harvest";


-- Lemongrass 
farming_vegetableconf.props["Lemongrass"] = {};
farming_vegetableconf.props["Lemongrass"].seedsRequired = 12;
farming_vegetableconf.props["Lemongrass"].texture = "crop_farming_02_14";
farming_vegetableconf.props["Lemongrass"].waterLvl = 70;
farming_vegetableconf.props["Lemongrass"].timeToGrow = ZombRand(54, 68);
farming_vegetableconf.props["Lemongrass"].minVeg = 2;
farming_vegetableconf.props["Lemongrass"].maxVeg = 4;
farming_vegetableconf.props["Lemongrass"].minVegAutorized = 8;
farming_vegetableconf.props["Lemongrass"].maxVegAutorized = 12;
farming_vegetableconf.props["Lemongrass"].vegetableName = "Base.LemonGrass";
farming_vegetableconf.props["Lemongrass"].growCode = "farming_vegetableconf.growLemongrass";
farming_vegetableconf.props["Lemongrass"].seedName = "Sprout.LemongrassSeed";
farming_vegetableconf.props["Lemongrass"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Lemongrass"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Lemongrass"].phaseName6 = "Farming_Ready for Harvest";


-- Eggplant 
farming_vegetableconf.props["Eggplant"] = {};
farming_vegetableconf.props["Eggplant"].seedsRequired = 4;
farming_vegetableconf.props["Eggplant"].texture = "crop_farming_02_30";
farming_vegetableconf.props["Eggplant"].waterLvl = 70;
farming_vegetableconf.props["Eggplant"].timeToGrow = ZombRand(54, 68);
farming_vegetableconf.props["Eggplant"].minVeg = 2;
farming_vegetableconf.props["Eggplant"].maxVeg = 4;
farming_vegetableconf.props["Eggplant"].minVegAutorized = 5;
farming_vegetableconf.props["Eggplant"].maxVegAutorized = 8;
farming_vegetableconf.props["Eggplant"].vegetableName = "Eggplant";
farming_vegetableconf.props["Eggplant"].growCode = "farming_vegetableconf.growEggplant";
farming_vegetableconf.props["Eggplant"].seedName = "Sprout.EggplantSeed";
farming_vegetableconf.props["Eggplant"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Eggplant"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Eggplant"].phaseName6 = "Farming_Ready for Harvest";


-- Grapes 
farming_vegetableconf.props["Grape"] = {};
farming_vegetableconf.props["Grape"].seedsRequired = 4;
farming_vegetableconf.props["Grape"].texture = "crop_farming_02_38";
farming_vegetableconf.props["Grape"].waterLvl = 70;
farming_vegetableconf.props["Grape"].timeToGrow = ZombRand(54, 68);
farming_vegetableconf.props["Grape"].minVeg = 2;
farming_vegetableconf.props["Grape"].maxVeg = 4;
farming_vegetableconf.props["Grape"].minVegAutorized = 5;
farming_vegetableconf.props["Grape"].maxVegAutorized = 8;
farming_vegetableconf.props["Grape"].vegetableName = "Grapes";
farming_vegetableconf.props["Grape"].growCode = "farming_vegetableconf.growGrape";
farming_vegetableconf.props["Grape"].seedName = "Sprout.GrapeSeed";
farming_vegetableconf.props["Grape"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Grape"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Grape"].phaseName6 = "Farming_Ready for Harvest";


-- Lemon
farming_vegetableconf.props["Lemon"] = {};
farming_vegetableconf.props["Lemon"].seedsRequired = 2;
farming_vegetableconf.props["Lemon"].texture = "trees_farming_01_22";
farming_vegetableconf.props["Lemon"].waterLvl = 85;
farming_vegetableconf.props["Lemon"].timeToGrow = ZombRand(100, 150);
farming_vegetableconf.props["Lemon"].minVeg = 4;
farming_vegetableconf.props["Lemon"].maxVeg = 6;
farming_vegetableconf.props["Lemon"].minVegAutorized = 8;
farming_vegetableconf.props["Lemon"].maxVegAutorized = 10;
farming_vegetableconf.props["Lemon"].vegetableName = "Lemon";
farming_vegetableconf.props["Lemon"].growCode = "farming_vegetableconf.growLemon";
farming_vegetableconf.props["Lemon"].seedName = "Sprout.LemonSeed";
farming_vegetableconf.props["Lemon"].seedPerVeg = 1;
farming_vegetableconf.props["Lemon"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Lemon"].phaseName6 = "Farming_Ready for Harvest";

-- Orange
farming_vegetableconf.props["Orange"] = {};
farming_vegetableconf.props["Orange"].seedsRequired = 2;
farming_vegetableconf.props["Orange"].texture = "trees_farming_02_22";
farming_vegetableconf.props["Orange"].waterLvl = 75;
farming_vegetableconf.props["Orange"].timeToGrow = ZombRand(100, 150);
farming_vegetableconf.props["Orange"].minVeg = 4;
farming_vegetableconf.props["Orange"].maxVeg = 6;
farming_vegetableconf.props["Orange"].minVegAutorized = 8;
farming_vegetableconf.props["Orange"].maxVegAutorized = 10;
farming_vegetableconf.props["Orange"].vegetableName = "Orange";
farming_vegetableconf.props["Orange"].growCode = "farming_vegetableconf.growOrange";
farming_vegetableconf.props["Orange"].seedName = "Sprout.OrangeSeed";
farming_vegetableconf.props["Orange"].seedPerVeg = 1;
farming_vegetableconf.props["Orange"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Orange"].phaseName6 = "Farming_Ready for Harvest";

-- Apple
farming_vegetableconf.props["Apple"] = {};
farming_vegetableconf.props["Apple"].seedsRequired = 2;
farming_vegetableconf.props["Apple"].texture = "trees_farming_01_6";
farming_vegetableconf.props["Apple"].waterLvl = 75;
farming_vegetableconf.props["Apple"].timeToGrow = ZombRand(100, 150);
farming_vegetableconf.props["Apple"].minVeg = 4;
farming_vegetableconf.props["Apple"].maxVeg = 6;
farming_vegetableconf.props["Apple"].minVegAutorized = 8;
farming_vegetableconf.props["Apple"].maxVegAutorized = 10;
farming_vegetableconf.props["Apple"].vegetableName = "Apple";
farming_vegetableconf.props["Apple"].growCode = "farming_vegetableconf.growApple";
farming_vegetableconf.props["Apple"].seedName = "Sprout.AppleSeed";
farming_vegetableconf.props["Apple"].seedPerVeg = 1;
farming_vegetableconf.props["Apple"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Apple"].phaseName6 = "Farming_Ready for Harvest";

-- Olive
farming_vegetableconf.props["Olive"] = {};
farming_vegetableconf.props["Olive"].seedsRequired = 2;
farming_vegetableconf.props["Olive"].texture = "trees_farming_01_54";
farming_vegetableconf.props["Olive"].waterLvl = 75;
farming_vegetableconf.props["Olive"].timeToGrow = ZombRand(100, 150);
farming_vegetableconf.props["Olive"].minVeg = 4;
farming_vegetableconf.props["Olive"].maxVeg = 6;
farming_vegetableconf.props["Olive"].minVegAutorized = 8;
farming_vegetableconf.props["Olive"].maxVegAutorized = 10;
farming_vegetableconf.props["Olive"].vegetableName = "Sprout.Olive";
farming_vegetableconf.props["Olive"].growCode = "farming_vegetableconf.growOlive";
farming_vegetableconf.props["Olive"].seedName = "Sprout.OliveSeed";
farming_vegetableconf.props["Olive"].seedPerVeg = 1;
farming_vegetableconf.props["Olive"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Olive"].phaseName6 = "Farming_Ready for Harvest";

-- Peach
farming_vegetableconf.props["Peach"] = {};
farming_vegetableconf.props["Peach"].seedsRequired = 2;
farming_vegetableconf.props["Peach"].texture = "trees_farming_01_62";
farming_vegetableconf.props["Peach"].waterLvl = 80;
farming_vegetableconf.props["Peach"].timeToGrow = ZombRand(100, 150);
farming_vegetableconf.props["Peach"].minVeg = 4;
farming_vegetableconf.props["Peach"].maxVeg = 6;
farming_vegetableconf.props["Peach"].minVegAutorized = 8;
farming_vegetableconf.props["Peach"].maxVegAutorized = 10;
farming_vegetableconf.props["Peach"].vegetableName = "Peach";
farming_vegetableconf.props["Peach"].growCode = "farming_vegetableconf.growPeach";
farming_vegetableconf.props["Peach"].seedName = "Sprout.PeachSeed";
farming_vegetableconf.props["Peach"].seedPerVeg = 1;
farming_vegetableconf.props["Peach"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Peach"].phaseName6 = "Farming_Ready for Harvest";

-- Banana
farming_vegetableconf.props["Banana"] = {};
farming_vegetableconf.props["Banana"].seedsRequired = 2;
farming_vegetableconf.props["Banana"].texture = "trees_farming_02_6";
farming_vegetableconf.props["Banana"].waterLvl = 85;
farming_vegetableconf.props["Banana"].timeToGrow = ZombRand(100, 150);
farming_vegetableconf.props["Banana"].minVeg = 4;
farming_vegetableconf.props["Banana"].maxVeg = 6;
farming_vegetableconf.props["Banana"].minVegAutorized = 8;
farming_vegetableconf.props["Banana"].maxVegAutorized = 10;
farming_vegetableconf.props["Banana"].vegetableName = "Banana";
farming_vegetableconf.props["Banana"].growCode = "farming_vegetableconf.growBanana";
farming_vegetableconf.props["Banana"].seedName = "Sprout.BananaSeed";
farming_vegetableconf.props["Banana"].seedPerVeg = 1;
farming_vegetableconf.props["Banana"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Banana"].phaseName6 = "Farming_Ready for Harvest";

-- Cherry
farming_vegetableconf.props["Cherry"] = {};
farming_vegetableconf.props["Cherry"].seedsRequired = 2;
farming_vegetableconf.props["Cherry"].texture = "trees_farming_01_38";
farming_vegetableconf.props["Cherry"].waterLvl = 85;
farming_vegetableconf.props["Cherry"].timeToGrow = ZombRand(100, 150);
farming_vegetableconf.props["Cherry"].minVeg = 8;
farming_vegetableconf.props["Cherry"].maxVeg = 10;
farming_vegetableconf.props["Cherry"].minVegAutorized = 12;
farming_vegetableconf.props["Cherry"].maxVegAutorized = 14;
farming_vegetableconf.props["Cherry"].vegetableName = "Cherry";
farming_vegetableconf.props["Cherry"].growCode = "farming_vegetableconf.growCherry";
farming_vegetableconf.props["Cherry"].seedName = "Sprout.CherrySeed";
farming_vegetableconf.props["Cherry"].seedPerVeg = 1;
farming_vegetableconf.props["Cherry"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Cherry"].phaseName6 = "Farming_Ready for Harvest";

-- Lime
farming_vegetableconf.props["Lime"] = {};
farming_vegetableconf.props["Lime"].seedsRequired = 2;
farming_vegetableconf.props["Lime"].texture = "trees_farming_01_30";
farming_vegetableconf.props["Lime"].waterLvl = 85;
farming_vegetableconf.props["Lime"].timeToGrow = ZombRand(100, 150);
farming_vegetableconf.props["Lime"].minVeg = 4;
farming_vegetableconf.props["Lime"].maxVeg = 6;
farming_vegetableconf.props["Lime"].minVegAutorized = 8;
farming_vegetableconf.props["Lime"].maxVegAutorized = 10;
farming_vegetableconf.props["Lime"].vegetableName = "Lime";
farming_vegetableconf.props["Lime"].growCode = "farming_vegetableconf.growLime";
farming_vegetableconf.props["Lime"].seedName = "Sprout.LimeSeed";
farming_vegetableconf.props["Lime"].seedPerVeg = 1;
farming_vegetableconf.props["Lime"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Lime"].phaseName6 = "Farming_Ready for Harvest";

-- Avocado
farming_vegetableconf.props["Avocado"] = {};
farming_vegetableconf.props["Avocado"].seedsRequired = 2;
farming_vegetableconf.props["Avocado"].texture = "trees_farming_01_14";
farming_vegetableconf.props["Avocado"].waterLvl = 85;
farming_vegetableconf.props["Avocado"].timeToGrow = ZombRand(100, 150);
farming_vegetableconf.props["Avocado"].minVeg = 4;
farming_vegetableconf.props["Avocado"].maxVeg = 6;
farming_vegetableconf.props["Avocado"].minVegAutorized = 8;
farming_vegetableconf.props["Avocado"].maxVegAutorized = 10;
farming_vegetableconf.props["Avocado"].vegetableName = "Avocado";
farming_vegetableconf.props["Avocado"].growCode = "farming_vegetableconf.growAvocado";
farming_vegetableconf.props["Avocado"].seedName = "Sprout.AvocadoSeed";
farming_vegetableconf.props["Avocado"].seedPerVeg = 1;
farming_vegetableconf.props["Avocado"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Avocado"].phaseName6 = "Farming_Ready for Harvest";

-- Mango
farming_vegetableconf.props["Mango"] = {};
farming_vegetableconf.props["Mango"].seedsRequired = 2;
farming_vegetableconf.props["Mango"].texture = "trees_farming_02_14";
farming_vegetableconf.props["Mango"].waterLvl = 85;
farming_vegetableconf.props["Mango"].timeToGrow = ZombRand(100, 150);
farming_vegetableconf.props["Mango"].minVeg = 4;
farming_vegetableconf.props["Mango"].maxVeg = 6;
farming_vegetableconf.props["Mango"].minVegAutorized = 8;
farming_vegetableconf.props["Mango"].maxVegAutorized = 10;
farming_vegetableconf.props["Mango"].vegetableName = "Mango";
farming_vegetableconf.props["Mango"].growCode = "farming_vegetableconf.growMango";
farming_vegetableconf.props["Mango"].seedName = "Sprout.MangoSeed";
farming_vegetableconf.props["Mango"].seedPerVeg = 1;
farming_vegetableconf.props["Mango"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Mango"].phaseName6 = "Farming_Ready for Harvest";

-- GrapeFruit
farming_vegetableconf.props["GrapeFruit"] = {};
farming_vegetableconf.props["GrapeFruit"].seedsRequired = 2;
farming_vegetableconf.props["GrapeFruit"].texture = "trees_farming_01_46";
farming_vegetableconf.props["GrapeFruit"].waterLvl = 85;
farming_vegetableconf.props["GrapeFruit"].timeToGrow = ZombRand(100, 150);
farming_vegetableconf.props["GrapeFruit"].minVeg = 4;
farming_vegetableconf.props["GrapeFruit"].maxVeg = 6;
farming_vegetableconf.props["GrapeFruit"].minVegAutorized = 8;
farming_vegetableconf.props["GrapeFruit"].maxVegAutorized = 10;
farming_vegetableconf.props["GrapeFruit"].vegetableName = "Grapefruit";
farming_vegetableconf.props["GrapeFruit"].growCode = "farming_vegetableconf.growGrapeFruit";
farming_vegetableconf.props["GrapeFruit"].seedName = "Sprout.GrapefruitSeed";
farming_vegetableconf.props["GrapeFruit"].seedPerVeg = 1;
farming_vegetableconf.props["GrapeFruit"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["GrapeFruit"].phaseName6 = "Farming_Ready for Harvest";

-- Rice
farming_vegetableconf.props["Rice"] = {};
farming_vegetableconf.props["Rice"].seedsRequired = 6;
farming_vegetableconf.props["Rice"].texture = "crop_farming_03_14";
farming_vegetableconf.props["Rice"].waterLvl = 95;
farming_vegetableconf.props["Rice"].timeToGrow = ZombRand(80, 100);
farming_vegetableconf.props["Rice"].minVeg = 110;
farming_vegetableconf.props["Rice"].maxVeg = 120;
farming_vegetableconf.props["Rice"].minVegAutorized = 110;
farming_vegetableconf.props["Rice"].maxVegAutorized = 120;
farming_vegetableconf.props["Rice"].vegetableName = "Sprout.RicePinch";
farming_vegetableconf.props["Rice"].growCode = "farming_vegetableconf.growRice";
farming_vegetableconf.props["Rice"].seedName = "Sprout.RiceSeed";
farming_vegetableconf.props["Rice"].seedPerVeg = ZombRand(1,5);
farming_vegetableconf.props["Rice"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Rice"].phaseName6 = "Farming_Ready for Harvest";

-- PepperPlant
farming_vegetableconf.props["PepperPlant"] = {};
farming_vegetableconf.props["PepperPlant"].seedsRequired = 6;
farming_vegetableconf.props["PepperPlant"].texture = "crop_farming_03_6";
farming_vegetableconf.props["PepperPlant"].waterLvl = 85;
farming_vegetableconf.props["PepperPlant"].timeToGrow = ZombRand(80, 100);
farming_vegetableconf.props["PepperPlant"].minVeg = 4;
farming_vegetableconf.props["PepperPlant"].maxVeg = 6;
farming_vegetableconf.props["PepperPlant"].minVegAutorized = 8;
farming_vegetableconf.props["PepperPlant"].maxVegAutorized = 10;
farming_vegetableconf.props["PepperPlant"].vegetableName = "Sprout.PepperPlant";
farming_vegetableconf.props["PepperPlant"].growCode = "farming_vegetableconf.growPepperPlant";
farming_vegetableconf.props["PepperPlant"].seedName = "Sprout.PepperPlantSeed";
farming_vegetableconf.props["PepperPlant"].seedPerVeg = ZombRand(1,5);
farming_vegetableconf.props["PepperPlant"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["PepperPlant"].phaseName6 = "Farming_Ready for Harvest";

-- Hops
farming_vegetableconf.props["Hops"] = {};
farming_vegetableconf.props["Hops"].seedsRequired = 6;
farming_vegetableconf.props["Hops"].texture = "crop_farming_03_30";
farming_vegetableconf.props["Hops"].waterLvl = 85;
farming_vegetableconf.props["Hops"].timeToGrow = ZombRand(80, 100);
farming_vegetableconf.props["Hops"].minVeg = 4;
farming_vegetableconf.props["Hops"].maxVeg = 6;
farming_vegetableconf.props["Hops"].minVegAutorized = 8;
farming_vegetableconf.props["Hops"].maxVegAutorized = 10;
farming_vegetableconf.props["Hops"].vegetableName = "Sprout.Hops";
farming_vegetableconf.props["Hops"].growCode = "farming_vegetableconf.growHops";
farming_vegetableconf.props["Hops"].seedName = "Sprout.HopsSeed";
farming_vegetableconf.props["Hops"].seedPerVeg = ZombRand(1,5);
farming_vegetableconf.props["Hops"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Hops"].phaseName6 = "Farming_Ready for Harvest";

-- Cotton
farming_vegetableconf.props["Cotton"] = {};
farming_vegetableconf.props["Cotton"].seedsRequired = 6;
farming_vegetableconf.props["Cotton"].texture = "crop_farming_03_22";
farming_vegetableconf.props["Cotton"].waterLvl = 85;
farming_vegetableconf.props["Cotton"].timeToGrow = ZombRand(80, 100);
farming_vegetableconf.props["Cotton"].minVeg = 4;
farming_vegetableconf.props["Cotton"].maxVeg = 6;
farming_vegetableconf.props["Cotton"].minVegAutorized = 8;
farming_vegetableconf.props["Cotton"].maxVegAutorized = 10;
farming_vegetableconf.props["Cotton"].vegetableName = "Sprout.Cotton";
farming_vegetableconf.props["Cotton"].growCode = "farming_vegetableconf.growCotton";
farming_vegetableconf.props["Cotton"].seedName = "Sprout.CottonSeed";
farming_vegetableconf.props["Cotton"].seedPerVeg = ZombRand(1,5);
farming_vegetableconf.props["Cotton"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Cotton"].phaseName6 = "Farming_Ready for Harvest";

--Sprites



farming_vegetableconf.sprite["Tea"] = {
	"trees2_01_0",
	"trees2_01_1",
	"trees2_01_2",
	"trees2_01_3",
	"trees2_01_4",
	"trees2_01_5",
	"trees2_01_6",
	"trees2_01_7"
	}
farming_vegetableconf.sprite["Coffee"] = {
	"trees2_01_8",
	"trees2_01_9",
	"trees2_01_10",
	"trees2_01_11",
	"trees2_01_12",
	"trees2_01_13",
	"trees2_01_14",
	"trees2_01_15"
	}
farming_vegetableconf.sprite["Latex"] = {
	"trees2_01_16",
	"trees2_01_17",
	"trees2_01_18",
	"trees2_01_19",
	"trees2_01_20",
	"trees2_01_21",
	"trees2_01_22",
	"trees2_01_23"
	}

farming_vegetableconf.sprite["Sativa"] = {
	"weed_01_0",
	"weed_01_1",
	"weed_01_2",
	"weed_01_3",
	"weed_01_4",
	"weed_01_5",
	"weed_01_6",
	"weed_01_7"
	}

farming_vegetableconf.sprite["Kief"] = {
	"weed_01_0",
	"weed_01_1",
	"weed_01_2",
	"weed_01_3",
	"weed_01_4",
	"weed_01_5",
	"weed_01_6",
	"A1 indutry_bunker_01_17"
	}
farming_vegetableconf.sprite["Indica"] = {
	"weed_01_8",
	"weed_01_9",
	"weed_01_10",
	"weed_01_11",
	"weed_01_12",
	"weed_01_13",
	"weed_01_14",
	"weed_01_15"
	}
farming_vegetableconf.sprite["Tobacco"] = {
	"weed_01_16",
	"weed_01_17",
	"weed_01_18",
	"weed_01_19",
	"weed_01_20",
	"weed_01_21",
	"weed_01_22",
	"weed_01_23"
	}

farming_vegetableconf.sprite["Carnation"] = {
	"flowergarden_01_0",
	"flowergarden_01_1",
	"flowergarden_01_2",
	"flowergarden_01_3",
	"flowergarden_01_4",
	"flowergarden_01_5",
	"flowergarden_01_6",
	"flowergarden_01_7"
	}
farming_vegetableconf.sprite["Dahlia"] = {
	"flowergarden_01_8",
	"flowergarden_01_9",
	"flowergarden_01_10",
	"flowergarden_01_11",
	"flowergarden_01_12",
	"flowergarden_01_13",
	"flowergarden_01_14",
	"flowergarden_01_15"
	}
farming_vegetableconf.sprite["Daisy"] = {
	"flowergarden_01_16",
	"flowergarden_01_17",
	"flowergarden_01_18",
	"flowergarden_01_19",
	"flowergarden_01_20",
	"flowergarden_01_21",
	"flowergarden_01_22",
	"flowergarden_01_23"
	}
farming_vegetableconf.sprite["Delphi"] = {
	"flowergarden_01_24",
	"flowergarden_01_25",
	"flowergarden_01_26",
	"flowergarden_01_27",
	"flowergarden_01_28",
	"flowergarden_01_29",
	"flowergarden_01_30",
	"flowergarden_01_31"
	}
	farming_vegetableconf.sprite["Larkspur"] = {
		"flowergarden_01_32",
		"flowergarden_01_33",
		"flowergarden_01_34",
		"flowergarden_01_35",
		"flowergarden_01_36",
		"flowergarden_01_37",
		"flowergarden_01_38",
		"flowergarden_01_39"
		}
farming_vegetableconf.sprite["Rose"] = {
		"flowergarden_01_40",
		"flowergarden_01_41",
		"flowergarden_01_42",
		"flowergarden_01_43",
		"flowergarden_01_44",
		"flowergarden_01_45",
		"flowergarden_01_46",
		"flowergarden_01_47"
		}
farming_vegetableconf.sprite["Penta"] = {
		"flowergarden_01_48",
		"flowergarden_01_49",
		"flowergarden_01_50",
		"flowergarden_01_51",
		"flowergarden_01_52",
		"flowergarden_01_53",
		"flowergarden_01_54",
		"flowergarden_01_55"
		}
farming_vegetableconf.sprite["Amapola"] = {
	    "flowergarden_01_48",
		"flowergarden_01_49",
		"flowergarden_01_50",
		"flowergarden_01_51",
		"flowergarden_01_52",
		"flowergarden_01_53",
		"flowergarden_01_54",
		"flowergarden_01_55"
		}
farming_vegetableconf.sprite["Geranium"] = {
		"flowergarden_01_56",
		"flowergarden_01_57",
		"flowergarden_01_58",
		"flowergarden_01_59",
		"flowergarden_01_60",
		"flowergarden_01_61",
		"flowergarden_01_62",
		"flowergarden_01_63"
		}


farming_vegetableconf.sprite["Bird"] = {
	"milk_and_honey_02_56",
	"milk_and_honey_02_57",
	"milk_and_honey_02_58",
	"milk_and_honey_02_59",
	"milk_and_honey_02_60",
	"milk_and_honey_02_61",
	"milk_and_honey_02_62",
	"milk_and_honey_02_63"
	}

farming_vegetableconf.sprite["Mutton"] = {
	"milk_and_honey_02_48",
	"milk_and_honey_02_49",
	"milk_and_honey_02_50",
	"milk_and_honey_02_51",
	"milk_and_honey_02_52",
	"milk_and_honey_02_53",
	"milk_and_honey_02_54",
	"milk_and_honey_02_55"
	}
	farming_vegetableconf.sprite["Pork"] = {
		"milk_and_honey_02_40",
		"milk_and_honey_02_41",
		"milk_and_honey_02_42",
		"milk_and_honey_02_43",
		"milk_and_honey_02_44",
		"milk_and_honey_02_45",
		"milk_and_honey_02_46",
		"milk_and_honey_02_47"
		}
farming_vegetableconf.sprite["Beef"] = {
	"milk_and_honey_02_32",
	"milk_and_honey_02_33",
	"milk_and_honey_02_34",
	"milk_and_honey_02_35",
	"milk_and_honey_02_36",
	"milk_and_honey_02_37",
	"milk_and_honey_02_38",
	"milk_and_honey_02_39"
	}
farming_vegetableconf.sprite["Wool"] = {
	"milk_and_honey_02_24",
	"milk_and_honey_02_25",
	"milk_and_honey_02_26",
	"milk_and_honey_02_27",
	"milk_and_honey_02_28",
	"milk_and_honey_02_29",
	"milk_and_honey_02_30",
	"milk_and_honey_02_31"
	}

farming_vegetableconf.sprite["Milk"] = {
	"milk_and_honey_02_8",
	"milk_and_honey_02_9",
	"milk_and_honey_02_10",
	"milk_and_honey_02_11",
	"milk_and_honey_02_12",
	"milk_and_honey_02_13",
	"milk_and_honey_02_14",
	"milk_and_honey_02_15"
	}

farming_vegetableconf.sprite["Egg"] = {
	"milk_and_honey_02_16",
	"milk_and_honey_02_17",
	"milk_and_honey_02_18",
	"milk_and_honey_02_19",
	"milk_and_honey_02_20",
	"milk_and_honey_02_21",
	"milk_and_honey_02_22",
	"milk_and_honey_02_23"
	}

farming_vegetableconf.sprite["Honey"] = {
	"milk_and_honey_02_0",
	"milk_and_honey_02_1",
	"milk_and_honey_02_2",
	"milk_and_honey_02_3",
	"milk_and_honey_02_4",
	"milk_and_honey_02_5",
	"milk_and_honey_02_6",
	"milk_and_honey_02_7"
	}



farming_vegetableconf.sprite["Hops"] = {
		"crop_farming_03_24",
		"crop_farming_03_25",
		"crop_farming_03_26",
		"crop_farming_03_27",
		"crop_farming_03_28",
		"crop_farming_03_29",
		"crop_farming_03_30",
		"crop_farming_03_31"
		}


farming_vegetableconf.sprite["Cotton"] = {
		"crop_farming_03_16",
		"crop_farming_03_17",
		"crop_farming_03_18",
		"crop_farming_03_19",
		"crop_farming_03_20",
		"crop_farming_03_21",
		"crop_farming_03_22",
		"crop_farming_03_23"
		}

farming_vegetableconf.sprite["Rice"] = {
	"crop_farming_03_8",
	"crop_farming_03_9",
	"crop_farming_03_10",
	"crop_farming_03_11",
	"crop_farming_03_12",
	"crop_farming_03_13",
	"crop_farming_03_14",
	"crop_farming_03_15"
	}
	farming_vegetableconf.sprite["PepperPlant"] = {
	"crop_farming_03_0",
	"crop_farming_03_1",
	"crop_farming_03_2",
	"crop_farming_03_3",
	"crop_farming_03_4",
	"crop_farming_03_5",
	"crop_farming_03_6",
	"crop_farming_03_7"
	}
farming_vegetableconf.sprite["Leek"] = {
"crop_farming_02_0",
"crop_farming_02_1",
"crop_farming_02_2",
"crop_farming_02_3",
"crop_farming_02_4",
"crop_farming_02_5",
"crop_farming_02_6",
"crop_farming_02_7 "
}
farming_vegetableconf.sprite["Lettuce"] = {
"trees_farming_02_32",
"trees_farming_02_33",
"trees_farming_02_34",
"trees_farming_02_35",
"trees_farming_02_36",
"trees_farming_02_37",
"trees_farming_02_38",
"trees_farming_02_39"
}
farming_vegetableconf.sprite["Onion"] = {
"crop_farming_01_56",
"crop_farming_01_57",
"crop_farming_01_58",
"crop_farming_01_59",
"crop_farming_01_60",
"crop_farming_01_61",
"crop_farming_01_62"
}
farming_vegetableconf.sprite["SoyBean"] = {
"crop_farming_01_24",
"crop_farming_01_25",
"crop_farming_01_26",
"crop_farming_01_27",
"crop_farming_01_28",
"crop_farming_01_29",
"crop_farming_01_30",
"crop_farming_01_31"
}
farming_vegetableconf.sprite["Pumpkin"] = {
"trees_farming_02_24",
"trees_farming_02_25",
"trees_farming_02_26",
"trees_farming_02_27",
"trees_farming_02_28",
"trees_farming_02_29",
"trees_farming_02_30",
"trees_farming_02_31"
}
farming_vegetableconf.sprite["Watermelon"] = {
"trees_farming_02_48",
"trees_farming_02_49",
"trees_farming_02_50",
"trees_farming_02_51",
"trees_farming_02_52",
"trees_farming_02_53",
"trees_farming_02_54",
"trees_farming_02_55"
}
farming_vegetableconf.sprite["Zucchini"] = {
"trees_farming_02_56",
"trees_farming_02_57",
"trees_farming_02_58",
"trees_farming_02_59",
"trees_farming_02_60",
"trees_farming_02_61",
"trees_farming_02_62",
"trees_farming_02_63"
}
farming_vegetableconf.sprite["Corn"] = {
"vegetation_farming_01_72",
"vegetation_farming_01_73",
"vegetation_farming_01_74",
"vegetation_farming_01_75",
"vegetation_farming_01_76",
"vegetation_farming_01_77",
"vegetation_farming_01_78",
"vegetation_farming_01_79"
}
farming_vegetableconf.sprite["Ginger"] = {
"crop_farming_01_16",
"crop_farming_01_17",
"crop_farming_01_18",
"crop_farming_01_19",
"crop_farming_01_20",
"crop_farming_01_21",
"crop_farming_01_22",
"crop_farming_01_23"
}

farming_vegetableconf.sprite["BellPepper"] = {
"crop_farming_02_16",
"crop_farming_02_17",
"crop_farming_02_18",
"crop_farming_02_19",
"crop_farming_02_20",
"crop_farming_02_21",
"crop_farming_02_22",
"crop_farming_02_23"
}
farming_vegetableconf.sprite["Eggplant"] = {
"crop_farming_02_24",
"crop_farming_02_25",
"crop_farming_02_26",
"crop_farming_02_27",
"crop_farming_02_28",
"crop_farming_02_29",
"crop_farming_02_30",
"crop_farming_02_31"
}
farming_vegetableconf.sprite["Wheat"] = {
"crop_farming_02_56",
"crop_farming_02_57",
"crop_farming_02_58",
"crop_farming_02_59",
"crop_farming_02_60",
"crop_farming_02_61",
"crop_farming_02_62",
"crop_farming_02_63"
}
farming_vegetableconf.sprite["SugarCane"] = {
"crop_farming_02_48",
"crop_farming_02_49",
"crop_farming_02_50",
"crop_farming_02_51",
"crop_farming_02_52",
"crop_farming_02_53",
"crop_farming_02_54",
"crop_farming_02_55"
}
farming_vegetableconf.sprite["Ginseng"] = {
"crop_farming_01_48",
"crop_farming_01_49",
"crop_farming_01_50",
"crop_farming_01_51",
"crop_farming_01_52",
"crop_farming_01_53",
"crop_farming_01_54",
"crop_farming_01_55"
}
farming_vegetableconf.sprite["Grape"] = {
"crop_farming_02_32",
"crop_farming_02_33",
"crop_farming_02_34",
"crop_farming_02_35",
"crop_farming_02_36",
"crop_farming_02_37",
"crop_farming_02_38",
"crop_farming_02_39"
}


farming_vegetableconf.sprite["Lemon"] = {
"trees_farming_01_16",
"trees_farming_01_17",
"trees_farming_01_18",
"trees_farming_01_19",
"trees_farming_01_20",
"trees_farming_01_21",
"trees_farming_01_22",
"trees_farming_01_23"
}

farming_vegetableconf.sprite["Orange"] = {
"trees_farming_02_16",
"trees_farming_02_17",
"trees_farming_02_18",
"trees_farming_02_19",
"trees_farming_02_20",
"trees_farming_02_21",
"trees_farming_02_22",
"trees_farming_02_23"
}

farming_vegetableconf.sprite["Apple"] = {
"trees_farming_01_0",
"trees_farming_01_1",
"trees_farming_01_2",
"trees_farming_01_3",
"trees_farming_01_4",
"trees_farming_01_5",
"trees_farming_01_6",
"trees_farming_01_7"
}

farming_vegetableconf.sprite["Peach"] = {
"trees_farming_01_56",
"trees_farming_01_57",
"trees_farming_01_58",
"trees_farming_01_59",
"trees_farming_01_60",
"trees_farming_01_61",
"trees_farming_01_62",
"trees_farming_01_63"
}

farming_vegetableconf.sprite["Banana"] = {
"trees_farming_02_0",
"trees_farming_02_1",
"trees_farming_02_2",
"trees_farming_02_3",
"trees_farming_02_4",
"trees_farming_02_5",
"trees_farming_02_6",
"trees_farming_02_7"
}

farming_vegetableconf.sprite["Cherry"] = {
"trees_farming_01_32",
"trees_farming_01_33",
"trees_farming_01_34",
"trees_farming_01_35",
"trees_farming_01_36",
"trees_farming_01_37",
"trees_farming_01_38",
"trees_farming_01_39"
}

farming_vegetableconf.sprite["Pineapple"] = {
"crop_farming_01_32",
"crop_farming_01_33",
"crop_farming_01_34",
"crop_farming_01_35",
"crop_farming_01_36",
"crop_farming_01_37",
"crop_farming_01_38",
"crop_farming_01_39"
}

farming_vegetableconf.sprite["Lime"] = {
"trees_farming_01_24",
"trees_farming_01_25",
"trees_farming_01_26",
"trees_farming_01_27",
"trees_farming_01_28",
"trees_farming_01_29",
"trees_farming_01_30",
"trees_farming_01_31"
}

farming_vegetableconf.sprite["Avocado"] = {
"trees_farming_01_8",
"trees_farming_01_9",
"trees_farming_01_10",
"trees_farming_01_11",
"trees_farming_01_12",
"trees_farming_01_13",
"trees_farming_01_14",
"trees_farming_01_15"
}
farming_vegetableconf.sprite["BerryBlack"] = {
"crop_farming_01_0",
"crop_farming_01_1",
"crop_farming_01_2",
"crop_farming_01_3",
"crop_farming_01_4",
"crop_farming_01_5",
"crop_farming_01_6",
"crop_farming_01_7"
}

farming_vegetableconf.sprite["Mushroom"] = {
"trees_farming_02_40",
"trees_farming_02_41",
"trees_farming_02_42",
"trees_farming_02_43",
"trees_farming_02_44",
"trees_farming_02_45",
"trees_farming_02_46",
"trees_farming_02_47"
}

farming_vegetableconf.sprite["Mongui"] = {
	"trees_farming_02_40",
	"trees_farming_02_41",
	"trees_farming_02_42",
	"trees_farming_02_43",
	"trees_farming_02_44",
	"trees_farming_02_45",
	"trees_farming_02_46",
	"trees_farming_02_47"
	}

farming_vegetableconf.sprite["Lemongrass"] = {
"crop_farming_02_8",
"crop_farming_02_9",
"crop_farming_02_10",
"crop_farming_02_11",
"crop_farming_02_12",
"crop_farming_02_13",
"crop_farming_02_14",
"crop_farming_02_15"
}

farming_vegetableconf.sprite["BerryBlue"] = {
"crop_farming_01_8",
"crop_farming_01_9",
"crop_farming_01_10",
"crop_farming_01_11",
"crop_farming_01_12",
"crop_farming_01_13",
"crop_farming_01_14",
"crop_farming_01_15"
}

farming_vegetableconf.sprite["Olive"] = {
"trees_farming_01_48",
"trees_farming_01_49",
"trees_farming_01_50",
"trees_farming_01_51",
"trees_farming_01_52",
"trees_farming_01_53",
"trees_farming_01_54",
"trees_farming_01_55"
}

farming_vegetableconf.sprite["Mango"] = {
"trees_farming_02_8",
"trees_farming_02_9",
"trees_farming_02_10",
"trees_farming_02_11",
"trees_farming_02_12",
"trees_farming_02_13",
"trees_farming_02_14",
"trees_farming_02_15"
}

farming_vegetableconf.sprite["GrapeFruit"] = {
"trees_farming_01_40",
"trees_farming_01_41",
"trees_farming_01_42",
"trees_farming_01_43",
"trees_farming_01_44",
"trees_farming_01_45",
"trees_farming_01_46",
"trees_farming_01_47"
}

-----------------------------------------------------------

farming_vegetableconf.icons["Pear"] = "Item_Pear";
farming_vegetableconf.icons["CommonMallow"] = "media/textures/WorldItems/CommonMallowGrapeLeaves.png";
farming_vegetableconf.icons["Plantain"] = "media/textures/WorldItems/MedicinalHerbsLeafBundle.png";
farming_vegetableconf.icons["Comfrey"] = "media/textures/WorldItems/Dandelion.png";
farming_vegetableconf.icons["Garlic"] = "Item_HerbChives";
farming_vegetableconf.icons["Sage"] = "Item_BlackSage";
farming_vegetableconf.sprite["Pear"] = {
	"Farming_add_01_0",
	"Farming_add_01_1",
	"Farming_add_01_2",
	"Farming_add_01_3",
	"Farming_add_01_4",
	"Farming_add_01_5",
	"Farming_add_01_6",
	"Farming_add_01_7"
	}
farming_vegetableconf.sprite["CommonMallow"] = {
	"Farming_add_01_16",
	"Farming_add_01_17",
	"Farming_add_01_18",
	"Farming_add_01_19",
	"Farming_add_01_20",
	"Farming_add_01_21",
	"Farming_add_01_22",
	"Farming_add_01_23"
	}

		farming_vegetableconf.sprite["Comfrey"] = {
			"Farming_add_01_8",
			"Farming_add_01_9",
			"Farming_add_01_10",
			"Farming_add_01_11",
			"Farming_add_01_12",
			"Farming_add_01_13",
			"Farming_add_01_14",
			"Farming_add_01_15"
			}
		farming_vegetableconf.sprite["Plantain"] = {
			"Farming_add_01_24",
			"Farming_add_01_25",
			"Farming_add_01_26",
			"Farming_add_01_27",
			"Farming_add_01_28",
			"Farming_add_01_29",
			"Farming_add_01_30",
			"Farming_add_01_31"
			}
			farming_vegetableconf.sprite["Sage"] = {
				"Farming_add_01_32",
				"Farming_add_01_33",
				"Farming_add_01_34",
				"Farming_add_01_35",
				"Farming_add_01_36",
				"Farming_add_01_37",
				"Farming_add_01_38",
				"Farming_add_01_39"
				}
			farming_vegetableconf.sprite["Coca"] = {
				"Farming_add_01_32",
				"Farming_add_01_33",
				"Farming_add_01_34",
				"Farming_add_01_35",
				"Farming_add_01_36",
				"Farming_add_01_37",
				"Farming_add_01_38",
				"Farming_add_01_39"
				}
			farming_vegetableconf.sprite["Garlic"] = {
				"Farming_add_01_48",
				"Farming_add_01_49",
				"Farming_add_01_50",
				"Farming_add_01_51",
				"Farming_add_01_52",
				"Farming_add_01_53",
				"Farming_add_01_54",
				"Farming_add_01_55"
				}

				
-- Pear
farming_vegetableconf.props["Pear"] = {};
farming_vegetableconf.props["Pear"].seedsRequired = 1;
farming_vegetableconf.props["Pear"].texture = "Farming_add_01_6";
farming_vegetableconf.props["Pear"].waterLvl = 85;
farming_vegetableconf.props["Pear"].timeToGrow = ZombRand(80, 100);
farming_vegetableconf.props["Pear"].minVeg = 4;
farming_vegetableconf.props["Pear"].maxVeg = 6;
farming_vegetableconf.props["Pear"].minVegAutorized = 8;
farming_vegetableconf.props["Pear"].maxVegAutorized = 10;
farming_vegetableconf.props["Pear"].vegetableName = "Base.Pear";
farming_vegetableconf.props["Pear"].growCode = "farming_vegetableconf.growTree";
farming_vegetableconf.props["Pear"].seedName = "Sprout.PearSeeds";
farming_vegetableconf.props["Pear"].seedPerVeg = ZombRand(1,5);
farming_vegetableconf.props["Pear"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Pear"].phaseName6 = "Farming_Ready for Harvest";

farming_vegetableconf.props["CommonMallow"] = {};
farming_vegetableconf.props["CommonMallow"].seedsRequired = 4;
farming_vegetableconf.props["CommonMallow"].texture = "Farming_add_01_21";
farming_vegetableconf.props["CommonMallow"].waterLvl = 85;
farming_vegetableconf.props["CommonMallow"].timeToGrow = ZombRand(46, 52);
farming_vegetableconf.props["CommonMallow"].vegetableName = "CommonMallow";
farming_vegetableconf.props["CommonMallow"].seedName = "Sprout.CommonMallowSeeds";
farming_vegetableconf.props["CommonMallow"].growCode = "farming_vegetableconf.growFlowers";
farming_vegetableconf.props["CommonMallow"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["CommonMallow"].minVeg = 3;
farming_vegetableconf.props["CommonMallow"].maxVeg = 6;
farming_vegetableconf.props["CommonMallow"].minVegAutorized = 10;
farming_vegetableconf.props["CommonMallow"].maxVegAutorized = 15;
farming_vegetableconf.props["CommonMallow"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["CommonMallow"].phaseName6 = "Farming_Ready for Harvest";

farming_vegetableconf.props["Plantain"] = {};
farming_vegetableconf.props["Plantain"].seedsRequired = 4;
farming_vegetableconf.props["Plantain"].texture = "Farming_add_01_29";
farming_vegetableconf.props["Plantain"].waterLvl = 85;
farming_vegetableconf.props["Plantain"].timeToGrow = ZombRand(46, 52);
farming_vegetableconf.props["Plantain"].vegetableName = "Plantain";
farming_vegetableconf.props["Plantain"].seedName = "Sprout.PlantainSeeds";
farming_vegetableconf.props["Plantain"].growCode = "farming_vegetableconf.growFlowers";
farming_vegetableconf.props["Plantain"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Plantain"].minVeg = 3;
farming_vegetableconf.props["Plantain"].maxVeg = 6;
farming_vegetableconf.props["Plantain"].minVegAutorized = 10;
farming_vegetableconf.props["Plantain"].maxVegAutorized = 15;
farming_vegetableconf.props["Plantain"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Plantain"].phaseName6 = "Farming_Ready for Harvest";

farming_vegetableconf.props["Comfrey"] = {};
farming_vegetableconf.props["Comfrey"].seedsRequired = 4;
farming_vegetableconf.props["Comfrey"].texture = "Farming_add_01_14";
farming_vegetableconf.props["Comfrey"].waterLvl = 85;
farming_vegetableconf.props["Comfrey"].timeToGrow = ZombRand(46, 52);
farming_vegetableconf.props["Comfrey"].vegetableName = "Comfrey";
farming_vegetableconf.props["Comfrey"].seedName = "Sprout.ComfreySeeds";
farming_vegetableconf.props["Comfrey"].growCode = "farming_vegetableconf.growFlowers";
farming_vegetableconf.props["Comfrey"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Comfrey"].minVeg = 3;
farming_vegetableconf.props["Comfrey"].maxVeg = 6;
farming_vegetableconf.props["Comfrey"].minVegAutorized = 10;
farming_vegetableconf.props["Comfrey"].maxVegAutorized = 15;
farming_vegetableconf.props["Comfrey"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Comfrey"].phaseName6 = "Farming_Ready for Harvest";

farming_vegetableconf.props["Garlic"] = {};
farming_vegetableconf.props["Garlic"].seedsRequired = 4;
farming_vegetableconf.props["Garlic"].texture = "Farming_add_01_53";
farming_vegetableconf.props["Garlic"].waterLvl = 85;
farming_vegetableconf.props["Garlic"].timeToGrow = ZombRand(46, 52);
farming_vegetableconf.props["Garlic"].vegetableName = "WildGarlic";
farming_vegetableconf.props["Garlic"].seedName = "Sprout.GarlicSeeds";
farming_vegetableconf.props["Garlic"].growCode = "farming_vegetableconf.growFlowers";
farming_vegetableconf.props["Garlic"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Garlic"].minVeg = 3;
farming_vegetableconf.props["Garlic"].maxVeg = 6;
farming_vegetableconf.props["Garlic"].minVegAutorized = 10;
farming_vegetableconf.props["Garlic"].maxVegAutorized = 15;
farming_vegetableconf.props["Garlic"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Garlic"].phaseName6 = "Farming_Ready for Harvest";

farming_vegetableconf.props["Sage"] = {};
farming_vegetableconf.props["Sage"].seedsRequired = 4;
farming_vegetableconf.props["Sage"].texture = "Farming_add_01_37";
farming_vegetableconf.props["Sage"].waterLvl = 85;
farming_vegetableconf.props["Sage"].timeToGrow = ZombRand(46, 52);
farming_vegetableconf.props["Sage"].vegetableName = "Base.BlackSage";
farming_vegetableconf.props["Sage"].seedName = "Sprout.BlackSageSeeds";
farming_vegetableconf.props["Sage"].growCode = "farming_vegetableconf.growFlowers";
farming_vegetableconf.props["Sage"].seedPerVeg = ZombRand(1,3);
farming_vegetableconf.props["Sage"].minVeg = 3;
farming_vegetableconf.props["Sage"].maxVeg = 6;
farming_vegetableconf.props["Sage"].minVegAutorized = 10;
farming_vegetableconf.props["Sage"].maxVegAutorized = 15;
farming_vegetableconf.props["Sage"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Sage"].phaseName6 = "Farming_Ready for Harvest";


farming_vegetableconf.props["Coca"] = {};
farming_vegetableconf.props["Coca"].seedsRequired = 6;
farming_vegetableconf.props["Coca"].texture = "Farming_add_01_37";
farming_vegetableconf.props["Coca"].waterLvl = 85;
farming_vegetableconf.props["Coca"].timeToGrow = ZombRand(46, 52);
farming_vegetableconf.props["Coca"].vegetableName = "Sprout.HojadeCoca";
farming_vegetableconf.props["Coca"].seedName = "Sprout.CocaSeeds";
farming_vegetableconf.props["Coca"].growCode = "farming_vegetableconf.growFlowers";
farming_vegetableconf.props["Coca"].seedPerVeg = ZombRand(0,0);
farming_vegetableconf.props["Coca"].minVeg = 3;
farming_vegetableconf.props["Coca"].maxVeg = 6;
farming_vegetableconf.props["Coca"].minVegAutorized = 10;
farming_vegetableconf.props["Coca"].maxVegAutorized = 15;
farming_vegetableconf.props["Coca"].phaseName5 = "Farming_Blooming";
farming_vegetableconf.props["Coca"].phaseName6 = "Farming_Ready for Harvest";