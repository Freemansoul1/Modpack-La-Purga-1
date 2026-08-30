require "Scripting/ItemFetcher"
require "Scripting/Reward"
require "Scripting/AchievementManager"

local function canned_food(item)
    local scriptItem = item:getScriptItem();
    if scriptItem then
        if item:getStringItemType() == "CannedFood" and scriptItem:isCantEat() then
            return true;
        end
    end
    return false;
end

local function camo_cloth(item)
    local item_type = item:getType();
    if item_type == 'Jacket_ArmyCamoGreen' or item_type == 'Jacket_ArmyCamoDesert' then
        return true;
    end
    return false;
end

local rare_pistols = {
    "PPK",
    "DEagle_Long",
    "Colt_Navy_1851",
    "G34"
}

local function rare_pistol(item)
    if weapon_condition(item) then
        local item_type = item:getType();
        for i=1, #rare_pistols do
            if rare_pistols[i] == item_type then
                return true;
            end
        end
    end
    return false;
end

local rare_shotguns = {
    "M1897",
    "UTS15",
    "SPAS_15",
    "M1208",
    "M1212",
    "M1216",
    "CAWS"
}

local function rare_shotgun(item)
    if weapon_condition(item) then
        local item_type = item:getType();
        for i=1, #rare_shotguns do
            if rare_shotguns[i] == item_type then
                return true;
            end
        end
    end
    return false;
end

local rare_rifles = {
    "XM8Compact_Pistol",
    "G11K3",
    "AKM_Custom",
    "AK74_Custom",
    "TAC50",
    "OSV_96",
    "SV_98"
}

local function rare_rifle(item)
    if weapon_condition(item) then
        local item_type = item:getType();
        for i=1, #rare_rifles do
            if rare_rifles[i] == item_type then
                return true;
            end
        end
    end
    return false;
end

local function any_fish(item)
    if item:isFood() then
        if item:getFoodType() == "Fish" then
            return true;
        end
    end
    return false;
end

local function big_fish(item)
    if any_fish(item) then
        local name = item:getName();
        local temp = name:lastIndexOf(' ');
        if temp ~= -1 then
            temp = string.sub(name, temp+2, -3):trim();
            local status, size = pcall(tonumber, temp);
            if status and size then
                if size >= 50 then
                    return true;
                end
            end
        end
    end
    return false;
end

local function skill_book(item)
    local item_type = item:getType();
    if item_type ~= "Book" and item_type:starts_with("Book") then
        return true;
    end
    return false;
end

local function artifact(item)
    if item:getScriptItem():getDisplayCategory() == "Artifact" then
        return true;
    end
    return false;
end

local function any_ammo(item)
    if item:getScriptItem():getDisplayCategory() == "Ammo" then
        return true;
    end
    return false;
end

ItemFetcher.add_ruleset("CannedFood", canned_food);
ItemFetcher.add_ruleset("Camo", camo_cloth);
ItemFetcher.add_ruleset("RarePistol", rare_pistol);
ItemFetcher.add_ruleset("RareShotgun", rare_shotgun);
ItemFetcher.add_ruleset("RareRifle", rare_rifle);
ItemFetcher.add_ruleset("AnyFish", any_fish);
ItemFetcher.add_ruleset("BigFish", big_fish);
ItemFetcher.add_ruleset("SkillBook", skill_book);
ItemFetcher.add_ruleset("Artifact", artifact);
ItemFetcher.add_ruleset("Ammo", any_ammo);

Events.OnQSystemPreInit.Add(function ()
    Reward.Pool.insert("CainAR", { "NHM.BlueprintAK", 1, Grade.Rare }, 25)
    Reward.Pool.insert("CainAR", { "NHM.BlueprintAR", 1, Grade.Rare }, 25)
    Reward.Pool.insert("CainAR", { "NHM.BlueprintMK", 1, Grade.Rare }, 25)
    Reward.Pool.insert("CainAR", { "NHM.BlueprintDSA", 1, Grade.Rare }, 25)
end)

Events.OnQSystemPreInit.Add(function ()
    Reward.Pool.insert("CainCarab", { "NHM.BlueprintSVD", 1, Grade.Rare }, 50)
    Reward.Pool.insert("CainCarab", { "NHM.BlueprintM1A", 1, Grade.Rare }, 50)
end)

Events.OnQSystemPreInit.Add(function ()
    Reward.Pool.insert("CainRifle", { "NHM.BlueprintMOS", 1, Grade.Rare }, 50)
    Reward.Pool.insert("CainRifle", { "NHM.Blueprint700M", 1, Grade.Rare }, 50)
end)

if AchievementManager then
    AchievementManager.add("cleanermeet", "cleaner_intro", nil, "cleanerintro", "cleanerintro", false)
    AchievementManager.add("Demiurgemeet", "Demiurge_intro", nil, "Demiurgeintro", "Demiurgeintro", false)
    AchievementManager.add("nursemeet", "nurse_intro", nil, "nurseintro", "nurseintro", false)
    AchievementManager.add("assistantmeet", "assistant_intro", nil, "assistantintro", "assistantintro", false)
    AchievementManager.add("cookmeet", "cook_intro", nil, "cookintro", "cookintro", false)
    AchievementManager.add("headmeet", "head_intro", nil, "headintro", "headintro", false)
    AchievementManager.add("pharmacistmeet", "pharmacist_intro", nil, "pharmacistintro", "pharmacistintro", false)
    AchievementManager.add("sentrymeet", "sentry_intro", nil, "sentryintro", "sentryintro", false)
    AchievementManager.add("sentryquit", "tutorial_all", nil, "tutorialall", "tutorialall", false)
    AchievementManager.add("abelmeet", "abel_intro", nil, "abelintro", "abelintro", false)
    AchievementManager.add("cainmeet", "cain_intro", nil, "cainintro", "cainintro", false)
    AchievementManager.add("aspirinmeet", "Aspirin_intro", nil, "aspirinintro", "aspirinintro", false)
    AchievementManager.add("houndmeet", "hound_intro", nil, "houndintro", "houndintro", false)
    AchievementManager.add("kioshimeet", "kioshi_intro", nil, "kioshiintro", "kioshiintro", false)
    AchievementManager.add("nerdmeet", "nerd_intro", nil, "nerdintro", "nerdintro", false)
    AchievementManager.add("silkmeet", "silk_intro", nil, "silkintro", "silkintro", false)
    AchievementManager.add("sparklemeet", "sparkle_intro", nil, "sparkleintro", "sparkleintro", false)
    AchievementManager.add("marshallmeet", "marshall_intro", nil, "marshallintro", "marshallintro", false)
    AchievementManager.add("cartermeet", "carter_intro", nil, "carterintro", "carterintro", false)
    AchievementManager.add("darkmeet", "dark_intro", nil, "darkintro", "darkintro", false)
    AchievementManager.add("tradermeet", "trader_intro", nil, "traderintro", "traderintro", false)
end
