

if isServer() then return end

local function getWeaponCategory(handWeapon)
    local weaponCategory = handWeapon:getScriptItem():getCategories()
    local categories = { "Axe", "LongBlade", "SmallBlade", "Blunt", "SmallBlunt", "Spear", "Improvised", }
    for _, category in ipairs(categories) do
        if weaponCategory:contains(category) then
            return category
        end
    end
    return nil
end

-- Gun stock attack compatibility
local function isFirearm(item)
    if item == nil then return "None" end
    if item:IsWeapon() and item:isRanged() then
        if not item:isTwoHandWeapon() then
            return "1hgun"
        else 
            return "2hgun"
        end
    end

    return "None"
end


local function calculateFirearmDropProbability(player, handWeapon)

    local baseProbability = getBaseProbability(player, handWeapon)
	
	local handWound, forearmWound = hasHandOrForearmWound(player)
	
	local weaponType = isFirearm(handWeapon)
	
	if weaponType == "1hgun" then
        baseProbability = 0.05
    elseif weaponType == "2hgun" then
        baseProbability = 0.02
    end

    local modifiers = {
        strength = ((10 - player:getPerkLevel(Perks.Strength)) / 10) * 0.2,
        dexterity = ((10 - player:getPerkLevel(Perks.Fitness)) / 10) * 0.05,
		agility = ((10 - player:getPerkLevel(Perks.Nimble)) / 10) * 0.1,
        weaponCondition = ((100 - handWeapon:getCondition()) / 100) * 0.02,
        weight = handWeapon:getWeight() * 0.008,
    }

    modifiers.panic = player:getMoodles():getMoodleLevel(MoodleType.Panic) * 0.04
    modifiers.drunk = player:getMoodles():getMoodleLevel(MoodleType.Drunk) * 0.03
    modifiers.stressed = player:getMoodles():getMoodleLevel(MoodleType.Stress) * 0.01
    modifiers.endurance = player:getMoodles():getMoodleLevel(MoodleType.Endurance) * 0.01
    modifiers.tired = player:getMoodles():getMoodleLevel(MoodleType.Tired) * 0.02
    modifiers.sick = player:getMoodles():getMoodleLevel(MoodleType.Sick) * 0.01
    modifiers.thirst = player:getMoodles():getMoodleLevel(MoodleType.Thirst) * 0.008
	modifiers.pain = player:getMoodles():getMoodleLevel(MoodleType.Pain) * 0.01
	modifiers.heavyload = player:getMoodles():getMoodleLevel(MoodleType.HeavyLoad) * 0.008
    modifiers.twoHanded = isTwoHandedWeaponInUse(player, handWeapon) and -0.05 or 0
    modifiers.stomp = player:getVariableBoolean("StompAnim") and -0.2 or 0
    modifiers.shove = player:getVariableBoolean("ShoveAnim") and -0.15 or 0

    if handWound then
        modifiers.wounds = 0.05
    end
    if forearmWound then
        modifiers.wounds = 0.04
    end

    if player:HasTrait("Dextrous") then modifiers.traits = -0.05 end
    if player:HasTrait("Lucky") then modifiers.traits = -0.05 end
    if player:HasTrait("AllThumbs") then modifiers.traits = 0.03 end
    if player:HasTrait("Clumsy") then modifiers.traits = 0.04 end
    if player:HasTrait("Unlucky") then modifiers.traits = 0.03 end
    if player:HasTrait("Handy") then modifiers.traits = -0.03 end
    if player:HasTrait("Stout") then modifiers.traits = -0.03 end
    if player:HasTrait("Strong") then modifiers.traits = -0.05 end
    if player:HasTrait("Burglar") then modifiers.traits = -0.02 end
    if player:HasTrait("Weak") then modifiers.traits = 0.04 end
	if player:HasTrait("Emaciated") then modifiers.traits = 0.02 end
    if player:HasTrait("Feeble") then modifiers.traits = 0.02 end

    local rainIntensity = getClimateManager():getRainIntensity()
    if player:isOutside() and rainIntensity > 0 then
        modifiers.rain = rainIntensity * 0.03
    end

    local temperature = getClimateManager():getTemperature()
    if temperature < 0 or temperature > 35 then
        modifiers.temperature = 0.03
    end

    local finalProbability = baseProbability
    for _, mod in pairs(modifiers) do
        finalProbability = finalProbability + mod
    end

    finalProbability = math.max(0.01, math.min(finalProbability, 1))

    if isDebugEnabled() then
        print("Drop Probability: " .. tostring(finalProbability))
        getPlayer():Say("Drop Probability: " .. tostring(finalProbability))
    end

    return finalProbability
