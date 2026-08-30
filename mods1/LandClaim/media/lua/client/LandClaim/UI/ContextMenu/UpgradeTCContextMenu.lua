--fears_storage_tiles_8
--Moveables.fears_storage_tiles_8
--Rename Airdrop Crate

local SafehouseController = require "LandClaim/SafehouseController"

local function upgradeSafehouse(safehouse, player)
    SafehouseController.UpgradeSafehouse(safehouse, player)
end

local function downgradeSafehouse(safehouse, player)
    SafehouseController.DowngradeSafehouse(safehouse, player)
end

local function HighlightSafehouseContextMenu(playerIndex, context, worldObjects, test)
	local player = getSpecificPlayer(playerIndex)
    local inventory = player:getInventory()
    local target
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

    if SafehouseController.IsPlayerAllowedBySquare(player, square) then
        if safehouseData.Level == LandClaimConfig.MinimumSafehouseLevel then
            if SafehouseController.CanUpgrade(square, safehouseData, player) then
                context:addOption(getText("Upgrade Safehouse"), safehouse, upgradeSafehouse, player);
            end
        elseif safehouseData.Level == LandClaimConfig.MaximumSafehouseLevel then
            context:addOption(getText("Downgrade Safehouse"), safehouse, downgradeSafehouse, player);
        else
            if SafehouseController.CanUpgrade(square, safehouseData, player) then
                context:addOption(getText("Upgrade Safehouse"), safehouse, upgradeSafehouse, player);
            end
            context:addOption(getText("Downgrade Safehouse"), safehouse, downgradeSafehouse, player);
        end
        
    end
end

Events.OnFillWorldObjectContextMenu.Add(HighlightSafehouseContextMenu)