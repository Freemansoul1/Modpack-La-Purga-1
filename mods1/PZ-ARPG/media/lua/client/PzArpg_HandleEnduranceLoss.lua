local previousEndurance = nil

local function OnPlayerUpdate_HandleEnduranceLoss(player)
    local stats = player:getStats()
    local modData = player:getModData()
    if not modData.pzarpg or not modData.pzarpg.buffs or not modData.pzarpg.buffs['endurance_loss_reduction'] then
        return
    end

    local currentEndurance = stats:getEndurance()

    -- Initialize previousEndurance if it hasn't been set yet
    if not previousEndurance then
        previousEndurance = currentEndurance
        return
    end

    -- Calculate endurance loss
    local enduranceLoss = previousEndurance - currentEndurance

    -- If endurance hasn't decreased, update previousEndurance and exit
    if enduranceLoss <= 0 then
        previousEndurance = currentEndurance
        return
    end

    -- Cap lossFactor between 0 and 0.8
    -- Todo change capping when implemented properly
    local lossFactor = modData.pzarpg.buffs['endurance_loss_reduction'].value
    lossFactor = math.max(0, math.min(lossFactor, 0.8))

    -- Apply the endurance loss reduction
    local reducedEnduranceLoss = enduranceLoss * (1 - lossFactor)

    -- Calculate the new endurance
    local newEndurance = previousEndurance - reducedEnduranceLoss

    -- Update the player's endurance and previousEndurance
    stats:setEndurance(newEndurance)
    previousEndurance = currentEndurance
end

Events.OnPlayerUpdate.Add(OnPlayerUpdate_HandleEnduranceLoss)
