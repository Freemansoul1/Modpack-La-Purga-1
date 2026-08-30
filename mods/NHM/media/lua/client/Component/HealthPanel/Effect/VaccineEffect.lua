local vaccineEffect = {}

vaccineEffect.update = function(player)
    if not player or player:isDead() then
        return
    end
end

vaccineEffect.apply = function(player)
    if not player or player:isDead() then
        return
    end

    player:getStats():setHunger(0.7)
    player:getStats():setThirst(0.8)
    player:getStats():setFatigue(0.7)
    player:getStats():setEndurance(0.25);
    player:getBodyDamage():setFoodSicknessLevel(40)

    if player:getBodyDamage():isInfected() then
        for i = BodyPartType.ToIndex(BodyPartType.Hand_L), BodyPartType.ToIndex(BodyPartType.MAX) - 1 do
            local bodyPart = player:getBodyDamage():getBodyPart(BodyPartType.FromIndex(i))
            bodyPart:SetInfected(false)
        end
        player:getBodyDamage():setInfectionLevel(0);
        player:getBodyDamage():setInfected(false)
        player:getBodyDamage():setInfectionMortalityDuration(-1);
        player:getBodyDamage():setInfectionTime(-1);

    else
        player:getBodyDamage():setInfected(true)

    end
end

local isEventInitialized = false
if not isEventInitialized then
    isEventInitialized = true
    Events.OnPlayerUpdate.Add(vaccineEffect.update)
end

return vaccineEffect

