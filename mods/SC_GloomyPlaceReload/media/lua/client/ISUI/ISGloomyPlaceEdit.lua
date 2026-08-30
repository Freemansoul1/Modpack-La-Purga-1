-- By 🆂🅲🆁🅸🅱🅻
-- Discord: scribl

-- Я не против если вы будете исследовать мои модификации. Не копируйте модификацию!
-- I don't mind if you explore my modifications. Do not copy the modification!

require "ISUI/ISCollapsableWindow"
ISGloomyPlaceEdit = ISCollapsableWindow:derive("ISGloomyPlaceEdit");

function ISGloomyPlaceEdit:getPointID(x,y,z) return x..y..z; end

function ISGloomyPlaceEdit:render() ISCollapsableWindow.render(self); end

function ISGloomyPlaceEdit:prerender() ISCollapsableWindow.prerender(self); end

function ISGloomyPlaceEdit:show() self:addToUIManager(); self:setVisible(true); end

function ISGloomyPlaceEdit:close() self:setVisible(false); self:removeFromUIManager(); end

function ISGloomyPlaceEdit:loadAnimations()
    for _, val in ipairs(SC_GloomyPlaceReload_Animations) do
        self.AnimAction:addOptionWithData(val.action, val);
    end 
    --{action = "Loot", key= "LootPosition", variable = {"Low","","High"}});
end

function ISGloomyPlaceEdit:animActionOnChange()
    local tooltipMap = self.AnimVariable.tooltip;
    self.AnimVariable:clear();
    self.AnimVariable:setToolTipMap(tooltipMap);
    for _,val in ipairs(self.AnimAction.options[self.AnimAction.selected].data.variable) do
        if val == nil then
            self.AnimVariable:setVisible(false); 
            return;
        end
        self.AnimVariable:addOptionWithData(val,{ key = self.AnimAction.options[self.AnimAction.selected].data.key, variable = val });
    end 
    self.AnimVariable:setVisible(true); 
end

function ISGloomyPlaceEdit:onClick(btn)
    if btn.internal == "PLAYANIMATION" then
        local o = self.AnimAction.options[self.AnimAction.selected].data;
        if not o then return; end
        ISTimedActionQueue.clear(self.character);
        ISTimedActionQueue.add(ISGloomyPlaceDemoAnim:new(self.character, o.action, o.key, self.AnimVariable.options[self.AnimVariable.selected].data.variable));
        return;
    end
    if btn.internal == "PLAYSOUND" then
        getSoundManager():playUISound(self.soundPoint:getText());
        return;
    end
    if btn.internal == "TELEPORTEDITEDPOINT" then
        SC_GloomyPlaceReload.TeleportTo(self.character, self.coordsEdited);
        return;
    end
    if btn.internal == "FASTTELEPORT" then
        SC_GloomyPlaceReload.TeleportTo(self.character, self.coords);
        self.coordsSwith = not self.coordsSwith;
        self:switchCoords();
        return;
    end
    if btn.internal == "SEND" then
        self.settings.anode = self.AnimAction.options[self.AnimAction.selected].data.action;
        self.settings.akey = self.AnimVariable.options[self.AnimVariable.selected].data.key;
        self.settings.avar = self.AnimVariable.options[self.AnimVariable.selected].data.variable;
        self.settings.sound = self.soundPoint:getText();
        self.settings.timedaction = tonumber(self.TimedAction:getText());
        self.settings.marker = self.MarkerType.selected;
        self.settings.isAnim = self.OtherParams:isSelected(1);
        self.settings.isSound = self.OtherParams:isSelected(2);
        self.settings.isMarker = self.OtherParams:isSelected(3);
        -- Shop And Traders Intergration
        if SandboxVars.SCGloomyPlaceReload.ShopAndTraderIntergration then
            self.settings.isPayToGo = self.OtherParams:isSelected(5);
            self.settings.costPassage = tonumber(self.PaidPassage:getText());
        end
        SC_GloomyPlaceReload:setTeleport(self.settings, false);
    end
end

