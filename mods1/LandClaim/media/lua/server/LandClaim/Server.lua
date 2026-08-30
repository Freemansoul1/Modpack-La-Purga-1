--[[
if not isServer() then return end

local tries = 0
local function read()
    local ReadKey = getFileReader("key.txt",true)
    local key = ReadKey:readLine()
    
    if key ~= 'valid' then
        tries = tries + 1
    else
       tries = 0
       LandClaimConfig.Validated = true 
       Events.EveryOneMinute.Remove(read)
       return
    end

    if tries > 10 then
        LandClaimConfig.Validated = false
    end

    ReadKey:close()
end

Events.EveryOneMinute.Add(read)
--]]