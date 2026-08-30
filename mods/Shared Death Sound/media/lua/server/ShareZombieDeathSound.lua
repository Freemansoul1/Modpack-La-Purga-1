--[[
*                                                       
*              ^_^         Y U M M Y         ^_^        
*                                                       
*                 ~ Deliciously Made by YUMMY ~         
*                                                       
*                          :3  :3  :3                 
*
]]

local function shareZombieDeathSound (zombie)
    zombie:playSound("HeadStab")
    zombie:playSound("HeadSmash")
end

Events.OnZombieDead.Add(shareZombieDeathSound)