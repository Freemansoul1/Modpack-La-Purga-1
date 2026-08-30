
local GreentimeDown = 0;
local RedtimeDown = 0;
local BluetimeDown = 0;
local PurpletimeDown = 0;
local DarksabertimeDown = 0;
local RedtimeDDown = 0;
local YellowtimeDown = 0;
local lightByPlayer = {}

function saber_switch(key)
  local player = getPlayer()    
  
  
    if key == Keyboard.KEY_COMMA then  -- activate lightsaber
      
	  
	  if getPlayer():getPrimaryHandItem() then         -- check if the player have a item on his hand in the first place
      
      -- Turn Saber ON (Green)
      if player:getPrimaryHandItem():getType() == "Wiz_Lightsaber_Luke_Hilt" then
        local item_on = InventoryItemFactory.CreateItem("Base.Wiz_Lightsaber_Luke"); 
		
			getSoundManager():PlayWorldSoundWav('saber_on', false, player:getSquare(), 0, 0, 0, true);
			player:setPrimaryHandItem(item_on);
			--player:getInventory():Remove("Wiz_Lightsaber_Luke_Hilt");
			
			
      -- Turn Saber OFF (Green)
      elseif player:getPrimaryHandItem():getType() == "Wiz_Lightsaber_Luke" then
        local item_off = InventoryItemFactory.CreateItem("Wiz_Lightsaber_Luke_Hilt");
        
			getSoundManager():PlayWorldSoundWav('saber_off', false, player:getSquare(), 0, 0, 0, true);
			
			player:setPrimaryHandItem(item_off);
			getCell():removeLamppost(lightByPlayer[player]); -- Remove Green Light
			--player:getInventory():Remove("Wiz_Lightsaber_Luke");	
	
	  -- Turn Saber ON (Red)
      elseif player:getPrimaryHandItem():getType() == "Wiz_Lightsaber_vader_hilt" then
        local item_on = InventoryItemFactory.CreateItem("Wiz_Lightsaber_vader"); -- using add.item here creates more problems than solutions atm
        
			getSoundManager():PlayWorldSoundWav('saber_on', false, player:getSquare(), 0, 0, 0, true);
			player:setPrimaryHandItem(item_on);
			
			
	  -- Turn Saber OFF (Red)
      elseif player:getPrimaryHandItem():getType() == "Wiz_Lightsaber_vader" then
        local item_off = InventoryItemFactory.CreateItem("Wiz_Lightsaber_vader_hilt");
        
			getSoundManager():PlayWorldSoundWav('saber_off', false, player:getSquare(), 0, 0, 0, true);
			player:setPrimaryHandItem(item_off);
			getCell():removeLamppost(lightByPlayer[player]); -- Remove Red Light
				
			
	  -- Turn Saber ON (Blue)
      elseif player:getPrimaryHandItem():getType() == "Wiz_Lightsaber_ObiWan_hilt" then
        local item_on = InventoryItemFactory.CreateItem("Wiz_Lightsaber_ObiWan")
        
			getSoundManager():PlayWorldSoundWav('saber_on', false, player:getSquare(), 0, 0, 0, true);
			player:setPrimaryHandItem(item_on);
			
	  -- Turn Saber OFF (Blue)
      elseif player:getPrimaryHandItem():getType() == "Wiz_Lightsaber_ObiWan" then
        local item_off = InventoryItemFactory.CreateItem("Wiz_Lightsaber_ObiWan_hilt")
        
			getSoundManager():PlayWorldSoundWav('saber_off', false, player:getSquare(), 0, 0, 0, true);
			getCell():removeLamppost(lightByPlayer[player])    -- Remove Blue Light
			player:setPrimaryHandItem(item_off);
			
			
	-- Turn Saber ON (Purple)
      elseif player:getPrimaryHandItem():getType() == "Wiz_Lightsaber_Purple_Hilt" then
        local item_on = InventoryItemFactory.CreateItem("Wiz_Lightsaber_Purple")
        
			getSoundManager():PlayWorldSoundWav('saber_on', false, player:getSquare(), 0, 0, 0, true);
			player:setPrimaryHandItem(item_on);
			
	  -- Turn Saber OFF (Purple)
      elseif player:getPrimaryHandItem():getType() == "Wiz_Lightsaber_Purple" then
        local item_off = InventoryItemFactory.CreateItem("Wiz_Lightsaber_Purple_Hilt")
        
			getSoundManager():PlayWorldSoundWav('saber_off', false, player:getSquare(), 0, 0, 0, true);
			getCell():removeLamppost(lightByPlayer[player])    -- Remove Light
			player:setPrimaryHandItem(item_off);
			
	-- Turn Saber ON (Yellow)
      elseif player:getPrimaryHandItem():getType() == "Wiz_Lightsaber_Yellow_Hilt" then
        local item_on = InventoryItemFactory.CreateItem("Wiz_Lightsaber_Yellow")
        
			getSoundManager():PlayWorldSoundWav('saber_on', false, player:getSquare(), 0, 0, 0, true);
			player:setPrimaryHandItem(item_on);
			
	  -- Turn Saber OFF (Yellow)
      elseif player:getPrimaryHandItem():getType() == "Wiz_Lightsaber_Yellow" then
        local item_off = InventoryItemFactory.CreateItem("Wiz_Lightsaber_Yellow_Hilt")
        
			getSoundManager():PlayWorldSoundWav('saber_off', false, player:getSquare(), 0, 0, 0, true);
			getCell():removeLamppost(lightByPlayer[player])    -- Remove Light
			player:setPrimaryHandItem(item_off);
			
	
