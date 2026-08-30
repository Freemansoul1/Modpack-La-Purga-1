if isClient() then return end--code below is server & solo only
require 'SMoatsGO'

function Moats.updateMoatsServer(self)
    local isRaining = RainManager.isRaining()
    local waterObjList = {}
    if Moats.Verbose then print('checkFlooding '..self:getLuaObjectCount()..' lua objects.'); end
    for i=1,self:getLuaObjectCount() do
        local luaObject = self:getLuaObjectByIndex(i)
        local data = luaObject
        if Moats.Verbose then print('checkFlooding '..tab2str(data)); end 
        if data.waterAmount < data.waterMax then
            local square = luaObject:getSquare()
            if square then
                data.exterior = square:isOutside()
                local xPos=square:getX()
                local yPos=square:getY()
                local zPos=square:getZ()
                data.nextToWaterTile = Moats.isWaterSource({x=xPos-1,y=yPos,z=zPos}) or Moats.isWaterSource({x=xPos+1,y=yPos,z=zPos}) or Moats.isWaterSource({x=xPos,y=yPos+1,z=zPos}) or Moats.isWaterSource({x=xPos,y=yPos-1,z=zPos})
            end
            if Moats.Verbose then print('checkFlooding exterior='..tostring(data.exterior)..' isRaining='..tostring(isRaining)..' nextToWaterTile='..tostring(data.nextToWaterTile)); end 
            --increase water level if raining outside or if there is a water tile aside
            if data.exterior and isRaining or data.nextToWaterTile then
                local previousAmount=data.waterAmount
                data.waterAmount = math.min(data.waterMax, data.waterAmount + 1 * RainCollectorBarrel.waterScale)
                data.taintedWater = true
                local isoObject = luaObject:getIsoObject()
                if isoObject then -- object might have been destroyed
                    if data.waterAmount < data.waterMax or square == nil then
                        self:noise('added water to moat at '..luaObject.x..","..luaObject.y..","..luaObject.z..' waterAmount='..data.waterAmount)
                        isoObject:setTaintedWater(true)
                        isoObject:setWaterAmount(data.waterAmount)
                        isoObject:getModData().waterMax = data.waterMax
                        isoObject:transmitModData()
                    end
                end
                if Moats.Verbose then print('checkFlooding moats '..previousAmount..' to '..data.waterAmount); end
            end
            
            if square and data.waterAmount >= data.waterMax then
                table.insert(waterObjList,luaObject)--add to the list to transform into water tile
            end
        end
    end
    
    if Moats.Verbose then print('Moats.updateMoatsServer moats '..tab2str(waterObjList)); end
    for i=#waterObjList, 1, -1 do
        local luaObject=waterObjList[i] 
        local square = luaObject:getSquare()
        luaObject:removeIsoObject()--removes Global Object
        makeItWaterTile(square,true,true)--square to become water, remove erosion, remove other objects
    end
end


-- every 10 minutes we check if it's raining, to fill our water barrel
local function floodMoats()
    local moatsSys = SGOSystems[Moats.key].instance
    if moatsSys then 
        Moats.updateMoatsServer(moatsSys)
    end
end

-- every 10 minutes we check if it's raining, to fill our water barrel
Events.EveryTenMinutes.Add(floodMoats)
