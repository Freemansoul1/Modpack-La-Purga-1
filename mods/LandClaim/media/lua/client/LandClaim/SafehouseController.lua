require "LandClaim/LC_Utils"
local highlightSafehouseSquares = require "LandClaim/HighlightSafehouseSquares"

local SafehouseController = {}

local function getFloorWorldObjectCountsForSquare(square, floorWorldObjectCounts)
    if not square then return floorWorldObjectCounts end
    local floorWorldObjects = square:getWorldObjects()
    for i = 0, floorWorldObjects:size() - 1 do
        local object = floorWorldObjects:get(i);
        local item = object:getItem()
        if not floorWorldObjectCounts[item:getFullType()] then
            floorWorldObjectCounts[item:getFullType()] = 1
        else
            floorWorldObjectCounts[item:getFullType()] = floorWorldObjectCounts[item:getFullType()] + 1
        end
    end

    return floorWorldObjectCounts
end

local function getFloorWorldObjectCounts(player)
    local playerSquare = player:getSquare()

    local floorWorldObjects = playerSquare:getWorldObjects()
    local floorWorldObjectCounts = {}
    floorWorldObjectCounts = getFloorWorldObjectCountsForSquare(playerSquare, floorWorldObjectCounts)
    floorWorldObjectCounts = getFloorWorldObjectCountsForSquare(getCell():getOrCreateGridSquare(playerSquare:getX()-1, playerSquare:getY()-1, playerSquare:getZ()), floorWorldObjectCounts)
    floorWorldObjectCounts = getFloorWorldObjectCountsForSquare(getCell():getOrCreateGridSquare(playerSquare:getX()-1, playerSquare:getY(), playerSquare:getZ()), floorWorldObjectCounts)
    floorWorldObjectCounts = getFloorWorldObjectCountsForSquare(getCell():getOrCreateGridSquare(playerSquare:getX()-1, playerSquare:getY()+1, playerSquare:getZ()), floorWorldObjectCounts)
    floorWorldObjectCounts = getFloorWorldObjectCountsForSquare(getCell():getOrCreateGridSquare(playerSquare:getX(), playerSquare:getY()-1, playerSquare:getZ()), floorWorldObjectCounts)
    floorWorldObjectCounts = getFloorWorldObjectCountsForSquare(getCell():getOrCreateGridSquare(playerSquare:getX(), playerSquare:getY()+1, playerSquare:getZ()), floorWorldObjectCounts)
    floorWorldObjectCounts = getFloorWorldObjectCountsForSquare(getCell():getOrCreateGridSquare(playerSquare:getX()+1, playerSquare:getY()-1, playerSquare:getZ()), floorWorldObjectCounts)
    floorWorldObjectCounts = getFloorWorldObjectCountsForSquare(getCell():getOrCreateGridSquare(playerSquare:getX()+1, playerSquare:getY(), playerSquare:getZ()), floorWorldObjectCounts)
    floorWorldObjectCounts = getFloorWorldObjectCountsForSquare(getCell():getOrCreateGridSquare(playerSquare:getX()+1, playerSquare:getY()+1, playerSquare:getZ()), floorWorldObjectCounts)

    return floorWorldObjectCounts
end

local function removeWorldObjectFromSquare(square, itemType)
    if not square then return false end
    local floorWorldObjects = square:getWorldObjects()

    for i = 0, floorWorldObjects:size() - 1 do
        local object = floorWorldObjects:get(i);
        local item = object:getItem()

        if item:getFullType() == itemType then
            square:transmitRemoveItemFromSquare(object);
            square:removeWorldObject(object)
            object:removeFromWorld()
            object:removeFromSquare()
            item:setWorldItem(nil);
            square:RecalcProperties();
            square:RecalcAllWithNeighbours(true);
            ISInventoryPage.renderDirty = true
            ISInventoryPage.dirtyUI();
            return true
        end
    end

    return false
end

