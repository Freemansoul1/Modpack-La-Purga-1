-- despawnwaterzombies by jbdiablo aka jimbeamdiablo --
-- keep this out of your mod pack, mmkay?            --
-- If I find this in your mod pack, I'll be big mads --
-- just use require= in your mod.info, no big deal   --

local waterZombies = {}

waterZombies.isZombieOnWater = function()
    local zeds = getCell():getZombieList() -- get all dem zombies in the cell
    if not zeds then return end -- no zeds? I'm audi
    for i = zeds:size() - 1, 0, -1 do -- flip it and reverse it
        local currentZed = zeds:get(i) -- you, then you, then you
        local sq = getSquare(currentZed:getX(), currentZed:getY(), currentZed:getZ()) -- square dance
        if currentZed:getZ() ~= 0 then break end -- no water in the air so let's jet
        if sq:getFloor():getSprite() then -- don't fuck with zombies whose sprite isn't loaded
            if sq:getFloor():getSprite():getProperties():Is(IsoFlagType.water) then -- we got a zed, we got a floor, we got a sprite so do we got water?
                waterZombies.isDroppedItemOnWater(currentZed) -- lets check this shit first before we deep 6 the zombie
                currentZed:removeFromWorld() -- good day to you
                currentZed:removeFromSquare() -- I SAID GOOD DAY TO YOU
            end
        end
    end
end

waterZombies.isZombieOnWaterSP = function(zombie)
    local sq = getSquare(zombie:getX(), zombie:getY(), zombie:getZ()) -- nice, we already got a zombie!
    if zombie:getZ() ~= 0 then return end
    if sq:getFloor():getSprite() then
        if sq:getFloor():getSprite():getProperties():Is(IsoFlagType.water) then
            waterZombies.isDroppedItemOnWater(zombie)
            zombie:removeFromWorld()
            zombie:removeFromSquare()
        end
    end
end

waterZombies.isDeadZombieOnWater = function(zombie)
    local sq = getSquare(zombie:getX(), zombie:getY(), zombie:getZ())
    if sq:getFloor():getSprite():getProperties():Is(IsoFlagType.water) then
        waterZombies.isDroppedItemOnWater(zombie)
        sq:transmitRemoveItemFromSquare(zombie) -- trmifw? idk, as m?
        zombie:removeFromWorld() -- no soup
        zombie:removeFromSquare() -- for you
    end
end

waterZombies.isDroppedItemOnWater = function(zombie)
    -- called from isZombieOnWater & isDeadZombieOnWater
    -- check 3x3 squares around zombie for blood and items on the ground
    local cell = getCell()
    local x, y = zombie:getX(), zombie:getY()
    for xx = x - 1, x + 1, 1 do
        for yy = y - 1, y + 1, 1 do -- xx * yy makes 3x3
            local sq = cell:getGridSquare(xx, yy, 0) -- get those squares
            if sq:getFloor():getSprite():getProperties():Is(IsoFlagType.water) then
                if sq:haveBlood() then -- got blood?
                    --print("Removing blood")
                    sq:removeBlood(false, false) -- remove blood
                end
                local objects = sq:getWorldObjects() -- get all objects on the square
                if objects then -- are there any?
                    for i = objects:size() - 1, 0, -1 do -- flip it and reverse it
                        --print("Removing objects")
                        sq:removeWorldObject(objects:get(i)) -- makes sense
                    end
                end
            end
        end
    end
end

waterZombies.howOftenToCheck = function()
    local update = { "", Events.EveryOneMinute.Add, Events.EveryTenMinutes.Add, Events.EveryHours.Add, Events.EveryDays.Add } -- so we don't have to iffy
    if SandboxVars.despawnZombies.howOften == 1 then -- did you pick single player?
        Events.OnZombieUpdate.Add(waterZombies.isZombieOnWaterSP) -- just update when the zombie updates cuz it's fas like lighnin
    else
        update[SandboxVars.despawnZombies.howOften](waterZombies.isZombieOnWater) -- otherwise, choose your own adventure aka table[index](function)
    end
end

Events.OnPostMapLoad.Add(waterZombies.howOftenToCheck) -- do this after the map loads. no reason to do it before

Events.OnZombieDead.Add(waterZombies.isDeadZombieOnWater) -- zap them dead dead on the wah wah when they die die
