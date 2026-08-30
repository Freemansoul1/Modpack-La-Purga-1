--
-- ********************************
-- ***    Sensors and Traps     ***
-- ********************************
-- ***     Coded by: Slayer     ***
-- ********************************
--

LSTiggers = LSTiggers or {}

local tick1 = 0
local tick2 = 0
local tick3 = 0

function LSTiggers.OnZombieUpdate(character)
    tick1 = tick1 + 1
    if tick1 < 8 then return end
    tick1 = 0

    local allowedTypes = {}
    allowedTypes.ZOMBIE = true
    LSTiggers.CheckSensors(allowedTypes, character)
end

function LSTiggers.OnPlayerUpdate(character)
    tick2 = tick2 + 1
    if tick2 < 16 then return end
    tick2 = 0

    entry = {}
    entry.id = character:getOnlineID()
    entry.x = math.floor(character:getX())
    entry.y = math.floor(character:getY())
    entry.z = character:getZ()
    sendClientCommand(character, 'Commands', 'UpdatePlayer', entry)

    local allowedTypes = {}
    allowedTypes.PROXY = true
    allowedTypes.ROOM = true
    LSTiggers.CheckSensors(allowedTypes, character)
end

function LSTiggers.OnPlayerMove(character)

    tick3 = tick3 + 1
    if tick3 < 16 then return end
    tick3 = 0

end

function LSTiggers.EveryOneMinute()
    local allowedTypes = {}
    allowedTypes.LIGHT = true
    allowedTypes.TEMP = true
    allowedTypes.RAIN = true
    allowedTypes.POWER = true

    LSTiggers.CheckSensors(allowedTypes, nil)
end

function LSTiggers.CheckSensors(allowedTypes, character)
    local world = getWorld()
    local cell = getCell()
    local cm = world:getClimateManager()
    local dls = cm:getDayLightStrength()

    local globalModData = GetLightSensorsModData()

    for k, vsensor in pairs(globalModData.LightSensors) do
        if allowedTypes[vsensor.type] then
            local x, y, z = LSUtils.Id2Coords(k)
            local square = cell:getGridSquare(x, y, z)

            if square then
                
                -- CHECK IF OBJECT IS STILL THERE
                local objectPresent = false
                local objects = square:getObjects()
                for i=0, objects:size()-1 do
                    local object = objects:get(i)
                    if LSUtils.CanHaveSensor(object) then 
                        objectPresent = true
                        break
                    end
                end

                if objectPresent then

                    -- SENSOR MUST BE POWERED
                    if world:isHydroPowerOn() or square:haveElectricity() or (vsensor.battery and vsensor.battery > 0) then

                        -- DETECT SENSOR STATE DEPENDING ON SENSOR TYPE
                        local action = true
                        local state = false
                        if vsensor.type == "PROXY" then
                            state = false
                            for _, player in pairs(globalModData.NetworkPlayers) do
                                local dist = math.sqrt(math.pow(vsensor.x - player.x, 2) + math.pow(vsensor.y - player.y, 2))
                                if vsensor.val > dist then
                                    state = true
                                    break
                                end
                            end
                        
                        elseif vsensor.type == "ZOMBIE" and character and character:isAlive() and not character:isCrawling() then 
                            local dist = character:DistTo(vsensor.x, vsensor.y)
                            if vsensor.val > dist then
                                state = true
                            end
                            -- print ("ID: " .. k .. "DIST: " .. dist .. " VAL: " .. vsensor.val)

                        elseif vsensor.type == "ROOM" and character and character:isAlive() then
                            state = false
                            local room = square:getRoom()
                            if room then
                                for _, player in pairs(globalModData.NetworkPlayers) do
                                    if room:isInside(player.x, player.y, player.z) then
                                        state = true
                                        break
                                    end
                                end
                            end

                        elseif vsensor.type == "LIGHT" then
                            if vsensor.val > dls then
                                state = true
                            end

                        elseif vsensor.type == "TEMP" then
                            local temp = cm:getAirTemperatureForSquare(square)
                            if vsensor.val > temp then
                                state = true
                            end

                            -- print ("T: " .. temp .. " VAL: " .. vsensor.val)
                        elseif vsensor.type == "RAIN" then
                            local ri = cm:getRainIntensity()
                            if vsensor.val > ri then
                                state = true
                            end

                            -- print ("RI: " .. ri .. " VAL: " .. vsensor.val)
                        elseif vsensor.type == "POWER" then
                            local power = square:haveElectricity() or world:isHydroPowerOn()
                            if power then
                                state = true
                            end

                            -- print ("POWER: " .. tostring(power))
                        else
                            action = false
                        end

                        if vsensor.inv then state = not state end
                        if vsensor.positive and state == false then action = false end

                        if action then 
                            LSActions.PerformAction(square, state, vsensor)

                            if state and vsensor.alarm then
                                LSActions.SoundAlarm(square, vsensor)
                            end

                            if state and vsensor.arm then
                                LSTraps.PerformTrap(square, vsensor)
                            end

                        end
                    end
                else
                    sendClientCommand(getPlayer(), 'Commands', 'RemoveSensor', vsensor)
                    break
                end
            end
        end
    end
end

-- Events.OnPreFillInventoryObjectContextMenu.Add(LSInventoryObjectContextMenuPre)
Events.EveryOneMinute.Add(LSTiggers.EveryOneMinute)
-- Events.OnPlayerMove.Add(LSOnPlayerMove)
Events.OnPlayerUpdate.Add(LSTiggers.OnPlayerUpdate)
Events.OnZombieUpdate.Add(LSTiggers.OnZombieUpdate)
