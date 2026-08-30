require "LandClaim/LC_Utils"

local SafehouseController = {}

--- Validates a root square for a new safehouse
---@param square IsoGridSquare
---@return boolean
function SafehouseController.IsSquareValidForNewSafehouse(square)
    local safehouses = ClientData.GetLandClaimSafehouses()
    local cellCoordinates = LC_Utils.CalculateCellCoordinates(square:getX(), square:getY())
    local searchCells = LC_Utils.GetSurroundingCoordinates(cellCoordinates.x, cellCoordinates.y, 1, true)

    -- distance squared for optimisation
    local distanceBetweenSafehouses = SandboxVars.LC.DistanceBetweenSafehouses *
                                          SandboxVars.LC.DistanceBetweenSafehouses

    local tempCellKey
    for _, safehouse in ipairs(safehouses) do
        local distance = LC_Utils.GetDistanceSquared(safehouse.Center.X, safehouse.Center.Y, square:getX(), square:getY())
        if distance < distanceBetweenSafehouses then
            return false
        end
    end

    return true
end

--- Get owner of safehouse that coveres the square
---@param player IsoPlayer
---@param square IsoGridSquare
---@return boolean
function SafehouseController.IsOwner(player, square)
    local safehouse = SafeHouse.getSafeHouse(square)
    if safehouse then
        return safehouse:isOwner(player)
    end

    return false
end

--- Get safehouse centers by cells
--- This is important for optimising the check for nearby safehouses
---@return Table {"4;1" = {x=1,y=1}}
function SafehouseController.GetSafehousesCenters()
    local tempSafehouseData = ServerData.GetLandClaimSafehouses()

    local result = {}

    for id, data in pairs(tempSafehouseData) do
        local cellCoordinates = LC_Utils.CalculateCellCoordinates(data.Center.X, data.Center.Y)
        local cellKey = cellCoordinates.x .. ";" .. cellCoordinates.y
        result[cellKey] = result[cellKey] or {}
        table.insert(result[cellKey], {
            x = data.Center.X,
            y = data.Center.Y
        })
    end

    return result
end

function SafehouseController.GetSafehouseAccessLevel(player, safehouse)
    if safehouse:isOwner(player) then
        return LandClaimConfig.RankStrings.Owner
    elseif safehouse:playerAllowed(player) then
        local tempSafehouseData = ServerData.GetLandClaimSafehouses()

        local data = tempSafehouseData[LC_Utils.GetSafehouseId(safehouse)]
        
        if not data then return LandClaimConfig.RankStrings.Unauthorized end

        local safehousePlayer = data.Players[player:getUsername()]

        if not safehousePlayer then
            return LandClaimConfig.RankStrings.Unauthorized
        else
            return LandClaimConfig.RankLevels[safehousePlayer.RankLevel]
        end
    else
        return LandClaimConfig.RankStrings.Unauthorized
    end
end

function SafehouseController.GetSafehouseByName(name)
    local safehouses = SafeHouse.getSafehouseList()
    local size = safehouses:size()
    for i = 0, size - 1 do
        local data = safehouses:get(i)
        if data:getTitle() == name then
            return data
        end
    end

    return nil
end

--- Gets safehouse permissions for player's safehouse role
---@param player IsoPlayer
---@param safehouse Safehouse
---@return {canDestroy, canDismantle, canPickup}
function SafehouseController.GetSafehousePermissionsForPlayer(player, safehouse)
    local accessLevel = SafehouseController.GetSafehouseAccessLevel(player, safehouse)
    return LandClaimConfig.Ranks[accessLevel]
end

function SafehouseController.IsPlayerAllowedBySafehouse(player, safehouse)
    return safehouse:playerAllowed(player)
end

function SafehouseController.IsPlayerAllowedBySquare(player, square)
    local safehouse = SafeHouse.getSafeHouse(square)
    if safehouse then
        return SafehouseController.IsPlayerAllowedBySafehouse(player, safehouse)
    end
end

local function getPermission(player, square, permission)
    local playerObj
    
    if type(player) == "number" then
        playerObj = getSpecificPlayer(player)
    else
        playerObj = player
    end

    local safehouse = SafeHouse.getSafeHouse(square)
    if safehouse then
        local permissions = SafehouseController.GetSafehousePermissionsForPlayer(playerObj, safehouse)
        return permissions[permission]
    end

    return nil
end

function SafehouseController.CanBuild(player, square)
    local hasPermission = getPermission(player, square, "canBuild")
    if hasPermission == nil then
        hasPermission = true
    end -- no safehouse, hence can globally build stuff
    return hasPermission
end

function SafehouseController.CanPickup(player, square)
    local hasPermission = getPermission(player, square, "canPickup")
    if hasPermission == nil then
        hasPermission = true
    end -- no safehouse, hence can globally pickup stuff
    return hasPermission
end

function SafehouseController.CanDismantle(player, square)
    local hasPermission = getPermission(player, square, "canDismantle")
    if hasPermission == nil then
        hasPermission = true
    end -- no safehouse, hence can globally dismantle stuff
    return hasPermission
end

function SafehouseController.CanDestroy(player, square)
    local hasPermission = getPermission(player, square, "canDestroy")
    if hasPermission == nil then
        hasPermission = true
    end -- no safehouse, hence can globally destroy stuff
    return hasPermission
end

--- Gets all players of a safehouse
---@param safehouse Safehouse
---@return Table @Table of {LC_Utils.GetSafehouseId(safehouse) = Safehouse}
function SafehouseController.GetSafehousePlayers(safehouse, includeOwner)
    local list = {}
    for i = 0, safehouse:getPlayers():size() - 1 do
        local newPlayer = {};
        newPlayer.name = self.safehouse:getPlayers():get(i);
        if includeOwner then
            list[newPlayer.name] = newPlayer;
        elseif newPlayer.name ~= safehouse:getOwner() then
            list[newPlayer.name] = newPlayer;
        end
    end

    return list
end

--- Gets all safehouses of a player
---@param safehouse Safehouse
---@return Table @Table of {LC_Utils.GetSafehouseId(safehouse) = Safehouse}
function SafehouseController.GetPlayerSafehouses(player)
    local safehouses = SafeHouse.getSafehouseList()
    local playerSafehouses = {}
    local size = safehouses:size()
    for i = 0, size - 1 do
        local safehouse = safehouses:get(i)
        if SafehouseController.GetSafehouseAccessLevel(player, safehouse) ~= LandClaimConfig.RankStrings.Unauthorized then
            playerSafehouses[LC_Utils.GetSafehouseId(safehouse)] = safehouse
        end
    end

    return playerSafehouses
end

function SafehouseController.SetTitleBySquare(square, title)
    local safehouse = SafeHouse.getSafeHouse(square)
    if safehouse then
        safehouse:setTitle(title)
        safehouse:syncSafehouse()
    end
end

return SafehouseController
