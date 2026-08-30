local IFP = IndustrialFuelPumps

function IFP.OnObjectAboutToBeRemoved(isoObject)
    if IFP.isRemovingObject or not IFP.gridTiles[isoObject:getTextureName()] then return end

    IFP.isRemovingObject = true
    local objects = ArrayList.new()
    isoObject:getSpriteGridObjects(objects)
    for i=objects:size()-1,0,-1 do
        local obj = objects:get(i)
        if isoObject ~= obj then
            local sq = obj:getObjectIndex() ~= -1 and obj:getSquare()
            if sq ~= nil then
                --if ZombRand(100) < IFP.removeChance then
                    sq:transmitRemoveItemFromSquare(obj)
                    IsoFireManager.StartFire(getCell(), sq, true, 100, 0)
                --else
                --    obj.getModData()
                --end
            end
        end
    end
    IFP.isRemovingObject = nil

end

function IFP.OnNewWithSprite(isoObject)
    local square = isoObject:getSquare()

    if not square or isoObject:getObjectIndex() == -1 then return print("IFP: OnNewWithSprite ",square,isoObject:getObjectIndex()) end

    IFP.isRemovingObject = true
    local index = isoObject:getObjectIndex()
    local spriteName = isoObject:getTextureName()
    square:transmitRemoveItemFromSquare(isoObject)

    local isoObject = IsoThumpable.new(getCell(), square, spriteName, false, {})
    isoObject:setThumpDmg(8)
    --square:transmitAddObjectToSquare(isoObject, index)
    square:AddSpecialObject(isoObject)
    if isServer() then
        isoObject:transmitCompleteItemToClients()
    end

    if ZombRand(100) < IFP.soundChance then
        addSound(nil,isoObject:getX(),isoObject:getY(),isoObject:getZ(),ZombRand(IFP.addSoundMax),1)
    end

    IFP.isRemovingObject = nil
end

if not isClient() then
    if IFP.isThump then
        for sprite,_ in pairs(IFP.gridTiles) do
            MapObjects.OnNewWithSprite(sprite, IFP.OnNewWithSprite, 5)
        end
    end

    Events.OnObjectAboutToBeRemoved.Add(IFP.OnObjectAboutToBeRemoved)
end
