--require("MutiesContextMenuIcons/HelperFunctions");

--MutiesContextMenuIcons.Options["ContextMenu_Grab_one"] =
--getExpandedIconPath("Grab.png");

--MutiesContextMenuIcons.Options["ContextMenu_Grab_half"] =
--getExpandedIconPath("GrabHalf.png");

--MutiesContextMenuIcons.Options["ContextMenu_Grab_all"] =
--getExpandedIconPath("GrabAll.png");

--MutiesContextMenuIcons.Options["ContextMenu_Grab"] =
--getExpandedIconPath("Grab.png");

local originalDoGrabMenu = ISInventoryPaneContextMenu.doGrabMenu

function ISInventoryPaneContextMenu.doGrabMenu(context, items, player)
    originalDoGrabMenu(context, items, player);

    local option = context:getOptionFromName(getText("ContextMenu_Grab"));
    if option then
        option.iconTexture = getTexture(getExpandedIconPath("Grab.png"));
    end

	local optionGrabOne = context:getOptionFromName(getText("ContextMenu_Grab_one"));
	if optionGrabOne then
		optionGrabOne.iconTexture = getTexture(getExpandedIconPath("Grab.png"));
	end

	local optionGrabHalf = context:getOptionFromName(getText("ContextMenu_Grab_half"));
    if optionGrabHalf then
        optionGrabHalf.iconTexture = getTexture(getExpandedIconPath("GrabHalf.png"));
    end

    local optionGrabAll = context:getOptionFromName(getText("ContextMenu_Grab_all"));
    if optionGrabAll then
        optionGrabAll.iconTexture = getTexture(getExpandedIconPath("GrabAll.png"));
    end
end

local originalHandleGrabWorldItem = ISWorldObjectContextMenu.handleGrabWorldItem

function ISWorldObjectContextMenu.handleGrabWorldItem(x, y, test, context, worldobjects, playerObj, playerInv)
    originalHandleGrabWorldItem(x, y, test, context, worldobjects, playerObj, playerInv);

    local option = context:getOptionFromName(getText("ContextMenu_Grab"));
    if not option then return end
    option.iconTexture = getTexture(getExpandedIconPath("Grab.png"));
end

--[[
local function setIcons (subMenuItem, name)
    local optionGrabOne = subMenuItem:getOptionFromName(getText("ContextMenu_Grab_one", name));
    if optionGrabOne then
        optionGrabOne.iconTexture = getTexture(getExpandedIconPath("GrabOne.png"));
    end
    
	local optionGrabHalf = subContext:getOptionFromName(getText("ContextMenu_Grab_half"));
    if optionGrabHalf then
        optionGrabHalf.iconTexture = getTexture(getRedrawedIconPath("GrabHalf.png"));
    end

    local optionGrabAll = subMenuItem:getOptionFromName(getText("ContextMenu_Grab_all", name));
    if optionGrabAll then
        optionGrabAll.iconTexture = getTexture(getOriginalIconPath("GrabAll.png"));
    end
end


local originalHandleGrabWorldItem = ISWorldObjectContextMenu.handleGrabWorldItem

function ISWorldObjectContextMenu.handleGrabWorldItem(x, y, test, context, worldobjects, playerObj, playerInv)
    originalHandleGrabWorldItem(x, y, test, context, worldobjects, playerObj, playerInv);

    local option = context:getOptionFromName(getText("ContextMenu_Grab"));
    if not option then return end
    option.iconTexture = getTexture(getExpandedIconPath("Grab.png"));

	--
    local playerNum = playerObj:getPlayerNum()
	local player = playerNum

	local squares = {}
	local doneSquare = {}
	for i,v in ipairs(worldobjects) do
		if v:getSquare() and not doneSquare[v:getSquare()] then
			doneSquare[v:getSquare()] = true
			table.insert(squares, v:getSquare())
		end
	end

	if #squares == 0 then return false end

	local worldObjects = {}
	if JoypadState.players[playerNum+1] then
		for _,square in ipairs(squares) do
			for i=1,square:getWorldObjects():size() do
				local worldObject = square:getWorldObjects():get(i-1)
				table.insert(worldObjects, worldObject)
			end
		end
	else
		local squares2 = {}
		for k,v in pairs(squares) do
			squares2[k] = v
		end
		local radius = 1
		for _,square in ipairs(squares2) do
			local worldX = screenToIsoX(playerNum, x, y, square:getZ())
			local worldY = screenToIsoY(playerNum, x, y, square:getZ())
			ISWorldObjectContextMenu.getSquaresInRadius(worldX, worldY, square:getZ(), radius, doneSquare, squares)
		end
		ISWorldObjectContextMenu.getWorldObjectsInRadius(playerNum, x, y, squares, radius, worldObjects)
	end

	if #worldObjects == 0 then return false end

	local itemList = {}
	for _,worldObject in ipairs(worldObjects) do
		local itemName = worldObject:getName() or (worldObject:getItem():getName() or "???")
		if not itemList[itemName] then itemList[itemName] = {} end
		table.insert(itemList[itemName], worldObject)
	end

	--local grabOption = context:addOption(getText("ContextMenu_Grab"), worldobjects, nil)
	local subMenuGrab = ISContextMenu:getNew(context)
	--context:addSubMenu(grabOption, subMenuGrab)
	for name,items in pairs(itemList) do
		--if items[1] and items[1]:getSquare() and items[1]:getSquare():isWallTo(playerObj:getSquare()) then
			--context:removeLastOption();
			--break;
		--end
		if #items > 1 then
			name = name..' ('..#items..')'
		end
		if #items > 2 then
			--local itemOption = subMenuGrab:addOption(name, worldobjects, nil)
			local subMenuItem = ISContextMenu:getNew(subMenuGrab)
            setIcons(subMenuItem, name);
			--subMenuGrab:addSubMenu(itemOption, subMenuItem)
			--subMenuItem:addOption(getText("ContextMenu_Grab_one"), worldobjects, ISWorldObjectContextMenu.onGrabWItem, items[1], player);
			--subMenuItem:addOption(getText("ContextMenu_Grab_half"), worldobjects, ISWorldObjectContextMenu.onGrabHalfWItems, items, player);
			--subMenuItem:addOption(getText("ContextMenu_Grab_all"), worldobjects, ISWorldObjectContextMenu.onGrabAllWItems, items, player);
		elseif #items > 1 and items[1]:getItem():getActualWeight() >= 3 then
			--local itemOption = subMenuGrab:addOption(name, worldobjects, nil)
			local subMenuItem = ISContextMenu:getNew(subMenuGrab)
            setIcons(subMenuItem, name);
			--subMenuGrab:addSubMenu(itemOption, subMenuItem)
			--subMenuItem:addOption(getText("ContextMenu_Grab_one"), worldobjects, ISWorldObjectContextMenu.onGrabWItem, items[1], player);
			--subMenuItem:addOption(getText("ContextMenu_Grab_all"), worldobjects, ISWorldObjectContextMenu.onGrabAllWItems, items, player);
		--else
			--subMenuGrab:addOption(name, worldobjects, ISWorldObjectContextMenu.onGrabAllWItems, items, player)
		end
	end
end
--]]