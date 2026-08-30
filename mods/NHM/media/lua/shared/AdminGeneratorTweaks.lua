local spriteMap = {off = 'adm_gen_0_0'}

local genMap = setmetatable({}, { __index = function(t, k)
	error('Indexing error ' .. k)
end })
for k,v in pairs(spriteMap) do
	genMap[v] = k
end

local function UpdateGenSprite(generator, activateOverride)
	local curState = genMap[generator:getTextureName()]
	local state = 'off'
	if state ~= curState then
		generator:setSprite(getSprite(spriteMap[state]))
		generator:transmitUpdatedSprite()
	end
end

return {spriteMap, UpdateGenSprite}