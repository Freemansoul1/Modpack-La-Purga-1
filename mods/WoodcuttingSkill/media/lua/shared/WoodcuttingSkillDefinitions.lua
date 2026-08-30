
Woodcutting = {}

Woodcutting.testMode = false -- enable this for debug

Woodcutting.Settings = {
    ChanceOfExtrasOneIn = {
        -- chances must all be higher than 17 (max tree size 9 max perk level)
        Log = 40,
        TreeBranch = 35,
        Twigs = 30,

        Pinecone = 20, -- for pine trees only
        PineTreeExtra = 120, -- for pine trees only

        FruitTreeExtra = 80, -- for 'fruit' trees only
        Winter = 130 -- for 'fruit' trees only
    },

    cumulatedForagingAndWoodcuttingSkillLevelForFruit = 8, --Woodcutting + Foraging level required to spawn food
    skillLevelForNoSevereExhaustion = 8, --Woodcutting level required to disable severe exhaustion

    enduranceSavedPerPerkLevel = 0.02, -- 7%
    bonusConditionLowerOneInPerLevel = 1,
    caloriesSavedModifierPerLevel = 0.17,
    bonusAxeTreeDamagePerLevel = 2, -- flat addition, not multiplied

    xpMultiplier = 1,
}

Woodcutting.TreeFruitExtrasList = { -- except winter
    "Cherry",
    "Lemon",
    "Lime",
    "Grapefruit",
    "Peach",
    "Pear",
    "Apple",
    "Orange",
    "Banana",
    "Acorn",
    "DeadSquirrel",
}

Woodcutting.TreeFruitsWinterList = { -- for winter
    "DeadSquirrel",
}
Woodcutting.PineTreeExtrasList = { -- in all seasons
    "DeadSquirrel",
}
Woodcutting.TreePineSpriteDefinitions = {
    
    ["e_virginia_pineJUMBO_1_0"] = 1,
    ["e_virginia_pineJUMBO_1_1"] = 1,
    ["e_virginia_pine_1_0"] = 1,
    ["e_virginia_pine_1_1"] = 1,

    ["e_americanhollyJUMBO_1_1"] = 1,
    ["e_americanhollyJUMBO_1_0"] = 1,
    ["e_americanholly_1_1"] = 1,
    ["e_americanholly_1_0"] = 1,

    ["e_canadianhemlockJUMBO_1_0"] = 1,
    ["e_canadianhemlockJUMBO_1_1"] = 1,
    ["e_canadianhemlock_1_0"] = 1,
    ["e_canadianhemlock_1_1"] = 1,

}

function Woodcutting.noise(text)
    if Woodcutting.testMode then
        print(text)
    end
end

function Woodcutting.AdjustNatureAbundance()
    local chances = Woodcutting.Settings.ChanceOfExtrasOneIn
    if SandboxVars.NatureAbundance == 1 then -- very poor
        Woodcutting.Settings.ChanceOfExtrasOneIn.Log = math.floor(chances.Log * 1.2);
        Woodcutting.Settings.ChanceOfExtrasOneIn.TreeBranch = math.floor(chances.TreeBranch * 1.2);
        Woodcutting.Settings.ChanceOfExtrasOneIn.Twigs = math.floor(chances.Twigs * 1.2);
        Woodcutting.Settings.ChanceOfExtrasOneIn.Pinecone = math.floor(chances.Pinecone * 1.2);
        Woodcutting.Settings.ChanceOfExtrasOneIn.PineTreeExtra = math.floor(chances.PineTreeExtra * 1.2);
        Woodcutting.Settings.ChanceOfExtrasOneIn.FruitTreeExtra = math.floor(chances.FruitTreeExtra * 1.2);
        Woodcutting.Settings.ChanceOfExtrasOneIn.Winter = math.floor(chances.Winter * 1.2);
    elseif SandboxVars.NatureAbundance == 2 then -- poor
        Woodcutting.Settings.ChanceOfExtrasOneIn.Log = math.floor(chances.Log * 1.1);
        Woodcutting.Settings.ChanceOfExtrasOneIn.TreeBranch = math.floor(chances.TreeBranch * 1.1);
        Woodcutting.Settings.ChanceOfExtrasOneIn.Twigs = math.floor(chances.Twigs * 1.1);
        Woodcutting.Settings.ChanceOfExtrasOneIn.Pinecone = math.floor(chances.Pinecone * 1.1);
        Woodcutting.Settings.ChanceOfExtrasOneIn.PineTreeExtra = math.floor(chances.PineTreeExtra * 1.1);
        Woodcutting.Settings.ChanceOfExtrasOneIn.FruitTreeExtra =  math.floor(chances.FruitTreeExtra * 1.1);
        Woodcutting.Settings.ChanceOfExtrasOneIn.Winter = math.floor(chances.Winter * 1.2);
    elseif SandboxVars.NatureAbundance == 4 then -- abundant
        Woodcutting.Settings.ChanceOfExtrasOneIn.Log = math.floor(chances.Log * 0.9);
        Woodcutting.Settings.ChanceOfExtrasOneIn.TreeBranch = math.floor(chances.TreeBranch * 0.9);
        Woodcutting.Settings.ChanceOfExtrasOneIn.Twigs = math.floor(chances.Twigs * 0.9);
        Woodcutting.Settings.ChanceOfExtrasOneIn.Pinecone = math.floor(chances.Pinecone * 0.9);
        Woodcutting.Settings.ChanceOfExtrasOneIn.PineTreeExtra = math.floor(chances.PineTreeExtra * 0.9);
        Woodcutting.Settings.ChanceOfExtrasOneIn.FruitTreeExtra =  math.floor(chances.FruitTreeExtra * 0.9);
        Woodcutting.Settings.ChanceOfExtrasOneIn.Winter = math.floor(chances.Winter * 1.2);
    elseif SandboxVars.NatureAbundance == 5 then -- very abundant
        Woodcutting.Settings.ChanceOfExtrasOneIn.Log = math.floor(chances.Log * 0.8);
        Woodcutting.Settings.ChanceOfExtrasOneIn.TreeBranch = math.floor(chances.TreeBranch * 0.8);
        Woodcutting.Settings.ChanceOfExtrasOneIn.Twigs = math.floor(chances.Twigs * 0.8);
        Woodcutting.Settings.ChanceOfExtrasOneIn.Pinecone = math.floor(chances.Pinecone * 0.8);
        Woodcutting.Settings.ChanceOfExtrasOneIn.PineTreeExtra = math.floor(chances.PineTreeExtra * 0.8);
        Woodcutting.Settings.ChanceOfExtrasOneIn.FruitTreeExtra = math.floor(chances.FruitTreeExtra * 0.8);
        Woodcutting.Settings.ChanceOfExtrasOneIn.Winter = math.floor(chances.Winter *0.8);
    end
end

Events.OnGameStart.Add(Woodcutting.AdjustNatureAbundance)
Events.OnServerStarted.Add(Woodcutting.AdjustNatureAbundance)


return Woodcutting
