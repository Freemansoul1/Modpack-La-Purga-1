require "Hotbar/ISHotbarAttachDefinition"
if not ISHotbarAttachDefinition then
    return
end

local KnifeSheathLeg = {
	type = "KnifeSheathLeg",
	name = "KnifeSheathLeg",
	animset = "belt right",
	attachments = {
		Knife = "Knife in Sheath (Leg)",
	},
}
table.insert(ISHotbarAttachDefinition, KnifeSheathLeg);

local SwordSheath = {
	type = "SwordSheath",
	name = "SwordSheath",
	animset = "back",
	attachments = {
		Sword = "Sword in Sheath",
	},
}
table.insert(ISHotbarAttachDefinition, SwordSheath);

local TacticalHolster = {
	type = "TacticalHolster",
	name = "TacticalHolster",
	animset = "belt left",
	attachments = {
		TacticalHolster = "Tactical Holster",
	},
}
table.insert(ISHotbarAttachDefinition, TacticalHolster);

local HolsterVanila = {
	type = "HolsterVanila",
	name = "HolsterVanila",
	animset = "holster left",
	attachments = {
		TacticalHolster = "Holster Vanila"
	},
}
table.insert(ISHotbarAttachDefinition, HolsterVanila);

local DaggerSheath = {
	type = "DaggerSheath",
	name = "DaggerSheath",
	animset = "belt right",
	attachments = {
		DaggerSheath = "Dagger Sheath",
	},
}
table.insert(ISHotbarAttachDefinition, DaggerSheath);
