require "BuildingObjects/ISDestroyCursor"
require "BuildingObjects/ISMoveableCursor"
require "BuildingObjects/ISBuildingObject"
require "QuestFunction1"


local function isNeutralZone(x, y)
    if not ISBuildMenu.cheat then
        if ((x > 11508 and x < 11637 and y > 7530 and y < 7756) -- госпиталь + оазис
        or (x > 5985 and x < 6269 and y > 10727 and y < 11119) -- гора
        or (x > 9003 and x < 9236 and y > 4802 and y < 4987) -- бункер
        or (x >= 12162 and x <= 12216 and y >= 1363 and y <= 1417)) -- здание для квеста на оружие
       or ((x < 10905 and x > 10857) and (y < 11168 and y > 11108)) -- свалка1
        or ((x < 13323 and x > 13277) and (y < 6462 and y > 6405)) -- свалка2
       or ((x < 4926 and x > 4900) and (y < 6412 and y > 6355)) -- свалка3
       or ((x > 5985 and x < 6269) and (y > 10727 and y < 11119)) -- гора Блэк
       or ((x > 12000 and x < 12299) and (y > 10800 and y < 11100)) -- Осирис
       or ((x > 8500 and x < 10500) and (y > 1800 and y < 3200)) -- Канализации
       or ((x > 9029 and x < 9425) and (y > 4802 and y < 4976)) -- Бункер
       or ((x > 10233 and x < 10329) and (y > 8650 and y < 8810)) -- Локация квест Каина Реле
       or ((x > 14729 and x < 14851) and (y > 4051 and y < 4180)) -- Локация квест Каина
       or ((x < 15000 and x > 11900) and (y < 3450 and y > 1000)) -- Луи
       or ((x < 8761 and x > 8497) and (y < 9800 and y > 9600) and not isUserInWhitelist()) 
       or ((x < 11053 and x > 10471) and (y < 5436 and y > 5378)) 
       or ((x < 7813 and x > 7481) and (y < 8720 and y > 8081)) 
        then
            return true;
        end
    end
	return false;
end

local ISMoveableCursor_isValid = ISMoveableCursor.isValid;
function ISMoveableCursor:isValid(square)
    if square then
        if isNeutralZone(square:getX(), square:getY()) then
            self:setInfoPanel( square, nil, nil );
            self.cursorFacing = nil;
            self.joypadFacing = nil;
            return false;
        end
    end
    return ISMoveableCursor_isValid(self, square);
end

local ISDestroyCursor_isValid = ISDestroyCursor.isValid;
function ISDestroyCursor:isValid(square)
    if square then
        if isNeutralZone(square:getX(), square:getY()) then
            self.renderX = square:getX()
            self.renderY = square:getY()
            self.renderZ = square:getZ()
            return false;
        end
    end
	return ISDestroyCursor_isValid(self, square);
end

local ISBuildingObject_isValid = ISBuildingObject.isValid;
function ISBuildingObject:isValid(square)
    if square then
        if isNeutralZone(square:getX(), square:getY()) then
            return false;
        end
    end
    return ISBuildingObject_isValid(self, square);
end