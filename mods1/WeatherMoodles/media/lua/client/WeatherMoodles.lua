--by B O B c a t (https://steamcommunity.com/id/the_bobcat/)

require "MF_ISMoodle"

--Variables are not local. Because we're accessing them from the ModOptions file.
Options = {}

--Setting default values in case we don't have ModOptions installed.
Options.isAltTexture = false

Options.enableExtreme = true
Options.isCombine = false

Options.showInside = false

Options.enableCloud = true
Options.cloudIs = 1

Options.enableRain = true
Options.rainIs = 1

Options.enableSnow = true
Options.snowIs = 1

Options.enableWind = true
Options.windIs = 2

Options.enableFog = true
Options.fogIs = 2

Options.enableSun = true
Options.sunIs = 1

Options.enableSeason = false
Options.seasonIs = 1

--Moodle creation order determines the in-game order of them.
MF.createMoodle("Season")
--Extreme Weather
MF.createMoodle("WeatherStorm")
MF.createMoodle("WeatherBlizzard")
MF.createMoodle("WeatherTropicalStorm")

--Weather Conditions
MF.createMoodle("WeatherCloud")
MF.createMoodle("WeatherRain")
MF.createMoodle("WeatherSnow")
MF.createMoodle("WeatherWind")
MF.createMoodle("WeatherFog")
MF.createMoodle("WeatherSun")

isPlayerValid = false
isExtremeWeather = false
isSeasonGood = { [1]=1, [2]=0 }

--Hotkey
--Use this a master switch for showing/hiding moodles. Still respects the settings in ModOptions.
isOn = true
KEY_TOGGLE = {
	name = "KeyToggle",
	key = Keyboard.KEY_RCONTROL,
}

local function KeyUp(keynum)
	if keynum == KEY_TOGGLE.key then
		isOn = not isOn
	end
end

if ModOptions and ModOptions.AddKeyBinding then
	ModOptions:AddKeyBinding("[Hotkeys]", KEY_TOGGLE)
end
--^Hotkey^

--This function is not local. Because we're calling it from the ModOptions file.
function UseAltTextures()
	local selTexDir = nil
	if Options.isAltTexture then selTexDir = "media/ui/alt/" else selTexDir = "media/ui/" end
	for t = 1, 2 do
		for i = 1, 4 do
			MF.getMoodle("Season"):setPicture(t, i, getTexture(selTexDir .. "SeasonDefault.png"))
			MF.getMoodle("WeatherCloud"):setPicture(t, i, getTexture(selTexDir .. "WeatherStorm.png"))
			MF.getMoodle("WeatherCloud"):setPicture(t, i, getTexture(selTexDir .. "WeatherBlizzard.png"))
			MF.getMoodle("WeatherCloud"):setPicture(t, i, getTexture(selTexDir .. "WeatherTropicalStorm.png"))
			MF.getMoodle("WeatherCloud"):setPicture(t, i, getTexture(selTexDir .. "WeatherCloud.png"))
			MF.getMoodle("WeatherRain"):setPicture(t, i, getTexture(selTexDir .. "WeatherRain.png"))
			MF.getMoodle("WeatherSnow"):setPicture(t, i, getTexture(selTexDir .. "WeatherSnow.png"))
			MF.getMoodle("WeatherWind"):setPicture(t, i, getTexture(selTexDir .. "WeatherWind.png"))
			MF.getMoodle("WeatherFog"):setPicture(t, i, getTexture(selTexDir .. "WeatherFog.png"))
			MF.getMoodle("WeatherSun"):setPicture(t, i, getTexture(selTexDir .. "WeatherSun.png"))
		end
	end
end

local function SwitchSeason(seasonName)
	local selTexDir = nil
	local moodleName = nil
	local titleText = nil
	if Options.isAltTexture then selTexDir = "media/ui/alt/" else selTexDir = "media/ui/" end

	if seasonName == "Spring" then moodleName = "SeasonSpring"
	elseif seasonName == "Early Summer" then moodleName = "SeasonEarlySummer"
	elseif seasonName == "Late Summer" then moodleName = "SeasonLateSummer"
	elseif seasonName == "Autumn" then moodleName = "SeasonAutumn"
	elseif seasonName == "Winter" then moodleName = "SeasonWinter"
	else moodleName = "SeasonDefault"
	end

	for t = 1, 2 do
		for i = 1, 4 do
			MF.getMoodle("Season"):setPicture(t, i, getTexture(selTexDir .. moodleName .. ".png"))
			MF.getMoodle("Season"):setTitle(t ,i, getText("Moodles_" .. moodleName .. "_Good_lvl4"))	--Must set the descriptions for "bad" if I ever add flavor text
		end
	end
end

--!!!should rename sun related variables!!!
local function SwitchSunMoon(isSun)
	local selTexDir = nil
	local moodleName = nil
	local titleText = nil
	if Options.isAltTexture then selTexDir = "media/ui/alt/" else selTexDir = "media/ui/" end
	if isSun then moodleName = "WeatherSun" else moodleName = "WeatherMoon" end
	for t = 1, 2 do
		for i = 1, 4 do
			MF.getMoodle("WeatherSun"):setPicture(t, i, getTexture(selTexDir .. moodleName .. ".png"))
			MF.getMoodle("WeatherSun"):setTitle(t, i, getText("Moodles_" .. moodleName .. "_Good_lvl4"))	--Must set the descriptions for "bad" if I ever add flavor text
		end
	end
end

--This function is not local. Because we're calling it from the ModOptions file.
function UpdateThresholds()

	if Options.seasonIs == 1 then
		MF.getMoodle("Season"):setThresholds(nil, nil, nil, nil, 0.1, nil, nil, 0.9)
	else
		MF.getMoodle("Season"):setThresholds(0.1, nil, nil, 0.9, nil, nil, nil, nil)
	end

	if Options.cloudIs == 1 then
		MF.getMoodle("WeatherCloud"):setThresholds(nil, nil, nil, nil, 0.1, 0.25, 0.50, 0.75)
	else
		MF.getMoodle("WeatherCloud"):setThresholds(0.25, 0.50, 0.75, 0.9, nil, nil, nil, nil)
	end

	if Options.rainIs == 1 then
		MF.getMoodle("WeatherRain"):setThresholds(nil, nil, nil, nil, 0.001, 0.25, 0.50, 0.75)
	else
		MF.getMoodle("WeatherRain"):setThresholds(0.25, 0.50, 0.75, 0.999, nil, nil, nil, nil)
	end
	
	if Options.snowIs == 1 then
		MF.getMoodle("WeatherSnow"):setThresholds(nil, nil, nil, nil, 0.001, 0.25, 0.50, 0.75)
	else
		MF.getMoodle("WeatherSnow"):setThresholds(0.25, 0.50, 0.75, 0.999, nil, nil, nil, nil)
	end
	
	if Options.windIs == 1 then
		MF.getMoodle("WeatherWind"):setThresholds(nil, nil, nil, nil, 0.02, 0.25, 0.50, 0.75)
	else
		MF.getMoodle("WeatherWind"):setThresholds(0.25, 0.50, 0.75, 0.98, nil, nil, nil, nil)
	end
	
	if Options.fogIs == 1 then
		MF.getMoodle("WeatherFog"):setThresholds(nil, nil, nil, nil, 0.02, 0.25, 0.50, 0.75)
	else
		MF.getMoodle("WeatherFog"):setThresholds(0.25, 0.50, 0.75, 0.98, nil, nil, nil, nil)
	end
	
	if Options.sunIs == 1 then
		MF.getMoodle("WeatherSun"):setThresholds(nil, nil, nil, nil, 0.1, nil, nil, 0.9)
	else
		MF.getMoodle("WeatherSun"):setThresholds(0.1, nil, nil, 0.9, nil, nil, nil, nil)
	end

end

local function HideMoodle(moodleName, optionsWeatherIs)
	if optionsWeatherIs ~= 1 then
		MF.getMoodle(moodleName):setValue(1)
	else
		MF.getMoodle(moodleName):setValue(0)
	end
end

--MoodleFramework dev said that MF.getMoodle() doesn't work without a valid player. So we check for that before starting. This is called by an event, check the end of file.
local function ValidatePlayer(playerIndex, player)
	if player == getPlayer() then
		isPlayerValid = true
		UpdateThresholds()
		UseAltTextures()
		SwitchSunMoon(ClimateManager.getInstance():getNightStrength() < 0.5)
		SwitchSeason(ClimateManager.getInstance():getSeasonName())
	else
		print("Player is not valid. Cannot run the mod.")
	end
end

function HideExtremeWeather()
	isExtremeWeather = false
	--0.5 is the default value for MoodleFramework.
	MF.getMoodle("WeatherStorm"):setValue(0.5)
	MF.getMoodle("WeatherBlizzard"):setValue(0.5)
	MF.getMoodle("WeatherTropicalStorm"):setValue(0.5)
end

local function ExtremeWeather(climateManager)
	local stageID = climateManager:getWeatherPeriod():getCurrentStageID()
	--I would use a switch statement if it existed.
	--And I don't like the handmade switch statements.
	--Base game weather stages
	--[[
    WEATHER_STAGE = ID
    STAGE_START = 0;
    STAGE_SHOWERS = 1;
    STAGE_HEAVY_PRECIP = 2;
    STAGE_STORM = 3;
    STAGE_CLEARING = 4;
    STAGE_MODERATE = 5;
    STAGE_DRIZZLE = 6;
    STAGE_BLIZZARD = 7;
    STAGE_TROPICAL_STORM = 8;
    STAGE_INTERMEZZO = 9;
    STAGE_MODDED = 10;
    STAGE_KATEBOB_STORM = 11;
    STAGE_MAX = 12;
    ]]--
	if stageID == 3 or stageID == 7 or stageID == 8 then
		isExtremeWeather = true
		if stageID == 3 then MF.getMoodle("WeatherStorm"):setValue(0)
		elseif stageID == 7 then MF.getMoodle("WeatherBlizzard"):setValue(0)
		elseif stageID == 8 then MF.getMoodle("WeatherTropicalStorm"):setValue(0)
		end
	else HideExtremeWeather() end
end

local function EveryHours()
	SwitchSunMoon(ClimateManager.getInstance():getNightStrength() < 0.5)
end

local function UpdateSeason()
	if Options.enableSeason then
		MF.getMoodle("Season"):setValue(isSeasonGood[Options.seasonIs])			--converting 1 to 1 and 2 to 0 because ModOptions starts dropdown index from 1 *sigh*
		SwitchSeason(ClimateManager.getInstance():getSeasonName())
	else
		HideMoodle("Season", Options.seasonIs)
	end
end

--Main function
local function UpdateWeatherMoodles(climateManager)

	local player = getPlayer()
	if isPlayerValid then

		local cloudIntensity = climateManager:getCloudIntensity()
		local rainIntensity = climateManager:getRainIntensity()
		local snowIntensity = climateManager:getSnowIntensity()
		local windIntensity = climateManager:getWindIntensity()
		local fogIntensity = climateManager:getFogIntensity()
		local isSunny = false
		local isSunnyVal = { [true]=1, [false]=0 }

		if Options.enableExtreme then ExtremeWeather(climateManager)
		else HideExtremeWeather() end --!!!put this somewhere better!!!
		--!!!this does not look pretty. find another way!!!
		if not player:isOutside() and not Options.showInside or not isOn then
			HideExtremeWeather()
			HideMoodle("Season", Options.seasonIs)
			HideMoodle("WeatherCloud", Options.cloudIs)
			HideMoodle("WeatherRain", Options.rainIs)
			HideMoodle("WeatherSnow", Options.snowIs)
			HideMoodle("WeatherWind", Options.windIs)
			HideMoodle("WeatherFog", Options.fogIs)
			HideMoodle("WeatherSun", Options.sunIs)
		else
			if Options.isCombine and isExtremeWeather then
				HideMoodle("WeatherCloud", Options.cloudIs)
				HideMoodle("WeatherRain", Options.rainIs)
				HideMoodle("WeatherSnow", Options.snowIs)
				HideMoodle("WeatherWind", Options.windIs)
				--HideMoodle("WeatherFog", Options.fogIs)
				HideMoodle("WeatherSun", Options.sunIs)
			else

				UpdateSeason()

				if Options.enableCloud and cloudIntensity > 0 then
					if Options.cloudIs ~= 1 then cloudIntensity = 1 - cloudIntensity end
					MF.getMoodle("WeatherCloud"):setValue(cloudIntensity)
				else HideMoodle("WeatherCloud", Options.cloudIs) end

				if Options.enableRain and rainIntensity > 0 then
					if Options.rainIs ~= 1 then rainIntensity = 1 - rainIntensity end		--Inverting the intensities to comply with how MoodleFramework works so we can implement toggling the "Good/Bad" moodles.
					MF.getMoodle("WeatherRain"):setValue(rainIntensity)
				else HideMoodle("WeatherRain", Options.rainIs) end

				if Options.enableSnow and snowIntensity > 0 then
					if Options.snowIs ~= 1 then snowIntensity = 1 - snowIntensity end
					MF.getMoodle("WeatherSnow"):setValue(snowIntensity)
				else HideMoodle("WeatherSnow", Options.snowIs) end

				if Options.enableWind and windIntensity > 0 then
					if Options.windIs ~= 1 then windIntensity = 1 - windIntensity end
					MF.getMoodle("WeatherWind"):setValue(windIntensity)
				else HideMoodle("WeatherWind", Options.windIs) end

				if Options.enableFog and fogIntensity > 0 then
					if Options.fogIs ~= 1 then fogIntensity = 1 - fogIntensity end
					MF.getMoodle("WeatherFog"):setValue(fogIntensity)
				else HideMoodle("WeatherFog", Options.fogIs) end

				if rainIntensity == 0 and snowIntensity == 0 and cloudIntensity < 0.1 then isSunny = true end
				if Options.enableSun and isSunny then
					if Options.sunIs ~= 1 then isSunny = false end
					MF.getMoodle("WeatherSun"):setValue(isSunnyVal[isSunny])	--setValue doesn't take booleans, so we're converting isSunny.
				else HideMoodle("WeatherSun", Options.sunIs)
				end
			end
		end
	else print("Player is not valid. Cannot update the weather.")
	end
end

--Call our ValidatePlayer function when this event fires
Events.OnCreatePlayer.Add(ValidatePlayer)

--Call our main function when this event fires. This is how we update.
Events.OnClimateTick.Add(UpdateWeatherMoodles)

Events.EveryHours.Add(EveryHours)

Events.OnKeyPressed.Add(KeyUp)

--Events.EveryDays.Add(UpdateSeason)