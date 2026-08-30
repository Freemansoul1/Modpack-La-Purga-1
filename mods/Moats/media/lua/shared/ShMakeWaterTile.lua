require 'SharedMoats'
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

lcl.PZArrayList_base        = __classmetatables[PZArrayList.class].__index
lcl.PZArrayList_size        = lcl.PZArrayList_base.size
lcl.PZArrayList_get         = lcl.PZArrayList_base.get


function makeItWaterTile(square,removeErosion,removeOtherTiles)
    if Moats.Verbose then print('Square ',square:getX(),' ',square:getY(),' ',square:getZ(),' ',square:getPlayerBuiltFloor(),' ',daysSinceStart) end

    if removeErosion then--disable erosion
        lcl.igs_disableErosion(square)
        if isClient() then
            local args = { x = lcl.igs_getX(square), y = lcl.igs_getY(square), z = lcl.igs_getZ(square) }
            sendClientCommand('erosion', 'disableForSquare', args)
        end
    end
    
    if removeOtherTiles then--remove tiles that should disappear with the flow
        -- maybe just store coordinate to remove stuff one square per cycle later?
        local objects = lcl.igs_getObjects(square)
        if objects then
            for i=lcl.PZArrayList_size(objects)-1,0,-1 do
                local isoObject = lcl.PZArrayList_get(objects,i)
                if isoObject then --and isoObject ~= newObj then
                    local props = lcl.io_getProperties(isoObject)
                    if Moats.Verbose then print('Remove Object ',i,' ',isoObject:getObjectName(),' ',isoObject:getTextureName(),' Water=',props:Is(IsoFlagType.water),' Floor=',props:Is(IsoFlagType.solidfloor),' Trans=',props:Is(IsoFlagType.solidtrans)) end
                    lcl.igs_RemoveTileObject(square,isoObject)
                    i = i - 1
                end
            end
        end
    end
    
    local newObj = lcl.igs_addFloor(square,"blends_natural_02_0");--replace square with water
    if isServer() then
        newObj:transmitUpdatedSpriteToClients();
    end
    
    --if not isServer() then--does not work for MP, probably because OnLoadMapZones is called before ModData client reception from server.
        local zx = lcl.igs_getX(square)
        local zy = lcl.igs_getY(square)

        registerMoatZone(zx,zy)
    --end
end

function registerMoatZone(x,y)
    local repos = ModData.getOrCreate(Moats.NoShoreLoadKey)
    if not repos then return end
    local xMap = repos[x]
    if not xMap then
        repos[x]= {}
        repos[x][y]=true
    else
        if xMap[y] then return end--already stored
        xMap[y]=true
    end
    if not SandboxVars.Moats or SandboxVars.Moats.RemoveShores then
        if Moats.Verbose then print('registerMoatZone '..x..' '..y) end
        getWorld():registerWaterZone(x-1, y-1, x+1, y+1, 0.0, 0.0);
    end
    if Moats.Verbose then print('registerMoatZone GMD['..Moats.NoShoreLoadKey..']['..x..']['..y..']='..tab2str(ModData.getOrCreate(Moats.NoShoreLoadKey)[x][y])) end
end
