----------------------------------------------------------------------------------------------------------------------------------------
local CAMmod = require "CorpsesAutoMove/CorpsesAutoMove_Functions"
require "ISUI/ISPanelJoypad"
----------------------------------------------------------------------------------------------------------------------------------------
--CAMmod = CAMmod or {}
CAMmod.UI = ISCollapsableWindow:derive("CAMmod.UI");
----------------------------------------------------------------------------------------------------------------------------------------
local RED = {r=1.0, g=0.2, b=0.0, a=0.7}
local NOCOLOR = {r=0, g=0, b=0, a=0.0}
local REDdown = {r=1.0, g=0.2, b=0.0, a=0.5}
local YEL = {r=0.9, g=0.75, b = 0, a= 1 }
local YELdown = {r=0.8, g=0.7, b = 0, a= 0.2 }
local GREEN = {r=0.1, g=0.85, b = 0, a= 0.7 }
----------------------------------------------------------------------------------------------------------------------------------------
function CAMmod.UI:prerender()
	ISCollapsableWindow.prerender(self);
	local radius = (self:getRadius("zone"));
	if self.zoneMarker and (self.zoneMarker:getSize() ~= radius) then
		self.zoneMarker:setSize(radius)
	end
	local th = self:titleBarHeight()
	self:drawTextureScaled(getTexture("media/ui/CAMmod_barre.png"), 1, 1, self:getWidth() - 2, th - 2, 1, 1, 1, 1)
