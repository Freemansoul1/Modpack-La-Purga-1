require "LevellingData"
require "PzArpgUtils"

local ISLevelDisplay = require("ISUI/ISLevelDisplay")
local displayer

local LEVELLING_DATA = nil
local PROFESSION_BUFF_DATA = nil
local BUFF_DATA = nil

local function loadBuffData()
    return {  
    health_loss_reduction = {
        display = 'Health Loss',
        min = SandboxVars.PZARPG.HealthLossMin,
        max = SandboxVars.PZARPG.HealthLossMax,
    },
    endurance_loss_reduction = {
        display = 'Endurance Loss',
        min = SandboxVars.PZARPG.EndoLossMin,
        max = SandboxVars.PZARPG.EndoLossMax,
    },
    movement_speed = {
        display = 'Movement Speed',
        min = SandboxVars.PZARPG.MoveMin,
        max = SandboxVars.PZARPG.MoveMax
    },
    swing_speed = {
        display = 'Swing Speed',
        min = SandboxVars.PZARPG.SwingMin,
        max = SandboxVars.PZARPG.SwingMax
    },
    attack_dmg = {
        display = 'Attack Damage',
        min = SandboxVars.PZARPG.DamageMin,
        max = SandboxVars.PZARPG.DamageMax
    },
    attack_range = {
        display = 'Attack Range',
        min = SandboxVars.PZARPG.RangeMin,
        max = SandboxVars.PZARPG.RangeMax
    },
    crit_chance = {
        display = 'Critical Chance',
        min = SandboxVars.PZARPG.CritMin,
        max = SandboxVars.PZARPG.CritMax
    },
    accuracy = {
        display = 'Accuracy',
        min = SandboxVars.PZARPG.AccuracyMin,
        max = SandboxVars.PZARPG.AccuracyMax
    }
    }
end

local function parseProfessionBuffData()
    local professionBuffData = {}
    local inputString = SandboxVars.PZARPG.ProfessionBuffs

    -- Iterate over each profession=buffs pair, using '|' as a delimiter
    for profession, buffs in string.gmatch(inputString, "([^=|]+)=([^|]+)") do
        local buffList = {}
        -- Iterate over each buff in the buffs list, using '+' as a delimiter
        for buff in string.gmatch(buffs, "([^+]+)") do
            table.insert(buffList, buff)
        end
        professionBuffData[profession] = buffList
    end

    return professionBuffData
end


local function loadLevellingData()
    if SandboxVars.PZARPG.LevelScaling == 1 then
        return generateLinearLevellingData(SandboxVars.PZARPG.BaseKills, SandboxVars.PZARPG.NumLevels,
            SandboxVars.PZARPG.ScalingFactor)
    elseif SandboxVars.PZARPG.LevelScaling == 2 then
        return generateExponentialLevellingData(SandboxVars.PZARPG.BaseKills, SandboxVars.PZARPG.NumLevels,
            SandboxVars.PZARPG.ScalingFactor)
    elseif SandboxVars.PZARPG.LevelScaling == 3 then
        return generateQuadraticLevellingData(SandboxVars.PZARPG.BaseKills, SandboxVars.PZARPG.NumLevels,
            SandboxVars.PZARPG.ScalingFactor)
    elseif SandboxVars.PZARPG.LevelScaling == 4 then
        return generateLogarithmicLevellingData(SandboxVars.PZARPG.BaseKills, SandboxVars.PZARPG.NumLevels,
            SandboxVars.PZARPG.ScalingFactor)
    end
end

local function updateLevelUi(playerData, killsNeeded)
    if displayer == nil then
        displayer = ISLevelDisplay.onOpen(playerData, killsNeeded)
        return
    end
    displayer:updateData(playerData, killsNeeded)
end

