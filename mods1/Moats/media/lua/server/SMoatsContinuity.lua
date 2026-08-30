if isClient() then return end--code below is server & solo only
require 'SMoatsGO'

local addCommand = 'add_'..Moats.key
function Moats.attemptsContinuity(command, playerObj, args, result, objectSystemInstance)
    if Moats.Verbose then print('attemptsContinuity '..command..' '..tab2str(result)); end
    if command == addCommand then
        if Moats.Verbose then print('attemptsContinuity handling command.'); end
        local luaObject = result
        if not luaObject or not luaObject.spriteName then return end
        if objectSystemInstance == nil then objectSystemInstance = SGOSystems[Moats.key].instance end--TODO correct: why is objectSystemInstance nil ? it should really not ?
        if luaObject.spriteName == Moats.WestSprite then
            Moats.joinSquaresSprites(luaObject, objectSystemInstance, -1, 0., Moats.EastSprite, Moats.LongitudeSprite)
        elseif luaObject.spriteName == Moats.EastSprite then
            Moats.joinSquaresSprites(luaObject, objectSystemInstance,  1, 0., Moats.WestSprite, Moats.LongitudeSprite)
        elseif luaObject.spriteName == Moats.SouthSprite then
            Moats.joinSquaresSprites(luaObject, objectSystemInstance, 0.,  1, Moats.NorthSprite, Moats.LatitudeSprite)
        elseif luaObject.spriteName == Moats.NorthSprite then
            Moats.joinSquaresSprites(luaObject, objectSystemInstance, 0., -1, Moats.SouthSprite, Moats.LatitudeSprite)
        end
    else
        if Moats.Verbose then print('attemptsContinuity NOT handling command '..command..' ~= '..addCommand); end
    end
end

function Moats.joinSquaresSprites(luaObject, objectSystemInstance, offsetLongitude, offsetLatitude, expectedBorderSprite, middleSprite)
    if Moats.Verbose then print('attemptsContinuity join.'); end
    local sideSquare = getCell():getGridSquare(luaObject.x+offsetLongitude,luaObject.y+offsetLatitude,luaObject.z)
    if sideSquare then
        if Moats.Verbose then print('attemptsContinuity join with side square.'); end
        local sideObject = objectSystemInstance:getLuaObjectOnSquare(sideSquare)
        if sideObject then
            local changeSprite = false
            if Moats.Verbose then print('attemptsContinuity join with side moat.'); end
            if sideObject:getSpriteName() == expectedBorderSprite then
                if Moats.Verbose then print('attemptsContinuity join with side moat as east sprite.'); end
                changeSprite = true
                sideObject:setSpriteName(middleSprite)
                local isoObject = sideObject:getIsoObject()
                if isoObject then
                    isoObject:transmitUpdatedSpriteToClients()
                end
            elseif sideObject:getSpriteName() == middleSprite then
                changeSprite = true
            else
                if Moats.Verbose then print('attemptsContinuity join not changing because side sprite=='..sideObject:getSpriteName()); end
            end
            if changeSprite then
                if Moats.Verbose then print('attemptsContinuity join changing to '..middleSprite); end
                luaObject:setSpriteName(middleSprite)
                local isoObject = luaObject:getIsoObject()
                if isoObject then
                    isoObject:transmitUpdatedSpriteToClients()
                end
            end
        end
    end
end

Events['OnSGlobalObjectReceiveCommand_'..Moats.key].Add(Moats.attemptsContinuity)
