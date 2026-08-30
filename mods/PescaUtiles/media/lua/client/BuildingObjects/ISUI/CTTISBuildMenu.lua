--***********************************************************
--**                    ROBERT JOHNSON                     **
--**       Contextual menu for building when clicking somewhere on the ground       **
--***********************************************************

CTTISBuildMenu = {};
CTTISBuildMenu.LeGourmetEPMod = 0;
CTTISBuildMenu.LeGourmetBuild = nil;
CTTISBuildMenu.LeGourmetCanBuild = nil;

local function predicateNotBroken(item)
	return not item:isBroken()
end

CTTISBuildMenu.doBuildMenu = function(player, context, worldobjects, test)

	if test and ISWorldObjectContextMenu.Test then return true end
	CTTISBuildMenu.LeGourmetBuild = nil;
	CTTISBuildMenu.LeGourmetCanBuild = nil;
	CTTISBuildMenu.LeGourmetEPMod = 0;
    if getCore():getGameMode()=="LastStand" then
        return;
    end
	local playerObj = getSpecificPlayer(player)
	if playerObj:getVehicle() then return; end
	local playerInv = playerObj:getInventory()
	
	if LGISBuildMenu then
		CTTISBuildMenu.LeGourmetEPMod = 1;
		if LGISBuildMenu.haveSomethingtoBuild then
			CTTISBuildMenu.LeGourmetBuild = true;
		end
	end

	local thump = nil;

	local square = nil;

	-- we get the thumpable item (like wall/door/furniture etc.) if exist on the tile we right clicked
	for i,v in ipairs(worldobjects) do
		square = v:getSquare();
		if instanceof(v, "IsoThumpable") and not v:isDoor() then
			thump = v;
		end
    end
	

	-- build menu
	-- if we have any thing to build in our inventory
	if CTTISBuildMenu.LeGourmetEPMod == 1 then
		if CTTISBuildMenu.LeGourmetBuild ~= nil then
			CTTISBuildMenu.LeGourmetCanBuild = LGISBuildMenu.haveSomethingtoBuild(player)
			--CTTISBuildMenu.LeGourmetCanBuild = true;
		end
		if CTTISBuildMenu.LeGourmetCanBuild ~= nil then
		--if AMISBuildMenu.haveSomethingtoBuild(player) ~= nil or LGISBuildMenu.haveSomethingtoBuild(player) ~= nil then
			if test then return ISWorldObjectContextMenu.setTest() end
			if playerInv:containsTypeEvalRecurse("Hammer", predicateNotBroken) or playerInv:containsTypeEvalRecurse("HammerStone", predicateNotBroken) or playerInv:containsTypeEvalRecurse("BallPeenHammer", predicateNotBroken) or  (playerInv:containsTypeRecurse("BlowTorch") and playerInv:containsTypeRecurse("WeldingMask")) or ISBuildMenu.cheat then
				local buildOption = context:addOption(getText("ContextMenu_Extra_Building"), worldobjects, nil);
				-- create a brand new context menu wich contain our different material (wood, stone etc.) to build
				local subMenu = ISContextMenu:getNew(context);
				-- We create the different option for this new menu (wood, stone etc.)
				-- check if we can build something in wood material

				if CTTISBuildMenu.LeGourmetCanBuild ~= nil then
					if haveSomethingtoBuildTrophy(player) then
						context:addSubMenu(buildOption, subMenu);
				
						LGISBuildMenu.doBuildMenu(player, context, worldobjects, test, square, subMenu)
					end
				end

			end
		end
	end
end

Events.OnFillWorldObjectContextMenu.Add(CTTISBuildMenu.doBuildMenu);
