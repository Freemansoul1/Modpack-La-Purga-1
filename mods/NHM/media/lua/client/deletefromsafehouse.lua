--[[require "PrivateUI/Safehouse"
require "ISUI/UserPanel/ISSafehouseAddPlayerUI"
 
local function isAlreadySafe(safehouse, username)
    local players = safehouse:getPlayers()
    for i=0, players:size()-1 do
        if players:get(i) == username then
            return safehouse
        end
    end
end
 
function ISSafehouseAddPlayerUI:populateList()
    self.playerList:clear();
    if not self.scoreboard then return end
    for i=1,self.scoreboard.usernames:size() do
        local username = self.scoreboard.usernames:get(i-1)
        local displayName = self.scoreboard.displayNames:get(i-1)
        if self.safehouse:getOwner() ~= username then
            local newPlayer = {};
            newPlayer.username = username;
            local alreadySafe = isAlreadySafe(self.safehouse, username);
            if alreadySafe then
                if alreadySafe:getTitle() ~= "Safehouse" then
                    newPlayer.tooltip = getText("IGUI_SafehouseUI_AlreadyHaveSafehouse", "(" .. alreadySafe:getTitle() .. ")");
                else
                    newPlayer.tooltip = getText("IGUI_SafehouseUI_AlreadyHaveSafehouse" , "");
                end
            end
            local item = self.playerList:addItem(displayName, newPlayer);
            if newPlayer.tooltip then
               item.tooltip = newPlayer.tooltip;
            end
        end
    end
end

Events.EveryTenMinutes.Remove(Private.syncFactionMembers);
 
Private.syncFactionMembers = function (safehouse) end]]
