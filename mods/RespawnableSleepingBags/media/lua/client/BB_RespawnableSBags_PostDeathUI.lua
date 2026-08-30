-- ************************************************************************
-- **        ██████  ██████   █████  ██    ██ ███████ ███    ██          **
-- **        ██   ██ ██   ██ ██   ██ ██    ██ ██      ████   ██          **
-- **        ██████  ██████  ███████ ██    ██ █████   ██ ██  ██          **
-- **        ██   ██ ██   ██ ██   ██  ██  ██  ██      ██  ██ ██          **
-- **        ██████  ██   ██ ██   ██   ████   ███████ ██   ████          **
-- ************************************************************************
-- ** All rights reserved. This content is protected by © Copyright law. **
-- ************************************************************************

local respawnWindow = nil

local function openRespawnWindow()

    if not respawnWindow then
        ArespawnWindow = BB_RespawnPoints_List_UI:new(getPlayer())
        ArespawnWindow:initialise()
        ArespawnWindow:addToUIManager()
        ArespawnWindow:populateList()
    else
        ArespawnWindow:close()
        respawnWindow = nil
    end
end

local deathUICreateChildren = ISPostDeathUI.createChildren

function ISPostDeathUI:createChildren()

    deathUICreateChildren(self)

    if not RespawnableSBags then return end
    if not RespawnableSBags.cooldown then return end
    if RespawnableSBags.cooldown > 0 then return end
    if #RespawnableSBags.respawnPoints == 0 then return end

    local buttonWid = 250
    local buttonHgt = 40
    local buttonX = 0
	local totalHgt = (buttonHgt * 4) + (12 * 3)

	self:setWidth(buttonWid)
	self:setHeight(totalHgt)

	self:setX(self.screenX + (self.screenWidth - buttonWid) / 2)
	self:setY(self.screenY + (self.screenHeight - 40 - totalHgt))

    local button = ISButton:new(buttonX, (totalHgt - buttonHgt), buttonWid, buttonHgt, (getText("IGUI_PostDeath_SbagRespawn")), self, openRespawnWindow)
    self:configButton(button)
    self:addChild(button)
    self.buttonSbagRespawn = button
end

local deathUIPreRender = ISPostDeathUI.prerender

function ISPostDeathUI:prerender()
    deathUIPreRender(self)
    if self.buttonSbagRespawn then
        local allPlayersDead = IsoPlayer.allPlayersDead()
        self.buttonSbagRespawn:setVisible(self.waitOver and allPlayersDead)
    end
end