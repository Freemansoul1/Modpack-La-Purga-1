require "ISUI/ISToolTipInv"
require 'ISUI/ISToolTipInv'


local old_render = ISToolTipInv.render
local item = nil
local numRows = 0

local chemText = getText("IGUI_invpanel_Chem_Prop")
local chemStatText = "TET"

local old_render = ISToolTipInv.render

function ISToolTipInv:render()
	numRows = 0
	if self.item ~= nil then
		item = self.item
		local player = getPlayer()
		if item and instanceof(item, "InventoryItem") and item:hasTag("Chem") and (player:getPerkLevel(Perks.Doctor) >= 3 or (player:HasTrait("ChemJunkie") or player:HasTrait("ChemExpert"))) then
			numRows = 2
			local type = item:getType()
			--print(type)
			if type == "Jet" then
				chemStatText = getText("IGUI_invpanel_Chem_Jet")
			elseif  type == "Buffout" then
				chemStatText = getText("IGUI_invpanel_Chem_Buffout")
			elseif  type == "Daytrip" then
				chemStatText = getText("IGUI_invpanel_Chem_Daytrip")
			elseif  type == "Stimpack" then
				chemStatText = getText("IGUI_invpanel_Chem_Stimpack")
			elseif  type == "SuperStimpack" then
				chemStatText = getText("IGUI_invpanel_SuperStimpack")
			elseif  type == "Mentats"  then
				chemStatText = getText("IGUI_invpanel_Chem_Mentats")
			elseif  type == "Psycho"  then
				chemStatText = getText("IGUI_invpanel_Chem_Psycho")
			elseif  type == "MedX"  then
				chemStatText = getText("IGUI_invpanel_Chem_MedX")
			elseif  type == "Xcell"  then
				chemStatText = getText("IGUI_invpanel_Chem_Xcell")
			elseif  type == "Bufftats"  then
				chemStatText = getText("IGUI_invpanel_Chem_Bufftats")
			elseif  type == "Buffjet"  then
				chemStatText = getText("IGUI_invpanel_Chem_Buffjet")
			elseif  type == "Rocket"  then
				chemStatText = getText("IGUI_invpanel_Chem_Rocket")
			elseif  type == "Slasher"  then
				chemStatText = getText("IGUI_invpanel_Chem_Slasher")
			elseif  type == "Cateye"  then
				chemStatText = getText("IGUI_invpanel_Chem_Cateye")
			elseif  type == "Fixer"  then
				chemStatText = getText("IGUI_invpanel_Chem_Fixer")
			end
		else
			return old_render(self)
		end
	end
	local stage = 1
	local old_y = 0
	local fontSize = 0
	local tooltipFontSize = 0
	local lineSpacing = self.tooltip:getLineSpacing()
	local old_setHeight = self.setHeight
	self.setHeight = function(self, num, ...)
		if stage == 1 then
			stage = 2
			old_y = num
			num = num + numRows * lineSpacing
		else 
			stage = -1 --error
		end
		return old_setHeight(self, num, ...)
	end
	local old_drawRectBorder = self.drawRectBorder
	self.drawRectBorder = function(self, ...)
		if numRows > 0 then
			local color = {0.68, 0.64, 0.96}
			local font = UIFont[getCore():getOptionTooltipFont()];
			self.tooltip:DrawText(font, chemText, 5, old_y, color[1], color[2], color[3], 1);
			self.tooltip:DrawText(font, chemStatText, 5, old_y + lineSpacing, color[1], color[2], color[3], 1);
			stage = 3
		else
			stage = -1 --error
		end
		return old_drawRectBorder(self, ...)
	end
	old_render(self)
	self.setHeight = old_setHeight
	self.drawRectBorder = old_drawRectBorder
end