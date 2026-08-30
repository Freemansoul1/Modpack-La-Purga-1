----------------------------
---------Meditation---------
----------------------------
------author: Burryaga------
----------------------------
---YouTube tutor: OgreLeg---
----------------------------

----------------------------
--Note: My local variables--
--and functions are tagged--
-----with B as a suffix-----
-------(for Burryaga)-------
----------------------------

-- Meditation is Restive

require "TimedActions/ISBaseTimedAction"

-- Utilities

Yogi = Yogi or {}

-- So it begins...
Yogi.translation = {
    meditate = getText("UI_Yogi_meditate"),

    meditateContextOption = getText("UI_Yogi_MO_meditateContextOption"),
    meditateSilently = getText("UI_Yogi_MO_meditateSilently"),
    meditateWhenSitting = getText("UI_Yogi_MO_meditateWhenSitting"),
    haloNoteFeedback = getText("UI_Yogi_MO_haloNoteFeedback"),
    meditateBeforeSit = getText("UI_Yogi_MO_meditateBeforeSit"),
    disableAnimation = getText("UI_Yogi_MO_disableAnimation"),
    serverOverride = getText("UI_Yogi_MO_serverOverride"),
    applyBalancedLabeling = getText("UI_Yogi_MO_applyBalancedLabeling"), 
    
    meditateContextOptionTooltip = getText("UI_Yogi_MO_meditateContextOption_tooltip"),
    meditateSilentlyTooltip = getText("UI_Yogi_MO_meditateSilently_tooltip"),
    meditateWhenSittingTooltip = getText("UI_Yogi_MO_meditateWhenSitting_tooltip"),
    haloNoteFeedbackTooltip = getText("UI_Yogi_MO_haloNoteFeedback_tooltip"),
    meditateBeforeSitTooltip = getText("UI_Yogi_MO_meditateBeforeSit_tooltip"),
    disableAnimationTooltip = getText("UI_Yogi_MO_disableAnimation_tooltip"),
    serverOverrideTooltip = getText("UI_Yogi_MO_serverOverride_tooltip"),
    applyBalancedLabelingTooltip = getText("UI_Yogi_MO_applyBalancedLabeling_tooltip"),
    
    gainSerenity = getText("UI_Yogi_haloNote_gainSerenity"),
    loseSerenity = getText("UI_Yogi_haloNote_loseSerenity"),
    loseFocus = getText("UI_Yogi_haloNote_loseFocus"),
    canRestHere = getText("UI_Yogi_haloNote_canRestHere"),
    comfySpot = getText("UI_Yogi_haloNote_comfySpot"),
    badTime = getText("UI_Yogi_haloNote_badTime"),
    needTimeToRelax = getText("UI_Yogi_haloNote_needTimeToRelax"),
    needTimeBeforeRest = getText("UI_Yogi_haloNote_needTimeBeforeRest"),
    unityAchieved = getText("UI_Yogi_haloNote_unityAchieved"),
    discoverMeditation = getText("UI_Yogi_haloNote_discoverMeditation"),
    readyToSurvive = getText("UI_Yogi_haloNote_readyToSurvive")
}

Yogi.mod = {

    options = {
        meditateContextOption = true,
        meditateSilently = false,
        meditateWhenSitting = false,
        haloNoteFeedback = true,
        meditateBeforeSit = true,
        disableAnimation = false,
        serverOverride = false,
        applyBalancedLabeling = true
    },
    
    names = {
        meditateContextOption = Yogi.translation.meditateContextOption,
        meditateSilently = Yogi.translation.meditateSilently,
        meditateWhenSitting = Yogi.translation.meditateWhenSitting,
        haloNoteFeedback = Yogi.translation.haloNoteFeedback,
        meditateBeforeSit = Yogi.translation.meditateBeforeSit,
        disableAnimation = Yogi.translation.disableAnimation,
        serverOverride = Yogi.translation.serverOverride,
        applyBalancedLabeling = Yogi.translation.applyBalancedLabeling
    },

    mod_id = "Meditation",

    mod_shortname = "Meditation"

}

