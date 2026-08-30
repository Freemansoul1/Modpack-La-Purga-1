
CVD = CVD or {}
CVD.Verbose = false
CVD.memo = {}


local lcl = {}
lcl.player_base        = __classmetatables[IsoPlayer.class].__index
lcl.player_getVehicle  = lcl.player_base.getVehicle

lcl.vehicle_base        = __classmetatables[BaseVehicle.class].__index
lcl.vehicle_isDriver         = lcl.vehicle_base.isDriver
lcl.vehicle_getSpeed2D       = lcl.vehicle_base.getSpeed2D
lcl.vehicle_getMaxPassengers = lcl.vehicle_base.getMaxPassengers
lcl.vehicle_getPassengerDoor = lcl.vehicle_base.getPassengerDoor
lcl.vehicle_getId            = lcl.vehicle_base.getId
lcl.vehicle_playPartSound    = lcl.vehicle_base.playPartSound


lcl.vPart_base        = __classmetatables[VehiclePart.class].__index
lcl.vPart_getDoor          = lcl.vPart_base.getDoor
lcl.vPart_getId            = lcl.vPart_base.getId

lcl.vDoor_base        = __classmetatables[VehicleDoor.class].__index
lcl.vDoor_isOpen      = lcl.vDoor_base.isOpen
lcl.vDoor_setOpen     = lcl.vDoor_base.setOpen


function CVD.OnPlayerUpdate(isoPlayer)
    if not isoPlayer then return end--some reuse from elsewhere with missing parameter
    local vehicle = lcl.player_getVehicle(isoPlayer)
    if not vehicle or not lcl.vehicle_isDriver(vehicle,isoPlayer) then
        CVD.memo[isoPlayer] = false
        return
    end
    
    if lcl.vehicle_getSpeed2D(vehicle) > 0.1 then
        if not CVD.memo[isoPlayer] then
            --if CVD.Verbose then print('CVD.OnPlayerUpdate '..vehicle:getSpeed2D()) end
            for seat = 0, lcl.vehicle_getMaxPassengers(vehicle) do
                local part = lcl.vehicle_getPassengerDoor(vehicle, seat);
                if part then
                    local door = lcl.vPart_getDoor(part)
                    if door and lcl.vDoor_isOpen(door) then
                        CVD.closeDoor(isoPlayer, vehicle, part)
                        if CVD.Verbose then print('CVD.OnPlayerUpdate close door for part '..part:getId()..' '..b2str(lcl.vDoor_isOpen(door))) end
                    end
                end
            end
            CVD.memo[isoPlayer] = true
        end
    else
        CVD.memo[isoPlayer] = false
    end
end

Events.OnPlayerUpdate.Add(CVD.OnPlayerUpdate)

function CVD.closeDoor(isoGameCharacter, baseVehicle, vehiclePart)
    if isoGameCharacter and baseVehicle and vehiclePart then
        --play close animation ?
        lcl.vehicle_playPartSound(baseVehicle, vehiclePart, isoGameCharacter, "Close")
        local args = { vehicle = lcl.vehicle_getId(baseVehicle), part = lcl.vPart_getId(vehiclePart), open = false }
        sendClientCommand(isoGameCharacter, 'vehicle', 'setDoorOpen', args)
        -- FIXME: due to network delay, we should wait until the server tells the client the door is closed before finishing
        local door = lcl.vPart_getDoor(vehiclePart)
        lcl.vDoor_setOpen(door, false)
        triggerEvent("OnContainerUpdate")
    end
end
