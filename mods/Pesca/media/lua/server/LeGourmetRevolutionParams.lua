overwriteparam = {
	{ 
		Item = "Base.FishFillet";
		Param = {
			"DangerousUncooked = TRUE"
		}
	},
	{ 
		Item = "Base.Salmon";
		Param = {
			"DisplayName = Salmon Fillet"
		}
	},
	{ 
		Item = "Base.FishingLine";
		Param = {
			"Tooltip = Tooltip_FishingLine"
		}
	},
	{ 
		Item = "Base.FishingRodBreak";
		Param = {
			"Tooltip = Tooltip_FishingRodBreak",
			"DisplayName	= Fishing Rod Without line"
		}
	},
	{ 
		Item = "Base.Catfish";
		Param = {
			"RemoveUnhappinessWhenCooked = false"
		}
	},
	{ 
		Item = "Base.Bass";
		Param = {
			"Icon = FishLbass",
			"Weight = 1.1",
			"HungerChange = -15",
			"RemoveUnhappinessWhenCooked = false"
		}
	},
	{ 
		Item = "Base.Perch";
		Param = {
			"RemoveUnhappinessWhenCooked = false"
		}
	},
	{ 
		Item = "Base.Crappie";
		Param = {
			"DisplayName = Crappie Fish",
			"RemoveUnhappinessWhenCooked = false"
		}
	},
	{ 
		Item = "Base.Panfish";
		Param = {
			"RemoveUnhappinessWhenCooked = false"
		}
	},
	{ 
		Item = "Base.Pike";
		Param = {
			"RemoveUnhappinessWhenCooked = false"
		}
	},
	{ 
		Item = "Base.Trout";
		Param = {
			"RemoveUnhappinessWhenCooked = false"
		}
	},
	{ 
		Item = "Base.BaitFish";
		Param = {
			"HungerChange = -5",
			"RemoveUnhappinessWhenCooked = false"
		}
	},
	{ 
		Item = "Base.FishingTackle";
		Param = {
			"FishingLure = false",
			"Tooltip = Tooltip_FishingTacklenew"
		}
	},
	{ 
		Item = "Base.FishingTackle2";
		Param = {
			"FishingLure = false",
			"Tooltip = Tooltip_FishingTacklenew"
		}
	},
	{ 
		Item = "Base.RubberBand";
		Param = {
			"Weight = 0.01"
		}
	},
};

local Debug = false;
if isDebugEnabled() then
	Debug = true;
end
for i = 1, #overwriteparam do
	if Debug then
		print ("Le Gourmet Revolution Rewriting Item: " .. tostring(overwriteparam[i].Item));
	end
	local script = ScriptManager.instance:getItem(overwriteparam[i].Item)
	for c = 1, #overwriteparam[i].Param do
		if script then
			if Debug then
				print ("New Parameter: " .. tostring(overwriteparam[i].Param[c]));
			end
			script:DoParam(overwriteparam[i].Param[c])
		end
	end
end
