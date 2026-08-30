
require 'SharedMoats'

function Moats.predicateDigMoats(item)
    return not item:isBroken() and item:hasTag("DigGrave")
end

function Moats.onDigMoats(worldobjects, player, shovel)
    local bo = ISEmptyMoats:new(Moats.EastSprite, Moats.WestSprite, Moats.SouthSprite, Moats.NorthSprite, shovel);
    bo.player = player;
    getCell():setDrag(bo, bo.player);
end

function Moats.doMenu(player, context, worldobjects, test)
    if test then return true end
    
    local playerObj = getSpecificPlayer(player);
    local playerInv = playerObj:getInventory();
    local shovel = playerInv:getFirstEvalRecurse(Moats.predicateDigMoats);
    
    if (JoypadState.players[player+1] or ISEmptyMoats.canDigHere(worldobjects)) and not playerObj:getVehicle() and shovel then
        context:addOption(getText("ContextMenu_DigMoats"), worldobjects, Moats.onDigMoats, player, shovel);
    end
end

Events.OnFillWorldObjectContextMenu.Add(Moats.doMenu);
