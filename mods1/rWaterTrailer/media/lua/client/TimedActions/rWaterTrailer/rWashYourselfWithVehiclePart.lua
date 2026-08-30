--***********************************************************
--**                    ROBERT JOHNSON                     **
--***********************************************************

require "TimedActions/ISWashYourself"
require "TimedActions/ISWashClothing"

rWashYourselfWithVehiclePart = ISWashYourself:derive("rWashYourselfWithVehiclePart")

function rWashYourselfWithVehiclePart:perform()
	self:stopSound()

	local visual = self.character:getHumanVisual()
	local waterUsed = 0

	for i=1,BloodBodyPartType.MAX:index() do
		local part = BloodBodyPartType.FromIndex(i-1)
		if ISWashYourself.washPart(self, visual, part) then
			waterUsed = waterUsed + 1
			if waterUsed >= self.tank:getContainerContentAmount() then
				break
			end
		end
	end
	self.character:resetModelNextFrame();
	sendVisual(self.character);
	triggerEvent("OnClothingUpdated", self.character)

	-- remove makeup
	ISWashYourself.removeAllMakeup(self)

	local args = { vehicle = self.vehicle:getId(), part = self.tank:getId(), amount = self.tank:getContainerContentAmount() - waterUsed }
	sendClientCommand(self.character, 'vehicle', 'setContainerContentAmount', args)

	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)
end

function rWashYourselfWithVehiclePart:new(player, trailer, tank, soapList)
	local r = {}
	setmetatable(r, self)
	self.__index = self

	local waterUnits = math.min(ISWashYourself.GetRequiredWater(player), tank:getContainerContentAmount())

	r.character = player
	r.vehicle = trailer
	r.tank = tank;
	r.soaps = soapList
	r.forceProgressBar = true
	r.stopOnWalk = true
	r.stopOnRun = true
	r.maxTime = waterUnits * 70

	if ActiveMods.getById("currentGame"):isModActive("Betterhandwash") then -- from https://steamcommunity.com/sharedfiles/filedetails/?id=2594865484 --
		if player:HasTrait("Hemophobic") then
			r.maxTime = waterUnits * 40
		end
	end

	if ISWashYourself.GetRequiredSoap(player) > ISWashClothing.GetSoapRemaining(soapList) then
		r.maxTime = r.maxTime * 1.8
	end

	return r
end
