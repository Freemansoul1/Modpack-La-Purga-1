local Settings = {

	options = {
		toggleExhaustion = true,
		exhaustionDrain = 0.00039,
		toggleExp = true,
		expGain = 15,
		toggleWarmth = true,
		warmthGain = 0.1,
	  },

	  names = {
		toggleExhaustion = getText("IGUI_Settings_ToggleExhaustion"),
		exhaustionDrain = getText("IGUI_Settings_ExhaustionDrain"),
		toggleExp = getText("IGUI_Settings_ToggleExp"),
		expGain = getText("IGUI_Settings_ExpGain"),
		toggleWarmth = getText("IGUI_Settings_ToggleWarmth"),
		warmthGain = getText("IGUI_Settings_WarmthGain"),
	  },

	  mod_id = "BB_Bicycles",
	  mod_shortname = "Braven's Bicycles",
}

if ModOptions and ModOptions.getInstance then
    local settings = ModOptions:getInstance(Settings)

	-- Apply tooltips
	settings:getData("toggleExhaustion").tooltip = getText("IGUI_Settings_Tooltip_ToggleExhaustion")
	settings:getData("toggleExp").tooltip = getText("IGUI_Settings_Tooltip_ToggleExp")
	settings:getData("toggleWarmth").tooltip = getText("IGUI_Settings_Tooltip_ToggleWarmth")
end

BravensBikes = {}
BravensBikes.Settings = Settings