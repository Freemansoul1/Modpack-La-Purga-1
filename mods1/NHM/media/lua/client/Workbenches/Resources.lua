require "ISUI/ISWorldObjectContextMenu"

--Рекурсивный поиск пропановой горелки
local function predicateBlowTorch(item)
    return item:getType() == "BlowTorch"
end

local function comparatorDrainableUsesInt(item1, item2)
    return item2:getDrainableUsesInt() - item1:getDrainableUsesInt()
end

local function getBlowTorch(playerInv)
    if (playerInv:containsTypeRecurse("BlowTorch") and playerInv:containsEvalRecurse(predicateBlowTorch)) then
        local BlowTorch = playerInv:getBestTypeEvalRecurse("Base.BlowTorch", comparatorDrainableUsesInt)
        if BlowTorch:getDrainableUsesInt() == 100 then
            return "ALREADYFILLED"
        else
            return BlowTorch
        end
    end
    return nil
end

--Рекурсивный поиск пропанового баллона
local function predicatePropaneTank(item)
    return item:getType() == "PropaneTank"
end

local function getPropaneTank(playerInv)
    if (playerInv:containsTypeRecurse("PropaneTank") and playerInv:containsEvalRecurse(predicatePropaneTank)) then
        local PropaneTank = playerInv:getBestTypeEvalRecurse("Base.PropaneTank", comparatorDrainableUsesInt)
        if PropaneTank:getDrainableUsesInt() == 20 then
            return "ALREADYFILLED"
        else
            return PropaneTank
        end
    end
    return nil
end

--Рекурсивный поиск кирки
local function predicatePickAxe(item)
    return (item:hasTag("PickAxe") or item:getType() == "PickAxe") and not item:isBroken()
end

local function getPickAxe(playerInv)
    if (playerInv:containsTypeRecurse("PickAxe") and playerInv:containsEvalRecurse(predicatePickAxe)) then
        return playerInv:getItemFromType("PickAxe", true, true)
    end

    return nil
end

--Рекурсивный поиск пустой канистры
local function predicateEmptyPetrolCan(item)
    return (item:hasTag("EmptyPetrolCan") or item:getType() == "EmptyPetrolCan")
end

local function getEmptyPetrolCan(playerInv)
    if (playerInv:containsTypeRecurse("EmptyPetrolCan") and playerInv:containsEvalRecurse(predicateEmptyPetrolCan)) then
        return playerInv:getItemFromType("EmptyPetrolCan", true, true)
    end

    return nil
end

--Рекурсивный поиск канистры с бензином
local function predicatePetrolCan(item)
    return item:getType() == "PetrolCan"
end

local function getPetrolCan(playerInv)
    if (playerInv:containsTypeRecurse("PetrolCan") and playerInv:containsEvalRecurse(predicatePetrolCan)) then
        local PetrolCan = playerInv:getBestTypeEvalRecurse("Base.PetrolCan", comparatorDrainableUsesInt)
        if PetrolCan:getDrainableUsesInt() == 8 then
            return "ALREADYFILLED"
        else
            return PetrolCan
        end
    end
    return nil
end


