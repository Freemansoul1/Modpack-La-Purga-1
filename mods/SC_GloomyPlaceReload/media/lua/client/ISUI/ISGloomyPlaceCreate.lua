-- By 🆂🅲🆁🅸🅱🅻
-- Discord: scribl

-- Я не против если вы будете исследовать мои модификации. Не копируйте модификацию!
-- I don't mind if you explore my modifications. Do not copy the modification!

require "ISUI/ISCollapsableWindow"
ISGloomyPlaceCreate = ISCollapsableWindow:derive("ISGloomyPlaceCreate");

function ISGloomyPlaceCreate:getPointID(x,y,z) return x..y..z; end

function ISGloomyPlaceCreate:render() ISCollapsableWindow.render(self); end

function ISGloomyPlaceCreate:prerender() ISCollapsableWindow.prerender(self); end

function ISGloomyPlaceCreate:show() self:addToUIManager(); self:setVisible(true); end

function ISGloomyPlaceCreate:close() self:setVisible(false); self:removeFromUIManager(); end

function ISGloomyPlaceCreate:onClick(btn)
    if btn.internal == "PLAYASRC" then
        local o = self.srcAnimAction.options[self.srcAnimAction.selected].data;
        if not o then return; end
        ISTimedActionQueue.clear(self.character);
        ISTimedActionQueue.add(ISGloomyPlaceDemoAnim:new(self.character, o.action, o.key, self.srcAnimVariable.options[self.srcAnimVariable.selected].data.variable));
        return;
    end
    if btn.internal == "PLAYADST" then
        local o = self.dstAnimAction.options[self.dstAnimAction.selected].data;
        if not o then return; end
        ISTimedActionQueue.clear(self.character);
        ISTimedActionQueue.add(ISGloomyPlaceDemoAnim:new(self.character, o.action, o.key, self.dstAnimVariable.options[self.dstAnimVariable.selected].data.variable));
        return;
    end
    if btn.internal == "PLAYSOSRC" then
        getSoundManager():playUISound(self.soundEnter:getText());
        return;
    end
    if btn.internal == "PLAYSODST" then
        getSoundManager():playUISound(self.soundExit:getText());
        return;
    end
    if btn.internal == "SEND" then
        --SC_GloomyPlaceReload:setTeleport(self.src,self.dst,1,false);
        --{action = "Loot", key= "LootPosition", variable = {"Low","","High"}});
        self.createTeleport:setEnable(false);

        self.src.anode = self.srcAnimAction.options[self.srcAnimAction.selected].data.action;
        self.dst.anode = self.dstAnimAction.options[self.dstAnimAction.selected].data.action;
        self.src.akey = self.srcAnimVariable.options[self.srcAnimVariable.selected].data.key;
        self.dst.akey = self.dstAnimVariable.options[self.dstAnimVariable.selected].data.key;
        self.src.avar = self.srcAnimVariable.options[self.srcAnimVariable.selected].data.variable;
        self.dst.avar = self.dstAnimVariable.options[self.dstAnimVariable.selected].data.variable;
        self.src.sound = self.soundEnter:getText();
        self.dst.sound = self.soundExit:getText();
        self.src.marker = self.srcMarkerType.selected;
        self.dst.marker = self.dstMarkerType.selected;
        self.src.isAnim = self.srcOtherParams:isSelected(1);
        self.dst.isAnim = self.dstOtherParams:isSelected(1);
        self.src.isSound = self.srcOtherParams:isSelected(2);
        self.dst.isSound = self.dstOtherParams:isSelected(2);
        self.src.isMarker = self.srcOtherParams:isSelected(3);
        self.dst.isMarker = self.dstOtherParams:isSelected(3);
        self.src.toOne = self.srcOtherParams:isSelected(4);

        -- Shop And Traders Intergration
        if SandboxVars.SCGloomyPlaceReload.ShopAndTraderIntergration then
            self.src.isPayToGo = self.srcOtherParams:isSelected(5);
            self.src.costPassage = tonumber(self.srcPaidPassage:getText());
            self.dst.isPayToGo = self.dstOtherParams:isSelected(4);
            self.dst.costPassage = tonumber(self.dstPaidPassage:getText());
        end

        self.src.toX = self.dst.x;
        self.src.toY = self.dst.y;
        self.src.toZ = self.dst.z;
        self.dst.toX = self.src.x;
        self.dst.toY = self.src.y;
        self.dst.toZ = self.src.z;

        self.src.isEnter = true;
        self.dst.isEnter = false;
        self.src.timedaction = tonumber(self.srcTimedAction:getText());
        self.dst.timedaction = tonumber(self.dstTimedAction:getText());

        SC_GloomyPlaceReload.BackupCoords();

        self.src.gprid = self:getPointID(self.src.x, self.src.y, self.src.z);
        self.dst.gprid = self:getPointID(self.dst.x, self.dst.y, self.dst.z);
        SC_GloomyPlaceReload.TeleportTo(self.character,self.src);
        local ticks = 0;
        local function DELAY_SRC()
            if ticks < SandboxVars.SCGloomyPlaceReload.DelayAdminCreate then ticks = ticks + 1; return; end
            SC_GloomyPlaceReload:setTeleport(self.src, false);
            Events.OnTick.Remove(DELAY_SRC);
            if self.src.toOne then
                self.alertLabel.text = " <CENTRE> <RGB:0,1,0> "..getText("UI_GPRStatusCreate");
                self.alertLabel:paginate();
                SC_GloomyPlaceReload.TeleportTo(self.character,SC_GloomyPlaceReload.Backup);
                return; 
            end
            SC_GloomyPlaceReload.TeleportTo(self.character,self.dst);
            ticks = 0;
            local function DELAY_DST()
                if ticks < SandboxVars.SCGloomyPlaceReload.DelayAdminCreate then ticks = ticks + 1; return; end
                SC_GloomyPlaceReload:setTeleport(self.dst, false);
                Events.OnTick.Remove(DELAY_DST);
                self.alertLabel.text = " <CENTRE> <RGB:0,1,0> "..getText("UI_GPRStatusCreate");
                self.alertLabel:paginate();
                SC_GloomyPlaceReload.TeleportTo(self.character,SC_GloomyPlaceReload.Backup);
            end
            Events.OnTick.Add(DELAY_DST);
        end
        Events.OnTick.Add(DELAY_SRC);
        --self:close();
        return;
    end
