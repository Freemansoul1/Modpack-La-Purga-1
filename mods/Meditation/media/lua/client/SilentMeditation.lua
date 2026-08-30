-- Lifestyle Sound Effect Silencer

require("TimedActions/MeditateAction")

if not (MeditateAction and MeditateAction.new) then return end

Yogi = Yogi or {}

Yogi.MeditationAction = {}

Yogi.MeditationAction.new = MeditateAction.new

function MeditateAction:new(player, sound, ...)
	if Yogi.mod.options.meditateSilently then 
		sound = "DisableSoundEffects"
	end

    return Yogi.MeditationAction.new(self, player, sound, ...)
end
