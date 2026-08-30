require "ISUI/ISPanel"

LSSensorEditorUI = ISPanel:derive("LSSensorEditorUI");

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)

--************************************************************************--
--** ISPanel:initialise
--**
--************************************************************************--

function LSSensorEditorUI:initialise()
    ISPanel.initialise(self);
    self:create();
end


function LSSensorEditorUI:setVisible(visible)
    --    self.parent:setVisible(visible);
    self.javaObject:setVisible(visible);
end

function LSSensorEditorUI:render()
--    local y = 20;
--    local splitPt = 100;
--
--    self:drawText(getText("IGUI_ItemEditor_Title"), self.width/2 - (getTextManager():MeasureStringX(UIFont.Medium, getText("IGUI_ItemEditor_Title")) / 2),y, 1,1,1,1, UIFont.Medium);
end

function LSSensorEditorUI:prerender()
    ISPanel.prerender(self);
    local entryHgt = FONT_HGT_SMALL + 2 * 2
    local y = 20;
    local dy = math.max(20, entryHgt) + 10
    local splitPt = 100;

    self:drawText(getText("Sensor Parameters"), self.width/2 - (getTextManager():MeasureStringX(UIFont.Medium, getText("Sensor Parameters")) / 2),y, 1,1,1,1, UIFont.Medium);
    y = y + 30;

    if SensorTypes[self.sensorModData.type].hasVal then
        self:drawText(getText("Threshold") .. ":", 5, y, 1,1,1,1,UIFont.Small);
        self.threshold:setY(y);
        if splitPt < getTextManager():MeasureStringX(UIFont.Small, getText("Threshold")) + 10 then
            splitPt = getTextManager():MeasureStringX(UIFont.Small, getText("Threshold")) + 10;
        end
        self.threshold:setX(splitPt);
        y = y + dy;
    end

    self:drawText(getText("Invert") .. ":", 5, y, 1,1,1,1,UIFont.Small);
    self.invert:setY(y);
    if splitPt < getTextManager():MeasureStringX(UIFont.Small, getText("Invert")) + 10 then
        splitPt = getTextManager():MeasureStringX(UIFont.Small, getText("Invert")) + 10;
    end
    self.invert:setX(splitPt);
    y = y + dy;

    self:drawText(getText("Positive only") .. ":", 5, y, 1,1,1,1,UIFont.Small);
    self.positive:setY(y);
    if splitPt < getTextManager():MeasureStringX(UIFont.Small, getText("Positive only")) + 10 then
        splitPt = getTextManager():MeasureStringX(UIFont.Small, getText("Positive only")) + 10;
    end
    self.positive:setX(splitPt);
    y = y + dy;

    self:drawText(getText("Modules") .. ":", 5, y, 1,1,1,1,UIFont.Small);
    
    if splitPt < getTextManager():MeasureStringX(UIFont.Small, getText("Power")) + 10 then
        splitPt = getTextManager():MeasureStringX(UIFont.Small, getText("Power")) + 10;
    end
    
    self.batteryDropBox:setY(y);
    self.batteryDropBox:setX(splitPt);

    self.alarmDropBox:setY(y);
    self.alarmDropBox:setX(splitPt + 30);

    self.armDropBox:setY(y);
    self.armDropBox:setX(splitPt + 60);

    y = y + dy;
end