Yogi.loadModOptions = function()

    if ModOptions and ModOptions.getInstance then

        Yogi.modSettings = ModOptions:getInstance(Yogi.mod)

        local meditateContextOption = Yogi.modSettings:getData("meditateContextOption")
        local meditateSilently = Yogi.modSettings:getData("meditateSilently")
        local meditateWhenSitting = Yogi.modSettings:getData("meditateWhenSitting")
        local haloNoteFeedback = Yogi.modSettings:getData("haloNoteFeedback")
        local meditateBeforeSit = Yogi.modSettings:getData("meditateBeforeSit")
        local disableAnimation = Yogi.modSettings:getData("disableAnimation")
        local serverOverride = Yogi.modSettings:getData("serverOverride")
        local applyBalancedLabeling = Yogi.modSettings:getData("applyBalancedLabeling")
        
        meditateContextOption.tooltip = Yogi.translation.meditateContextOptionTooltip
        meditateSilently.tooltip = Yogi.translation.meditateSilentlyTooltip
        meditateWhenSitting.tooltip = Yogi.translation.meditateWhenSittingTooltip
        haloNoteFeedback.tooltip = Yogi.translation.haloNoteFeedbackTooltip
        meditateBeforeSit.tooltip = Yogi.translation.meditateBeforeSitTooltip
        disableAnimation.tooltip = Yogi.translation.disableAnimationTooltip
        serverOverride.tooltip = Yogi.translation.serverOverrideTooltip
        applyBalancedLabeling.tooltip = Yogi.translation.applyBalancedLabelingTooltip

        function meditateWhenSitting:onUpdate(value)
            if value then
                meditateContextOption:set(false)
            end
        end
        
        function meditateContextOption:onUpdate(value)
            if value then
                meditateWhenSitting:set(false)
            end
        end

    end
end

Yogi.loadModOptions()

Yogi.anyoneCanMeditate = function()

    return SandboxVars.Meditation and (SandboxVars.Meditation.everyoneDoesYoga or 
        (SandboxVars.Meditation.trainForTheTrait and not SandboxVars.Meditation.mustReadBeforePractice))

end

-- Returns true if player hasn't been attacked for at least a minute and the player has
-- the Yogi trait or the server doesn't require it (unless player is already invisible).
Yogi.canClearMind = function(player)
    return player:getTimeSinceZombieAttack() > 7200 and player:getTicksSinceSeenZombie() > 3600 and 
           (player:HasTrait("Yogi") or Yogi.anyoneCanMeditate()) and not player:isTargetedByZombie() -- or player:isInvisible()?
end

Yogi.isRelaxing = function(player)

    return (player:isSitOnGround() and not player:isAiming())

end

Yogi.isPracticingEnough = function(player)

    if not SandboxVars.Meditation.serenityTakesPractice then return true end

    local frequency = math.max(1, Yogi.daysMeditated) / math.max(1, Yogi.daysSurvived)

    if frequency > .9 then return true end

end

-- Key Functions

-- Halo Note Duration (Ticks)
Yogi.halo = 420

Yogi.notify = function(player, state)
    if state == "Being Blessed" then
        player:setHaloNote(Yogi.translation.gainSerenity, Yogi.halo)
    elseif state == "Being Forsaken" then
        player:setHaloNote(Yogi.translation.loseSerenity, Yogi.halo)
    elseif state == "Becoming Restless" then
        player:setHaloNote(Yogi.translation.loseFocus, Yogi.halo)
    elseif state == "Recovering Energy" then
        player:setHaloNote(Yogi.translation.canRestHere, Yogi.halo)
    elseif state == "Just Vibin'" then
        player:setHaloNote(Yogi.translation.comfySpot, Yogi.halo)
    elseif state == "Cannot Focus" then
        player:setHaloNote(Yogi.translation.badTime, Yogi.halo)
    elseif state == "Keep Trying" then
        player:setHaloNote(Yogi.translation.needTimeToRelax, Yogi.halo)
    elseif state == "Keep Trying While Resting" then
        player:setHaloNote(Yogi.translation.needTimeBeforeRest, Yogi.halo)
    elseif state == "Gaining Abilities" then
        player:setHaloNote(Yogi.translation.unityAchieved, Yogi.halo)
    elseif state == "Discovering Meditation" then
        player:setHaloNote(Yogi.translation.discoverMeditation, Yogi.halo)
    elseif state == "Ending Recovery" then
        player:setHaloNote(Yogi.translation.readyToSurvive, Yogi.halo)
    end
end

Yogi.blessed = Yogi.blessed or {}

Yogi.bless = function(player)

    Yogi.blessed[player:getPlayerNum()] = true

    if Yogi.mod.options.haloNoteFeedback then
        Yogi.notify(player, "Being Blessed")
    end

    player:setInvisible(true)

    Events.OnTick.Add(Yogi.maintainConcentration)
    Events.OnKeyStartPressed.Add(Yogi.interruptConcentration)
    Events.OnPlayerMove.Add(Yogi.forsake)

end

