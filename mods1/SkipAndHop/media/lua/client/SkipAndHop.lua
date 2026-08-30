----------------
--somewhatfrog--
----------------

local runningTicks = 0

local function OnPlayerUpdate(player)
    if not SandboxVars.SkipAndHop.SS then return end

    if player:isRunning() then
        runningTicks = runningTicks + 1
        if runningTicks < 10 then
            local stats = player:getStats()
            local currentEndurance = stats:getEndurance()
            stats:setEndurance(currentEndurance - 0.0002)
        end
    else
        runningTicks = 0
    end
end

Events.OnPlayerUpdate.Add(OnPlayerUpdate)

local function OnAIStateChange(character, newState, oldState)
    if not SandboxVars.SkipAndHop.HP then return end
    if character ~= getSpecificPlayer(0) then return end

    if newState == ClimbOverFenceState.instance() and not character:isRunning() then
        local stats = character:getStats()
        local currentEndurance = stats:getEndurance()
        stats:setEndurance(currentEndurance - 0.0078)
    end
end

Events.OnAIStateChange.Add(OnAIStateChange)