end

local function isTwoHandedWeaponInUse(player, handWeapon)
    return handWeapon:isTwoHandWeapon() and player:getSecondaryHandItem()
end

local skills = {
        Axe = Perks.Axe,
        LongBlade = Perks.LongBlade,
        SmallBlade = Perks.SmallBlade,
        Blunt = Perks.Blunt,
        SmallBlunt = Perks.SmallBlunt,
        Spear = Perks.Spear,
        Improvised = nil,
    }

local function getBaseProbability(player, handWeapon)
    local category = getWeaponCategory(handWeapon)
    local baseProbability = 0
    local skillLevel = 0

    local probabilities = {
        Axe = -0.25,
        LongBlade = -0.2,
        SmallBlade = -0.2,
        Blunt = -0.2,
        SmallBlunt = -0.2,
        Spear = -0.25,
        Improvised = -0.1,
    }  

   if probabilities[category] then
        baseProbability = probabilities[category]
        skillLevel = player:getPerkLevel(skills[category])
    end

    baseProbability = baseProbability - (skillLevel * 0.02)
    return baseProbability
end

local function hasHandOrForearmWound(player)
    local bodyDamage = player:getBodyDamage()
    local handWound = false
    local forearmWound = false

    if bodyDamage:getBodyPart(BodyPartType.Hand_L):HasInjury() or bodyDamage:getBodyPart(BodyPartType.Hand_R):HasInjury() then
        handWound = true
    end
    if bodyDamage:getBodyPart(BodyPartType.ForeArm_L):HasInjury() or bodyDamage:getBodyPart(BodyPartType.ForeArm_R):HasInjury() then
        forearmWound = true
    end

    return handWound, forearmWound
end

local function calculateDropProbability(player, handWeapon)
    local baseProbability = getBaseProbability(player, handWeapon)
	
	local handWound, forearmWound = hasHandOrForearmWound(player)
	
	local weaponType = isFirearm(handWeapon)
	
	if weaponType == "1hgun" then
        baseProbability = 0.05
    elseif weaponType == "2hgun" then
        baseProbability = 0.02
    end

    local modifiers = {
        strength = ((10 - player:getPerkLevel(Perks.Strength)) / 10) * 0.2,
        dexterity = ((10 - player:getPerkLevel(Perks.Fitness)) / 10) * 0.05,
		agility = ((10 - player:getPerkLevel(Perks.Nimble)) / 10) * 0.1,
        weaponCondition = ((100 - handWeapon:getCondition()) / 100) * 0.02,
        weight = handWeapon:getWeight() * 0.008,
    }

    modifiers.panic = player:getMoodles():getMoodleLevel(MoodleType.Panic) * 0.03
    modifiers.drunk = player:getMoodles():getMoodleLevel(MoodleType.Drunk) * 0.02
    modifiers.stressed = player:getMoodles():getMoodleLevel(MoodleType.Stress) * 0.01
    modifiers.endurance = player:getMoodles():getMoodleLevel(MoodleType.Endurance) * 0.01
    modifiers.tired = player:getMoodles():getMoodleLevel(MoodleType.Tired) * 0.02
    modifiers.sick = player:getMoodles():getMoodleLevel(MoodleType.Sick) * 0.01
    modifiers.thirst = player:getMoodles():getMoodleLevel(MoodleType.Thirst) * 0.01
	modifiers.pain = player:getMoodles():getMoodleLevel(MoodleType.Pain) * 0.01
	modifiers.heavyload = player:getMoodles():getMoodleLevel(MoodleType.HeavyLoad) * 0.01
    modifiers.twoHanded = isTwoHandedWeaponInUse(player, handWeapon) and -0.05 or 0
    modifiers.stomp = player:getVariableBoolean("StompAnim") and -0.2 or 0
    modifiers.shove = player:getVariableBoolean("ShoveAnim") and -0.2 or 0

    if handWound then
        modifiers.wounds = 0.05
    end
    if forearmWound then
        modifiers.wounds = 0.04
    end

    if player:HasTrait("Dextrous") then modifiers.traits = -0.05 end
    if player:HasTrait("Lucky") then modifiers.traits = -0.05 end
    if player:HasTrait("AllThumbs") then modifiers.traits = 0.03 end
    if player:HasTrait("Clumsy") then modifiers.traits = 0.04 end
    if player:HasTrait("Unlucky") then modifiers.traits = 0.03 end
    if player:HasTrait("Handy") then modifiers.traits = -0.03 end
    if player:HasTrait("Stout") then modifiers.traits = -0.03 end
    if player:HasTrait("Strong") then modifiers.traits = -0.05 end
    if player:HasTrait("Burglar") then modifiers.traits = -0.02 end
    if player:HasTrait("Weak") then modifiers.traits = 0.04 end
	if player:HasTrait("Emaciated") then modifiers.traits = 0.02 end
    if player:HasTrait("Feeble") then modifiers.traits = 0.02 end

    local rainIntensity = getClimateManager():getRainIntensity()
    if player:isOutside() and rainIntensity > 0 then
        modifiers.rain = rainIntensity * 0.03
    end

    local temperature = getClimateManager():getTemperature()
    if temperature < 0 or temperature > 35 then
        modifiers.temperature = 0.03
    end

    local finalProbability = baseProbability
    for _, mod in pairs(modifiers) do
        finalProbability = finalProbability + mod
    end

    finalProbability = math.max(0.01, math.min(finalProbability, 1))

    if isDebugEnabled() then
        print("Drop Probability: " .. tostring(finalProbability))
        getPlayer():Say("Drop Probability: " .. tostring(finalProbability))
    end

    return finalProbability
