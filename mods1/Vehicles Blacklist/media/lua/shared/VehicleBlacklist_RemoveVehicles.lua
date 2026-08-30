if not VehicleZoneDistribution then return end

local function removeVehicles()
    -- Fetch the list of blacklisted vehicles from sandbox settings
    local blacklistedVehiclesStr = SandboxVars.vehicleBlacklist.blacklistedVehicles or ""
    local vehiclesToRemove = {}
    for vehicle in string.gmatch(blacklistedVehiclesStr, '([^,]+)') do
        vehiclesToRemove[vehicle] = true
    end

    -- Function to remove specific vehicles from the VehicleZoneDistribution table
    for zoneType, zoneData in pairs(VehicleZoneDistribution) do
        if type(zoneData) == "table" and zoneData.vehicles then
            for vehicleType, _ in pairs(zoneData.vehicles) do
                if vehiclesToRemove[vehicleType] then
                    zoneData.vehicles[vehicleType] = nil
                end
            end
        end
    end
end

Events.OnInitGlobalModData.Add(removeVehicles)
