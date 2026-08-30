--Made by Snake
OpenFLeadBox = {};


OpenFLeadBox.doMenu = function(player, context, items)
	local FLeadBox = nil;
	local itemsCrafting = {};
    local c = 0;
	for i,v in ipairs(items) do
		local tempitem = v;
        if not instanceof(v, "InventoryItem") then
            tempitem = v.items[1];
        end
		if tempitem:getType() ~= nil and FLBoxDefs[tempitem:getType()] then
			FLeadBox = tempitem;
		end
		itemsCrafting[c + 1] = tempitem;
		c = c + 1;
		if c > 1 then
			FLeadBox = nil;
		end
	end
	if FLeadBox == nil then
		return
	end
	if FLeadBox ~= nil then
		local FLeadBoxOption = context:addOption(getText("ContextMenu_OpenFLeadBox") .. FLeadBox:getDisplayName(), items, nil, player);
		local OpenFLeadBoxSubMenu = context:getNew(context);
		context:addSubMenu(FLeadBoxOption, OpenFLeadBoxSubMenu);
		local tooltip = ISInventoryPaneContextMenu.addToolTip();
		tooltip:setName(getText("ContextMenu_OpenFLeadBox"));
		tooltip.description = getText("ContextMenu_OpenFLeadBoxTT");
		tooltip:setTexture(FLeadBox:getTexture():getName());
		
		for i,k in pairs(items) do
			if not instanceof(k, "InventoryItem") then
				if #k.items > 2 then
					local OpenFLeadBoxSubMenuOption1 = OpenFLeadBoxSubMenu:addOption(getText("ContextMenu_One"), items, OpenFLeadBox.OpenFLeadBox_OnCreate, player, 1);
					OpenFLeadBoxSubMenuOption1.toolTip = tooltip;
					--local OpenFLeadBoxSubMenuOption2 = OpenFLeadBoxSubMenu:addOption(getText("ContextMenu_IdentifyHalf"), items, OpenFLeadBox.StudyPlant_OnCreate, player, 2);
					--OpenFLeadBoxSubMenuOption2.toolTip = tooltip;
					local OpenFLeadBoxSubMenuOption3 = OpenFLeadBoxSubMenu:addOption(getText("ContextMenu_IdentifyAll"), items, OpenFLeadBox.OpenFLeadBox_OnCreate, player, 3);
					OpenFLeadBoxSubMenuOption3.toolTip = tooltip;
					break;
				else
					local OpenFLeadBoxSubMenuOption = OpenFLeadBoxSubMenu:addOption(getText("ContextMenu_One"), items, OpenFLeadBox.OpenFLeadBox_OnCreate, player, 3);
					OpenFLeadBoxSubMenuOption.toolTip = tooltip;
					break;
				end
			else
				local OpenFLeadBoxSubMenuOption = OpenFLeadBoxSubMenu:addOption(getText("ContextMenu_One"), items, OpenFLeadBox.OpenFLeadBox_OnCreate, player, 3);
				OpenFLeadBoxSubMenuOption.toolTip = tooltip;
				break;
			end
		end
	end
end

OpenFLeadBox.OpenFLeadBox_OnCreate = function(items, playernum, directive)
	local player = getSpecificPlayer(playernum);
	local count = 0;
	for i,k in ipairs(items) do
		if not instanceof(k, "InventoryItem") then
			if directive == 1 then
				count = math.floor((#k.items - 1) / (#k.items - 1))
			elseif directive == 2 then
				count =  math.floor((#k.items - 1) / 2)
			else
				count =  math.floor(#k.items - 1)
			end
			-- first in a list is a dummy duplicate, so ignore it.
			for i2=1,count do
				local k2 = k.items[i2+1]
				if luautils.haveToBeTransfered(player, k2) then
					ISTimedActionQueue.add(ISInventoryTransferAction:new(player, k2, k2:getContainer(), player:getInventory()))
				end
				OpenFLeadBox.EquipFLBox(k2, player);
				ISTimedActionQueue.add(OpenFLeadBoxAction:new(player, k2, 100));
			end
		else
			if luautils.haveToBeTransfered(player, k) then
				ISTimedActionQueue.add(ISInventoryTransferAction:new(player, k, k:getContainer(), player:getInventory()))
			end
			OpenFLeadBox.EquipFLBox(k, player);
			ISTimedActionQueue.add(OpenFLeadBoxAction:new(player, k, 100));
		end
	end
end

OpenFLeadBox.EquipFLBox = function(item, player)
	if not item:isEquipped() then
		-- equip the item first
		ISTimedActionQueue.add(ISEquipWeaponAction:new(player, item, 50, true, false))
	end
end

Events.OnFillInventoryObjectContextMenu.Add(OpenFLeadBox.doMenu);