Yogi.forsake = function(player)

    if not Yogi.blessed[player:getPlayerNum()] then return end

    Yogi.blessed[player:getPlayerNum()] = nil

    -- meditativeResting refers to Meditative Recovery.
    -- I won't bother renaming the variable because it would force
    -- people to reenable the option, and most end users will never
    -- care what the code looks like. But man I want to change it. :D
    if not SandboxVars.Meditation.meditativeResting or SandboxVars.Meditation.healingRequiresFocus then
        Yogi.focused[playerIndex] = nil
        player:clearVariable("Meditative")
        Yogi.reportAnimation(player:getDisplayName(), false)
    end

    if Yogi.mod.options.haloNoteFeedback then
        if SandboxVars.Meditation.oneWithTheForce then
            Yogi.notify(player, "Being Forsaken")
        else
            Yogi.notify(player, "Becoming Restless")
        end
    end
    
    if SandboxVars.Meditation.oneWithTheForce then
        player:setInvisible(false)
    end

    Events.OnTick.Remove(Yogi.maintainConcentration)
    Events.OnKeyStartPressed.Remove(Yogi.interruptConcentration)
    Events.OnPlayerMove.Remove(Yogi.forsake)

end

-- Sit Function Override Triggers Blessing

-- Tracks players who are simply animating meditation, but nothing else.
Yogi.lotus = {}

Yogi.ticksSpentWaiting = {}

Yogi.awaitBlessing = function(ticks)

    local nobodyWaiting = true

    for playerIndex = 0, getNumActivePlayers() - 1 do repeat

        local player = getSpecificPlayer(playerIndex)

        if not player then break end

        if not Yogi.ticksSpentWaiting[playerIndex] then break end

        nobodyWaiting = false
        
        if Yogi.ticksSpentWaiting[playerIndex] < 1200 then 
        
            Yogi.ticksSpentWaiting[playerIndex] = Yogi.ticksSpentWaiting[playerIndex] + 1

            break
        
        end

        if Yogi.isRelaxing(player) and Yogi.canClearMind(player) then 

            if not Yogi.meditatedToday then
                Yogi.meditatedToday = true
                player:getModData().Yogi.meditatedToday = true
                player:transmitModData()
            end
                
            if SandboxVars.Meditation.oneWithTheForce and Yogi.isPracticingEnough(player) then
                Yogi.bless(player)
            elseif Yogi.mod.options.haloNoteFeedback and SandboxVars.Meditation.meditativeResting then 
                Yogi.notify(player, "Recovering Energy")
            elseif Yogi.mod.options.haloNoteFeedback then
                Yogi.notify(player, "Just Vibin'")
                if not SandboxVars.Meditation.meditativeResting then
                    Yogi.lotus[playerIndex] = true
                end
            end

            if not Yogi.resting[playerIndex] then Yogi.heal(playerIndex) end

            Yogi.relaxing[playerIndex] = nil

            table.remove(Yogi.ticksSpentWaiting, playerIndex)
            
        elseif not Yogi.isRelaxing(player) then

            if Yogi.mod.options.haloNoteFeedback then
                Yogi.notify(player, "Cannot Focus")
            end

            Yogi.relaxing[playerIndex] = nil

            table.remove(Yogi.ticksSpentWaiting, playerIndex)

        else --if not Yogi.canClearMind(player) then

            if Yogi.mod.options.haloNoteFeedback then
                if SandboxVars.Meditation.meditativeResting then
                    Yogi.notify(player, "Keep Trying While Resting")
                else
                    Yogi.notify(player, "Keep Trying")
                end
            end

            Yogi.heal(playerIndex)

            local timeNeeded = math.max(7200 - player:getTimeSinceZombieAttack(), 3600 - player:getTicksSinceSeenZombie())

            timeNeeded = math.max(timeNeeded, 1200)

            Yogi.ticksSpentWaiting[playerIndex] = 1200 - timeNeeded

        end

    until true end

    if nobodyWaiting then

        Events.OnTick.Remove(Yogi.awaitBlessing)

    end

end

Yogi.ignorePain = function()

    local nobodyResting = true

    for playerIndex = 0, getNumActivePlayers() - 1 do repeat

        if not Yogi.resting[playerIndex] then break end

        local player = getSpecificPlayer(playerIndex)

        if not player then break end

        nobodyResting = false

        player:getStats():setPain(0)

    until true end

    if nobodyResting then
        Events.OnTick.Remove(Yogi.ignorePain)
    end

end

Yogi.preparingForMeditation = {}

Yogi.removeHandItems = function(player, context)

    local unequippingSomething = false

    local primaryItem = player:getPrimaryHandItem()
    local secondaryItem = player:getSecondaryHandItem()

    if primaryItem then

        ISTimedActionQueue.add(ISUnequipAction:new(player, primaryItem, 50))
        unequippingSomething = true
        Yogi.preparingForMeditation[player:getPlayerNum()] = context

        if (primaryItem:isTwoHandWeapon() or primaryItem:isRequiresEquippedBothHands()) and primaryItem == player:getSecondaryHandItem() then
            return unequippingSomething
        end
        
    end

    if secondaryItem then

        ISTimedActionQueue.add(ISUnequipAction:new(player, secondaryItem, 50))
        unequippingSomething = true
        Yogi.preparingForMeditation[player:getPlayerNum()] = context

    end

    return unequippingSomething

