local function ApplyNoDrop(player)
    local wornItems = player:getWornItems()

    for i=0, wornItems:size()-1 do
		local item = wornItems:getItemByIndex(i);
        if item.setChanceToFall  then
            -- print(item:getScriptItem():getFullName()..':getChanceToFall'..tostring(item:getChanceToFall()))
            item:setChanceToFall(0)
            -- print(item:getScriptItem():getFullName()..':getChanceToFall'..tostring(item:getChanceToFall()))
        end
    end
end

local function OnCreatePlayer(playerIndex, player)
    if (playerIndex == 0) then
        ApplyNoDrop(player)
    end
end


Events.OnClothingUpdated.Add(ApplyNoDrop)
Events.OnCreatePlayer.Add(OnCreatePlayer)