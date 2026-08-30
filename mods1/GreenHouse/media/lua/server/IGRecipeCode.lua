--From IMPROVISED GLASS MOD
-- Give back the recipe result AND include the original roasting pan too
function ImprovisedGlass_GiveBackRoastingPan(items, result, player)
    player:getInventory():AddItem(result);
    player:getInventory():AddItem("Base.RoastingPan");
end

--[[Give back a glass pane and the original responses
function ImprovisedGlass_GiveBackGlassPane(items, result, player)
    player:getInventory():AddItem(result);
    player:getInventory():AddItem("ImprovisedGlass.GlassPane");

end]]
