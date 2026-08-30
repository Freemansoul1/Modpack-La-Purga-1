local IFP = IndustrialFuelPumps

local function predicatePetrol(item)
    return (item:hasTag("Petrol") or item:getType() == "PetrolCan") and (item:getRemainingUses() > 0)
end

local function predicateCanHaveFuelPetrol(item)
    return item:hasTag("EmptyPetrol") or item:getType() == "EmptyPetrolCan" or (item:hasTag("Petrol") or item:getType() == "PetrolCan") and (item:getRemainingUses() < 1)
end

function IFP.onFillTank(character,tankObj,item,all)
    item = ISWorldObjectContextMenu.equip(character, character:getPrimaryHandItem(), all and predicatePetrol or item, true, false)
    if item ~= nil then ISTimedActionQueue.add(IFP.FillTank:new(character, tankObj, item, all)) end
end

function IFP.onAddFuelOption(character,pump,item,all)
    if luautils.walkAdj(character, pump:getSquare(), true) then
        IFP.onFillTank(character,pump,item,all)
    end
end

function IFP.replaceTooltip()
    return ISToolTip:new()
end

function IFP.OnPreFillWorldObjectContextMenu(player, context, worldobjects, test)
    if test and ISWorldObjectContextMenu.Test then return true end

    local tileObj = haveFuel
    if not tileObj then
        for _,object in ipairs(worldobjects) do
            if IFP.gridTiles[object:getTextureName()] ~= nil then
                tileObj = object
                break
            end
        end
    elseif not IFP.gridTiles[tileObj:getTextureName()] then
        tileObj = nil
    end
    if tileObj ~= nil then
        local character = getSpecificPlayer(player)

        local tileList = ArrayList.new()
        tileObj:getSpriteGridObjects(tileList)

        if tileList:size() < tileObj:getSprite():getSpriteGrid():getSpriteCount() then return character:Say("Object is incomplete") end --fixme broken and need to empty

        tileObj = tileList:get(0)
        if character:getX() + character:getY() > tileObj:getX() + tileObj:getY() + 2.9 then
            tileObj = tileList:get(7)
        end

        local fuelFull = tonumber(tileObj:getPipedFuelAmount()) / tonumber(tileObj:getSprite():getProperties():Val("fuelAmount")) * 100
        local fuelItems = character:getInventory():getAllEvalRecurse(predicatePetrol)
        local count = fuelItems:size()

        local option = context:addOption(string.format("%s %d%%",getText("ContextMenu_GeneratorAddFuel"),fuelFull))
        if count == 0 or fuelFull >= 100 then
            option.notAvailable = true
        else
            if test then return ISWorldObjectContextMenu.setTest() end
            local subMenu = context:getNew(context)
            context:addSubMenu(option, subMenu)
            if count > 1 then
                if test then return ISWorldObjectContextMenu.setTest() end
                subMenu:addOption(getText("ContextMenu_AllWithCount",count), character, IFP.onAddFuelOption, tileObj, nil, true)
            end
            for i = 0, count - 1 do
                if test then return ISWorldObjectContextMenu.setTest() end
                local item = fuelItems:get(i)
                subMenu:addOption(string.format("%s %d%%",item:getName(),item:getUsedDelta()*100), character, IFP.onAddFuelOption, tileObj, item, false)
            end
        end

        --if haveFuel == tileObj or tileObj:getPipedFuelAmount() > 0 and character:getInventory():containsEvalRecurse(predicateCanHaveFuelPetrol) then --todo sync data
        if tileObj:getPipedFuelAmount() > 0 and character:getInventory():containsEvalRecurse(predicateCanHaveFuelPetrol) then
            haveFuel = tileObj

            if not (tileObj:getSquare():haveElectricity() or getWorld():isHydroPowerOn()) then
                if test == true then return ISWorldObjectContextMenu.setTest() end

                local prev = ISWorldObjectContextMenu.addToolTip
                ISWorldObjectContextMenu.addToolTip = IFP.replaceTooltip

                pcall(ISWorldObjectContextMenu.doFillFuelMenu, tileObj, player, context)

                ISWorldObjectContextMenu.addToolTip = prev

            end
        else
            haveFuel = nil
        end
    end
end

Events.OnPreFillWorldObjectContextMenu.Add(IFP.OnPreFillWorldObjectContextMenu)
