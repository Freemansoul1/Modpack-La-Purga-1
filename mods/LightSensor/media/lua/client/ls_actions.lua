--
-- ********************************
-- ***    Sensors and Traps     ***
-- ********************************
-- ***     Coded by: Slayer     ***
-- ********************************
--
LSActions = LSActions or {}
local LSEmitters = {}

function LSActions.PerformAction(square, state, vsensor)
    -- ACTIVATE / DISACTIVATE OBJECT DEPENDING ON SENSOR STATE FOR EACH OBJECT TYPE
    local energyUse = 0

    -- LAMPS AND LIGHTSWITCHES
    local lightSwitch = LSUtils.GetObjectByClass(square, "IsoLightSwitch")
    if lightSwitch then
        if lightSwitch:isActivated() ~= state then
            lightSwitch:setActive(state)
            energyUse = energyUse + 0.001
        end
    end

    -- GENERATOR
    local gen = LSUtils.GetObjectByClass(square, "IsoGenerator")
    if gen then
        if gen:isConnected() and gen:isActivated() ~= state then
            gen:setActivated(state)
            energyUse = energyUse + 0.002
        end
    end

    -- DRYER
    local cd = LSUtils.GetObjectByClass(square, "IsoClothingDryer")
    if cd then
        if cd:isActivated() ~= state then

            if getActivatedMods():contains("AirCond1") and isConnectedAC(cd) then
                ACToggle(cd, state, getPlayer())
            elseif getActivatedMods():contains("Plumbing1") and IsAttachedPump(cd) then
                if state then
                    PumpTurnOn(getPlayer(), cd, nil, nil)
                else
                    PumpTurnOff(getPlayer(), cd, nil, nil)
                end
            else
                cd:setActivated(state)
            end

            energyUse = energyUse + 0.001
        end

    end

    -- WASHER
    local cw = LSUtils.GetObjectByClass(square, "IsoClothingWasher")
    if cw then
        if cw:isActivated() ~= state then
            cw:setActivated(state)
            energyUse = energyUse + 0.001
        end
    end

    -- WASHER/DRYER
    local cwd = LSUtils.GetObjectByClass(square, "IsoCombinationWasherDryer")
    if cwd then
        if cwd:isActivated() ~= state then
            cwd:setActivated(state)
            energyUse = energyUse + 0.001
        end
    end

    -- STACKED WASHER/DRYER
    local swd = LSUtils.GetObjectByClass(square, "IsoStackedWasherDryer")
    if swd then
        if swd:isWasherActivated() ~= state then
            swd:setWasherActivated(state)
            energyUse = energyUse + 0.001
        end
    end

    -- TV
    local tv = LSUtils.GetObjectByClass(square, "IsoTelevision")
    if tv then
        if tv:getIsTurnedOn() ~= state then
            tv:getDeviceData():setIsTurnedOn(state)
            energyUse = energyUse + 0.001
        end
    end

    -- RADIO
    local radio = LSUtils.GetObjectByClass(square, "IsoRadio")
    if radio then
        if radio:getIsTurnedOn() ~= state then
            radio:getDeviceData():setIsTurnedOn(state)
            energyUse = energyUse + 0.001
        end
    end

    -- STOVE
    local stove = LSUtils.GetObjectByClass(square, "IsoStove")
    if stove then
        if stove:Activated() then
            stove:setActivated(state)
            energyUse = energyUse + 0.001
        end
    end

    -- DOORS
    local door = LSUtils.GetDoor(square)
    if door and not door:isLocked() and not door:isLockedByKey() and not door:isObstructed() then
        -- print ("ISOPEN: " .. tostring(door:IsOpen()) .. " STATE: " .. tostring(state))
        if door:IsOpen() ~= state then 
            door:ToggleDoor(getPlayer())
            -- door:ToggleDoor(nil)
            energyUse = energyUse + 0.1
        end
    end

    if energyUse and not square:haveElectricity() and vsensor.battery and vsensor.battery > 0 then
        -- print ("battery deplete trigger: " .. tostring(energyUse))
        vsensor.battery = vsensor.battery - energyUse
        if vsensor.battery < 0 then
            vsensor.battery = 0
        end
        sendClientCommand(getPlayer(), 'Commands', 'UpdateSensor', vsensor)
    end

end

function LSActions.SoundAlarm (square, vsensor)
    local world = getWorld()

    local x = vsensor.x 
    local y = vsensor.y 
    local z = vsensor.z

    local eid = LSUtils.Coords2Id (x, y, z)
    if LSEmitters[eid] then
        local emitter = LSEmitters[eid]
        if not emitter:isPlaying("SensorAlarm1") then
            LSEmitters[eid] = nil
        end
    else
        local emitter = world:getFreeEmitter(x, y, z)
        emitter:playSound("SensorAlarm1")
        emitter:setVolumeAll(0.25)
        LSEmitters[eid] = emitter
        
        local player = getPlayer()

        addSound(player, x, y, z, 40, 100)

        local energyUse = 0.02
        if energyUse and not square:haveElectricity() and vsensor.battery and vsensor.battery > 0 then
            -- print ("battery deplete alarm: " .. tostring(energyUse))
            vsensor.battery = vsensor.battery - energyUse
            if vsensor.battery < 0 then
                vsensor.battery = 0
            end
            sendClientCommand(getPlayer(), 'Commands', 'UpdateSensor', vsensor)
        end

        entry = {}
        entry.x = x
        entry.y = y
        sendClientCommand(getPlayer(), 'Broadcaster', 'WakeUp', entry)
    end
end