end

Yogi.isMeditationAnimated = function()

    return (not Yogi.mod.options.disableAnimation) and
           (not SandboxVars.Meditation.animationOffByDefault or Yogi.mod.options.serverOverride)

end

Yogi.knowsAboutMeditation = function(player)

    return SandboxVars.Meditation.trainForTheTrait and (not SandboxVars.Meditation.mustReadBeforePractice or 
        (player:getModData().Yogi and player:getModData().Yogi.discoveredMeditation))

end

Yogi.heal = function(playerIndex)
    
    if SandboxVars.Meditation.meditativeResting then

        if SandboxVars.Meditation.healingRequiresFocus and not SandboxVars.Meditation.oneWithTheForce then
            Events.OnTick.Add(Yogi.maintainConcentration)
            Events.OnKeyStartPressed.Add(Yogi.interruptConcentration)
            Events.OnPlayerMove.Add(Yogi.forsake)
        end

        if not Yogi.recovery then 
            Yogi.recovery = SandboxVars.Meditation.recoveryFrequency
        end

        Yogi.resting[playerIndex] = true

        if SandboxVars.Meditation.painlessRecovery then
            Events.OnTick.Remove(Yogi.ignorePain)
            Events.OnTick.Add(Yogi.ignorePain)
        end

        Events.OnTick.Remove(Yogi.rest)
        Events.OnTick.Add(Yogi.rest)
    end

end

Yogi.meditative = function(player)

    return (Yogi.mod.options.meditateWhenSitting or Yogi.mod.options.meditateContextOption) and 
           (Yogi.anyoneCanMeditate() or player:HasTrait("Yogi")) 

end

Yogi.trying = Yogi.trying or {}

Yogi.grow = function()

    local nobodyTrying = true

    for playerIndex = 0, getNumActivePlayers() - 1 do repeat

        local player = getSpecificPlayer(playerIndex)

        if not (player and player:isAlive() and Yogi.trying[playerIndex]) then break end

        if player:isSitOnGround() and player:getModData().Yogi then
            if not player:getModData().Yogi.minutesMeditated then
                player:getModData().Yogi.minutesMeditated = 1
                player:transmitModData()
                nobodyTrying = false
            elseif player:getModData().Yogi.minutesMeditated < 1000000 then --> Current Max Required is 1 Million
                player:getModData().Yogi.minutesMeditated = player:getModData().Yogi.minutesMeditated + 1
                player:transmitModData()
                nobodyTrying = false
            end
            -- May seem redundant but is not. Moving above code would cause this to loop unnecessarily
            -- for people who have learned everything they can about meditation. Doubling it up looks
            -- odd but is more efficient long-term.
            if not player:HasTrait("Yogi") then
                if SandboxVars.Meditation.trainingRequiredForTrait < player:getModData().Yogi.minutesMeditated then
                    player:getTraits():add("Yogi")
                    if Yogi.mod.options.haloNoteFeedback then
                        Yogi.notify(player, "Gaining Abilities")
                    end
                    Events.OnTick.Remove(Yogi.awaitBlessing)
                    Events.OnTick.Add(Yogi.awaitBlessing)
                end
            end
        else
            Yogi.trying[playerIndex] = nil
        end

    until true end

    if nobodyTrying then
        Events.EveryOneMinute.Remove(Yogi.grow)
    end

end

Yogi.relaxing = Yogi.relaxing or {}

Yogi.focused = Yogi.focused or {}

Yogi.meditate = function(playerIndex, player)
    
    if Yogi.meditative(player) or Yogi.knowsAboutMeditation(player) then

        Yogi.relaxing[playerIndex] = true

        Yogi.focused[playerIndex] = true

        Yogi.ticksSpentWaiting[playerIndex] = 0
    
        if Yogi.isMeditationAnimated() then
            player:setVariable("Meditative", true)
            Yogi.reportAnimation(player:getDisplayName(), true)
        else
            player:clearVariable("Meditative")
            Yogi.reportAnimation(player:getDisplayName(), false)
        end
    
        if player:HasTrait("Yogi") or SandboxVars.Meditation.everyoneDoesYoga then
            Events.OnTick.Remove(Yogi.awaitBlessing)
            Events.OnTick.Add(Yogi.awaitBlessing)
        end

        Yogi.trying[playerIndex] = true

        Events.EveryOneMinute.Remove(Yogi.grow)
        Events.EveryOneMinute.Add(Yogi.grow)

        Events.OnTick.Remove(Yogi.finish)
        Events.OnTick.Add(Yogi.finish)

    else
       
        player:clearVariable("Meditative")
        Yogi.reportAnimation(player:getDisplayName(), false)
        
    end

