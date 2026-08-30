---
--- WL_SelectPlayersPanel.lua
--- 24/04/2024
---
require "GravyUI"
require "ISUI/ISPanel"
require "WL_Utils"

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)

WL_SelectPlayersPanel = ISPanel:derive("WL_SelectPlayersPanel")
WL_SelectPlayersPanel.instance = nil

--- Show a select players panel, offering nearby players up to choose from
---@param target table to call the callback function on e.g. myTable
---@param callback function to call when a player is chosen e.g. myTable.onPlayerChosen
---@param options WL_SelectPlayersPanel_Options|nil if true only shows players visible within line of sight
function WL_SelectPlayersPanel:show(target, callback, options)
	if WL_SelectPlayersPanel.instance then
		WL_SelectPlayersPanel.instance:onClose()
	end

	local w = 400
	local h = 350
	local o = ISPanel:new(getCore():getScreenWidth()/2-w/2,getCore():getScreenHeight()/2-h/2, w, h)
	setmetatable(o, self)
	o.__index = self
	o.target = target
	o.callback = callback
	o.onlyInLOS = options.onlyInLOS or false
	o.includeSelf = options.includeSelf or false
	o:initialise()
	o:addToUIManager()
	WL_SelectPlayersPanel.instance = o
	return o
end

function WL_SelectPlayersPanel:initialise()
	self.moveWithMouse = true

	local window = GravyUI.Node(self.width, self.height):pad(15)
	local header, body, footer = window:rows({30, 1, 20}, 15)
	local leftBtn, nothing, rightBtn = footer:cols({0.2, 0.6, 30}, 15)
	self.headerLabel = header

	self.playerList = ISScrollingListBox:new(body.left, body.top, body.width, body.height);
	self.playerList:initialise();
	self.playerList:instantiate();
	self.playerList.itemheight = FONT_HGT_SMALL + 2 * 2;
	self.playerList.selected = 0;
	self.playerList.joypadParent = self;
	self.playerList.font = UIFont.NewSmall;
	self.playerList.doDrawItem = self.drawPlayers;
	self.playerList.drawBorder = true;

	self.goButton = leftBtn:makeButton("Select Player", self, self.onSelectPlayer)
	self.cancelButton = rightBtn:makeButton("Cancel", self, self.onClose)

	self:addChild(self.playerList);
	self:addChild(self.goButton)
	self:addChild(self.cancelButton)

	self:populatePlayerList()
end

function WL_SelectPlayersPanel:prerender()
	ISPanel.prerender(self)
	self:drawTextCentre("Nearby Players", self.headerLabel.left + (self.headerLabel.width/2),
			self.headerLabel.top, 1, 1, 1, 1, UIFont.Medium)
end

function WL_SelectPlayersPanel:drawPlayers(y, item, alt)
	local a = 0.9;
	self:drawRectBorder(0, (y), self:getWidth(), self.itemheight - 1, a, self.borderColor.r, self.borderColor.g,
			self.borderColor.b);
	if self.selected == item.index then
		self:drawRect(0, (y), self:getWidth(), self.itemheight - 1, 0.3, 0.7, 0.35, 0.15);
	end
	self:drawText(item.text, 10, y + 2, 1, 1, 1, a, self.font);
	return y + self.itemheight;
end

-- Uses IsoGameCharacter.CanSee and IsoPlayer.isGhostMode to validate
function WL_SelectPlayersPanel:populatePlayerList()
	self.playerList:clear();
	local players = getOnlinePlayers()
	players = players or ArrayList.new()
	local playerDataTable = {}
	for playerIndex = 0, players:size() -1 do
		local player = players:get(playerIndex)
		if self:filterPlayer(player) then
			local distance = getPlayer():getDistanceSq(player)
			local username = player:getUsername()
			local displayedName = WL_Utils.getRolePlayChatName(username)
			table.insert(playerDataTable, {displayedName = displayedName, username = username, distance = distance })
		end
	end

	table.sort(playerDataTable, function(a, b) return a.distance < b.distance end)

	for _, playerData in ipairs(playerDataTable) do
		self.playerList:addItem(playerData.displayedName, playerData.username);
	end
end

function WL_SelectPlayersPanel:filterPlayer(player)
	local localPlayer = getPlayer()
	local isStaff = WL_Utils.isStaff(localPlayer)
	if isStaff then return true end
	if not self.includeSelf and player == getPlayer() then return false end   -- Don't list yourself
	if player:isGhostMode() then return false end  -- Don't show ghost-mode staff
	if self.onlyInLOS and not localPlayer:CanSee(player) then return false end -- If LOS only, check if we can see them
	return true
end

function WL_SelectPlayersPanel:onSelectPlayer()
	local selectedPlayer = self.playerList.items[self.playerList.selected]
	if not selectedPlayer then return end
	local username = selectedPlayer.item
	if(username) then
		self.callback(self.target, username)
		self:onClose()
	end
end

function WL_SelectPlayersPanel:onClose()
	WL_SelectPlayersPanel.instance = nil
	self:removeFromUIManager()
end

--- @class WL_SelectPlayersPanel_Options
--- @field onlyInLOS boolean|nil if true only shows players visible within line of sight
--- @field includeSelf boolean|nil if true includes the local player in the list