if not getActivatedMods():contains("HarvestZSUtilities") then
    local function onOpenSpectatePanel()
        if ISSpectatePanelUI.instance then
            ISSpectatePanelUI.instance:close()
        else
            local ui = ISSpectatePanelUI:new(getPlayer());
            ui:initialise();
            ui:addToUIManager();
        end
    end

    --Based on code snippet by Chuckleberry from ZombieZones.
    require "ISUI/AdminPanel/ISAdminPanelUI"
    local _ISAdminPanelUI_create = ISAdminPanelUI.create
    function ISAdminPanelUI:create()
        _ISAdminPanelUI_create(self)
        local fontHeight = getTextManager():getFontHeight(UIFont.Small)
        local btnWid = 150
        local btnHgt = math.max(25, fontHeight + 3 * 2)
        local btnGapY = 5

        local lastButton = self.children[self.IDMax - 1]
        lastButton = lastButton.internal == "CANCEL" and self.children[self.IDMax - 2] or lastButton

        self.showSpectatePanel = ISButton:new(lastButton.x, lastButton.y + btnHgt + btnGapY, lastButton:getWidth(),
            btnHgt, "Spectate Panel", self, onOpenSpectatePanel)
        self.showSpectatePanel.internal = ""
        self.showSpectatePanel:initialise()
        self.showSpectatePanel:instantiate()
        self.showSpectatePanel.borderColor = self.buttonBorderColor
        self:addChild(self.showSpectatePanel)
    end
end