--Контекстное меню
function Work_Stations(player, context, worldobjects, test)

    if test and ISWorldObjectContextMenu.Test then
        return true
    end

    if getCore():getGameMode() == "LastStand" then
        return ;
    end

    if test then
        return ISWorldObjectContextMenu.setTest()
    end

    scavengeZone = nil;
    local playerObj = getSpecificPlayer(player)
    local x1 = getPlayer():getX();
    local y1 = getPlayer():getY();
    local z1 = getPlayer():getZ();

    if playerObj:getVehicle() then
        return ;
    end

    local trash_pit

    local gasst

    local copper_mine
    local tin_mine
    local iron_mine
    local galena_mine
    local nickel_mine
    local chromium_mine
    local sulfur_mine
    local lime_mine
    local coal_mine
    local stone_mine
    local salt_mine

    local entry_lab
    local exit_lab

    local entry_bunker1
    local entry_bunker2
    local entry_bunker3
    local exit_bunker1
    local exit_bunker2
    local exit_bunker3

    local active_comp
    local petrol_bunker
    local weaponparts
    local trainer
    local bankomat

    local microchip
    local luk
    local lestnica
    local obvjesy

    --Проверка выбранного тайла
    for i, v in ipairs(worldobjects) do

        if v:getSprite():getName() == nil then
            return ;
        end
        local spriteName = v:getSprite():getName()
        x = v:getX();
        y = v:getY();
        if spriteName == "A1 ae_bunker_0"
                or spriteName == "A1 ae_bunker_1" or spriteName == "A1 ae_bunker_2" or spriteName == "A1 ae_bunker_3" or spriteName == "A1 ae_bunker_4"
                or spriteName == "A1 ae_bunker_5" or spriteName == "A1 ae_bunker_6" or spriteName == "A1 ae_bunker_7" or spriteName == "A1 ae_bunker_8"
                or spriteName == "A1 ae_bunker_9" or spriteName == "A1 ae_bunker_10" or spriteName == "A1 ae_bunker_11" or spriteName == "A1 ae_bunker_12"
                or spriteName == "A1 ae_bunker_13" or spriteName == "A1 ae_bunker_14" or spriteName == "A1 ae_bunker_15" or spriteName == "A1 ae_bunker_16"
                or spriteName == "A1 ae_bunker_17" or spriteName == "A1 ae_bunker_18" or spriteName == "A1 ae_bunker_19" or spriteName == "A1 ae_bunker_20"
                or spriteName == "A1 ae_bunker_21" or spriteName == "A1 ae_bunker_22" or spriteName == "A1 ae_bunker_23" or spriteName == "A1 ae_bunker_24"
                or spriteName == "A1 ae_bunker_25" or spriteName == "A1 ae_bunker_26" or spriteName == "A1 ae_bunker_27" or spriteName == "A1 ae_bunker_28"
                or spriteName == "A1 ae_bunker_29" or spriteName == "A1 ae_bunker_30" or spriteName == "A1 ae_bunker_31" or spriteName == "A1 ae_bunker_32"
                or spriteName == "A1 ae_bunker_33" or spriteName == "A1 ae_bunker_34" or spriteName == "A1 ae_bunker_35" or spriteName == "A1 ae_bunker_36"
                or spriteName == "A1 ae_bunker_37" or spriteName == "A1 ae_bunker_38" or spriteName == "A1 ae_bunker_39" or spriteName == "A1 ae_bunker_40"
                or spriteName == "A1 ae_bunker_41" or spriteName == "A1 ae_bunker_42" or spriteName == "A1 ae_bunker_43" or spriteName == "A1 ae_bunker_44"
                or spriteName == "A1 ae_bunker_45" or spriteName == "A1 ae_bunker_46" or spriteName == "A1 ae_bunker_47" or spriteName == "A1 ae_bunker_48"
                or spriteName == "A1 ae_bunker_49" or spriteName == "A1 ae_bunker_50" or spriteName == "A1 ae_bunker_51" or spriteName == "A1 ae_bunker_52"
                or spriteName == "A1 ae_bunker_57" or spriteName == "A1 ae_bunker_58" or spriteName == "A1 ae_bunker_59" or spriteName == "A1 ae_bunker_60"
                or spriteName == "A1 ae_bunker_61" or spriteName == "A1 ae_bunker_62" or spriteName == "A1 ae_bunker_63" or spriteName == "A1 ae_bunker_64"
                or spriteName == "A1 ae_bunker_65" or spriteName == "A1 ae_bunker_66" or spriteName == "A1 ae_bunker_67" or spriteName == "A1 ae_bunker_68"
                or spriteName == "A1 ae_bunker_69" or spriteName == "A1 ae_bunker_70" or spriteName == "A1 ae_bunker_71" or spriteName == "A1 ae_bunker_72"
                or spriteName == "A1 ae_bunker_73" or spriteName == "A1 ae_bunker_74" or spriteName == "A1 ae_bunker_75" or spriteName == "A1 ae_bunker_76"
                or spriteName == "A1 ae_bunker_77" or spriteName == "A1 ae_bunker_78" or spriteName == "A1 ae_bunker_79" or spriteName == "A1 ae_bunker_80"
                or spriteName == "A1 ae_bunker_81" or spriteName == "A1 ae_bunker_82" or spriteName == "A1 ae_bunker_83" or spriteName == "A1 ae_bunker_84"
                or spriteName == "A1 ae_bunker_85" or spriteName == "A1 ae_bunker_86" or spriteName == "A1 ae_bunker_87" or spriteName == "A1 ae_bunker_88"
                or spriteName == "A1 ae_bunker_89" or spriteName == "A1 ae_bunker_90" or spriteName == "A1 ae_bunker_91" or spriteName == "A1 ae_bunker_92"
                or spriteName == "A1 ae_bunker_93" or spriteName == "A1 ae_bunker_94" or spriteName == "A1 ae_bunker_95" or spriteName == "A1 ae_bunker_96"
        then
            trash_pit = v;
        elseif spriteName == "NHGasL_0" or spriteName == "NHGasR_0"
        then
            gasst = v;
        elseif spriteName == "A1_CULT_29"
        then
            obvjesy = v;
        elseif spriteName == "NHCopper_0"
        then
            copper_mine = v;
        elseif spriteName == "NHTin_0"
        then
            tin_mine = v;
        elseif spriteName == "NHIron_0"
        then
            iron_mine = v;
        elseif spriteName == "NHLead_0"
        then
            galena_mine = v;
        elseif spriteName == "NHNickel_0"
        then
            nickel_mine = v;
        elseif spriteName == "NHChromium_0"
        then
            chromium_mine = v;
        elseif spriteName == "NHSulfur_0"
        then
            sulfur_mine = v;
        elseif spriteName == "NHLimestone_0"
        then
            lime_mine = v;
        elseif spriteName == "NHCoal_0"
        then
            coal_mine = v;
        elseif spriteName == "NHStone_1_0" or spriteName == "NHStone_2_0"
        then
            stone_mine = v;
        elseif spriteName == "NHSalt_1_0" or spriteName == "NHSalt_2_0"
        then
            salt_mine = v;
        elseif spriteName == "A1 pinkot_0"
        then
            entry_lab = v;
        elseif spriteName == "A1 pinkot_1"
        then
            exit_lab = v;
        elseif spriteName == "A1 Tubing_11"
        then
            luk = v;
        elseif spriteName == "industry_railroad_05_36"
                or spriteName == "location_sewer_01_32"
                or spriteName == "industry_railroad_05_21"
                or spriteName == "fixtures_stairs_01_3"
                or spriteName == "fixtures_stairs_01_4"
                or spriteName == "fixtures_stairs_01_5"
                or spriteName == "industry_railroad_05_20"
        then
            lestnica = v;
        elseif spriteName == "A1 pinkot_2"
        then
            entry_bunker1 = v;
        elseif spriteName == "A1 pinkot_8"
        then
            entry_bunker2 = v;
        elseif spriteName == "A1 pinkot_10"
        then
            entry_bunker3 = v;
        elseif spriteName == "A1 pinkot_3"
        then
            exit_bunker1 = v;
        elseif spriteName == "A1 pinkot_9"
        then
            exit_bunker2 = v;
        elseif spriteName == "A1 pinkot_11"
        then
            exit_bunker3 = v;
        elseif spriteName == "A1_CULT_0"
        then
            petrol_bunker = v;
        elseif spriteName == "A1_CULT_12"
        then
            microchip = v;
        elseif spriteName == "A1_CULT_24" or spriteName == "A1_CULT_25"
                or spriteName == "A1_CULT_26" or spriteName == "A1_CULT_27"
        then
            weaponparts = v;
        elseif spriteName == "A1 decor_med_3"
        then
            active_comp = v;
        elseif spriteName == "WorkbenchAgility_1_0" or spriteName == "WorkbenchAgility_2_0"
        then
            trainer = v;
        elseif spriteName == "location_business_bank_01_64" or spriteName == "location_business_bank_01_65"
                or spriteName == "location_business_bank_01_66" or spriteName == "location_business_bank_01_67"
        then
            bankomat = v;
        end
    end

    local MineEnd = getPlayer():getXp():getXP(Perks.MineEndurance)
    local MineEndLevel = math.ceil(MineEnd / 15 * 10) / 10
    --local DocRep = getPlayer():getXp():getXP(Perks.RepDoc)
    --local DocTaskTaken = getPlayer():HasTrait('task_start_med')
    local End = getPlayer():getStats():getEndurance()
    local Fatique = getPlayer():getStats():getFatigue()
    local pickaxe = getPickAxe(getPlayer():getInventory())
    local GreenCard = getPlayer():getInventory():getItemCount("NHM.GreenCard", true);
    local YellowCard = getPlayer():getInventory():getItemCount("NHM.YellowCard", true);
    --local RedCard = getPlayer():getInventory():getItemCount("NHM.RedCard", true);
    local CreditCard = getPlayer():getInventory():getItemCount("Base.CreditCard", true);
    local EPetrolCan = getEmptyPetrolCan(getPlayer():getInventory())
    if not EPetrolCan then
        EPetrolCan = getPetrolCan(getPlayer():getInventory())
    end

    if obvjesy then
        local option_obvjesy_search = context:addOption(getText("ContextMenu_Obvjesy_Search"), worldobjects, Obvjesy_Search, player);
        local toolTip = ISToolTip:new();

        toolTip:initialise();
        toolTip:setVisible(false);
        option_obvjesy_search.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_Obvjesy_Search"));
        toolTip:setTexture("Item_RedDot");
        toolTip.description = getText("Tooltip_Search_Obvjesy") .. "\n";

        if MineEnd < 75 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "5" .. "\n";
            option_obvjesy_search.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "\n<RGB:0,1,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "5" .. "\n";
        end

        if End < 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_End");
            option_obvjesy_search.notAvailable = true;
        end
        if Fatique > 0.8 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_obvjesy_search.notAvailable = true;
        end
    end

    if microchip then
        local option_microchip_search = context:addOption(getText("ContextMenu_MicroChip_Search"), worldobjects, Microchip_Search, player);
        local toolTip = ISToolTip:new();

        toolTip:initialise();
        toolTip:setVisible(false);
        option_microchip_search.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_MicroChip_Search"));
        toolTip:setTexture("Item_Microchip");
        toolTip.description = getText("Tooltip_Search_Microchips") .. "\n";

        if MineEnd < 45 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "3" .. "\n";
            option_microchip_search.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "\n<RGB:0,1,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "3" .. "\n";
        end

        if End < 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_End");
            option_microchip_search.notAvailable = true;
        end
        if Fatique > 0.8 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_microchip_search.notAvailable = true;
        end
    end

    --Контекстное меню для свалки
    if trash_pit then
        local option_trash_search = context:addOption(getText("ContextMenu_Search_Trash"), worldobjects, Trash_search, player);
        local toolTip = ISToolTip:new();

        toolTip:initialise();
        toolTip:setVisible(false);
        option_trash_search.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_Search_Trash"));
        toolTip:setTexture("Item_Garbagebag");
        toolTip.description = getText("Tooltip_Search_Trash") .. "\n";

        if MineEnd < 15 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "1" .. "\n";
            option_trash_search.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "\n<RGB:0,1,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "1" .. "\n";
        end

        if End < 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_End");
            option_trash_search.notAvailable = true;
        end
        if Fatique > 0.8 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_trash_search.notAvailable = true;
        end

        --Контекстное меню для газовой колонки
    elseif gasst then

        --Контекстное меню для заправки пропановой горелки

        local EBlowTorch = getBlowTorch(getPlayer():getInventory())
        local option_gasstation = context:addOption(getText("ContextMenu_Extract_Gas"), worldobjects, Gas_Station, player);
        local toolTip = ISToolTip:new();

        toolTip:initialise();
        toolTip:setVisible(false);
        option_gasstation.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_Extract_Gas"));
        toolTip:setTexture("Item_BlowTorch");
        toolTip.description = getText("Tooltip_Extract_Gas") .. "\n";

        if MineEnd < 30 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "2" .. "\n";
            option_gasstation.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "\n<RGB:0,1,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "2" .. "\n";
        end

        if not EBlowTorch then
            toolTip.description = toolTip.description .. "<RGB:1,0,0>" .. getItemNameFromFullType("Base.BlowTorch") .. " 0/1\n";
            option_gasstation.notAvailable = true;
        elseif EBlowTorch == "ALREADYFILLED" then
            toolTip.description = toolTip.description .. "<RGB:1,0,0>" .. getItemNameFromFullType("Base.BlowTorch") .. " 1/1\n";
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_Full_BlowTorch") .. "\n";
            option_gasstation.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "<RGB:0,1,0>" .. getItemNameFromFullType("Base.BlowTorch") .. " 1/1\n";
        end

        if End < 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_End");
            option_gasstation.notAvailable = true;
        end
        if Fatique > 0.8 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_gasstation.notAvailable = true;
        end

        --Контекстное меню для заправки пропанового баллона

        local EPropaneTank = getPropaneTank(getPlayer():getInventory())
        local option_muchgas = context:addOption(getText("ContextMenu_Extract_MuchGas"), worldobjects, Much_Gas, player);
        local toolTip2 = ISToolTip:new();
        toolTip2:initialise();
        toolTip2:setVisible(false);
        option_muchgas.toolTip = toolTip2;
        toolTip2:setName(getText("ContextMenu_Extract_MuchGas"));
        toolTip2:setTexture("Item_PropaneTank");
        toolTip2.description = getText("Tooltip_Extract_Gas") .. "\n";

        if MineEnd < 120 then
            toolTip2.description = toolTip2.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "8" .. "\n";
            option_muchgas.notAvailable = true;
        else
            toolTip2.description = toolTip2.description .. "\n<RGB:0,1,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "8" .. "\n";
        end

        if not EPropaneTank then
            toolTip2.description = toolTip2.description .. "<RGB:1,0,0>" .. getItemNameFromFullType("Base.PropaneTank") .. " 0/1\n";
            option_muchgas.notAvailable = true;
        elseif EPropaneTank == "ALREADYFILLED" then
            toolTip2.description = toolTip2.description .. "<RGB:1,0,0>" .. getItemNameFromFullType("Base.PropaneTank") .. " 1/1\n";
            toolTip2.description = toolTip2.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_Full_PropaneTank") .. "\n";
            option_muchgas.notAvailable = true;
        else
            toolTip2.description = toolTip2.description .. "<RGB:0,1,0>" .. getItemNameFromFullType("Base.PropaneTank") .. " 1/1\n";
        end

        if End < 0.1 then
            toolTip2.description = toolTip2.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_End");
            option_muchgas.notAvailable = true;
        end
        if Fatique > 0.8 then
            toolTip2.description = toolTip2.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_muchgas.notAvailable = true;
        end

        --Контекстное меню для медной жилы
    elseif copper_mine then
        local option_mine_copper = context:addOption(getText("ContextMenu_Mine_Copper"), worldobjects, MineCopper, player);
        local toolTip = ISToolTip:new();

        toolTip:initialise();
        toolTip:setVisible(false);
        option_mine_copper.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_Mine_Copper"));
        toolTip:setTexture("Item_PickAxe");
        toolTip.description = getText("Tooltip_Mine_Copper") .. "\n"

        if MineEnd < 30 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "2" .. "\n";
            option_mine_copper.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "\n<RGB:0,1,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "2" .. "\n";
        end

        if not pickaxe then
            toolTip.description = toolTip.description .. "<RGB:1,0,0>" .. getItemNameFromFullType("Base.PickAxe") .. " 0/1" .. "\n"
            option_mine_copper.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "<RGB:0,1,0>" .. getItemNameFromFullType("Base.PickAxe") .. " 1/1" .. "\n";
        end

        if End < 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_End") .. "\n";
            option_mine_copper.notAvailable = true;
        end
        if Fatique > 0.8 and End < 0.1 then
            toolTip.description = toolTip.description .. "<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_mine_copper.notAvailable = true;
        elseif Fatique > 0.8 and End >= 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_mine_copper.notAvailable = true;
        end

        --Контекстное меню для оловянной жилы
    elseif tin_mine then
        local option_mine_tin = context:addOption(getText("ContextMenu_Mine_Tin"), worldobjects, MineTin, player);
        local toolTip = ISToolTip:new();

        toolTip:initialise();
        toolTip:setVisible(false);
        option_mine_tin.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_Mine_Tin"));
        toolTip:setTexture("Item_PickAxe");
        toolTip.description = getText("Tooltip_Mine_Tin") .. "\n"

        if MineEnd < 30 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "2" .. "\n";
            option_mine_tin.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "\n<RGB:0,1,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "2" .. "\n";
        end

        if not pickaxe then
            toolTip.description = toolTip.description .. "<RGB:1,0,0>" .. getItemNameFromFullType("Base.PickAxe") .. " 0/1" .. "\n"
            option_mine_tin.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "<RGB:0,1,0>" .. getItemNameFromFullType("Base.PickAxe") .. " 1/1" .. "\n";
        end

        if End < 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_End") .. "\n";
            option_mine_tin.notAvailable = true;
        end
        if Fatique > 0.8 and End < 0.1 then
            toolTip.description = toolTip.description .. "<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_mine_tin.notAvailable = true;
        elseif Fatique > 0.8 and End >= 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_mine_tin.notAvailable = true;
        end

        --Контекстное меню для железной жилы
    elseif iron_mine then
        local option_mine_iron = context:addOption(getText("ContextMenu_Mine_Iron"), worldobjects, MineIron, player);
        local toolTip = ISToolTip:new();

        toolTip:initialise();
        toolTip:setVisible(false);
        option_mine_iron.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_Mine_Iron"));
        toolTip:setTexture("Item_PickAxe");
        toolTip.description = getText("Tooltip_Mine_Iron") .. "\n"

        if MineEnd < 45 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "3" .. "\n";
            option_mine_iron.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "\n<RGB:0,1,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "3" .. "\n";
        end

        if not pickaxe then
            toolTip.description = toolTip.description .. "<RGB:1,0,0>" .. getItemNameFromFullType("Base.PickAxe") .. " 0/1" .. "\n"
            option_mine_iron.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "<RGB:0,1,0>" .. getItemNameFromFullType("Base.PickAxe") .. " 1/1" .. "\n";
        end

        if End < 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_End") .. "\n";
            option_mine_iron.notAvailable = true;
        end
        if Fatique > 0.8 and End < 0.1 then
            toolTip.description = toolTip.description .. "<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_mine_iron.notAvailable = true;
        elseif Fatique > 0.8 and End >= 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_mine_iron.notAvailable = true;
        end

        --Контекстное меню для свинцовой жилы
    elseif galena_mine then
        local option_mine_lead = context:addOption(getText("ContextMenu_Mine_Lead"), worldobjects, MineLead, player);
        local toolTip = ISToolTip:new();

        toolTip:initialise();
        toolTip:setVisible(false);
        option_mine_lead.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_Mine_Lead"));
        toolTip:setTexture("Item_PickAxe");
        toolTip.description = getText("Tooltip_Mine_Lead") .. "\n"

        if MineEnd < 45 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "3" .. "\n";
            option_mine_lead.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "\n<RGB:0,1,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "3" .. "\n";
        end

        if not pickaxe then
            toolTip.description = toolTip.description .. "<RGB:1,0,0>" .. getItemNameFromFullType("Base.PickAxe") .. " 0/1" .. "\n"
            option_mine_lead.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "<RGB:0,1,0>" .. getItemNameFromFullType("Base.PickAxe") .. " 1/1" .. "\n";
        end

        if End < 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_End") .. "\n";
            option_mine_lead.notAvailable = true;
        end
        if Fatique > 0.8 and End < 0.1 then
            toolTip.description = toolTip.description .. "<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_mine_lead.notAvailable = true;
        elseif Fatique > 0.8 and End >= 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_mine_lead.notAvailable = true;
        end

        --Контекстное меню для никелевой жилы
    elseif nickel_mine then
        local option_mine_nickel = context:addOption(getText("ContextMenu_Mine_Nickel"), worldobjects, MineNickel, player);
        local toolTip = ISToolTip:new();

        toolTip:initialise();
        toolTip:setVisible(false);
        option_mine_nickel.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_Mine_Nickel"));
        toolTip:setTexture("Item_PickAxe");
        toolTip.description = getText("Tooltip_Mine_Nickel") .. "\n"

        if MineEnd < 60 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "4" .. "\n";
            option_mine_nickel.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "\n<RGB:0,1,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "4" .. "\n";
        end

        if not pickaxe then
            toolTip.description = toolTip.description .. "<RGB:1,0,0>" .. getItemNameFromFullType("Base.PickAxe") .. " 0/1" .. "\n"
            option_mine_nickel.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "<RGB:0,1,0>" .. getItemNameFromFullType("Base.PickAxe") .. " 1/1" .. "\n";
        end

        if End < 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_End") .. "\n";
            option_mine_nickel.notAvailable = true;
        end
        if Fatique > 0.8 and End < 0.1 then
            toolTip.description = toolTip.description .. "<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_mine_nickel.notAvailable = true;
        elseif Fatique > 0.8 and End >= 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_mine_nickel.notAvailable = true;
        end

        --Контекстное меню для хромовой жилы
    elseif chromium_mine then
        local option_mine_chromium = context:addOption(getText("ContextMenu_Mine_Chromium"), worldobjects, MineChromium, player);
        local toolTip = ISToolTip:new();

        toolTip:initialise();
        toolTip:setVisible(false);
        option_mine_chromium.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_Mine_Chromium"));
        toolTip:setTexture("Item_PickAxe");
        toolTip.description = getText("Tooltip_Mine_Chromium") .. "\n"

        if MineEnd < 60 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "4" .. "\n";
            option_mine_chromium.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "\n<RGB:0,1,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "4" .. "\n";
        end

        if not pickaxe then
            toolTip.description = toolTip.description .. "<RGB:1,0,0>" .. getItemNameFromFullType("Base.PickAxe") .. " 0/1" .. "\n"
            option_mine_chromium.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "<RGB:0,1,0>" .. getItemNameFromFullType("Base.PickAxe") .. " 1/1" .. "\n";
        end

        if End < 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_End") .. "\n";
            option_mine_chromium.notAvailable = true;
        end
        if Fatique > 0.8 and End < 0.1 then
            toolTip.description = toolTip.description .. "<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_mine_chromium.notAvailable = true;
        elseif Fatique > 0.8 and End >= 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_mine_chromium.notAvailable = true;
        end

        --Контекстное меню для серной жилы
    elseif sulfur_mine then
        local option_mine_sulfur = context:addOption(getText("ContextMenu_Mine_Sulfur"), worldobjects, MineSulfur, player);
        local toolTip = ISToolTip:new();

        toolTip:initialise();
        toolTip:setVisible(false);
        option_mine_sulfur.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_Mine_Sulfur"));
        toolTip:setTexture("Item_PickAxe");
        toolTip.description = getText("Tooltip_Mine_Sulfur") .. "\n"

        if MineEnd < 30 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "2" .. "\n";
            option_mine_sulfur.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "\n<RGB:0,1,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "2" .. "\n";
        end

        if not pickaxe then
            toolTip.description = toolTip.description .. "<RGB:1,0,0>" .. getItemNameFromFullType("Base.PickAxe") .. " 0/1" .. "\n"
            option_mine_sulfur.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "<RGB:0,1,0>" .. getItemNameFromFullType("Base.PickAxe") .. " 1/1" .. "\n";
        end

        if End < 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_End") .. "\n";
            option_mine_sulfur.notAvailable = true;
        end
        if Fatique > 0.8 and End < 0.1 then
            toolTip.description = toolTip.description .. "<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_mine_sulfur.notAvailable = true;
        elseif Fatique > 0.8 and End >= 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_mine_sulfur.notAvailable = true;
        end

        --Контекстное меню для кальцитовой жилы
    elseif lime_mine then
        local option_mine_lime = context:addOption(getText("ContextMenu_Mine_Limestone"), worldobjects, MineLimestone, player);
        local toolTip = ISToolTip:new();

        toolTip:initialise();
        toolTip:setVisible(false);
        option_mine_lime.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_Mine_Limestone"));
        toolTip:setTexture("Item_PickAxe");
        toolTip.description = getText("Tooltip_Mine_Limestone") .. "\n"

        if MineEnd < 45 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "3" .. "\n";
            option_mine_lime.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "\n<RGB:0,1,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "3" .. "\n";
        end

        if not pickaxe then
            toolTip.description = toolTip.description .. "<RGB:1,0,0>" .. getItemNameFromFullType("Base.PickAxe") .. " 0/1" .. "\n"
            option_mine_lime.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "<RGB:0,1,0>" .. getItemNameFromFullType("Base.PickAxe") .. " 1/1" .. "\n";
        end

        if End < 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_End") .. "\n";
            option_mine_lime.notAvailable = true;
        end
        if Fatique > 0.8 and End < 0.1 then
            toolTip.description = toolTip.description .. "<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_mine_lime.notAvailable = true;
        elseif Fatique > 0.8 and End >= 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_mine_lime.notAvailable = true;
        end

        --Контекстное меню для угольной жилы
    elseif coal_mine then
        local option_mine_coal = context:addOption(getText("ContextMenu_Mine_Coal"), worldobjects, MineCoal, player);
        local toolTip = ISToolTip:new();

        toolTip:initialise();
        toolTip:setVisible(false);
        option_mine_coal.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_Mine_Coal"));
        toolTip:setTexture("Item_PickAxe");
        toolTip.description = getText("Tooltip_Mine_Coal") .. "\n"

        if MineEnd < 15 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "1" .. "\n";
            option_mine_coal.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "\n<RGB:0,1,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "1" .. "\n";
        end

        if not pickaxe then
            toolTip.description = toolTip.description .. "<RGB:1,0,0>" .. getItemNameFromFullType("Base.PickAxe") .. " 0/1" .. "\n"
            option_mine_coal.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "<RGB:0,1,0>" .. getItemNameFromFullType("Base.PickAxe") .. " 1/1" .. "\n";
        end

        if End < 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_End") .. "\n";
            option_mine_coal.notAvailable = true;
        end
        if Fatique > 0.8 and End < 0.1 then
            toolTip.description = toolTip.description .. "<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_mine_coal.notAvailable = true;
        elseif Fatique > 0.8 and End >= 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_mine_coal.notAvailable = true;
        end

        --Контекстное меню для каменной жилы
    elseif stone_mine then
        local option_mine_stone = context:addOption(getText("ContextMenu_Mine_Stone"), worldobjects, MineStone, player);
        local toolTip = ISToolTip:new();

        toolTip:initialise();
        toolTip:setVisible(false);
        option_mine_stone.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_Mine_Stone"));
        toolTip:setTexture("Item_PickAxe");
        toolTip.description = getText("Tooltip_Mine_Stone") .. "\n"

        if MineEnd < 30 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "2" .. "\n";
            option_mine_stone.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "\n<RGB:0,1,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "2" .. "\n";
        end

        if not pickaxe then
            toolTip.description = toolTip.description .. "<RGB:1,0,0>" .. getItemNameFromFullType("Base.PickAxe") .. " 0/1" .. "\n"
            option_mine_stone.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "<RGB:0,1,0>" .. getItemNameFromFullType("Base.PickAxe") .. " 1/1" .. "\n";
        end

        if End < 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_End") .. "\n";
            option_mine_stone.notAvailable = true;
        end
        if Fatique > 0.8 and End < 0.1 then
            toolTip.description = toolTip.description .. "<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_mine_stone.notAvailable = true;
        elseif Fatique > 0.8 and End >= 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_mine_stone.notAvailable = true;
        end

        --Контекстное меню для каменной жилы
    elseif salt_mine then
        local option_mine_salt = context:addOption(getText("ContextMenu_Mine_Salt"), worldobjects, MineSalt, player);
        local toolTip = ISToolTip:new();

        toolTip:initialise();
        toolTip:setVisible(false);
        option_mine_salt.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_Mine_Salt"));
        toolTip:setTexture("Item_PickAxe");
        toolTip.description = getText("Tooltip_Mine_Salt") .. "\n"

        if MineEnd < 45 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "3" .. "\n";
            option_mine_salt.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "\n<RGB:0,1,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "3" .. "\n";
        end

        if not pickaxe then
            toolTip.description = toolTip.description .. "<RGB:1,0,0>" .. getItemNameFromFullType("Base.PickAxe") .. " 0/1" .. "\n"
            option_mine_salt.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "<RGB:0,1,0>" .. getItemNameFromFullType("Base.PickAxe") .. " 1/1" .. "\n";
        end

        if End < 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_End") .. "\n";
            option_mine_salt.notAvailable = true;
        end
        if Fatique > 0.8 and End < 0.1 then
            toolTip.description = toolTip.description .. "<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_mine_salt.notAvailable = true;
        elseif Fatique > 0.8 and End >= 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_mine_salt.notAvailable = true;
        end

        --вход в лабу
    elseif entry_lab then
        local option_entry_lab = context:addOption(getText("ContextMenu_Entry_Lab"), worldobjects, EntryLab, player);
        local toolTip = ISToolTip:new();
        toolTip:initialise();
        toolTip:setVisible(false);
        option_entry_lab.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_Entry_Lab"));
        toolTip:setTexture("Item_GreenCard");
        toolTip.description = getText("Tooltip_Entry_Lab") .. "\n";
        if GreenCard < 1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getItemNameFromFullType("NHM.GreenCard") .. " 0/1" .. "\n"
            option_entry_lab.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "\n<RGB:0,1,0>" .. getItemNameFromFullType("NHM.GreenCard") .. " 1/1" .. "\n";
        end

        --выход из лабы
    elseif exit_lab then
        local option_exit_lab = context:addOption(getText("ContextMenu_Exit_Lab"), worldobjects, ExitLab, player);
        local toolTip = ISToolTip:new();
        toolTip:initialise();
        toolTip:setVisible(false);
        option_exit_lab.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_Exit_Lab"));
        toolTip:setTexture("Item_GreenCard");
        toolTip.description = getText("Tooltip_Exit_Lab") .. "\n";

        -- вход и выход из бункера 1
    elseif entry_bunker1 then
        local option_entry_bunker1 = context:addOption(getText("ContextMenu_Entry_Bunker"), worldobjects, EntryBunker1, player);
        local toolTip = ISToolTip:new();
        toolTip:initialise();
        toolTip:setVisible(false);
        option_entry_bunker1.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_Entry_Bunker"));
        toolTip:setTexture("Item_YellowCard");
        toolTip.description = getText("Tooltip_Entry_Bunker") .. "\n"
        if YellowCard < 1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getItemNameFromFullType("NHM.YellowCard") .. " 0/1" .. "\n"
            option_entry_bunker1.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "\n<RGB:0,1,0>" .. getItemNameFromFullType("NHM.YellowCard") .. " 1/1" .. "\n";
        end

    elseif exit_bunker1 then
        local option_exit_bunker1 = context:addOption(getText("ContextMenu_Exit_Bunker"), worldobjects, ExitBunker1, player);
        local toolTip = ISToolTip:new();
        toolTip:initialise();
        toolTip:setVisible(false);
        option_exit_bunker1.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_Exit_Bunker"));
        toolTip:setTexture("Item_YellowCard");
        toolTip.description = getText("Tooltip_Exit_Bunker") .. "\n"

        -- вход и выход из бункера 2
    elseif entry_bunker2 then
        local option_entry_bunker2 = context:addOption(getText("ContextMenu_Entry_Bunker"), worldobjects, EntryBunker2, player);
        local toolTip = ISToolTip:new();
        toolTip:initialise();
        toolTip:setVisible(false);
        option_entry_bunker2.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_Entry_Bunker"));
        toolTip:setTexture("Item_YellowCard");
        toolTip.description = getText("Tooltip_Entry_Bunker") .. "\n"
        if YellowCard < 1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getItemNameFromFullType("NHM.YellowCard") .. " 0/1" .. "\n"
            option_entry_bunker2.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "\n<RGB:0,1,0>" .. getItemNameFromFullType("NHM.YellowCard") .. " 1/1" .. "\n";
        end

    elseif exit_bunker2 then
        local option_exit_bunker2 = context:addOption(getText("ContextMenu_Exit_Bunker"), worldobjects, ExitBunker2, player);
        local toolTip = ISToolTip:new();
        toolTip:initialise();
        toolTip:setVisible(false);
        option_exit_bunker2.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_Exit_Bunker"));
        toolTip:setTexture("Item_YellowCard");
        toolTip.description = getText("Tooltip_Exit_Bunker") .. "\n"

        -- вход и выход из бункера 3
    elseif entry_bunker3 then
        local option_entry_bunker3 = context:addOption(getText("ContextMenu_Entry_Bunker"), worldobjects, EntryBunker3, player);
        local toolTip = ISToolTip:new();
        toolTip:initialise();
        toolTip:setVisible(false);
        option_entry_bunker3.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_Entry_Bunker"));
        toolTip:setTexture("Item_YellowCard");
        toolTip.description = getText("Tooltip_Entry_Bunker") .. "\n"
        if YellowCard < 1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getItemNameFromFullType("NHM.YellowCard") .. " 0/1" .. "\n"
            option_entry_bunker3.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "\n<RGB:0,1,0>" .. getItemNameFromFullType("NHM.YellowCard") .. " 1/1" .. "\n";
        end

    elseif exit_bunker3 then
        local option_exit_bunker3 = context:addOption(getText("ContextMenu_Exit_Bunker"), worldobjects, ExitBunker3, player);
        local toolTip = ISToolTip:new();
        toolTip:initialise();
        toolTip:setVisible(false);
        option_exit_bunker3.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_Exit_Bunker"));
        toolTip:setTexture("Item_YellowCard");
        toolTip.description = getText("Tooltip_Exit_Bunker") .. "\n"

    elseif luk then
        local option_luk = context:addOption(getText("ContextMenu_EntryLuk"), worldobjects, EntryLuk, player);
        local toolTip = ISToolTip:new();
        toolTip:initialise();
        toolTip:setVisible(false);
        option_luk.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_EntryLuk"));
        toolTip.description = getText("Tooltip_EntryLuk") .. "\n"

    elseif lestnica then
        local option_lestnica = context:addOption(getText("ContextMenu_EntryLestnica"), worldobjects, EntryLestnica, player);
        local toolTip = ISToolTip:new();
        toolTip:initialise();
        toolTip:setVisible(false);
        option_lestnica.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_EntryLestnica"));
        toolTip.description = getText("Tooltip_EntryLestnica") .. "\n"

        -- бензин в бункере
    elseif petrol_bunker then
        local option_get_petrol = context:addOption(getText("ContextMenu_Get_Petrol"), worldobjects, GetPetrol, player);
        local toolTip = ISToolTip:new();

        toolTip:initialise();
        toolTip:setVisible(false);
        option_get_petrol.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_Get_Petrol"));
        toolTip:setTexture("Item_Petrol");
        toolTip.description = getText("Tooltip_Get_Petrol") .. "\n";

        if MineEnd < 90 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "6" .. "\n";
            option_get_petrol.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "\n<RGB:0,1,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "6" .. "\n";
        end

        if not EPetrolCan then
            toolTip.description = toolTip.description .. "<RGB:1,0,0>" .. getItemNameFromFullType("Base.EmptyPetrolCan") .. " 0/1\n";
            option_get_petrol.notAvailable = true;
        elseif EPetrolCan == "ALREADYFILLED" then
            toolTip.description = toolTip.description .. "<RGB:1,0,0>" .. getItemNameFromFullType("Base.EmptyPetrolCan") .. " 1/1\n";
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_Full_GasCan") .. "\n";
            option_get_petrol.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "<RGB:0,1,0>" .. getItemNameFromFullType("Base.EmptyPetrolCan") .. " 1/1\n";
        end

        if End < 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_End");
            option_get_petrol.notAvailable = true;
        end
        if Fatique > 0.8 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_get_petrol.notAvailable = true;
        end

        --ДЕТАЛИ ОРУЖИЯ
    elseif weaponparts and getPlayer():DistToSquared(x, y) <= 6 then
        local option_get_weaponparts = context:addOption(getText("ContextMenu_Get_Weaponparts"), worldobjects, GetWeaponparts, player);
        local toolTip = ISToolTip:new();
        toolTip:initialise();
        toolTip:setVisible(false);
        option_get_weaponparts.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_Get_Weaponparts"));
        toolTip:setTexture("A1_CULT_0");
        toolTip.description = getText("Tooltip_Get_Weaponparts");
        if MineEnd < 45 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_MineEnd") .. " -45 (" .. MineEnd .. ")" .. "\n";
            option_get_weaponparts.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "\n<RGB:1,1,1>" .. getText("Tooltip_MineEnd") .. " -45 (" .. MineEnd .. ")" .. "\n";
        end
        if End < 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_End");
            option_get_weaponparts.notAvailable = true;
        end
        if Fatique > 0.8 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_get_weaponparts.notAvailable = true;
        end


        --АКТИВНОЕ ВЕЩЕСТВО
    elseif active_comp then
        local option_active_comp = context:addOption(getText("ContextMenu_Active_Comp"), worldobjects, ActiveComp, player);
        local toolTip = ISToolTip:new();
        toolTip:initialise();
        toolTip:setVisible(false);
        option_active_comp.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_Active_Comp"));
        toolTip:setTexture("Item_FlaskActiveComp");
        toolTip.description = getText("Tooltip_Active_Comp") .. "\n"
        local Flask = getPlayer():getInventory():getItemFromType("ChemicalFlask", true, true) or nil

        if MineEnd < 60 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "4" .. "\n";
            option_active_comp.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "\n<RGB:0,1,0>" .. getText("Tooltip_MineEnd") .. " " .. MineEndLevel .. "/" .. "4" .. "\n";
        end

        if not Flask then
            toolTip.description = toolTip.description .. "<RGB:1,0,0>" .. getItemNameFromFullType("NHM.ChemicalFlask") .. " 0/1" .. "\n"
            option_active_comp.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "<RGB:0,1,0>" .. getItemNameFromFullType("NHM.ChemicalFlask") .. " 1/1" .. "\n";
        end

        if End < 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_End") .. "\n";
            option_active_comp.notAvailable = true;
        end
        if Fatique > 0.8 and End < 0.1 then
            toolTip.description = toolTip.description .. "<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_active_comp.notAvailable = true;
        elseif Fatique > 0.8 and End >= 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_active_comp.notAvailable = true;
        end

        --ТРЕНАЖЕР
    elseif trainer and trainer:getSquare():haveElectricity() and getPlayer():DistToSquared(x, y) <= 4 then

        local option_train = context:addOption(getText("ContextMenu_Train"), worldobjects, nil)
        local subMenu = ISContextMenu:getNew(context);
        context:addSubMenu(option_train, subMenu);

        local option_train_run = subMenu:addOption(getText("ContextMenu_TrainRun"), worldobjects, TrainRun, player)
        local toolTip = ISToolTip:new();
        toolTip:initialise();
        toolTip:setVisible(false);
        option_train_run.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_TrainRun"));
        toolTip:setTexture("WorkbenchAgility_1_0");
        toolTip.description = getText("Tooltip_TrainRun");
        if MineEnd < 15 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_MineEnd") .. " -15 (" .. MineEnd .. ")" .. "\n";
            option_train_run.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "\n<RGB:1,1,1>" .. getText("Tooltip_MineEnd") .. " -15 (" .. MineEnd .. ")" .. "\n";
        end
        if End < 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_End");
            option_train_run.notAvailable = true;
        end
        if Fatique > 0.8 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_train_run.notAvailable = true;
        end

        local option_train_lightfoot = subMenu:addOption(getText("ContextMenu_TrainLightfoot"), worldobjects, TrainLightfoot, player)
        local toolTip = ISToolTip:new();
        toolTip:initialise();
        toolTip:setVisible(false);
        option_train_lightfoot.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_TrainLightfoot"));
        toolTip:setTexture("WorkbenchAgility_1_0");
        toolTip.description = getText("Tooltip_TrainLightfoot");
        if MineEnd < 15 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_MineEnd") .. " -15 (" .. MineEnd .. ")" .. "\n";
            option_train_lightfoot.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "\n<RGB:1,1,1>" .. getText("Tooltip_MineEnd") .. " -15 (" .. MineEnd .. ")" .. "\n";
        end
        if End < 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_End");
            option_train_lightfoot.notAvailable = true;
        end
        if Fatique > 0.8 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_train_lightfoot.notAvailable = true;
        end

        local option_train_nimble = subMenu:addOption(getText("ContextMenu_TrainNimble"), worldobjects, TrainNimble, player)
        local toolTip = ISToolTip:new();
        toolTip:initialise();
        toolTip:setVisible(false);
        option_train_nimble.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_TrainNimble"));
        toolTip:setTexture("WorkbenchAgility_1_0");
        toolTip.description = getText("Tooltip_TrainNimble");
        if MineEnd < 15 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_MineEnd") .. " -15 (" .. MineEnd .. ")" .. "\n";
            option_train_nimble.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "\n<RGB:1,1,1>" .. getText("Tooltip_MineEnd") .. " -15 (" .. MineEnd .. ")" .. "\n";
        end
        if End < 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_End");
            option_train_nimble.notAvailable = true;
        end
        if Fatique > 0.8 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_train_nimble.notAvailable = true;
        end

        local option_train_sneak = subMenu:addOption(getText("ContextMenu_TrainSneak"), worldobjects, TrainSneak, player)
        local toolTip = ISToolTip:new();
        toolTip:initialise();
        toolTip:setVisible(false);
        option_train_sneak.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_TrainSneak"));
        toolTip:setTexture("WorkbenchAgility_1_0");
        toolTip.description = getText("Tooltip_TrainSneak");
        if MineEnd < 15 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_MineEnd") .. " -15 (" .. MineEnd .. ")" .. "\n";
            option_train_sneak.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "\n<RGB:1,1,1>" .. getText("Tooltip_MineEnd") .. " -15 (" .. MineEnd .. ")" .. "\n";
        end
        if End < 0.1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_End");
            option_train_sneak.notAvailable = true;
        end
        if Fatique > 0.8 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_Fatique");
            option_train_sneak.notAvailable = true;
        end

    elseif bankomat and bankomat:getSquare():haveElectricity() and getPlayer():DistToSquared(x, y) <= 3 then
        local option_rob = context:addOption(getText("ContextMenu_Rob_Card"), worldobjects, RobBank, player);
        local toolTip = ISToolTip:new();
        toolTip:initialise();
        toolTip:setVisible(false);
        option_rob.toolTip = toolTip;
        toolTip:setName(getText("ContextMenu_Rob_Card"));
        toolTip:setTexture("location_business_bank_01_65");
        toolTip.description = getText("Tooltip_Rob_Card");
        if MineEnd < 30 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_MineEnd") .. " -30 (" .. MineEnd .. ")" .. "\n";
            option_rob.notAvailable = true;
        else
            toolTip.description = toolTip.description .. "\n<RGB:1,1,1>" .. getText("Tooltip_MineEnd") .. " -30 (" .. MineEnd .. ")" .. "\n";
        end
        if CreditCard < 1 then
            toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_CreditCard");
            option_rob.notAvailable = true;
        end
    end