end

function ISGloomyPlaceCreate:cheakSquare(sq)
    self.createTeleport:setEnable(false);
    if self.src.x > 0 and self.dst.x > 0 and sq:getModData()[SC_GloomyPlaceReload.moduleName] == nil then
        self.createTeleport:setEnable(true);
    end
end

function ISGloomyPlaceCreate:onSquareSelected(square)
    self.cursor = nil;
    local coords = "";
    if self.onSelect then
        self.src.x = square:getX() or 0;
        self.src.y = square:getY() or 0;
        self.src.z = square:getZ() or 0;
        coords = "X="..self.src.x.." | Y="..self.src.y.." | Z="..self.src.z;
        self.srcLabel:setName(coords);
    else
        self.dst.x = square:getX() or 0;
        self.dst.y = square:getY() or 0;
        self.dst.z = square:getZ() or 0;
        coords = "X="..self.dst.x.." | Y="..self.dst.y.." | Z="..self.dst.z;
        self.dstLabel:setName(coords);
    end
    self:cheakSquare(square);
end

function ISGloomyPlaceCreate:onSelectSquareSrc()
    self.onSelect = true;
    self.cursor = ISSelectCursor:new(self.character, self, self.onSquareSelected);
	getCell():setDrag(self.cursor, self.character:getPlayerNum());
end

function ISGloomyPlaceCreate:onSelectSquareDst()
    self.onSelect = false;
    self.cursor = ISSelectCursor:new(self.character, self, self.onSquareSelected);
	getCell():setDrag(self.cursor, self.character:getPlayerNum());
end

function ISGloomyPlaceCreate:loadAnimations(isSource)
    if isSource then
        for _, val in ipairs(SC_GloomyPlaceReload_Animations) do
            self.srcAnimAction:addOptionWithData(val.action, val);
        end 
    else
        for _, val in ipairs(SC_GloomyPlaceReload_Animations) do
            self.dstAnimAction:addOptionWithData(val.action, val);
        end 
    end
    --{action = "Loot", key= "LootPosition", variable = {"Low","","High"}});
end

