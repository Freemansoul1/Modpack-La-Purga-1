LightSensorsModData = {}

function InitLightSensorsModData(isNewGame)

    local modData = ModData.getOrCreate("LightSensors")

    if isClient() then
        ModData.request("LightSensors")
    end

    if not modData.LightSensors then modData.LightSensors = {} end
    if not modData.NetworkPlayers then modData.NetworkPlayers = {} end

    LightSensorsModData = modData
end

function LoadLightSensorsModData(key, modData)
    if isClient() then
        if key and key == "LightSensors" and modData then
            LightSensorsModData = modData
        end
    end
end

function GetLightSensorsModData()
    return LightSensorsModData
end

function TransmitLightSensorsModData()
    ModData.transmit("LightSensors")
end

print ("-------------------------------")
print ("- light sensors gmd loaded    -")
print ("-------------------------------")


Events.OnInitGlobalModData.Add(InitLightSensorsModData)
Events.OnReceiveGlobalModData.Add(LoadLightSensorsModData)
