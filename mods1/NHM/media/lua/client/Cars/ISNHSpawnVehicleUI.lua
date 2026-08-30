ISNHSpawnVehicleUI = ISPanelJoypad:derive("ISNHSpawnVehicleUI");

function ISNHSpawnVehicleUI:initialise()
    ISPanelJoypad.initialise(self);

    local y = 60

    self.vehicleComboBox = ISComboBox:new(10, y, 180, 20)
    self.vehicleComboBox:initialise()
    self.vehicleComboBox:setEditable(true)
    self:addChild(self.vehicleComboBox)

    y = y + 40

    --self.boolOptions = ISTickBox:new(10, y, 200, 20, "", self, self.onSelectOption);
    --self.boolOptions:initialise()
    --self:addChild(self.boolOptions)
    --self.boolOptions:addOption("Normal cars");
    --self.boolOptions.selected[2] = true

    y = y + 80

    self.spawn = ISButton:new(10, self.height - 35, 80, 25, "Craft", self, ISNHSpawnVehicleUI.onClick);
    self.spawn.anchorTop = false
    self.spawn.anchorBottom = true
    self.spawn.internal = "SPAWN";
    self.spawn:initialise();
    self.spawn:instantiate();
    self.spawn.borderColor = { r = 1, g = 1, b = 1, a = 0.1 };
    self:addChild(self.spawn);

    self.close = ISButton:new(110, self.height - 35, 80, 25, "Close", self, ISNHSpawnVehicleUI.onClick);
    self.close.anchorTop = false
    self.close.anchorBottom = true
    self.close.internal = "CLOSE";
    self.close:initialise();
    self.close:instantiate();
    self.close.borderColor = { r = 1, g = 1, b = 1, a = 0.1 };
    self:addChild(self.close);

    self:populateList()
end

function ISNHSpawnVehicleUI:onSelectOption()
    self:populateList()
end

function ISNHSpawnVehicleUI:populateList()
    self.vehicleComboBox:clear()

    local vehicleList = { { "Base.CarNormal", "CarNormal" }, { "Base.CarStationWagon", "CarStationWagon" }, { "Base.SmallCar", "SmallCar" }, { "Base.PickUpTruck", "PickUpTruck" }, { "Base.PickUpVan", "PickUpVan" } }

    for i = 1, #vehicleList do
        local txt = vehicleList[i][1]
        txt = getText("IGUI_VehicleName" .. vehicleList[i][2])
        self.vehicleComboBox:addOptionWithData(txt, vehicleList[i][1])
    end
end

function ISNHSpawnVehicleUI:destroy()
    UIManager.setShowPausedMessage(true);
    self:setVisible(false);
    self:removeFromUIManager();
end

function ISNHSpawnVehicleUI:getVehicle()
    return self.vehicleComboBox.options[self.vehicleComboBox.selected].data;
end

function ISNHSpawnVehicleUI:update()
    self.vehicle = self.player:getNearVehicle()
end

function ISNHSpawnVehicleUI:onClick(button, args)
    if self.player ~= nil then
        if button.internal == "SPAWN" then
            print(tostring(self:getVehicle()))
            sendClientCommand(self.player, "vehicle", "SpawnCarFrame", { vehicle = tostring(self:getVehicle()) })
        elseif button.internal == "GETKEY" then
            if self.vehicle ~= nil then
                sendClientCommand(self.player, "vehicle", "getKey", { vehicle = self.vehicle:getId() })
            end
        elseif button.internal == "REPAIR" then
            if self.vehicle ~= nil then
                sendClientCommand(self.player, "vehicle", "repair", { vehicle = self.vehicle:getId() })
            end
        elseif button.internal == "CLOSE" then
            self:destroy();
        end
    end
end

function ISNHSpawnVehicleUI:titleBarHeight()
    return 16
end

function ISNHSpawnVehicleUI:prerender()
    self.backgroundColor.a = 0.8

    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);

    local th = self:titleBarHeight()
    self:drawTextureScaled(self.titlebarbkg, 2, 1, self:getWidth() - 4, th - 2, 1, 1, 1, 1);

    self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);

    self:drawTextCentre("Craft Vehicle Frame", self:getWidth() / 2, 20, 1, 1, 1, 1, UIFont.NewLarge);
end

function ISNHSpawnVehicleUI:render()

end

function ISNHSpawnVehicleUI:onMouseMove(dx, dy)
    self.mouseOver = true
    if self.moving then
        self:setX(self.x + dx)
        self:setY(self.y + dy)
        self:bringToTop()
    end
end

function ISNHSpawnVehicleUI:onMouseMoveOutside(dx, dy)
    self.mouseOver = false
    if self.moving then
        self:setX(self.x + dx)
        self:setY(self.y + dy)
        self:bringToTop()
    end
end

function ISNHSpawnVehicleUI:onMouseDown(x, y)
    if not self:getIsVisible() then
        return
    end
    self.downX = x
    self.downY = y
    self.moving = true
    self:bringToTop()
end

function ISNHSpawnVehicleUI:onMouseUp(x, y)
    if not self:getIsVisible() then
        return ;
    end
    self.moving = false
    if ISMouseDrag.tabPanel then
        ISMouseDrag.tabPanel:onMouseUp(x, y)
    end
    ISMouseDrag.dragView = nil
end

function ISNHSpawnVehicleUI:onMouseUpOutside(x, y)
    if not self:getIsVisible() then
        return
    end
    self.moving = false
    ISMouseDrag.dragView = nil
end

function ISNHSpawnVehicleUI:new(x, y, width, height, player)
    local o = {}
    o = ISPanelJoypad:new(x, y, width, height);
    setmetatable(o, self)
    self.__index = self
    if y == 0 then
        o.y = o:getMouseY() - (height / 2)
        o:setY(o.y)
    end
    if x == 0 then
        o.x = o:getMouseX() - (width / 2)
        o:setX(o.x)
    end
    o.name = nil;
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.5 };
    o.borderColor = { r = 0.4, g = 0.4, b = 0.4, a = 1 };
    o.width = width;
    local txtWidth = getTextManager():MeasureStringX(UIFont.Small, text) + 10;
    if width < txtWidth then
        o.width = txtWidth;
    end
    o.height = height;
    o.anchorLeft = true;
    o.anchorRight = true;
    o.anchorTop = true;
    o.anchorBottom = true;
    o.player = player;
    o.titlebarbkg = getTexture("media/ui/Panel_TitleBar.png");
    return o;
end
