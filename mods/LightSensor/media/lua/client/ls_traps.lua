--
-- ********************************
-- ***    Sensors and Traps     ***
-- ********************************
-- ***     Coded by: Slayer     ***
-- ********************************
--

LSTraps = LSTraps or {}

function LSTraps.PerformTrap(square, vsensor)
    local world = getWorld()
    local cell = getCell()
    local handweapon = InventoryItemFactory.CreateItem("Base.Axe")

    if vsensor.arm == "SensorsTraps.LSTrapShock" then
        -- print ("LSTrapShock!")

        local characters = cell:getObjectList()
        for i=0, characters:size()-1 do
            local chr = characters:get(i)

            if instanceof(chr, "IsoGameCharacter") then
                local dist = math.sqrt(math.pow(vsensor.x - chr:getX(), 2) + math.pow(vsensor.y - chr:getY(), 2))
                
                if vsensor.val > dist then
                    if instanceof(chr, "IsoPlayer") and not chr:isSneaking() then
                        
                        local rnd = ZombRand(3)
                        if rnd == 0 then
                            chr:setKnockedDown(true)
                        elseif rnd == 1 then
                            chr:clearVariable("BumpFallType")
                            chr:setBumpType("stagger")
                            chr:setBumpFall(true)
                            chr:setBumpFallType("pushedFront")
                        else
                            chr:clearVariable("BumpFallType")
                            chr:setBumpType("stagger")
                            chr:setBumpFall(true)
                            chr:setBumpFallType("pushedBehind")
                        end

                    elseif instanceof(chr, "IsoZombie") and not chr:isCrawling() then
                        -- cell:getGridSquare(chr:getX(), chr:getY(), chr:getZ()):explode()
                        -- chr:startMuzzleFlash()
                        chr:knockDown(true)

                        local rnd = ZombRand(3)
                        if rnd == 1 then 
                            chr:setBecomeCrawler(true)
                            chr:setCrawler(true) 
                        end

                    end

                    if isClient() then
                        local args = {x=chr:getX(), y=chr:getY(), z=chr:getZ()}
                        sendClientCommand('object', 'addSmokeOnSquare', args)
                    else
                        IsoFireManager.StartSmoke(cell, square, true, 200, 3000)
                    end

                    local emitter = world:getFreeEmitter(chr:getX(), chr:getY(), chr:getZ())
                    local snd = "TrapElectro" .. tostring(1 + ZombRand(3))
                    emitter:playSound(snd)
                    emitter:setVolumeAll(0.6)

                end
            end
        end

    elseif vsensor.arm == "SensorsTraps.LSTrapNails" then
        -- print ("LSTrapNails!")

        if isClient() then
            local args = {x=vsensor.x, y=vsensor.y, z=vsensor.z}
            sendClientCommand('object', 'addSmokeOnSquare', args)
        else
            IsoFireManager.StartSmoke(cell, square, true, 200, 3000)
        end

        local emitter = world:getFreeEmitter(vsensor.x, vsensor.y, vsensor.z)
        local snd = "TrapGlass1"
        emitter:playSound(snd)
        emitter:setVolumeAll(0.5)
        
        local characters = cell:getObjectList()
        for i=0, characters:size()-1 do
            local chr = characters:get(i)

            if instanceof(chr, "IsoGameCharacter") then

                LSUtils.PlaceBlood(chr:getX(), chr:getY(), chr:getZ(), ZombRand(10))

                if instanceof(chr, "IsoPlayer") and not chr:isSneaking() then
                    local bodyParts = {
                        BodyPartType.UpperArm_L,
                        BodyPartType.UpperArm_R,
                        BodyPartType.ForeArm_L,
                        BodyPartType.ForeArm_R,
                        BodyPartType.LowerLeg_L,
                        BodyPartType.LowerLeg_R,
                        BodyPartType.UpperArm_L,
                        BodyPartType.UpperArm_R,
                    }
                
                    for i=0, ZombRand(4) do
                        local bodyPart = chr:getBodyDamage():getBodyPart(bodyParts[1 + ZombRand(8)])
                        bodyPart:setAdditionalPain(40)
                        bodyPart:setDeepWounded(true)
                    end

                elseif instanceof(chr, "IsoZombie") then
                    local rnd = ZombRand(10)
                    if rnd == 1 then
                        chr:setKnockedDown(true)
                    else
                        chr:Kill(chr, true)
                        chr:die()
                    end
                end

                sendClientCommand(getPlayer(), 'Commands', 'RemoveSensor', vsensor)
            end
        end

    elseif vsensor.arm == "SensorsTraps.LSTrapBrokenGlass" then
        -- print ("LSTrapBrokenGlass!")

        if isClient() then
            local args = {x=vsensor.x, y=vsensor.y, z=vsensor.z}
            sendClientCommand('object', 'addSmokeOnSquare', args)
        else
            IsoFireManager.StartSmoke(cell, square, true, 200, 3000)
        end

        local emitter = world:getFreeEmitter(vsensor.x, vsensor.y, vsensor.z)
        local snd = "TrapGlass1"
        emitter:playSound(snd)
        emitter:setVolumeAll(0.5)

        local characters = cell:getObjectList()
        for i=0, characters:size()-1 do
            local chr = characters:get(i)

            if instanceof(chr, "IsoGameCharacter") then

                LSUtils.PlaceBlood(chr:getX(), chr:getY(), chr:getZ(), ZombRand(10))

                if instanceof(chr, "IsoPlayer") and not chr:isSneaking() then
                    local bodyParts = {
                        BodyPartType.UpperArm_L,
                        BodyPartType.UpperArm_R,
                        BodyPartType.ForeArm_L,
                        BodyPartType.ForeArm_R,
                        BodyPartType.LowerLeg_L,
                        BodyPartType.LowerLeg_R,
                        BodyPartType.UpperArm_L,
                        BodyPartType.UpperArm_R,
                    }
                
                    for i=0, ZombRand(4) do
                        local bodyPart = chr:getBodyDamage():getBodyPart(bodyParts[1 + ZombRand(8)])
                        bodyPart:setAdditionalPain(10)
                        bodyPart:setDeepWounded(true)
                        bodyPart:setHaveGlass(true)
                    end

                elseif instanceof(chr, "IsoZombie") then
                    local rnd = ZombRand(10)
                    if rnd == 1 then
                        chr:setKnockedDown(true)
                    else
                        chr:Kill(chr, true)
                        chr:die()
                    end
                end

                sendClientCommand(getPlayer(), 'Commands', 'RemoveSensor', vsensor)
            end
        end
    else
        print ("Unknown trap!")
    end
end
