-- Made by Snake

LGBaseGameCharacterDetails = {}

LGBaseGameCharacterDetails.DoTraits = function()
	

	local efish = TraitFactory.addTrait("FishExpert", getText("UI_trait_fishexp"), 3, getText("UI_trait_fishexpdesc"), false);
	efish:getFreeRecipes():add("Make fishing dough");
	efish:getFreeRecipes():add("Make strong fishing dough");
	efish:getFreeRecipes():add("Make fishing tackle");
	efish:getFreeRecipes():add("Add dough on fishing tackle");
	efish:getFreeRecipes():add("Add strong dough on fishing tackle");
	efish:getFreeRecipes():add("Add cricket on fishing tackle");
	efish:getFreeRecipes():add("Add worm on fishing tackle");
	efish:getFreeRecipes():add("Add red worm on fishing tackle");
	efish:getFreeRecipes():add("Add grasshopper on fishing tackle");
	efish:getFreeRecipes():add("Add cockroach on fishing tackle");
	efish:getFreeRecipes():add("Add baitfish on fishing tackle");
	efish:getFreeRecipes():add("Make fishing tackle2");
	efish:getFreeRecipes():add("Add dough on fishing tackle2");
	efish:getFreeRecipes():add("Add strong dough on fishing tackle2");
	efish:getFreeRecipes():add("Add cricket on fishing tackle2");
	efish:getFreeRecipes():add("Add worm on fishing tackle2");
	efish:getFreeRecipes():add("Add red worm on fishing tackle2");
	efish:getFreeRecipes():add("Add grasshopper on fishing tackle2");
	efish:getFreeRecipes():add("Add cockroach on fishing tackle2");
	efish:getFreeRecipes():add("Add baitfish on fishing tackle2");
	efish:getFreeRecipes():add("Add dentudo on fishing tackle2");
	efish:getFreeRecipes():add("Add anguila on fishing tackle2");
	efish:getFreeRecipes():add("Make fishing tackle3");
	efish:getFreeRecipes():add("Add dentudo on fishing tackle3");
	efish:getFreeRecipes():add("Add crab on fishing tackle3");
	efish:getFreeRecipes():add("Add pejerrey on fishing tackle3");
	efish:getFreeRecipes():add("Add rat on fishing tackle3");
	efish:getFreeRecipes():add("Add mouse on fishing tackle3");
	efish:getFreeRecipes():add("Add frog on fishing tackle3");
	efish:getFreeRecipes():add("Add anguila on fishing tackle3");
	efish:getFreeRecipes():add("Make fishing tackle4");
	
	efish:getFreeRecipes():add("Add dough on fishing tackle4");
	efish:getFreeRecipes():add("Add strong dough on fishing tackle4");
	efish:getFreeRecipes():add("Add cricket on fishing tackle4");
	efish:getFreeRecipes():add("Add worm on fishing tackle4");
	efish:getFreeRecipes():add("Add red worm on fishing tackle4");
	efish:getFreeRecipes():add("Add grasshopper on fishing tackle4");
	efish:getFreeRecipes():add("Add cockroach on fishing tackle4");
	efish:getFreeRecipes():add("Add baitfish on fishing tackle4");
	
	efish:getFreeRecipes():add("Make fishing tackle5");
	efish:getFreeRecipes():add("Add Dentudo on fishing tackle5");
	efish:getFreeRecipes():add("Add Pejerrey on fishing tackle5");
	efish:getFreeRecipes():add("Add Peach on fishing tackle5");
	efish:getFreeRecipes():add("Add dough on fishing tackle5");
	efish:getFreeRecipes():add("Add strong dough on fishing tackle5");
	efish:getFreeRecipes():add("Add turtle on fishing tackle5");
	efish:getFreeRecipes():add("Add anguila on fishing tackle5");

	efish:getFreeRecipes():add("Make fishing tackle6");
	efish:getFreeRecipes():add("Add anguila on fishing tackle6");
	efish:getFreeRecipes():add("Add rat on fishing tackle6");
	efish:getFreeRecipes():add("Add frog on fishing tackle6");
	efish:getFreeRecipes():add("Add mouse on fishing tackle6");


