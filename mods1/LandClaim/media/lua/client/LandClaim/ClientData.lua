local SafehouseController = require "LandClaim/SafehouseController"

local KEY_LAND_CLAIM_SAFEHOUSES = "LAND-CLAIM-SAFEHOUSES"

ClientData = ClientData or {}

ClientData.RequestData = function()
    ModData.request(KEY_LAND_CLAIM_SAFEHOUSES)
end

Events.OnInitGlobalModData.Add(ClientData.RequestData)

ClientData.OnReceiveGlobalModData = function(key, modData)
    if key == KEY_LAND_CLAIM_SAFEHOUSES then
        ModData.add(key, modData)
        triggerEvent("LC_ClientData_OnReceiveGlobalModData_Update")
    end
end

Events.OnReceiveGlobalModData.Add(ClientData.OnReceiveGlobalModData)

ClientData.GetLandClaimSafehouses = function()
    return ModData.getOrCreate(KEY_LAND_CLAIM_SAFEHOUSES)
end