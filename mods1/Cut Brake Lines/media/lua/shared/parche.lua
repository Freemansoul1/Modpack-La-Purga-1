require "Private"

local parche = {}
parche.Private = {}

parche.Private.canBeCaptured = Private.canBeCaptured


function Private.canBeCaptured(square)
	local flag = getServerOptions():getBoolean("SafehouseAllowNonResidential");
	if flag == false then
		if not Private.isResidential(square) then
			return getText("IGUI_Safehouse_NotHouse");
		end
	end

	return "valid";
end
