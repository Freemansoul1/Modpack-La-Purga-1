-- leveling_data.lua
-- Linear progression function
function generateLinearLevellingData(baseKills, numLevels, increment)
    local levellingData = {}

    for i = 1, numLevels do
        local levelId = "level_" .. i
        -- Calculate the number of kills using linear progression
        local killsRequired = baseKills + (i - 1) * increment

        -- Populate the level data
        levellingData[levelId] = {
            level = i,
            kills = killsRequired
        }
    end

    return levellingData
end

-- Exponential progression function
function generateExponentialLevellingData(baseKills, numLevels, growthFactor)
    local levellingData = {}

    for i = 1, numLevels do
        local levelId = "level_" .. i
        -- Calculate the number of kills using exponential growth
        local killsRequired = baseKills * (growthFactor ^ (i - 1))

        -- Populate the level data
        levellingData[levelId] = {
            level = i,
            kills = killsRequired
        }
    end

    return levellingData
end

-- Quadratic progression function
function generateQuadraticLevellingData(baseKills, numLevels, coefficient)
    local levellingData = {}

    for i = 1, numLevels do
        local levelId = "level_" .. i
        -- Calculate the number of kills using quadratic growth
        local killsRequired = baseKills + coefficient * ((i - 1) ^ 2)

        -- Populate the level data
        levellingData[levelId] = {
            level = i,
            kills = killsRequired
        }
    end

    return levellingData
end

-- Logarithmic progression function
function generateLogarithmicLevellingData(baseKills, numLevels, base)
    local levellingData = {}

    for i = 1, numLevels do
        local levelId = "level_" .. i
        -- Calculate the number of kills using logarithmic growth
        -- Use math.log with a change of base formula
        local killsRequired = baseKills + math.log(i, base)

        -- Round to the nearest integer as kill counts should be whole numbers
        killsRequired = math.floor(killsRequired + 0.5)

        -- Populate the level data
        levellingData[levelId] = {
            level = i,
            kills = killsRequired
        }
    end

    return levellingData
end