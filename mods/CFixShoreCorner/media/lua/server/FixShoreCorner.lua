
local lcl = lcl or {}
lcl.ArrayList_base   = __classmetatables[ArrayList.class].__index
lcl.ArrayList_size   = lcl.ArrayList_base.size
lcl.ArrayList_get    = lcl.ArrayList_base.get

lcl.igs_base = __classmetatables[IsoGridSquare.class].__index
lcl.igs_getObjects        = lcl.igs_base.getObjects
lcl.igs_RemoveTileObject  = lcl.igs_base.RemoveTileObject
lcl.igs_isSolidTrans      = lcl.igs_base.isSolidTrans
lcl.igs_getProperties     = lcl.igs_base.getProperties


lcl.io_base = __classmetatables[IsoObject.class].__index
lcl.io_getProperties     = lcl.io_base.getProperties
lcl.io_getObjectName     = lcl.io_base.getObjectName

lcl.pc_base = __classmetatables[PropertyContainer.class].__index
lcl.pc_Is     = lcl.pc_base.Is
lcl.pc_Val    = lcl.pc_base.Val
lcl.pc_UnSet  = lcl.pc_base.UnSet

lcl.PZArrayList_base        = __classmetatables[PZArrayList.class].__index
lcl.PZArrayList_size        = lcl.PZArrayList_base.size
lcl.PZArrayList_get         = lcl.PZArrayList_base.get


function lcl.onLoadGridsquare(square)
    if not lcl.igs_isSolidTrans(square) then return end--all passable terrain out
    local objects = lcl.igs_base.getObjects(square)
    if not objects then return end
    local size = lcl.PZArrayList_size(objects)
    if size < 2 then return end--water tiles out, empty squares out
    local isoObject = lcl.PZArrayList_get(objects,1)--second object, iter starts at 0
    if not isoObject then return end
    local textureName = isoObject:getTextureName()
    if textureName == 'blends_natural_02_1'--todo evaluate if applying a startswith check is better perf-wise.
    or textureName == 'blends_natural_02_2'
    or textureName == 'blends_natural_02_3'
    or textureName == 'blends_natural_02_4' then--todo evaluate if a check on other objects being solidtrans is required
        local props = lcl.io_getProperties(isoObject)
        lcl.pc_UnSet(props,IsoFlagType.solidtrans)--release the object flag
        local sqProps = lcl.igs_getProperties(square)
        lcl.pc_UnSet(sqProps,IsoFlagType.solidtrans)--release the square flag
    end
end


if not isClient() then
    Events.LoadGridsquare.Add(lcl.onLoadGridsquare)
end
