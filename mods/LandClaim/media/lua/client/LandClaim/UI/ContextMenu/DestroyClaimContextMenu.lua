local SafehouseController = require "LandClaim/SafehouseController"

local function destroyClaim(safehouse, square, player)
    if luautils.walkAdj(player, square) then
        ISTimedActionQueue.add(ISDestroyLandClaim:new(player, square, safehouse))
    end
end

local function DestroyClaimContextMenu(playerIndex, context, worldObjects, test)
	local player = getSpecificPlayer(playerIndex)
    local square

    if player:getVehicle() then return end

    for i,v in ipairs(worldObjects) do
        square = v:getSquare();
        break
    end

    if not square then return end

    if IsoUtils.DistanceTo(square:getX(), square:getY(), player:getX(), player:getY()) > 2 then
        return
    end

    local safehouse = SafeHouse.getSafeHouse(square)
    if not safehouse then return end

    local safehouses = ClientData.GetLandClaimSafehouses()

    local safehouseData = safehouses[LC_Utils.GetSafehouseId(safehouse)]

    if not safehouseData then return end

    if not (safehouseData.Center.X == square:getX() and safehouseData.Center.Y == square:getY() and safehouseData.Center.Z == square:getZ()) then
        return
    end

    if isAdmin() or not SafehouseController.IsPlayerAllowedBySquare(player, square) then
        context:addOption(getText("Destroy Land Claim"), safehouse, destroyClaim, square, player);
    end
end

Events.OnFillWorldObjectContextMenu.Add(DestroyClaimContextMenu)