require "QNWL_AUtil"
require "SC_AConfig"

QNW_SC_AUtil = QNW_SC_AUtil or {}

local l_util = QNW_QNWL_AUtil
local config = QNW_SC_AConfig

function QNW_SC_AUtil.isCrate(_isoThumpable)
    if instanceof(_isoThumpable, "IsoThumpable") then
        return l_util.tableContainsKey(config.crateList, _isoThumpable:getSprite():getName())
    end
    return false
end

function QNW_SC_AUtil.isSealedCrate(_item)
    if instanceof(_item, "InventoryItem") then
        return l_util.tableContains(config.crateList, _item:getFullType(), function(_v, _value)
            return _v.item == _value
        end)
    end
    return false
end