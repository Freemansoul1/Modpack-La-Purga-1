
local lcl = lcl or {}
lcl.ArrayList_base   = __classmetatables[ArrayList.class].__index
lcl.ArrayList_size   = lcl.ArrayList_base.size
lcl.ArrayList_get    = lcl.ArrayList_base.get

lcl.igs_base = __classmetatables[IsoGridSquare.class].__index
lcl.igs_getObjects        = lcl.igs_base.getObjects
lcl.igs_RemoveTileObject  = lcl.igs_base.RemoveTileObject

lcl.io_base = __classmetatables[IsoObject.class].__index
lcl.io_getProperties     = lcl.io_base.getProperties
lcl.io_getObjectName     = lcl.io_base.getObjectName

lcl.pc_base = __classmetatables[PropertyContainer.class].__index
lcl.pc_Is     = lcl.pc_base.Is
lcl.pc_Val    = lcl.pc_base.Val

lcl.PZArrayList_base        = __classmetatables[PZArrayList.class].__index
lcl.PZArrayList_size        = lcl.PZArrayList_base.size
lcl.PZArrayList_get         = lcl.PZArrayList_base.get

function lcl.OnPlayerUpdate(player)
    if not player then return end
    local sq = player:getCurrentSquare()
    if not sq or sq == lcl.sq then return end
    lcl.sq = sq
    local isInARoom = sq:isInARoom()
    local iwr = sq:getIsoWorldRegion()
    print('Player [',sq:getX(),',',sq:getY(),'] ',(sq:getRoom() and 'getRoom' or 'notRoom'),' ',(iwr and 'IWR' or 'OWR'),' ',(iwr and iwr:isPlayerRoom() and 'PlayerRoom' or 'NotPR'))
    if not iwr then return end
    local isoChunkRegions = iwr:getDebugIsoChunkRegionCopy()
    for i=0, lcl.ArrayList_size(isoChunkRegions)-1 do
        local cr = lcl.ArrayList_get(isoChunkRegions,i)
        print('  ChunkRegion [',i,'] ',cr:getSquareSize(),' ',cr:getRoofCnt())
    end
end


--Events.OnPlayerUpdate.Add(lcl.OnPlayerUpdate);

--we use consumeMaterial because with B42 it is reliably called by vanilla B41 before transmitting the square to the server
--but after having sq and javaObject valid
lcl.consumeMaterial = buildUtil.consumeMaterial
function buildUtil.consumeMaterial(buildingObject)
    local consumedItems = lcl.consumeMaterial(buildingObject)

    --if we are adding an object1 with flag cutW and there is already an object2 with cutW and WallSE flags
    if buildingObject and buildingObject.javaObject then
        local sprite = buildingObject.javaObject:getSprite()
        if sprite then
            local props = sprite:getProperties()
            if props then
                if props:Is(IsoFlagType.cutW) then
                    --here we know boNeedNWClear = true
                    local sq = buildingObject.sq
                    if sq then
                        local objects = lcl.igs_getObjects(sq)
                        if objects then
                            for i=lcl.PZArrayList_size(objects)-1, 0, -1 do
                                local isoObject = lcl.PZArrayList_get(objects,i)
                                if isoObject then
                                    local props = lcl.io_getProperties(isoObject)
                                    if (lcl.pc_Is(props,IsoFlagType.WallSE) and  lcl.pc_Is(props,IsoFlagType.cutW)) then--I see you NW pillar
                                        lcl.igs_RemoveTileObject(sq,isoObject)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    return consumedItems
end
