--***********************************************************
--**                       BitBraven                       **
--***********************************************************

require "TimedActions/ISBaseTimedAction"

BB_Escape_Rope_ISTimedAction = ISBaseTimedAction:derive("BB_Escape_Rope_ISTimedAction")

function BB_Escape_Rope_ISTimedAction:isValid()
    return true
end

function BB_Escape_Rope_ISTimedAction:waitToStart()
    self.character:facePosition(self.squareX, self.squareY)
    return self.character:shouldBeTurning()
end

function BB_Escape_Rope_ISTimedAction:update()
    self.character:facePosition(self.squareX, self.squareY)
    self.character:setMetabolicTarget(Metabolics.LightWork)
end

function BB_Escape_Rope_ISTimedAction:start()
    self:setActionAnim("Loot")
    self.character:SetVariable("LootPosition", "Low")
end

function BB_Escape_Rope_ISTimedAction:stop()
    ISBaseTimedAction.stop(self)
end

function BB_Escape_Rope_ISTimedAction:perform()

    if self.actionType == "AddRope" then
        local obj = self.entity
        local index = 0

        if instanceof(obj,"IsoGridSquare") then
            buildUtil.setHaveConstruction(obj, true)
        else
            index = obj:getObjectIndex()
            buildUtil.setHaveConstruction(obj:getSquare(), true)
        end

        local emptySquare = nil
        if self.emptySquare then
            emptySquare = { x = self.emptySquare:getX(), y = self.emptySquare:getY(), z = self.emptySquare:getZ() }
        end

        local args = { playerDir = self.character:getDir(), square = { x = obj:getX(), y = obj:getY(), z = obj:getZ() }, emptySquare = emptySquare, index = index }
        sendClientCommand(self.character, 'EscapeRope', 'AddRope', args)

        local playerInv = self.character:getInventory()
        local item = playerInv:getItemFromType("Base."..BB_Escape_Rope.itemName)
        if item then playerInv:Remove(item) end
    end

    if self.actionType == "RemoveRope" then
        local obj = self.entity
        local index = 0

        local emptySquare = nil
        if self.emptySquare then
            emptySquare = { x = self.emptySquare:getX(), y = self.emptySquare:getY(), z = self.emptySquare:getZ() }
        end

        local args = { square = { x = obj:getX(), y = obj:getY(), z = obj:getZ() }, emptySquare = emptySquare, index = index, isReversed = self.isReversed }
        sendClientCommand(self.character, 'EscapeRope', 'RemoveRope', args)

        local playerInv = self.character:getInventory()
        playerInv:AddItem("Base."..BB_Escape_Rope.itemName)
    end

    if self.actionType == "ClimbRope" then
        local obj = self.square
        local index = 0

        local emptySquare = nil
        if self.emptySquare then
            emptySquare = { x = self.emptySquare:getX(), y = self.emptySquare:getY(), z = self.emptySquare:getZ() }
        end

        local args = { square = { x = obj:getX(), y = obj:getY(), z = obj:getZ() }, emptySquare = emptySquare, index = index, isReversed = self.isReversed }
        sendClientCommand(self.character, 'EscapeRope', 'RescuePlayer', args)
    end

    ISBaseTimedAction.perform(self)
end

function BB_Escape_Rope_ISTimedAction:AddRope(character, entity, squareX, squareY, emptySquare)
    local o = ISBaseTimedAction.new(self, character)
    o.actionType = "AddRope"
    o.character = character
    o.stopOnWalk = true
    o.stopOnRun = true
    o.maxTime = 20
    o.entity = entity
    o.squareX = squareX
    o.squareY = squareY
    o.emptySquare = emptySquare

    if o.character:isTimedActionInstant() then o.maxTime = 1 end
    return o
end

function BB_Escape_Rope_ISTimedAction:RemoveRope(character, entity, squareX, squareY, emptySquare, isReversed)
    local o = ISBaseTimedAction.new(self, character)
    o.actionType = "RemoveRope"
    o.character = character
    o.stopOnWalk = true
    o.stopOnRun = true
    o.maxTime = 20
    o.entity = entity
    o.squareX = squareX
    o.squareY = squareY
    o.emptySquare = emptySquare
    o.isReversed = isReversed

    if o.character:isTimedActionInstant() then o.maxTime = 1 end
    return o
end

function BB_Escape_Rope_ISTimedAction:ClimbRope(character, square, squareX, squareY, emptySquare, isReversed)
    local o = ISBaseTimedAction.new(self, character)
    o.actionType = "ClimbRope"
    o.character = character
    o.stopOnWalk = true
    o.stopOnRun = true
    o.maxTime = 20
    o.square = square
    o.squareX = squareX
    o.squareY = squareY
    o.emptySquare = emptySquare
    o.isReversed = isReversed

    if o.character:isTimedActionInstant() then o.maxTime = 1 end
    return o
end

return TimeAction