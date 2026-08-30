-- SZ_ImprovedMeleeCombatServer.lua

if not isServer() then return end

-- FIXME: Remove
-- local function getZombie(player, id)
--     local isoZombies = player:getCell():getZombieList()
--     DebugLog.log(DebugType.Mod, "stickIntoZombieServer: getZombie() id: " .. tostring(id) .. " zombies found:" .. tostring(isoZombies:size()))
--     for i=0, isoZombies:size()-1 do
--         local isoZombie = isoZombies:get(i)
--         DebugLog.log(DebugType.Mod, "stickIntoZombieServer: getZombie(): zombies id:" .. tostring(isoZombie:getOnlineID()))
--         if isoZombie:getOnlineID() == id then 
--             return isoZombie 
--         end
--     end
--     return nil
-- end

local function stickIntoZombieServer(args)
    -- Pass the info about the zombie back to all clients
    sendServerCommand("SZ_IMC_Server", "stickIntoZombieFromServer", args)
end

local function OnClientCommand(moduleName, command, player, args)
    DebugLog.log(DebugType.Mod, "SZ_IMC client module: " .. moduleName .. " command: " .. command)
    if moduleName == "SZ_IMC_Client" then
        if command == "stickIntoZombie" then
            stickIntoZombieServer(args)
            return
        end
    end
end

Events.OnClientCommand.Add(OnClientCommand)