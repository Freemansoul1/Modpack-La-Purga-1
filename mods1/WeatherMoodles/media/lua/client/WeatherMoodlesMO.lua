--by B O B c a t (https://steamcommunity.com/id/the_bobcat/)

require "WeatherMoodles"

if ModOptions and ModOptions.getInstance then

	--Runs when an options value changes
	--No idea why we have to put that x in there. It can be any string.
	local function OnApply(x)

		Options.isAltTexture = x.settings.options.isAltTexture

		Options.enableExtreme = x.settings.options.enableExtreme
		Options.isCombine = x.settings.options.isCombine

		Options.showInside = x.settings.options.showInside
		
		Options.enableSeason= x.settings.options.enableSeason
		Options.seasonIs = x.settings.options.seasonIs

		Options.enableCloud = x.settings.options.enableCloud
		Options.cloudIs = x.settings.options.cloudIs

		Options.enableRain = x.settings.options.enableRain
		Options.rainIs = x.settings.options.rainIs

		Options.enableSnow = x.settings.options.enableSnow
		Options.snowIs = x.settings.options.snowIs

		Options.enableWind = x.settings.options.enableWind
		Options.windIs = x.settings.options.windIs

		Options.enableFog = x.settings.options.enableFog
		Options.fogIs = x.settings.options.fogIs

		Options.enableSun = x.settings.options.enableSun
		Options.sunIs = x.settings.options.sunIs

		if isPlayerValid then
			UpdateThresholds()
			UseAltTextures()
		end
	end

	local SETTINGS = {
		options_data = {

			isAltTexture = {
				name = "UI_WeatherMoodles_IsAltTex",
				tooltip = "UI_WeatherMoodles_IsAltTex_Tooltip",
				default = false,
				OnApplyMainMenu = OnApply,
				OnApplyInGame = OnApply,
			},

			enableExtreme = {
				name = "UI_WeatherMoodles_EnableExtreme",
				tooltip = "UI_WeatherMoodles_EnableExtreme_Tooltip",
				default = false,
				OnApplyMainMenu = OnApply,
				OnApplyInGame = OnApply,
			},

			isCombine = {
				name = "UI_WeatherMoodles_IsCombine",
				tooltip = "UI_WeatherMoodles_IsCombine_Tooltip",
				default = false,
				OnApplyMainMenu = OnApply,
				OnApplyInGame = OnApply,
			},

			showInside = {
				name = "UI_WeatherMoodles_ShowInside",
				tooltip = "UI_WeatherMoodles_ShowInside_Tooltip",
				default = false,
				OnApplyMainMenu = OnApply,
				OnApplyInGame = OnApply,
			},

			enableSeason = {
				name = "UI_WeatherMoodles_EnableSeason",
				tooltip = "UI_WeatherMoodles_EnableSeason_Tooltip",
				default = false,
				OnApplyMainMenu = OnApply,
				OnApplyInGame = OnApply,
			},
			seasonIs = {
				getText("UI_WeatherMoodles_Good"), getText("UI_WeatherMoodles_Bad"),
				name = "UI_WeatherMoodles_SeasonIs",
				tooltip = "UI_WeatherMoodles_BGColor_Tooltip",
				default = 1,
				OnApplyMainMenu = OnApply,
				OnApplyInGame = OnApply,
			},

			enableCloud = {
				name = "UI_WeatherMoodles_EnableCloud",
				tooltip = "UI_WeatherMoodles_EnableCloud_Tooltip",
				default = true,
				OnApplyMainMenu = OnApply,
				OnApplyInGame = OnApply,
			},
			cloudIs = {
				getText("UI_WeatherMoodles_Good"), getText("UI_WeatherMoodles_Bad"),
				name = "UI_WeatherMoodles_CloudIs",
				tooltip = "UI_WeatherMoodles_BGColor_Tooltip",
				default = 1,
				OnApplyMainMenu = OnApply,
				OnApplyInGame = OnApply,
			},

			enableRain = {
				name = "UI_WeatherMoodles_EnableRain",
				tooltip = "UI_WeatherMoodles_EnableRain_Tooltip",
				default = true,
				OnApplyMainMenu = OnApply,
				OnApplyInGame = OnApply,
			},
			rainIs = {
				getText("UI_WeatherMoodles_Good"), getText("UI_WeatherMoodles_Bad"),
				name = "UI_WeatherMoodles_RainIs",
				tooltip = "UI_WeatherMoodles_BGColor_Tooltip",
				default = 1,
				OnApplyMainMenu = OnApply,
				OnApplyInGame = OnApply,
			},

			enableSnow = {
				name = "UI_WeatherMoodles_EnableSnow",
				tooltip = "UI_WeatherMoodles_EnableSnow_Tooltip",
				default = true,
				OnApplyMainMenu = OnApply,
				OnApplyInGame = OnApply,
			},
			snowIs = {
				getText("UI_WeatherMoodles_Good"), getText("UI_WeatherMoodles_Bad"),
				name = "UI_WeatherMoodles_SnowIs",
				tooltip = "UI_WeatherMoodles_BGColor_Tooltip",
				default = 1,
				OnApplyMainMenu = OnApply,
				OnApplyInGame = OnApply,
			},

			enableWind = {
				name = "UI_WeatherMoodles_EnableWind",
				tooltip = "UI_WeatherMoodles_EnableWind_Tooltip",
				default = true,
				OnApplyMainMenu = OnApply,
				OnApplyInGame = OnApply,
			},
			windIs = {
				getText("UI_WeatherMoodles_Good"), getText("UI_WeatherMoodles_Bad"),
				name = "UI_WeatherMoodles_WindIs",
				tooltip = "UI_WeatherMoodles_BGColor_Tooltip",
				default = 1,
				OnApplyMainMenu = OnApply,
				OnApplyInGame = OnApply,
			},
	
			enableFog = {
				name = "UI_WeatherMoodles_EnableFog",
				tooltip = "UI_WeatherMoodles_EnableFog_Tooltip",
				default = true,
				OnApplyMainMenu = OnApply,
				OnApplyInGame = OnApply,
			},
			fogIs = {
				getText("UI_WeatherMoodles_Good"), getText("UI_WeatherMoodles_Bad"),
				name = "UI_WeatherMoodles_FogIs",
				tooltip = "UI_WeatherMoodles_BGColor_Tooltip",
				default = 1,
				OnApplyMainMenu = OnApply,
				OnApplyInGame = OnApply,
			},

			enableSun = {
				name = "UI_WeatherMoodles_EnableSun",
				tooltip = "UI_WeatherMoodles_EnableSun_Tooltip",
				default = true,
				OnApplyMainMenu = OnApply,
				OnApplyInGame = OnApply,
			},
			sunIs = {
				getText("UI_WeatherMoodles_Good"), getText("UI_WeatherMoodles_Bad"),
				name = "UI_WeatherMoodles_SunIs",
				tooltip = "UI_WeatherMoodles_BGColor_Tooltip",
				default = 1,
				OnApplyMainMenu = OnApply,
				OnApplyInGame = OnApply,
			},

		},
		mod_id = 'WeatherMoodles',
		mod_shortname = 'Weather Moodles',
		mod_fullname = 'Weather Moodles',
	}
	ModOptions:getInstance(SETTINGS)
	
	--This is probably unnecessary but just in case.
	ModOptions:loadFile()
	
	--So that we initialize variables. Not sure what the "settings = SETTINGS" do.
	Events.OnPreMapLoad.Add(function() OnApply({ settings = SETTINGS }) end)
end
