ISInventoryRenameGunNotch = {};

require "ISInventoryPaneContextMenu"

local function predicateNotBroken(item)
	return not item:isBroken()
end

ISInventoryRenameGunNotch.addRenameContextOption = function(character, context, items)
    local isWeapon = nil;

    for i, v in ipairs(items) do
        local item = v;

        if not instanceof(v, "InventoryItem") then
            item = v.items[1];
        end

        if instanceof(item, "HandWeapon") then
            isWeapon = item;
        end
    end

    local playerObj = getSpecificPlayer(character);
    local playerInv = playerObj:getInventory();

    local hasScrewdriver = playerInv:containsTagEvalRecurse("Screwdriver", predicateNotBroken);

    if isWeapon and hasScrewdriver and isWeapon:getSubCategory() == "Firearm" and (isWeapon:getModData().notchName == nil or isWeapon:getModData().notchName == "") then
        if isWeapon:getModData().notchName == nil then
            isWeapon:getModData().notchName = "";
            isWeapon:getModData().notchCreator = "";
        end
        context:addOption(getText("UI_Rename_Weapon_Notch"), isWeapon, ISInventoryRenameGunNotch.onRenameWeaponNotch, character);
    end
end

ISInventoryRenameGunNotch.onRenameWeaponNotch = function(weapon, character)
    local window = ISTextBox:new(0, 0, 280, 180, getText("UI_Rename_Weapon_Notch_Window"), weapon:getModData().notchName, nil, ISInventoryRenameGunNotch.onRenameWeaponNotchSuccess, character, getSpecificPlayer(character), weapon);
    window:initialise();
    window:addToUIManager();
end

function ISInventoryRenameGunNotch:onRenameWeaponNotchSuccess(button, character, weapon)
    if button.internal == "OK" then
        if button.parent.entry:getText() ~= nil then
            local playerName = character:getUsername();
            weapon:getModData().notchCreator = playerName;
            weapon:getModData().notchName = button.parent.entry:getText();
            local charData = getPlayerData(character:getPlayerNum());
            charData.playerInventory:refreshBackpacks();
            charData.lootInventory:refreshBackpacks();
        end
    end
end

Events.OnPreFillInventoryObjectContextMenu.Add(ISInventoryRenameGunNotch.addRenameContextOption);