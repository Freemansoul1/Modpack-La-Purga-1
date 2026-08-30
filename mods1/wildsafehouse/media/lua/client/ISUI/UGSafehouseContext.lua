UGSafehouse = {}

--make these options editable through the sandbox menu
UGSafehouse.diameter = 15
UGSafehouse.buffer = 5
UGSafehouse.allowonroads = false

UGSafehouse.OnContextMenu = function( player, context, worldobjects)

	UGSafehouse.diameter = SandboxVars.UGSafehouse.diameter
	UGSafehouse.buffer = SandboxVars.UGSafehouse.buffer
	UGSafehouse.allowonroads = SandboxVars.UGSafehouse.allowonroads
	
	--print( "keyword: UGSafehouse.OnContextMenu called")
	local playerObj = getSpecificPlayer( player)
	if playerObj:getVehicle() then return end
	if SafeHouse.hasSafehouse( playerObj:getUsername()) then return end --only one safehouse!
	
	local procede, reason, limit = UGSafehouse.CanSafehouse( player)
	if limit then return end
	
	if not playerObj:getSquare():getBuilding() and not isNeutralZone(x, y) then
	
		local option = context:addOptionOnTop( "Create Safehouse", player, UGSafehouse.SetupSafehouse, procede)
		
		if not procede then

			local _tooltip = ISToolTip:new()
			_tooltip:initialise()
			_tooltip:setVisible(false)
			_tooltip.description = " <RGB:1,0,0>" .. reason
			
			option.notAvailable = true
			option.toolTip = _tooltip
		end
	end
	
	--Since multiple safehouses do not work properly, allow the vanilla claiming system to handle claiming existing buildings.
	-- else
		
		-- if ( not SafeHouse.getSafeHouse( playerObj:getSquare()) and not limit and SafeHouse.hasSafehouse( playerObj:getUsername()) and playerObj:getSquare():getBuilding():getDef()) then

			-- --print( "keyword: replacement claim")
			-- local shoption = context:addOptionOnTop( getText("ContextMenu_SafehouseClaim"), player, UGSafehouse.addSafeHouse)
			-- -- if reason ~= "" and reason = getText("IGUI_Safehouse_AlreadyHaveSafehouse") then
				-- -- local toolTip = ISWorldObjectContextMenu.addToolTip();
				-- -- toolTip:setVisible(false);
				-- -- toolTip.description = reason;
				-- -- shoption.notAvailable = true;
				-- -- shoption.toolTip = toolTip;
			-- -- end
		-- end	
	-- end
end


UGSafehouse.addSafeHouse = function( player)  --claim an existing building   This function should not be used any more.

	print( "keyword: UGSafehouse.addSafeHouse() called in wild safehouse mod, this should not happen!")
	local playerObj = getSpecificPlayer( player)
	local square = playerObj:getSquare()
	local building = square:getBuilding()
	local buildingDef = building:getDef()
	
	local diffError = 2  --this is static in the SafeHouse.class java file acts the same way as my buffer for wild safe houses

	if buildingDef ~= nil then
		SafeHouse.addSafeHouse( buildingDef:getX() - diffError, buildingDef:getY() - diffError, buildingDef:getW() + diffError * 2, buildingDef:getH() + diffError * 2, playerObj:getUsername(), false);
	else
		print( "ERROR: no definition for building: ", playerObj:getUsername())
	end
end

UGSafehouse.SetupSafehouse = function( player, procede)  --claim a wild safehouse

	--print( "keyword: UGSafehouse.SetupSafehouse called")
	
	if not procede then return end
	
	local playerObj = getSpecificPlayer( player)
	local square = playerObj:getSquare()

	local sX = square:getX()
	local sY = square:getY()
	SafeHouse.addSafeHouse( sX - UGSafehouse.diameter, sY - UGSafehouse.diameter, 2 * UGSafehouse.diameter + 1, 2 * UGSafehouse.diameter + 1, playerObj:getUsername(), false);
end

UGSafehouse.CanSafehouse = function( player)
	
	--print( "keyword: UGSafehouse.CanSafeHouse called")
	local cansafehouse = true
	local playerObj = getSpecificPlayer( player)
	--local safehouselist = SafeHouse.getSafehouseList()
	
	local daystoclaim = getServerOptions():getInteger( "SafehouseDaySurvivedToClaim")
	if daystoclaim > 0 and playerObj:getHoursSurvived() < (daystoclaim * 24) then
	
		return false, Translator.getText( "IGUI_Safehouse_DaysSurvivedToClaim", daystoclaim), false
	end
	
	--cycle through the tiles to check restrictions   -no roads -no buildings and -no other safehouses.
	local square = playerObj:getSquare()
	local sX = square:getX()
	local sY = square:getY()
	
	for i = sX - UGSafehouse.diameter - UGSafehouse.buffer, sX + UGSafehouse.diameter + UGSafehouse.buffer, 1 do
		for j = sY - UGSafehouse.diameter - UGSafehouse.buffer, sY + UGSafehouse.diameter + UGSafehouse.buffer, 1 do
		
			local square = getCell():getGridSquare( i, j, 0)

			if square and square:getBuilding() then
			
				--print(" keyword: can not create safe house, too close to another building")
				return false, "You are too close to another building to setup a safe house", false
			end

			if square and SafeHouse.getSafeHouse( square) then
			
				--print( " keyword: can not create safe house, can not overlap another safehouse")
				return false, "There is another safe house nearby", false
			end
			
			if square then  --prevent errors when searcing near the edge of the map
				for i=1,square:getObjects():size() do
				
					local obj = square:getObjects():get(i-1)
					local oTN = obj:getTextureName()
					
					if not UGSafehouse.allowonroads and oTN ~= nil and luautils.stringStarts( oTN, "blends_street")  then
					
						--print( " keyword: can not create safe house, can not overlap a road")
						return false, "You are too close to a road to setup a safe house", false
					end
				end
			end
		end
	end
	
	return true, "You're good to go!", false
end

UGSafehouse.Init = function()

	this.diameter = SandboxVars.UGSafehouse.diameter
	this.buffer = SandboxVars.UGSafehouse.buffer
end

Events.OnFillWorldObjectContextMenu.Add( UGSafehouse.OnContextMenu)