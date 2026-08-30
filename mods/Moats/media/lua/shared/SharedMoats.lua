require 'GlobalObject/SharedGlobalObjectTools'
Moats = Moats or {}
Moats.key = 'moats'
Moats.modDataKeys = {'spriteName','exterior','taintedWater','waterAmount','waterMax'}
Moats.Verbose = false
Moats.WestSprite = "location_community_cemetary_01_16"
Moats.LongitudeSprite = "location_community_cemetary_01_17"
Moats.EastSprite = "location_community_cemetary_01_18"
Moats.SouthSprite = "location_community_cemetary_01_19"
Moats.LatitudeSprite = "location_community_cemetary_01_20"
Moats.NorthSprite = "location_community_cemetary_01_21"
Moats.NoShoreLoadKey = 'NoShoreLoad'

local lcl = {}
lcl.igs_base = __classmetatables[IsoGridSquare.class].__index
lcl.igs_getX             = lcl.igs_base.getX
lcl.igs_getY             = lcl.igs_base.getY
lcl.igs_getZ             = lcl.igs_base.getZ
lcl.igs_getFloor         = lcl.igs_base.getFloor
lcl.igs_addFloor         = lcl.igs_base.addFloor
lcl.igs_disableErosion   = lcl.igs_base.disableErosion
lcl.igs_RemoveTileObject = lcl.igs_base.RemoveTileObject
lcl.igs_isOutside        = lcl.igs_base.isOutside
lcl.igs_getObjects        = lcl.igs_base.getObjects

lcl.io_base = __classmetatables[IsoObject.class].__index
lcl.io_getProperties     = lcl.io_base.getProperties
lcl.io_getObjectName     = lcl.io_base.getObjectName


lcl.pc_base = __classmetatables[PropertyContainer.class].__index
lcl.pc_Is     = lcl.pc_base.Is
lcl.pc_Val    = lcl.pc_base.Val

function Moats.isWaterSource(pos)
    local square = getCell():getGridSquare(pos.x, pos.y, pos.z)
    local isWater = false
    if square then
        local currentFloor = lcl.igs_getFloor(square)
        if currentFloor then
            local prevFloorProps = lcl.io_getProperties(currentFloor)
            isWater = prevFloorProps and lcl.pc_Is(prevFloorProps,IsoFlagType.water)
        else
            local objects = lcl.igs_getObjects(square)
            if objects and lcl.PZArrayList_size(objects) > 0 then
                local isoObject0 = lcl.PZArrayList_get(objects,0)
                local obj0Props = lcl.io_getProperties(isoObject0)
                isWater = obj0Props and lcl.pc_Is(obj0Props,IsoFlagType.water)
            end
        end
        if Moats.Verbose then print('isWaterSource '..sq2str(square)..' = '..tostring(isWater)); end 
    end
    return isWater
end