function LSSensorEditorUI:create()
    local btnWid = 150
    local btnHgt = FONT_HGT_SMALL + 2 * 4
    local entryHgt = FONT_HGT_SMALL + 2 * 2
    local padBottom = 10
    local numberWidth = 50;
    local dy = math.max(20, entryHgt) + 10

    local y = 30;

    if SensorTypes[self.sensorModData.type].hasVal then
        self.threshold = ISTextEntryBox:new(luautils.round(self.sensorModData.val, 3) .. "", 10, y, numberWidth, entryHgt);
        self.originalThreshold = luautils.round(self.sensorModData.val, 3);
        self.threshold:initialise();
        self.threshold:instantiate();
        self.threshold.min = 0;
        self.threshold:setOnlyNumbers(true);
        self:addChild(self.threshold);
        y = y + dy
    end
    
    self.invert = ISTickBox:new(10, y, 10, 10, "", nil, nil)
    self.invert:initialise()
    self:addChild(self.invert)
    self.invert:addOption("Invert")
    self.invert:setWidthToFit()
    self.invert:setX((self.width - self.invert.width) / 2)
    self.invert:setSelected(1, self.sensorModData.inv)
    y = y + dy

    self.positive = ISTickBox:new(10, y, 10, 10, "", nil, nil)
    self.positive:initialise()
    self:addChild(self.positive)
    self.positive:addOption("Positive only")
    self.positive:setWidthToFit()
    self.positive:setX((self.width - self.positive.width) / 2)
    -- self.positive:setToolTip( true, getText("Sensor will not send deactivation signal") )
    self.positive:setSelected(1, self.sensorModData.positive)
    y = y + dy

    self.batteryDropBox = ISItemDropBox:new (10, y, 24, 24, false, self, LSSensorEditorUI.addBattery, LSSensorEditorUI.removeBattery, LSSensorEditorUI.verifyBattery, nil )
    self.batteryDropBox:initialise()
    self.batteryDropBox:setBackDropTex( getTexture("Item_Battery"), 0.4, 1,1,1 )
    self.batteryDropBox:setDoBackDropTex( true )
    self.batteryDropBox:setToolTip( true, getText("Add battery here it you want sensor to work outside of power grid."))
    self.batteryDropBox:setX((self.width - self.positive.width) / 2)
    self:addChild(self.batteryDropBox)

    self.alarmDropBox = ISItemDropBox:new (20, y, 24, 24, false, self, LSSensorEditorUI.addAlarm, LSSensorEditorUI.removeAlarm, LSSensorEditorUI.verifyAlarm, nil )
    self.alarmDropBox:initialise()
    self.alarmDropBox:setBackDropTex( getTexture("Item_Amplifier"), 0.4, 1,1,1 )
    self.alarmDropBox:setDoBackDropTex( true )
    self.alarmDropBox:setToolTip( true, getText("Add an amplifier here if you want sensor to emit sound alarm."))
    self.alarmDropBox:setX((self.width - self.positive.width) / 2)
    self:addChild(self.alarmDropBox)

    self.armDropBox = ISItemDropBox:new (30, y, 24, 24, false, self, LSSensorEditorUI.addArm, LSSensorEditorUI.removeArm, LSSensorEditorUI.verifyArm, nil )
    self.armDropBox:initialise()
    self.armDropBox:setBackDropTex( getTexture("Item_CannedSardines"), 0.4, 1,1,1 )
    self.armDropBox:setDoBackDropTex( true )
    self.armDropBox:setToolTip( true, getText("Add an explosive here if you want it to blow when activated."))
    self.armDropBox:setX((self.width - self.positive.width) / 2)
    self:addChild(self.armDropBox)
    y = y + dy

    --[[
    self.alarm = ISTickBox:new(10, y, 10, 10, "", nil, nil)
    self.alarm:initialise()
    self:addChild(self.alarm)
    self.alarm:addOption("Alarm")
    self.alarm:setWidthToFit()
    self.alarm:setX((self.width - self.alarm.width) / 2)
    self.alarm:setSelected(1, sensorModData.alarm)
    y = y + dy;

    self.arm = ISTickBox:new(10, y, 10, 10, "", nil, nil)
    self.arm:initialise()
    self:addChild(self.arm)
    self.arm:addOption("Arm")
    self.arm:setWidthToFit()
    self.arm:setX((self.width - self.arm.width) / 2)
    self.arm:setSelected(1, sensorModData.arm)
    y = y + dy;
    ]]--

    self:setHeight(y + 150);

    self.save = ISButton:new(5, self:getHeight() - padBottom - btnHgt, btnWid, btnHgt, getText("IGUI_RadioSave"), self, LSSensorEditorUI.onOptionMouseDown);
    self.save.internal = "SAVE";
    self.save:initialise();
    self.save:instantiate();
    self.save.borderColor = self.buttonBorderColor;
    self:addChild(self.save);

    self.cancel = ISButton:new(self:getWidth() - btnWid - 5, self:getHeight() - padBottom - btnHgt, btnWid, btnHgt, getText("IGUI_Exit"), self, LSSensorEditorUI.onOptionMouseDown);
    self.cancel.internal = "CANCEL";
    self.cancel:initialise();
    self.cancel:instantiate();
    self.cancel.borderColor = self.buttonBorderColor;
    self:addChild(self.cancel);

end

function LSSensorEditorUI:update()
    ISPanel.update(self);
    
    if self.sensorModData.battery then
        self.batteryDropBox:setStoredItemFake(getTexture("Item_Battery"))
    else
        self.batteryDropBox:setStoredItemFake(nil)
    end

    if self.sensorModData.alarm then
        self.alarmDropBox:setStoredItemFake(getTexture("Item_Amplifier"))
    else
        self.alarmDropBox:setStoredItemFake(nil)
    end

    if self.sensorModData.arm then
        local map = {}
        map["SensorsTraps.LSTrapShock"] = "Item_CannedSardines"
        map["SensorsTraps.LSTrapNails"] = "Item_CannedSardines"
        map["SensorsTraps.LSTrapBrokenGlass"] = "Item_CannedSardines"
        local tex = map[self.sensorModData.arm]
        self.armDropBox:setStoredItemFake(getTexture(map[self.sensorModData.arm]))
    else
        self.armDropBox:setStoredItemFake(nil)
    end
