require 'SoulMain'

--- @param playerObj IsoPlayer
--- @param Soul Normal
function onGainSoul(playerObj, Soul)
    --- GET MODDATA
    local moddata = Soul:getModData()
    oldusername = moddata.PurgaSkills.username
    profname = moddata.PurgaSkills.profession
    addtraits = moddata.PurgaSkills.traits
    addweight = moddata.PurgaSkills.weight
    addcalories = moddata.PurgaSkills.calories
    addcarbohydrates = moddata.PurgaSkills.carbohydrates
    addlipids = moddata.PurgaSkills.lipids
    addproteins = moddata.PurgaSkills.proteins
    addXP = moddata.PurgaSkills.skills
    addboost = moddata.PurgaSkills.skillsB
    addrecipes = moddata.PurgaSkills.knownRecipes
    addvhs = moddata.PurgaSkills.recordedMedia

    -- GET CURRENT USERNAME
    local currentusername = playerObj:getUsername()

    -- CHECK IF USERNAME MATCH
    local usernameMatch = currentusername == oldusername

    -- Print the results
    if usernameMatch then
        print("match: true")
    else
        print("match: false")
    end
    
    -- If the total check is true, proceed with adding skills, weight, recipes, etc.
    if usernameMatch then
        -- GET PROFESSION TO CHECK
        playerObj:getDescriptor():setProfession(profname)

        -- GET TRAITS TO CHECK
        local playerTraits = playerObj:getTraits()
        for i = playerTraits:size() - 1, 0, -1 do
            local trait = playerTraits:get(i)
            playerObj:getTraits():remove(trait)
        end
        if addtraits and addtraits ~= "" then
            local traitsToAdd = {}
            for trait in addtraits:gmatch("%S+") do
                table.insert(traitsToAdd, trait)
            end
            for _, traitName in ipairs(traitsToAdd) do
                playerObj:getTraits():add(traitName)
            end
        end

        -- GET WEIGHT
        playerObj:getNutrition():setWeight(addweight)
        playerObj:getNutrition():setCalories(addcalories)
        playerObj:getNutrition():setCalories(addcarbohydrates)
        playerObj:getNutrition():setCalories(addlipids)
        playerObj:getNutrition():setCalories(addproteins)
        
        --REMOVE SKILLS
        local playerXP = playerObj:getXp()

        for i=0, PerkFactory.PerkList:size() -1 do
            local perk = PerkFactory.PerkList:get(i)
            playerObj:level0(perk)
            playerObj:getXp():setXPToLevel(perk, 0)
        end

        -- GET SKILLS
        local recoveryPercentage = 0.25
        local playerXP = playerObj:getXp()
        for perkName, xp in pairs(addXP) do
            local perk = PerkFactory.getPerkFromName(perkName)
            local xpToRecover = xp * recoveryPercentage
            playerXP:AddXP(perk, xpToRecover - playerXP:getXP(perk), false, false, true)
        end

        -- ADD BOOST
        local playerXP = playerObj:getXp()
        local perks = PerkFactory.PerkList

        for i = 0, perks:size() - 1 do
            local perk = perks:get(i)
            playerXP:setPerkBoost(perk, 0)
        end

        -- Apply stored boosts
        for perkName, boost in pairs(addboost) do
            local perk = PerkFactory.getPerkFromName(perkName)
            playerXP:setPerkBoost(perk, boost)
        end

        -- GET RECIPES
        local playerrecipe = playerObj:getKnownRecipes()
        for recipeID, _ in pairs(addrecipes) do
            playerrecipe:add(recipeID)
        end

        -- GET VHS
        for title, lineGuids in pairs(addvhs) do
            for _, lineGuid in ipairs(lineGuids) do
                if not playerObj:isKnownMediaLine(lineGuid) then
                    playerObj:addKnownMediaLine(lineGuid)
                end
            end
        end
       
        playerObj:getInventory():Remove("IngotGold")
        playerObj:getInventory():Remove("IngotGold")
        playerObj:getInventory():Remove(Soul)

    end
end

