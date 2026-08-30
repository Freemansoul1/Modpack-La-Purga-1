require 'SharedMoats'
--- analyse global mod data
function Moats.OnReceiveGlobalModData(_module, _packet)
    if Moats.Verbose then print('Moats.OnReceiveGlobalModData '..tab2str(_module)..tab2str(_packet)) end
    if _module == Moats.NoShoreLoadKey then
        if _packet then
            if Moats.Verbose then print("Client receives Global mod data update ".._module..' '..tab2str(_packet or 'nil')) end
            ModData.add(_module, _packet)
            doNoShoreZones()--we need to call it now because the vanilla objects.lua call has already elapsed client side
        else
            if Moats.Verbose then print("Client receives Global mod data synchro "..tab2str(_module or 'nil')..' '..tab2str(_packet or 'nil')) end
        end
    end
end

function Moats.initGMD()
    if Moats.Verbose then print('Moats.initGMD '..Moats.NoShoreLoadKey) end
    ModData.request(Moats.NoShoreLoadKey);
end

if isClient() then
    Events.OnReceiveGlobalModData.Add(Moats.OnReceiveGlobalModData)
    Events.OnInitGlobalModData.Add(Moats.initGMD)
end