-- Function to add random buffs to a player
local function addRandomBuffs(playerData, profession, count, preferenceMultiplier)
    if not playerData.pzarpg.buffs then
        playerData.pzarpg.buffs = {}
    end

    local buffs = playerData.pzarpg.buffs

    -- Create a weighted list of buff keys
    local weightedBuffKeys = {}
    for key in pairs(BUFF_DATA) do
        -- Default weight is 1
        local weight = 1
        -- If the profession has preferred buffs, increase their weight
        if PROFESSION_BUFF_DATA[profession] then
            for _, preferredBuff in ipairs(PROFESSION_BUFF_DATA[profession]) do
                if key == preferredBuff then
                    weight = weight + preferenceMultiplier
                end
            end
        end
        -- Add the key multiple times based on its weight
        for _ = 1, weight do
            table.insert(weightedBuffKeys, key)
        end
    end

    for _ = 1, count do
        -- Select a random buff key from the weighted list
        local randomKey = ZombRand(#weightedBuffKeys) + 1;
        local randomBuffKey = weightedBuffKeys[randomKey]
        local buffInfo = BUFF_DATA[randomBuffKey]

        -- Randomize the buff value between min and max
        local randomValue = ZombRandFloat(buffInfo.min, buffInfo.max)
        local buffDisplayName = buffInfo.display
        -- Add the random value to the existing buff value or set it if it doesn't exist
        if buffs[randomBuffKey] and buffs[randomBuffKey].value and buffs[randomBuffKey].display then
            buffs[randomBuffKey].value = buffs[randomBuffKey].value + randomValue
        else
            buffs[randomBuffKey] = {}
            buffs[randomBuffKey].display = buffDisplayName
            buffs[randomBuffKey].value = randomValue
        end
    end
end

function displayMd()
    local playerData = getPlayer():getModData()
    printTable(playerData.pzarpg)
end

function displayBd()
    printTable(BUFF_DATA)
end
function displayLd()
    printTable(LEVELLING_DATA)
end
function displayPbd()
    printTable(PROFESSION_BUFF_DATA)
end

local function OnPlayerUpdate(player)
    if not LEVELLING_DATA then
        LEVELLING_DATA = loadLevellingData()
    end

    if not PROFESSION_BUFF_DATA then
        PROFESSION_BUFF_DATA = parseProfessionBuffData()
    end

    if not BUFF_DATA then
        BUFF_DATA = loadBuffData()
    end

    local playerData = player:getModData()
    local zombieKills = player:getZombieKills()

    -- Initialise pzarpg mod data
    if not playerData.pzarpg then
        playerData.pzarpg = {}
        playerData.pzarpg.initialKills = zombieKills
        playerData.pzarpg.level = 1
        playerData.pzarpg.nextLevel = 2
        playerData.pzarpg.levelId = 'level_1'
        playerData.pzarpg.nextLevelId = 'level_2'
        playerData.pzarpg.buffs = {}
    end

    local killsRemaining = -1

    if playerData.pzarpg then
        -- Check if player can level up
        local currentLevelId = playerData.pzarpg.levelId
        local nextLevelId = playerData.pzarpg.nextLevelId

        -- Ensure the next level exists in levellingData
        if LEVELLING_DATA[nextLevelId] then
            local killsNeeded = LEVELLING_DATA[nextLevelId].kills
            local killsRemaining = killsNeeded - (zombieKills - playerData.pzarpg.initialKills)

            -- Check if the player has enough kills to level up
            local killsNeededPlayer = (zombieKills - playerData.pzarpg.initialKills)
            if (zombieKills - playerData.pzarpg.initialKills) >= killsNeeded then
                -- Update player level and level IDs
                playerData.pzarpg.level = LEVELLING_DATA[nextLevelId].level
                playerData.pzarpg.levelId = nextLevelId

                -- Determine the next level ID
                local nextLevelNumber = playerData.pzarpg.level + 1
                playerData.pzarpg.nextLevelId = 'level_' .. tostring(nextLevelNumber)

                -- Reset initialKills to the current zombieKills
                playerData.pzarpg.initialKills = zombieKills

                player:setHaloNote("You have levelled up to level " .. playerData.pzarpg.level);

                -- Add buff on level up
                local professionbias = SandboxVars.PZARPG.ProfessionBiasMultiplier
                local numberOfBuffsToGain = SandboxVars.PZARPG.BuffsToGainOnLevelUp
                addRandomBuffs(playerData, player:getDescriptor():getProfession(), numberOfBuffsToGain, professionbias)

                -- Update any equipped weapons
                PzArpg_UpdateEquippedWeapon(player)
            end

            updateLevelUi(playerData, killsRemaining)
            return
        end

        updateLevelUi(playerData, killsRemaining)
    end
end

Events.OnPlayerUpdate.Add(OnPlayerUpdate)
