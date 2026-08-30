if getActivatedMods():contains("ItemTweakerAPI1") then
	require("ItemTweaker_Core");
else return end

-- Adjust items to be repairable
TweakItem("UndeadSurvivor.StalkerBoots", "FabricType", "Leather");
TweakItem("UndeadSurvivor.NomadBoots", "FabricType", "Leather");
