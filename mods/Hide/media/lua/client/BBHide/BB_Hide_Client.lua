-- **************************************************
-- ██████  ██████   █████  ██    ██ ███████ ███    ██ 
-- ██   ██ ██   ██ ██   ██ ██    ██ ██      ████   ██ 
-- ██████  ██████  ███████ ██    ██ █████   ██ ██  ██ 
-- ██   ██ ██   ██ ██   ██  ██  ██  ██      ██  ██ ██ 
-- ██████  ██   ██ ██   ██   ████   ███████ ██   ████
-- **************************************************
-- ** Seek Excellence! Employ ME, not my Copycats. **
-- **************************************************

local tileListNormal = {
    "appliances_refrigeration_01_38","appliances_refrigeration_01_39","carpentry_02_52","crafted_01_24","crafted_01_28","furniture_storage_01_0","furniture_storage_01_1",
    "furniture_storage_01_2","furniture_storage_01_3","furniture_storage_01_4","furniture_storage_01_5","furniture_storage_01_6","furniture_storage_01_7","furniture_storage_01_16",
    "furniture_storage_01_17","furniture_storage_01_18","furniture_storage_01_19","furniture_storage_01_20","furniture_storage_01_21","furniture_storage_01_22","furniture_storage_01_23",
    "furniture_storage_01_24","furniture_storage_01_25","furniture_storage_01_26","furniture_storage_01_27","furniture_storage_01_28","furniture_storage_01_29","furniture_storage_01_30",
    "furniture_storage_01_31","furniture_storage_01_36","furniture_storage_01_37","furniture_storage_01_38","furniture_storage_01_39","furniture_tables_high_01_30","furniture_storage_01_56",
    "furniture_storage_01_57","furniture_storage_01_58","furniture_storage_01_59","furniture_storage_01_60","furniture_storage_01_61","furniture_storage_01_62","furniture_storage_01_63",
    "furniture_storage_02_16","furniture_storage_02_17","furniture_storage_02_18","furniture_storage_02_19","furniture_storage_02_20","furniture_storage_02_21","furniture_storage_02_22",
    "furniture_storage_02_23","furniture_storage_02_24","furniture_storage_02_25","furniture_storage_02_26","furniture_storage_02_27","furniture_storage_02_40","furniture_storage_02_41",
    "furniture_storage_02_42","furniture_storage_02_43","furniture_storage_02_44","furniture_storage_02_45","furniture_storage_02_46","furniture_storage_02_47","furniture_tables_high_01_24",
    "furniture_tables_high_01_25","furniture_tables_high_01_26","furniture_tables_high_01_27","furniture_tables_high_01_28","furniture_tables_high_01_29","furniture_tables_high_01_30","furniture_tables_high_01_31",
    "location_business_distillery_01_8","location_business_office_generic_01_0","location_business_office_generic_01_1","location_business_office_generic_01_2","location_business_office_generic_01_3","location_business_office_generic_01_4","location_business_office_generic_01_5",
    "location_business_office_generic_01_6","location_business_office_generic_01_8","location_business_office_generic_01_9","location_business_office_generic_01_10","location_business_office_generic_01_11","location_business_office_generic_01_12","location_business_office_generic_01_13",
    "location_business_office_generic_01_14","location_business_office_generic_01_40","location_business_office_generic_01_41","location_business_office_generic_01_42","location_business_office_generic_01_43","location_business_office_generic_01_44","location_business_office_generic_01_45",
    "location_business_office_generic_01_46","location_business_office_generic_01_47","location_community_church_small_01_48","location_community_church_small_01_49","location_community_church_small_01_50","location_community_church_small_01_51","location_community_church_small_01_52",
    "location_community_church_small_01_53","location_community_church_small_01_56","location_community_church_small_01_57","location_community_church_small_01_58","location_community_church_small_01_59","location_community_church_small_01_60","location_community_church_small_01_61",
    "recreational_01_2","recreational_01_3","recreational_01_6","recreational_01_7","furniture_storage_02_0","furniture_storage_02_1","furniture_storage_02_2",
    "furniture_storage_02_3","furniture_storage_02_4","furniture_storage_02_5","furniture_storage_02_6","furniture_storage_02_7","furniture_storage_02_12","furniture_storage_02_13",
    "furniture_storage_02_14","furniture_storage_02_15","furniture_storage_02_16","furniture_storage_02_17","furniture_storage_02_18","furniture_storage_02_19","furniture_storage_02_20",
    "furniture_storage_02_21","furniture_storage_02_22","furniture_storage_02_23","furniture_storage_02_24","furniture_storage_02_25","furniture_storage_02_26","furniture_storage_02_27",
    "furniture_storage_02_40","furniture_storage_02_41","furniture_storage_02_42","furniture_storage_02_43","furniture_storage_02_44","furniture_storage_02_45","furniture_storage_02_46","furniture_storage_02_47",
}

local tileListSickness = {
    "trashcontainers_01_0","trashcontainers_01_1","trashcontainers_01_2",
    "trashcontainers_01_3","trashcontainers_01_8","trashcontainers_01_9","trashcontainers_01_10","trashcontainers_01_11","trashcontainers_01_12","trashcontainers_01_13",
    "trashcontainers_01_14","trashcontainers_01_15","trashcontainers_01_16","trashcontainers_01_17",
}

