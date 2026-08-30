WAT_CopyPaste = ISCollapsableWindow:derive("WAT_CopyPaste")
WAT_CopyPaste.instance = nil

function WAT_CopyPaste:display()
    if WAT_CopyPaste.instance then
        WAT_CopyPaste.instance:close()
    end
    local scale = getTextManager():MeasureStringY(UIFont.Small, "XXX") / 12
    local width = scale * 315
    local height = scale * 185
    local x = getCore():getScreenWidth() / 2 - width / 2
    local y = getCore():getScreenHeight() / 2 - height / 2
    local o = ISCollapsableWindow:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.scale = scale
    o:initialise()
    o:addToUIManager()
    WAT_CopyPaste.instance = o
    return o
end

function WAT_CopyPaste:initialise()
    ISCollapsableWindow.initialise(self)

    self.moveWithMouse = true
    self:setResizable(false)

    self.contents = nil

    -- local x = math.floor(getPlayer():getX())
    -- local y = math.floor(getPlayer():getY())
    -- local z = math.floor(getPlayer():getZ())

    local win = GravyUI.Node(self.width, self.height, self):pad(5 * self.scale, 20 * self.scale, 5 * self.scale, 5 * self.scale)
    local header, body, footer = win:rows({20 * self.scale, 1.0, 55 * self.scale}, 5 * self.scale)
    local areaSelector, pointSelector, status = body:rows({0.5, 0.5, 12 * self.scale}, 2 * self.scale)
    local areaSelectorLabel, areaSelector = areaSelector:cols({0.24, 0.76}, 2 * self.scale)
    local pointSelectorLabel, pointSelector = pointSelector:cols({0.24, 0.76}, 2 * self.scale)
    local buttonRow1, buttonRow2, buttonRow3 = footer:grid(3, {0.24, 0.19, 0.19, 0.19, 0.19}, 2 * self.scale, 2 * self.scale)

    self.header = header:makeLabel("Tile CopyPaste", UIFont.Large, {r=1, g=1, b=1, a=1}, "center")

    self.areaSelectorLabel = areaSelectorLabel:makeLabel("Source Area:", UIFont.Small, {r=1, g=1, b=1, a=1}, "right")
    self.areaSelector = areaSelector:makeAreaPicker()
    self.areaSelector.groundHighlighter:setColor(0.5, 1.0, 0.5, 1.0)
    -- self.areaSelector:setValue({x1 = x - 5, y1 = y - 5, z1 = z, x2 = x + 5, y2 = y + 5, z2 = z})

    self.pointSelectorLabel = pointSelectorLabel:makeLabel("Paste Point:", UIFont.Small, {r=1, g=1, b=1, a=1}, "right")
    self.pointSelector = pointSelector:makePointPicker()
    self.pointSelector.groundHighlighter:setColor(0.5, 0.5, 1.0, 1.0)
    -- self.pointSelector:setValue({x = x, y = y, z = z})

    self.status = status:makeLabel("", UIFont.Small, {r=1, g=1, b=1, a=1}, "center")

    self.toggles = buttonRow1[1]:makeTickBox()
    self.toggles:addOption("Ground")
    self.toggles:addOption("Floors")
    self.toggles:addOption("Roof Hide")
    self.toggles:setSelected(1, true)
    self.toggles:setSelected(2, true)
    self.toggles.tooltip = "Ground: Include floor tiles on ground level.<br>Floors: Include floor tiles on upper levels.<br>Roof Hide: Add floor tiles to hide roofs properly."

    self.copyButton = buttonRow1[2]:makeButton("Copy", self, self.onCopy)
    self.copyButton.tooltip = "Copy enabled tiles from the copy area."

    self.deleteButton = buttonRow1[3]:makeButton("Delete", self, self.onDelete)
    self.deleteButton.tooltip = "Delete the enabled tiles copy area."

    self.clearButton = buttonRow1[4]:makeButton("Clear", self, self.onClear)
    self.clearButton.tooltip = "Delete the enabled tiles from the paste area."

    self.pasteButton = buttonRow1[5]:makeButton("Paste", self, self.onPaste)
    self.pasteButton.tooltip = "Paste the copied tiles to the paste area."

    self.resetButton = buttonRow2[2]:makeButton("Reset", self, self.onReset)
    self.resetButton.tooltip = "Reset the copy and paste area and clear the clipboard."

    self.saveButton = buttonRow2[3]:makeButton("Save", self, self.onSave)
    self.saveButton.tooltip = "Save the clipboard to a named slot.<br>These are shared to all staff!"

    self.comboLoad = buttonRow2[4]:makeComboBox(self, self.loadSave)
    self.comboLoad:addOption("")
    self.comboLoad.tooltip = "Load the clipboard from a named slot."

    self.deleteSaveButton = buttonRow2[5]:makeButton("Del Save", self, self.onDeleteSave)
    self.deleteSaveButton.tooltip = "Delete the currently selected named slot."

    self.exportButton = buttonRow3[2]:makeButton("Export", self, self.onExport)
    self.exportButton.tooltip = "Export the clipboard."

    self.importButton = buttonRow3[3]:makeButton("Import", self, self.onImport)
    self.importButton.tooltip = "Import a previous exported clipboard."

    self.fileExportButton = buttonRow3[4]:makeButton("File Export", self, self.onFileExport)
    self.fileExportButton.tooltip = "Export the clipboard to a file."

    self.fileImportButton = buttonRow3[5]:makeButton("File Import", self, self.onFileImport)
    self.fileImportButton.tooltip = "Import a previous exported clipboard from a file."

    self.clearButton:setEnabled(false)
    self.pasteButton:setEnabled(false)

    self.pasteArea = GroundHightlighter:new()
    self.pasteArea:setColor(0.5, 0.5, 1.0, 1.0)

    self.pendingAdds = nil
    self.pendingActionCooldown = 0

    self.savedData = {}
    ModData.request("WAT_CopyPaste")
