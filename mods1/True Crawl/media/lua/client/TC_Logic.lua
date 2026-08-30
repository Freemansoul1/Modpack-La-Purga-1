
		----------------------------------------------------------------------------------------------------------------------
		--										True Crawl Logic Script by iLusioN											--
		--					Do Not Copy Any Of This! But if you do anyway, at least give me the CREDITS!					--
		----------------------------------------------------------------------------------------------------------------------
		
		-- Bug dos zumbis não atacarem um jogador em pé enquanto outro está em stealth foi resolvido.
		
 -- For thoses that would like to create an extension for my mod, you can see if it is enabled using IsTrueCrawlEnabled variable. Also can call IsCrawling / isCrawling / TC_Stealth

		
require 'UI/KeyBindMod'		

Crawl = Crawl or {}
Crawl.Verbose = false
Crawl.key = 'Crawl_Key'
Crawl.Variable = 'isCrawling'
KBM.addKeyBinding('[Player Control]', Crawl.key, 33)--'F' for qwerty/azerty

--------------------
IsCrawling = false
TC_Stealth = false
--------------------
local Functions = require "TrueCrawl/Functions"
local Moodle = require "TrueCrawl/Moodle"


-------------------------------------------------------
-- Em caso do jogador alterar a tecla de Crouch
local old_MainOptionsApply = MainOptions.apply

function MainOptions:apply (closeAfter)
	MainOptions.saveKeys();
	old_MainOptionsApply(self, closeAfter)
	crouchKey = getCore():getKey("Crouch")
	
end
-------------------------------------------------------


Crawl.OnPlayerUpdate = function (isoPlayer)
    if not isoPlayer or not isoPlayer:isLocalPlayer() then return end -- To work with NPCs.
	if not PlaVar.computeAndGetSync(isoPlayer:getPlayerNum()) then return end -- Wait for sendClientCommand to be available
	
	-- Local Variables
----------------------------------------------------------------------------------------------------------------------------
	local player = getPlayer()
	local isSneaking = isoPlayer:isSneaking()
	local isAiming = isoPlayer:isAiming()
	local Weapon = isoPlayer:getPrimaryHandItem()
	local IsTurning = isoPlayer:getVariableBoolean("isTurning")
	local IsTurningAround = isoPlayer:getVariableBoolean("isTurningAround")
	local IsTurning90 = isoPlayer:getVariableBoolean("isTurning90")
	local IsClimbing = isoPlayer:getVariableBoolean("ClimbFenceStarted")
	local isSprint = isoPlayer:isSprinting()
	local isRun = isoPlayer:isRunning()
	local isMoving = isoPlayer:isPlayerMoving()
	local stats = isoPlayer:getStats()
	local Endurance = isoPlayer:getStats():getEndurance()
	--print(crouchKey)
----------------------------------------------------------------------------------------------------------------------------
	
	-- Debug:
	
	--if IsTrueCrawlEnabled then
	--print("IS TRUE CRAWL ENABLED!")
	--end
	
	--if IsCrawling == true then
	--player:Say("Is Crawling is True!")
	--else
	--player:Say("Is Crawling is False!")
	--end
	
----------------------------------------------------------------------------------------------------------------------------

	if IsUnderVehicle == true then return end -- A função não roda se estiver embaixo de veículos.
	
	
	-- Remove todas as variáveis se não estiver de acordo.
	if IsCrawling == false or isSneaking == false or isoPlayer:hasTimedActions() then
		TC_Stealth = false 
		IsCrawling = false
		isoPlayer:setBannedAttacking(false)
		isoPlayer:setIgnoreAimingInput(false)
		getCore():addKeyBinding("Crouch", crouchKey);
		Events.OnZombieUpdate.Remove(Crawl.OnZombieUpdate)
		-- Not Used Anymore:
		--isoPlayer:setBlockMovement(false)
		--isoPlayer:setIgnoreInputsForDirection(false)
		
		if isoPlayer:getVariableBoolean("isCrawling") ~= false then
			--print("isCrawling is not false!")
			Crawl.SetCrawling(isoPlayer, false)
		end
	end