local tileListCold = {
    "appliances_refrigeration_01_20","appliances_refrigeration_01_21",
    "appliances_refrigeration_01_38","appliances_refrigeration_01_39",
}

local distanceBetween = function(firstObj, secondObj)
        local distanceVector = {0, 0, 0}

        distanceVector.X = firstObj:getX() - secondObj:getX()
        distanceVector.Y = firstObj:getY() - secondObj:getY()
        distanceVector.Z = firstObj:getZ() - secondObj:getZ()

        local distance = distanceVector.X + distanceVector.Y

        if distanceVector.Z ~= 0 then
            distance = 9999
        end

        return distance
end

local onGameStart = function()
    local playerObj = getPlayer()

    if playerObj:getModData().hiding then
        BravensUtilsO5.DelayFunction(function()
            BB_Hide.RevealPlayer(playerObj, playerObj:getModData().lastCoordsZ)
        end, 150)
    end
end

local hide = function(playerObj, targetObj)
    if distanceBetween(playerObj, targetObj) > 2.5 then
        local targetSq = AdjacentFreeTileFinder.FindClosest(targetObj:getSquare(), playerObj) or targetObj:getSquare()
        luautils.walkAdjWindowOrDoor(playerObj, targetSq, targetObj)
    end

    local primaryHandItem = playerObj:getPrimaryHandItem()
    if primaryHandItem then
        ISTimedActionQueue.add(ISUnequipAction:new(playerObj, primaryHandItem, 20))
    end

    ISTimedActionQueue.add(BB_Hide_ISTimedAction:Hide(playerObj, SandboxVars.Hide.HidingSpeed))
end

local function onFillWorldObjectContextMenu(player, context, worldobjects, test)
    if getCore():getGameMode() == 'LastStand' then return; end
    if test then return; end

    local playerObj = getSpecificPlayer(player)
    if playerObj:getVehicle() then return; end
    if playerObj:getModData().hiding == true then return end
    if playerObj:getZ() == 6 then return end
    local objs = clickedSquare:getObjects()
    local targetObj = nil

    for i = 0, objs:size() - 1 do
        local obj = objs:get(i)
        local isHidingSpot = false

        if instanceof(obj, "IsoObject") then
            local sprite =  obj:getSprite()
            if sprite then
                if sprite:getProperties():Is(IsoFlagType.bed) then
                    local bedType = sprite:getProperties():Val("BedType") or "averageBed"
                    if bedType == "goodBed" then
                        isHidingSpot = true
                    end
                else
                    local spriteName = sprite:getName()
                    if spriteName then
                        for x = 0, #tileListNormal - 1 do
                            if spriteName == tileListNormal[x] then
                                isHidingSpot = true
                                break
                            end
                        end

                        if isHidingSpot == false then
                            for l = 0, #tileListSickness - 1 do
                                if spriteName == tileListSickness[l] then
                                    playerObj:getModData().bbStatusEffect = "Sickness"
                                    isHidingSpot = true
                                    break
                                end
                            end
                        end

                        if isHidingSpot == false then
                            for n = 0, #tileListCold - 1 do
                                if spriteName == tileListCold[n] then
                                    --playerObj:getModData().bbStatusEffect = "Cold" <- Worthless game overrides it
                                    playerObj:getModData().bbStatusEffect = "Sickness"
                                    isHidingSpot = true
                                    break
                                end
                            end
                        end
                    end
                end
            end

            local objContainer = obj:getContainer()
            if objContainer and objContainer:getCapacityWeight() >= (objContainer:getCapacity() / 1.7) then
                isHidingSpot = false
            end
        end

        if isHidingSpot == true then
            if not playerObj:getModData().bbStatusEffect then
                playerObj:getModData().bbStatusEffect = "Boredom"
            end
            targetObj = obj
        end
    end

    if targetObj then
        context:addOptionOnTop(getText("ContextMenu_Hide"), playerObj, hide, targetObj, player)
    end
end

local everyTenMinutes = function()
    local playerObj = getPlayer()
    if not playerObj:getModData().hiding then return end

    local statusEffect = playerObj:getModData().bbStatusEffect

    if statusEffect == "Boredom" then
        local bodyDamage = playerObj:getBodyDamage()
        bodyDamage:setBoredomLevel(bodyDamage:getBoredomLevel() + (ZomboidGlobals.BoredomDecrease * 120))
    elseif statusEffect == "Sickness" then
        local bodyDamage = playerObj:getBodyDamage()
        bodyDamage:setFoodSicknessLevel(bodyDamage:getFoodSicknessLevel() + 4)
    elseif statusEffect == "Cold" then
        playerObj:setTemperature(playerObj:getTemperature() - 2)
    end
end

Events.EveryTenMinutes.Add(everyTenMinutes)
Events.OnGameStart.Add(onGameStart)
Events.OnFillWorldObjectContextMenu.Add(onFillWorldObjectContextMenu)