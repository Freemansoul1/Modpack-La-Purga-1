local RU_NoteTooltip = {}

function RU_NoteTooltip:init()
	if isServer() then return end
	
end

local mod = RU_NoteTooltip:init()

local ISToolTipInv = ISToolTipInv

local ISToolTipInv_prerender = ISToolTipInv.prerender
function ISToolTipInv:prerender()
	local plr = self.tooltip:getCharacter()
	ISToolTipInv_prerender(self)
end

local function customNoteTooltip(self)
	local tooltip = self.tooltip
	local item = self.item
	local font = tooltip:getFont()
	local spacing = tooltip:getLineSpacing()
	local itemName = item:getName()
	local layout = tooltip:beginLayout()
		
	tooltip:render()
		
	local height = 0 + tooltip:getLineSpacing()
	
		-- all the mod data here is added in RU_RepairAction.lua, this method also makes it easy to add/maintain translations :)
	
		local itemModData = self.item:getModData()
		if itemModData.Timestamp then -- if we have a date (happens when repairing while wearing a digital watch)
			local day = itemModData.RepairDay
			local month = itemModData.RepairMonth
			local year = itemModData.RepairYear
			if day ~= nil and month ~= nil and year ~= nil then -- if we have a timestamp but not a date for some reason, skip making this entry
				local formattedDateString = ""
				if getCore():getOptionClockFormat() == 1 then -- if using U.S date format (MM/DD/YY)
					formattedDateString = month .. "/" .. day .. "/" .. year
				elseif getCore():getOptionClockFormat() == 2 then -- if using the proper date format (DD/MM/YY) ;)
					formattedDateString = day .. "/" .. month .. "/" .. year
				end
				local repairTimeLabel = layout:addItem()
				repairTimeLabel:setLabel(formattedDateString, 1, 1, 1, 1)
			end
		end
		
		if itemModData.Accuracy == "Accurate" then -- if using accurate readings from tier 2 notes
			local repairLengthLabel = layout:addItem()
			repairLengthLabel:setLabel(getText("Tooltip_resultPaper_Accurate", getText("Tooltip_Utility" .. itemModData.utility), itemModData.repairLength), 1, 1, 1, 1)
			
			if itemModData.InverterActive then -- if an inverter was present
				local altRepairLengthLabel = layout:addItem()
				altRepairLengthLabel:setLabel(getText("Tooltip_resultPaper_Accurate", getText("Tooltip_Utility" .. itemModData.altUtility), itemModData.altRepairLength), 1, 1, 1, 1)
			end
		elseif itemModData.Accuracy == "Loose" then -- if using loose readings from tier 1 notes
			local repairLengthLabel = layout:addItem()
			repairLengthLabel:setLabel(getText("Tooltip_resultPaper_Loose", getText("Tooltip_Utility" .. itemModData.utility), itemModData.repairLength), 1, 1, 1, 1)
			
			if itemModData.InverterActive then
				local altRepairLengthLabel = layout:addItem()
				altRepairLengthLabel:setLabel(getText("Tooltip_resultPaper_Loose", getText("Tooltip_Utility" .. itemModData.altUtility), itemModData.altRepairLength), 1, 1, 1, 1)
			end
		end
		
		height = layout:render(5, self.tooltip:getHeight(), tooltip)
		tooltip:endLayout(layout)
		
		height = height + 5
		tooltip:setHeight(height)
		
		if tooltip:getWidth() < 150.0 then
			tooltip:setWidth(150.0)
		end
end

local ISToolTipInv_render = ISToolTipInv.render
function ISToolTipInv:render()
	local item = self.item
	local scriptItem = item:getScriptItem()
	if scriptItem:getFullName() == "RestoreUtilities.RepairResultsT1" or scriptItem:getFullName() == "RestoreUtilities.RepairResultsT2" then -- we only want to run a custom tooltip for these 2 items in particular!
		if not ISContextMenu.instance or not ISContextMenu.instance.visibleCheck then
		

            local mx = getMouseX() + 24;
            local my = getMouseY() + 24;
            if not self.followMouse then
                mx = self:getX()
                my = self:getY()
                if self.anchorBottomLeft then
                    mx = self.anchorBottomLeft.x
                    my = self.anchorBottomLeft.y
                end
            end

            self.tooltip:setX(mx+11);
            self.tooltip:setY(my);

            self.tooltip:setWidth(50)
			self.item:DoTooltip(self.tooltip)
			customNoteTooltip(self)

            local myCore = getCore();
            local maxX = myCore:getScreenWidth();
            local maxY = myCore:getScreenHeight();

            local tw = self.tooltip:getWidth();
            local th = self.tooltip:getHeight()

            self.tooltip:setX(math.max(0, math.min(mx + 11, maxX - tw - 1)));
            if not self.followMouse and self.anchorBottomLeft then
                self.tooltip:setY(math.max(0, math.min(my - th, maxY - th - 1)));
            else
                self.tooltip:setY(math.max(0, math.min(my, maxY - th - 1)));
            end

            self:setX(self.tooltip:getX() - 11);
            self:setY(self.tooltip:getY());
            self:setWidth(tw + 11);
            self:setHeight(th);

            if self.followMouse then
                self:adjustPositionToAvoidOverlap({ x = mx - 24 * 2, y = my - 24 * 2, width = 24 * 2, height = 24 * 2 })
            end

			

            self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
            self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);

			self.item:DoTooltip(self.tooltip)
			customNoteTooltip(self)
			
			
        end
	else
		ISToolTipInv_render(self)
	end
end

Events.OnGameStart.Add(RU_NoteTooltip.init)