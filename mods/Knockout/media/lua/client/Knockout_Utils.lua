Knockout = Knockout or {}

function Knockout.disabler(player, bool)
    player:setIgnoreInputsForDirection(bool)
    player:setAuthorizeMeleeAction(not bool)
    player:setIgnoreAimingInput(bool)
    player:setCanShout(not bool)
    player:setBlockMovement(bool)
end

function Knockout.GetWorldAgeInDays()
    local worldAgeInHours = getGameTime():getWorldAgeHours()
    local worldAgeInDays = math.ceil(worldAgeInHours / 24)
    return worldAgeInDays
end

-- Function to check if one minute has passed between initialTime and currentTime
function Knockout.timePassed(initialTime)
    local currentTime = {
        day = Knockout.GetWorldAgeInDays(),
        hour = getGameTime():getHour(),
        minute = getGameTime()
            :getMinutes()
    }

    local timeDifference = (currentTime.day - initialTime.day) * 24 * 60 + (currentTime.hour - initialTime.hour) * 60 +
        (currentTime.minute - initialTime.minute)

    return timeDifference
end

function Knockout.setUnconscious(character)
    if character:getModData().Knockout_isKnockedout then return end

    local playerIndex = character:getPlayerNum() --Get player num

    ISTimedActionQueue.clear(character)
    ISTimedActionQueue.add(Knockout_TimedAction:new(character, playerIndex))
end

Events.OnFillWorldObjectContextMenu.Add(function(player, context, worldobjects)
    if isAdmin() or isDebugEnabled() or getSpecificPlayer(player):isAccessLevel('admin') then
        local knockoutOption = context:addOption(getText("ContextMenu_Knockout_DebugOption"), playersList,
            Knockout.onCreateUI)
    end
end)

function Knockout.isOtherPlayerKnockedOutResponse(playerObj, clickedPlayerID)
    local playerObjID = playerObj:getOnlineID()
    local args = { playerObjID, clickedPlayerID }
    sendClientCommand('RealKnockouts', 'CheckKnockoutStatus', args)

    local response = playerObj:getModData().Knockout_CheckKnockoutStatusResponse
    playerObj:getModData().Knockout_CheckKnockoutStatusResponse = nil
    return response
end

function Knockout.isBeingAttackedByZombies(character)
    local vehicle = character:getVehicle()

    if vehicle then
        local seat = vehicle:getSeat(getPlayer())
        local windowPart = nil

        if seat == 0 then
            windowPart = vehicle:getPartById("WindowFrontLeft")
        elseif seat == 1 then
            windowPart = vehicle:getPartById("WindowFrontRight")
        elseif seat == 2 then
            windowPart = vehicle:getPartById("WindowRearLeft")
        elseif seat == 3 then
            windowPart = vehicle:getPartById("WindowRearRight")
        end

        if windowPart then
            local windowObj = windowPart:getWindow()

            if windowObj and (windowObj:isOpen() or windowObj:isDestroyed()) then
                local playerX, playerY = character:getX(), character:getY()

                for x = playerX - 2, playerX + 2 do
                    for y = playerY - 2, playerY + 2 do
                        local square = getSquare(x, y, character:getZ())

                        if square then
                            local squareZombie = square:getZombie()

                            if squareZombie and squareZombie:isAttacking() and squareZombie:getTarget() == character then
                                return true
                            end
                        end
                    end
                end
            end
        end
    else
        -- If player is on foot
        local surroundingZombies = character:getSurroundingAttackingZombies()

        if surroundingZombies > 0 then
            return true
        end
    end

    return false
end