end

local function calculateStuckProbability(player, handWeapon)
    local category = getWeaponCategory(handWeapon)
    local baseStuckProbability = 0
    local skillLevel = 0

    local stuckProbabilities = {
        Spear = 0.20,
        Axe = 0.1,
        SmallBlade = 0.25,
        LongBlade = 0.20,  
    }

    if stuckProbabilities[category] then
        baseStuckProbability = stuckProbabilities[category]
        skillLevel = player:getPerkLevel(skills[category])
    end
	
    local maxSkillLevel = 10
    local skillFactor = (maxSkillLevel - skillLevel) / maxSkillLevel
    baseStuckProbability = baseStuckProbability * skillFactor

    local panicLevel = player:getMoodles():getMoodleLevel(MoodleType.Panic)
    local panicModifier = panicLevel * 0.03
	
	local tiredLevel = player:getMoodles():getMoodleLevel(MoodleType.Tired)
    local tiredModifier = tiredLevel * 0.02
	
	local enduranceLevel = player:getMoodles():getMoodleLevel(MoodleType.Endurance)
    local enduranceModifier = enduranceLevel * 0.01
	
    local weaponCondition = handWeapon:getCondition()
    if weaponCondition < 25 then
        baseStuckProbability = baseStuckProbability + 0.04
    end

    local strength = player:getPerkLevel(Perks.Strength)
    local dexterity = player:getPerkLevel(Perks.Fitness)
    local agility = player:getPerkLevel(Perks.Nimble)

    local strengthModifier = (strength / 10) * -0.2
    local dexterityModifier = (dexterity / 10) * -0.08
    local agilityModifier = (agility / 10) * -0.08

    local traitModifier = 0

    -- Trait Modifiers
    if player:HasTrait("Dextrous") then traitModifier = traitModifier - 0.05 end
    if player:HasTrait("Lucky") then traitModifier = traitModifier - 0.05 end
    if player:HasTrait("AllThumbs") then traitModifier = traitModifier + 0.04 end
    if player:HasTrait("Clumsy") then traitModifier = traitModifier + 0.04 end
    if player:HasTrait("Unlucky") then traitModifier = traitModifier + 0.03 end
    if player:HasTrait("Handy") then traitModifier = traitModifier - 0.03 end
    if player:HasTrait("Stout") then traitModifier = traitModifier - 0.03 end
    if player:HasTrait("Strong") then traitModifier = traitModifier - 0.04 end
    if player:HasTrait("Burglar") then traitModifier = traitModifier - 0.02 end
    if player:HasTrait("Weak") then traitModifier = traitModifier + 0.04 end
    if player:HasTrait("Emaciated") then traitModifier = traitModifier + 0.02 end
    if player:HasTrait("Feeble") then traitModifier = traitModifier + 0.02 end

    local temperature = getClimateManager():getTemperature()
    local temperatureModifier = 0
    if temperature < 0 then
        temperatureModifier = 0.05
    elseif temperature > 32 then
        temperatureModifier = -0.04
    end

    local twoHandedModifier = isTwoHandedWeaponInUse(player, handWeapon) and -0.05 or 0

    local finalStuckProbability = baseStuckProbability 
        + strengthModifier 
        + dexterityModifier 
        + agilityModifier 
        + twoHandedModifier 
        + traitModifier 
        + temperatureModifier 
        + panicModifier
		+ enduranceModifier
		+ tiredModifier

    finalStuckProbability = math.max(0.01, math.min(finalStuckProbability, 1))

    if isDebugEnabled() then
        print("Stuck Probability: " .. tostring(finalStuckProbability))
        getPlayer():Say("Stuck Probability: " .. tostring(finalStuckProbability))
    end

    return finalStuckProbability
