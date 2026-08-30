
--requires 'probably' being called after metazoneHandler.lua doMapZones

function doNoShoreZones()
    if Moats and Moats.Verbose then print('doNoShoreZones') end
    if not SandboxVars.Moats or SandboxVars.Moats.RemoveShores then
        local repos = ModData.getOrCreate(Moats.NoShoreLoadKey)
        if not repos then return end
        for x,yTab in pairs(repos) do
            for y,isNoShoreZone in pairs(yTab) do
                if isNoShoreZone then
                    if Moats and Moats.Verbose then print('doNoShoreZone '..x..' '..y) end
                    getWorld():registerWaterZone(x-1, y-1, x+1, y+1, 0.0, 0.0)
                end
            end
        end
    end
end

-- loads solo/host: OK.
-- loads server side: maybe useless.
-- loads client: NO. because ModData.getOrCreate(Moats.NoShoreLoadKey) is empty at this event time.
-- for client doNoShoreZones is called in CNoShoreLoad instead.
Events.OnLoadMapZones.Add(doNoShoreZones);
