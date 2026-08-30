--***********************************************************
--**                       BitBraven                       **
--***********************************************************

local OnVehicleDashboardNew = ISVehicleDashboard.new
local OnVehicleDashboardCreateChildren = ISVehicleDashboard.createChildren

-- Snippet extracted from TIS code, modified.
local function onGameStart()
	-- Doing this to avoid a big pause entering a vehicle the first time.
	local textures = {}
	textures.speedGaugeTex = getTexture("media/ui/vehicles/vehicle_spedometer_kmph.png")
end

function ISVehicleDashboard:new(playerNum, chr)
    local o = OnVehicleDashboardNew(self, playerNum, chr)
	o.speedGaugeTex = getTexture("media/ui/vehicles/vehicle_spedometer_kmph.png")
    return o
end

function ISVehicleDashboard:createChildren()

    OnVehicleDashboardCreateChildren(self)

	local x = self.backgroundTex:getWidth() - 211
	local y = self.backgroundTex:getHeight() - self.speedGaugeTex:getHeight()
	self.speedGauge = ISVehicleGauge:new(x, y, self.speedGaugeTex, 64, 114, 180, 0)
	self:addChild(self.speedGauge)

	-- Snippet extracted from TIS code. For some reason the texture prevents these buttons from being clicked.
	self.lightsTex.onclick = ISVehicleDashboard.onClickHeadlights;
	self.lightsTex.target = self;
	self:addChild(self.lightsTex);

	self.heaterTex.onclick = ISVehicleDashboard.onClickHeater;
	self.heaterTex.target = self;
	self:addChild(self.heaterTex);

	self.trunkTex.onclick = ISVehicleDashboard.onClickTrunk;
	self.trunkTex.target = self;
	self:addChild(self.trunkTex);
	-- End of snippity snippet

	self:onResolutionChange()
end

Events.OnGameStart.Add(onGameStart)