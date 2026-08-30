-- ************************************************************************
-- **        ██████  ██████   █████  ██    ██ ███████ ███    ██          **
-- **        ██   ██ ██   ██ ██   ██ ██    ██ ██      ████   ██          **
-- **        ██████  ██████  ███████ ██    ██ █████   ██ ██  ██          **
-- **        ██   ██ ██   ██ ██   ██  ██  ██  ██      ██  ██ ██          **
-- **        ██████  ██   ██ ██   ██   ████   ███████ ██   ████          **
-- ************************************************************************
-- ** All rights reserved. This content is protected by © Copyright law. **
-- ************************************************************************

BB_SecureAccess_Utils = {}

BB_SecureAccess_Utils.TryPlaySoundClip = function(obj, soundName, override)
    soundName = soundName or ""
	if not override and obj:getEmitter():isPlaying(soundName) then return end
    obj:getEmitter():playSoundImpl(soundName, IsoObject.new())
end

BB_SecureAccess_Utils.GetGameSpeed = function()
    if getWorld():getGameMode() == "Multiplayer" then return 1 end
    local speedControl = UIManager.getSpeedControls():getCurrentGameSpeed()
    local gameSpeed = 1

    if speedControl == 2 then
        gameSpeed = 5
    elseif speedControl == 3 then
        gameSpeed = 20
    elseif speedControl == 4 then
        gameSpeed = 40
    end

    return gameSpeed
end

BB_SecureAccess_Utils.DelayFunction = function(func, delay, adaptToSpeed)

    delay = delay or 1
    local multiplier = 1
    local ticks = 0
    local canceled = false
    local tickRate = 60
    local lastTickTime = os.time()

    local function onTick()
        local currentTime = os.time()
        local deltaTime = currentTime - lastTickTime
        lastTickTime = currentTime

        if adaptToSpeed then multiplier = BB_SecureAccess_Utils.GetGameSpeed() end
        if not canceled and ticks < delay then
            ticks = (ticks + multiplier) + deltaTime * tickRate
            return
        end

        Events.OnTick.Remove(onTick)
        if not canceled then func() end
    end

    Events.OnTick.Add(onTick)
    return function()
        canceled = true
    end
end

BB_SecureAccess_Utils.DistanceBetween = function(firstObj, secondObj)
    local x1, y1, z1 = firstObj:getX(), firstObj:getY(), firstObj:getZ()
    local x2, y2, z2 = secondObj:getX(), secondObj:getY(), secondObj:getZ()

    local dx = x1 - x2
    local dy = y1 - y2
    local dz = z1 - z2

    if dz >= 2 then
        return 999
    end

    local distance = math.sqrt(dx * dx + dy * dy)
    return distance
end