end

Gas_Station = function(worldobjects, player, item)
    local playerObj = getSpecificPlayer(player)
    local BlowTorch = getBlowTorch(playerObj:getInventory())
    local GasStation = nil

    for i, v in ipairs(worldobjects) do
        local spriteName = v:getSprite():getName()
        if spriteName == "NHGasL_0" or spriteName == "NHGasR_0" then
            GasStation = v;
        end
    end

    local adjacent = AdjacentFreeTileFinder.Find(GasStation:getSquare(), playerObj)
    if adjacent then
        ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), BlowTorch, true, false)
        ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, adjacent))
        ISTimedActionQueue.add(ISExtractGas:new(playerObj, GasStation, BlowTorch, BlowTorch:getDelta(), 500, 2));
    end
end

Much_Gas = function(worldobjects, player, item)
    local playerObj = getSpecificPlayer(player)
    local PropaneTank = getPropaneTank(playerObj:getInventory())
    local GasStation = nil

    for i, v in ipairs(worldobjects) do
        local spriteName = v:getSprite():getName()
        if spriteName == "NHGasL_0" or spriteName == "NHGasR_0" then
            GasStation = v;
        end
    end

    local adjacent = AdjacentFreeTileFinder.Find(GasStation:getSquare(), playerObj)
    if adjacent then
        ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), PropaneTank, true, false)
        ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, adjacent))
        ISTimedActionQueue.add(ISExtractGas:new(playerObj, GasStation, PropaneTank, PropaneTank:getDelta(), 2000, 8));
    end
