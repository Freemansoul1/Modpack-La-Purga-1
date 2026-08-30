-----------------------------------------------------
--Visit Sunday Drivers for the latest and greatest!--
--mod by lect----------------------------------------
--Free to use with permission------------------------
-----------------------------------------------------
if not getActivatedMods():contains("MoodleFramework") then return end
require "ZoneCheck"
require "MF_ISMoodle"

MF.createMoodle("Tier1");
MF.createMoodle("Tier2");
MF.createMoodle("Tier3");
MF.createMoodle("Tier4");

local function EveryOneMinute()
	local player = getSpecificPlayer(0)
	if player ~= nil then
		local checkMoodle = checkZone()
		if checkMoodle == 4 then
			MF.getMoodle("Tier4"):setValue(0.1);
			MF.getMoodle("Tier1"):setValue(0.5);
			MF.getMoodle("Tier2"):setValue(0.5);
			MF.getMoodle("Tier3"):setValue(0.5);
--			MF.getMoodle("Tier4"):doWiggle();
		elseif checkMoodle == 3 then
			MF.getMoodle("Tier3"):setValue(0.4);
			MF.getMoodle("Tier1"):setValue(0.5);
			MF.getMoodle("Tier2"):setValue(0.5);
			MF.getMoodle("Tier4"):setValue(0.5);
--			MF.getMoodle("Tier3"):doWiggle();
		elseif checkMoodle == 2 then
			MF.getMoodle("Tier2"):setValue(0.6);
			MF.getMoodle("Tier1"):setValue(0.5);
			MF.getMoodle("Tier4"):setValue(0.5);
			MF.getMoodle("Tier3"):setValue(0.5);
--			MF.getMoodle("Tier2"):doWiggle();
		elseif checkMoodle == 1 then
			MF.getMoodle("Tier1"):setValue(1.0);
			MF.getMoodle("Tier4"):setValue(0.5);
			MF.getMoodle("Tier2"):setValue(0.5);
			MF.getMoodle("Tier3"):setValue(0.5);
--			MF.getMoodle("Tier1"):doWiggle();
		end
	end
end
Events.EveryOneMinute.Add(EveryOneMinute)