-- i tried to make this as friendly as possible for people who have never looked at a lua document before, if you know what you're doing feel free to ignore or delete all the comments. if you're new, the stuff after a -- are notes i've left for you, they don't impact the code at all so you are free to delete them if they're annoying :)
-- please remember that if you use this to add new spaces you can repair in, the changes will be applied every time the save is loaded. this is only a problem if you use the in-game tools to remove one of the squares you have set here in this file

require "RU_extraRepairZones" -- makes this file rely on RU_extraRepairZones, this is very important (do not delete!)

local zonesToAdd = {
						{X = 0, Y = 0, Z = 0, utilityType = "Elec"}, -- set to your preferred X/Y/Z co-ordinates, then choose which utility is repairable here ("Elec" for power, "Water" for water)
						{X = 1, Y = 1, Z = 0, utilityType = "Water"}, -- copy and paste infinitely to your heart's content to add more squares, don't forget to include the comma after the }
} -- this little } by itself might seem insignificant, but it's very important, do not delete :)

local function onSaveLoad() -- when setup properly (see the last line) this will run each time a save is loaded, but this is only an example, if you know what you're doing you can change this to a different event, or not run it at all and do it your own way :)
	for i, v in ipairs(zonesToAdd) do
		RU_AddNewCoords(v) -- i'm not going to do this here, but you could also remove any coords you don't want by instead having the code run RU_RemoveOldCoords(v)
	end
end

--Events.OnInitGlobalModData.Add(onSaveLoad) -- remove the first -- before Events, otherwise this code won't actually run