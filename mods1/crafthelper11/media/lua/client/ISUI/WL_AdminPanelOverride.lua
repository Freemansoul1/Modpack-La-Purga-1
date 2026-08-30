---
--- WL_AdminPanelOverride.lua
--- 26/10/2023
---
require "ISUI/AdminPanel/ISAdminPanelUI"
require "WL_Utils"

local adminPanelButtonRefresh = ISAdminPanelUI.updateButtons

function ISAdminPanelUI:updateButtons()
	adminPanelButtonRefresh(self)

	local isModerator = WL_Utils.canModerate(getPlayer())
	self.safezoneBtn.enable = isModerator
	self.seeFactionBtn.enable = isModerator
	self.seeSafehousesBtn.enable = isModerator
	self.seeTicketsBtn.enable = isModerator
	self.miniScoreboardBtn.enable = isModerator
	self.packetCountsBtn.enable = isAdmin()
	self.sandboxOptionsBtn.enable = isAdmin()
	self.itemListBtn.enable = WL_Utils.isAtLeastGM(getPlayer())
	self.climateOptionsBtn.enable = isModerator
	self.showStatisticsBtn.enable = isModerator
	self.dbBtn.enable = isAdmin() and getDebug()
end