-- Turn Saber ON (Double Red)
      elseif player:getPrimaryHandItem():getType() == "Wiz_Lightsaber_double_red_Hilt" then
        local item_on = InventoryItemFactory.CreateItem("Wiz_Lightsaber_double_red")
        
			getSoundManager():PlayWorldSoundWav('saber_on', false, player:getSquare(), 0, 0, 0, true);
			player:setPrimaryHandItem(item_on);
			
	  -- Turn Saber OFF 
      elseif player:getPrimaryHandItem():getType() == "Wiz_Lightsaber_double_red" then
        local item_off = InventoryItemFactory.CreateItem("Wiz_Lightsaber_double_red_Hilt")
        
			getSoundManager():PlayWorldSoundWav('saber_off', false, player:getSquare(), 0, 0, 0, true);
			getCell():removeLamppost(lightByPlayer[player])    -- Remove Light
			player:setPrimaryHandItem(item_off);

			
		
	-- Turn Darksaber ON
      elseif player:getPrimaryHandItem():getType() == "Wiz_Darksaber_hilt" then
        local item_on = InventoryItemFactory.CreateItem("Wiz_Darksaber")
        
			getSoundManager():PlayWorldSoundWav('darksaber_on', false, player:getSquare(), 0, 0, 0, true);
			player:setPrimaryHandItem(item_on);
			player:getPrimaryHandItem():setLightDistance(2)
			player:getPrimaryHandItem():setLightStrength(0.2)
			
	  -- Turn Darksaber OFF
      elseif player:getPrimaryHandItem():getType() == "Wiz_Darksaber" then
        local item_off = InventoryItemFactory.CreateItem("Wiz_Darksaber_hilt")
        
        getSoundManager():PlayWorldSoundWav('darksaber_off', false, player:getSquare(), 0, 0, 0, true);
			player:setPrimaryHandItem(item_off);
			player:getPrimaryHandItem():setLightDistance(0)
			player:getPrimaryHandItem():setLightStrength(0)
			
		
	-- Jaspion Sword ON
      elseif player:getPrimaryHandItem():getType() == "Wiz_JaspionSword" then
        local item_on = InventoryItemFactory.CreateItem("Wiz_JapsionSword_ON")
        
			getSoundManager():PlayWorldSoundWav('darksaber_on', false, player:getSquare(), 0, 0, 0, true);
			player:setPrimaryHandItem(item_on);
			
	  -- Jaspion Sword OFF (Blue)
      elseif player:getPrimaryHandItem():getType() == "Wiz_JapsionSword_ON" then
        local item_off = InventoryItemFactory.CreateItem("Wiz_JaspionSword")
        
			getSoundManager():PlayWorldSoundWav('darksaber_off', false, player:getSquare(), 0, 0, 0, true);
			getCell():removeLamppost(lightByPlayer[player])    -- Remove Blue Light
			player:setPrimaryHandItem(item_off);


	
	
	
      end
	  
	  else

    end
	
  end
