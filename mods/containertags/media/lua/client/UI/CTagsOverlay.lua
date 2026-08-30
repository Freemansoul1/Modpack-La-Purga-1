CTagsOverlay = ISPanel:derive("CTagsOverlay");

function CTagsOverlay:initialise()
	ISPanel.initialise(self)
end

function CTagsOverlay:prerender()
	if CTags.drawData then
		for i=1, #CTags.drawData do
			local tag = CTags.drawData[i];
			if tag and tag.square then
				local x = isoToScreenX(self.playerNumber, tag.coords[1], tag.coords[2], tag.coords[3]);
				local y = isoToScreenY(self.playerNumber, tag.coords[1], tag.coords[2], tag.coords[3]);
				if (x < self.screenW or x > -200) or (y < self.screenH or y > -200) then
					self:drawTextCentre(tag.text, x + 2, y + 2, 0, 0, 0, 1, self.font or UIFont.Small);
					self:drawTextCentre(tag.text, x, y, tag.color[1], tag.color[2], tag.color[3], 1, self.font or UIFont.Small);
				end
			end
		end 
	end
end

function CTagsOverlay:createChildren()

end

function CTagsOverlay:loop()
	local window = CTagsOverlay.window; 
	window.zoom = window.core:getZoom(window.playerNumber);
	if window.zoom >= 1 then window.font = UIFont.Small else window.font = UIFont.Large end
	CTags:sleepDo(0.1, CTagsOverlay.loop);
end

function CTagsOverlay:make()
	local window = CTagsOverlay:new();
	window:initialise();
	window:setVisible(true);
	window:addToUIManager()
	CTagsOverlay.window = window;
	CTagsOverlay:loop()
	print('Tags overlay initialised.');
end

function CTagsOverlay.hide()
	local window = CTagsOverlay.window;
	if not window then return end;
	window:setVisible(false)
	window:removeFromUIManager()
end

function CTagsOverlay:utility(o)

end 

function CTagsOverlay:new(x, y, w, h)
	-- Don't store it, regenerate completely
	if CTagsOverlay.window then CTagsOverlay:hide() end

	local o = {};
	o = ISPanel:new(0, 0, 0, 0);
	setmetatable(o, self);
	self.__index = self;
	o.x = 0;
	o.y = 0;
	o.background = true;
	o.backgroundColor = {r=0, g=0, b=0, a=0};
	o.borderColor = {r=0, g=0, b=0, a=0};
	o.anchorLeft = true;
	o.anchorRight = false;
	o.anchorTop = true;
	o.anchorBottom = false;
	o.moveWithMouse = false;
	o.screenW = getCore():getScreenWidth();
	o.screenH = getCore():getScreenHeight();
	o.player = getPlayer();
	o.playerNumber = o.player:getPlayerNum();
	o.core = getCore();
	return o;
end