
require "ISUI/AdminPanel/ISItemsListTable"

if ISItemsListTable.isModdedIconPatched then return end

local lcl = {}
lcl.debug = true
lcl.logdebug = false
if lcl.debug then
    local itemClass = Item.class
    if not __classmetatables[Item.class] then
        if lcl.logdebug then
            print('Someone (a mod most likely) is messing with lua representation of java class Item '..tab2str(Item))
        else
            print('Someone (a mod most likely) is messing with lua representation of java class Item '..tostring(Item))
        end
        return
    end
end

lcl.item_base                = __classmetatables[Item.class].__index
lcl.item_getIcon             = lcl.item_base.getIcon
lcl.item_getIconsForTexture  = lcl.item_base.getIconsForTexture
lcl.item_getNormalTexture    = lcl.item_base.getNormalTexture
lcl.item_getCategory         = lcl.item_base.getTypeString

lcl.iconSize = getTextManager():getFontHeight(UIFont.Small)


local vanilla_ISItemsListTable_drawDatas = ISItemsListTable.drawDatas
function ISItemsListTable:drawDatas(y, item, alt)
    local returnValue = vanilla_ISItemsListTable_drawDatas(self,y,item,alt)

------- hidden
    if y + self:getYScroll() + self.itemheight < 0 or y + self:getYScroll() >= self.height then
        return returnValue
    end
------- vanilla did the job ?
    local icon = nil
    local iconsForTestures = lcl.item_getIconsForTexture(item.item)
    if iconsForTestures and not iconsForTestures:isEmpty() then
        icon = iconsForTestures:get(0)
    else
        icon = lcl.item_getIcon(item.item)
    end
    local vanillaFoundTexture = false
    if icon then
        local texture = getTexture("Item_" .. icon)
        if texture then
            vanillaFoundTexture = true
        end
    end
-------    
    if not vanillaFoundTexture and lcl.item_getCategory(item.item) ~= 'Moveable' then
        local texture = lcl.item_getNormalTexture(item.item)--thx to Notloc
        if texture then
            local iconX = 4
            local xoffset = 10;
            self:drawTextureScaledAspect2(texture, self.columns[2].size + iconX, y + (self.itemheight - lcl.iconSize) / 2, lcl.iconSize, lcl.iconSize,  1, 1, 1, 1);
        end
    end
    return returnValue
end
ISItemsListTable.isModdedIconPatched = true