--	local icht = TraitFactory.addTrait("ichthyologist", getText("UI_trait_ichthyologist"), 2, getText("UI_trait_ichthyologistdesc"), false);
	local sfisherman = TraitFactory.addTrait("sportfisherman", getText("UI_trait_sportfisherman"), 2, getText("UI_trait_sportfishermandesc"), false);

    TraitFactory.sortList();
	--BaseGameCharacterDetails.SetTraitDescription(archery)
end



LGBaseGameCharacterDetails.checkstate  = function()
	local player = getSpecificPlayer(0);
	if player:getDescriptor():getProfession() == "fisherman" then
		--Rasgos
		if not player:HasTrait("FishExpert") then
			player:getTraits():add("FishExpert");
		end
		--Recetas de FishExpert
		LGBaseGameCharacterDetails.AddFishermanRecipes();
	else
	end
end


function LGBaseGameCharacterDetails:AddFishermanRecipes()
	local player = getPlayer();
	local plrecipe = player:getKnownRecipes();
	--Recetas de pescador
	if not plrecipe:contains("Make fishing dough") then
		plrecipe:add("Make fishing dough");
	end
	if not plrecipe:contains("Make strong fishing dough") then
		plrecipe:add("Make strong fishing dough");
	end
	if not plrecipe:contains("Make fishing tackle") then
		plrecipe:add("Make fishing tackle");
	end
	if not plrecipe:contains("Add dough on fishing tackle") then
		plrecipe:add("Add dough on fishing tackle");
	end
	if not plrecipe:contains("Add strong dough on fishing tackle") then
		plrecipe:add("Add strong dough on fishing tackle");
	end
	if not plrecipe:contains("Add cricket on fishing tackle") then
		plrecipe:add("Add cricket on fishing tackle");
	end
	if not plrecipe:contains("Add worm on fishing tackle") then
		plrecipe:add("Add worm on fishing tackle");
	end
	if not plrecipe:contains("Add red worm on fishing tackle") then
		plrecipe:add("Add red worm on fishing tackle");
	end
	if not plrecipe:contains("Add grasshopper on fishing tackle") then
		plrecipe:add("Add grasshopper on fishing tackle");
	end
	if not plrecipe:contains("Add cockroach on fishing tackle") then
		plrecipe:add("Add cockroach on fishing tackle");
	end
	if not plrecipe:contains("Add baitfish on fishing tackle") then
		plrecipe:add("Add baitfish on fishing tackle");
	end

	if not plrecipe:contains("Make fishing tackle2") then
		plrecipe:add("Make fishing tackle2");
	end
	if not plrecipe:contains("Add dough on fishing tackle2") then
		plrecipe:add("Add dough on fishing tackle2");
	end
	if not plrecipe:contains("Add strong dough on fishing tackle2") then
		plrecipe:add("Add strong dough on fishing tackle2");
	end
	if not plrecipe:contains("Add cricket on fishing tackle2") then
		plrecipe:add("Add cricket on fishing tackle2");
	end
	if not plrecipe:contains("Add worm on fishing tackle2") then
		plrecipe:add("Add worm on fishing tackle2");
	end
	if not plrecipe:contains("Add red worm on fishing tackle2") then
		plrecipe:add("Add red worm on fishing tackle2");
	end
	if not plrecipe:contains("Add grasshopper on fishing tackle2") then
		plrecipe:add("Add grasshopper on fishing tackle2");
	end
	if not plrecipe:contains("Add cockroach on fishing tackle2") then
		plrecipe:add("Add cockroach on fishing tackle2");
	end
	if not plrecipe:contains("Add baitfish on fishing tackle2") then
		plrecipe:add("Add baitfish on fishing tackle2");
	end
	if not plrecipe:contains("Add dentudo on fishing tackle2") then
		plrecipe:add("Add dentudo on fishing tackle2");
	end
	if not plrecipe:contains("Add anguila on fishing tackle2") then
		plrecipe:add("Add anguila on fishing tackle2");
	end

	if not plrecipe:contains("Make fishing tackle3") then
		plrecipe:add("Make fishing tackle3");
	end
	if not plrecipe:contains("Add dentudo on fishing tackle3") then
		plrecipe:add("Add dentudo on fishing tackle3");
	end
	if not plrecipe:contains("Add crab on fishing tackle3") then
		plrecipe:add("Add crab on fishing tackle3");
	end
	if not plrecipe:contains("Add pejerrey on fishing tackle3") then
		plrecipe:add("Add pejerrey on fishing tackle3");
	end
	if not plrecipe:contains("Add rat on fishing tackle3") then
		plrecipe:add("Add rat on fishing tackle3");
	end
	if not plrecipe:contains("Add mouse on fishing tackle3") then
		plrecipe:add("Add mouse on fishing tackle3");
	end
	if not plrecipe:contains("Add frog on fishing tackle3") then
		plrecipe:add("Add frog on fishing tackle3");
	end
	if not plrecipe:contains("Add anguila on fishing tackle3") then
		plrecipe:add("Add anguila on fishing tackle3");
	end

	if not plrecipe:contains("Make fishing tackle4") then
		plrecipe:add("Make fishing tackle4");
	end
	if not plrecipe:contains("Add dough on fishing tackle4") then
		plrecipe:add("Add dough on fishing tackle4");
	end
	if not plrecipe:contains("Add strong dough on fishing tackle4") then
		plrecipe:add("Add strong dough on fishing tackle4");
	end
	if not plrecipe:contains("Add cricket on fishing tackle4") then
		plrecipe:add("Add cricket on fishing tackle4");
	end
	if not plrecipe:contains("Add worm on fishing tackle4") then
		plrecipe:add("Add worm on fishing tackle4");
	end
	if not plrecipe:contains("Add red worm on fishing tackle4") then
		plrecipe:add("Add red worm on fishing tackle4");
	end
	if not plrecipe:contains("Add grasshopper on fishing tackle4") then
		plrecipe:add("Add grasshopper on fishing tackle4");
	end
	if not plrecipe:contains("Add cockroach on fishing tackle4") then
		plrecipe:add("Add cockroach on fishing tackle4");
	end
	if not plrecipe:contains("Add baitfish on fishing tackle4") then
		plrecipe:add("Add baitfish on fishing tackle4");
	end

	if not plrecipe:contains("Make fishing tackle5") then
		plrecipe:add("Make fishing tackle5");
	end
	if not plrecipe:contains("Add Dentudo on fishing tackle5") then
		plrecipe:add("Add Dentudo on fishing tackle5");
	end
	if not plrecipe:contains("Add Pejerrey on fishing tackle5") then
		plrecipe:add("Add Pejerrey on fishing tackle5");
	end
	if not plrecipe:contains("Add Peach on fishing tackle5") then
		plrecipe:add("Add Peach on fishing tackle5");
	end
	if not plrecipe:contains("Add dough on fishing tackle5") then
		plrecipe:add("Add dough on fishing tackle5");
	end
	if not plrecipe:contains("Add strong dough on fishing tackle5") then
		plrecipe:add("Add strong dough on fishing tackle5");
	end
	if not plrecipe:contains("Add turtle on fishing tackle5") then
		plrecipe:add("Add turtle on fishing tackle5");
	end
	if not plrecipe:contains("Add anguila on fishing tackle5") then
		plrecipe:add("Add anguila on fishing tackle5");
	end

	if not plrecipe:contains("Make fishing tackle6") then
		plrecipe:add("Make fishing tackle6");
	end
	if not plrecipe:contains("Add anguila on fishing tackle6") then
		plrecipe:add("Add anguila on fishing tackle6");
	end
	if not plrecipe:contains("Add rat on fishing tackle6") then
		plrecipe:add("Add rat on fishing tackle6");
	end
	if not plrecipe:contains("Add frog on fishing tackle6") then
		plrecipe:add("Add frog on fishing tackle6");
	end
	if not plrecipe:contains("Add mouse on fishing tackle6") then
		plrecipe:add("Add mouse on fishing tackle6");
	end
end

Events.OnGameBoot.Add(LGBaseGameCharacterDetails.DoTraits);
Events.OnGameBoot.Add(LGBaseGameCharacterDetails.DoProfessions);
Events.OnGameStart.Add(LGBaseGameCharacterDetails.checkstate);