------------------------------------------------------------------------------------------
--------------------------------- IS CRAWLING MANAGER ------------------------------------
	
	if IsCrawling == true then 
	--print("IsCrawling is true!")
	
		if SandboxVars.TrueCrawl.RealisticEndurance == true then
			--print("Realistic Endurance is ACTIVATED!")
		
			if Endurance < 0.1 and isMoving then
				--print("Too tired to crawl!")
				isoPlayer:setVariable("isCrawlingTired", "true")
			else
			isoPlayer:setVariable("isCrawlingTired", "false")
			end
			
					-- Endurance Reduction when Crawl
			if Endurance > 0.1 and isMoving and not isRun and not isSprint then
				--print(Endurance)
				stats:setEndurance(stats:getEndurance() - 0.000075) -- por volta de 3:40 minutos na vida real
			
				elseif Endurance > 0.1 and isMoving and isRun and not isSprint then
				--print(Endurance)
				stats:setEndurance(stats:getEndurance() - 0.00012) -- por volta de 1:20 minutos na vida real
				
				--elseif Endurance > 0.01 and isMoving and isSprint and not isRun then -- Não precisa do sprint, já funciona bem com o vanilla. Por volta de 30 segundos.
				--stats:setEndurance(stats:getEndurance() - 0.00005)
				--print(Endurance)
			end
		end
		
		-- TODO Realistic Encumbrance
		--[[if SandboxVars.TrueCrawl.RealisticEncumbrance == true then
			if isoPlayer:getMoodles():getMoodleLevel(MoodleType.HeavyLoad) >= 3 then
			--print("TOO HEAVY TO CRAWL!")
			local TooHeavy = isoPlayer:getVariableBoolean("isTooHeavy")
			isoPlayer:setVariable("isTooHeavy", "true")
			print (TooHeavy)
			else
			isoPlayer:setVariable("isTooHeavy", "false")
			
			end--]]
		
		------------------------------------------
		-- Prevent Shove when Crawling
		if isoPlayer:getVariableBoolean("isCrawling") and not isAiming then
		--print("Variable isCrawling is true!")
		isoPlayer:setBannedAttacking(true)
		elseif not isoPlayer:getVariableBoolean("isCrawling") then
		isoPlayer:setBannedAttacking(false)
		end
		------------------------------------------

		
		------------------------------------------
		-- Prevent animation issues
		if IsTurning then
		getCore():addKeyBinding("Crouch", Keyboard.NONE)
		--print("Is turning!")
		return
		elseif not IsTurning then
		getCore():addKeyBinding("Crouch", crouchKey);
		end
		------------------------------------------
		-- Prevent animation issues
		if isMoving or IsTurningAround then 
		isoPlayer:setIgnoreAimingInput(true)
		--print("isMoving!")
		
		elseif not isMoving and not IsTurningAround then
		isoPlayer:setIgnoreAimingInput(false)
		end
		------------------------------------------

		
		if isAiming then
		
			if Weapon == nil or not Weapon:IsWeapon() then
			--print("Its not even a Weapon")
			getCore():addKeyBinding("Crouch", Keyboard.NONE);

			elseif Weapon:IsWeapon() and not Weapon:isRanged() then
			--print("Its a Weapon but not Ranged Weapon")
			getCore():addKeyBinding("Crouch", Keyboard.NONE);
			
			elseif Weapon:IsWeapon() and Weapon:isRanged() then
			--print("Its endeed a Ranged Weapon")
			getCore():addKeyBinding("Crouch", Keyboard.NONE);
			TC_Stealth = false
			PlayerDetected = true
			isoPlayer:setBannedAttacking(false)
			Events.OnZombieUpdate.Remove(Crawl.OnZombieUpdate)
			end
			
		elseif not isAiming then
		getCore():addKeyBinding("Crouch", crouchKey);
		
		end
	end
	
-------------------------------------------------------------------------------
--------------------- STEALTH BUFF CONTROL ------------------------------------

	if SandboxVars.TrueCrawl.StealhModeEnable == true then
		if TC_Stealth == true then
		--print("Stealth Mode = TRUE")
			
			if SandboxVars.TrueCrawl.MoodleEnable == true then
				Moodle.setValue(1.0) -- ON
			end
		
			
			if not (player:getAccessLevel() == "Admin") and SandboxVars.TrueCrawl.StealhModeServer == true then
				player:setGhostMode(true)
				--print("SERVER MODE: Stealth ON")
			
			end
			
		end
	
		if TC_Stealth == false then
		--print("Stealth Mode = FALSE")
		
			if SandboxVars.TrueCrawl.MoodleEnable == true then
				Moodle.setValue(2.0) -- OFF
			end
			
			if not (player:getAccessLevel() == "Admin") and SandboxVars.TrueCrawl.StealhModeServer == true then
				player:setGhostMode(false)
				--print("SERVER MODE: Stealth OFF")
			
			end
		end
	end
----------------------------------------------------------------------

-----------------------------------------------------------------------
	if isoPlayer:isSitOnGround() then return end
	
	if isKeyPressed(getCore():getKey(Crawl.key)) and IsCrawling == true and not isAiming and not IsTurning and not IsClimbing then
		--ISTimedActionQueue.clear(isoPlayer)
		IsCrawling = false
		Events.OnZombieUpdate.Remove(Crawl.OnZombieUpdate) -- Remove o Evento ZombieUpdate
		return
	end

	if isKeyPressed(getCore():getKey(Crawl.key)) and isSneaking and not isoPlayer:hasTimedActions() and not isAiming and not IsTurning and not IsClimbing and not isSprint then
	
		if IsCrawling == false then 
		
			-- Adiciona animações
			--ISTimedActionQueue.clear(isoPlayer)
			--ISTimedActionQueue.add(ISTrueCrawlInit:new(isoPlayer))
			
			--isoPlayer:setVariable("isCrawling", "true")
			--PlaVar.set(isoPlayer,"isCrawling","true",isIt)
			Crawl.SetCrawling(isoPlayer, true)
			IsCrawling = true
			
			if SandboxVars.TrueCrawl.StealhModeEnable == true then
			Events.OnZombieUpdate.Add(Crawl.OnZombieUpdate) -- Adiciona o Evento ZombieUpdate
			
			end
		end
	end
