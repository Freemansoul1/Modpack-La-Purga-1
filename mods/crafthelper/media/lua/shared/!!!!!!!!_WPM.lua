if isClient() then return end

local wpm = require("WPM_Main")

Events.OnTick.Add(function ()
    if SandboxVars.WastelandPerformanceMonitor.Enabled then
        wpm:OnTickStart()
    end
end)

Events.EveryOneMinute.Add(function ()
    if SandboxVars.WastelandPerformanceMonitor.Enabled then
        wpm:EveryOneMinuteStart()
    end
end)

Events.EveryTenMinutes.Add(function ()
    if SandboxVars.WastelandPerformanceMonitor.Enabled then
        wpm:EveryTenMinutesStart()
    end
end)