function ISGloomyPlaceEdit:createChildren()
    ISCollapsableWindow.createChildren(self);

    local x, y = 10, 20;
    local fontHgt =  getTextManager():getFontHeight(UIFont.NewSmall);

    self.srcLabel = ISLabel:new(x, y, fontHgt, string.format("FROM X=%s | Y=%s | Z=%s", self.settings.x, self.settings.y, self.settings.z), 1, 1, 1, 1, UIFont.NewSmall, true);
    self.srcLabel:initialise();
    self.srcLabel:instantiate();
    self:addChild(self.srcLabel);

    self.dstLabel = ISLabel:new(x, self.srcLabel:getBottom() + 5, fontHgt, string.format("TO X=%s | Y=%s | Z=%s", self.settings.toX, self.settings.toY, self.settings.toZ), 1, 1, 1, 1, UIFont.NewSmall, true);
    self.dstLabel:initialise();
    self.dstLabel:instantiate();
    self:addChild(self.dstLabel);

    self.teleportFast = ISButton:new(x, self.dstLabel:getBottom() + 5, 200-10*2, 20, getText("UI_GPRSwitchTeleport"), self, self.onClick);
    self.teleportFast.internal = "FASTTELEPORT";
    self.teleportFast.tooltip = getText("UI_GPRSwitchTeleportTooltip");
	self.teleportFast:initialise();
	self.teleportFast:instantiate();
	self:addChild(self.teleportFast);
    
    self.AnimAction = ISComboBox:new(x, self.teleportFast:getBottom() + 5 , 200-x*2, 20, self, self.animActionOnChange);
	self.AnimAction:initialise();
    self.AnimAction:setToolTipMap({ defaultTooltip = getText("UI_GPRSelectAnim") });
	self:addChild(self.AnimAction);
    self.AnimAction.selected = 1;
    self:loadAnimations();
    self.AnimAction:select(self.settings.anode);

    self.AnimVariable = ISComboBox:new(x, self.AnimAction:getBottom() + 5 ,200-x*2, 20, self);
    self.AnimVariable:initialise();
    self.AnimVariable:setToolTipMap({ defaultTooltip = getText("UI_GPRSelectAnimVariant") });
    self:addChild(self.AnimVariable);
    self:animActionOnChange();
    self.AnimVariable:select(self.settings.avar);

    self.playAnim = ISButton:new(x, self.AnimVariable:getBottom() + 5, 200-x*2, 20, getText("UI_GPRPlayAnimation"), self, self.onClick);
    self.playAnim.internal = "PLAYANIMATION";
	self.playAnim:initialise();
	self.playAnim:instantiate();
	self:addChild(self.playAnim);

    self.soundPoint = ISTextEntryBox:new(self.settings.sound or "", x, self.playAnim:getBottom() + 5, 200-x*2, 20);
    self.soundPoint.font = UIFont.NewSmall;
	self.soundPoint:initialise();
	self.soundPoint:instantiate();
    self.soundPoint.tooltip = getText("UI_GPRsoundPoint");
    self:addChild(self.soundPoint);

    self.playSound = ISButton:new(x, self.soundPoint:getBottom() + 5, 200-x*2, 20, getText("UI_GPRSoundPlay"), self, self.onClick);
    self.playSound.internal = "PLAYSOUND";
	self.playSound:initialise();
	self.playSound:instantiate();
	self:addChild(self.playSound);
    
    self.MarkerType = ISComboBox:new(x, self.playSound:getBottom() + 5 , 200-x*2, 20, self);
	self.MarkerType:initialise();
    self.MarkerType:addOption(getText("UI_GPRMarkerCenterUP")); --1
    self.MarkerType:addOption(getText("UI_GPRMarkerCenterMid")); -- 2
    self.MarkerType:addOption(getText("UI_GPRMarkerCenterDown")); -- 3
    self.MarkerType:addOption(getText("UI_GPRMarkerCenterVeryDown")); -- 4
	self.MarkerType:addOption(getText("UI_GPRMarkerNWUp")); -- 5
    self.MarkerType:addOption(getText("UI_GPRMarkerNWMid")); -- 6
    self.MarkerType:addOption(getText("UI_GPRMarkerNWDown")); -- 7
    self.MarkerType:addOption(getText("UI_GPRMarkerNEUp")); -- 8
    self.MarkerType:addOption(getText("UI_GPRMarkerNEMid")); -- 9
    self.MarkerType:addOption(getText("UI_GPRMarkerNEDown")); -- 10
    self.MarkerType:addOption(getText("UI_GPRMarkerSWUp")); -- 11
    self.MarkerType:addOption(getText("UI_GPRMarkerSWMid")); -- 12
    self.MarkerType:addOption(getText("UI_GPRMarkerSWDown")); -- 13
    self.MarkerType:addOption(getText("UI_GPRMarkerSEUp")); -- 14
    self.MarkerType:addOption(getText("UI_GPRMarkerSEMid")); -- 15
    self.MarkerType:addOption(getText("UI_GPRMarkerSEDown")); -- 16
    self.MarkerType:setToolTipMap({ defaultTooltip = getText("UI_GPRSelectMarker") });
    self.MarkerType.selected = self.settings.marker;
	self:addChild(self.MarkerType);

    self.TimedAction = ISTextEntryBox:new(tostring(self.settings.timedaction) or "35", x, self.MarkerType:getBottom() + 5, 200-x*2, 20);
    self.TimedAction.font = UIFont.NewSmall;
	self.TimedAction:initialise();
	self.TimedAction:instantiate();
    self.TimedAction:setOnlyNumbers(true);
    self.TimedAction.tooltip = getText("UI_GPRTimedAction");
    self:addChild(self.TimedAction);

    self.OtherParams = ISTickBox:new(x, self.TimedAction:getBottom() + 5, 20, 200-x*2, "", self, self.onChangeTeleportToOne)
    self.OtherParams:initialise();
    self:addChild(self.OtherParams);
    self.OtherParams:addOption(getText("UI_GPRAnimationEnable"));
    self.OtherParams:setSelected(1, self.settings.isAnim);
    self.OtherParams:addOption(getText("UI_GPRSoundEnable"));
    self.OtherParams:setSelected(2, self.settings.isSound);
    self.OtherParams:addOption(getText("UI_GPREnableMarker"));
    self.OtherParams:setSelected(3, self.settings.isMarker);

    self.OtherParams:addOption(getText("UI_GPRToOneEnable"));
    self.OtherParams:setSelected(4, self.settings.toOne);
    self.OtherParams:disableOption(getText("UI_GPRToOneEnable"), true);

    -- Shop And Traders Intergration by request SwedishYodeler https://steamcommunity.com/id/SwedishYodeler
    if SandboxVars.SCGloomyPlaceReload.ShopAndTraderIntergration then
        self.OtherParams:addOption(getText("UI_GPRPaidPassage"));
        self.OtherParams:setSelected(5, self.settings.isPayToGo or false);
        self.PaidPassage = ISTextEntryBox:new(tostring(self.settings.costPassage) or "10", x, self.OtherParams:getBottom() + 5, 200-10*2, 20);
        self.PaidPassage.font = UIFont.NewSmall;
        self.PaidPassage:initialise();
        self.PaidPassage:instantiate();
        self.PaidPassage:setOnlyNumbers(true);
        self.PaidPassage.tooltip = getText("UI_GPRPaidPassageCount");
        self:addChild(self.PaidPassage);
    end

    self.alertLabel = ISRichTextPanel:new(5,( self.PaidPassage:getBottom() or self.OtherParams:getBottom() ) + 5, self.width-10, 50);
    self.alertLabel.autosetheight = false;
    self.alertLabel:initialise();
    self.alertLabel:setMargins(0,0,0,0);
	self:addChild( self.alertLabel);
    self.alertLabel.text = " <CENTRE> "..getText("UI_GPRMsgOnEdit");
    self.alertLabel:paginate();

    self.teleportToEdited = ISButton:new(x, self.alertLabel:getBottom() + 5, 200-10*2, 20, getText("UI_GPREditedTeleport"), self, self.onClick);
    self.teleportToEdited.internal = "TELEPORTEDITEDPOINT";
    self.teleportToEdited.tooltip = getText("UI_GPREditedTeleportTooltip");
	self.teleportToEdited:initialise();
	self.teleportToEdited:instantiate();
	self:addChild(self.teleportToEdited);

    self.updateTeleport = ISButton:new(x, self.teleportToEdited:getBottom() + 5, self.width-20, 20, getText("UI_GPREditTeleportBtn"), self, self.onClick);
    self.updateTeleport.internal = "SEND";
    self.updateTeleport:initialise();
	self.updateTeleport:instantiate();
    self:addChild(self.updateTeleport);
    self:setHeight(self.updateTeleport:getBottom() + 5);

end

function ISGloomyPlaceEdit:switchCoords()
    if self.coordsSwith then
        self.coords = { x = self.settings.x, y = self.settings.y, z = self.settings.z };
        --self.srcLabe:setColor(r,g,b) 
    else
        self.coords = { x = self.settings.toX, y = self.settings.toY, z = self.settings.toZ };
    end
end

function ISGloomyPlaceEdit:new(settings)
    local o = {};
    local windowWidth = 200;
    local windowHeight = 150;
    local sWidth = getCore():getScreenWidth()/2;
    local sHeight = getCore():getScreenHeight();
    local x = (sWidth - windowWidth)/2;
    local y = (sHeight - windowHeight)/2;
    o = ISCollapsableWindow:new(x, y, windowWidth, windowHeight);
    setmetatable(o, self);
    self.__index = self;
    o.character = getPlayer();
    o.coordsSwith = false;
    o.coords = { x = settings.toX, y = settings.toY, z = settings.toZ };
    o.coordsEdited = { x = settings.x, y = settings.y, z = settings.z };
    o.settings = settings;
    o.width = windowWidth;
	o.height = windowHeight;
    o.resizable = false;
    o.title = getText("UI_GPREditTeleport");
    return o;
end