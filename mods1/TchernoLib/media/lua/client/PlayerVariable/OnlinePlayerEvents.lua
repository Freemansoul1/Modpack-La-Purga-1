
require 'PlayerVariable/PlayerVariableShared'
PlaVar.onlinePlayers = {}

function PlaVar.surveyPlayers()
    local onlinePlayers = getOnlinePlayers()
    local newOnlinePlayers = {}
    if onlinePlayers then
        for i=0, onlinePlayers:size()-1 do
            local isoPlayer = onlinePlayers:get(i)
            if isoPlayer and not isoPlayer:isLocalPlayer() then
                newOnlinePlayers[i] = isoPlayer
                local op = PlaVar.onlinePlayers[i]
                if isoPlayer ~= op then
                    if PlaVar.Verbose then print("PlaVar.surveyPlayers update "..p2str(isoPlayer)) end
                    triggerEvent("OnOtherPlayerDetected",isoPlayer)
                end
            else
                newOnlinePlayers[i] = nil
                --if PlaVar.Verbose then print("PlaVar.updateOnlinePlayers nop "..p2str(isoPlayer)) end
            end
        end
    end
    
    PlaVar.onlinePlayers = newOnlinePlayers
end

--- install callbacks
if isClient() then
--all connections except those before we arrived are associated to OnMiniScoreboardUpdate trigger: awesome !
Events.OnMiniScoreboardUpdate.Add(PlaVar.surveyPlayers)
end