end

function WAT_CopyPaste:setSavedData(data)
    self.savedData = data or ModData.getOrCreate("WAT_CopyPaste") or {}

    local keys = {}
    for key, _ in pairs(self.savedData) do
        table.insert(keys, key)
    end
    table.sort(keys)

    self.comboLoad:clear()
    self.comboLoad:addOption("")
    for _, key in ipairs(keys) do
        self.comboLoad:addOption(key)
    end
end

function WAT_CopyPaste:prerender()
    ISCollapsableWindow.prerender(self)

    if self.pendingActionCooldown <= getTimestampMs() then
        self:processNextPendingAdd()
        self.pendingActionCooldown = getTimestampMs() + 50
    end

    if self.contents then
        local point = self.pointSelector:getValue()
        local x = point.x
        local y = point.y
        local z = point.z
        local bounds = self.pasteArea.bounds
        if x ~= bounds.x1 or
           y ~= bounds.y1 or
           z ~= bounds.z1 or
           x + self.contents.width - 1 ~= bounds.x2 or
           y + self.contents.height - 1 ~= bounds.y2 or
           z + self.contents.depth - 1 ~= bounds.z2 then
            self.areaSelector:_updateGroundHighlight(true)
            self.pointSelector:_updateGroundHighlight(true)
            self.pasteArea:highlightSquare(x, y, x + self.contents.width - 1, y + self.contents.height - 1, z)
        end
    end
end

function WAT_CopyPaste:onReset()
    self.contents = nil
    self.status:setText("")
    self.clearButton:setEnabled(false)
    self.pasteButton:setEnabled(false)
    self.resetButton:setEnabled(false)
    self.resetButton.tooltipUI:setVisible(false)
    self.resetButton.tooltipUI:removeFromUIManager()
    self.areaSelector:setValue({x1 = 0, y1 = 0, z1 = 0, x2 = 0, y2 = 0, z2 = 0})
    self.pointSelector:setValue({x = 0, y = 0, z = 0})
    self.areaSelector:cleanup()
    self.pointSelector:cleanup()
    self.pasteArea:remove()
end

function WAT_CopyPaste:onSave()
    if not self.contents then
        return
    end
    WL_TextEntryPanel:show("Save CopyPaste Name", self, self.doSave)
end

function WAT_CopyPaste:doSave(name)
    if not name or name == "" then
        return
    end
    sendClientCommand(getPlayer(), "WAT", "addCopyPaste", {name = name, data = self.contents})
    self.savedData[name] = self.contents
    self.comboLoad:addOption(name)