end

Trash_search = function(worldobjects, player, item)
    local playerObj = getSpecificPlayer(player)
    local Junkyard = nil

    for i, v in ipairs(worldobjects) do
        local spriteName = v:getSprite():getName()
        if spriteName == "A1 ae_bunker_0"
                or spriteName == "A1 ae_bunker_1" or spriteName == "A1 ae_bunker_2" or spriteName == "A1 ae_bunker_3" or spriteName == "A1 ae_bunker_4"
                or spriteName == "A1 ae_bunker_5" or spriteName == "A1 ae_bunker_6" or spriteName == "A1 ae_bunker_7" or spriteName == "A1 ae_bunker_8"
                or spriteName == "A1 ae_bunker_9" or spriteName == "A1 ae_bunker_10" or spriteName == "A1 ae_bunker_11" or spriteName == "A1 ae_bunker_12"
                or spriteName == "A1 ae_bunker_13" or spriteName == "A1 ae_bunker_14" or spriteName == "A1 ae_bunker_15" or spriteName == "A1 ae_bunker_16"
                or spriteName == "A1 ae_bunker_17" or spriteName == "A1 ae_bunker_18" or spriteName == "A1 ae_bunker_19" or spriteName == "A1 ae_bunker_20"
                or spriteName == "A1 ae_bunker_21" or spriteName == "A1 ae_bunker_22" or spriteName == "A1 ae_bunker_23" or spriteName == "A1 ae_bunker_24"
                or spriteName == "A1 ae_bunker_25" or spriteName == "A1 ae_bunker_26" or spriteName == "A1 ae_bunker_27" or spriteName == "A1 ae_bunker_28"
                or spriteName == "A1 ae_bunker_29" or spriteName == "A1 ae_bunker_30" or spriteName == "A1 ae_bunker_31" or spriteName == "A1 ae_bunker_32"
                or spriteName == "A1 ae_bunker_33" or spriteName == "A1 ae_bunker_34" or spriteName == "A1 ae_bunker_35" or spriteName == "A1 ae_bunker_36"
                or spriteName == "A1 ae_bunker_37" or spriteName == "A1 ae_bunker_38" or spriteName == "A1 ae_bunker_39" or spriteName == "A1 ae_bunker_40"
                or spriteName == "A1 ae_bunker_41" or spriteName == "A1 ae_bunker_42" or spriteName == "A1 ae_bunker_43" or spriteName == "A1 ae_bunker_44"
                or spriteName == "A1 ae_bunker_45" or spriteName == "A1 ae_bunker_46" or spriteName == "A1 ae_bunker_47" or spriteName == "A1 ae_bunker_48"
                or spriteName == "A1 ae_bunker_49" or spriteName == "A1 ae_bunker_50" or spriteName == "A1 ae_bunker_51" or spriteName == "A1 ae_bunker_52"
                or spriteName == "A1 ae_bunker_57" or spriteName == "A1 ae_bunker_58" or spriteName == "A1 ae_bunker_59" or spriteName == "A1 ae_bunker_60"
                or spriteName == "A1 ae_bunker_61" or spriteName == "A1 ae_bunker_62" or spriteName == "A1 ae_bunker_63" or spriteName == "A1 ae_bunker_64"
                or spriteName == "A1 ae_bunker_65" or spriteName == "A1 ae_bunker_66" or spriteName == "A1 ae_bunker_67" or spriteName == "A1 ae_bunker_68"
                or spriteName == "A1 ae_bunker_69" or spriteName == "A1 ae_bunker_70" or spriteName == "A1 ae_bunker_71" or spriteName == "A1 ae_bunker_72"
                or spriteName == "A1 ae_bunker_73" or spriteName == "A1 ae_bunker_74" or spriteName == "A1 ae_bunker_75" or spriteName == "A1 ae_bunker_76"
                or spriteName == "A1 ae_bunker_77" or spriteName == "A1 ae_bunker_78" or spriteName == "A1 ae_bunker_79" or spriteName == "A1 ae_bunker_80"
                or spriteName == "A1 ae_bunker_81" or spriteName == "A1 ae_bunker_82" or spriteName == "A1 ae_bunker_83" or spriteName == "A1 ae_bunker_84"
                or spriteName == "A1 ae_bunker_85" or spriteName == "A1 ae_bunker_86" or spriteName == "A1 ae_bunker_87" or spriteName == "A1 ae_bunker_88"
                or spriteName == "A1 ae_bunker_89" or spriteName == "A1 ae_bunker_90" or spriteName == "A1 ae_bunker_91" or spriteName == "A1 ae_bunker_92"
                or spriteName == "A1 ae_bunker_93" or spriteName == "A1 ae_bunker_94" or spriteName == "A1 ae_bunker_95" or spriteName == "A1 ae_bunker_96"
        then
            Junkyard = v;
        end
    end

    local adjacent = AdjacentFreeTileFinder.Find(Junkyard:getSquare(), playerObj)

    if adjacent then
        ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, adjacent))
        ISTimedActionQueue.add(ISSearchTrash:new(playerObj, Junkyard, 900));
    end