function ISGloomyPlaceCreate:dstAnimActionOnChange()
    local tooltipMap = self.dstAnimVariable.tooltip;
    self.dstAnimVariable:clear();
    self.dstAnimVariable:setToolTipMap(tooltipMap);
    for _,val in ipairs(self.dstAnimAction.options[self.dstAnimAction.selected].data.variable) do
        if val == nil then
            self.dstAnimVariable:setVisible(false); 
            return;
        end
        self.dstAnimVariable:addOptionWithData(val,{ key = self.dstAnimAction.options[self.dstAnimAction.selected].data.key, variable = val });
    end 
    self.dstAnimVariable:setVisible(true); 
end

function ISGloomyPlaceCreate:srcAnimActionOnChange()
    local tooltipMap = self.srcAnimVariable.tooltip;
    self.srcAnimVariable:clear();
    self.srcAnimVariable:setToolTipMap(tooltipMap);
    for _,val in ipairs(self.srcAnimAction.options[self.srcAnimAction.selected].data.variable) do
        if val == nil then
            self.srcAnimVariable:setVisible(false); 
            return;
        end
        self.srcAnimVariable:addOptionWithData(val,{ key = self.srcAnimAction.options[self.srcAnimAction.selected].data.key, variable = val });
    end 
    self.srcAnimVariable:setVisible(true); 
end

function ISGloomyPlaceCreate:onChangeTeleportToOne()
    --[[if self.playAnimSrc:isSelected(3) then
        self.rectDst:setVisible(false);
        self.labelExit:setVisible(false);
        self.dstLabel:setVisible(false);
        self.pickNewSqDst:setVisible(false);
        return;
    end
    self.rectDst:setVisible(true);
    self.labelExit:setVisible(true);
    self.dstLabel:setVisible(true);
    self.pickNewSqDst:setVisible(true);]]--
end