end


-- Saber Idle Sound
function saber_idle()
	local player = getPlayer();
	
	
	if player:getPrimaryHandItem() then
			
		if player:getPrimaryHandItem():getType() == "Wiz_Lightsaber_Luke" then  -- GREEN
		
	
			GreentimeDown = GreentimeDown - 1;
			if GreentimeDown <= 0 then 
				GreentimeDown = 100;
			end
			if GreentimeDown == 99 then
				getSoundManager():PlayWorldSoundWav('saber_idle', false, getPlayer():getSquare(), 0, 0, 0, false);
			end
			
		elseif player:getPrimaryHandItem():getType() == "Wiz_Lightsaber_vader" then -- RED
			RedtimeDown = RedtimeDown - 1;
			if RedtimeDown <= 0 then 
				RedtimeDown = 100;
			end
			if RedtimeDown == 99 then
				getSoundManager():PlayWorldSoundWav('saber_idle', false, getPlayer():getSquare(), 0, 0, 0, false);
			end
			
		elseif player:getPrimaryHandItem():getType() == "Wiz_Lightsaber_double_red" then -- double RED
			RedtimeDDown = RedtimeDDown - 1;
			if RedtimeDDown <= 0 then 
				RedtimeDDown = 100;
			end
			if RedtimeDDown == 99 then
				getSoundManager():PlayWorldSoundWav('saber_idle', false, getPlayer():getSquare(), 0, 0, 0, false);
			end
			
		elseif player:getPrimaryHandItem():getType() == "Wiz_Lightsaber_ObiWan" then -- BLUE
			BluetimeDown = BluetimeDown - 1;
			if BluetimeDown <= 0 then 
				BluetimeDown = 100;
			end
			if BluetimeDown == 99 then
				getSoundManager():PlayWorldSoundWav('saber_idle', false, getPlayer():getSquare(), 0, 0, 0, false);
			end
			
		elseif player:getPrimaryHandItem():getType() == "Wiz_Darksaber" then -- Darksaber
			DarksabertimeDown = DarksabertimeDown - 1;
			if DarksabertimeDown <= 0 then 
				DarksabertimeDown = 100;
			end
			if DarksabertimeDown == 99 then
				getSoundManager():PlayWorldSoundWav('darksaber_idle', false, getPlayer():getSquare(), 0, 0, 0, false);
			end
			
	    elseif player:getPrimaryHandItem():getType() == "Wiz_Lightsaber_Purple" then -- PURPLE
			PurpletimeDown = PurpletimeDown - 1;
			if PurpletimeDown <= 0 then 
				PurpletimeDown = 100;
			end
			if PurpletimeDown == 99 then
				getSoundManager():PlayWorldSoundWav('saber_idle', false, getPlayer():getSquare(), 0, 0, 0, false);
			end
			
		elseif player:getPrimaryHandItem():getType() == "Wiz_Lightsaber_Yellow" then -- YELLOW
			YellowtimeDown = YellowtimeDown - 1;
			if YellowtimeDown <= 0 then 
				YellowtimeDown = 100;
			end
			if YellowtimeDown == 99 then
				getSoundManager():PlayWorldSoundWav('saber_idle', false, getPlayer():getSquare(), 0, 0, 0, false);
			end
			
		else
		end
	else
	end
	
end


