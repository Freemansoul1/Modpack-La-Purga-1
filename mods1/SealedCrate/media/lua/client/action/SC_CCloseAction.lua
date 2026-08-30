QNW_SC_CCloseAction = ISBaseTimedAction:derive("QNW_SC_CCloseAction")

local l_util        = QNW_QNWL_AUtil

function QNW_SC_CCloseAction:isValid()
    for _, v in pairs(self.materials) do
        if not self.character:getInventory():contains(v) then
            return false
        end
    end
    return true
end

function QNW_SC_CCloseAction:update()
    for _, v in pairs(self.materials) do
        v:setJobDelta(self:getJobDelta())
    end
end

function QNW_SC_CCloseAction:start()
    for _, v in pairs(self.materials) do
        v:setJobType(getText("ContextMenu_QNW_SC_Close"))
        v:setJobDelta(0.0)
    end
end

function QNW_SC_CCloseAction:stop()
    for _, v in pairs(self.materials) do
        v:setJobDelta(0.0)
    end
end

function QNW_SC_CCloseAction:perform()
    for _, v in pairs(self.materials) do
        v:setJobDelta(0.0)
        l_util.itemRemoveFromContainer(v, v:getContainer())
    end

    local containerItems = l_util.getInventoryItemByObject(self.crate)
    local data           = {}
    local weight         = 8
    for _, v in pairs(containerItems) do
        table.insert(data, l_util.inventoryItemToTable(v))
        weight = weight + v:getActualWeight()
    end
    local newCrate                          = InventoryItemFactory.CreateItem(self.crateConfig.item)
    newCrate:getModData().SealedCrate       = data
    newCrate:getModData().SealedCrateWeight = weight
    newCrate:setActualWeight(weight)
    newCrate:setCustomWeight(true)
    self.crate:getSquare():AddWorldInventoryItem(newCrate, 0.01, 0.01, 0)
    self.crate:getSquare():transmitRemoveItemFromSquare(self.crate)
    l_util.refreshPlayerBackpacks(self.character)

    ISBaseTimedAction.perform(self)
end

function QNW_SC_CCloseAction:new(_player, _crate, _crateConfig, _materials)
    local o = {}
    setmetatable(o, self)
    self.__index     = self
    o.character      = _player
    o.crate          = _crate
    o.crateConfig    = _crateConfig
    o.materials      = _materials
    o.stopOnWalk     = true
    o.stopOnRun      = true
    o.stopOnAim      = true
    o.maxTime        = #_materials * 15
    o.useProgressBar = true
    return o
end
