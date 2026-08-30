require "PrivateUI/Safehouse"
 
function HideSHUI()
    local player = getPlayer();
    local square = player:getSquare();
    if square then
        local x, y = square:getX(), square:getY();
        if Private.GUI then
            if ((x < 9305 and x > 7550) and (y < 7500 and y > 5000)) -- хоуптаун
             or ((x < 11640 and x > 11200) and (y < 8000 and y > 7150)) -- госпиталь и оазис
             or ((x < 15000 and x > 11900) and (y < 3450 and y > 1000)) -- Луи
            or ((x < 10905 and x > 10857) and (y < 11168 and y > 11108)) -- свалка1
             or ((x < 13323 and x > 13277) and (y < 6462 and y > 6405)) -- свалка2
            or ((x < 4926 and x > 4900) and (y < 6412 and y > 6355)) -- свалка3
            or ((x > 5985 and x < 6269) and (y > 10727 and y < 11119)) -- гора Блэк
            or ((x > 12000 and x < 12299) and (y > 10800 and y < 11100)) -- Осирис
            or ((x > 8500 and x < 10500) and (y > 1800 and y < 3200)) -- Канализации
            or ((x > 9029 and x < 9425) and (y > 4802 and y < 4976)) -- Бункер
            or ((x > 10233 and x < 10329) and (y > 8650 and y < 8810)) -- Локация квест Каина Реле
            or ((x > 14729 and x < 14851) and (y > 4051 and y < 4180)) -- Локация квест Каина
            then
                Private.GUI:setVisible(false);
            else
                Private.GUI:setVisible(true);
            end
        end
    end
end
 
Events.OnPlayerUpdate.Add(HideSHUI)