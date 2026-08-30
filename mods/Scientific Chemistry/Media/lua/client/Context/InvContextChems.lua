--***********************************************************
--**                    THE INDIE STONE                    **
--**			Author: turbotutone		   **
--***********************************************************

ISInventoryMenuElements = ISInventoryMenuElements or {};

function ISInventoryMenuElements.ContextChem()
    local self 		= ISMenuElement.new();
    self.invMenu	= ISContextManager.getInstance().getInventoryMenu();

    function self.init()
    end

    function self.createMenu( _item )
        if _item:getType() == "Stimpack" or _item:getType() == "SuperStimpack" or _item:getType() == "MedX" or _item:getType() == "Jet" or _item:getType() == "Mentats" or _item:getType() == "Psycho" or _item:getType() == "Buffout" or _item:getType() == "Xcell" or _item:getType() == "Daytrip"  or _item:getType() == "Cateye" or _item:getType() == "Rocket" or _item:getType() == "Fixer" or _item:getType() == "Bufftats" or _item:getType() == "Buffjet" or _item:getType() == "Slasher" then
            self.invMenu.context:addOption(getText("ContextMenu_UseChem"), self.invMenu, self.useChem, _item );
        end
    end

    function self.useChem( _p, _item )
	ISInventoryPaneContextMenu.transferIfNeeded(_p.player, _item)
	ISTimedActionQueue.add(ISUseChem:new(_p.player, _item));
    end
    return self;
end


