local lastBodyDamageState

local function getBodyDamage(player)
    local bodyDamage = player:getBodyDamage()
    return {
        bodyDamage = bodyDamage,
        parts = {
            bodyDamage:getBodyPart(BodyPartType.Torso_Upper), bodyDamage:getBodyPart(BodyPartType.Torso_Lower),
            bodyDamage:getBodyPart(BodyPartType.ForeArm_L), bodyDamage:getBodyPart(BodyPartType.ForeArm_R),
            bodyDamage:getBodyPart(BodyPartType.UpperArm_L), bodyDamage:getBodyPart(BodyPartType.UpperArm_R),
            bodyDamage:getBodyPart(BodyPartType.Groin), bodyDamage:getBodyPart(BodyPartType.Neck),
            bodyDamage:getBodyPart(BodyPartType.Back), bodyDamage:getBodyPart(BodyPartType.Head),
            bodyDamage:getBodyPart(BodyPartType.UpperLeg_L), bodyDamage:getBodyPart(BodyPartType.UpperLeg_R),
            bodyDamage:getBodyPart(BodyPartType.LowerLeg_L), bodyDamage:getBodyPart(BodyPartType.LowerLeg_R),
            bodyDamage:getBodyPart(BodyPartType.Foot_L), bodyDamage:getBodyPart(BodyPartType.Foot_R)
        }
    }
end

local function updateLastBodyHealth(player)
    local bodyDamage = getBodyDamage(player)
    lastBodyDamageState = {}
    for _, bodyPart in ipairs(bodyDamage.parts) do
        lastBodyDamageState[bodyPart:getType()] = bodyPart:getHealth()
    end
end

local function PzArpg_HandleHealthLoss(player)
    local modData = player:getModData()
    if not modData.pzarpg or not modData.pzarpg.buffs or not modData.pzarpg.buffs['health_loss_reduction'] then
        return
    end

    -- Initialize lastBodyDamageState if it hasn't been set yet
    if not lastBodyDamageState then
        updateLastBodyHealth(player)
        return
    end

    local lossFactor = modData.pzarpg.buffs['health_loss_reduction'].value
    lossFactor = math.max(0, math.min(lossFactor, 0.8)) -- Cap lossFactor between 0 and 0.8

    for bodyPartType, lastBodyHealth in pairs(lastBodyDamageState) do
        local bodyDamage = player:getBodyDamage()
        local bodyPart = bodyDamage:getBodyPart(bodyPartType)
        
        local currentHealth = bodyPart:getHealth()
        local healthLoss = lastBodyHealth - currentHealth

        if healthLoss > 0 then
            -- Reduce health loss based on the buff
            local reducedHealthLoss = healthLoss * (1 - lossFactor)

            -- Calculate the new health
            local newHealth = lastBodyHealth - reducedHealthLoss
            bodyPart:SetHealth(newHealth)
        end
    end

    updateLastBodyHealth(player)
end

Events.OnPlayerUpdate.Add(PzArpg_HandleHealthLoss)
