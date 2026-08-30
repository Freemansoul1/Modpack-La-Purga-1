require "ISUI/AdminPanel/ISAdminPanelUI"

DupeA = DupeA or {}
local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)

local DA_vanilla_ISAdminPanelUI_create = ISAdminPanelUI.create
function ISAdminPanelUI:create()
    DA_vanilla_ISAdminPanelUI_create(self)

    local btnWid = 150
    local btnHgt = math.max(25, FONT_HGT_SMALL + 3 * 2)
    local btnGapY = 5

    local last_btn = self.children[self.IDMax - 1]
    if last_btn.internal == "CANCEL" then
        last_btn = self.children[self.IDMax - 2]
    end
    local x = last_btn.x
    local y = last_btn.y + btnHgt + btnGapY

    if getAccessLevel() == "admin" then
        self.dupeBtn = ISButton:new(x, y, btnWid, btnHgt, getText("IGUI_AdminPanel_DupeAnalyzer"), self, ISAdminPanelUI.onDupeMouseDown)
        self.dupeBtn.internal = "DUPEANALYZER"
        self.dupeBtn:initialise()
        self.dupeBtn:instantiate()
        self.dupeBtn.borderColor = self.buttonBorderColor
        self:addChild(self.dupeBtn)
        y = y + btnHgt + btnGapY
    end
end

function ISAdminPanelUI:onDupeMouseDown(button)
    if ISDupeListPanel.instance then
        ISDupeListPanel.instance:close()
    end
    local ui = ISDupeListPanel:new(50,50,750,650, getPlayer())
    ui:initialise()
    ui:addToUIManager()
end