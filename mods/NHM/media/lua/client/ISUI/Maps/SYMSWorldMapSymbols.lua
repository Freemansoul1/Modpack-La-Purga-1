require('ISUI/Maps/ISWorldMapSymbols')
require("ServerSyncMap")

MapSymbolsTable = {
    tableMarkers = { }
}

ServerCommandReadMap = {}

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_HANDWRITTEN = getTextManager():getFontHeight(UIFont.Handwritten)
local SYMBOL_TEXTURE_HGT = 20
iterations = 0

local function round(number, decimalPlaces)
    local multiplier = 10 ^ (decimalPlaces or 0)
    return math.floor(number * multiplier + 0.5) / multiplier
end

local function generateId(data)
    local id = ""
    if data.symbolID ~= nil then id = id .. data.symbolID end
    if data.textTranslated ~= nil then id = id .. data.textTranslated end
    if data.textUntranslated ~= nil then id = id .. data.textUntranslated end
    if data.worldX ~= nil then id = id .. data.worldX end
    if data.worldY ~= nil then id = id .. data.worldY end

    return id
end
-----


ISWorldMapSymbolTool_SYMSDisableAutoUpdate = ISWorldMapSymbolTool:derive("ISWorldMapSymbolTool_SYMSDisableAutoUpdate")

function ISWorldMapSymbolTool_SYMSDisableAutoUpdate:new(symbolsUI)
    local o = ISWorldMapSymbolTool.new(self, symbolsUI)
    return o
end

function ISWorldMapSymbolTool_SYMSDisableAutoUpdate:activate()
    local realTable = {}
    realTable["syms"] = {  }
    sendClientCommand(getPlayer(), "client", "savejson", realTable)
end

function ISWorldMapSymbolTool_SYMSDisableAutoUpdate:deactivate()
    if self.modal then
        self.modal.no:forceClick()
        self.modal = nil
    end
end

-----



ISWorldMapSymbolTool_SYMSCopyMarkings = ISWorldMapSymbolTool:derive("ISWorldMapSymbolTool_SYMSCopyMarkings")

function ISWorldMapSymbolTool_SYMSCopyMarkings:new(symbolsUI)
    local o = ISWorldMapSymbolTool.new(self, symbolsUI)
    return o
end

function ISWorldMapSymbolTool_SYMSCopyMarkings:activate()
    local allSymbols = {}

    for i = 1, self.symbolsAPI:getSymbolCount() do
        local symbol = self.symbolsAPI:getSymbolByIndex(i - 1)

        local textUntranslated, textTranslated, symbolID, symbolScale
        local isText = symbol:isText()
        if isText then
            textTranslated = symbol:getTranslatedText()
            textUntranslated = symbol:getUntranslatedText()
            symbolScale = symbol:getDisplayHeight() / (self.mapAPI:getWorldScale() * FONT_HGT_HANDWRITTEN)
        elseif symbol:isTexture() then
            symbolID = symbol:getSymbolID()
            symbolScale = symbol:getDisplayHeight() / (self.mapAPI:getWorldScale() * SYMBOL_TEXTURE_HGT)
        end

        local data = {
            isText = isText,
            worldX = symbol:getWorldX(),
            worldY = symbol:getWorldY(),
            r = symbol:getRed(),
            g = symbol:getGreen(),
            b = symbol:getBlue(),
            a = symbol:getAlpha(),
            textTranslated = textTranslated,
            textUntranslated = textUntranslated,
            symbolID = symbolID,
            scale = 0.666000027884742
        }
        allSymbols[generateId(data)] = data
    end

    theTable = {}
    for k, symbol in pairs(allSymbols) do
        tempTable = {}
        tempTable[k] = symbol
        table.insert(theTable, tempTable)
    end
    local realTable = {}
    realTable["syms"] = theTable
    sendClientCommand(getPlayer(), "client", "savejson", realTable)
    self.symbolsUI.character:playSound("MapAddNote")
end

function ISWorldMapSymbolTool_SYMSCopyMarkings:deactivate()
    if self.modal then
        self.modal.no:forceClick()
        self.modal = nil
    end
