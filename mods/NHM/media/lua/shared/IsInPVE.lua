require "Private"

--[[function isInPVE()
   local x = square:getX();
   local y = square:getY();
    if ((x < 13541 and x > 12879) and (y < 7484 and y > 6883)) then
        return true
    end 
    return false
end]]


Private.init = function ()
	--[[if isClient() then
		local username = getPlayer():getUsername();
		if isRuleBreaker(username) then
			local message = getTextOrNull("UI_Text_SafehouseWarning") or "<RED> [INFO] Soon you will lose some of your safehouses if you don't recruit more faction members to cover the points difference";
			addLineInChat(message, 0);
		end
	elseif isServer() then
		print("[Private] Using full version of ssr-private.");
		checkFactions();
		SSRTimer.add_m(checkFactions, 30, true); -- once per 30 minutes
	end]]
end
