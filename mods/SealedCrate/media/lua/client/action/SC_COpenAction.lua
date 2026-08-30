QNW_SC_COpenAction = ISBaseTimedAction:derive("QNW_SC_COpenAction")

local l_util       = QNW_QNWL_AUtil

function QNW_SC_COpenAction:isValid()
    return true
end

function QNW_SC_COpenAction:update()
    self.sealedCrate:setJobDelta(self:getJobDelta())
end

function QNW_SC_COpenAction:start()
    self.sealedCrate:setJobType(getText("ContextMenu_QNW_SC_Open"))
    self.sealedCrate:setJobDelta(0.0)
end

function QNW_SC_COpenAction:stop()
    self.sealedCrate:setJobDelta(0.0)
end

function QNW_SC_COpenAction:perform()
    self.sealedCrate:setJobDelta(0.0)

    self.crate:create(self.sq:getX(), self.sq:getY(), self.sq:getZ(), self.crate.north, self.crate.sprite)
    l_util.itemRemoveFromContainer(self.sealedCrate, self.sealedCrate:getContainer())
    l_util.refreshPlayerBackpacks(self.character)
    local data = self.sealedCrate:getModData().SealedCrate
    if data then
        for _, v in pairs(data) do
            local newItem = l_util.tableToInventoryItem(v, self.character)
            l_util.itemAddFromContainer(newItem, self.crate.javaObject:getContainer())
        end
        for _ = 1, self.crateConfig.materialCount do
            self.character:getInventory():AddItem(self.crateConfig.material, 1)
        end
        l_util.refreshPlayerBackpacks(self.character)
    end

    ISBaseTimedAction.perform(self)
end

function QNW_SC_COpenAction:new(_player, _sealedCrate, _crateConfig)
    local o = {}
    setmetatable(o, self)
    self.__index              = self
    o.character               = _player
    o.sealedCrate             = _sealedCrate
    o.crateConfig             = _crateConfig
    o.stopOnWalk              = true
    o.stopOnRun               = true
    o.stopOnAim               = true
    o.maxTime                 = 120
    o.useProgressBar          = true

    o.crate                   = ISWoodenContainer:new(_crateConfig.sprite, _crateConfig.sprite)
    o.crate.player            = _player:getPlayerNum()
    o.crate.canBeAlwaysPlaced = true
    o.crate.containerType     = "crate"

    o.sq                      = l_util.getSquareByInventoryItem(_sealedCrate)
    return o
end
