require "ISUI/ISEquippedItem"
require "ISUI/ISContextMenu"

function ISMoveablesIconPopup:render()
 
    local playerID = self.owner.chr:getPlayerNum()
    local mode = nil
    if getCell():getDrag(playerID) and getCell():getDrag(playerID).isMoveableCursor then
        mode = getCell():getDrag(playerID):getMoveableMode()
    end
 
    local fontHgt = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight()
    self:drawRect(0, 0, self.width, self.height + fontHgt + 2 * 2, 0.80, 0, 0, 0)
 
    local index = math.floor(self:getMouseX() / 50)
    if index > 0 or mode then
        self:drawRect(index * 50, 0, 50, self.height, 0.15, 1, 1, 1)
    end
    
    --local texts = { getText("IGUI_Exit"), getText("IGUI_Pickup"), getText("IGUI_Place"), getText("IGUI_Rotate"), getText("IGUI_Scrap") }
    local texts = { getText("IGUI_Exit"), getText("IGUI_Pickup"), getText("IGUI_Place"), getText("IGUI_Rotate") }
    if not mode then
        texts[1] = ""
    end
    local text = texts[index+1]
    self:drawText(text, 2, self.height + 2, 1.0, 0.85, 0.05, 1.0, UIFont.Small)
 
    local x = 0
    local y = 0
    local tex = self.owner.movableIcon
    self:drawTexture(tex, x, y, 1, 1, 1, 1)
 
    if mode == "pickup" then
        self:drawRectBorder(x + 50, 0, 50, self.height, 0.5, 1, 1, 1)
    end
    tex = self.owner.movableIconPickup
    self:drawTexture(tex, x + 50, y, 1, 1, 1, 1)
 
    if mode == "place" then
        self:drawRectBorder(x + 50 * 2, 0, 50, self.height, 0.5, 1, 1, 1)
    end
    tex = self.owner.movableIconPlace
    self:drawTexture(tex, x + 50 * 2, y, 1, 1, 1, 1)
 
    if mode == "rotate" then
        self:drawRectBorder(x + 50 * 3, 0, 50, self.height, 0.5, 1, 1, 1)
    end
    tex = self.owner.movableIconRotate
    self:drawTexture(tex, x + 50 * 3, y, 1, 1, 1, 1)
 
    --[[if mode == "scrap" then
        self:drawRectBorder(x + 50 * 4, 0, 50, self.height, 0.5, 1, 1, 1)
    end
    tex = self.owner.movableIconScrap
    self:drawTexture(tex, x + 50 * 4, y, 1, 1, 1, 1)--]]
end
 
function ISMoveablesIconPopup:new (x, y, width, height)
    local o = ISPanel:new(x, y, width-50, height);
    setmetatable(o, self)
    self.__index = self
    return o
end
 
local _addOption = ISContextMenu.addOption;
function ISContextMenu:addOption(name, target, onSelect, param1, param2, param3, param4, param5, param6, param7, param8, param9, param10)
    if name == getText("ContextMenu_Dismantle") or name == getText("ContextMenu_Disassemble") then
        local arr = {};
        return arr;
    end  
    if (name == getText("ContextMenu_Build") or name == getText("ContextMenu_MetalWelding")) and not ISBuildMenu.cheat then
        local player = getPlayer();
        if player then
            local x = player:getX();
            local y = player:getY();
            if ((x < 9305 and x > 7550) and (y < 7500 and y > 5000)) -- Хоуптаун запрет строить
            or ((x < 11640 and x > 11200) and (y < 8000 and y > 7150)) -- госпиталь и оазис
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
            then
                local arr = {};
                return arr;
            end
        end
    end
    return _addOption(self, name, target, onSelect, param1, param2, param3, param4, param5, param6, param7, param8, param9, param10);
end