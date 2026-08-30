local KEY_LAND_CLAIM_SAFEHOUSES = "LAND-CLAIM-SAFEHOUSES"

ServerData = ServerData or {}
ServerData.Data = ServerData.Data or {}

ServerData.GlobalModDataInit = function()
    ModData.getOrCreate(KEY_LAND_CLAIM_SAFEHOUSES)
end

Events.OnInitGlobalModData.Add(ServerData.GlobalModDataInit)

ServerData.ClearAllData = function(state)
    ModData.remove(KEY_LAND_CLAIM_SAFEHOUSES)
    ServerData.GlobalModDataInit(state)
    ModData.transmit(KEY_LAND_CLAIM_SAFEHOUSES)
end

ServerData.GetLandClaimSafehouses = function()
    return ModData.getOrCreate(KEY_LAND_CLAIM_SAFEHOUSES)
end

ServerData.SetLandClaimSafehouses = function(data)
    ModData.add(KEY_LAND_CLAIM_SAFEHOUSES, data)
    ModData.transmit(KEY_LAND_CLAIM_SAFEHOUSES)
end