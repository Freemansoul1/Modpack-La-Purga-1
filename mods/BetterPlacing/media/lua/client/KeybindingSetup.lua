require('keyBinding.lua');

-- key bind --
local function BP_AddKeybindings()
	keyBinding[#keyBinding + 1] = { value = "[BetterPlacing Keys]" }
	keyBinding[#keyBinding + 1] = { value = "BP Adjust Height",  key = Keyboard.KEY_Z }
    keyBinding[#keyBinding + 1] = { value = "BP Reset Height",  key = Keyboard.KEY_X }
end

Events.OnGameBoot.Add(BP_AddKeybindings);