function onGainSoul1(playerObj, Soul)
    --- GET MODDATA
    local moddata = Soul:getModData()
    oldusername = moddata.PurgaSkills.username
    profname = moddata.PurgaSkills.profession
    addtraits = moddata.PurgaSkills.traits
    addweight = moddata.PurgaSkills.weight
    addcalories = moddata.PurgaSkills.calories
    addcarbohydrates = moddata.PurgaSkills.carbohydrates
    addlipids = moddata.PurgaSkills.lipids
    addproteins = moddata.PurgaSkills.proteins
    addXP = moddata.PurgaSkills.skills
    addboost = moddata.PurgaSkills.skillsB
    addrecipes = moddata.PurgaSkills.knownRecipes
    addvhs = moddata.PurgaSkills.recordedMedia

    -- GET CURRENT USERNAME
    local currentusername = playerObj:getUsername()

    -- CHECK IF USERNAME MATCH
    local usernameMatch = currentusername == oldusername

    -- Print the results
    if usernameMatch then
        print("match: true")
    else
        print("match: false")
    end
    
    -- If the total check is true, proceed with adding skills, weight, recipes, etc.
    if usernameMatch then
        -- GET PROFESSION TO CHECK
        playerObj:getDescriptor():setProfession(profname)

        -- GET TRAITS TO CHECK
        local playerTraits = playerObj:getTraits()
        for i = playerTraits:size() - 1, 0, -1 do
            local trait = playerTraits:get(i)
            playerObj:getTraits():remove(trait)
        end
        if addtraits and addtraits ~= "" then
            local traitsToAdd = {}
            for trait in addtraits:gmatch("%S+") do
                table.insert(traitsToAdd, trait)
            end
            for _, traitName in ipairs(traitsToAdd) do
                playerObj:getTraits():add(traitName)
            end
        end

        -- GET WEIGHT
        playerObj:getNutrition():setWeight(addweight)
        playerObj:getNutrition():setCalories(addcalories)
        playerObj:getNutrition():setCalories(addcarbohydrates)
        playerObj:getNutrition():setCalories(addlipids)
        playerObj:getNutrition():setCalories(addproteins)
        
        --REMOVE SKILLS
        local playerXP = playerObj:getXp()

        for i=0, PerkFactory.PerkList:size() -1 do
            local perk = PerkFactory.PerkList:get(i)
            playerObj:level0(perk)
            playerObj:getXp():setXPToLevel(perk, 0)
        end

        -- GET SKILLS
        local recoveryPercentage = 0.50
        local playerXP = playerObj:getXp()
        for perkName, xp in pairs(addXP) do
            local perk = PerkFactory.getPerkFromName(perkName)
            local xpToRecover = xp * recoveryPercentage
            playerXP:AddXP(perk, xpToRecover - playerXP:getXP(perk), false, false, true)
        end

        -- ADD BOOST
        local playerXP = playerObj:getXp()
        local perks = PerkFactory.PerkList

        for i = 0, perks:size() - 1 do
            local perk = perks:get(i)
            playerXP:setPerkBoost(perk, 0)
        end

        -- Apply stored boosts
        for perkName, boost in pairs(addboost) do
            local perk = PerkFactory.getPerkFromName(perkName)
            playerXP:setPerkBoost(perk, boost)
        end

        -- GET RECIPES
        local playerrecipe = playerObj:getKnownRecipes()
        for recipeID, _ in pairs(addrecipes) do
            playerrecipe:add(recipeID)
        end

        -- GET VHS
        for title, lineGuids in pairs(addvhs) do
            for _, lineGuid in ipairs(lineGuids) do
                if not playerObj:isKnownMediaLine(lineGuid) then
                    playerObj:addKnownMediaLine(lineGuid)
                end
            end
        end
       
        playerObj:getInventory():Remove("IngotGold")
        playerObj:getInventory():Remove("IngotGold")
        playerObj:getInventory():Remove("IngotGold")
        playerObj:getInventory():Remove("IngotGold")
        playerObj:getInventory():Remove(Soul)

    end
end

