--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

local group = AttachedLocations.getGroup("Human")


group:getOrCreateLocation("Knife in Sheath (Leg)"):setAttachmentName("Knife_Sheath_Leg")

if getDebug() then
	group:getOrCreateLocation("OnLeg"):setAttachmentName("leg")
end

group:getOrCreateLocation("Sword in Sheath"):setAttachmentName("Sword_Sheath")

if getDebug() then
	group:getOrCreateLocation("OnBack"):setAttachmentName("back")
end

group:getOrCreateLocation("Tactical Holster"):setAttachmentName("Tactical_Holster")

if getDebug() then
	group:getOrCreateLocation("OnLeg"):setAttachmentName("leg")
end

group:getOrCreateLocation("Holster Vanila"):setAttachmentName("Holster_Vanila")

if getDebug() then
	group:getOrCreateLocation("OnLeg"):setAttachmentName("leg")
end

group:getOrCreateLocation("Dagger Sheath"):setAttachmentName("Dagger_Sheath")

if getDebug() then
	group:getOrCreateLocation("OnLeg"):setAttachmentName("leg")
end