end

function ISWorldMapSymbols:getAvailableColor(r, g, b)
    local rR, rG, rB = round(r, 1), round(g, 1), round(b, 1)
    return rR, rG, rB
end


local originalCreateChildren = ISWorldMapSymbols.createChildren

function ISWorldMapSymbols:createChildren()
    originalCreateChildren(self)

    for i = 1, 21 do
        sendClientCommand(getPlayer(), "client", "loadmap", {})
    end

    local btnWid = self.width - 20 * 2
    local btnHgt = FONT_HGT_SMALL + 2 * 2

    local y = self.removeBtn:getBottom() + 20
    self.symsCopyBtn = ISButton:new(20, y, btnWid, btnHgt, getText("IGUI_SYMS_CopyElements"), self, ISWorldMapSymbols.onButtonSYMS)
    self.symsCopyBtn.internal = "SYMS_COPY"
    self.symsCopyBtn:initialise()
    self.symsCopyBtn:instantiate()
    self.symsCopyBtn.borderColor.a = 0.0
    self:addChild(self.symsCopyBtn)

    local y = self.removeBtn:getBottom() + 45
    self.disableAutoUpdate = ISButton:new(20, y, btnWid, btnHgt, getText("IGUI_SYMS_DisableAutoUpdate"), self, ISWorldMapSymbols.onButtonSYMS)
    self.disableAutoUpdate.internal = "SYMS_DISABLE"
    self.disableAutoUpdate:initialise()
    self.disableAutoUpdate:instantiate()
    self.disableAutoUpdate.borderColor.a = 0.0
    self:addChild(self.disableAutoUpdate)

    self:setHeight(self.disableAutoUpdate:getBottom() + 40)
    self:insertNewLineOfButtons(self.symsCopyBtn)
    self:insertNewLineOfButtons(self.disableAutoUpdate)

    self:checkInventorySYMS()
end

local originalPrerender = ISWorldMapSymbols.prerender

function ISWorldMapSymbols:prerender()
    originalPrerender(self)

    if self:canCopyMarkingsSYMS() ~= self.wasCanCopyMarkings or self.symbolsAPI:getSymbolCount() ~= self.prevSymbolCount then
        self.wasCanCopyMarkings = self:canCopyMarkingsSYMS()
        self.prevSymbolCount = self.symbolsAPI:getSymbolCount()
        self:checkInventorySYMS()
    end

    self.symsCopyBtn.borderColor.a = (self.currentTool == self.tools.SYMSCopyMarkings) and 1 or 0
end

function arr_len(t)
    local len = 0
    for _,_ in pairs(t) do
        len = len + 1
    end
    return len
end

function check_key(t, str)
    return (t[str] or false)
end

function iterate()
    if iterations == 100 then
        iterations = 0
        return true
    else
        iterations = iterations + 1
        return false
    end
end

