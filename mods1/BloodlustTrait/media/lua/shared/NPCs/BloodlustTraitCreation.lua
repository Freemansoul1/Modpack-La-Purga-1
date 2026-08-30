

BloodlustTraitCharacter = {}

BloodlustTraitCharacter.DoTraits = function()

	local mods = getActivatedMods()
	local cost
	if mods:contains("BloodlustTrait8Points1") then
		cost = 8
	elseif mods:contains("BloodlustTrait6Points") then
		cost = 6
	elseif mods:contains("BloodlustTrait4Points") then
		cost = 4
	elseif mods:contains("BloodlustTraitN2Points") then
		cost = -2
	elseif mods:contains("BloodlustTraitN4Points") then
		cost = -4
	else
		cost = 0 -- Cannot pick the trait by default
	end

	TraitFactory.addTrait("BloodlustTrait", getText("UI_trait_bloodlust"), cost, getText("UI_trait_bloodlust_desc"), false)
	print("Registered the Bloodlust Trait with cost "..tostring(cost))

	TraitFactory.setMutualExclusive("BloodlustTrait", "Hemophobic")

	--- This code is used in the game after all the traits are added
    TraitFactory.sortList()
	local traits = TraitFactory.getTraits()
	for i=0, traits:size()-1 do
		local trait = traits:get(i)
		BaseGameCharacterDetails.SetTraitDescription(trait)
	end
end

Events.OnGameBoot.Add(BloodlustTraitCharacter.DoTraits)