end

local function showAttachedLocations(zombie)
    local lg = zombie:getAttachedLocationGroup()
    for i=0, lg:size()-1 do
        local location = lg:getLocationByIndex(i)
        DebugLog.log(DebugType.Mod, "  Location[" .. tostring(i) .. "] id: '" .. location:getId() .. "' Name: '" .. location:getAttachmentName() .. "'")
    end
end

local bodyLocations = {
    'Knife Left Leg',
    'Knife Right Leg',
    'Knife Stomach',
    'Knife Shoulder',
    'Knife in Back'
}



local function stickIntoZombieBody(zombie, bodyLocation, handWeapon)
    zombie:setAttachedItem(bodyLocation, handWeapon)
    zombie:resetModelNextFrame()
    zombie:getInventory():AddItem(handWeapon)
    if not zombie:getModData().SZ_IMC then
        zombie:getModData().SZ_IMC = {}
    end
    zombie:getModData().SZ_IMC[bodyLocation] = 1
end

local function chooseBodyLocation(zombie)
    if not zombie:getModData().SZ_IMC then
        zombie:getModData().SZ_IMC = {}
    end
    local n = ZombRand(1, #bodyLocations)
    local startN = n
    while zombie:getModData().SZ_IMC[bodyLocations[n]] do
        n = n + 1
        if n > #bodyLocations then
            n = 1
        end
        if n == startN then
            break
        end
    end
    return bodyLocations[n]
end

local function stickIntoZombie(zombie, handWeapon)

    local bodyLocation = chooseBodyLocation(zombie)
    if isClient() then
        local args = {
            playerId = getPlayer():getOnlineID(),
            zombieId = zombie:getOnlineID(),
            xZ = zombie:getX(),
            yZ = zombie:getY(),
            zZ = zombie:getZ(),
            bodyLocation = bodyLocation, 
            handWeaponType = handWeapon:getType(),
            condition = handWeapon:getCondition()
        }
        sendClientCommand(getPlayer(), "SZ_IMC_Client", "stickIntoZombie", args)
    end
    stickIntoZombieBody(zombie, bodyLocation, handWeapon)
end

local function handleWeaponDrop(player, handWeapon)
    if handWeapon and player and instanceof(handWeapon, "HandWeapon") then
        if handWeapon:isAimedFirearm() then return end      
        if ZombRandFloat(0, 2) < calculateDropProbability(player, handWeapon) then
            
            if ZombRandFloat(0, 1) < 0.5 then
                if isDebugEnabled() then
                    getPlayer():Say("I almost dropped my weapon!")
                end
            else
                player:dropHandItems()
                if isDebugEnabled() then
                    getPlayer():Say("I dropped my weapon!")
                end
                
                if ZombRandFloat(0, 2) < 0.1 then
                    local bodyDamage = player:getBodyDamage()
                    local handPart = bodyDamage:getBodyPart(BodyPartType.Hand_R)
                    handPart:AddDamage(5 + ZombRand(5))                
                end
            end
        end

        local moodles = player:getMoodles()
        local tiredLevel = moodles:getMoodleLevel(MoodleType.Tired)
        if tiredLevel >= 2 then
            if ZombRandFloat(0, 2) < 0.1 then
                local bodyDamage = player:getBodyDamage()
                local handPart = bodyDamage:getBodyPart(BodyPartType.Hand_R)
                handPart:AddDamage(5 + ZombRand(5))
                handPart:setAdditionalPain(handPart:getAdditionalPain() + ZombRand(20))
            end
        end
    end
end

local function handleGunDrop(player, handWeapon)
    if handWeapon then
		if not handWeapon:isAimedFirearm() then return end
        local weaponType = isFirearm(handWeapon)
		
		if player:isDoShove() and player:isAiming() and player:getVariableBoolean("bShoveAiming") then
        if weaponType == "1hgun" or weaponType == "2hgun" then
            if ZombRandFloat(0, 1) < calculateFirearmDropProbability(player, handWeapon) then
                player:dropHandItems()
                if isDebugEnabled() then
                    player:Say("I dropped my firearm!")
                end
            end
        else
            if ZombRandFloat(0, 1) < calculateDropProbability(player, handWeapon) then
                player:dropHandItems()
                if isDebugEnabled() then
                    player:Say("I dropped my weapon!")
                end
                if ZombRandFloat(0, 1) < 0.1 then
                    local bodyDamage = player:getBodyDamage()
                    local handPart = bodyDamage:getBodyPart(BodyPartType.Hand_R)
                    handPart:AddDamage(5 + ZombRand(5))
                end
            end

            local moodles = player:getMoodles()
            local tiredLevel = moodles:getMoodleLevel(MoodleType.Tired)
            if tiredLevel >= 2 then
                if ZombRandFloat(0, 1) < 0.1 then
                    local bodyDamage = player:getBodyDamage()
                    local handPart = bodyDamage:getBodyPart(BodyPartType.Hand_R)
                    handPart:AddDamage(5 + ZombRand(5))
                    handPart:setAdditionalPain(handPart:getAdditionalPain() + ZombRand(20))
                end
            end
        end
    end
	end
end

local function handleWeaponStuck(player, handWeapon, zombie)
    if handWeapon and (handWeapon:getCategories():contains("LongBlade") or handWeapon:getCategories():contains("SmallBlade") or handWeapon:getCategories():contains("Spear")) then
        if ZombRandFloat(0, 2) < calculateStuckProbability(player, handWeapon) then
			if isDebugEnabled() then
				getPlayer():Say("Weapon stuck!")
			end
			
            if handWeapon:getCategories():contains("Axe") and not zombie:getModData().stuck_Head01 then
                zombie:setAttachedItem("Stuck Head01", handWeapon)
                zombie:getModData().stuck_Head01 = 1
            elseif not zombie:getModData().stuck_Body01 then
    			stickIntoZombie(zombie, handWeapon)
            end
            player:removeFromHands(handWeapon)
        end
    end
end

local function getZombie(xZ, yZ, zZ, id)
    local dx = 1
    local dy = 1
    for x = xZ - dx, xZ + dx do
        for y = yZ - dy, yZ + dy do
            local gridSquare = getCell():getGridSquare(x, y, zZ)
            if gridSquare then
                local movingObjects = gridSquare:getMovingObjects()
                DebugLog.log(DebugType.Mod, "stickIntoZombieServer: getZombie(): square found.  n = " .. tostring(movingObjects:size()))
                for i=0, movingObjects:size()-1 do
                    local movingObject = movingObjects:get(i)
                    if instanceof(movingObject, "IsoZombie") and movingObject:getOnlineID() == id then
                        return movingObject
                    end
                end
            end
        end
    end
    return nil
end

local function stickIntoZombieFromServer(args)
    local playerId = getPlayer():getOnlineID()
    DebugLog.log(DebugType.Mod, "stickIntoZombieFromServer() playerid: " .. tostring(playerId) .. " type: " .. type(playerId) .. " args.playerId: " .. tostring(args.playerId) .. " type: " .. type(args.playerId))

   if args.playerId == playerId then return end

    local zombie = getZombie(args.xZ, args.yZ, args.zZ, args.zombieId)
    if zombie then
        DebugLog.log(DebugType.Mod, "stickIntoZombieFromServer() zombie found")
        local weapon = InventoryItemFactory.CreateItem(args.handWeaponType)
        if weapon then
            DebugLog.log(DebugType.Mod, "stickIntoZombieFromServer() weapon made")
            weapon:setCondition(args.condition)
            stickIntoZombieBody(zombie, args.bodyLocation, weapon)
        end
    end
end

local function OnServerCommand(moduleName, command, args)
    if moduleName ~= "SZ_IMC_Server" then return end

    if command == "stickIntoZombieFromServer" then
        stickIntoZombieFromServer(args)
        return
    end
end


local function DumpZombie(zombie)
    DebugLog.log(DebugType.Mod, "DumpZombie() id:" .. tostring(zombie:getOnlineID()))
    if not zombie:getModData().SZ_IM then
        DebugLog.log(DebugType.Mod, "  zombie has no mod data")
        zombie:getModData().SZ_IM = "SZ_IM zombie modData"
    else
        DebugLog.log(DebugType.Mod, "  zombie has mod data: " .. zombie:getModData().SZ_IM)
    end
end

local function OnHitZombie(zombie, player, bodyPartType, handWeapon)
    if not zombie or not player or not handWeapon then
        print("OnHitZombie: Missing arguments.")
        return
    end
    if zombie:isDead() or (zombie:isKnockedDown() and not zombie:isCrawling()) then
        return
    end
    local stuck = handleWeaponStuck(player, handWeapon, zombie)
    if not stuck then
        handleWeaponDrop(player, handWeapon)
    end
	handleGunDrop(player, handWeapon)
end

Events.OnHitZombie.Add(OnHitZombie)
Events.OnServerCommand.Add(OnServerCommand)