function onGainSoul2(playerObj, Soul)
    --- GET MODDATA
    local moddata = Soul:getModData()
    oldusername = moddata.PurgaSkills.username
    profname = moddata.PurgaSkills.profession
    addtraits = moddata.PurgaSkills.traits
    addweight = moddata.PurgaSkills.weight
    addcalories = moddata.PurgaSkills.calories
    addcarbohydrates = moddata.PurgaSkills.carbohydrates
    addlipids = moddata.PurgaSkills.lipids
    addproteins = moddata.PurgaSkills.proteins
    addXP = moddata.PurgaSkills.skills
    addboost = moddata.PurgaSkills.skillsB
    addrecipes = moddata.PurgaSkills.knownRecipes
    addvhs = moddata.PurgaSkills.recordedMedia

    -- GET CURRENT USERNAME
    local currentusername = playerObj:getUsername()

    -- CHECK IF USERNAME MATCH
    local usernameMatch = currentusername == oldusername

    -- Print the results
    if usernameMatch then
        print("match: true")
    else
        print("match: false")
    end
    
    -- If the total check is true, proceed with adding skills, weight, recipes, etc.
    if usernameMatch then
        -- GET PROFESSION TO CHECK
        playerObj:getDescriptor():setProfession(profname)

        -- GET TRAITS TO CHECK
        local playerTraits = playerObj:getTraits()
        for i = playerTraits:size() - 1, 0, -1 do
            local trait = playerTraits:get(i)
            playerObj:getTraits():remove(trait)
        end
        if addtraits and addtraits ~= "" then
            local traitsToAdd = {}
            for trait in addtraits:gmatch("%S+") do
                table.insert(traitsToAdd, trait)
            end
            for _, traitName in ipairs(traitsToAdd) do
                playerObj:getTraits():add(traitName)
            end
        end

        -- GET WEIGHT
        playerObj:getNutrition():setWeight(addweight)
        playerObj:getNutrition():setCalories(addcalories)
        playerObj:getNutrition():setCalories(addcarbohydrates)
        playerObj:getNutrition():setCalories(addlipids)
        playerObj:getNutrition():setCalories(addproteins)
        
        --REMOVE SKILLS
        local playerXP = playerObj:getXp()

        for i=0, PerkFactory.PerkList:size() -1 do
            local perk = PerkFactory.PerkList:get(i)
            playerObj:level0(perk)
            playerObj:getXp():setXPToLevel(perk, 0)
        end

        -- GET SKILLS
        local recoveryPercentage = 0.75
        local playerXP = playerObj:getXp()
        for perkName, xp in pairs(addXP) do
            local perk = PerkFactory.getPerkFromName(perkName)
            local xpToRecover = xp * recoveryPercentage
            playerXP:AddXP(perk, xpToRecover - playerXP:getXP(perk), false, false, true)
        end

        -- ADD BOOST
        local playerXP = playerObj:getXp()
        local perks = PerkFactory.PerkList

        for i = 0, perks:size() - 1 do
            local perk = perks:get(i)
            playerXP:setPerkBoost(perk, 0)
        end

        -- Apply stored boosts
        for perkName, boost in pairs(addboost) do
            local perk = PerkFactory.getPerkFromName(perkName)
            playerXP:setPerkBoost(perk, boost)
        end

        -- GET RECIPES
        local playerrecipe = playerObj:getKnownRecipes()
        for recipeID, _ in pairs(addrecipes) do
            playerrecipe:add(recipeID)
        end

        -- GET VHS
        for title, lineGuids in pairs(addvhs) do
            for _, lineGuid in ipairs(lineGuids) do
                if not playerObj:isKnownMediaLine(lineGuid) then
                    playerObj:addKnownMediaLine(lineGuid)
                end
            end
        end
       
        playerObj:getInventory():Remove("IngotGold")
        playerObj:getInventory():Remove("IngotGold")
        playerObj:getInventory():Remove("IngotGold")
        playerObj:getInventory():Remove("IngotGold")
        playerObj:getInventory():Remove("IngotGold")
        playerObj:getInventory():Remove("IngotGold")
        playerObj:getInventory():Remove(Soul)

    end
end

