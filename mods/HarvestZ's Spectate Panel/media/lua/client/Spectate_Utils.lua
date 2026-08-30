local SpectateUtils = {}

---Checks whether or not the player is spectating
---@return boolean
function SpectateUtils.isPlayerSpectating()
    return SpectateUtils.isSpectating or false
end

---Sets the player's spectating target
---@param target string
function SpectateUtils.setSpectateTarget(target)
    SpectateUtils.target = target
    SpectateUtils.isSpectating = true
    Events.OnTick.Remove(SpectateUtils.doSpectate)
    Events.OnTick.Add(SpectateUtils.doSpectate)
end

---Stops the spectate mode
function SpectateUtils.stopSpectating()
    SpectateUtils.isSpectating = false
    Events.OnTick.Remove(SpectateUtils.doSpectate)
end

---Function to start spectating someone
function SpectateUtils.doSpectate()
    if SpectateUtils.isSpectating then
        local target = SpectateUtils.target
        local targetObj = getPlayerFromUsername(target)
        if targetObj then
            local character = getPlayer()
            local x, y, z = targetObj:getX(), targetObj:getY(), targetObj:getZ()
            character:setX(x)
            character:setLx(x)
            character:setY(y)
            character:setLy(y)
            character:setZ(z)
            character:setLz(z)
        end
    end
end

---Function to favorite a player
---@param character IsoPlayer
---@param name string
function SpectateUtils.favoritePlayer(character, name)
    -- Initialize modData table for favorite players if it doesn't exist
    if not character:getModData().favoritePlayers then
        character:getModData().favoritePlayers = {}
    end

    -- Avoid duplicates
    local favoritePlayers = character:getModData().favoritePlayers
    for _, favName in ipairs(favoritePlayers) do
        if favName == name then
            return
        end
    end

    table.insert(favoritePlayers, name)
end

---Function to unfavorite a player
---@param character IsoPlayer
---@param name string
function SpectateUtils.unfavoritePlayer(character, name)
    -- Check if the favoritePlayers list exists
    if not character:getModData().favoritePlayers then
        return
    end

    -- Find and remove the player from the favoritePlayers list
    local favoritePlayers = character:getModData().favoritePlayers
    for i, favName in ipairs(favoritePlayers) do
        if favName == name then
            table.remove(favoritePlayers, i)
            return
        end
    end
end

---Function to check if a player is favorited
---@param character IsoPlayer
---@param name string
---@return boolean
function SpectateUtils.isPlayerFavorited(character, name)
    -- Ensure favoritePlayers list exists
    if not character:getModData().favoritePlayers then
        return false
    end

    -- Check if the player is favorited
    for _, favName in ipairs(character:getModData().favoritePlayers) do
        if favName == name then
            return true
        end
    end

    return false
end

return SpectateUtils