function saber_color(player)
	
	if player:getPrimaryHandItem() then
	
		if player:getPrimaryHandItem():getType() == "Wiz_Lightsaber_Luke" then  -- GREEN
	
			if lightByPlayer[player] ~= nil then
				lightByPlayer[player]:setActive(false)
				getCell():removeLamppost(lightByPlayer[player])
			end
			
				lightByPlayer[player] = IsoLightSource.new(player:getX(), player:getY(), player:getZ(), 0.0, 1.3, 0.0, 4)
				getCell():addLamppost(lightByPlayer[player])
				
				
		elseif player:getPrimaryHandItem():getType() == "Wiz_Lightsaber_vader" then  -- RED
	
			if lightByPlayer[player] ~= nil then
				lightByPlayer[player]:setActive(false)
				getCell():removeLamppost(lightByPlayer[player])
			end
			
				lightByPlayer[player] = IsoLightSource.new(player:getX(), player:getY(), player:getZ(), 1.3, 0.0, 0.0, 4)
				getCell():addLamppost(lightByPlayer[player])
				
				
		elseif player:getPrimaryHandItem():getType() == "Wiz_Lightsaber_ObiWan" then  -- BLUE
	
			if lightByPlayer[player] ~= nil then
				lightByPlayer[player]:setActive(false)
				getCell():removeLamppost(lightByPlayer[player])
			end
			
				lightByPlayer[player] = IsoLightSource.new(player:getX(), player:getY(), player:getZ(), 0.0, 0.3, 1.0, 4)
				getCell():addLamppost(lightByPlayer[player])
				
		elseif player:getPrimaryHandItem():getType() == "Wiz_Lightsaber_Purple" then  -- PURPLE
	
			if lightByPlayer[player] ~= nil then
				lightByPlayer[player]:setActive(false)
				getCell():removeLamppost(lightByPlayer[player])
			end
			
				lightByPlayer[player] = IsoLightSource.new(player:getX(), player:getY(), player:getZ(), 0.3, 0.0, 1.0, 4)
				getCell():addLamppost(lightByPlayer[player])
				
				
		elseif player:getPrimaryHandItem():getType() == "Wiz_Lightsaber_Yellow" then  -- YELLOW
	
			if lightByPlayer[player] ~= nil then
				lightByPlayer[player]:setActive(false)
				getCell():removeLamppost(lightByPlayer[player])
			end
			
				lightByPlayer[player] = IsoLightSource.new(player:getX(), player:getY(), player:getZ(), 1.0, 0.9, 0.0, 4)
				getCell():addLamppost(lightByPlayer[player])
				
		elseif player:getPrimaryHandItem():getType() == "Wiz_Lightsaber_double_red" then  -- double red
	
			if lightByPlayer[player] ~= nil then
				lightByPlayer[player]:setActive(false)
				getCell():removeLamppost(lightByPlayer[player])
			end
			
				lightByPlayer[player] = IsoLightSource.new(player:getX(), player:getY(), player:getZ(), 1.0, 0.0, 0.0, 4)
				getCell():addLamppost(lightByPlayer[player])
			
			
		elseif player:getPrimaryHandItem():getType() == "Wiz_JapsionSword_ON" then  -- BLUE JASPION
	
			if lightByPlayer[player] ~= nil then
				lightByPlayer[player]:setActive(false)
				getCell():removeLamppost(lightByPlayer[player])
			end
			
				lightByPlayer[player] = IsoLightSource.new(player:getX(), player:getY(), player:getZ(), 0.0, 0.3, 1.0, 4)
				getCell():addLamppost(lightByPlayer[player])


		
				
			
		
	
		else
				--getCell():removeLamppost(lightByPlayer[player])
		end

	else
	end
end








Events.OnKeyPressed.Add(saber_switch);
Events.OnPlayerUpdate.Add(saber_idle);
Events.OnPlayerUpdate.Add(saber_color);

-- 332 updates in 10 seconds
-- 316 ticks in 10 seconds