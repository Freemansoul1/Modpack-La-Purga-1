--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

-- Locations must be declared in render-order.
-- Location IDs must match BodyLocation= and CanBeEquipped= values in items.txt.
local group = BodyLocations.getGroup("Human")



group:getOrCreateLocation("WizBracers")
group:getOrCreateLocation("WizArmbands")

group:getOrCreateLocation("WizTorsoBags")
group:getOrCreateLocation("WizTorsoBadge")
group:getOrCreateLocation("WizBeltBag")
group:getOrCreateLocation("WizBeltAddons")
group:getOrCreateLocation("WizCape")

group:getOrCreateLocation("WizLegsExtra")
group:getOrCreateLocation("WizKnee")
group:getOrCreateLocation("WizBootExtra")

group:getOrCreateLocation("WizShield")
group:getOrCreateLocation("WizCCCapsule")
group:getOrCreateLocation("WizFaceAdd")

group:getOrCreateLocation("WizEyeLens")
group:getOrCreateLocation("WizTail")
group:getOrCreateLocation("WizWings")