end
local counter = 6
function CAMmod.UI:render()
	if counter == 0 then
		counter = 2
		CAMmod.getHighlightedAreaRender(self)
	else
		counter = counter-1
	end
    ISCollapsableWindow.render(self);
    --local btnSmallWidHgt = math.ceil(self.width/30)
    --local lastSpace = self.width -( btnSmallWidHgt*3)
	local space = self.width/48
	local th = self:titleBarHeight()
	local midleScreenWidth = (self.width/2) + space
	self:drawText(getText("IGUI_CAMmod_drawText_PendingCleaningAction")..tostring(#CAMmod.bodiesList), midleScreenWidth, th+space, 0.9, 0.75, 0, 1, self.font); --23
	self:drawText(getText("IGUI_CAMmod_drawText_MissedCleaningAction")..tostring(CAMmod.bodiesFail), midleScreenWidth, th+space+space+space, 0.9, 0.75, 0, 1, self.font); -- 38
	--self:drawTexture(getTexture("media/ui/CAMmod_Background.png"), 0, 0, 0.8)
	--self:drawTextureScaled(self.titlebarbkg, 2, 1, self:getWidth() - 4, 16 - 2, 1, 1, 1, 1);
	--self:drawTextureScaledAspect(getTexture("media/ui/CAMmod_Background.png"), 0, 0, self.width, self.height,1, 0.5, 0.5, 1);
	--self:drawText("Corpses list: "..tostring(#CAMmod.bodiesList), 168, 37, 1, 1, 1, 1, self.font);
end
----------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------
function CAMmod.UI:update()
	ISCollapsableWindow.update(self);
	CAMmod.getUpdate(self.chr)
    if self.chr:isDead() or self.chr:getVehicle() then self:close() end
    --if chr:isPlayerMoving() then started = nil end
end
----------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------
function CAMmod.UI:createChildren()
	ISCollapsableWindow.createChildren(self)
	local btnSmallWidHgt = self.width/30--math.ceil()--13
	local btnMidleWidHgt = self.width/12-- math.ceil()--30

	local btnWid = self.width/4--math.ceil()--95
	local btnHgt = btnSmallWidHgt*2--self.height/6--math.ceil() --25

	local space = self.width/48--math.ceil()
	local space1 = btnWid+(space*2)
	local space2 = space1+space1--btnWid+space
	local space3 = space1+space2
	local lastSpace = self.width -(space*3)

	local width = self.width; --384
	local height = self.height; --120
	local padBottom = 0
	local f = 0.8
	local th = self:titleBarHeight()
	local lastSpaceheight = height-btnHgt-(space*f)
	local btnSmallSpace = btnSmallWidHgt + space
	local TickBoxSpaceHeight = th+space
	local widthBar = self.width*0.7
	local spaceBarWidth = self.width - widthBar -space
	local heightBar = space*1.5
	

	
	if self.widthScreen == 1920 and self.heightScreen == 1080 then
		self.backgroundImage = ISImage:new(padBottom-2,th+1, width, height, getTexture("media/ui/CAMmod_Background.png"));
		self.backgroundImage:initialise();
		self.backgroundImage:instantiate();
		self:addChild(self.backgroundImage)
	end
	self.stairIcon = ISImage:new(lastSpace-(space),lastSpaceheight-(space/3), 26, 24, getTexture("media/ui/CAMmod_stairIcon.png"));
	self.stairIcon:initialise();
	self.stairIcon:instantiate();
	self:addChild(self.stairIcon)

	self.boolOptions = ISTickBox:new(space, TickBoxSpaceHeight, 75, space, "", self, CAMmod.UI.onBoolOptionsChange);
	self.boolOptions:initialise()
	self.boolOptions.choicesColor = RED;
	self:addChild(self.boolOptions)
	self.boolOptions:addOption(getText("IGUI_CAMmod_option_Move"));
	self.boolOptions:addOption(getText("IGUI_CAMmod_option_Area"));
	self.boolOptions:addOption(getText("IGUI_CAMmod_option_Stack"));

	local firstCocheHeight = (self.boolOptions:getHeight()/3)
	local spaceBarHeight = TickBoxSpaceHeight+(firstCocheHeight*2)+space
	
	_,self.radiusSlider = ISDebugUtils.addSlider(self, "radius", spaceBarWidth, spaceBarHeight,widthBar ,heightBar , CAMmod.UI.onSliderChange)
	self.radiusSlider.pretext = "Radius: ";
	self.radiusSlider.valueLabel = self.radiusSliderLabel;
	self.radiusSlider:setValues(1, 33, 1, 10, true);
	self.radiusSlider.currentValue = 10;

	self.pickNewSq = ISButton:new(space2, lastSpaceheight, btnWid, btnHgt, getText("IGUI_CAMmod_button_SelectZone"), self,CAMmod.UI.onSelectZoneMarkerSquare);
	self.pickNewSq.anchorTop = false
	self.pickNewSq.anchorBottom = true
	self.pickNewSq:initialise();
	self.pickNewSq:instantiate();
	self.pickNewSq.backgroundColor = NOCOLOR;
    self.pickNewSq.backgroundColorMouseOver = YELdown;
    self.pickNewSq.textColor = RED
	self.pickNewSq.borderColor = REDdown;
	self:addChild(self.pickNewSq);

	self.pickNewSq2 = ISButton:new(space1, lastSpaceheight, btnWid, btnHgt, getText("IGUI_CAMmod_button_SelectPlace"), self, CAMmod.UI.onSelectPlaceMarkerSquare);
	self.pickNewSq2.anchorTop = false
	self.pickNewSq2.anchorBottom = true
	self.pickNewSq2:initialise();
	self.pickNewSq2:instantiate();
	self.pickNewSq2.backgroundColor = NOCOLOR;
    self.pickNewSq2.backgroundColorMouseOver = YELdown;
    self.pickNewSq2.textColor = RED
	self.pickNewSq2.borderColor = REDdown;
	self:addChild(self.pickNewSq2);

	self.add = ISButton:new(space,lastSpaceheight , btnWid*f, btnHgt, getText("IGUI_CAMmod_button_clean"), self, CAMmod.UI.onStart);-- btnWid*f >> 103
	self.add.anchorTop = false
	self.add.anchorBottom = true
	--self.add:setImage(getTexture("media/ui/imageT.png"))
	self.add:initialise();
	self.add:instantiate();
	self.add.backgroundColor = NOCOLOR;
    self.add.backgroundColorMouseOver = RED;
    self.add.textColor = YEL
	self.add.borderColor = REDdown;
	self:addChild(self.add);
	self.cursorType = "move"
	self:onBoolOptionsChange(1, true)

	self.clearListButton = ISButton:new(space1+btnMidleWidHgt+space,th+space, btnMidleWidHgt, btnMidleWidHgt,"", self, CAMmod.UI.onClickClearList);--getText("IGUI_CAMmod_button_ClearList")
    self.clearListButton:initialise();
    self.clearListButton:instantiate();
    self.clearListButton.backgroundColor = NOCOLOR;
    self.clearListButton.backgroundColorMouseOver = RED;
	self.clearListButton.borderColor = REDdown;
	self.clearListButton.textColor = YEL
	self.clearListButton:setImage(getTexture("media/ui/CAMmod_trashButton.png"))
    self.clearListButton:forceImageSize(btnMidleWidHgt, btnMidleWidHgt)
    self:addChild(self.clearListButton);

    self.resumeButton = ISButton:new(space1,th+space, btnMidleWidHgt, btnMidleWidHgt, "", self, CAMmod.UI.onClickResume);
    self.resumeButton:initialise();
    self.resumeButton:instantiate();
    self.resumeButton.backgroundColor = NOCOLOR;
    self.resumeButton.backgroundColorMouseOver = RED;
	self.resumeButton.borderColor = REDdown;
	self.resumeButton.textColor = RED
	self.resumeButton:setImage(getTexture("media/ui/CAMmod_resumeButton.png"))
    self.resumeButton:forceImageSize(btnMidleWidHgt, btnMidleWidHgt)
    self:addChild(self.resumeButton);

    self.buttonInfo = ISButton:new(lastSpace,th+space, btnSmallWidHgt*1.5, btnSmallWidHgt*1.5, "?", self, CAMmod.UI.onClickInfo); --13,10
    --self.buttonInfo.internal = "INFO";
    self.buttonInfo:initialise();
    self.buttonInfo:instantiate();
    self.buttonInfo.backgroundColor = NOCOLOR;
    self.buttonInfo.textColor = YEL
    self.buttonInfo.backgroundColorMouseOver = RED;
	self.buttonInfo.borderColor = REDdown;
    self:addChild(self.buttonInfo);

	self.button1p = ISButton:new(space3,lastSpaceheight, btnSmallWidHgt, btnSmallWidHgt, "", self, CAMmod.UI.onClickFloor);-- 18 12
    self.button1p.internal = "B1PLUS";
    self.button1p:initialise();
    self.button1p:instantiate();
    self.button1p.backgroundColor = NOCOLOR;
    self.button1p.textColor = RED
    self.button1p.backgroundColorMouseOver = YELdown;
	self.button1p.borderColor = REDdown;
	self.button1p:setImage(getTexture("media/ui/CAMmod_upButton.png"))
    self.button1p:forceImageSize(btnSmallWidHgt, btnSmallWidHgt)
    self:addChild(self.button1p);

    self.button1m = ISButton:new(space3,lastSpaceheight+btnSmallWidHgt, btnSmallWidHgt, btnSmallWidHgt, "", self, CAMmod.UI.onClickFloor); --18 12
    self.button1m.internal = "B1MINUS";
    self.button1m:initialise();
    self.button1m:instantiate();
    self.button1m.textColor = RED
    self.button1m.backgroundColor = NOCOLOR;
    self.button1m.backgroundColorMouseOver = YELdown;
	self.button1m.borderColor = REDdown;
	self.button1m:setImage(getTexture("media/ui/CAMmod_downButton.png"))
    self.button1m:forceImageSize(btnSmallWidHgt, btnSmallWidHgt)
    self:addChild(self.button1m);

	--_,self.floorNumberLabel = ISDebugUtils.addLabel(self,"Number",310+27,y+61,"0", UIFont.Small, false);
	self.floorNumberLabel = ISLabel:new(lastSpace-(space/3), lastSpaceheight+space, 16, "0", 0.9, 0.75, 0, 1.0, UIFont.Small,true)-- _bLeft==nil and true or _bLeft);
    self.floorNumberLabel:initialise();
    self.floorNumberLabel:instantiate();
    --label.customData = _data;
    self:addChild(self.floorNumberLabel)

	self.floorNumberLabel.valueLabel = 0;
    --
end
----------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------
function CAMmod.UI.onClickResume()
	CAMmod.started = true
end
function CAMmod.UI.onClickInfo(button)
	local w = 250
	local h = 150
	local x = getCore():getScreenWidth() / 4
    local y = getCore():getScreenHeight() / 4
    local t = getText("IGUI_CAMmod_Dialog_Info")
    local dialog = ISModalDialog:new(x,y, w, h, t, false)-- nil, confirm, 0)
    dialog:initialise()
    dialog:addToUIManager()
    getSoundManager():playUISound("CAMmod_CleanMenu")
end
function CAMmod.UI:onClickClearList()
	CAMmod.bodiesList = {}
	CAMmod.bodiesFail = 0
	ISTimedActionQueue.clear(self.chr) 
	self:stopAction()
end
function CAMmod.UI:onClickFloor(button)
	if self.floorNumberLabel.valueLabel then
		local val = tonumber(self.floorNumberLabel.valueLabel)
		local newEval = 0
		if button.internal == "B1PLUS" then
			newEval = val+1
		elseif button.internal == "B1MINUS" then
			newEval = val-1
		end
		if newEval < 0 then newEval = 0 end
		self.floorNumberLabel.valueLabel = newEval
		self.floorNumberLabel:setName(tostring(newEval));
	end
	if self.boolOptions.selected[3] ~= true or (not self.zoneMarker and not self.placeMarker )then self:onBoolOptionsChange(3, true) end
end
function CAMmod.UI:onBoolOptionsSelect(b1,b2,b3)
	self.boolOptions.selected[1] = b1
	self.boolOptions.selected[2] = b2
	self.boolOptions.selected[3] = b3
end
function CAMmod.UI:getMarker(cursorType)
	self[cursorType.."X"] = self[cursorType.."X"] or self.chr:getX()
	self[cursorType.."Y"] = self[cursorType.."Y"] or self.chr:getY()
	self[cursorType.."Z"] = self[cursorType.."Z"] or self.chr:getZ()
	local square = getSquare(self[cursorType.."X"],self[cursorType.."Y"],self[cursorType.."Z"])
	local radius = self:getRadius(cursorType)
	self.cursorType = cursorType
	self:addMarker(square,radius)
end
function CAMmod.UI:onBoolOptionsChange(index, selected)
	if getCell():getDrag(self.chr:getPlayerNum()) then getCell():setDrag(nil, self.chr:getPlayerNum()) end
	self.cursor = nil
	if index == 1 then
		self:onBoolOptionsSelect(true,false,false)
		self:removeArea()
		self:removeMarkers()
		self:onSelectMoveSquare()
	end
	if index == 2 then
		self:onBoolOptionsSelect(false,true,false)
		self:removeArea()
		self:removeMarkers()
		self:onSelectAreaSquare()
	end
	if index == 3 then
		self:onBoolOptionsSelect(false,false,true)
		self:removeArea()
		if not self.placeMarker then 
			self.placeX = self.chr:getX();
			self.placeY = self.chr:getY();
			self.placeZ = self.chr:getZ();
			self:getMarker("place") 
		else
			self:removePlaceMarker()
		end
		if not self.zoneMarker then 
			self.zoneX = self.chr:getX();
			self.zoneY = self.chr:getY();
			self.zoneZ = self.chr:getZ();
			self:getMarker("zone") 
		else
			self:removeZoneMarker()
		end
	end
end
function CAMmod.UI:onSliderChange(_newval, _slider)
	if _slider.valueLabel then
		_slider.valueLabel:setName(ISDebugUtils.printval((_newval),3));
	end
	if self.boolOptions.selected[3] ~= true or (not self.zoneMarker and not self.placeMarker )then self:onBoolOptionsChange(3, true) end
end
function CAMmod.UI:onSelectZoneMarkerSquare()
	if self.boolOptions.selected[3] ~= true or (not self.zoneMarker and not self.placeMarker )then self:onBoolOptionsChange(3, true) end
	self.cursorType = "zone"
	self:getCursor()
end
function CAMmod.UI:onSelectPlaceMarkerSquare()
	if self.boolOptions.selected[3] ~= true or (not self.zoneMarker and not self.placeMarker )then self:onBoolOptionsChange(3, true) end
	self.cursorType = "place"
	self:getCursor()
end
function CAMmod.UI:onSelectMoveSquare()
	--self.corpses = nil
	self.cursorType = "move"
	self:getCursor()
end
function CAMmod.UI:onSelectAreaSquare()
	if self.selectStart then 
		self.selectStart = false
	else
		self.selectStart = true
	end
	self.cursorType = "area"
	self.selectEnd = false
    self.startPos = nil
    self.endPos = nil
    CAMmod.startPos = nil
    CAMmod.endPos = nil
    self.zPos = self.chr:getZ()
    
end
----------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------
function CAMmod.UI:onSquareSelected(square,actionType)
	if self.cursorType == "zone" then
		self:removeZoneMarker();
		self.zoneX = square:getX();
		self.zoneY = square:getY();
		self.zoneZ = square:getZ();
		self:addMarker(square, self:getRadius(self.cursorType));
		--self.cursorType = "place"
		--self:getCursor()
	elseif self.cursorType == "place" then
		self.cursor = nil;
		if getCell():getDrag(self.chr:getPlayerNum()) then getCell():setDrag(nil, self.chr:getPlayerNum()) end
		self:removePlaceMarker();
		self.placeX = square:getX();
		self.placeY = square:getY();
		self.placeZ = square:getZ();
		self:addMarker(square, 1);
	elseif self.cursorType == "move" then
		CAMmod.setMoveAction(self.chr,square,actionType)
	end
end
function CAMmod.UI:clean()
	getSoundManager():playUISound("CAMmod_CleanMenu")
	CAMmod.getCleanSurface(self)
end
----------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------
function CAMmod.UI:onStart()
	CAMmod.started = true
	self:clean()
end
function CAMmod.UI:stopAction()
	CAMmod.started = nil
end
function CAMmod.UI:close()
	self:stopAction()
	if getCell():getDrag(self.chr:getPlayerNum()) then getCell():setDrag(nil, self.chr:getPlayerNum()) end
	self.cursor = nil
	CAMmod.removeList()
	getSoundManager():playUISound("CAMmod_CloseMenu")
	self:removeMarkers();
	self:removeArea()
	self:setVisible(false);
	self:removeFromUIManager();
end
function CAMmod.UI:getRadius(cursorType)
	local radius = 1
	if cursorType == "zone" then
		radius = tonumber(self.radiusSlider:getCurrentValue()) or 16
	end
	return radius
end
function CAMmod.UI:getFloor()
	return tonumber(self.floorNumberLabel.valueLabel) or 0
end

function CAMmod.UI:getCursor()
	self.cursor = CAMmod.ISSelectCursor:new(self.chr, self)
	getCell():setDrag(self.cursor, self.chr:getPlayerNum())
end
function CAMmod.UI:addMarker(square, radius)
	if self.cursorType == "zone" then
		self.zoneMarker = getWorldMarkers():addGridSquareMarker(square, 0.2, 0.2, 0.2, true, radius);--"circle_center", "circle_only_highlight",
		self.zoneMarker:setScaleCircleTexture(true);
	else
		self.placeMarker = getWorldMarkers():addGridSquareMarker(square, 0.8, 0.3, 0.0, true, radius);
		self.placeMarker:setScaleCircleTexture(true);
		local texName = nil; -- use default
		self.arrow2 = getWorldMarkers():addDirectionArrow(self.chr, self.placeX, self.placeY, self.placeZ, texName, 0.9, 0.3, 0.0, 0.6);
	end
end
function CAMmod.UI:removeZoneMarker()
	if self.zoneMarker then
		self.zoneMarker:remove();
		self.zoneMarker = nil;
	end
	if self.arrow then
		self.arrow:remove();
		self.arrow = nil;
	end
end
function CAMmod.UI:removePlaceMarker()
	if self.placeMarker then
		self.placeMarker:remove();
		self.placeMarker = nil;
	end
	if self.arrow2 then
		self.arrow2:remove();
		self.arrow2 = nil;
	end
end
function CAMmod.UI:removeMarkers()
	self:removePlaceMarker()
	self:removeZoneMarker()
end
function CAMmod.UI:removeArea()
	if self.endPos and self.startPos then
		CAMmod.removeArea(self.startPos,self.endPos,self.zPos)
	end
	self.selectStart = false
    self.selectEnd = false
    self.startPos = nil
    self.endPos = nil
    CAMmod.startPos = nil
    CAMmod.endPos = nil
end
----------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------
function CAMmod.UI:onMouseMove(dx, dy)
    self.mouseOver = true
    if self.moving then
        self:setX(self.x + dx)
        self:setY(self.y + dy)
        self:bringToTop()
    end
end
function CAMmod.UI:onMouseMoveOutside(dx, dy)
    self.mouseOver = false
    if self.moving then
        self:setX(self.x + dx)
        self:setY(self.y + dy)
        self:bringToTop()
    end
end
function CAMmod.UI:onMouseDown(x, y)
    if not self:getIsVisible() then
        return
    end
    self.downX = x
    self.downY = y
    self.moving = true
    self:bringToTop()
end
function CAMmod.UI:onMouseUp(x, y)
    if not self:getIsVisible() then
        return;
    end
    self.moving = false
    if ISMouseDrag.tabPanel then
        ISMouseDrag.tabPanel:onMouseUp(x,y)
    end
    ISMouseDrag.dragView = nil
end
function CAMmod.UI:onMouseUpOutside(x, y)
    if not self:getIsVisible() then
        return
    end
    self.moving = false
    ISMouseDrag.dragView = nil
end
function CAMmod.UI:onRightMouseDownOutside(x, y)
	self:removeArea()
end
function CAMmod.UI:onMouseDownOutside(x, y)
    local xx, yy = ISCoordConversion.ToWorld(getMouseXScaled(), getMouseYScaled(), self.zPos)
    if self.selectStart then
        self.startPos = { x = math.floor(xx), y = math.floor(yy) }
        CAMmod.startPos = self.startPos
        self.selectStart = false
        self.selectEnd = true
    elseif self.selectEnd then
        self.endPos = { x = math.floor(xx), y = math.floor(yy) }
        CAMmod.endPos = self.endPos
        self.selectEnd = false
        local bodies = CAMmod.getCorpsesByArea(self.chr,self.startPos,self.endPos)
		if #bodies <= 0 then self:removeArea() ; self.selectStart = true return end
    end
end
--************************************************************************--
--** CAMmod.UI:new
--**
--************************************************************************--
function CAMmod.UI:new(x, y, character, square)
	--local width = 357;
	--local height = 122;--147
	local widthScreen = getPlayerScreenWidth(character:getPlayerNum())
	local heightScreen = getPlayerScreenHeight(character:getPlayerNum())
	local width = widthScreen/5.5--math.ceil(getCore():getScreenWidth() / 5)
	local height = heightScreen/9--math.ceil(getCore():getScreenHeight() / 9)
	local o = ISCollapsableWindow.new(self, x, y, width, height);
	--o:setImage(getTexture("media/ui/imageT.png"))
	o.playerNum = character:getPlayerNum()
	--o:setTexture(getTexture("media/ui/CAMmod_Background.png"))
	if y == 0 then
		o.y = getPlayerScreenTop(o.playerNum) + (getPlayerScreenHeight(o.playerNum) - height) / 2
		o:setY(o.y)
	end
	if x == 0 then
		o.x = getPlayerScreenLeft(o.playerNum) + (getPlayerScreenWidth(o.playerNum) - width) --/ 2
		o:setX(o.x)
	end
	getSoundManager():playUISound("CAMmod_OpenMenu")
	o.widthScreen = widthScreen
	o.heightScreen = heightScreen
	o.borderColor = REDdown
	o.width = width;
	o.height = height;
	o.chr = getSpecificPlayer(0);
	o.moveWithMouse = true;
	o.zoneX = square:getX();
	o.zoneY = square:getY();
	o.zoneZ = square:getZ();
	o.placeX = square:getX();
	o.placeY = square:getY();
	o.placeZ = square:getZ();
	o.closeButtonTexture = getTexture("media/ui/CAMmod_quitButton.png");
	o.collapseButtonTexture = getTexture("media/ui/CAMmod_collapseButton.png.png");--"media/ui/CAMmod_collapseButton.png.png"
	o.pinButtonTexture = getTexture("media/ui/CAMmod_pinButton.png");
	o.pin = true
	o.isCollapsed = false;
	o.collapseCounter = 0;
	--o.titlebarbkg =
	o.anchorLeft = true;
	o.anchorRight = false;
	o.anchorTop = true;
	o.anchorBottom = false;
	o.resizable = false
	o.selectStart = false
    o.selectEnd = false
    o.startPos = nil
    o.endPos = nil
    o.zPos = square:getZ();

	return o;
end

return CAMmod


