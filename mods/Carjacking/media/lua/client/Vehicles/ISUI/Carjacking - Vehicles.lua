require "Vehicles/ISUI/ISVehicleMenu"

function ISVehicleMenu.onEnter(playerObj, vehicle, seat)
    if vehicle:isSeatOccupied(seat) then
        if vehicle:getCharacter(seat) then
            playerObj:Say(getText("IGUI_PlayerText_VehicleSomeoneInSeat"))

            if playerObj:getVehicle() ~= vehicle then

                local doorPart = vehicle:getPassengerDoor(seat)
                local door = doorPart:getDoor()

                if (not door or door:isOpen()) then
                    ---@type IsoPlayer|IsoGameCharacter
                    local victim = vehicle:getCharacter(seat)
                    if victim and SwipeStatePlayer.checkPVP(playerObj, victim) then
                        ISVehicleMenu.onExit(victim, seat)
                        victim:faceThisObjectAlt(vehicle)
                        victim:clearVariable("BumpFallType")
                        victim:setBumpType("stagger")
                        victim:setBumpDone(false)
                        victim:setBumpFall(true)
                        victim:setBumpFallType("pushedFront")
                    end
                end
            end

        else
            if not ISVehicleMenu.moveItemsFromSeat(playerObj, vehicle, seat, true, true) then
                playerObj:Say(getText("IGUI_PlayerText_VehicleItemInSeat"))
                return
            end
        end
    end

    if isShiftKeyDown() then
        ISVehicleMenu.processShiftEnter(playerObj, vehicle, seat)
    elseif vehicle:isPassengerUseDoor2(playerObj, seat) then
        ISVehicleMenu.processEnter2(playerObj, vehicle, seat);
    else
        ISVehicleMenu.processEnter(playerObj, vehicle, seat);
    end

end