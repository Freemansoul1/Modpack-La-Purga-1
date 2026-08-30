

LastPushTraitCharacter = {}

LastPushTraitCharacter.DoTraits = function()

	local mods = getActivatedMods()
	local cost
	if mods:contains("LastPushTraitNotPickable") then
		cost = 0 -- Do not add the trait as pickable
	elseif mods:contains("LastPushTrait20Points") then
		cost = 20
	elseif mods:contains("LastPushTrait18Points") then
		cost = 18
	elseif mods:contains("LastPushTrait16Points") then
		cost = 16
	elseif mods:contains("LastPushTrait12Points") then
		cost = 12
	else
		cost = 10 -- The default cost if none of the submods are activated
	end

	TraitFactory.addTrait("LastPush", getText("UI_trait_lastpush"), cost, getText("UI_trait_lastpush_desc"), false)
	print("Registered the Last Push Trait with cost "..tostring(cost))

	--- This code is used in the game after all the traits are added
    TraitFactory.sortList()
	local traits = TraitFactory.getTraits()
	for i=0, traits:size()-1 do
		local trait = traits:get(i)
		BaseGameCharacterDetails.SetTraitDescription(trait)
	end
end

Events.OnGameBoot.Add(LastPushTraitCharacter.DoTraits)
