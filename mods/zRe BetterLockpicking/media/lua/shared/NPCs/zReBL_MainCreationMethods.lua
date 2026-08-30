if getActivatedMods():contains("zReS_ProfReworkbykERHUS1") then return end

zReBLBaseGameCharacterDetails = {}

zReBLBaseGameCharacterDetails.DoTraits = function()

	local nimblefingers = TraitFactory.addTrait("Nimblefingers", getText("UI_trait_nimblefingers"), 3, getText("UI_trait_nimblefingersDesc"), false);
	nimblefingers:addXPBoost(Perks.Lockpicking, 2)
	nimblefingers:getFreeRecipes():add("Lockpicking");
	nimblefingers:getFreeRecipes():add("Alarm check");
	nimblefingers:getFreeRecipes():add("Create BobbyPin");
	nimblefingers:getFreeRecipes():add("Create BobbyPin2");
	
	local burglar = TraitFactory.addTrait("Burglar", getText("UI_prof_Burglar"), 0, getText("UI_trait_BurglarDesc"), true);
	burglar:getFreeRecipes():add("Lockpicking");
	burglar:getFreeRecipes():add("Alarm check");
	burglar:getFreeRecipes():add("Create BobbyPin");
	burglar:getFreeRecipes():add("Create BobbyPin2");
		
	TraitFactory.setMutualExclusive("Nimblefingers", "Burglar");
	
    TraitFactory.sortList();
end

zReBLBaseGameCharacterDetails.DoProfessions = function()

	local burglar = ProfessionFactory.addProfession("burglar", getText("UI_prof_Burglar"), "profession_burglar2", -4);
	burglar:addXPBoost(Perks.Nimble, 1)
	burglar:addXPBoost(Perks.Sneak, 2)
	burglar:addXPBoost(Perks.Lightfoot, 1)
	burglar:addXPBoost(Perks.Lockpicking, 2)
	burglar:addFreeTrait("Burglar")
	
	local profList = ProfessionFactory.getProfessions()
		for i = 1, profList:size() do
		local prof = profList:get(i - 1)
		BaseGameCharacterDetails.SetProfessionDescription(prof)
	end
	
end

Events.OnGameBoot.Add(zReBLBaseGameCharacterDetails.DoTraits);
Events.OnGameBoot.Add(zReBLBaseGameCharacterDetails.DoProfessions);
Events.OnCreateLivingCharacter.Add(zReBLBaseGameCharacterDetails.DoProfessions);