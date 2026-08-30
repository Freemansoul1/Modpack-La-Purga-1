if getActivatedMods():contains("ItemTweakerAPI1") then
	require("ItemTweaker_Core");
else return end

-- Adjust items to be repairable
TweakItem("Spongie.Gloves_LeatherFingerless", "FabricType", "Leather");
TweakItem("Spongie.Gloves_MilitaryFingerless", "FabricType", "Denim");
TweakItem("Spongie.Jacket_FlightVest", "FabricType", "Leather");
TweakItem("Spongie.Jacket_FlightVestOPEN", "FabricType", "Leather");
TweakItem("Spongie.Jacket_WinterCoat", "FabricType", "Leather");
TweakItem("Spongie.Jacket_WinterCoatDOWN", "FabricType", "Leather");