require "SpeedFramework"

local function PzArpg_HandleMovementSpeed(player)
    local modData = player:getModData()
    if not modData.pzarpg or not modData.pzarpg.buffs or not modData.pzarpg.buffs['movement_speed'] then
        return
    end

    local speedModifier = 1 + modData.pzarpg.buffs['movement_speed'].value

    SpeedFramework.SetPlayerSpeed(player, speedModifier)
end

Events.OnPlayerUpdate.Add(PzArpg_HandleMovementSpeed)