if isClient() then return end

WVD = {}

function WVD.UpdateSandbox(sandbox, option, daylength)
    option:setValue(daylength)
    sandbox:applySettings()
    sandbox:toLua()
    sandbox:saveServerLuaFile(getServerName())
    sendServerCommand("WVD", "setDayLength", {daylength})
end

function WVD.SetDaylengthSpeed()
    local sandboxOptions = getSandboxOptions()
    local gameTime = getGameTime()
    local option = sandboxOptions:getOptionByName("DayLength")
    local currentDayLength = option:getValue()
    local dayTimeStartHour = SandboxVars.WastelandVariableDays.DaytimeStart
    local nightTimeStartHour = SandboxVars.WastelandVariableDays.NighttimeStart
    local dayTimeValue = SandboxVars.WastelandVariableDays.DayLength
    local nightTimeValue = SandboxVars.WastelandVariableDays.NightLength
    local currentHour = gameTime:getHour()

    if currentHour < dayTimeStartHour or currentHour >= nightTimeStartHour then
        if currentDayLength ~= nightTimeValue then
            WVD.UpdateSandbox(sandboxOptions, option, nightTimeValue)
        end
    else
        if currentDayLength ~= dayTimeValue then
            WVD.UpdateSandbox(sandboxOptions, option, dayTimeValue)
        end
    end
end

Events.EveryHours.Add(WVD.SetDaylengthSpeed)
Events.OnGameStart.Add(WVD.SetDaylengthSpeed)