GiveItem = GiveItem or {}

GiveItem.getDistance2D = function(_x1, _y1, _x2, _y2)
    return math.sqrt(math.abs(_x2 - _x1) ^ 2 + math.abs(_y2 - _y1) ^ 2);
end

-- GiveItem.getPlayersInRange = function(player)
--     local players = {}
--     if not isClient() and not isServer() then
--         -- Is singleplayer
--         return {}
--     else
--         players = getOnlinePlayers()
--     end
--     local playersInRange = {}
--     for i = 0, players:size() - 1 do
--         local otherPlayer = players:get(i)
--         if otherPlayer:getSteamID() ~= player:getSteamID() or otherPlayer:getUsername() ~= player:getUsername() then
--             local x1 = player:getX()
--             local y1 = player:getY()
--             local x2 = otherPlayer:getX()
--             local y2 = otherPlayer:getY()
--             local distance = GiveItem.getDistance2D(x1, y1, x2, y2)
--             if distance < 2 then
--                 table.insert(playersInRange, otherPlayer)
--             end
--         end
--     end
--     return playersInRange
-- end

GiveItem.getCloseByCharacters = function(player)
    local characters = {}
    local x1 = player:getX()
    local y1 = player:getY()
    local z1 = player:getZ()
    -- look for IsoGameCharacters in a 2 tile radius
    for x = x1 - 1, x1 + 1 do
        for y = y1 - 1, y1 + 1 do
            local sq = getCell():getGridSquare(x, y, z1)
            if sq then
                for i = 0, sq:getMovingObjects():size() - 1 do
                    local obj = sq:getMovingObjects():get(i)
                    if obj and obj:isCharacter() and obj ~= player and not obj:isZombie() then
                        table.insert(characters, obj)
                    end
                end
            end
        end
    end
    return characters
end