local function removeWorldObject(player, itemType)
    local playerSquare = player:getSquare()
    local floorWorldObjects = playerSquare:getWorldObjects()
    
    if removeWorldObjectFromSquare(playerSquare, itemType) then return end
    if removeWorldObjectFromSquare(getCell():getOrCreateGridSquare(playerSquare:getX()-1, playerSquare:getY()-1, playerSquare:getZ()), itemType) then return end
    if removeWorldObjectFromSquare(getCell():getOrCreateGridSquare(playerSquare:getX()-1, playerSquare:getY(), playerSquare:getZ()), itemType) then return end
    if removeWorldObjectFromSquare(getCell():getOrCreateGridSquare(playerSquare:getX()-1, playerSquare:getY()+1, playerSquare:getZ()), itemType) then return end
    if removeWorldObjectFromSquare(getCell():getOrCreateGridSquare(playerSquare:getX(), playerSquare:getY()-1, playerSquare:getZ()), itemType) then return end
    if removeWorldObjectFromSquare(getCell():getOrCreateGridSquare(playerSquare:getX(), playerSquare:getY()+1, playerSquare:getZ()), itemType) then return end
    if removeWorldObjectFromSquare(getCell():getOrCreateGridSquare(playerSquare:getX()+1, playerSquare:getY()-1, playerSquare:getZ()), itemType) then return end
    if removeWorldObjectFromSquare(getCell():getOrCreateGridSquare(playerSquare:getX()+1, playerSquare:getY(), playerSquare:getZ()), itemType) then return end
    if removeWorldObjectFromSquare(getCell():getOrCreateGridSquare(playerSquare:getX()+1, playerSquare:getY()+1, playerSquare:getZ()), itemType) then return end
end

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
    for _, safehouse in pairs(safehouses) do
        local distance = LC_Utils.GetDistanceSquared(safehouse.Center.X, safehouse.Center.Y, square:getX(), square:getY())
        if distance < distanceBetweenSafehouses then
            return false
        end
    end

    return true
end

--- Validates a root square for a new safehouse
---@param square IsoGridSquare
---@return boolean
function SafehouseController.IsSquareValidForBuilding(player, square)
    local safehouses = ClientData.GetLandClaimSafehouses()
    local cellCoordinates = LC_Utils.CalculateCellCoordinates(square:getX(), square:getY())
    local searchCells = LC_Utils.GetSurroundingCoordinates(cellCoordinates.x, cellCoordinates.y, 1, true)

    -- distance squared for optimisation
    local buildingDistance = LandClaimConfig.BuildingDistance *
                                          LandClaimConfig.BuildingDistance

    local tempCellKey
    for _, safehouse in pairs(safehouses) do
        local distance = LC_Utils.GetDistanceSquared(safehouse.Center.X, safehouse.Center.Y, square:getX(), square:getY())
        if distance < buildingDistance then
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
    local tempSafehouseData = ClientData.GetLandClaimSafehouses()

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
        local tempSafehouseData = ClientData.GetLandClaimSafehouses()

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
    local allowed = safehouse:playerAllowed(player)
    return allowed
end

function SafehouseController.IsPlayerAllowedBySquare(player, square)
    local safehouse = SafeHouse.getSafeHouse(square)
    if safehouse then
        return SafehouseController.IsPlayerAllowedBySafehouse(player, safehouse)
    end
end

local function getPermission(player, square, permission)
    if isAdmin() then
        return true
    end

    local safehouse = SafeHouse.getSafeHouse(square)
    if safehouse then
        local permissions = SafehouseController.GetSafehousePermissionsForPlayer(player, safehouse)
        return permissions[permission]
    end

    return nil
end

function SafehouseController.CanLockDoors(player, square)
    local hasPermission = getPermission(player, square, "canLockDoors")
    if hasPermission == nil then
        hasPermission = true
    end -- no safehouse, hence can globally lock/unlock stuff

    return hasPermission
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

--- CLIENT ONLY - Highlight the entire safehouse that the square belongs to
---@param square IsoGridSquare
function SafehouseController.HighlightSafehouse(square)
    local safehouse = SafeHouse.getSafeHouse(square)
    highlightSafehouseSquares.Highlight(safehouse)
end

--- CLIENT ONLY - Add player to safehouse
---@param safehouse Safehouse
---@param player IsoPlayer
function SafehouseController.AddPlayer(safehouse, playerUsername)
    sendClientCommand("LandClaim_Server", "AddPlayerToSafehouse", {
        safehouseId = LC_Utils.GetSafehouseId(safehouse),
        isOwner = false,
        username = playerUsername
    })
end