end


-----------------------------------------------------------------------------------------------------
-- To sync animations on MP
Crawl.SetCrawling = function (isoPlayer, isIt)
	print("SetCrawling Function is Running!")
    if Crawl.Verbose then print ('Crawl.SetCrawling '..p2str(isoPlayer)..' '..tab2str(isIt)); end
    PlaVar.set(isoPlayer, Crawl.Variable, isIt)
	
end
-----------------------------------------------------------------------------------------------------


Crawl.OnZombieUpdate = function (zombie)

	for playerIndex = 0, getNumActivePlayers() -1 do
	local playerObj = getSpecificPlayer(playerIndex)
	
		-------------------------------------------------------------
		-- Controla o que acontece quando o player é visto
		if SandboxVars.TrueCrawl.CancelCrawlWhenSpotted == true then
			if zombie:getTarget() == playerObj then 
				--print("ZOMBIE SPOTTED!")
				IsCrawling = false
				Events.OnZombieUpdate.Remove(Crawl.OnZombieUpdate)
				return; 
			end
		
		elseif SandboxVars.TrueCrawl.CancelCrawlWhenSpotted == false then
			if zombie:getTarget() == playerObj then
			--print("ZOMBIE SPOTTED!")
			PlayerDetected = true
			TC_Stealth = false
			Events.OnZombieUpdate.Remove(Crawl.OnZombieUpdate)
			return;
			end
		end


		if IsCrawling == false then
		Events.OnZombieUpdate.Remove(Crawl.OnZombieUpdate)	
			return;
		end

		-------------------------------------------------------------
		-- calcula tudo e define se pode ou não adicionar o buff
		if IsCrawling == true then 
			if zombie:getTarget() ~= playerObj then
				--print("Is Not Target")

				local playerPos = Functions.getCoords(playerObj)
				local zombiePos = Functions.getCoords(zombie)
				local distance = math.sqrt(((playerPos.x - zombiePos.x)^2) + ((playerPos.y - zombiePos.y)^2))
				--print("Distance: ", distance)
				
				if distance < SandboxVars.TrueCrawl.ZombieRadius then 
					PlayerDetected = true
						
					TC_Stealth = false
						
					--print("PlayerDetected: ", PlayerDetected)
					Events.OnZombieUpdate.Remove(Crawl.OnZombieUpdate)
						
					elseif distance > SandboxVars.TrueCrawl.ZombieRadius then
					
					PlayerDetected = false
					TC_Stealth = true
						
					--print("PlayerDetected: ", PlayerDetected)
						
				end
			end
		end
	end
end


Crawl.EveryOneMinute = function ()

		-- Debug:
		--print("Every One Minute Check")
		
		--if TC_Stealth == true then
		--print("Stealth Mode : TRUE")
		--else
		--print("Stealth Mode : FALSE")
		--end
		
	if IsCrawling == true and PlayerDetected == true then
		--print("Testing EveryOneMinute Check Function!")
		PlayerDetected = false
		Events.OnZombieUpdate.Add(Crawl.OnZombieUpdate)
	end
end

Crawl.OnGameStart = function (isoPlayer)
	crouchKey = getCore():getKey("Crouch")
	local playerObj = getPlayer()
	
	-- To make easy to check if the mod is enabled or not. Its not local, you can call anywhere.
	playerObj:setVariable("IsTrueCrawlEnabled", "true")
	IsTrueCrawlEnabled = playerObj:getVariableBoolean("IsTrueCrawlEnabled")
	print("TRUE CRAWL : IsTrueCrawlEnabled? ", "[",IsTrueCrawlEnabled,"]")
------------------------------------------------------------------------------------------------------------
	
	-- Controls the Stealth Mode Sandbox Value.
	if SandboxVars.TrueCrawl.StealhModeEnable == true then
		Events.EveryOneMinute.Add(Crawl.EveryOneMinute)
		Moodle.createType(getPlayer())
	end
end


-- To make sure that crouchKey will not stop working.
Crawl.OnDisconnect = function ()
	crouchKey = getCore():getKey("Crouch")
end


-------------------------------------------------
Events.OnDisconnect.Add(Crawl.OnDisconnect)
Events.OnGameStart.Add(Crawl.OnGameStart)
Events.OnPlayerUpdate.Add(Crawl.OnPlayerUpdate)