function ISGloomyPlaceCreate:createChildren()
    ISCollapsableWindow.createChildren(self)
    
    local x, y = 10, 20;
    local fontHgt =  getTextManager():getFontHeight(UIFont.NewSmall);

    local rectSrc = ISRect:new(5, y, 190 , fontHgt*2 + 65, 1, 0.4, 0.4, 0.4)
    rectSrc:initialise();

    self:addChild(rectSrc);

    local label = ISLabel:new(x, rectSrc:getY()+5, fontHgt, getText("UI_GPRCoordsToEnter"), 1, 1, 1, 1, UIFont.NewSmall, true);
    label:initialise();
    label:instantiate();
    self:addChild(label);

    --ISSpawnHordeUI
    local text = "X=0 | Y=0 | Z=0";
    self.srcLabel = ISLabel:new(x, label:getBottom() + 5, fontHgt, text, 1, 1, 1, 1, UIFont.NewSmall, true);
    self.srcLabel:initialise();
    self.srcLabel:instantiate();
    self:addChild(self.srcLabel);

	self.pickNewSqSrc = ISButton:new(x, self.srcLabel:getBottom() + 5, 200-x*2, 20, getText("UI_GPRSelectSQPoint"), self, self.onSelectSquareSrc);
	self.pickNewSqSrc:initialise();
	self.pickNewSqSrc:instantiate();
	self:addChild(self.pickNewSqSrc);

    self.srcAnimAction = ISComboBox:new(x, self.pickNewSqSrc:getBottom() + 5 , 200-x*2, 20, self, self.srcAnimActionOnChange);
	self.srcAnimAction:initialise();
    self.srcAnimAction:setToolTipMap({ defaultTooltip = getText("UI_GPRSelectAnim") });
	self:addChild(self.srcAnimAction);
    self.srcAnimAction.selected = 1;
    self:loadAnimations(true);

    self.srcAnimVariable = ISComboBox:new(x, self.srcAnimAction:getBottom() + 5 ,200-x*2, 20, self);
    self.srcAnimVariable:initialise();
    self.srcAnimVariable:setToolTipMap({ defaultTooltip = getText("UI_GPRSelectAnimVariant") });
    self:addChild(self.srcAnimVariable);
    self:srcAnimActionOnChange();

    self.playSrcAnim = ISButton:new(x, self.srcAnimVariable:getBottom() + 5, 200-x*2, 20, getText("UI_GPRPlayAnimation"), self, self.onClick);
    self.playSrcAnim.internal = "PLAYASRC";
	self.playSrcAnim:initialise();
	self.playSrcAnim:instantiate();
	self:addChild(self.playSrcAnim);

    self.soundEnter = ISTextEntryBox:new("GPRDefEnter", x, self.playSrcAnim:getBottom() + 5, 200-x*2, 20);
    self.soundEnter.font = UIFont.NewSmall;
	self.soundEnter:initialise();
	self.soundEnter:instantiate();
    self.soundEnter.tooltip = getText("UI_GPRSoundEnter");
    self:addChild(self.soundEnter);

    self.playSrcSound = ISButton:new(x, self.soundEnter:getBottom() + 5, 200-x*2, 20, getText("UI_GPRSoundPlay"), self, self.onClick);
    self.playSrcSound.internal = "PLAYSOSRC";
	self.playSrcSound:initialise();
	self.playSrcSound:instantiate();
	self:addChild(self.playSrcSound);
    
    self.srcMarkerType = ISComboBox:new(x, self.playSrcSound:getBottom() + 5 , 200-x*2, 20, self);
	self.srcMarkerType:initialise();
    self.srcMarkerType:addOption(getText("UI_GPRMarkerCenterUP")); --1
    self.srcMarkerType:addOption(getText("UI_GPRMarkerCenterMid")); -- 2
    self.srcMarkerType:addOption(getText("UI_GPRMarkerCenterDown")); -- 3
    self.srcMarkerType:addOption(getText("UI_GPRMarkerCenterVeryDown")); -- 4
	self.srcMarkerType:addOption(getText("UI_GPRMarkerNWUp")); -- 5
    self.srcMarkerType:addOption(getText("UI_GPRMarkerNWMid")); -- 6
    self.srcMarkerType:addOption(getText("UI_GPRMarkerNWDown")); -- 7
    self.srcMarkerType:addOption(getText("UI_GPRMarkerNEUp")); -- 8
    self.srcMarkerType:addOption(getText("UI_GPRMarkerNEMid")); -- 9
    self.srcMarkerType:addOption(getText("UI_GPRMarkerNEDown")); -- 10
    self.srcMarkerType:addOption(getText("UI_GPRMarkerSWUp")); -- 11
    self.srcMarkerType:addOption(getText("UI_GPRMarkerSWMid")); -- 12
    self.srcMarkerType:addOption(getText("UI_GPRMarkerSWDown")); -- 13
    self.srcMarkerType:addOption(getText("UI_GPRMarkerSEUp")); -- 14
    self.srcMarkerType:addOption(getText("UI_GPRMarkerSEMid")); -- 15
    self.srcMarkerType:addOption(getText("UI_GPRMarkerSEDown")); -- 16
    self.srcMarkerType:setToolTipMap({ defaultTooltip = getText("UI_GPRSelectMarker") });
    self.srcMarkerType.selected = 1;
	self:addChild(self.srcMarkerType);

    self.srcTimedAction = ISTextEntryBox:new("35", x, self.srcMarkerType:getBottom() + 5, 200-x*2, 20);
    self.srcTimedAction.font = UIFont.NewSmall;
	self.srcTimedAction:initialise();
	self.srcTimedAction:instantiate();
    self.srcTimedAction:setOnlyNumbers(true);
    self.srcTimedAction.tooltip = getText("UI_GPRTimedAction");
    self:addChild(self.srcTimedAction);

    self.srcOtherParams = ISTickBox:new(x, self.srcTimedAction:getBottom() + 5, 20, 200-x*2, "", self, self.onChangeTeleportToOne)
    --self.srcOtherParams.tooltip = getText("UI_SC");
    self.srcOtherParams:initialise()
    self:addChild(self.srcOtherParams)
    self.srcOtherParams:addOption(getText("UI_GPRAnimationEnable"));
    self.srcOtherParams:setSelected(1, true);
    self.srcOtherParams:addOption(getText("UI_GPRSoundEnable"));
    self.srcOtherParams:setSelected(2, true);
    self.srcOtherParams:addOption(getText("UI_GPREnableMarker"));
    self.srcOtherParams:setSelected(3, true);
    self.srcOtherParams:addOption(getText("UI_GPRToOneEnable"));

    rectSrc:setHeight(self.srcOtherParams:getBottom()+5);
 
    -- Shop And Traders Intergration by request SwedishYodeler https://steamcommunity.com/id/SwedishYodeler
    if SandboxVars.SCGloomyPlaceReload.ShopAndTraderIntergration then
        self.srcOtherParams:addOption(getText("UI_GPRPaidPassage"));
        self.srcPaidPassage = ISTextEntryBox:new("10", x, self.srcOtherParams:getBottom() + 5, 200-10*2, 20);
        self.srcPaidPassage.font = UIFont.NewSmall;
        self.srcPaidPassage:initialise();
        self.srcPaidPassage:instantiate();
        self.srcPaidPassage:setOnlyNumbers(true);
        self.srcPaidPassage.tooltip = getText("UI_GPRPaidPassageCount");
        self:addChild(self.srcPaidPassage);
        rectSrc:setHeight(self.srcPaidPassage:getBottom()+5);
    end
    
    x = 205;
    self.rectDst = ISRect:new(200, 20, 190 , rectSrc:getHeight(), 1, 0.4, 0.4, 0.4)
    self.rectDst:initialise();
    self:addChild(self.rectDst);

    label = ISLabel:new(x , self.rectDst:getY() + 5, fontHgt, getText("UI_GPRCoordsToExit"), 1, 1, 1, 1, UIFont.NewSmall, true);
    label:initialise();
    label:instantiate();
    self:addChild(label);

    self.dstLabel = ISLabel:new(x, label:getBottom() + 5, fontHgt, text, 1, 1, 1, 1, UIFont.NewSmall, true);
    self.dstLabel:initialise();
    self.dstLabel:instantiate();
    self:addChild(self.dstLabel);

    self.pickNewSqDst = ISButton:new(x, self.dstLabel:getBottom() + 5, 200-10*2, 20, getText("UI_GPRSelectSQPoint"), self, self.onSelectSquareDst);
	self.pickNewSqDst:initialise();
	self.pickNewSqDst:instantiate();
	self:addChild(self.pickNewSqDst);

    self.dstAnimAction = ISComboBox:new(x, self.pickNewSqDst:getBottom() + 5 , 200-10*2, 20, self, self.dstAnimActionOnChange);
	self.dstAnimAction:initialise();
    self.dstAnimAction:setToolTipMap({ defaultTooltip = getText("UI_GPRSelectAnim") });
	self:addChild(self.dstAnimAction);
    self.dstAnimAction.selected = 1;
    self:loadAnimations(false);

    self.dstAnimVariable = ISComboBox:new(x, self.dstAnimAction:getBottom() + 5 ,200-10*2, 20, self);
    self.dstAnimVariable:initialise();
    self.dstAnimVariable:setToolTipMap({ defaultTooltip = getText("UI_GPRSelectAnimVariant") });
    self:addChild(self.dstAnimVariable);
    self:dstAnimActionOnChange();

    self.playDstAnim = ISButton:new(x, self.dstAnimVariable:getBottom() + 5, 200-10*2, 20, getText("UI_GPRPlayAnimation"), self, self.onClick);
    self.playDstAnim.internal = "PLAYADST";
	self.playDstAnim:initialise();
	self.playDstAnim:instantiate();
	self:addChild(self.playDstAnim);

    self.soundExit = ISTextEntryBox:new("GPRDefExit", x, self.playDstAnim:getBottom() + 5, 200-10*2, 20);
    self.soundExit.font = UIFont.NewSmall;
	self.soundExit:initialise();
	self.soundExit:instantiate();
    self.soundExit.tooltip = getText("UI_GPRSoundEnter");
    self:addChild(self.soundExit);

    self.playDstSound = ISButton:new(x, self.soundExit:getBottom() + 5, 200-10*2, 20, getText("UI_GPRSoundPlay"), self, self.onClick);
    self.playDstSound.internal = "PLAYSODST";
	self.playDstSound:initialise();
	self.playDstSound:instantiate();
	self:addChild(self.playDstSound);
    
    self.dstMarkerType = ISComboBox:new(x, self.playDstSound:getBottom() + 5 , 200-10*2, 20, self);
	self.dstMarkerType:initialise();
    self.dstMarkerType:addOption(getText("UI_GPRMarkerCenterUP"));
    self.dstMarkerType:addOption(getText("UI_GPRMarkerCenterMid"));
    self.dstMarkerType:addOption(getText("UI_GPRMarkerCenterDown"));
    self.dstMarkerType:addOption(getText("UI_GPRMarkerCenterVeryDown"));
	self.dstMarkerType:addOption(getText("UI_GPRMarkerNWUp"));
    self.dstMarkerType:addOption(getText("UI_GPRMarkerNWMid"));
    self.dstMarkerType:addOption(getText("UI_GPRMarkerNWDown"));
    self.dstMarkerType:addOption(getText("UI_GPRMarkerNEUp"));
    self.dstMarkerType:addOption(getText("UI_GPRMarkerNEMid"));
    self.dstMarkerType:addOption(getText("UI_GPRMarkerNEDown"));
    self.dstMarkerType:addOption(getText("UI_GPRMarkerSWUp"));
    self.dstMarkerType:addOption(getText("UI_GPRMarkerSWMid"));
    self.dstMarkerType:addOption(getText("UI_GPRMarkerSWDown"));
    self.dstMarkerType:addOption(getText("UI_GPRMarkerSEUp"));
    self.dstMarkerType:addOption(getText("UI_GPRMarkerSEMid"));
    self.dstMarkerType:addOption(getText("UI_GPRMarkerSEDown"));
    self.dstMarkerType:setToolTipMap({ defaultTooltip = getText("UI_GPRSelectMarker") });
    self.dstMarkerType.selected = 1;
	self:addChild(self.dstMarkerType);

    self.dstTimedAction = ISTextEntryBox:new("35", x, self.dstMarkerType:getBottom() + 5, 200-10*2, 20);
    self.dstTimedAction.font = UIFont.NewSmall;
	self.dstTimedAction:initialise();
	self.dstTimedAction:instantiate();
    self.dstTimedAction:setOnlyNumbers(true);
    self.dstTimedAction.tooltip = getText("UI_GPRTimedAction");
    self:addChild(self.dstTimedAction);

    self.dstOtherParams = ISTickBox:new(x, self.dstTimedAction:getBottom() + 5, 20, 200-10*2, "", self, self.onChangeTeleportToOne)
    --self.dstOtherParams.tooltip = getText("UI_SC");
    self.dstOtherParams:initialise()
    self:addChild(self.dstOtherParams)
    self.dstOtherParams:addOption(getText("UI_GPRAnimationEnable"));
    self.dstOtherParams:setSelected(1, true);
    self.dstOtherParams:addOption(getText("UI_GPRSoundEnable"));
    self.dstOtherParams:setSelected(2, true);
    self.dstOtherParams:addOption(getText("UI_GPREnableMarker"));
    self.dstOtherParams:setSelected(3, true);

    -- Shop And Traders Intergration
    if SandboxVars.SCGloomyPlaceReload.ShopAndTraderIntergration then
        self.dstOtherParams:addOption(getText("UI_GPRPaidPassage"));
        self.dstPaidPassage = ISTextEntryBox:new("10", x, self.dstOtherParams:getBottom() + 5, 200-10*2, 20);
        self.dstPaidPassage.font = UIFont.NewSmall;
        self.dstPaidPassage:initialise();
        self.dstPaidPassage:instantiate();
        self.dstPaidPassage:setOnlyNumbers(true);
        self.dstPaidPassage.tooltip = getText("UI_GPRPaidPassageCount");
        self:addChild(self.dstPaidPassage);
    end

    self.alertLabel = ISRichTextPanel:new(5, rectSrc:getBottom() + 5, self.width-10, 40);
    self.alertLabel.autosetheight = false;
    self.alertLabel:initialise();
    self.alertLabel:setMargins(0,0,0,0);
	self:addChild( self.alertLabel);
    self.alertLabel.text = " <CENTRE> "..getText("UI_GPRMsgOnCreate");
    self.alertLabel:paginate();

    self.createTeleport = ISButton:new(5, self.alertLabel:getBottom() + 5, self.width-10, 20, getText("UI_GPRCreateTeleport"), self, self.onClick);
    self.createTeleport.internal = "SEND";
    self.createTeleport:initialise();
	self.createTeleport:instantiate();
    self:addChild(self.createTeleport);
    self.createTeleport:setEnable(false);
    self:setHeight(self.createTeleport:getBottom() + 5);

end

function ISGloomyPlaceCreate:new()
    local o = {};
    local windowWidth = 395;
    local windowHeight = 150;
    local sWidth = getCore():getScreenWidth()/2;
    local sHeight = getCore():getScreenHeight();
    local x = (sWidth - windowWidth)/2;
    local y = (sHeight - windowHeight)/2;
    o = ISCollapsableWindow:new(x, y, windowWidth, windowHeight);
    setmetatable(o, self);
    self.__index = self;
    o.character = getPlayer();
    o.width = windowWidth;
	o.height = windowHeight;
    o.lastPosition = {}
    o.src, o.dst = { x = 0 }, { x = 0};

    o.resizable = false;
    o.title = getText("UI_GPRCreateTeleport");
    return o;
end