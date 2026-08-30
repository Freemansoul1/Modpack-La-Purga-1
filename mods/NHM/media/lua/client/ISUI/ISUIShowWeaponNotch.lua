require "ISUI/ISToolTipInv"

local notch = nil
local notchCreator = nil;
local notchText = nil
local item = nil
local numRows = 0

local old_render = ISToolTipInv.render

function ISToolTipInv:render()
	numRows = 0
	if self.item ~= nil then
		item = self.item
		getPlayer()
		notchText = nil;
		if item and instanceof(item, "HandWeapon") and item:getSubCategory() == "Firearm" and item:getModData().notchName ~= nil and item:getModData().notchCreator ~= nil and item:getModData().notchName ~= "" then
			numRows = 3
			notch = item:getModData().notchName
			notchCreator = item:getModData().notchCreator
			
		else
			return old_render(self)
		end
	end
	local stage = 1
	local old_y = 0
	local lineSpacing = self.tooltip:getLineSpacing()
	local old_setHeight = self.setHeight
	self.setHeight = function(self, num, ...)
		if stage == 1 then
			stage = 2
			old_y = num
			num = num + numRows * lineSpacing
		else 
			stage = -1
		end
		return old_setHeight(self, num, ...)
	end
	local old_drawRectBorder = self.drawRectBorder
	self.drawRectBorder = function(self, ...)
		if numRows > 0 then
			notchText = getText("UI_Notch_Text") .. ": \"" .. notch .. "\"" .. "\n" .. getText("UI_Notch_Created_By") .. ": " .. notchCreator
			local color = {0.68, 0.64, 0.96}
			local font = UIFont[getCore():getOptionTooltipFont()];
			self.tooltip:DrawText(font, notchText, 5, old_y, color[1], color[2], color[3], 1);
			stage = 3
		else
			stage = -1
		end
		return old_drawRectBorder(self, ...)
	end
	old_render(self)
	self.setHeight = old_setHeight
	self.drawRectBorder = old_drawRectBorder
end