--- CLIENT ONLY - Remove player from safehouse
---@param safehouse Safehouse
---@param player IsoPlayer
function SafehouseController.RemovePlayer(safehouse, playerUsername)
    safehouse:removePlayer(playerUsername)
    sendClientCommand("LandClaim_Server", "RemovePlayerToSafehouse", {
        safehouseId = LC_Utils.GetSafehouseId(safehouse),
        username = playerUsername
    })
end

--- CLIENT ONLY - Promote player in safehouse
---@param safehouse Safehouse
---@param player IsoPlayer
function SafehouseController.PromotePlayer(safehouse, playerUsername)
    sendClientCommand("LandClaim_Server", "UpdatePlayerRankOfSafehouse", {
        safehouseId = LC_Utils.GetSafehouseId(safehouse),
        username = playerUsername,
        promote = true
    })
end

--- CLIENT ONLY - Demote player in safehouse
---@param safehouse Safehouse
---@param player IsoPlayer
function SafehouseController.DemotePlayer(safehouse, playerUsername)
    sendClientCommand("LandClaim_Server", "UpdatePlayerRankOfSafehouse", {
        safehouseId = LC_Utils.GetSafehouseId(safehouse),
        username = playerUsername,
        demote = true
    })
end

--- CLIENT ONLY - Upgrade safehouse level
---@param safehouse Safehouse
---@param player IsoPlayer
function SafehouseController.UpgradeSafehouse(safehouse, player)
    local tempSafehouseData = ClientData.GetLandClaimSafehouses()
    local safehouseData = tempSafehouseData[LC_Utils.GetSafehouseId(safehouse)]

    if not SafehouseController.CanUpgrade(nil, safehouseData, player) then
        player:setHaloNote("Can't upgrade safehouse!");
        return
    end

    local nextLevel = safehouseData.Level + 1
    local level = LandClaimConfig.SafehouseLevels[nextLevel]
    local inventory = player:getInventory()
    local cost = level.Cost

    for itemType, count in pairs(level.Cost) do
        for i = 1, count do
            local item = inventory:getItemFromType(itemType)
            if item then 
                inventory:DoRemoveItem(item)
            else
                removeWorldObject(player, itemType)
            end
        end
    end


    local radius = SandboxVars.LC['SafehouseLevelRadius' .. nextLevel]

    local bounds = LC_Utils.CalculateSquareCoordinates(safehouseData.Center.X, safehouseData.Center.Y, radius, radius)
    
    local safehouseTitle = safehouse:getTitle()
    safehouse:removeSafeHouse(player)

    local newSafehouse = SafeHouse.addSafeHouse(bounds.x1, bounds.y1, radius, radius, player:getUsername(), false)
    newSafehouse:setTitle(safehouseTitle)
    newSafehouse:syncSafehouse()

    sendClientCommand("LandClaim_Server", "UpdateSafehouseLevel", {
        safehouseId = LC_Utils.GetSafehouseId(safehouse),
        upgrade = true
    })
end

--- CLIENT ONLY - Downgrade safehouse level
---@param safehouse Safehouse
---@param player IsoPlayer
function SafehouseController.DowngradeSafehouse(safehouse, player)
    local tempSafehouseData = ClientData.GetLandClaimSafehouses()

    local safehouseData = tempSafehouseData[LC_Utils.GetSafehouseId(safehouse)]

    local nextLevel = safehouseData.Level - 1
    local level = LandClaimConfig.SafehouseLevels[nextLevel]
    local inventory = player:getInventory()
    local radius = SandboxVars.LC['SafehouseLevelRadius' .. nextLevel]
    local bounds = LC_Utils.CalculateSquareCoordinates(safehouseData.Center.X, safehouseData.Center.Y, radius, radius)
    
    local safehouseTitle = safehouse:getTitle()
    safehouse:removeSafeHouse(player)
    
    local newSafehouse = SafeHouse.addSafeHouse(bounds.x1, bounds.y1, radius, radius, player:getUsername(), false)
    newSafehouse:setTitle(safehouseTitle)
    newSafehouse:syncSafehouse()

    sendClientCommand("LandClaim_Server", "UpdateSafehouseLevel", {
        safehouseId = LC_Utils.GetSafehouseId(safehouse),
        downgrade = true
    })
end

