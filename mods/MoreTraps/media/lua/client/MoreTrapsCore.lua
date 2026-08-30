--[[⠀
------------------------------------------------------------------------------------------------------------------------------------------------------------      
         /\    \                  /\    \      |\    \              /\    \                  /\    \                  /\    \                  /\    \         
        /::\    \                /::\____\     |:\____\            /::\    \                /::\    \                /::\____\                /::\    \        
       /::::\    \              /:::/    /     |::|   |            \:::\    \              /::::\    \              /:::/    /               /::::\    \       
      /::::::\    \            /:::/    /      |::|   |             \:::\    \            /::::::\    \            /:::/    /               /::::::\    \      
     /:::/\:::\    \          /:::/    /       |::|   |              \:::\    \          /:::/\:::\    \          /:::/    /               /:::/\:::\    \     
    /:::/  \:::\    \        /:::/    /        |::|   |               \:::\    \        /:::/  \:::\    \        /:::/____/               /:::/__\:::\    \    
   /:::/    \:::\    \      /:::/    /         |::|   |               /::::\    \      /:::/    \:::\    \      /::::\    \              /::::\   \:::\    \   
  /:::/    / \:::\    \    /:::/    /          |::|___|______        /::::::\    \    /:::/    / \:::\    \    /::::::\    \   _____    /::::::\   \:::\    \  
 /:::/    /   \:::\ ___\  /:::/    /           /::::::::\    \      /:::/\:::\    \  /:::/    /   \:::\    \  /:::/\:::\    \ /\    \  /:::/\:::\   \:::\____\ 
/:::/____/  ___\:::|    |/:::/____/           /:::____ __\____\    /:::/  \:::\____\/:::/____/     \:::\____\/:::/  \:::\    /::\____\/:::/  \:::\   \:::|    |
\:::\    \ /\  /:::|____|\:::\    \          /:::/    /           /:::/    \::/    /\:::\    \      \::/    /\::/    \:::\  /:::/    /\::/   |::::\  /:::|____|
 \:::\    /::\ \::/    /  \:::\    \        /:::/    /           /:::/    / \/____/  \:::\    \      \/____/  \/____/ \:::\/:::/    /  \/____|:::::\/:::/    / 
  \:::\   \:::\ \/____/    \:::\    \      /:::/    /           /:::/    /            \:::\    \                       \::::::/    /         |:::::::::/    /  
   \:::\   \:::\____\       \:::\    \    /:::/    /           /:::/    /              \:::\    \                       \::::/    /          |::|\::::/    /   
    \:::\  /:::/    /        \:::\    \   \::/    /            \::/    /                \:::\    \                      /:::/    /           |::| \__/____/    
     \:::\/:::/    /          \:::\    \   \/____/              \/____/                  \:::\    \                    /:::/    /            |::|   |          
      \::::::/    /            \:::\    \                                                 \:::\    \                  /:::/    /             |::|   |          
       \::::/    /              \:::\____\                                                 \:::\____\                /:::/    /              \::|   |          
        \::/____/                \::/    /                                                  \::/    /                \::/    /                \:|   |          
                                  \/____/                                                    \/____/                  \/____/                  \|___|    
------------------------------------------------------------------------------------------------------------------------------------------------------------
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
Please contact me if you need to hire someone to do mods or other design related tasks
https://steamcommunity.com/id/glytch3r/myworkshopfiles/
https://ko-fi.com/glytch3r
Discord: Glytch3r#1337 / glytch3r


----------------------------------------------------------------------------------------------------------------------------
--]]



local fallTrapTiles = {
    ['fall_trap_01_1']=true,
    ['fall_trap_01_3']=true,
    ['fall_trap_01_5']=true,
	['fall_trap_01_0']=true,
	['fall_trap_01_6']=true,
	['fall_trap_01_18']=true,
	['fall_trap_01_19']=true,
	['fall_trap_01_20']=true,
	['fall_trap_01_21']=true,
	['fall_trap_01_22']=true,
	['fall_trap_01_23']=true,
}
local mineTrapTiles = {
    ['fall_trap_01_8']=true,
    ['fall_trap_01_9']=true,
	['fall_trap_01_2']=true,
    ['fall_trap_01_4']=true,
    ['fall_trap_01_24']=true,
	['fall_trap_01_25']=true,
    ['fall_trap_01_26']=true,
    ['fall_trap_01_27']=true,
	['fall_trap_01_28']=true,	
	['fall_trap_01_29']=true,
    ['fall_trap_01_30']=true,
    ['fall_trap_01_31']=true,
}

local zedTrapTiles = {
    ['fall_trap_01_16']=true,
    ['fall_trap_01_17']=true,
}

local sirenTrapTiles = {
    ['fall_trap_01_10']=true,
    ['fall_trap_01_11']=true,
}





local function doSledge(object)
        local sq = object:getSquare()
        if isClient() then          
			sledgeDestroy(object)  
			if isDebugEnabled() then print(object:getSprite():getName()) end 
        else                         
            sq:RemoveTileObject(object);
            sq:getSpecialObjects():remove(object);
            sq:getObjects():remove(object);
            sq:transmitRemoveItemFromSquare(object)
        end
end

