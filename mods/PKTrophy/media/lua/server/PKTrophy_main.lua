local function OnCharacterDeath(player)
    if not instanceof(player, "IsoPlayer") or not player:isLocalPlayer() then
        return;
    end

    local title = "Trophy"

    local usernameTitle = nil
    local fullnameTitle = nil

    if SandboxVars.PKTrophy.Username then
        title = title .. " - " .. player:getUsername()
    end

    if SandboxVars.PKTrophy.FullName then
        title = title .. " - " .. player:getFullName()
    end

    local item = player:getInventory():AddItem("Base.PKTrophy");
    item:setName(title)
end

Events.OnCharacterDeath.Add(OnCharacterDeath)
