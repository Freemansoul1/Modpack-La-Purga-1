function Recipe.OnCreate.OpenFood(items, result, player)
    player:getInventory():AddItem("Base.EmptyJar");
    player:getInventory():AddItem("Base.JarLid");
end

function Recipe.OnCreate.GetPaperBag(items, result, player)
    player:getInventory():AddItem("Base.PaperBag");
end

function Recipe.OnCreate.GetJar(items, result, player)
    player:getInventory():AddItem("Base.EmptyJar");
end
