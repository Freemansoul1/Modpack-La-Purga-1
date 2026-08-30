local function UpdateSafehouses()
	local safehouseData = ClientData.GetLandClaimSafehouses()

    local idsToDelete = {}
    local hasLandClaim = false
    for id, data in pairs(safehouseData) do
        hasLandClaim = false
        local sq = getCell():getGridSquare(data.Center.X,data.Center.Y, data.Center.Z)
        if sq then
            local squareObjects = sq:getObjects();
            for i = 0, squareObjects:size() - 1 do
                local sqObj = squareObjects:get(i)
                local sprite = sqObj:getSprite()
                if not hasLandClaim and sprite:getName() == LandClaimConfig.LCItemType then
                    hasLandClaim = true
                    break
                end
            end

            if not hasLandClaim then
                table.insert(idsToDelete, id)
            end
        end
    end

    for _, v in ipairs(idsToDelete) do
        sendClientCommand("LandClaim_Server", "DeleteSafehouse", {safehouseId = v})
    end

end

Events.EveryTenMinutes.Add(UpdateSafehouses)