require "ISUI/ISPanelJoypad"

ISCheckDialog = ISPanelJoypad:derive("ISCheckDialog");

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)

local toDO = require('toDO')
local toDOU = require('toDOutils')


function ISCheckDialog:initialise()
	ISPanel.initialise(self);
	local btnWid = 100
    local btnHgt = math.max(25, FONT_HGT_SMALL + 3 * 2)
	local padBottom = 10

	local boxW = self:getWidth()*0.7
	local boxH = self:getHeight()*0.1

	self.editBox = ISTextEntryBox:new("", ((self:getWidth() / 2) - boxW / 2) + 5, (self:getHeight() / 2) - boxH / 2, boxW, boxH)
	self.editBox.font = UIFont.Medium
	self.editBox.backgroundColor = {r=1, g=1, b=1, a=1};
	self.editBox:initialise()
	self.editBox:instantiate()
	local color = ColorInfo.new(0, 0, 0, 1)
	self.editBox.javaObject:setTextColor(color)
	--self.editBox.onCommandEntered = self.downEnter
	self.editBox.target = self.editBox
	self:addChild(self.editBox)

	if self.yesno then
		self.yes = ISButton:new((self:getWidth() / 2) - btnWid - 5, self:getHeight() - padBottom - btnHgt, btnWid, btnHgt, getText("UI_Yes"), self, ISCheckDialog.onClick);
		self.yes.internal = "YES";
		self.yes.anchorTop = false;
		self.yes.anchorBottom = true;
		self.yes:initialise();
		self.yes:instantiate();
		self.yes.backgroundColor = {r=0, g=0, b=0, a=0.7};
		self.yes.borderColor = {r=1, g=1, b=1, a=0.1};
		self:addChild(self.yes);

		self.no = ISButton:new((self:getWidth() / 2) + 5, self:getHeight() - padBottom - btnHgt, btnWid, btnHgt, getText("UI_No"), self, ISCheckDialog.onClick);
		self.no.internal = "NO";
		self.no.anchorTop = false;
		self.no.anchorBottom = true;
		self.no:initialise();
		self.no:instantiate();
		self.no.backgroundColor = {r=0, g=0, b=0, a=0.7};
		self.no.borderColor = {r=1, g=1, b=1, a=0.1};
		self:addChild(self.no);
	else
		self.ok = ISButton:new((self:getWidth() / 2) - btnWid / 2, self:getHeight() - padBottom - btnHgt, btnWid, btnHgt, getText("UI_Ok"), self, ISCheckDialog.onClick);
		self.ok.internal = "OK";
		self.ok.anchorTop = false;
		self.ok.anchorBottom = true;
		self.ok:initialise();
		self.ok:instantiate();
		self.ok.borderColor = {r=1, g=1, b=1, a=0.1};
		self:addChild(self.ok);
	end
--	if UIManager.getSpeedControls() then
--		UIManager.getSpeedControls():SetCurrentGameSpeed(0);
--		UIManager.setShowPausedMessage(false);
--	end
end

function ISCheckDialog:destroy()
	local inGame = MainScreen.instance and MainScreen.instance.inGame and not MainScreen.instance:getIsVisible()
	UIManager.setShowPausedMessage(inGame);
	self:setVisible(false);
	self:removeFromUIManager();
	if UIManager.getSpeedControls() and inGame then
		UIManager.getSpeedControls():SetCurrentGameSpeed(1);
	end
	if self.player ~= nil then
		setJoypadFocus(self.player, self.prevFocus);
	elseif self.joyfocus and self.joyfocus.focus == self then
		self.joyfocus.focus = self.prevFocus
		updateJoypadFocus(self.joyfocus)
	end
end

function ISCheckDialog:onClick(button)
	
	if button.internal == "YES" and toDO.playerObj then
		toDOU.writeCheckList(self.editBox:getText(), toDO.playerObj, self.target)
	end

	self:destroy()
	
	if self.onclick ~= nil then
		button.player = self.player;
		self.onclick(self.target, button, self.param1, self.param2);
	end
end

function ISCheckDialog:prerender()
	self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
	self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
	self:drawTextCentre(self.text, self:getWidth() / 2, 20, 0, 0, 0, 1, UIFont.Small);
	self:drawTextureScaledAspect(getTexture("media/textures/write.png"), 5, self.editBox:getY()-5, 32, 32, 1.0, 1.0, 1.0, 1.0)
end

function ISCheckDialog:onMouseUp(x, y)
    if not self.moveWithMouse then return; end
    if not self:getIsVisible() then
        return;
    end

    self.moving = false;
    if ISMouseDrag.tabPanel then
        ISMouseDrag.tabPanel:onMouseUp(x,y);
    end

    ISMouseDrag.dragView = nil;
end

function ISCheckDialog:onMouseUpOutside(x, y)
    if not self.moveWithMouse then return; end
    if not self:getIsVisible() then
        return;
    end

    self.moving = false;
    ISMouseDrag.dragView = nil;
end

function ISCheckDialog:onMouseDown(x, y)
    if not self.moveWithMouse then return; end
    if not self:getIsVisible() then
        return;
    end

    self.downX = x;
    self.downY = y;
    self.moving = true;
    self:bringToTop();
