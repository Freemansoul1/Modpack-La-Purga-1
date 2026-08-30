local ammoCount;
local originalDoMagazineMenu = ISInventoryPaneContextMenu.doMagazineMenu;

function ISInventoryPaneContextMenu.doMagazineMenu(playerObj, magazine, context)
    originalDoMagazineMenu(playerObj, magazine, context);
    
    ammoCount = playerObj:getInventory():getItemCountRecurse(magazine:getAmmoType());
    if ammoCount > magazine:getMaxAmmo() then
        ammoCount = magazine:getMaxAmmo();
    end
    if ammoCount > magazine:getMaxAmmo() - magazine:getCurrentAmmoCount() then
        ammoCount = magazine:getMaxAmmo() - magazine:getCurrentAmmoCount();
    end
        
    local option = context:getOptionFromName(getText("ContextMenu_InsertBulletsInMagazine", ammoCount));
    if not option then return context end;
    option.iconTexture = getTexture(getExpandedIconPath("InsertBulletsInMagazine.png"));
end

local originalDoReloadMenuForBullets = ISInventoryPaneContextMenu.doReloadMenuForBullets;

function ISInventoryPaneContextMenu.doReloadMenuForBullets(playerObj, bullet, context)
    originalDoReloadMenuForBullets(playerObj, bullet, context);
    
    for i=0, playerObj:getInventory():getItems():size()-1 do
        local item = playerObj:getInventory():getItems():get(i);
        if not instanceof(item, "HandWeapon") and item:getAmmoType() == bullet:getFullType() then
            if item:getCurrentAmmoCount() < item:getMaxAmmo() then
                ammoCount = playerObj:getInventory():getItemCountRecurse(item:getAmmoType())
                if ammoCount > item:getMaxAmmo() then
                    ammoCount = item:getMaxAmmo()
                end
                if ammoCount > item:getMaxAmmo() - item:getCurrentAmmoCount() then
                    ammoCount = item:getMaxAmmo() - item:getCurrentAmmoCount()
                end
            end
        end
    end

    local option = context:getOptionFromName(getText("ContextMenu_InsertBulletsInMagazine", ammoCount));
    if not option then return context end;
    option.iconTexture = getTexture(getExpandedIconPath("InsertBulletsInMagazine.png"));
end