--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

-- Locations must be declared in render-order.
-- Location IDs must match BodyLocation= and CanBeEquipped= values in items.txt.

local group = BodyLocations.getGroup("Human")

local function addBodyLocationTattoo(tattooLocation)
    local group = BodyLocations.getGroup("Human");
    local list = getClassFieldVal(group, getClassField(group, 1));
    local tattooItem = group:getOrCreateLocation(tattooLocation);
    list:remove(tattooItem);
    list:add(0, tattooItem);
end

group:getOrCreateLocation("KnifeSheathLeg")

group:setExclusive("KnifeSheathLeg", "KnifeSheathLeg")

group:getOrCreateLocation("SwordSheath")

group:setExclusive("SwordSheath", "SwordSheath")

group:getOrCreateLocation("TacticalHolster")

group:setExclusive("TacticalHolster", "TacticalHolster")

group:getOrCreateLocation("HolsterVanila")

group:setExclusive("HolsterVanila", "HolsterVanila")

group:getOrCreateLocation("DaggerSheath")

group:setExclusive("DaggerSheath", "DaggerSheath")

group:getOrCreateLocation("KnifeSheathLeg")
group:getOrCreateLocation("SwordSheath")
group:getOrCreateLocation("TorsoRig")
group:getOrCreateLocation("TorsoRig2")
group:getOrCreateLocation("TacticalHolster")
group:getOrCreateLocation("UpperArmLeft")
group:getOrCreateLocation("UpperArmRight")
group:getOrCreateLocation("ThighLeft")
group:getOrCreateLocation("ThighRight")
group:getOrCreateLocation("LowerBody")
group:getOrCreateLocation("HandPlateLeft")
group:getOrCreateLocation("HandPlateRight")
group:getOrCreateLocation("ShinPlateLeft")
group:getOrCreateLocation("ShinPlateRight")
group:getOrCreateLocation("UpperArms")
group:getOrCreateLocation("UpperLegs")
group:getOrCreateLocation("LowerLegs")
group:getOrCreateLocation("LowerArms")
group:getOrCreateLocation("DaggerSheath")

addBodyLocationTattoo("Tattoo_Back")
addBodyLocationTattoo("Tattoo_Face")
addBodyLocationTattoo("Tattoo_HandLeft")
addBodyLocationTattoo("Tattoo_HandRight")
addBodyLocationTattoo("Tattoo_ArmLeft")
addBodyLocationTattoo("Tattoo_ArmRight")
addBodyLocationTattoo("Tattoo_Neck")
addBodyLocationTattoo("Tattoo_Torso")
