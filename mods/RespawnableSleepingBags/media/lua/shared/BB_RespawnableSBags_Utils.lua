-- ************************************************************************
-- **        ██████  ██████   █████  ██    ██ ███████ ███    ██          **
-- **        ██   ██ ██   ██ ██   ██ ██    ██ ██      ████   ██          **
-- **        ██████  ██████  ███████ ██    ██ █████   ██ ██  ██          **
-- **        ██   ██ ██   ██ ██   ██  ██  ██  ██      ██  ██ ██          **
-- **        ██████  ██   ██ ██   ██   ████   ███████ ██   ████          **
-- ************************************************************************
-- ** All rights reserved. This content is protected by © Copyright law. **
-- ************************************************************************

BB_RSBags_Utils = {}

BB_RSBags_Utils.TeleportTo = function(playerObj, coordsX, coordsY, coordsZ)
    playerObj:setX(coordsX)
    playerObj:setY(coordsY)
    playerObj:setZ(coordsZ)

    playerObj:setLx(coordsX)
    playerObj:setLy(coordsY)
    playerObj:setLz(coordsZ)
end

BB_RSBags_Utils.DelayFunction = function(func, delay)

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