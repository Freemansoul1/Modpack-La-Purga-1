-- +================================================================+
-- |                                                                |
-- |                        /##         /##             /##         |
-- |                       | ##       /####            | ##         |
-- |     /#######  /#######| ####### |_  ##   /########| ##   /##   |
-- |    /##_____/ /##_____/| ##__  ##  | ##  |____ /##/| ##  /##/   |
-- |   |  ###### | ##      | ##  \ ##  | ##     /####/ | ######/    |
-- |    \____  ##| ##      | ##  | ##  | ##    /##__/  | ##_  ##    |
-- |    /#######/|  #######| ##  | ## /###### /########| ## \  ##   |
-- |   |_______/  \_______/|__/  |__/|______/|________/|__/  \__/   |
-- |                                                                |
-- +================================================================+

SForcedSync = SForcedSync or {}
SForcedSync.Client = {}

function SForcedSync.Client.OnCustomUIKey(key)
    if not SandboxVars.ForcedSync.ForceSyncOnKey then return end
    if key == getCore():getKey("Force Sync Key") then
        local playerObj = getPlayer();
        local args = { x = playerObj:getX(), y = playerObj:getY(), z = playerObj:getZ() }
        sendClientCommand(playerObj, 'playersync', 'forcesyncaround', args)
    end
end

function SForcedSync.Client.OnWeaponHitCharacter(wielder, character, handWeapon, damage)
    if not SandboxVars.ForcedSync.ForceSyncOnWeaponHitCharacter then return end
    local player = getPlayer();
    -- If another client character has been hit by anyone
    if character ~= player and instanceof(character, "IsoPlayer") then
        -- Requesting another client character position from server
        local args = { id = character:getOnlineID() }
        sendClientCommand(player, 'playersync', 'forcesyncone', args)

    -- If client character has been hit by another client character
    elseif character == player and wielder ~= player and instanceof(wielder, "IsoPlayer") then
        -- Requesting wielder client character position from server
        local args = { id = wielder:getOnlineID() }
        sendClientCommand(player, 'playersync', 'forcesyncone', args)
    end
end

function SForcedSync.Client.OnWeaponSwing(character, handWeapon)
    if not SandboxVars.ForcedSync.ForceSyncOnWeaponSwing then return end
    local player = getPlayer();
    -- If client character swing his weapon (or use firearms)
    if character == player then
        local args = { x = character:getX(), y = character:getY(), z = character:getZ() }
        -- Requesting around characters positions from server
        sendClientCommand(character, 'playersync', 'forcesyncaround', args)
    
    -- If another client character swing his weapon (or use firearms)
    elseif instanceof(character, "IsoPlayer") then
        local args = { id = character:getOnlineID() }
        sendClientCommand(player, 'playersync', 'forcesyncone', args)
    end
end

SForcedSync.Client.zombiesStorage = {}
function SForcedSync.Client.OnHitZombie(zombie, character, bodyPartType, handWeapon)
    if not SandboxVars.ForcedSync.ForceSyncOnHitZombie then return end
    local player = getPlayer();
    if character ~= player and instanceof(character, "IsoPlayer") then
        if zombie:getX() >= player:getX() - 20 and zombie:getX() < player:getX() + 20 and zombie:getY() >= player:getY() - 50 and zombie:getY() < player:getY() + 50 then
            local ts = getTimestampMs()
            SForcedSync.Client.zombiesStorage[zombie:getOnlineID()] = { ts = ts, zombie = zombie }
        end
    elseif character == player then
        local args = { zombieid = zombie:getOnlineID(), x = zombie:getX(), y = zombie:getY(), z = zombie:getZ() }
        sendClientCommand(player, 'playersync', 'sendzombiedata', args)
    end
end

function SForcedSync.Client.EveryOneMinute()
    if not SandboxVars.ForcedSync.ForceSyncOnHitZombie then return end
    for id, array in pairs(SForcedSync.Client.zombiesStorage) do
        local ts = getTimestampMs()
        if ts - array.ts > 1000 then
            SForcedSync.Client.zombiesStorage[id] = nil;
        end
    end
end

local Commands = {}
Commands.playersync = {}
Commands.playersync.forcesync = function(args)
    print("FORCED SYNC")
    local otherPlayer = getPlayerByOnlineID(args.id);
    if otherPlayer then
        otherPlayer:setX(args.x);
        otherPlayer:setY(args.y);
        otherPlayer:setZ(args.z);
    end
end

Commands.playersync.zombiesync = function(args)
    print("got zombie pos update w/id "..args.zombieid)
    if not SForcedSync.Client.zombiesStorage[args.zombieid] then return end
    local zombie = SForcedSync.Client.zombiesStorage[args.zombieid].zombie
    if zombie then
        zombie:setX(args.x);
        zombie:setY(args.y);
        zombie:setZ(args.z);
    end
end

local function OnServerCommand(module, command, args)
    if Commands[module] and Commands[module][command] then
        local argStr = ''
        for k,v in pairs(args) do argStr = argStr..' '..k..'='..tostring(v) end
        print('received '..module..' '..command..' '..argStr)
        Commands[module][command](args)
    end
end

Events.OnCustomUIKey.Add(SForcedSync.Client.OnCustomUIKey);
Events.OnWeaponHitCharacter.Add(SForcedSync.Client.OnWeaponHitCharacter)
Events.OnWeaponSwing.Add(SForcedSync.Client.OnWeaponSwing)
Events.OnHitZombie.Add(SForcedSync.Client.OnHitZombie)
Events.EveryOneMinute.Add(SForcedSync.Client.EveryOneMinute)

Events.OnServerCommand.Add(OnServerCommand)

