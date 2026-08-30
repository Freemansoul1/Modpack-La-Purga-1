
local function HandleAddictUpdate(_player, frequency)
    player = _player;
    HoursChem = player:getModData().HoursSinceChem;
    if HoursChem < frequency then
        --player:Say("I'm Good");
        return;
    end

    local detoxHours = getSandboxOptions():getOptionByName("ScientificChemistry.Cold"):getValue();

    -- handle finishing detox
    if HoursChem > detoxHours then
        player:getTraits():remove("ChemJunkie");
        return;
    end
    
    local halfPoint = detoxHours / 2.0;
    local quaterPoint = halfPoint / 2.0;
    ---[[
    local currentUnhappiness = 0.5;
    if HoursChem <= quaterPoint then
        --player:Say("I'm Not so good Good");
        if player:getStats():getStress() < 0.10 then
            player:getStats():setStress(player:getStats():getStress() + 0.05);
        end
        if player:getStats():getEndurance() > 0.90 then
            player:getStats():setEndurance(player:getStats():getEndurance() - 0.05);
        end
    --]]
    ---[[
    elseif HoursChem <= halfPoint then
        if player:getStats():getStress() < 0.30 then
            player:getStats():setStress(player:getStats():getStress() + 0.05);
        end
        if player:getStats():getEndurance() > 0.85 then
            player:getStats():setEndurance(player:getStats():getEndurance() - 0.08);
        end
    --]]
    ---[[
    elseif HoursChem <= halfPoint + quaterPoint then
        if player:getStats():getStress() < 0.40 then
            player:getStats():setStress(player:getStats():getStress() + 0.05);
        end
        if player:getStats():getEndurance() > 0.80 then
            player:getStats():setEndurance(player:getStats():getEndurance() - 0.10);
        end
        if player:getStats():getPain() < 20.0 then
            player:getStats():setPain(player:getStats():getPain() + 0.10);
        end
    --]]
    ---[[
    elseif HoursChem > halfPoint + quaterPoint then
        if player:getStats():getStress() < 0.50 then
            player:getStats():setStress(player:getStats():getStress() + 0.07);
        end
        if player:getStats():getEndurance() > 0.75 then
            player:getStats():setEndurance(player:getStats():getEndurance() - 0.15);
        end
        if player:getStats():getPain() < 50.0 then
            player:getStats():setPain(player:getStats():getPain() + 0.20);
        end
    end
    player:getBodyDamage():setUnhappynessLevel(player:getBodyDamage():getUnhappynessLevel() + currentUnhappiness);
    
    --]]
end


local function HandleTenMinuteUpdate()
    local player = getPlayer();

    if player:isZombie() then
        return
    end

    local medicationFrequency = getSandboxOptions():getOptionByName("ScientificChemistry.Frequency"):getValue();
    --if SandboxVars.ExpTraits.MedicationFrequencyHours then
       -- medicationFrequency = SandboxVars.ExpTraits.MedicationFrequencyHours;
    --end

    if player:HasTrait("ChemJunkie") then
        HandleAddictUpdate(player, medicationFrequency);
    end
end
Events.EveryTenMinutes.Add(HandleTenMinuteUpdate);