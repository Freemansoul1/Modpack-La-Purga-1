--
-- ********************************
-- ***    Sensors and Traps     ***
-- ********************************
-- ***     Coded by: Slayer     ***
-- ********************************
--

LSClient = {}
LSClient.Commands = {}

LSClient.Commands.WakeUp = function(args)
    print ("wakeup command")
    local player = getPlayer()
    local dist = player:DistTo(args.x, args.y)
    if dist < 40 then
        print ("WAKE UP!")
        player:forceAwake()
    end
end

local onLightSensorsServerCommand = function(module, command, args)
    if LSClient[module] and LSClient[module][command] then
        local argStr = ""
        for k, v in pairs(args) do
            argStr = argStr .. " " .. k .. "=" .. tostring(v)
        end
        -- print ("client received " .. module .. "." .. command .. " "  .. argStr)
        LSClient[module][command](args)
    end
end

Events.OnServerCommand.Add(onLightSensorsServerCommand)

--

