-- Thanks Valrix for this function!
if DistributeTo == nil then
    DistributeTo = function(_table, item, chance)
        local n = #_table+1
        _table[n] = item
        _table[n+1] = chance
    end
end

DistributeTo(VehicleDistributions.PoliceTruckBed.items, "Braven.SpikeStrip", 0.1)