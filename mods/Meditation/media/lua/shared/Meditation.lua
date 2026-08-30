-- Yogi Trait

Yogi = Yogi or {}

Yogi.trait = function()
    Yogi.yogi = TraitFactory.addTrait("Yogi", "Yogi", 2, "You practice meditation frequently. You are one with the Force, and the Force is with you.", false)
    Yogi.yogi:addXPBoost(Perks.Lightfoot, 1)
end

Events.OnGameBoot.Add(Yogi.trait)