end

function LSSensorEditorUI:onOptionMouseDown(button, x, y)
    if button.internal == "SAVE" then

        self.sensorModData.inv = self.invert:isSelected(1)
        self.sensorModData.positive = self.positive:isSelected(1)
        -- self.sensorModData.alarm = self.alarm:isSelected(1)
        -- self.sensorModData.arm = self.arm:isSelected(1)

        if SensorTypes[self.sensorModData.type].hasVal and self.originalThreshold ~= string.trim(self.threshold:getInternalText()) then
            self.sensorModData.val = tonumber(string.trim(self.threshold:getInternalText()))
            if self.sensorModData.val < SensorTypes[self.sensorModData.type].minVal then self.sensorModData.val = SensorTypes[self.sensorModData.type].minVal end
            if self.sensorModData.val > SensorTypes[self.sensorModData.type].maxVal then self.sensorModData.val = SensorTypes[self.sensorModData.type].maxVal end
        end
        
        self:setVisible(false);
        self:removeFromUIManager();
    end
    if button.internal == "CANCEL" then
        self:setVisible(false);
        self:removeFromUIManager();
    end
end

-- MODULE: BATTERY

function LSSensorEditorUI:verifyBattery(item)
    if item:getFullType() == "Base.Battery" then
        return true
    end
end

function LSSensorEditorUI:addBattery(items)
    local item
    local pbuff = 0

    for _, i in ipairs(items) do
        if i:getDelta() > pbuff then
            item = i
            pbuff = i:getDelta()
        end
    end

    if item then
        ISTimedActionQueue.add(TAModules:new("AddBattery", self.character, self.sensor, item))
    end
end

function LSSensorEditorUI:removeBattery()
    ISTimedActionQueue.add(TAModules:new("RemoveBattery", self.character, self.sensor))
end

-- MODULE: ALARM

function LSSensorEditorUI:verifyAlarm(item)
    if item:getFullType() == "Base.Amplifier" then
        return true
    end
end

function LSSensorEditorUI:addAlarm(items)
    local item
    local pbuff = 0

    for _, i in ipairs(items) do
        if i:getCondition() > pbuff then
            item = i
            pbuff = i:getCondition()
        end
    end

    if item then
        ISTimedActionQueue.add(TAModules:new("AddAlarm", self.character, self.sensor, item))
    end
end

function LSSensorEditorUI:removeAlarm()
    ISTimedActionQueue.add(TAModules:new("RemoveAlarm", self.character, self.sensor))
end

-- MODULE: WEAPON

function LSSensorEditorUI:verifyArm(item)
    local validTypes = {"SensorsTraps.LSTrapShock", "SensorsTraps.LSTrapNails", "SensorsTraps.LSTrapBrokenGlass"}
    local isValid = false

    for _, vtype in pairs(validTypes) do
        if item:getFullType() == vtype then return true end
    end

    return false
end

function LSSensorEditorUI:addArm(items)
    local item
    local pbuff = 0

    for _, i in ipairs(items) do
        if i:getCondition() > pbuff then
            item = i
            pbuff = i:getCondition()
        end
    end

    if item then
        ISTimedActionQueue.add(TAModules:new("AddArm", self.character, self.sensor, item))
    end
end

function LSSensorEditorUI:removeArm()
    ISTimedActionQueue.add(TAModules:new("RemoveArm", self.character, self.sensor))
end


function LSSensorEditorUI:new(x, y, width, height, character, sensor)
    local o = {};
    x = getMouseX() + 10;
    y = getMouseY() + 10;
    o = ISPanel:new(x, y, 400, height);
    setmetatable(o, self);
    self.__index = self;
    o.variableColor={r=0.9, g=0.55, b=0.1, a=1};
    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
    o.backgroundColor = {r=0, g=0, b=0, a=0.8};
    o.buttonBorderColor = {r=0.7, g=0.7, b=0.7, a=0.5};
    o.zOffsetSmallFont = 25;
    o.moveWithMouse = true;
    o.character = character;
    o.sensor = sensor;
    o.sensorModData = LSUtils.GetSensorModData(sensor)
    LSSensorEditorUI.instance = self;

    return o;
end
