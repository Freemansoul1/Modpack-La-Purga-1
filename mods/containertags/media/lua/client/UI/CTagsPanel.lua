CTagsPanel = ISPanel:derive("CTagsPanel");

function CTagsPanel:initialise()
	ISPanel.initialise(self)
end
function CTagsPanel:prerender()

end
function CTagsPanel:createChildren()
	local hO = self.y;

	self.tagsBtn = ISButton:new(0, 0, 40, 35, "", self, CTagsPanel.onOptionMouseDown);
	if CTags.mode == 2 then
		self.tagsBtn:setImage(getTexture("media/textures/note_faction.png"));
	else
		self.tagsBtn:setImage(getTexture("media/textures/note.png"));
	end
	self.tagsBtn:initialise();
	self.tagsBtn:instantiate();
	self.tagsBtn:setDisplayBackground(false);
	CTagsPanel.button = self.tagsBtn;

	self.tagsBtn.borderColor = {r=1, g=1, b=1, a=0.1};
	self.tagsBtn:ignoreWidthChange();
	self.tagsBtn:ignoreHeightChange();
	self:addChild(self.tagsBtn);
end

function CTagsPanel.onOptionMouseDown(button, x, y)
	local mode = CTags.mode or 1;
	local button = CTagsPanel.button;
	local iconOn = getTexture("media/textures/note.png");
	local iconOff = getTexture("media/textures/note_off.png");
	local iconFaction = getTexture("media/textures/note_faction.png");


	if (getWorld():getGameMode() == "Multiplayer") then
		-- Factions mode
		if mode == 0 then 
			CTags.mode = 1;
			button:setImage(iconOn)
		end 
		if mode == 1 then 
			local faction = CTags:getFaction();
			if faction then
				CTags.mode = 2;
				button:setImage(iconFaction)
			else
				CTags.mode = 0;
				button:setImage(iconOff)
			end 
		end
		if mode == 2 then 
			CTags.mode = 0;
			button:setImage(iconOff)
		end 
	else 
		-- No factions in SP
		if mode == 0 then 
			CTags.mode = 1;
			button:setImage(iconOn)
		end 
		if mode == 1 then 
			CTags.mode = 0;
			button:setImage(iconOff)
		end
	end
end 

function CTagsPanel.hide()
	local window = CTagsPanel.window;
	if not window then return end;
	window:setVisible(false)
	window:removeFromUIManager()
end

function CTagsPanel.make()
	local player = getPlayer();
	local playerNum = player:getPlayerNum()
	local x = getPlayerScreenLeft(playerNum)
	local y = getPlayerScreenTop(playerNum)
	local panel = CTagsPanel:new(18, 670, 50, 50, player);
	CTagsPanel.window = panel;
	panel:initialise();
	panel:addToUIManager();
	return panel;
end


function CTagsPanel:new(x, y, w, h)
	-- Don't store it, regenerate completely
	if CTagsPanel.window then CTagsPanel:hide() end

	local o = {};
	o = ISPanel:new(x, y, w, h);
	setmetatable(o, self);
	self.__index = self;
	o.x = x;
	o.y = y;
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