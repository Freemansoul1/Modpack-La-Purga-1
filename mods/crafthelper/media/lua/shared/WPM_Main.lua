if isClient() then return end

local WPM = {}

function WPM:new()
    local o = {}
    setmetatable(o, self)
    o.__index = self
    o:Init()
    return o
end

function WPM:Init()
    self.OnTick_Start = 0
    self.EveryOneMinute_Start = 0
    self.EveryTenMinutes_Start = 0

    self.cachedTimes = {}
end

function WPM:OnTickStart()
    if self.OnTick_Start ~= 0 then
        self:OnTickEnd()
    end
    if self.EveryOneMinute_Start ~= 0 then
        self:EveryOneMinuteEnd()
    end
    if self.EveryTenMinutes_Start ~= 0 then
        self:EveryTenMinutesEnd()
    end

    self.OnTick_Start = getTimestampMs()
end

function WPM:EveryOneMinuteStart()
    self.EveryOneMinute_Start = getTimestampMs()
end

function WPM:EveryTenMinutesStart()
    self.EveryTenMinutes_Start = getTimestampMs()
end

function WPM:OnTickEnd()
    local now = getTimestampMs()
    local diff = now - self.OnTick_Start
    table.insert(self.cachedTimes, {now, "OnTick", diff})
    self.OnTick_Start = 0
end

function WPM:EveryOneMinuteEnd()
    local now = getTimestampMs()
    local diff = now - self.EveryOneMinute_Start
    table.insert(self.cachedTimes, {now, "EveryOneMinute", diff})
    self.EveryOneMinute_Start = 0
end

function WPM:EveryTenMinutesEnd()
    local now = getTimestampMs()
    local diff = now - self.EveryTenMinutes_Start
    table.insert(self.cachedTimes, {now, "EveryTenMinutes", diff})
    self.EveryTenMinutes_Start = 0
    self:WriteTimes()
end

function WPM:WriteTimes()
    local fileWriter = getFileWriter("WPM_Times.csv", true, true)
    for i, v in ipairs(self.cachedTimes) do
        fileWriter:writeln(v[1] .. "," .. v[2] .. "," .. v[3])
    end
    fileWriter:close()
    self.cachedOnTickTimes = {}
    self.cachedEveryOneMinuteTimes = {}
    self.cachedEveryTenMinutesTimes = {}
end

local wpm = WPM:new()

return wpm