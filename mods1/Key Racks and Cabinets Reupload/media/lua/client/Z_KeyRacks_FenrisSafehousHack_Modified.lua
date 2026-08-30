-------------------------------------------------------------
--[[ project zomboid non-residential safehouse hack
    to be placed in the media/lua/client directory
 
]]
local function bypassClaimChecks(worldobjects, square, player)
    local def = square:getBuilding():getDef()
    SafeHouse.addSafeHouse(def:getX() - 2, def:getY() - 2, def:getW() + 2*2, def:getH() +2*2, getSpecificPlayer(player):getUsername(), false)
end
 
ISWorldObjectContextMenu.onTakeSafeHouse = function(worldobjects, square, player)
    SafeHouse.addSafeHouse(square, getSpecificPlayer(player));
end 
 
 
Events.OnFillWorldObjectContextMenu.Add(function(player, context, worldobjects, test)
	--print("KEY RACK AND CABINET TEST")
	
	--print("PLAYER TEST 2:" .. tostring(player))
	local keyRack = nil
	local keyCabinet = nil
	for x in pairs(worldobjects) do
		if worldobjects[x]:getProperties() then
			if worldobjects[x]:getProperties():Val("GroupName") then
				GroupName = worldobjects[x]:getProperties():Val("GroupName")
				CustomName = worldobjects[x]:getProperties():Val("CustomName")
				if GroupName == "Key" then
					if CustomName == "Rack" then
						keyRack = true
						--print("KEY RACK")
					end
					if CustomName == "Cabinet" then
						keyCabinet = true
						--print("KEY CABINET")
					end
				end
				-- if GroupName == "Key Rack" then
					-- keyRack = true
					-- print("KEY RACK")
				-- end
				-- if GroupName == "Key Cabinet" then
					-- keyCabinet = true
					-- print("KEY CABINET")
				-- end
			end
		end
	end	
	
	if keyRack ~= true and keyCabinet ~= true then
		--if option and option.toolTip.description == getText("ContextMenu_SafehouseClaim") then
		--return false
		--print("NO KEY CABINET OR RACK")
	end

	local option = nil
    for _, opt in pairs(context.options) do
        if opt.name == getText("ContextMenu_SafehouseClaim") then
            option = opt
            break
        end
    end
	
    if not option then return end
	
		
    if option.name and option.name == getText("ContextMenu_SafehouseClaim") 
	and keyCabinet ~= true 
	and( keyRack ~= true  )then
        option.notAvailable = true
        option.toolTip = ISWorldObjectContextMenu.addToolTip();
        option.toolTip.description = "Key Rack or Key Cabinet required."
    end
	
	
    if option.toolTip and option.toolTip.description == getText("IGUI_Safehouse_NotHouse") 
	and keyCabinet == true then
        option.notAvailable = false
        option.toolTip = nil
        option.onSelect = bypassClaimChecks
    end





    -- local option = nil
    -- for _, opt in pairs(context.options) do
        -- if opt.name == getText("ContextMenu_SafehouseClaim") then
            -- option = opt
            -- break
        -- end
    -- end
    -- if not option then return end
    -- if option.name == getText("ContextMenu_SafehouseClaim") and keyCabinet ~= true and keyRack ~= true then
		-- print("NO KEY RACK OR CABINET")
		-- option.notAvailable = true
		-- option.toolTip = nil
		-- option.onSelect = nil
    -- end
    -- if option.toolTip.description == getText("IGUI_Safehouse_NotHouse")
	-- and keyCabinet == true then
        -- option.notAvailable = false
        -- option.toolTip = nil
        -- option.onSelect = bypassClaimChecks
    -- end
end)