end

function WAT_CopyPaste:onDeleteSave()
    local name = self.comboLoad:getOptionText(self.comboLoad.selected)
    if not name or name == "" then
        return
    end
    sendClientCommand(getPlayer(), "WAT", "removeCopyPaste", {name = name})
    self.savedData[name] = nil
    self:setSavedData(self.savedData)
end

function WAT_CopyPaste:loadSave()
    local name = self.comboLoad:getOptionText(self.comboLoad.selected)
    if not name or name == "" then
        return
    end
    self.contents = self.savedData[name]
    if not self.contents then
        self.status:setText("Failed to load " .. name)
        return
    end
    self.status:setText("Loaded " .. #self.contents.objects .. " objects")
    self.clearButton:setEnabled(true)
    self.pasteButton:setEnabled(true)
    self.resetButton:setEnabled(true)
end

local function exportHeader(contents)
    return string.format("%d,%d,%d", contents.width, contents.height, contents.depth)
end

local function exportLine(data)
    return string.format("%d,%d,%d,%s,%s,%s", data.x, data.y, data.z, data.spriteName, tostring(data.isFloor), tostring(data.isSupport))
end

local function importHeader(contents, line)
    local parts = line:split(",")
    if #parts ~= 3 then
        return false
    end
    contents.width = tonumber(parts[1])
    contents.height = tonumber(parts[2])
    contents.depth = tonumber(parts[3])
    contents.objects = {}
    return true
end

local function importLine(contents, line)
    local parts = line:split(",")
    if #parts ~= 6 then
        return false
    end
    local data = {
        x = tonumber(parts[1]),
        y = tonumber(parts[2]),
        z = tonumber(parts[3]),
        spriteName = parts[4],
        isFloor = parts[5] == "true",
        isSupport = parts[6] == "true",
    }
    table.insert(contents.objects, data)
    return true
end

function WAT_CopyPaste:onExport()
    if not self.contents then
        return
    end
    local lines = {}
    table.insert(lines, exportHeader(self.contents))
    for _, data in ipairs(self.contents.objects) do
        table.insert(lines, exportLine(data))
    end
    local window = ISPanel:new(self.x, self.y, 400, 400)
    window:initialise()
    local textEntry = ISTextEntryBox:new(table.concat(lines, "\n"), 0, 0, 400, 400)
    textEntry:initialise()
    textEntry:instantiate()
    textEntry:setMultipleLine(true)
    window:addChild(textEntry)
    local closeBtn = ISButton:new(380, 0, 20, 20, "X", window, function() window:removeFromUIManager() end)
    closeBtn:initialise()
    window:addChild(closeBtn)
    window:addToUIManager()
end

function WAT_CopyPaste:onImport()
    local window = ISPanel:new(self.x, self.y, 400, 400)
    window:initialise()
    local textEntry = ISTextEntryBox:new("", 0, 0, 400, 400)
    textEntry:initialise()
    textEntry:instantiate()
    textEntry:setMultipleLine(true)
    window:addChild(textEntry)
    local closeBtn = ISButton:new(380, 0, 20, 20, "X", window, function() window:removeFromUIManager() end)
    closeBtn:initialise()
    window:addChild(closeBtn)
    local submitBtn = ISButton:new(340, 380, 60, 20, "Import", window, function()
        local lines = textEntry:getText():split("\n")
        local header = table.remove(lines, 1)
        local contents = {}
        importHeader(contents, header)
        for _, line in ipairs(lines) do
            importLine(contents, line)
        end
        self.contents = contents
        self.status:setText("Imported " .. #self.contents.objects .. " objects")
        self.clearButton:setEnabled(true)
        self.pasteButton:setEnabled(true)
        self.resetButton:setEnabled(true)
        window:removeFromUIManager()
    end)
    submitBtn:initialise()
    window:addChild(submitBtn)
    window:addToUIManager()
end

function WAT_CopyPaste:onFileExport()
    if not self.contents then
        return
    end
    WL_TextEntryPanel:show("Export: Filename?", self, self.doFileExport)
end

function WAT_CopyPaste:doFileExport(filename)
    if not filename or filename == "" then
        return
    end
    -- remove special characters
    filename = filename:gsub("[^a-zA-Z0-9_\\-\\.]", "")
    local fileWriter = getFileWriter("WastelandCopyPaste/" .. filename .. ".txt", true, false)
    if not fileWriter then
        return
    end
    fileWriter:writeln(exportHeader(self.contents))
    for _, data in ipairs(self.contents.objects) do
        fileWriter:writeln(exportLine(data))
    end
    fileWriter:close()
end

function WAT_CopyPaste:onFileImport()
    WL_TextEntryPanel:show("Import: Filename?", self, self.doFileImport)
end

function WAT_CopyPaste:doFileImport(filename)
    if not filename or filename == "" then
        return
    end
    -- remove special characters
    filename = filename:gsub("[^a-zA-Z0-9_\\-\\.]", "")
    local fileReader = getFileReader("WastelandCopyPaste/" .. filename .. ".txt", false)
    local contents = {}
    local line = fileReader:readLine()
    if not importHeader(contents, line) then
        fileReader:close()
        return
    end
    line = fileReader:readLine()
    while line do
        importLine(contents, line)
        line = fileReader:readLine()
    end
    fileReader:close()
    self.contents = contents
    self.status:setText("Imported " .. #self.contents.objects .. " objects")
    self.clearButton:setEnabled(true)
    self.pasteButton:setEnabled(true)
    self.resetButton:setEnabled(true)
end

function WAT_CopyPaste:onCopy()
    local area = self.areaSelector:getValue()
    local doGround = self.toggles:isSelected(1)
    local doFloor = self.toggles:isSelected(2)
    local doSupports = self.toggles:isSelected(3)
    self.contents = {
        width = area.x2 - area.x1 + 1,
        height = area.y2 - area.y1 + 1,
        depth = area.z2 - area.z1 + 1,
        objects = {}
    }
    for z = area.z1, area.z2 do
        for y = area.y1, area.y2 do
            for x = area.x1, area.x2 do
                local square = getCell():getGridSquare(x, y, z)
                if square then
                    local objects = square:getObjects()
                    if objects:size() > 0 and not objects:get(0):isFloor() and doSupports then
                        local data = {}
                        data.x = x - area.x1
                        data.y = y - area.y1
                        data.z = z - area.z1
                        data.spriteName = "carpentry_02_57"
                        data.isFloor = true
                        data.isSupport = true
                        table.insert(self.contents.objects, data)
                    end
                    for i = 1, objects:size() do
                        local object = objects:get(i - 1)
                        if instanceof(object, "IsoObject") and not instanceof(object, "IsoMovingObject") then
                            if not object:isFloor() or ((z == 0 or doFloor) and (z > 0 or doGround)) then
                                local sprite = object:getSprite()
                                if sprite then
                                    local data = {}
                                    data.x = x - area.x1
                                    data.y = y - area.y1
                                    data.z = z - area.z1
                                    data.spriteName = object:getSprite():getName()
                                    data.isFloor = object:isFloor()
                                    data.isSupport = false
                                    if data.spriteName then
                                        table.insert(self.contents.objects, data)
                                        local children = object:getChildSprites()
                                        if children then
                                            for j = 1, children:size() do
                                                local child = children:get(j - 1)
                                                local data = {}
                                                data.x = x - area.x1
                                                data.y = y - area.y1
                                                data.z = z - area.z1
                                                data.spriteName = child:getName()
                                                data.isFloor = object:isFloor()
                                                data.isSupport = false
                                                if data.spriteName then
                                                    table.insert(self.contents.objects, data)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    self.status:setText("Copied " .. #self.contents.objects .. " objects")
    self.clearButton:setEnabled(true)
    self.pasteButton:setEnabled(true)
    self.resetButton:setEnabled(true)
end

function WAT_CopyPaste:processNextPendingAdd()
    if not self.pendingAdds then
        return
    end
    if #self.pendingAdds == 0 then
        self.pendingAdds = nil
        self.status:setText("Paste complete!")
        self.pasteArea:remove()
        return
    end
    local action = table.remove(self.pendingAdds, 1)
    if not action then
        return
    end
    self.status:setText(#self.pendingAdds .. " objects pending creation")
    local square = getCell():getGridSquare(action.x, action.y, action.z)
    if square == nil and getWorld():isValidSquare(action.x, action.y, action.z) then
        square = getCell():createNewGridSquare(action.x, action.y, action.z, true)
    end
    if not square then
        return
    end

    if action.isFloor then
        square:addFloor(action.spriteName)
        return
    end

    local tileAlreadyOnSquare = false
    local objects = square:getObjects()
    for i=0, objects:size() - 1 do
        if objects:get(i):getSprite() ~= nil and objects:get(i):getSprite():getName() == action.spriteName then
            tileAlreadyOnSquare = true
            break
        end
    end
    if not tileAlreadyOnSquare then
        local dummyItem = InventoryItemFactory.CreateItem("Base.Plank")
        local props = ISMoveableSpriteProps.new(IsoObject.new(square, action.spriteName):getSprite())
        props.rawWeight = 10
        props:placeMoveableInternal(square, dummyItem, action.spriteName)
    end
end

function WAT_CopyPaste:onPaste()
    local point = self.pointSelector:getValue()
    local x = point.x
    local y = point.y
    local z = point.z

    if not self.contents then
        return
    end

    if not self.pendingAdds then
        self.pendingAdds = {}
    end

    local doGround = self.toggles:isSelected(1)
    local doFloor = self.toggles:isSelected(2)
    local doSupports = self.toggles:isSelected(3)

    for _, data in ipairs(self.contents.objects) do
        if (doSupports or not data.isSupport) and (not data.isFloor or (data.z == 0 and doGround) or (data.z > 0 and doFloor)) then
            table.insert(self.pendingAdds, {
                x = x + data.x,
                y = y + data.y,
                z = z + data.z,
                spriteName = data.spriteName,
            })
        end
    end

    self.status:setText(#self.pendingAdds .. " objects pending creation")
end

function WAT_CopyPaste:onClear()
    local point = self.pointSelector:getValue()
    local xMin = point.x
    local yMin = point.y
    local zMin = point.z
    local xMax = point.x + self.contents.width - 1
    local yMax = point.y + self.contents.height - 1
    local zMax = point.z + self.contents.depth - 1
    local doGround = self.toggles:isSelected(1)
    local doFloor = self.toggles:isSelected(2)
    for z = zMin, zMax do
        for y = yMin, yMax do
            for x = xMin, xMax do
                local square = getCell():getGridSquare(x, y, z)
                if square then
                    local objects = square:getObjects()
                    for i=objects:size(),1,-1 do
                        local object = objects:get(i-1)
                        if instanceof(object, "IsoObject") and not instanceof(object, "IsoMovingObject") then
                            if not object:isFloor() or ((z == 0 or doFloor) and (z > 0 or doGround)) then
                                square:transmitRemoveItemFromSquare(object)
                            end
                        end
                    end
                end
            end
        end
    end
end

function WAT_CopyPaste:onDelete()
    local area = self.areaSelector:getValue()
    local doGround = self.toggles:isSelected(1)
    local doFloor = self.toggles:isSelected(2)
    for z = area.z1, area.z2 do
        for y = area.y1, area.y2 do
            for x = area.x1, area.x2 do
                local square = getCell():getGridSquare(x, y, z)
                if square then
                    local objects = square:getObjects()
                    for i=objects:size(),1,-1 do
                        local object = objects:get(i-1)
                        if instanceof(object, "IsoObject") and not instanceof(object, "IsoMovingObject") then
                            if not object:isFloor() or ((z == 0 or doFloor) and (z > 0 or doGround)) then
                                square:transmitRemoveItemFromSquare(object)
                            end
                        end
                    end
                end
            end
        end
    end
end

function WAT_CopyPaste:close()
    self.areaSelector:cleanup()
    self.pointSelector:cleanup()
    self.pasteArea:remove()
    ISCollapsableWindow.close(self)
    self:removeFromUIManager()
end

if not WAT_CopyPaste.didBindEvents then
    Events.OnReceiveGlobalModData.Add(function (key, data)
        if key == "WAT_CopyPaste" then
            if WAT_CopyPaste.instance then
                WAT_CopyPaste.instance:setSavedData(data)
            end
        end
    end)
    WAT_CopyPaste.didBindEvents = true
end