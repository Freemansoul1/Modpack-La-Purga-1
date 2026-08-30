local dynamic_grunts = true

local function PlayGruntSound(character, handWeapon)
	local swing_anim = handWeapon:getSwingAnim()
	if swing_anim == "Rifle" or swing_anim == "Handgun" then return end
	
    if dynamic_grunts then
        local endurance = character:getStats():getEndurance()
        local gruntChance = 7

        if endurance <= 0.85 and endurance > 0.75 then
            gruntChance = 5
        else
            if endurance <= 0.75 then
                gruntChance = 0
            end
        end

        if ZombRand(0, 11) < gruntChance then return end
    end

    if character:isFemale() then
        local num = ZombRand(1, 4)
        character:getEmitter():playSound("female_grunt" .. num)
    else
        local num = ZombRand(1, 6)
	    character:getEmitter():playSound("male_grunt" .. num)
    end
end

Events.OnWeaponSwing.Add(PlayGruntSound)

-- Mod Options

if ModOptions and ModOptions.getInstance then
	local SETTINGS = {
		options = { 
			dynamicgrunts = true,
		},
		names = {
			dynamicgrunts = "UI_DynamicGruntSounds",
		},
		mod_id = "PlayerGruntSounds",
		mod_shortname = "Player Grunt Sounds",
	}
	
    local settings = ModOptions:getInstance(SETTINGS)
	ModOptions:loadFile()

    local opt1 = settings:getData("dynamicgrunts")
    opt1.tooltip = "UI_DynamicGruntSoundsTooltip"

    function opt1:OnApplyInGame(val)
        dynamic_grunts = val
    end

    dynamic_grunts = settings.options.dynamicgrunts
end