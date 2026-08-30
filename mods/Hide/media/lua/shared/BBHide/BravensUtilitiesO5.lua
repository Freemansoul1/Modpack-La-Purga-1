-- **************************************************
-- ██████  ██████   █████  ██    ██ ███████ ███    ██ 
-- ██   ██ ██   ██ ██   ██ ██    ██ ██      ████   ██ 
-- ██████  ██████  ███████ ██    ██ █████   ██ ██  ██ 
-- ██   ██ ██   ██ ██   ██  ██  ██  ██      ██  ██ ██ 
-- ██████  ██   ██ ██   ██   ████   ███████ ██   ████
-- **************************************************
-- ** Seek Excellence! Employ ME, not my Copycats. **
-- **************************************************

BravensUtilsO5 = {}

BravensUtilsO5.TryPlaySoundClip = function(obj, soundName)
	if obj:getEmitter():isPlaying(soundName) then return end
    obj:getEmitter():playSoundImpl(soundName, IsoObject.new())
end

BravensUtilsO5.TryStopSoundClip = function(obj, soundName)
	if not obj:getEmitter():isPlaying(soundName) then return end
	obj:getEmitter():stopSoundByName(soundName)
end

BravensUtilsO5.TirePlayer = function(playerObj, amount)

	local stats = playerObj:getStats()
	if not stats then return end

	if stats:getEndurance() < 0.21 then return end --We don't want to *kill* someone out of exhaustion do we?
	stats:setEndurance(stats:getEndurance() - (amount / (playerObj:getPerkLevel(Perks.Fitness) / 2)))
end

-- Credits for this function: Konijima
BravensUtilsO5.DelayFunction = function(func, delay)

    delay = delay or 1
    local ticks = 0
    local canceled = false

    local function onTick()

        if not canceled and ticks < delay then
            ticks = ticks + 1
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