end

Yogi.finish = function()

    local nobodyMeditating = true

    for playerIndex = 0, getNumActivePlayers() - 1 do repeat

        local player = getSpecificPlayer(playerIndex)
        
        if not player then break end
        
        if player:isSitOnGround() then 
            nobodyMeditating = false
        else
            Yogi.relaxing[playerIndex] = nil
            player:clearVariable("Meditative")
            Yogi.reportAnimation(player:getDisplayName(), false)
        end

    until true end

    if nobodyMeditating then
        Events.OnTick.Remove(Yogi.finish)
        Events.OnTick.Remove(Yogi.awaitBlessing)
    end

end

Yogi.isContextMenuOptionPreferred = function()

    if Yogi.mod.options.meditateContextOption and not Yogi.mod.options.meditateWhenSitting then
        return true
    else
        return false
    end 
    
end

Yogi.oldContextMenuSitOnGround = ISWorldObjectContextMenu.onSitOnGround

ISWorldObjectContextMenu.onSitOnGround = function(playerIndex)

    local player = getSpecificPlayer(playerIndex)

    if (Yogi.meditative(player) or Yogi.knowsAboutMeditation(player)) and 
       Yogi.isMeditationAnimated() and not Yogi.isContextMenuOptionPreferred() then
        if Yogi.removeHandItems(player, "Sit") then return end
    end

    Yogi.oldContextMenuSitOnGround(playerIndex)

    if not Yogi.isContextMenuOptionPreferred() then
        Yogi.meditate(playerIndex, getSpecificPlayer(playerIndex))
    end

end

Yogi.oldJoypadRadialSitToggle = ISJoystickButtonRadialMenu.onToggleSit

ISJoystickButtonRadialMenu.onToggleSit = function(player)

    if player:isCurrentState(PlayerSitOnGroundState.instance()) then 

        Yogi.oldJoypadRadialSitToggle(player) 

        return 

    end

    if (Yogi.meditative(player) or Yogi.knowsAboutMeditation(player)) and 
       Yogi.isMeditationAnimated() and not Yogi.isContextMenuOptionPreferred() then
        if Yogi.removeHandItems(player, "Radial") then return end
    end

    Yogi.oldJoypadRadialSitToggle(player)

    if not Yogi.isContextMenuOptionPreferred() then
        Yogi.meditate(player:getPlayerNum(), player)
    end

end

-- Aiming and Keyboard Presses Cancel Blessing

Yogi.maintainConcentration = function(...)

    for playerIndex = 0, getNumActivePlayers() - 1 do
        
        local player = getSpecificPlayer(playerIndex)
        
        if player and not Yogi.isRelaxing(player) then 

            Yogi.forsake(player)

        end

    end

end

Yogi.interruptConcentration = function(...)
    
    for playerIndex = 0, getNumActivePlayers() - 1 do
        
        local player = getSpecificPlayer(playerIndex)
        
        if player then 

            Yogi.forsake(player)

        end

    end

end

-- Joypad Button Presses Cancel Blessing

Yogi.onPressButtonNoFocus = JoypadControllerData.onPressButtonNoFocus

function JoypadControllerData:onPressButtonNoFocus(button)

    if not MainScreen.instance:isVisible() then

        -- Confirm Player Exists

        local joypadData = self.joypad

        if not joypadData then 
            Yogi.onPressButtonNoFocus(self, button)
            return 
        end

        local playerIndex = joypadData.player

        if not playerIndex then
            Yogi.onPressButtonNoFocus(self, button)
            return 
        end

        local player = getSpecificPlayer(playerIndex)

        if not player then
            Yogi.onPressButtonNoFocus(self, button)
            return 
        end
        
        if player:isDead() then
            Yogi.onPressButtonNoFocus(self, button)
            return 
        end

        if player:isInvisible() then
        
            Yogi.forsake(player)
        
        end
        
        Yogi.onPressButtonNoFocus(self, button)
   
        return

    end

    Yogi.onPressButtonNoFocus(self, button)

end

-- Prevent issues that may arise from somehow dying while you are meditating (perhaps in PvP).

