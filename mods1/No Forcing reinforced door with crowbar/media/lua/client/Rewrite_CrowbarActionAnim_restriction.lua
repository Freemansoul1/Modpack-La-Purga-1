--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************
--require "Lockpicking/UI/UIVehicle"
require "Lockpicking/Crowbar/CrowbarWindow"
require "TimedActions/ISBaseTimedAction"
-------------------------------------------------------------------------------------------------------------------------------------------------------------
--local upperLayer = {}
--upperLayer.CrowbarWindow = {}
-------------------------------------------------------------------------------------------------------------------------------------------------------------
--upperLayer.CrowbarWindow.createBuildingDoor = CrowbarWindow.createBuildingDoor
--function CrowbarWindow:createBuildingDoor(playerObj, door)
--    upperLayer.CrowbarWindow.createBuildingDoor(self,playerObj, door)
--    local spriteName = door:getSprite():getName()
--    if  spriteName and 
--        spriteName == "fixtures_doors_01_32"               or 
--        spriteName == "fixtures_doors_01_33"               or
--        spriteName == "location_community_police_01_4"     or
--        spriteName == "location_community_police_01_5"     then 
--
--        playerObj:Say("i can't do this! because is renforced !") 
--        --self:close()
--        --self:forceStop()
--        --ISPanel.close(self)
--        return  
--    end
--    --return true
--end
local WINDOW_WIDTH = 340
local WINDOW_HEIGHT = 150

local MODE_BUILDING_DOOR = 2

function CrowbarWindow:createBuildingDoor(playerObj, door)
    local dx = door:getSquare():getX() - playerObj:getSquare():getX()
    local dy = door:getSquare():getY() - playerObj:getSquare():getY()
    local zGood = math.abs(door:getSquare():getZ() - playerObj:getSquare():getZ()) < 2
    local dist = math.sqrt(dx*dx + dy*dy)
    
    if not zGood or dist > 2 then 
        return
    end

    if not door:isLocked() then
        playerObj:Say(getText("UI_door_is_unlocked"))
        return
    end

    local spriteName = door:getSprite():getName()
    if  spriteName and 
        spriteName == "fixtures_doors_01_32"               or 
        spriteName == "fixtures_doors_01_33"               or
        spriteName == "location_community_police_01_4"     or
        spriteName == "location_community_police_01_5"     then 

        playerObj:Say("i can't do this! because is reinforced !") 
        --self:close()
        --self:forceStop()
        --ISPanel.close(self)
    return
    end  

    local modal = CrowbarWindow:new(Core:getInstance():getScreenWidth()/2 - WINDOW_WIDTH/2 + 300, Core:getInstance():getScreenHeight()/2 - 500/2, WINDOW_WIDTH, WINDOW_HEIGHT)
    modal.lockpick_object = door
    modal.mode = MODE_BUILDING_DOOR
    modal.character = playerObj
    modal.addingXP = door:getModData().LockpickLevel.xp
    modal.diffLevel = door:getModData().LockpickLevel.num
    modal.isGarage = IsoDoor.getGarageDoorIndex(door) ~= -1

    local pos = door:getFacingPosition(playerObj:getPlayerMoveDir())
    if not door:getNorth() then
        playerObj:facePosition(pos:getX(), pos:getY()+1)
    else
        playerObj:facePosition(pos:getX()+1, pos:getY())
    end

    modal:initialise()
    modal:addToUIManager()
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------

--function BetLock.UI.goToDoorBobbyPin(playerObj, door, goToOpen)
--    local sq = door:getSquare()
--    if door:getOppositeSquare():DistTo(playerObj:getSquare()) < door:getSquare():DistTo(playerObj:getSquare()) then
--        sq = door:getOppositeSquare()
--    end
--
--    ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, sq));
--    if playerObj:getPrimaryHandItem() then
--        ISTimedActionQueue.add(ISUnequipAction:new(playerObj, playerObj:getPrimaryHandItem(), 50));
--    end
--    if playerObj:getSecondaryHandItem() and playerObj:getSecondaryHandItem() ~= playerObj:getPrimaryHandItem() then
--        ISTimedActionQueue.add(ISUnequipAction:new(playerObj, playerObj:getSecondaryHandItem(), 50));
--    end
--
--    ISTimedActionQueue.add(EmptyAction:new(playerObj, BobbyPinWindow.createBuildingDoor, nil, playerObj, door, goToOpen))
--end
