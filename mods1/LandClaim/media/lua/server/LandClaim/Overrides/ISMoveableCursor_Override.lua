local SafehouseController = require "LandClaim/SafehouseController_Server"

local oldISMoveableCursor_isValid = ISMoveableCursor.isValid
function ISMoveableCursor:isValid(square)
	if ISMoveableCursor.mode[self.player] == "scrap" then
		if  SafehouseController.CanDismantle(self.player, square)  then
			return oldISMoveableCursor_isValid(self, square)	
		end
	else
		if SafehouseController.CanPickup(self.player, square) then
			return oldISMoveableCursor_isValid(self, square)
		end	
	end
	return false
end
