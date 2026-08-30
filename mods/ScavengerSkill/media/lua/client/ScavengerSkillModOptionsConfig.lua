ScavengerSkill = ScavengerSkill or {};
ScavengerSkill.settings = ScavengerSkill.SETTINGS or {};

ScavengerSkill.settings.ScavengerLootIndicator = true;
ScavengerSkill.settings.ScavengerExpIndicator = true;

if ModOptions and ModOptions.getInstance then
	local function onModOptionsApply(optionValues)
		ScavengerSkill.settings.ScavengerLootIndicator = optionValues.settings.options.ScavengerLootIndicator;
		ScavengerSkill.settings.ScavengerExpIndicator = optionValues.settings.options.ScavengerExpIndicator;
	end
	local SETTINGS = {
		options_data = {
			ScavengerLootIndicator = {
				name = "UI_ScavengerSkill_Options_ScavengerLootIndicator",
				default = true,
				OnApplyMainMenu = onModOptionsApply,
				OnApplyInGame = onModOptionsApply,
			},
			ScavengerExpIndicator = {
				name = "UI_ScavengerSkill_Options_ScavengerExpIndicator",
				default = true,
				OnApplyMainMenu = onModOptionsApply,
				OnApplyInGame = onModOptionsApply,
			},
		},
		mod_id = 'ScavengingSkillFixed',
		mod_shortname = 'Scavenging Skill Fixed',
		mod_fullname = 'Scavenging Skill Fixed',
	}
	ModOptions:getInstance(SETTINGS)
	ModOptions:loadFile()

	Events.OnPreMapLoad.Add(function()
		onModOptionsApply({ settings = SETTINGS })
	end)
end