if not ISPlace3DItemCursor then ISPlace3DItemCursor = {} end;

local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)

-- Overrides

--- Overrides ISPlace3DItemCursor:Create to make the Z Offset stick for placing
---@param self any
---@param x any
---@param y any
---@param z any
---@param north any
---@param sprite any
ISPlace3DItemCursor.create = function(self, x, y, z, north, sprite)
    local drop = self.itemSq == nil; -- nil when the item is in a vehicle
    if self.itemSq and luautils.walkAdj(self.chr, self.itemSq, true) then
        drop = true;
    end
    if not drop then return; end
    for i,v in ipairs(self.items) do
--        if not v:getWorldItem() or not AdjacentFreeTileFinder.isTileOrAdjacent(self.selectedSqDrop, v:getWorldItem():getSquare()) then
            ISWorldObjectContextMenu.transferIfNeeded(self.chr, v)
--        end
    end
    if self.chr:getJoypadBind() == -1 then
        self.placeAll = isShiftKeyDown()
    end
    if self.placeAll then
        if luautils.walkAdjAltTest(self.chr, self.selectedSqDrop, self.itemSq, true) then
            for i,v in ipairs(self.items) do
                if self.chr:isEquipped(v) then
                    ISTimedActionQueue.add(ISUnequipAction:new(self.chr, v, 1));
                end
                ISTimedActionQueue.add(ISDropWorldItemAction:new(self.chr, v, self.selectedSqDrop,  self.render3DItemXOffset,
                                                                              self.render3DItemYOffset, self.render3DItemZOffset + self.render3DItemZOffsetAdditional, 
                                                                              self.render3DItemRot, #self.items > 1));
            end
        end
    else
        local item = table.remove(self.items, 1)
        if luautils.walkAdjAltTest(self.chr, self.selectedSqDrop, self.itemSq, true) then
            if self.chr:isEquipped(item) then
                ISTimedActionQueue.add(ISUnequipAction:new(self.chr, item, 1));
            end
            ISTimedActionQueue.add(ISDropWorldItemAction:new(self.chr, item, self.selectedSqDrop, self.render3DItemXOffset,
                                                                             self.render3DItemYOffset, self.render3DItemZOffset + self.render3DItemZOffsetAdditional, 
                                                                             self.render3DItemRot, false));
        end
        if #self.items > 0 then
            getCell():setDrag(self, self.chr:getPlayerNum())
        end
    end
    self.keepOnSquare = false

    print("Placed item @ ZOffset: " .. self.render3DItemZOffset + self.render3DItemZOffsetAdditional);
end

--- Override ISPlace3DItemCursor:render to add key handler for Raise/Lower/Reset of placed object
---@param x any
---@param y any
---@param z any
---@param square any World Tile being considered for placing on
ISPlace3DItemCursor.render = function(self, x, y, z, square)
    
    if not self.RENDER_SPRITE_FLOOR then
        self.RENDER_SPRITE_FLOOR = IsoSprite.new()
        self.RENDER_SPRITE_FLOOR:LoadFramesNoDirPageSimple('media/ui/FloorTileCursor.png')
    end
    if not square or not self:isValid(square) then
        self.RENDER_SPRITE_FLOOR:RenderGhostTileColor(x, y, z, 1.0, 0.0, 0.0, 0.2)
        self.chr:setIgnoreMovement(false) -- for joypad Y button
        return
    end
    self.RENDER_SPRITE_FLOOR:RenderGhostTileColor(x, y, z, 1.0, 1.0, 1.0, 0.2)

    self:checkRotateKey()
    self:checkSelectSurfaceKey()
    self:checkRotateJoypad()
    self:checkPositionJoypad()

    if self.surfaceKeyTimer then
        self.surfaceKeyTimer = self.surfaceKeyTimer - 1;
        if self.surfaceKeyTimer == 0 then
            self.surfaceKeyTimer = nil;
        end
    end

    local worldX = x + 0.5
    local worldY = y + 0.5
    if self.chr:getPlayerNum() == 0 and (self.chr:getJoypadBind() == -1 or wasMouseActiveMoreRecentlyThanJoypad()) then
        worldX = screenToIsoX(self.player, getMouseX(), getMouseY(), math.floor(self.chr:getZ()))
        worldY = screenToIsoY(self.player, getMouseX(), getMouseY(), math.floor(self.chr:getZ()))
        if self.isLeftDown then
            if not self.keepOnSquare then
                self.keepOnSquare = true
                self.keepOnSquareX = math.floor(worldX)
                self.keepOnSquareY = math.floor(worldY)
            end
        end
        if self.keepOnSquare then
            worldX = PZMath.clampFloat(worldX, self.keepOnSquareX + 0.05, self.keepOnSquareX + 0.95)
            worldY = PZMath.clampFloat(worldY, self.keepOnSquareY + 0.05, self.keepOnSquareY + 0.95)
        end
    end
    if self.chr:getJoypadBind() ~= -1 and not (self.chr:getPlayerNum() == 0 and wasMouseActiveMoreRecentlyThanJoypad()) then
        worldX = x + self.joypadPositionX
        worldY = y + self.joypadPositionY
    end
    local sq = getSquare(worldX, worldY, self.chr:getZ());
    if not sq then
        return;
    end
    self.render3DItemXOffset = worldX - sq:getX();
    self.render3DItemYOffset = worldY - sq:getY();
    self.render3DItemZOffset = self:getSurface(sq);
    if square:HasStairs() then
        self.render3DItemZOffset = square:getApparentZ(self.render3DItemXOffset, self.render3DItemYOffset)
    end

    self:checkHeightKey();

    self.selectedSqDrop = sq;
    if self.placeAll then
        for i,v in ipairs(self.items) do
            -- ensure you're not too far
            local sq = nil;
            if v:getWorldItem() then
                sq = v:getWorldItem():getSquare();
            end
            local container = item:getOutermostContainer()
            if container then
                if container:getParent() then
                    sq = container:getParent():getSquare();
                end
                if container:getContainingItem() and container:getContainingItem():getWorldItem() then
                    sq = container:getContainingItem():getWorldItem():getSquare()
                end
            end
            self.itemSq = sq;
            if container and container:getVehiclePart() then
                self.itemSq = nil
            end

            Render3DItem(v, sq, worldX, worldY, self.selectedSqDrop:getZ() + self.render3DItemZOffset + self.render3DItemZOffsetAdditional, self:clamp(self.render3DItemRot));
        end
    else
        local item = self.items[1]
        local sq = nil;
        if item:getWorldItem() then
            sq = item:getWorldItem():getSquare();
        end
        local container = item:getOutermostContainer()
        if container then
            if container:getParent() then
                sq = container:getParent():getSquare();
            end
            if container:getContainingItem() and container:getContainingItem():getWorldItem() then
                sq = container:getContainingItem():getWorldItem():getSquare()
            end
        end
        self.itemSq = sq;
        if container and container:getVehiclePart() then
            self.itemSq = nil
        end

        Render3DItem(item, sq, worldX, worldY, self.selectedSqDrop:getZ() + self.render3DItemZOffset + self.render3DItemZOffsetAdditional, self:clamp(self.render3DItemRot));
    end
end

local ISPlace3DItemCursor_drawPrompt_Base = ISPlace3DItemCursor.drawPrompt;

--- Override ISPlace3DItemCursor:drawPrompt to add 'Better Placing' prompts
---@param playerNum any
---@param ui any
ISPlace3DItemCursor.drawPrompt = function(self, playerNum, ui)
    if playerNum ~= 0 then return end
    if JoypadState.players[playerNum+1] then return end

    local changeHeightKeyStr = getKeyName(getCore():getKey("BP Adjust Height"));
    local resetHeightKeyStr = getKeyName(getCore():getKey("BP Reset Height"));

    local screenX = getPlayerScreenLeft(playerNum);
    local screenW = getPlayerScreenWidth(playerNum);
    local screenH = getPlayerScreenHeight(playerNum);


    -- Move the text prompt up if the hotbar is visible to this player
    -- Borrowed from the original and recalculated
    local y = screenH - (FONT_HGT_MEDIUM * 4)
    local textW = getTextManager():MeasureStringX(UIFont.Medium, getText("IGUI_Place3DItem_ChangeHeight"))
    local hotBar = getPlayerHotbar(playerNum)
    if hotBar and hotBar:isReallyVisible() and (screenX + screenW - 30 - textW < hotBar:getRight()) then
        y = hotBar:getY() - FONT_HGT_MEDIUM * 3
    end

    ui:drawTextRight(getText("IGUI_Place3DItem_ChangeHeight", changeHeightKeyStr, getKeyName(42), resetHeightKeyStr), 
                     screenX + screenW - 30, y - 25, 1, 1, 1, 1, UIFont.NewMedium);

    ISPlace3DItemCursor_drawPrompt_Base(self, playerNum, ui);
end

--- func desc
---@param : any
---@return : number
function ISPlace3DItemCursor:heightDelta()
    return 0.75 * getGameTime():getMultiplier() / 1.6;
end

--- Handle checking for pressing the keybind for changing height
---@param character Character
function ISPlace3DItemCursor:checkHeightKey()
    if self.chr:getPlayerNum() ~= 0 then return end
    if self.chr:getJoypadBind() ~= -1 then return end

    local isPressed = isKeyDown(getCore():getKey("BP Adjust Height"));
    local isReversed = isShiftKeyDown();
    local isReset = isKeyDown(getCore():getKey("BP Reset Height"));
    self:handleHeight(isPressed, isReversed, isReset);
end

--- Clamp to -/+ 1
---@param height number
function ISPlace3DItemCursor:clampHeight(height) 
    if height > 1 then
        height = 1;
    elseif height < -1 then
        height = -1;
    end
    return height;
end

--- Handle the height change key with modifier
---@param base ISPlace3DItemCursor
---@param isPressed any
---@param isReverse any
function ISPlace3DItemCursor:handleHeight(isPressed, isReverse, isReset)
    self.heightReverse = isReverse;

    if isReset or self.render3DItemZOffsetAdditional == nil then
        self.render3DItemZOffsetAdditional = 0;
    end

    if isPressed then
        if not self.heightChangePressed then
            self.heightChangePressed = true;
            self.heightChangeStart = getTimestampMs();
            return;
        elseif (getTimestampMs() - self.heightChangeStart) > 250 then
            self.changingHeight = true;
        else 
            return;
        end

        local height = self.render3DItemZOffsetAdditional;
        if isReverse then
            height = height - 0.01 * self:heightDelta();
        else
            height = height + 0.01 * self:heightDelta();
        end

        -- TODO: Clamping
        self.render3DItemZOffsetAdditional = self:clampHeight(height);
    else
        self.changingHeight = false;
    end
end