function onGainSoul3(playerObj, Soul)
    --- GET MODDATA
    local moddata = Soul:getModData()
    oldusername = moddata.PurgaSkills.username
    profname = moddata.PurgaSkills.profession
    addtraits = moddata.PurgaSkills.traits
    addweight = moddata.PurgaSkills.weight
    addcalories = moddata.PurgaSkills.calories
    addcarbohydrates = moddata.PurgaSkills.carbohydrates
    addlipids = moddata.PurgaSkills.lipids
    addproteins = moddata.PurgaSkills.proteins
    addXP = moddata.PurgaSkills.skills
    addboost = moddata.PurgaSkills.skillsB
    addrecipes = moddata.PurgaSkills.knownRecipes
    addvhs = moddata.PurgaSkills.recordedMedia

    -- GET CURRENT USERNAME
    local currentusername = playerObj:getUsername()

    -- CHECK IF USERNAME MATCH
    local usernameMatch = currentusername == oldusername

    -- Print the results
    if usernameMatch then
        print("match: true")
    else
        print("match: false")
    end
    
    -- If the total check is true, proceed with adding skills, weight, recipes, etc.
    if usernameMatch then
        -- GET PROFESSION TO CHECK
        playerObj:getDescriptor():setProfession(profname)

        -- GET TRAITS TO CHECK
        local playerTraits = playerObj:getTraits()
        for i = playerTraits:size() - 1, 0, -1 do
            local trait = playerTraits:get(i)
            playerObj:getTraits():remove(trait)
        end
        if addtraits and addtraits ~= "" then
            local traitsToAdd = {}
            for trait in addtraits:gmatch("%S+") do
                table.insert(traitsToAdd, trait)
            end
            for _, traitName in ipairs(traitsToAdd) do
                playerObj:getTraits():add(traitName)
            end
        end

        -- GET WEIGHT
        playerObj:getNutrition():setWeight(addweight)
        playerObj:getNutrition():setCalories(addcalories)
        playerObj:getNutrition():setCalories(addcarbohydrates)
        playerObj:getNutrition():setCalories(addlipids)
        playerObj:getNutrition():setCalories(addproteins)
        
        --REMOVE SKILLS
        local playerXP = playerObj:getXp()

        for i=0, PerkFactory.PerkList:size() -1 do
            local perk = PerkFactory.PerkList:get(i)
            playerObj:level0(perk)
            playerObj:getXp():setXPToLevel(perk, 0)
        end

        -- GET SKILLS
        local playerXP = playerObj:getXp()
        for perkName, xp in pairs(addXP) do
            local perk = PerkFactory.getPerkFromName(perkName)
            playerXP:AddXP(perk, xp - playerXP:getXP(perk), false, false, true)
        end

        -- ADD BOOST
        local playerXP = playerObj:getXp()
        local perks = PerkFactory.PerkList

        for i = 0, perks:size() - 1 do
            local perk = perks:get(i)
            playerXP:setPerkBoost(perk, 0)
        end

        -- Apply stored boosts
        for perkName, boost in pairs(addboost) do
            local perk = PerkFactory.getPerkFromName(perkName)
            playerXP:setPerkBoost(perk, boost)
        end

        -- GET RECIPES
        local playerrecipe = playerObj:getKnownRecipes()
        for recipeID, _ in pairs(addrecipes) do
            playerrecipe:add(recipeID)
        end

        -- GET VHS
        for title, lineGuids in pairs(addvhs) do
            for _, lineGuid in ipairs(lineGuids) do
                if not playerObj:isKnownMediaLine(lineGuid) then
                    playerObj:addKnownMediaLine(lineGuid)
                end
            end
        end
       
        playerObj:getInventory():Remove("IngotGold")
        playerObj:getInventory():Remove("IngotGold")
        playerObj:getInventory():Remove("IngotGold")
        playerObj:getInventory():Remove("IngotGold")
        playerObj:getInventory():Remove("IngotGold")
        playerObj:getInventory():Remove("IngotGold")
        playerObj:getInventory():Remove("IngotGold")
        playerObj:getInventory():Remove("IngotGold")
        playerObj:getInventory():Remove(Soul)

    end
end