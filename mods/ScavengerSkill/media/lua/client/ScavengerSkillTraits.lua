local function initScavengerSkillTraits()
    local scavengerTrait = TraitFactory.addTrait("vulture", getText("UI_trait_vulture"), 4, getText("UI_trait_vulturedesc"), false, false);
    scavengerTrait:addXPBoost(Perks.Scavenging, 1);
end

Events.OnGameBoot.Add(initScavengerSkillTraits);