end

function ISCheckDialog:onMouseMoveOutside(dx, dy)
    if not self.moveWithMouse then return; end
    self.mouseOver = false;

    if self.moving then
        self:setX(self.x + dx);
        self:setY(self.y + dy);
        self:bringToTop();
    end
end

function ISCheckDialog:onMouseMove(dx, dy)
    if not self.moveWithMouse then return; end
    self.mouseOver = true;

    if self.moving then
        self:setX(self.x + dx);
        self:setY(self.y + dy);
        self:bringToTop();
        --ISMouseDrag.dragView = self;
    end
end

function ISCheckDialog:onGainJoypadFocus(joypadData)
--    print("gained modal focus");
    ISPanelJoypad.onGainJoypadFocus(self, joypadData);
	if self.yesno then
		self:setISButtonForA(self.yes)
		self:setISButtonForB(self.no)
	else
		self:setISButtonForA(self.ok)
	end
	self.joypadButtons = {}
end

function ISCheckDialog:onLoseJoypadFocus(joypadData)
	ISPanelJoypad.onLoseJoypadFocus(self, joypadData)
	if self.yesno then
		self.yes:clearJoypadButton()
		self.no:clearJoypadButton()
	else
		self.ok:clearJoypadButton()
	end
end

function ISCheckDialog:onJoypadBeforeDeactivate(joypadData)
	if self.removeIfJoypadDeactivated then -- ugh
		self:destroy()
	end
end

function ISCheckDialog:onJoypadDown(button)
	ISPanelJoypad.onJoypadDown(self, button)
--[[
    if button == Joypad.AButton then
        if self.yesno then
            self.yes.player = self.player;
            self.yes.onclick(self.yes.target, self.yes);
        else
            self.ok.onclick(self.ok.target, self.ok);
        end
        if self.player ~= nil then
            setJoypadFocus(self.player, self.prevFocus);
        elseif self.joyfocus and self.joyfocus.focus == self then
            self.joyfocus.focus = self.prevFocus
            updateJoypadFocus(self.joyfocus)
        end
        self:destroy();
    end
    if button == Joypad.BButton then
        if self.yesno then
            self.no.player = self.player;
            self.no.onclick(self.no.target, self.no);
        else
            self.ok.onclick(self.ok.target, self.ok);
        end
       if self.player ~= nil then
            setJoypadFocus(self.player, self.prevFocus);
        elseif self.joyfocus and self.joyfocus.focus == self then
            self.joyfocus.focus = self.prevFocus
            updateJoypadFocus(self.joyfocus)
       end
        self:destroy();
    end
--]]
end

--************************************************************************--
--** ISCheckDialog:render
--**
--************************************************************************--
function ISCheckDialog:render()

end

function ISCheckDialog.CalcSize(width, height, text)
	local fontHgt = getTextManager():getFontHeight(UIFont.Small)
	local textWid = 0
	local textHgt = 0
	local lines = text:split("\\n")
	for _,line in ipairs(lines) do
		textWid = math.max(textWid, getTextManager():MeasureStringX(UIFont.Small, line))
		textHgt = textHgt + fontHgt
	end
	local buttonWid = 100
	if width < math.max(textWid + 20, buttonWid * 2 + 10) then
		width = math.max(textWid + 20, buttonWid * 2 + 10)
	end
	local buttonHgt = 25
	local padBottom = 10
	if height < 20 + textHgt + 20 + buttonHgt + padBottom then
		height = 20 + textHgt + 20 + buttonHgt + padBottom
	end
	return width,height
end

--************************************************************************--
--** ISCheckDialog:new
--**
--************************************************************************--
function ISCheckDialog:new(x, y, width, height, text, yesno, target, onclick, player, param1, param2)
	text = text:gsub("\\n", "\n")
	width,height = ISCheckDialog.CalcSize(width, height, text)
	local o = ISPanelJoypad.new(self, x, y, width, height);
	local playerObj = player and getSpecificPlayer(player) or nil
	if y == 0 then
		if playerObj and playerObj:getJoypadBind() ~= -1 then
			o.y = getPlayerScreenTop(player) + (getPlayerScreenHeight(player) - height) / 2
		else
			o.y = o:getMouseY() - (height / 2)
		end
		o:setY(o.y)
	end
	if x == 0 then
		if playerObj and playerObj:getJoypadBind() ~= -1 then
			o.x = getPlayerScreenLeft(player) + (getPlayerScreenWidth(player) - width) / 2
		else
			o.x = o:getMouseX() - (width / 2)
		end
		o:setX(o.x)
	end
	o.name = nil;
    o.backgroundColor = {r=0.898, g=0.898, b=0.898, a=0.8};
    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
	o.anchorLeft = true;
	o.anchorRight = true;
	o.anchorTop = true;
	o.anchorBottom = true;
	o.text = text;
	o.yesno = yesno;
	o.target = target;
	o.onclick = onclick;
	o.yes = nil;
    o.player = player;
	o.no = nil;
	o.ok = nil;
	o.param1 = param1;
	o.param2 = param2;
    o.moveWithMouse = false;
    return o;
end