Yogi.prepareToDie = function(player)

    player:setInvisible(false)

    Events.OnTick.Remove(Yogi.maintainConcentration)
    Events.OnKeyStartPressed.Remove(Yogi.interruptConcentration)
    Events.OnPlayerMove.Remove(Yogi.forsake)
    
    local playerIndex = player:getPlayerNum()

    Yogi.relaxing[playerIndex] = nil
    Yogi.resting[playerIndex] = nil
    Yogi.blessed[playerIndex] = nil

    player:clearVariable("Meditative")
    Yogi.reportAnimation(player:getDisplayName(), false)

end

Events.OnPlayerDeath.Add(Yogi.prepareToDie)

-- Practice Tracking

Yogi.daysSurvived = 0
Yogi.daysMeditated = 0
Yogi.meditatedToday = false

Yogi.dedication = function()

    if not SandboxVars.Meditation.dedication then return 1 end

    local frequency = math.max(1, Yogi.daysMeditated) / math.max(1, Yogi.daysSurvived)

    if frequency > .90 then 
        return 2.00
    elseif frequency > .70 then 
        return 1.75
    elseif frequency > .50 then 
        return 1.50
    elseif frequency > .30 then 
        return 1.25
    elseif frequency > .10 then 
        return 1.00
    else
        return 0.75
    end

end

Yogi.practice = function()

    for playerIndex = 0, getNumActivePlayers() - 1 do repeat

        local player = getSpecificPlayer(playerIndex)

        if not (player and player:isAlive() and (Yogi.meditative(player) or Yogi.knowsAboutMeditation(player))) then break end

        Yogi.daysSurvived = Yogi.daysSurvived + 1

        if Yogi.meditatedToday then
            Yogi.daysMeditated = Yogi.daysMeditated + 1
        end

        Yogi.meditatedToday = false

        if not player:getModData().Yogi then
            Yogi.loadModData(playerIndex, player)
        end

        player:getModData().Yogi.daysSurvived = Yogi.daysSurvived
        player:getModData().Yogi.daysMeditated = Yogi.daysMeditated
        player:getModData().Yogi.meditatedToday = false

        player:transmitModData()

    until true end

end

Yogi.discoverMeditation = function(player)

    if player:getModData().Yogi and player:getModData().Yogi.discoveredMeditation then return end

    if Yogi.mod.options.haloNoteFeedback then
        Yogi.notify(player, "Discovering Meditation")
    end

    Yogi.loadModData(player:getPlayerNum(), player, true)

end

Yogi.loadModData = function(playerIndex, player, learning)
    
    if Yogi.meditative(player) or learning then
        
        if player:getModData().Yogi then
            Yogi.daysSurvived = player:getModData().Yogi.daysSurvived
            Yogi.daysMeditated = player:getModData().Yogi.daysMeditated
            Yogi.meditatedToday = player:getModData().Yogi.meditatedToday
        else
            player:getModData().Yogi = {}
            player:getModData().Yogi.daysSurvived = 0
            player:getModData().Yogi.daysMeditated = 0
            player:getModData().Yogi.meditatedToday = false
            Yogi.daysSurvived = 0
            Yogi.daysMeditated = 0
            Yogi.meditatedToday = false
        end

        player:getModData().Yogi.discoveredMeditation = true

        Events.EveryDays.Remove(Yogi.practice)
        Events.EveryDays.Add(Yogi.practice)

    end

end

Events.OnCreatePlayer.Add(Yogi.loadModData)

-- Protects Against a Known Options Bug

if not Exterminator then

    Exterminator = {}

    Exterminator.onEnterFromGame = MainScreen.onEnterFromGame

    function MainScreen:onEnterFromGame()

        Exterminator.onEnterFromGame(self)

        -- Guarantee that when you ENTER the options menu, the game does not think you've already changed your damn options.

        MainOptions.instance.gameOptions.changed = false

    end

end

-- Send Animation to Server

Yogi.reportAnimation = function(displayName, state)
    local arguments = {
        displayName = displayName,
        state = state
    }            
    sendClientCommand("Meditation", "Animation Toggle", arguments)
end

Yogi.acknowledgeAnimation = function(mod, command, arguments)

    if mod ~= "Meditation" or command ~= "Animation Toggle" then return end

    local displayName = arguments.displayName
    local state = arguments.state

    local buddies = getOnlinePlayers()
    
    for index = 0, buddies:size() - 1 do

        local buddy = buddies:get(index)

        if buddy:getDisplayName() == displayName then

            if state then
                buddy:setVariable("Meditative", state)
            else
                buddy:clearVariable("Meditative")
            end

            return

        end

    end

end

Events.OnServerCommand.Remove(Yogi.acknowledgeAnimation)
Events.OnServerCommand.Add(Yogi.acknowledgeAnimation)

-- Meditation is Restorative

Yogi.resting = {}

Yogi.moment = 0