--- CLIENT ONLY - Create new safehouse
---@param safehouse Safehouse
---@param player IsoPlayer
function SafehouseController.CreateSafehouse(square, player)
    if not SafehouseController.IsSquareValidForNewSafehouse(square) then
        print('Invalid Square For New Safehouse!')
        return
    end

    local radius = SandboxVars.LC['SafehouseLevelRadius1']

    local bounds = LC_Utils.CalculateSquareCoordinates(square:getX(), square:getY(), radius, radius)
    local newSafehouse = SafeHouse.addSafeHouse(bounds.x1, bounds.y1, radius, radius, player:getUsername(), false)
    newSafehouse:setTitle(player:getUsername() .. "'s Safehouse")
    newSafehouse:syncSafehouse()
    sendClientCommand("LandClaim_Server", "CreateSafehouse", {
        safehouseId = LC_Utils.GetSafehouseId(newSafehouse),
        x = square:getX(),
        y = square:getY(),
        z = square:getZ()
    })
    print('Created Safehouse')
end

--- CLIENT ONLY - Delete safehouse
---@param safehouse Safehouse
---@param player IsoPlayer
function SafehouseController.DeleteSafehouse(square, player, isRaid)
    local safehouse = SafeHouse.getSafeHouse(square)
    SafehouseController.DeleteSafehouseBySafehouse(safehouse, player, isRaid)
end

function SafehouseController.DeleteSafehouseBySafehouse(safehouse, player, isRaid)
    if not safehouse then return end
    local safehouseId = LC_Utils.GetSafehouseId(safehouse);
    if isRaid then
        safehouse:removeSafeHouse(player, true) --bypass player owner check
    else
        safehouse:removeSafeHouse(player)
    end
    sendClientCommand("LandClaim_Server", "DeleteSafehouse", {
        safehouseId = safehouseId
    })
    print('Deleted Safehouse')
end

function SafehouseController.CheckCost(safehouseData, player)
    local nextLevel = safehouseData.Level + 1
    local level = LandClaimConfig.SafehouseLevels[nextLevel]
    local cost = level.Cost
    
    local inventory = player:getInventory()
    local floorInventory = getFloorWorldObjectCounts(player)

    for item, count in pairs(level.Cost) do
        local floorInventoryCount = floorInventory[item] or 0
        if inventory:getCountType(item) + floorInventoryCount < count then
            return false
        end
    end

    return true
end

function SafehouseController.CanUpgrade(square, safehouseGlobalModData, player)
    if square and not SafehouseController.IsOwner(player, square) then
        print('Only an owner can upgrade a safehouse!')
        return
    end

    if safehouseGlobalModData.Level == LandClaimConfig.MinimumSafehouseLevel then
       return SafehouseController.CheckCost(safehouseGlobalModData, player)
    elseif safehouseGlobalModData.Level == LandClaimConfig.MaximumSafehouseLevel then
        return false
    else
        return SafehouseController.CheckCost(safehouseGlobalModData, player)
    end
end

function SafehouseController.GetPlayerRank(safehouse, playerUsername)
    local tempSafehouseData = ClientData.GetLandClaimSafehouses()
    local safehouseData = tempSafehouseData[LC_Utils.GetSafehouseId(safehouse)]
    if safehouseData.Players[playerUsername] then
        return safehouseData.Players[playerUsername].RankLevel
    end

    return ''
end


function SafehouseController.CanPromotePlayer(safehouse, playerUsername)
    local tempSafehouseData = ClientData.GetLandClaimSafehouses()
    local safehouseData = tempSafehouseData[LC_Utils.GetSafehouseId(safehouse)]
    if safehouseData.Players[playerUsername] then
        return safehouseData.Players[playerUsername].RankLevel < LandClaimConfig.MaximumMemberRankLevel
    end

    return false
end

function SafehouseController.CanDemotePlayer(safehouse, playerUsername)
    local tempSafehouseData = ClientData.GetLandClaimSafehouses()
    local safehouseData = tempSafehouseData[LC_Utils.GetSafehouseId(safehouse)]
    if safehouseData.Players[playerUsername] and not safehouseData.Players[playerUsername].IsOwner then
        return safehouseData.Players[playerUsername].RankLevel > LandClaimConfig.MinimumMemberRankLevel
    end

    return false
end

return SafehouseController
