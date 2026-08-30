require "TimedActions/ISRemoveGrass"

local YL_ISRemoveGrass = {};

YL_ISRemoveGrass.Old_perform = ISRemoveGrass.perform

function ISRemoveGrass:perform()

    local t_O = YL_ISRemoveGrass.Old_perform(self);

    self.character:getInventory():AddItem("traps.Grass");

end
