Events.OnServerCommand.Add(function (module, command, args)
    if module ~= "WVD" then return end
    if command == "setDayLength" then
        local sandboxOptions = getSandboxOptions()
        local option = sandboxOptions:getOptionByName("DayLength")
        local dayLength = tonumber(args[1])
        if dayLength == nil then
            print("Invalid day length!!!")
            -- should we boot the user?? probably they are going to have a desynced time
            return
        end
        option:setValue(dayLength)
        sandboxOptions:applySettings()
        sandboxOptions:toLua()
    end
end)