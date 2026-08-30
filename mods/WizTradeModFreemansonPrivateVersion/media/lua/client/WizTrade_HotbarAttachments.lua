require "Hotbar/ISHotbarAttachDefinition"
if not ISHotbarAttachDefinition then
    return
end


local Wiz_SentaiHelmet_Chip_Light = {
	type = "Wiz_SentaiHelmet_Chip_Light",-- Name shown in the slot icon
	name = "Miner Hat", -- what is this name for?
	animset = "back", -- Animation name 
	attachments = {
		Wiz_AttachLight = "Wiz_AttachLight", -- defined in AttachedLocations.lua
	},
}
table.insert(ISHotbarAttachDefinition, Wiz_SentaiHelmet_Chip_Light);


local Wiz_SentaiHelmet_Chip_Radio = {
	type = "Wiz_SentaiHelmet_Chip_Radio",-- Name shown in the slot icon
	name = "Chip Radio", 
	animset = "back", -- Animation name 
	attachments = {
		Wiz_AttachRadio = "Wiz_AttachRadio", -- defined in AttachedLocations.lua
	},
}
table.insert(ISHotbarAttachDefinition, Wiz_SentaiHelmet_Chip_Radio);


local Wiz_BobaFettAntena = {
	type = "Wiz_BobaFettAntena",-- Name shown in the slot icon
	name = "Light Attachment", 
	animset = "back", -- Animation name 
	attachments = {
		Wiz_AttachBobaFettLight = "Wiz_AttachBobaFettLight", -- defined in AttachedLocations.lua
	},
}
table.insert(ISHotbarAttachDefinition, Wiz_BobaFettAntena);


local Wiz_Jaspion_Light = {
	type = "Wiz_Jaspion_Light",-- Name shown in the slot icon
	name = "Light Attachment", 
	animset = "back", -- Animation name 
	attachments = {
		Wiz_Jaspion_Light_Type = "Wiz_Jaspion_Light_Type", -- defined in AttachedLocations.lua
	},
}
table.insert(ISHotbarAttachDefinition, Wiz_Jaspion_Light);


local Wiz_MinerHelmet_Light = {
	type = "Wiz_MinerHelmet_Light",-- Name shown in the slot icon
	name = "Light Attachment", 
	animset = "back", -- Animation name 
	attachments = {
		Wiz_AttachMinerHelmet_Light = "Wiz_AttachMinerHelmet_Light", -- defined in AttachedLocations.lua
	},
}
table.insert(ISHotbarAttachDefinition, Wiz_MinerHelmet_Light);
