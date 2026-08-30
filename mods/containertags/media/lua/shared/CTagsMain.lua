-- Container Tags
-- Author: Dismellion


CTags = {}
CTags.version = '1.0.0';
CTags.build = '41.78';
CTags.drawData = {};

function CTags:isMultiplayer() return getCore():getGameMode() == "Multiplayer" end

function CTags:tableContains(t, e)
	for _, value in pairs(t) do
		if value == e then
			return true
		end
	end
	return false
end

function CTags:splitString(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end

function CTags:sleepDo(seconds, func, condition)
	local time = os.time();
	local targetTime = time + seconds;
	if condition == nil then condition = true end; -- Optional 


	local function OnSleepTick()
		local timeNew = os.time();
		if not condition then 
			Events.OnTick.Remove(OnSleepTick);
			return
		end
		if timeNew >= targetTime then
			Events.OnTick.Remove(OnSleepTick);
			func();
		end
	end
	Events.OnTick.Add(OnSleepTick)
end

function CTags:getFaction()
	local factions = Faction.getFactions();
	local player = getPlayer();

	for i=0, factions:size()-1 do
		local userName = player:getUsername();
		local faction = factions:get(i);
		local isPlayerMember = faction:isPlayerMember(player) or faction:isOwner(userName);

		if isPlayerMember then
			return faction
		end
	end
	return
end