Yogi.rest = function()

    Yogi.moment = Yogi.moment + 1
    
    local nobodyResting = true
    
    for playerIndex = 0, getNumActivePlayers() - 1 do repeat

        if not Yogi.resting[playerIndex] then break end

        local player = getSpecificPlayer(playerIndex)
        
        if not player then
            -- They're probably dead but either way they sure aren't resting.
            Yogi.resting[playerIndex] = nil
            break
        end

        nobodyResting = false

        if player:getStats():getEndurance() < 1 and player:isSitOnGround() then
            player:updateEnduranceWhileSitting()
        end

        if Yogi.moment > Yogi.recovery and player:isSitOnGround() then 

            local meditationVars = SandboxVars.Meditation

            if player:getStats():getFear() > 0 then
                local currentFear = player:getStats():getFear()
                local newFear = math.max(0, currentFear - (meditationVars.fearRecovery * Yogi.dedication()))
                player:getStats():setFear(newFear)
            end
            if player:getStats():getPanic() > 0 then
                local currentPanic = player:getStats():getPanic()
                local newPanic = math.max(0, currentPanic - (meditationVars.panicRecovery * Yogi.dedication()))
                player:getStats():setPanic(newPanic)
            end
            if player:getStats():getAnger() > 0 then
                local currentAnger = player:getStats():getAnger()
                local newAnger = math.max(0, currentAnger - (meditationVars.angerRecovery * Yogi.dedication()))
                player:getStats():setAnger(newAnger)
            end
            if player:getStats():getHunger() > 0 then
                local currentHunger = player:getStats():getHunger()
                local newHunger = math.max(0, currentHunger - (meditationVars.hungerRecovery * Yogi.dedication()))
                player:getStats():setHunger(newHunger)
            end
            if player:getStats():getThirst() > 0 then
                local currentThirst = player:getStats():getThirst()
                local newThirst = math.max(0, currentThirst - (meditationVars.thirstRecovery * Yogi.dedication()))
                player:getStats():setThirst(newThirst)
            end
            if player:getStats():getStress() > 0 then
                local currentStress = player:getStats():getStress()
                local newStress = math.max(0, currentStress - (meditationVars.stressRecovery * Yogi.dedication()))
                player:getStats():setStress(newStress)
            end
            if player:getStats():getFatigue() > 0 then
                local currentFatigue = player:getStats():getFatigue()
                local newFatigue = math.max(0, currentFatigue - (meditationVars.fatigueRecovery * Yogi.dedication()))
                player:getStats():setFatigue(newFatigue)
            end
            if player:getStats():getStressFromCigarettes() > 0 then
                local currentStressFromCigarettes = player:getStats():getStressFromCigarettes()
                local newStressFromCigarettes = math.max(0, currentStressFromCigarettes - (meditationVars.stressRecovery * Yogi.dedication()))
                player:getStats():setStressFromCigarettes(newStressFromCigarettes)
            end
            if player:getBodyDamage():getBoredomLevel() > 0 then
                local currentBoredom = player:getBodyDamage():getBoredomLevel()
                local newBoredom = math.max(0, currentBoredom - (meditationVars.boredomRecovery * Yogi.dedication()))
                player:getBodyDamage():setBoredomLevel(newBoredom)
            end
            if player:getBodyDamage():getUnhappynessLevel() > 0 then
                local currentUnhappiness = player:getBodyDamage():getUnhappynessLevel()
                local newUnhappiness = math.max(0, currentUnhappiness - (meditationVars.happinessRecovery * Yogi.dedication()))
                player:getBodyDamage():setUnhappynessLevel(newUnhappiness)
            end
        end

        if not player:isSitOnGround() or (SandboxVars.Meditation.healingRequiresFocus and not Yogi.focused[playerIndex]) then

            if Yogi.mod.options.haloNoteFeedback and not SandboxVars.Meditation.healingRequiresFocus then
                Yogi.notify(player, "Ending Recovery")    
            end

            player:clearVariable("Meditative")
            Yogi.reportAnimation(player:getDisplayName(), false)
            Yogi.resting[playerIndex] = nil
            Yogi.focused[playerIndex] = nil
        
        end

    until true end
        
    if Yogi.moment > Yogi.recovery then
        Yogi.moment = 0
    end

    if nobodyResting then
        Events.OnTick.Remove(Yogi.rest) 
    end

end

-- Meditation Context Menu Option

