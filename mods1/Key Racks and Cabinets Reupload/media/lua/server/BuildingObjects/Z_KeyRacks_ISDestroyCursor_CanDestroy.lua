require "BuildingObjects/ISDestroyCursor"

local old_ISDestroyCursor_canDestroy = ISDestroyCursor.canDestroy

function ISDestroyCursor:canDestroy(object)
	
	local spriteName = object:getSprite():getName()
	if spriteName then
		if luautils.stringStarts(spriteName, 'keycabinet') then return false end
		if luautils.stringStarts(spriteName, 'keyrack') then return false end
	end
	return old_ISDestroyCursor_canDestroy(self, object)

end
