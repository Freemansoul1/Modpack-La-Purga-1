local function initMycologist()
	local mycologist = TraitFactory.addTrait("Mycologist", getText("UI_trait_mycologist"), 4, getText("UI_trait_mycologistdesc"), false)
	mycologist:addXPBoost(Perks.Mycology, 2);
end

Events.OnGameBoot.Add(initMycologist);

function RnRRecipeIdentify(items, result, player, selectedItem)
    player:getInventory():AddItem(selectedItem:getModData().IdentifiedItem);
end

function RnRRecipeIdentifyBasicXP(recipe, ingredients, result, player)
    RnRClientAddMycologyXP(player, 4);
end

function RnRRecipeIdentifyActiveXP(recipe, ingredients, result, player)
    RnRClientAddMycologyXP(player, 6);
end

function RnRRecipeIdentifyMedicinalXP(recipe, ingredients, result, player)
    RnRClientAddMycologyXP(player, 8);
end

function RnRClientAddMycologyXP(player, xp)
    player:getXp():AddXP(Perks.Mycology, xp, true, true, true);
end