Yogi.addMeditation = function(playerIndex, menu, objects, test) 
    
    if test then return true end

    if not Yogi.isContextMenuOptionPreferred() then return end

    local player = getSpecificPlayer(playerIndex)

    if not player or not (Yogi.anyoneCanMeditate() or player:HasTrait("Yogi") or Yogi.knowsAboutMeditation(player)) then return end

    if Yogi.lotus[playerIndex] and player:isSitOnGround() then return end

    Yogi.lotus[playerIndex] = nil

    if Yogi.relaxing[playerIndex] or Yogi.resting[playerIndex] or Yogi.blessed[playerIndex] then return end

    if Yogi.mod.options.meditateBeforeSit then

        if player:isSitOnGround() then

            menu:addOptionOnTop(Yogi.translation.meditate, player, 
            
                function()

                    if Yogi.isMeditationAnimated() then
                        if Yogi.removeHandItems(player, "Context") then return end
                    end

                    Yogi.oldContextMenuSitOnGround(playerIndex)

                    Yogi.meditate(playerIndex, getSpecificPlayer(playerIndex))

                end
            
            )

        else

            menu:insertOptionBefore(getText("ContextMenu_SitGround"), Yogi.translation.meditate, player, 
            
                function()

                    if Yogi.isMeditationAnimated() then
                        if Yogi.removeHandItems(player, "Context") then return end
                    end

                    Yogi.oldContextMenuSitOnGround(playerIndex)

                    Yogi.meditate(playerIndex, getSpecificPlayer(playerIndex))

                end
            
            )

        end

    else

        menu:addOption(Yogi.translation.meditate, player, 
        
            function()

                if Yogi.isMeditationAnimated() then
                    if Yogi.removeHandItems(player, "Context") then return end
                end

                Yogi.oldContextMenuSitOnGround(playerIndex)

                Yogi.meditate(playerIndex, getSpecificPlayer(playerIndex))

            end
        
        )

    end

end 

Events.OnFillWorldObjectContextMenu.Add(Yogi.addMeditation)

-- Delay for Unequipping

Yogi.performUnequipAction = ISUnequipAction.perform

function ISUnequipAction:perform()

    Yogi.performUnequipAction(self)

    local player = self.character

    local playerIndex = player:getPlayerNum()

    local context = Yogi.preparingForMeditation[playerIndex]

    if context and not player:getSecondaryHandItem() then

        if context == "Sit" or context == "Context" then

            Yogi.oldContextMenuSitOnGround(playerIndex)
    
            Yogi.meditate(playerIndex, getSpecificPlayer(playerIndex))

        else -- context == "Radial"
            
            if player:isCurrentState(PlayerSitOnGroundState.instance()) then 

                Yogi.oldJoypadRadialSitToggle(player) 
        
                return
        
            end
        
            Yogi.oldJoypadRadialSitToggle(player)
        
            if not Yogi.isContextMenuOptionPreferred() then
                Yogi.meditate(player:getPlayerNum(), player)
            end

        end

        Yogi.preparingForMeditation[player:getPlayerNum()] = nil

    end

end

-- OCD Sit on Ground Menu Fix

Yogi.bringBalance = function(playerIndex, menu, objects, test)

    if test then return true end
    
    local player = getSpecificPlayer(playerIndex)

    -- Hopefully there's no way to generate a context menu when dead.

    if menu:getOptionFromName("Sit on ground") then
        menu:insertOptionAfter("Sit on ground", "Sit on Ground", player, function() ISWorldObjectContextMenu.onSitOnGround(playerIndex) end)
        menu:removeOptionByName("Sit on ground")
    end

    local walkOnClick = menu:getOptionFromName("Walk to")

    if walkOnClick then
        local target = walkOnClick.target
        local onSelect = walkOnClick.onSelect
        local item = walkOnClick.param1
        menu:insertOptionAfter("Walk to", "Walk", target, function() onSelect(target, item, playerIndex) end)
        menu:removeOptionByName("Walk to")
    end

    local tenYearsLaterRemoveVegetation = menu:getOptionFromName("Remove vegetation")
    
    if tenYearsLaterRemoveVegetation then
        local target = tenYearsLaterRemoveVegetation.target
        local onSelect = tenYearsLaterRemoveVegetation.onSelect
        local square = tenYearsLaterRemoveVegetation.param1
        menu:insertOptionAfter("Remove vegetation", "Remove Vegetation", target, function() onSelect(target, square, player) end)
        menu:removeOptionByName("Remove vegetation")
    end

end

Yogi.waitForTheRightTimeToStrike = function()
    
    Events.OnFillWorldObjectContextMenu.Remove(Yogi.bringBalance)

    if not Yogi.mod.options.applyBalancedLabeling then return end
    -- Sneaky Ninja Things
    Events.OnFillWorldObjectContextMenu.Add(Yogi.bringBalance)

end

Events.OnFillWorldObjectContextMenu.Add(Yogi.waitForTheRightTimeToStrike)
