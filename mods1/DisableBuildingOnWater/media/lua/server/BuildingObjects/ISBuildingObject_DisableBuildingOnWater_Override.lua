require "ISBaseObject"
require "ISBuildingObject"

Events.OnDoTileBuilding2.Remove(DoTileBuilding);

Events.OnDoTileBuilding3.Remove(DoTileBuildingJoyPad);

local function isWaterOrShore(sq)
    return sq:Is(IsoFlagType.water)
end

local function isMouseOverUI()
    local uis = UIManager.getUI()
    for i = 1, uis:size() do
        local ui = uis:get(i - 1)
        if ui:isMouseOver() then
            return true
        end
    end
    return false
end

-- render the item on the ground or launch the build
function DoTileBuilding(draggingItem, isRender, x, y, z, square)
    local spriteName = nil;
    if not draggingItem.player then
        print('ERROR: player not set in DoTileBuilding');
        draggingItem.player = 0
    end
    -- if the square is nil we have to create it (for example, the 2nd floor square are nil)
    if square == nil and getWorld():isValidSquare(x, y, z) then
        -- ~ 		print("create new square : " .. x .. " " .. y);
        square = getCell():createNewGridSquare(x, y, z, true);
        -- ~ 		print("square created : " .. newSq:getX() .. " " .. newSq:getY());
    end

    -- Disable Building On Water Override Code
    -- Check level 0 tile for water. 
    -- So players can't build bases hovering over water and then delete the stairs and use ropes etc.

    local zCheck = 0
    local sq = getCell():getGridSquare(square:getX(), square:getY(), zCheck);

    if not DisableBuildingOnWater_Exceptions[draggingItem.sprite] then
        local isWater = isWaterOrShore(sq)
        if isWater then
            draggingItem.canBeBuild = false
            return
        end

        -- Check stairs sprite, which consists of 4 tiles in a direction. None of them should be on water.
        if draggingItem.sprite == "carpentry_02_88" then
            -- Check stairs direction
            if draggingItem.north then
                for y = 1, 4, 1 do
                    local northCheckSq = getCell():getGridSquare(square:getX(), square:getY() - y, zCheck);
                    isWater = isWaterOrShore(northCheckSq)
                    if isWater then
                        draggingItem.canBeBuild = false
                        return
                    end
                end
            elseif draggingItem.west then
                for x = 1, 4, 1 do
                    local westCheckSq = getCell():getGridSquare(square:getX() - x, square:getY(), zCheck);
                    isWater = isWaterOrShore(westCheckSq)
                    if isWater then
                        draggingItem.canBeBuild = false
                        return
                    end
                end
            end
        end
    end

    -- ~ 	print("dragging : " .. x .. " " .. y);
    -- ~ 	print("square is : " .. square:getX() .. " " .. square:getY());
    -- get the sprite we have to display
    if draggingItem.player == 0 and wasMouseActiveMoreRecentlyThanJoypad() then
        local mouseOverUI = isMouseOverUI();
        if Mouse:isLeftDown() then
            if not draggingItem.isLeftDown then
                draggingItem.clickedUI = mouseOverUI;
                draggingItem.isLeftDown = true;
            end
            if draggingItem.clickedUI then
                return
            end
            draggingItem:rotateMouse(x, y);
        else
            if draggingItem.isLeftDown then
                draggingItem.isLeftDown = false;
                draggingItem.build = draggingItem.canBeBuild and not mouseOverUI and not draggingItem.clickedUI;
                draggingItem.clickedUI = false;
            end
            if mouseOverUI then
                return
            end
        end
    end
    spriteName = draggingItem:getSprite();
    -- if we have the left mouse button down, we fix the item to the square we clicked
    -- so while we have the left button down, we can drag the mouse to change the direction of the item (like in the Sims..)
    if (draggingItem.isLeftDown or draggingItem.build) and draggingItem.square then
        square = draggingItem.square;
        x = square:getX();
        y = square:getY();
    else -- else, the square is the one our mouse is on
        draggingItem.square = square;
    end
    -- There may be no square if we are at the edge of the map.
    if not square then
        draggingItem.canBeBuild = false
        return
    end
    -- render our item on the ground, if it can be placed we render it with a bit of red over it
    if isRender then
        -- we first call the isValid function of our item
        draggingItem.canBeBuild = draggingItem:isValid(square, draggingItem.north)
        -- we call the render function of our item, because for stairs (for example), we drag only 1 item : the 1st part of the stairs
        -- so in the :render function is ISWoodenStair, we gonna display the 2 other part of the stairs, depending on his direction
        draggingItem:render(x, y, z, square)
    end
    -- finally build our item !
    if draggingItem.canBeBuild and draggingItem.build then
        draggingItem.build = false
        draggingItem:tryBuild(x, y, z)
    end
    if draggingItem.build and not draggingItem.dragNilAfterPlace then
        draggingItem:reinit();
    end
end

function DoTileBuildingJoyPad(draggingItem, isRender, x, y, z)
    if draggingItem.xJoypad == -1 then
        draggingItem.xJoypad = x;
        draggingItem.yJoypad = y;
        --        local buts = getButtonPrompts(playerIndex);
        --        if buts ~= nil then
        --            buts:getBestLBButtonAction(nil);
        --            buts:getBestRBButtonAction(nil);
        --        end
    end
    draggingItem.zJoypad = z;
    local square = getCell():getGridSquare(draggingItem.xJoypad, draggingItem.yJoypad, draggingItem.zJoypad);
    DoTileBuilding(draggingItem, isRender, draggingItem.xJoypad, draggingItem.yJoypad, draggingItem.zJoypad, square);
end

Events.OnDoTileBuilding2.Add(DoTileBuilding);

Events.OnDoTileBuilding3.Add(DoTileBuildingJoyPad);