end

Microchip_Search = function(worldobjects, player, item)
    local playerObj = getSpecificPlayer(player)
    local Box = nil

    for i, v in ipairs(worldobjects) do
        local spriteName = v:getSprite():getName()
        if spriteName == "A1_CULT_12"
        then
            Box = v;
        end
    end

    local adjacent = AdjacentFreeTileFinder.Find(Box:getSquare(), playerObj)

    if adjacent then
        ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, adjacent))
        ISTimedActionQueue.add(ISSearchChip:new(playerObj, Box, 900));
    end
end

Obvjesy_Search = function(worldobjects, player, item)
    local playerObj = getSpecificPlayer(player)
    local Box = nil

    for i, v in ipairs(worldobjects) do
        local spriteName = v:getSprite():getName()
        if spriteName == "A1_CULT_29"
        then
            Box = v;
        end
    end

    local adjacent = AdjacentFreeTileFinder.Find(Box:getSquare(), playerObj)

    if adjacent then
        ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, adjacent))
        ISTimedActionQueue.add(ISSearchObvjesy:new(playerObj, Box, 200));
    end
end

local function MineInit(Worldobjects, Player, MineSpriteName, MiningTime, EnduranceConsumption, MineEnduranceLevelConsumption)
    local playerObj = getSpecificPlayer(Player)
    local Mine = nil
    local MineEnduranceConsumption = -(MineEnduranceLevelConsumption * 15 * 4)

    for i, v in pairs(Worldobjects) do
        if type(MineSpriteName) ~= "table" then
            if v:getSprite():getName() == MineSpriteName then
                Mine = v
            end
        else
            if v:getSprite():getName() == MineSpriteName[1] or v:getSprite():getName() == MineSpriteName[2] then
                Mine = v
            end
        end
    end

    local adjacent = AdjacentFreeTileFinder.Find(Mine:getSquare(), playerObj)
    ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, adjacent))

    local PickAxe = getPickAxe(playerObj:getInventory())
    ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), PickAxe, true, true)

    ISTimedActionQueue.add(ISMineGeneral:new(playerObj, Mine, PickAxe, MiningTime, Mine:getSprite():getName(), MineEnduranceLevelConsumption, EnduranceConsumption));
    getPlayer():getStats():setEndurance(playerObj:getStats():getEndurance() - EnduranceConsumption);

