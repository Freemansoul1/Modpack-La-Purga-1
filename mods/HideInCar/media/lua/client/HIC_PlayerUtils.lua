setmetatable(HIC, { __index = _G })
setfenv(1, HIC) 

ZombieMemory = SandboxVars.HIC.ZombieMemory;

function EnterGhostMode(player)
    if Ghosted then return end;
    player:setGhostMode(true);
    Ghosted = true;
end

function ExitGhostMode(player)
    if not Ghosted then return end;
    player:setGhostMode(false);
    Ghosted = false;
end

function AreZombiesDetectPlayer(player)
    local playerX, playerY, playerZ = player:getX(), player:getY(), player:getZ();

    local zombies = getCell():getZombieList();
    if zombies == nil then return; end

    for i = 0, zombies:size() - 1 do
        local zombie = zombies:get(i);

        if IsZombieChasingTarget(zombie, player) then return true; end
        local zombieX, zombieY, zombieZ = zombie:getX(), zombie:getY(), zombie:getZ();

        local distance = math.sqrt((playerX - zombieX) ^ 2 + (playerY - zombieY) ^ 2);

        if distance <= Radius and playerZ == zombieZ then return true; end
    end
    return false;
end

function IsZombieChasingTarget(zombie, player)
    local chasing = false;

    if HIC.ZombieMemory == true then 
        chasing = zombie:getTarget() == player;
    else 
        chasing = zombie:getTarget() == player and zombie:isTargetVisible();
    end

    if chasing then
        HIC.OnPlayerChased(player);
        return true;
    end;
    return false;
end

function IsPlayerInCar(player)
    local vehicle = player:getVehicle()
    return vehicle ~= nil;
end