
JumpCompatibility = JumpCompatibility or {}

function JumpCompatibility.canEnterVehicle(character, vehicle, seat)
    --https://steamcommunity.com/sharedfiles/filedetails/?id=2957935793
    if AVCS and AVCS.checkPermission and AVCS.getSimpleBooleanPermission then
        return AVCS.getSimpleBooleanPermission(AVCS.checkPermission(character, vehicle))
    end
    
    --https://steamcommunity.com/sharedfiles/filedetails/?id=2694358451
    --only the owner can feel like a Duke
    if Valhalla and Valhalla.VehicleClaims and Valhalla.VehicleClaims.playerIsOwner then
        return Valhalla.VehicleClaims:playerIsOwner(vehicle, character)
    end
    
    --compatibility wih "no mod" ha ha!
    return true
end

----How to add your own modded condition to being a duke: create a lua file under media/lua/client/Compatibility with:
--local modInfoJump = getModInfoByID("Jump")
--if not modInfoJump or not isModActive(modInfoJump) then
--    return--handle : compat not required
--end
--require 'Compatibility/JumpCompatibility'
--
--if JumpCompatibility and JumpCompatibility.canEnterVehicle then
--    local jumpCompaCanEnter = JumpCompatibility.canEnterVehicle
--    function JumpCompatibility.canEnterVehicle(character, vehicle, seat)
--        if jumpCompaCanEnter(character, vehicle, seat) then
--            --add your own logic returning true or false
--        end
--        return false
--    end
--end