local function isFallTrapTile(spr)
    return fallTrapTiles[spr] or false
end

local function isMineTrapTile(spr)
    return mineTrapTiles[spr] or false
end

local function isZedTrapTile(spr)
    return zedTrapTiles[spr] or false
end

local function isSirenTrapTile(spr)
    return sirenTrapTiles[spr] or false
end


local function steppedOnTrap(char)
    if not char then return end
    local sq = getCell():getGridSquare(char:getX(),char:getY(),char:getZ()) 
	if sq and sq:getObjects() then
		local objects = sq:getObjects()
		for i=1,sq:getObjects():size() do
			local obj = sq:getObjects():get(i-1)
			if obj then 
			
				local spr = obj:getSprite()
				
				if spr and isSirenTrapTile(spr:getName())  then 	
					doSledge(obj) 
					local sq = getPlayer():getSquare() 		
					--getSoundManager():stop()  
					--getSoundManager():PlayWorldSound('VehicleSirenAlarm', sq, 0, 5, 5, false)  					
					getSoundManager():PlayWorldSound('RaidSiren', sq, 0, 4000, 5, false)  
					getSoundManager():PlayWorldSound('VehicleTireExplode', sq, 0, 5, 5, false)  
					char:startMuzzleFlash()		
					addSound(char, char:getX(),char:getY(),char:getZ(), 300, 300);
				end
				
				if spr and isZedTrapTile(spr:getName())  then 		
					if instanceof(char, "IsoPlayer") then		
						doSledge(obj) 
						
						getSoundManager():PlayWorldSound('ZombieTrip', sq, 0, 5, 5, false)  
						getSoundManager():PlayWorldSound('ZombieThumpGeneric', sq, 0, 5, 5, false)  
						getSoundManager():PlayWorldSound('MetalDoorOpen', sq, 0, 5, 5, false)  
						
						addSound(char, char:getX(),char:getY(),char:getZ(), 5, 1)
						local count =  tostring(ZombRand(1, 4))
						SendCommandToServer("/createhorde \"" .. count .. "\"");
						sq:AddWorldInventoryItem("Base.MetalPipe", 0, 0, 0);
						ISInventoryPage.dirtyUI();
					end
				end
				
				if spr and isFallTrapTile(spr:getName())  then 		
					if  char:getZ() > 0 then
						doSledge(obj) 
						
						local flr = sq:getFloor()
						if flr then doSledge(flr)  end 
						getSoundManager():PlayWorldSound('ZombieThumpGeneric', sq, 0, 5, 5, false)  
						getSoundManager():PlayWorldSound('HeadSmash', sq, 0, 5, 5, false)  
						
					else
						if instanceof(char, "IsoPlayer") then		
							char:setBumpType("stagger");	
							char:setVariable("BumpDone", true);
							char:setVariable("BumpFall", true);
							char:setVariable("BumpFallType", "pushedBehind");
							char:setVariable("BumpDone", false);
							char:reportEvent("wasBumped")
						end
					end
						getSoundManager():PlayWorldSound('ZombieTrip', sq, 0, 5, 5, false)  
		
						addSound(char, char:getX(),char:getY(),char:getZ(), 5, 1)
					
				end
				
				if spr and isMineTrapTile(spr:getName()) then 	
	
					
					doSledge(obj) 					
					
					getSoundManager():PlayWorldSound('PipeBombExplode', sq, 0, 5, 5, false)  
					getSoundManager():PlayWorldSound('BurnedObjectExploded', sq, 0, 5, 5, false)  
					getSoundManager():PlayWorldSound('VehicleTireExplode', sq, 0, 5, 5, false)
					getSoundManager():PlayWorldSound('LightFlicker', sq, 0, 5, 5, false);  
					addSound(char, sq:getX(), sq:getY(), sq:getZ(), 5, 1)
					
					local dug = IsoObject.new(sq, "floors_burnt_01_"..ZombRand(2,3), "", false)
					local dug2 = IsoObject.new(sq, "floors_burnt_01_"..ZombRand(2,3), "", false)
					
					sq:AddTileObject(dug)
					sq:AddTileObject(dug2)
					
					local args = { x = char:getX(), y = char:getY(), z = char:getZ() }
						
					if instanceof(char, "IsoPlayer") then		
						--and not char:isInvisible() 
						sendClientCommand(char, 'object', 'addExplosionOnSquare', args)
						char:startMuzzleFlash()					
						char:setBumpType("stagger");	
						char:setVariable("BumpDone", true);
						char:setVariable("BumpFall", true);
						char:setVariable("BumpFallType", "pushedBehind");
						char:setVariable("BumpDone", false);
						char:reportEvent("wasBumped")
					end
					
					if instanceof(char, "IsoZombie")  then			
						sendClientCommand(getPlayer() , 'object', 'addExplosionOnSquare', args)

					end

					
					if isClient() then
						dug:transmitCompleteItemToServer()
						dug2:transmitCompleteItemToServer()
					end
					
					ISInventoryPage.renderDirty = true;
				end
			end
		end
    end
end
Events.OnPlayerUpdate.Add(steppedOnTrap) 
Events.OnZombieUpdate.Add(steppedOnTrap) 
