local stateMap = {off = 'steamgenerator_01_0', green = 'steamgenerator_01_1', yellow = 'steamgenerator_01_2', red = 'steamgenerator_01_3'}

local spriteMap = setmetatable({}, { __index = function(t, k)
	error('Attempt to index SteamGenerator sprite table with ' .. k)
end })
for k,v in pairs(stateMap) do
	spriteMap[v] = k
end

local function CheckAndUpdateSprite(generator, activateOverride)
	local isActivated = generator:isActivated()
	local waterLvl = generator:getModData().water or 0
	local fuelLvl = generator:getFuel() or 0
	local condition = generator:getCondition() or 0
	local curState = spriteMap[generator:getTextureName()]
	local state = 'off'
	if isActivated then
		if waterLvl < 30 or fuelLvl < 30 or condition < 30 then
			state = 'red'
		elseif waterLvl < 70 or fuelLvl < 70 or condition < 70 then
			state = 'yellow'
		else
			state = 'green'
		end
	end
	if state ~= curState then
		generator:setSprite(getSprite(stateMap[state]))
		generator:transmitUpdatedSprite()
	end
end

return {stateMap, CheckAndUpdateSprite}