end

MineCopper = function(worldobjects, player, item)
    MineInit(worldobjects, player, "NHCopper_0", 1000, 0.1, 2)
end

MineTin = function(worldobjects, player, item)
    MineInit(worldobjects, player, "NHTin_0", 1000, 0.1, 2)
end

MineIron = function(worldobjects, player, item)
    MineInit(worldobjects, player, "NHIron_0", 1500, 0.15, 3)
end

MineLead = function(worldobjects, player, item)
    MineInit(worldobjects, player, "NHLead_0", 1500, 0.15, 3)
end

MineNickel = function(worldobjects, player, item)
    MineInit(worldobjects, player, "NHNickel_0", 2000, 0.2, 4)
end

MineChromium = function(worldobjects, player, item)
    MineInit(worldobjects, player, "NHChromium_0", 2000, 0.2, 4)
end

MineSulfur = function(worldobjects, player, item)
    MineInit(worldobjects, player, "NHSulfur_0", 1000, 0.1, 2)
end

MineLimestone = function(worldobjects, player, item)
    MineInit(worldobjects, player, "NHLimestone_0", 1500, 0.15, 3)
end

MineCoal = function(worldobjects, player, item)
    MineInit(worldobjects, player, "NHCoal_0", 500, 0.1, 1)
end

MineStone = function(worldobjects, player, item)
    MineInit(worldobjects, player, { "NHStone_1_0", "NHStone_2_0" }, 1000, 0.1, 2)
end

MineSalt = function(worldobjects, player, item)
    MineInit(worldobjects, player, { "NHSalt_1_0", "NHSalt_2_0" }, 1500, 0.15, 3)
end

GetPetrol = function(worldobjects, player, item)
    local playerObj = getSpecificPlayer(player)
    local PetrolCan = getEmptyPetrolCan(playerObj:getInventory())
    if not PetrolCan then
        PetrolCan = getPetrolCan(playerObj:getInventory())
    end
    local PetrolStation = nil

    for i, v in ipairs(worldobjects) do
        local spriteName = v:getSprite():getName()
        if spriteName == "A1_CULT_0" then
            PetrolStation = v;
        end
    end

    local adjacent = AdjacentFreeTileFinder.Find(PetrolStation:getSquare(), playerObj)
    if adjacent then
        ISWorldObjectContextMenu.equip(playerObj, playerObj:getSecondaryHandItem(), PetrolCan, false, false)
        ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, adjacent))
        if PetrolCan:getType() == "EmptyPetrolCan" then
            ISTimedActionQueue.add(ISExtractPetrol:new(playerObj, PetrolCan, PetrolStation, 6, 2000, nil));
        else
            ISTimedActionQueue.add(ISExtractPetrol:new(playerObj, PetrolCan, PetrolStation, 6, 2000, PetrolCan:getDelta()));
        end
    end
end

GetWeaponparts = function(worldobjects, player, item)
    local playerObj = getSpecificPlayer(player)
    ISTimedActionQueue.add(ISExtractWeaponpart:new(playerObj, item, 1000));
    getPlayer():getStats():setEndurance(playerObj:getStats():getEndurance() - 0.5);
    playerObj:LoseLevel(Perks.MineEndurance);
    playerObj:LoseLevel(Perks.MineEndurance);
    playerObj:LoseLevel(Perks.MineEndurance);
    if playerObj:HasTrait("FastLearner") then
        playerObj:getXp():AddXP(Perks.MineEndurance, (-180 / 1.3));
    elseif playerObj:HasTrait("SlowLearner") then
        playerObj:getXp():AddXP(Perks.MineEndurance, (-180 / 0.7));
    else
        playerObj:getXp():AddXP(Perks.MineEndurance, -180);
    end
end

EntryLab = function(worldobjects, player, item)
    local playerObj = getSpecificPlayer(player)
    local Card = getPlayer():getInventory():getItemFromType("GreenCard", true, true)
    local CodeLock = nil

    for i, v in ipairs(worldobjects) do
        local spriteName = v:getSprite():getName()
        if spriteName == "A1 pinkot_0" then
            CodeLock = v;
        end
    end

    local adjacent = AdjacentFreeTileFinder.Find(CodeLock:getSquare(), playerObj)

    if adjacent then
        ISTimedActionQueue.add(ISPathFindAction:pathToLocationF(playerObj, CodeLock:getSquare():getX() + 0.5, CodeLock:getSquare():getY() + 0.5, CodeLock:getSquare():getZ()))
        ISWorldObjectContextMenu.equip(playerObj, playerObj:getSecondaryHandItem(), Card, false, false)
        ISTimedActionQueue.add(ISLabAction:new(playerObj, CodeLock, Card, 6059, 10906, 1, "N"));
    end
