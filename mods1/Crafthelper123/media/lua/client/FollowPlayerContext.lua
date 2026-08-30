require "TimedActions/FollowPlayerAction"
require "TimedActions/ISTimedActionQueue"

local function FollowPlayer(player, otherPlayer)
    ISTimedActionQueue.add(FollowPlayerAction:new(player, otherPlayer))
end

local function AddFollowPlayerOption(playerIdx, context, worldObjects)
    local player = getPlayer(playerIdx)
    for _, v in ipairs(worldObjects) do
        local movingObjects = v:getSquare():getMovingObjects()
        for i = 0, movingObjects:size() - 1 do
            local object = movingObjects:get(i)
            if instanceof(object, "IsoPlayer") and player ~= object then
                context:addOption("Follow " .. object:getDescriptor():getForename(), player, FollowPlayer, object)
                return
            end
        end
    end
end

Events.OnFillWorldObjectContextMenu.Add(AddFollowPlayerOption)