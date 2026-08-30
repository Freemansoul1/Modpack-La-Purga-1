require "TC_Logic.lua"

-- To work in SinglePlayer without Bugs or Freezes


local function OnZombieUpdate(zombie)
	if not SandboxVars.TrueCrawl.StealhModeEnable == true then return end;
	if not SandboxVars.TrueCrawl.StealhModeServer == false then return end;


	if SandboxVars.TrueCrawl.StealhModeEnable == true then
	
		if SandboxVars.TrueCrawl.StealhModeServer == false then
		
			if TC_Stealth == true then 
			
			zombie:setUseless(true)
			--print("Zombie is Useless")
			
			elseif TC_Stealth == false then
			zombie:setUseless(false)
			--print("Zombie is not Useless")
			
			end
			
		end
	end
end

Events.OnZombieUpdate.Add(OnZombieUpdate)