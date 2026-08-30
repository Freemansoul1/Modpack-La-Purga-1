-- ************************************************************************
-- **        ██████  ██████   █████  ██    ██ ███████ ███    ██          **
-- **        ██   ██ ██   ██ ██   ██ ██    ██ ██      ████   ██          **
-- **        ██████  ██████  ███████ ██    ██ █████   ██ ██  ██          **
-- **        ██   ██ ██   ██ ██   ██  ██  ██  ██      ██  ██ ██          **
-- **        ██████  ██   ██ ██   ██   ████   ███████ ██   ████          **
-- ************************************************************************
-- ** All rights reserved. This content is protected by © Copyright law. **
-- ************************************************************************

local function onObjectAboutToBeRemoved(object)
    local squareX, squareY, squareZ = object:getX(), object:getY(), object:getZ()
    local args = { spawnPointX = squareX, spawnPointY = squareY, spawnPointZ = squareZ }
    sendClientCommand(getPlayer(), "RespawnableSBags", "", args)
end

Events.OnObjectAboutToBeRemoved.Add(onObjectAboutToBeRemoved)

local onPlaceMoveable = ISMoveableSpriteProps.placeMoveable

function ISMoveableSpriteProps:placeMoveable(character, square, origSpriteName)

    if string.find(origSpriteName, "sleepingbags") then

        local squareX, squareY, squareZ = square:getX(), square:getY(), square:getZ()
        local toolMode = ISMoveableCursor.mode[character:getPlayerNum()]

        for dx = -2, 2 do
            for dy = -2, 2 do
                local x = squareX + dx
                local y = squareY + dy
                local sq = getCell():getGridSquare(x, y, squareZ)
                if sq then
                    local sqProps = sq:getProperties()
                    if sqProps then
                        if sqProps:Is(IsoFlagType.bed) then
                            if sqProps:Is("GroupName") then
                                if string.find(sqProps:Val("GroupName"), "Sleeping") then
                                    if toolMode ~= "rotate" then
                                        character:Say("Invalid Placement! Must be at least 2 Squares away from other Bags, in every direction.")
                                        return
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        character:Say("Respawn Point Added")

        local spawnPointX = square:getX()
        local spawnPointY = square:getY()
        local spawnPointZ = square:getZ()
        RespawnableSBags_Client.AddRespawnPoint(spawnPointX, spawnPointY, spawnPointZ)
    end

    return onPlaceMoveable(self, character, square, origSpriteName)
end

local onDestroyStuff = ISDestroyStuffAction.perform

function ISDestroyStuffAction:perform()
	if self.item == nil then
        return onDestroyStuff(self)
	end

    local square = self.item:getSquare(); if not square then return end
    local squareX, squareY, squareZ = square:getX(), square:getY(), square:getZ()
    local args = { spawnPointX = squareX, spawnPointY = squareY, spawnPointZ = squareZ }
    sendClientCommand(getPlayer(), "RespawnableSBags", "RemoveSBag", args)
    onDestroyStuff(self)
end