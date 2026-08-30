require "ISSafetyUI"

function isUserInWhitelist1()
    local whitelist = SandboxVars.Roleplay.Whitelist1 or ""
    local usernames = {}
    for username in whitelist:gmatch("[^,]+") do
        table.insert(usernames, username:lower())
    end
    local usernameCheck = getPlayer():getUsername()
    local lowerUsernameToCheck = usernameCheck:lower()
    for i, username in ipairs(usernames) do
        if username == lowerUsernameToCheck then
            return true
        end
    end

    return false
end



ISSafetyUI.initUI = function()
    if not isClient() then return end
    Events.OnKeyPressed.Add(ISSafetyUI.onKeyPressed);
end

function ISSafetyUI:prerender()
    -- Verificar si el jugador está en la whitelist
    local safetyEnabled = isUserInWhitelist1()
    local isNonPvpZone = NonPvpZone.getNonPvpZone(self.character:getX(), self.character:getY())
    local playerSafety = getSpecificPlayer(0):getSafety()

    -- Ocultar el icono de seguridad por defecto
    self.radialIcon:setVisible(false)
    self.drawLock = false


    -- Si el jugador está en la whitelist, mostrar el icono de seguridad activada
    if safetyEnabled and playerSafety:isEnabled() then
        self.radialIcon:setVisible(true)
        self.radialIcon:setTexture(self.onTexture)  -- Usar la textura de seguridad activada
        self:drawTexture(self.onTexture, 0, 0, 1, 1, 1, 1)  -- Dibujar el icono de seguridad activada
    else
        -- Si no está en la whitelist, ocultar el icono de seguridad
        self.radialIcon:setVisible(false)
    end

    if not safetyEnabled and playerSafety:isEnabled() then
        if getPlayerSafetyUI(0) then
            getPlayerSafetyUI(0):toggleSafety()
        end  -- Activar la seguridad si no está ya activada
    end

    if safetyEnabled and not playerSafety:isEnabled() then
        if getPlayerSafetyUI(0) then
            getPlayerSafetyUI(0):toggleSafety()
        end  -- Activar la seguridad si no está ya activada
    end
    -- Si el jugador está en una zona no PvP y no está en la whitelist
    if isNonPvpZone and not safetyEnabled then
        -- Mostrar el icono de deshabilitado si el jugador no está en la whitelist y está en zona No PvP
        self:drawTexture(self.disableTexture, 0, 0, 1, 1, 1, 1)
        self.radialIcon:setVisible(false)

        if self:isMouseOver() then
            self:drawText(getText("IGUI_PvpZone_NonPvpZone"), self.width + 10, self.height / 2, 1, 0, 0, 1, self.Small)
        end
    end
end

ISSafetyUI.onKeyPressed = function(key)
    --[[if key == getCore():getKey("Toggle Safety") and isUserInWhitelist1() then
        local playerSafety = getPlayer():getSafety()
        if isUserInWhitelist1() then
            -- Forzar la activación del sistema de seguridad para el jugador en la lista blanca
            if getPlayerSafetyUI(0) then
                getPlayerSafetyUI(0):toggleSafety()
            end  -- Activar la seguridad si no está ya activada
        end
    end]]
end
function ISSafetyUI:onMouseUp(x, y)

end

Events.OnGameStart.Add(ISSafetyUI.initUI);

if not isClient() then
    Events.OnKeyPressed.Add(
        function(key)
            if key == getCore():getKey("Toggle Safety") then
                IsoPlayer.setCoopPVP(not IsoPlayer.getCoopPVP())
            end
        end
    )
end

Events.OnWeaponHitCharacter.Add(function (attackedBy, target, handWeapon, damage)
    if target:isZombie() then return end
    if attackedBy:getSafety():isEnabled() or target:getSafety():isEnabled() then
        attackedBy:setLastHitCount(attackedBy:getLastHitCount() - 1)
        target:setAvoidDamage(true)
    end
end)