end

ExitLab = function(worldobjects, player, item)
    local playerObj = getSpecificPlayer(player)
    local CodeLock = nil

    for i, v in ipairs(worldobjects) do
        local spriteName = v:getSprite():getName()
        if spriteName == "A1 pinkot_1" then
            CodeLock = v;
        end
    end

    local adjacent = AdjacentFreeTileFinder.Find(CodeLock:getSquare(), playerObj)

    if adjacent then
        ISTimedActionQueue.add(ISPathFindAction:pathToLocationF(playerObj, CodeLock:getSquare():getX() + 0.5, CodeLock:getSquare():getY() + 0.5, CodeLock:getSquare():getZ()))
        ISTimedActionQueue.add(ISLabAction:new(playerObj, CodeLock, nil, 6058, 10909, 1, "W"));
    end
end

EntryBunker1 = function(worldobjects, player, item)
    local playerObj = getSpecificPlayer(player)
    local Card = getPlayer():getInventory():getItemFromType("YellowCard", true, true)
    local CodeLock = nil

    for i, v in ipairs(worldobjects) do
        local spriteName = v:getSprite():getName()
        if spriteName == "A1 pinkot_2" then
            CodeLock = v;
        end
    end

    local adjacent = AdjacentFreeTileFinder.Find(CodeLock:getSquare(), playerObj)

    if adjacent then
        ISTimedActionQueue.add(ISPathFindAction:pathToLocationF(playerObj, CodeLock:getSquare():getX() + 0.5, CodeLock:getSquare():getY() + 0.5, CodeLock:getSquare():getZ()))
        ISWorldObjectContextMenu.equip(playerObj, playerObj:getSecondaryHandItem(), Card, false, false)
        ISTimedActionQueue.add(ISLabAction:new(playerObj, CodeLock, Card, 9148, 4898, 3, "W"));
    end
end

ExitBunker1 = function(worldobjects, player, item)
    local playerObj = getSpecificPlayer(player)
    local CodeLock = nil

    for i, v in ipairs(worldobjects) do
        local spriteName = v:getSprite():getName()
        if spriteName == "A1 pinkot_3" then
            CodeLock = v;
        end
    end

    local adjacent = AdjacentFreeTileFinder.Find(CodeLock:getSquare(), playerObj)

    if adjacent then
        ISTimedActionQueue.add(ISPathFindAction:pathToLocationF(playerObj, CodeLock:getSquare():getX() + 0.5, CodeLock:getSquare():getY() + 0.5, CodeLock:getSquare():getZ()))
        ISTimedActionQueue.add(ISLabAction:new(playerObj, CodeLock, nil, 6043, 10875, 0, "N"));
    end
end

EntryBunker2 = function(worldobjects, player, item)
    local playerObj = getSpecificPlayer(player)
    local Card = getPlayer():getInventory():getItemFromType("YellowCard", true, true)
    local CodeLock = nil

    for i, v in ipairs(worldobjects) do
        local spriteName = v:getSprite():getName()
        if spriteName == "A1 pinkot_8" then
            CodeLock = v;
        end
    end

    local adjacent = AdjacentFreeTileFinder.Find(CodeLock:getSquare(), playerObj)

    if adjacent then
        ISTimedActionQueue.add(ISPathFindAction:pathToLocationF(playerObj, CodeLock:getSquare():getX() + 0.5, CodeLock:getSquare():getY() + 0.5, CodeLock:getSquare():getZ()))
        ISWorldObjectContextMenu.equip(playerObj, playerObj:getSecondaryHandItem(), Card, false, false)
        ISTimedActionQueue.add(ISLabAction:new(playerObj, CodeLock, Card, 9166, 4929, 2, "W"));
    end
end

ExitBunker2 = function(worldobjects, player, item)
    local playerObj = getSpecificPlayer(player)
    local CodeLock = nil

    for i, v in ipairs(worldobjects) do
        local spriteName = v:getSprite():getName()
        if spriteName == "A1 pinkot_9" then
            CodeLock = v;
        end
    end

    local adjacent = AdjacentFreeTileFinder.Find(CodeLock:getSquare(), playerObj)

    if adjacent then
        ISTimedActionQueue.add(ISPathFindAction:pathToLocationF(playerObj, CodeLock:getSquare():getX() + 0.5, CodeLock:getSquare():getY() + 0.5, CodeLock:getSquare():getZ()))
        ISTimedActionQueue.add(ISLabAction:new(playerObj, CodeLock, nil, 6087, 10951, 0, "N"));
    end
end

EntryBunker3 = function(worldobjects, player, item)
    local playerObj = getSpecificPlayer(player)
    local Card = getPlayer():getInventory():getItemFromType("YellowCard", true, true)
    local CodeLock = nil

    for i, v in ipairs(worldobjects) do
        local spriteName = v:getSprite():getName()
        if spriteName == "A1 pinkot_10" then
            CodeLock = v;
        end
    end

    local adjacent = AdjacentFreeTileFinder.Find(CodeLock:getSquare(), playerObj)

    if adjacent then
        ISTimedActionQueue.add(ISPathFindAction:pathToLocationF(playerObj, CodeLock:getSquare():getX() + 0.5, CodeLock:getSquare():getY() + 0.5, CodeLock:getSquare():getZ()))
        ISWorldObjectContextMenu.equip(playerObj, playerObj:getSecondaryHandItem(), Card, false, false)
        ISTimedActionQueue.add(ISLabAction:new(playerObj, CodeLock, Card, 9226, 4897, 2, "N"));
    end
end

ExitBunker3 = function(worldobjects, player, item)
    local playerObj = getSpecificPlayer(player)
    local CodeLock = nil

    for i, v in ipairs(worldobjects) do
        local spriteName = v:getSprite():getName()
        if spriteName == "A1 pinkot_11" then
            CodeLock = v;
        end
    end

    local adjacent = AdjacentFreeTileFinder.Find(CodeLock:getSquare(), playerObj)

    if adjacent then
        ISTimedActionQueue.add(ISPathFindAction:pathToLocationF(playerObj, CodeLock:getSquare():getX() + 0.5, CodeLock:getSquare():getY() + 0.5, CodeLock:getSquare():getZ()))
        ISTimedActionQueue.add(ISLabAction:new(playerObj, CodeLock, nil, 6145, 10866, 0, "N"));
    end
end

EntryLuk = function(worldobjects, player, item)
    local playerObj = getSpecificPlayer(player)
    local Luk = nil

    for i, v in ipairs(worldobjects) do
        local spriteName = v:getSprite():getName()
        if spriteName == "A1 Tubing_11" then
            Luk = v;
        end
    end

    local x = Luk:getSquare():getX()

    local adjacent = AdjacentFreeTileFinder.Find(Luk:getSquare(), playerObj)

    if adjacent then
        ISTimedActionQueue.add(ISPathFindAction:pathToLocationF(playerObj, Luk:getSquare():getX() + 0.5, Luk:getSquare():getY() + 0.5, Luk:getSquare():getZ()))
        if x == 12451 then
            ISTimedActionQueue.add(ISLuk:new(playerObj, Luk, 9192, 2984, 0));
        end
        if x == 12540 then
            ISTimedActionQueue.add(ISLuk:new(playerObj, Luk, 9243, 2022, 0));
        end
        if x == 12557 then
            ISTimedActionQueue.add(ISLuk:new(playerObj, Luk, 9221, 1728, 0));
        end
        if x == 12752 then
            ISTimedActionQueue.add(ISLuk:new(playerObj, Luk, 9377, 2547, 0));
        end
        if x == 12951 then
            ISTimedActionQueue.add(ISLuk:new(playerObj, Luk, 9421, 1422, 0));
        end
        if x == 13563 then
            ISTimedActionQueue.add(ISLuk:new(playerObj, Luk, 9548, 1365, 0));
        end
        if x == 13358 then
            ISTimedActionQueue.add(ISLuk:new(playerObj, Luk, 9613, 2423, 0));
        end
        if x == 13237 then
            ISTimedActionQueue.add(ISLuk:new(playerObj, Luk, 9627, 2078, 0));
        end
        if x == 13647 then
            ISTimedActionQueue.add(ISLuk:new(playerObj, Luk, 9784, 2121, 0));
        end
        if x == 13922 then
            ISTimedActionQueue.add(ISLuk:new(playerObj, Luk, 10040, 2971, 0));
        end
        if x == 13036 then
            ISTimedActionQueue.add(ISLuk:new(playerObj, Luk, 11022, 5398, 0));
        end
        if x == 11534 then
            ISTimedActionQueue.add(ISLuk:new(playerObj, Luk, 10769, 5388, 0));
        end
        if x == 8650 then
            ISTimedActionQueue.add(ISLuk:new(playerObj, Luk, 10480, 5408, 0));
        end
    end
end

