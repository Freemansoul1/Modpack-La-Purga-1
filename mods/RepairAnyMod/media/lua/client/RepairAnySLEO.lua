if getActivatedMods():contains("ItemTweakerAPI1") then
	require("ItemTweaker_Core");
else return end

-- Adjust items to be repairable
TweakItem("SLEOClothing.Shoes_TacticalBoots", "FabricType", "Leather");
TweakItem("SLEOClothing.PoliceTacticalVest", "FabricType", "Leather");
