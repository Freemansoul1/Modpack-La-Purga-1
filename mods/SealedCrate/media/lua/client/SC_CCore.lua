require "Moveables/ISMoveableSpriteProps"

local util                                     = QNW_SC_AUtil
local config                                   = QNW_SC_AConfig
local l_util                                   = QNW_QNWL_AUtil

local OnFillWorldObjectContextMenuCallback     = function(_playerNum, _context, _worldObjects)
    local player = getSpecificPlayer(_playerNum)
    local crate  = l_util.tableFilterFirst(_worldObjects, util.isCrate)
    if crate then
        local crateConfig = config.crateList[crate:getSprite():getName()]
        if crateConfig then
            local sealedCrateMenu    = _context:addOption(getText("IGUI_QNW_SC_SealedCrate"))
            local sealedCrateSubMenu = ISContextMenu:getNew(_context)
            _context:addSubMenu(sealedCrateMenu, sealedCrateSubMenu)

            local playerInv = player:getInventory()
            local materials = l_util.getAllItemByType(crateConfig.material, playerInv)
            local closeMenu = sealedCrateSubMenu:addOption(getText("ContextMenu_QNW_SC_Close"), nil, function()
                if luautils.walkToContainer(crate:getContainer(), _playerNum) then
                    ISTimedActionQueue.add(QNW_SC_CCloseAction:new(player, crate, crateConfig, l_util.tableCut(materials, crateConfig.materialCount)))
                end
            end)

            if #materials < crateConfig.materialCount then
                closeMenu.notAvailable = true
                l_util.setContextMenuTooltip(closeMenu, getText(crateConfig.materialTooltip))
            end
        end
    end
end

local OnFillInventoryObjectContextMenuCallback = function(_playerNum, _context, _items)
    local player    = getSpecificPlayer(_playerNum)
    local playerInv = player:getInventory()
    local items     = ISInventoryPane.getActualItems(_items)
    local sealedCrate = l_util.tableFilterFirst(items, util.isSealedCrate)
    if sealedCrate then
        local crateConfig = l_util.tableFilterFirst(config.crateList, function(_config)
            return _config.item == sealedCrate:getFullType()
        end)
        if crateConfig then
            local sealedCrateMenu    = _context:addOption(getText("IGUI_QNW_SC_SealedCrate"))
            local sealedCrateSubMenu = ISContextMenu:getNew(_context)
            _context:addSubMenu(sealedCrateMenu, sealedCrateSubMenu)

            local action   = QNW_SC_COpenAction:new(player, sealedCrate, crateConfig)
            local openMenu = sealedCrateSubMenu:addOption(getText("ContextMenu_QNW_SC_Open"), nil, function()
                if luautils.walkToContainer(sealedCrate:getContainer(), _playerNum) then
                    ISTimedActionQueue.add(action)
                end
            end)

            local tool     = l_util.getAllItemByFunction(function(_item)
                return _item:getTags():contains("Hammer")
            end, playerInv)
            if #tool == 0 then
                tool = l_util.getAllItemByFunction(function(_item)
                    return _item:getTags():contains("Crowbar")
                end, playerInv)
            end
            if #tool == 0 then
                openMenu.notAvailable = true
                l_util.setContextMenuTooltip(openMenu, getText("Tooltip_QNW_SC_MissingHammerOrCrowbar"))
            end
            if not buildUtil.canBePlace(action.crate, action.sq) then
                openMenu.notAvailable = true
                l_util.setContextMenuTooltip(openMenu, getText("Tooltip_QNW_SC_NotOpenSpace"))
            end
        end
    end
end

if not isServer() then
    Events.OnFillWorldObjectContextMenu.Add(OnFillWorldObjectContextMenuCallback)
    Events.OnFillInventoryObjectContextMenu.Add(OnFillInventoryObjectContextMenuCallback)
end