EntryLestnica = function(worldobjects, player, item)
    local playerObj = getSpecificPlayer(player)
    local Lestnica = nil

    for i, v in ipairs(worldobjects) do
        local spriteName = v:getSprite():getName()
        if spriteName == "industry_railroad_05_36"
                or spriteName == "location_sewer_01_32"
                or spriteName == "industry_railroad_05_21"
                or spriteName == "fixtures_stairs_01_3"
                or spriteName == "fixtures_stairs_01_4"
                or spriteName == "fixtures_stairs_01_5"
                or spriteName == "industry_railroad_05_20" then
            Lestnica = v;
        end
    end

    local x = Lestnica:getSquare():getX()
    print(x)

    local adjacent = AdjacentFreeTileFinder.Find(Lestnica:getSquare(), playerObj)

    if adjacent then
        if x ~= 9626 and x ~= 9625 and x ~= 9624 then
            ISTimedActionQueue.add(ISPathFindAction:pathToLocationF(playerObj, Lestnica:getSquare():getX() + 0.5, Lestnica:getSquare():getY() + 0.5, Lestnica:getSquare():getZ()))
            if x == 9192 then
                ISTimedActionQueue.add(ISLuk:new(playerObj, Lestnica, 12451, 3557, 0));
            end
            if x == 9243 then
                ISTimedActionQueue.add(ISLuk:new(playerObj, Lestnica, 12540, 2230, 0));
            end
            if x == 9221 then
                ISTimedActionQueue.add(ISLuk:new(playerObj, Lestnica, 12557, 1745, 0));
            end
            if x == 9377 then
                ISTimedActionQueue.add(ISLuk:new(playerObj, Lestnica, 12752, 2972, 0));
            end
            if x == 9421 then
                ISTimedActionQueue.add(ISLuk:new(playerObj, Lestnica, 12951, 1417, 0));
            end
            if x == 9548 then
                ISTimedActionQueue.add(ISLuk:new(playerObj, Lestnica, 13563, 1463, 0));
            end
            if x == 9613 then
                ISTimedActionQueue.add(ISLuk:new(playerObj, Lestnica, 13358, 3097, 0));
            end
            if x == 9784 then
                ISTimedActionQueue.add(ISLuk:new(playerObj, Lestnica, 13647, 2538, 0));
            end
            if x == 10040 then
                ISTimedActionQueue.add(ISLuk:new(playerObj, Lestnica, 13922, 3347, 0));
            end
            if x == 11022 then
                ISTimedActionQueue.add(ISLuk:new(playerObj, Luk, 13036, 7016, 0));
            end
            if x == 10769 then
                ISTimedActionQueue.add(ISLuk:new(playerObj, Luk, 11534, 7640, 0));
            end
            if x == 10480 then
                ISTimedActionQueue.add(ISLuk:new(playerObj, Luk, 8650, 9721, 0));
            end
        elseif x == 9626 or x == 9625 or x == 9624 then
            ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, adjacent))
            ISTimedActionQueue.add(ISLuk:new(playerObj, Lestnica, 13237, 2151, 0));
        end
    end
end

ActiveComp = function(worldobjects, player, item)
    local playerObj = getSpecificPlayer(player)
    local Flask = getPlayer():getInventory():getItemFromType("ChemicalFlask", true, true)
    local Tile = nil

    for i, v in ipairs(worldobjects) do
        local spriteName = v:getSprite():getName()
        if spriteName == "A1 decor_med_3"
        then
            Tile = v;
        end
    end

    local adjacent = AdjacentFreeTileFinder.Find(Tile:getSquare(), playerObj)

    if adjacent then
        ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, adjacent))
        ISWorldObjectContextMenu.equip(playerObj, playerObj:getSecondaryHandItem(), Flask, false, false)
        ISTimedActionQueue.add(ISActiveComp:new(playerObj, Tile, 500, Flask));
    end
end

TrainRun = function(worldobjects, player, item)
    local playerObj = getSpecificPlayer(player)
    ISTimedActionQueue.add(ISTrainRun:new(playerObj, item, 2000));
    --getPlayer():getBodyDamage():setUnhappynessLevel(player:getBodyDamage():getUnhappynessLevel() + 0.5);
    --getPlayer():getStats():setHunger(player:getStats():getHunger() + 0.005);
    getPlayer():getStats():setThirst(playerObj:getStats():getThirst() + 0.05);
    getPlayer():getStats():setFatigue(playerObj:getStats():getFatigue() + 0.05);
    getPlayer():getStats():setEndurance(playerObj:getStats():getEndurance() - 0.1);
    --getSoundManager():PlayWorldSound("TrashSearch", false, getPlayer():getCurrentSquare(), 0.2, 60, 0.2, false);
    playerObj:LoseLevel(Perks.MineEndurance);
    if playerObj:HasTrait("FastLearner") then
        playerObj:getXp():AddXP(Perks.MineEndurance, (-60 / 1.3));
    elseif playerObj:HasTrait("SlowLearner") then
        playerObj:getXp():AddXP(Perks.MineEndurance, (-60 / 0.7));
    else
        playerObj:getXp():AddXP(Perks.MineEndurance, -60);
    end
end

TrainLightfoot = function(worldobjects, player, item)
    local playerObj = getSpecificPlayer(player)
    ISTimedActionQueue.add(ISTrainLightfoot:new(playerObj, item, 2000));
    --getPlayer():getBodyDamage():setUnhappynessLevel(player:getBodyDamage():getUnhappynessLevel() + 0.5);
    --getPlayer():getStats():setHunger(player:getStats():getHunger() + 0.005);
    getPlayer():getStats():setThirst(playerObj:getStats():getThirst() + 0.05);
    getPlayer():getStats():setFatigue(playerObj:getStats():getFatigue() + 0.05);
    getPlayer():getStats():setEndurance(playerObj:getStats():getEndurance() - 0.1);
    --getSoundManager():PlayWorldSound("TrashSearch", false, getPlayer():getCurrentSquare(), 0.2, 60, 0.2, false);
    playerObj:LoseLevel(Perks.MineEndurance);
    if playerObj:HasTrait("FastLearner") then
        playerObj:getXp():AddXP(Perks.MineEndurance, (-60 / 1.3));
    elseif playerObj:HasTrait("SlowLearner") then
        playerObj:getXp():AddXP(Perks.MineEndurance, (-60 / 0.7));
    else
        playerObj:getXp():AddXP(Perks.MineEndurance, -60);
    end
end

TrainNimble = function(worldobjects, player, item)
    local playerObj = getSpecificPlayer(player)
    ISTimedActionQueue.add(ISTrainNimble:new(playerObj, item, 2000));
    --getPlayer():getBodyDamage():setUnhappynessLevel(player:getBodyDamage():getUnhappynessLevel() + 0.5);
    --getPlayer():getStats():setHunger(player:getStats():getHunger() + 0.005);
    getPlayer():getStats():setThirst(playerObj:getStats():getThirst() + 0.05);
    getPlayer():getStats():setFatigue(playerObj:getStats():getFatigue() + 0.05);
    getPlayer():getStats():setEndurance(playerObj:getStats():getEndurance() - 0.1);
    --getSoundManager():PlayWorldSound("TrashSearch", false, getPlayer():getCurrentSquare(), 0.2, 60, 0.2, false);
    playerObj:LoseLevel(Perks.MineEndurance);
    if playerObj:HasTrait("FastLearner") then
        playerObj:getXp():AddXP(Perks.MineEndurance, (-60 / 1.3));
    elseif playerObj:HasTrait("SlowLearner") then
        playerObj:getXp():AddXP(Perks.MineEndurance, (-60 / 0.7));
    else
        playerObj:getXp():AddXP(Perks.MineEndurance, -60);
    end
end

TrainSneak = function(worldobjects, player, item)
    local playerObj = getSpecificPlayer(player)
    ISTimedActionQueue.add(ISTrainSneak:new(playerObj, item, 2000));
    --getPlayer():getBodyDamage():setUnhappynessLevel(player:getBodyDamage():getUnhappynessLevel() + 0.5);
    --getPlayer():getStats():setHunger(player:getStats():getHunger() + 0.005);
    getPlayer():getStats():setThirst(playerObj:getStats():getThirst() + 0.05);
    getPlayer():getStats():setFatigue(playerObj:getStats():getFatigue() + 0.05);
    getPlayer():getStats():setEndurance(playerObj:getStats():getEndurance() - 0.1);
    --getSoundManager():PlayWorldSound("TrashSearch", false, getPlayer():getCurrentSquare(), 0.2, 60, 0.2, false);
    playerObj:LoseLevel(Perks.MineEndurance);
    if playerObj:HasTrait("FastLearner") then
        playerObj:getXp():AddXP(Perks.MineEndurance, (-60 / 1.3));
    elseif playerObj:HasTrait("SlowLearner") then
        playerObj:getXp():AddXP(Perks.MineEndurance, (-60 / 0.7));
    else
        playerObj:getXp():AddXP(Perks.MineEndurance, -60);
    end
end

RobBank = function(worldobjects, player, item)
    local playerObj = getSpecificPlayer(player)
    ISTimedActionQueue.add(ISRobBank:new(playerObj, item, 600));
    --getPlayer():getBodyDamage():setUnhappynessLevel(player:getBodyDamage():getUnhappynessLevel() + 0.5);
    --getPlayer():getStats():setHunger(player:getStats():getHunger() + 0.005);
    --getSoundManager():PlayWorldSound("TrashSearch", false, getPlayer():getCurrentSquare(), 0.2, 60, 0.2, false);
    playerObj:LoseLevel(Perks.MineEndurance);
    playerObj:LoseLevel(Perks.MineEndurance);
    if playerObj:HasTrait("FastLearner") then
        playerObj:getXp():AddXP(Perks.MineEndurance, (-120 / 1.3));
    elseif playerObj:HasTrait("SlowLearner") then
        playerObj:getXp():AddXP(Perks.MineEndurance, (-120 / 0.7));
    else
        playerObj:getXp():AddXP(Perks.MineEndurance, -120);
    end
end

function miner_power()
    player = getPlayer();
    if player:getPerkLevel(Perks.MineEndurance) < 10 then
        if player:HasTrait("inert") then
            if player:HasTrait("FastLearner") then
                player:getXp():AddXP(Perks.MineEndurance, (20 / 1.3))
            elseif player:HasTrait("SlowLearner") then
                player:getXp():AddXP(Perks.MineEndurance, (20 / 0.7))
            else
                player:getXp():AddXP(Perks.MineEndurance, 20);
            end
        elseif player:HasTrait("energetic") then
            if player:HasTrait("FastLearner") then
                player:getXp():AddXP(Perks.MineEndurance, (40 / 1.3))
            elseif player:HasTrait("SlowLearner") then
                player:getXp():AddXP(Perks.MineEndurance, (40 / 0.7))
            else
                player:getXp():AddXP(Perks.MineEndurance, 40);
            end
        else
            if player:HasTrait("FastLearner") then
                player:getXp():AddXP(Perks.MineEndurance, (30 / 1.3))
            elseif player:HasTrait("SlowLearner") then
                player:getXp():AddXP(Perks.MineEndurance, (30 / 0.7))
            else
                player:getXp():AddXP(Perks.MineEndurance, 30);
            end
        end
    end
end

Events.OnFillWorldObjectContextMenu.Add(Work_Stations);
Events.EveryHours.Add(miner_power);