local originalRender = ISWorldMapSymbols.render
function ISWorldMapSymbols:render()
    originalRender(self)
    if iterate() then
        local curretSymbols = {}
        sendClientCommand(getPlayer(), "client", "loadmap", {})

        local item = MapSymbolsTable.tableMarkers
        local lua_trash = true

        for i = 1, self.symbolsAPI:getSymbolCount() do
            local symbol = self.symbolsAPI:getSymbolByIndex(i - 1)

            local textUntranslated, textTranslated, symbolID
            if symbol:isText() then
                textTranslated = symbol:getTranslatedText()
                textUntranslated = symbol:getUntranslatedText()
            elseif symbol:isTexture() then
                symbolID = symbol:getSymbolID()
            end

            local data = {
                worldX = symbol:getWorldX(),
                worldY = symbol:getWorldY(),
                textTranslated = textTranslated,
                textUntranslated = textUntranslated,
                symbolID = symbolID
            }

            local generated_id = generateId(data)
            curretSymbols[generated_id] = data
        end

        local allSymbols = item["syms"]

        if allSymbols == nil then return end

        for k, v in ipairs(allSymbols) do
            if check_key(curretSymbols, k) == false then
                lua_trash = false
            end
        end

        if lua_trash then return end

        local added = false
        if allSymbols ~= nil then
            for i, thisSymbols in ipairs(allSymbols) do
                for k, symbol in pairs(thisSymbols) do
                    local newSymbol
                    if not curretSymbols[k] then
                        if symbol.isText then
                            if symbol.textUntranslated then
                                newSymbol = self.symbolsAPI:addUntranslatedText(symbol.textUntranslated, UIFont.Handwritten, symbol.worldX, symbol.worldY)
                            else
                                newSymbol = self.symbolsAPI:addTranslatedText(symbol.textTranslated, UIFont.Handwritten, symbol.worldX, symbol.worldY)
                            end
                            newSymbol:setAnchor(0.0, 0.0)
                        else
                            newSymbol = self.symbolsAPI:addTexture(symbol.symbolID, symbol.worldX, symbol.worldY)
                            newSymbol:setAnchor(0.5, 0.5)
                        end
                        local r, g, b = self:getAvailableColor(symbol.r, symbol.g, symbol.b)
                        newSymbol:setRGBA(r, g, b, symbol.a)
                        newSymbol:setScale(symbol.scale)
                        added = true
                    end
                end
            end
        end
    end
end

local originalInitTools = ISWorldMapSymbols.initTools
function ISWorldMapSymbols:initTools()
    originalInitTools(self)
    self.tools.SYMSCopyMarkings = ISWorldMapSymbolTool_SYMSCopyMarkings:new(self)
    self.tools.SYMSDisableAutoUpdate = ISWorldMapSymbolTool_SYMSDisableAutoUpdate:new(self)
end

function ISWorldMapSymbols:checkInventorySYMS()
    if not self.character then
        self.symsCopyBtn.enable = false
        self.disableAutoUpdate.enable = false
        return
    end

    local canCopyMarkings = self:canCopyMarkingsSYMS()
    self.symsCopyBtn.enable = canCopyMarkings and self.symbolsAPI:getSymbolCount() > 0
    self.disableAutoUpdate.enable = canCopyMarkings

    if canCopyMarkings then
        self.symsCopyBtn.tooltip = nil
        self.disableAutoUpdate.tooltip = nil
        if self.symbolsAPI:getSymbolCount() == 0 then
            self.symsCopyBtn.tooltip = getText("Tooltip_SYMS_NothingToCopy")
        end
    else
        self.symsCopyBtn.tooltip = ""
        self.disableAutoUpdate.tooltip = ""
        if not canCopyMarkings then
            self.symsCopyBtn.tooltip = self.symsCopyBtn.tooltip .. getText("Tooltip_SYMS_CantCopyMarkings")
            self.disableAutoUpdate.tooltip = self.disableAutoUpdate.tooltip .. getText("Tooltip_SYMS_CantCopyMarkings")
        end
    end


    if self.currentTool == self.tools.SYMSCopyMarkings and not canCopyMarkings then
        self:setCurrentTool(nil)
    end
end

function ISWorldMapSymbols:canCopyMarkingsSYMS()
    if not self.character then return false end
    if self.character:isAccessLevel("admin") then
        return true
    end
    return false
end

function ISWorldMapSymbols:onButtonSYMS(button)
    if button.internal == "SYMS_COPY" then
        self.selectedSymbol = nil
        self:toggleTool(self.tools.SYMSCopyMarkings)
    elseif button.internal == "SYMS_DISABLE" then
        self.selectedSymbol = nil
        self:toggleTool(self.tools.SYMSDisableAutoUpdate)
    end
end

ServerCommandReadMap.storetable = function(table)
    MapSymbolsTable.tableMarkers = table
end

function ServerCommandReadMap:onServerCommand(command, args)
    if ServerCommandReadMap[command] then
        ServerCommandReadMap[command](args)
    end
end


if isClient() then
    Events.OnServerCommand.Add(ServerCommandReadMap.onServerCommand)
end
