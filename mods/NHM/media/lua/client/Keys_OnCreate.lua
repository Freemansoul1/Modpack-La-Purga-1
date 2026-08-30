function makeSpareKey(items, result, player)
	for i=1,items:size() do
        local item = items:get(i-1)
        if item:getType() == "Screwdriver" then
            result:setCondition(item:getCondition() - 0.1)
            break
        end
    end
	local theKeyId = -1;
	local newKey;
	for i=0, items:size()-1 do
		if(items:get(i):getCategory() == "Key") then
			theKeyId = items:get(i):getKeyId();
		end
	end
	local KeyItem = InventoryItemFactory.CreateItem("Base.Key"..ZombRandBetween(1,5));
	KeyItem:setKeyId(theKeyId);
	KeyItem:setName("Spare Key");
	player:getInventory():AddItem(KeyItem);
end

function KeyG(items, result, player)
	for i=1,items:size() do
        local item = items:get(i-1)
        if item:getType() == "Screwdriver" then
            result:setCondition(item:getCondition() - 0.1)
            break
        end
    end
theKeyId = ZombRandBetween(10000000,99999999);
local KeyItem = InventoryItemFactory.CreateItem("Base.Key"..ZombRandBetween(1,5));
	KeyItem:setKeyId(theKeyId);
--KeyItem:setName("Spare Key");
	player:getInventory():AddItem(KeyItem);
end

function matchDoorknobtoKey(items, result, player)
	for i=1,items:size() do
        local item = items:get(i-1)
        if item:getType() == "Screwdriver" then
            result:setCondition(item:getCondition() - 0.1)
            break
        end
    end
	local theKeyId = -1;
	local theDoorKnob = -1;

	for i=0, items:size()-1 do
		if(items:get(i):getCategory() == "Key") then
			theKeyId = items:get(i):getKeyId();
		elseif(items:get(i):getType() == "Doorknob") then
			theDoorKnob = items:get(i);
		end
	end
	
	if(theKeyId ~= -1) then
	--player:Say("keyid:" .. tostring(theKeyId) .. " | DoorId:" .. tostring(theDoorKnob:getKeyId()));
		theDoorKnob:setKeyId(theKeyId);
	--player:Say("keyid:" .. tostring(theKeyId) .. " | DoorId:" .. tostring(theDoorKnob:getKeyId()));
	else
		sendClientCommand(player, "LockCrafting", "Say", {saythis = getText("UI_NoID")});
		player:Say(getText("UI_NoID"));
	end	

end

function matchKeytoDoorknob(items, result, player)
	for i=1,items:size() do
        local item = items:get(i-1)
        if item:getType() == "Screwdriver" then
            result:setCondition(item:getCondition() - 0.1)
            break
        end
    end
	local theDoorKnobId = -1;
	local theKey = -1;

	for i=0, items:size()-1 do
		if(items:get(i):getType() == "Doorknob") then
			theDoorKnobId = items:get(i):getKeyId();
		elseif(items:get(i):getCategory() == "Key") then
			theKey = items:get(i);
		end
	end
	
	if(theDoorKnobId ~= -1) then
	--player:Say("theDoorKnobId:" .. tostring(theDoorKnobId) .. " | theKeyid:" .. tostring(theKey:getKeyId()));
		theKey:setKeyId(theDoorKnobId);
	--player:Say("theDoorKnobId:" .. tostring(theDoorKnobId) .. " | theKeyid:" .. tostring(theKey:getKeyId()));
	else
		sendClientCommand(player, "LockCrafting", "Say", {saythis = "This Doorknob does not have a lock"});
		player:Say("This Doorknob does not have a lock");
	end	
end
