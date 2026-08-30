--- @class PurgaSkills
PurgaSkills = {}

--- @param playerObj IsoPlayer
function PurgaSkills:getNewSoul(playerObj)
    --- @type table
    local moddata = {}
    moddata.PurgaSkills = {}

    local playerusername = playerObj:getUsername()
    local playerprofession = playerObj:getDescriptor():getProfession()

    -- SAVE NUTRITION
    local playerweight = playerObj:getNutrition():getWeight()
    local playercalories = playerObj:getNutrition():getCalories()
    local playercarbohydrates = playerObj:getNutrition():getCarbohydrates()
    local playerlipids = playerObj:getNutrition():getLipids()
    local playerproteins = playerObj:getNutrition():getProteins()

    local playertraits = ""
    do
      local i = 0
      while i < playerObj:getTraits():size() do
        playertraits = playertraits .. playerObj:getTraits():get(i) .. " " -- Agregar un espacio después de cada rasgo
        i = i + 1
      end
    end

    -- SAVE SKILLS
    EXP = {}
    EXPBOOST = {}

    local perks      = PerkFactory.PerkList
    local xp = playerObj:getXp()

    for i=0, perks:size() - 1 do
        local perk      = perks:get(i)
        local perkName  = perk:getName()

        local perkXP = xp:getXP(perk:getType())

        if perkXP > 0 then
          EXP[perkName] = perkXP
        end

        local perkBoost = xp:getPerkBoost(perk)

        if perkBoost > 0 then
          EXPBOOST[perkName] = perkBoost
        end
    end

    -- SAVE RECIPES
    local gainedRecipes = {}

    ---@type ArrayList
    local knownRecipes = playerObj:getKnownRecipes()
  
    for i=0, knownRecipes:size()-1 do
      local recipeID = knownRecipes:get(i)
      gainedRecipes[recipeID] = true
    end

    -- SAVE VHS
    local knownVHS = {}
    local RecMedia = getZomboidRadio():getRecordedMedia()
    local categories = RecMedia:getCategories()
    for i=1,categories:size() do
        local category = categories:get(i-1)
        local mediaType = RecordedMedia.getMediaTypeForCategory(category)
        local list = RecMedia:getAllMediaForType(mediaType)
        for j=1,list:size() do
            ---@type MediaData
            local mediaData = list:get(j-1)
            for jj=1, mediaData:getLineCount() do
                ---@type MediaData.MediaLineData
                local mediaLineData = mediaData:getLine(jj-1)
                if mediaLineData then
                    local lineGuid
                    for i = 0, getNumClassFields(mediaLineData) - 1 do
                        ---@type Field
                        local field = getClassField(mediaLineData, i)
                        if string.find(tostring(field), "%.text") then
                            lineGuid = getClassFieldVal(mediaLineData, field)
                        end
                    end
                    local title = mediaData:getTranslatedTitle()
                    if lineGuid and playerObj.isKnownMediaLine and playerObj:isKnownMediaLine(lineGuid) then
                        knownVHS[title] = knownVHS[title] or {}
                        table.insert(knownVHS[title], lineGuid)
                    end
                end
            end
        end
    end

    -- GET TIME OF DEATH
    local gameDateTime = {
        year = getGameTime():getYear(),
        month = getGameTime():getMonth() + 1,
        day = getGameTime():getDay() + 1,
        hour = getGameTime():getHour(),
        minute = getGameTime():getMinutes()        
    }

    -- SAVE IN MODDATA
    moddata.PurgaSkills.username = playerusername
    moddata.PurgaSkills.profession = playerprofession
    moddata.PurgaSkills.weight = playerweight
    moddata.PurgaSkills.calories = playercalories
    moddata.PurgaSkills.carbohydrates = playercarbohydrates
    moddata.PurgaSkills.lipids = playerlipids
    moddata.PurgaSkills.proteins = playerproteins
    moddata.PurgaSkills.traits = playertraits
    moddata.PurgaSkills.skills = EXP
    moddata.PurgaSkills.skillsB = EXPBOOST
    moddata.PurgaSkills.knownRecipes = gainedRecipes
    moddata.PurgaSkills.recordedMedia = knownVHS
    moddata.PurgaSkills.gametime = gameDateTime

    -- CREATE ITEM
    local Soul = InventoryItemFactory.CreateItem("Base.Soul")
    Soul:copyModData(moddata)
    Soul:setLockedBy(playerObj:getUsername())
    Soul:setCustomName(true)
    Soul:setCanBeWrite(false)

    -- PRINT
    print(playerObj:getUsername() .. " is DEAD")
    print("HABILIDADES GUARDADAS:")
    for key, value in pairs(moddata.PurgaSkills) do
        if type(value) == "table" then
            print(key .. ":")
            for subKey, subValue in pairs(value) do
                print("\t" .. subKey .. ": " .. tostring(subValue))
            end
        else
            print(key .. ": " .. tostring(value))
        end
    end

    return Soul
end