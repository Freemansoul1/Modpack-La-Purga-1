--- @class WL_ClientServerBase
--- @field publicData table
--- @field privateData table
--- @field needsPublicData boolean
--- @field needsPrivateData boolean
--- @field systemName string
WL_ClientServerBase = {}

--- @type WL_ClientServerBase[]
WL_ClientServerBase.registeredSystems = {}

function WL_ClientServerBase:new(systemName)
    local o = WLBaseObject.new(self)
    o.systemName = systemName
    o.needsPrivateData = false
    o.needsPublicData = false
    o.privateData = {}
    o.publicData = {}
    o.lastPublicData = {}
    o.enablePartialTransmit = false
    WL_ClientServerBase.registeredSystems[systemName] = o
    return o
end

-- Overridable callbacks
function WL_ClientServerBase:onPublicDataUpdated() end
function WL_ClientServerBase:onModDataInit() end

function WL_ClientServerBase:sendToServer(player, command, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
    if isClient() then
        sendClientCommand(player, self.systemName, command, {arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8})
    else
        self:receiveFromClient(player, command, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
    end
end

function WL_ClientServerBase:sendToClient(player, command, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
    if isServer() then
        sendServerCommand(player, self.systemName, command, {arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8})
    else
        self:receiveFromServer(player, command, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
    end
end

function WL_ClientServerBase:sendToAllClients(command, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
    if isServer() then
        sendServerCommand(self.systemName, command, {arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8})
    else
        self:receiveFromServer(getPlayer(), command, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
    end
end

function WL_ClientServerBase:receiveFromClient(player, command, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
    if self[command] then
        self[command](self, player, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
    else
        print("Unknown command: " .. command) -- Todo better logging
    end
end

function WL_ClientServerBase:receiveFromServer(player, command, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
    if self[command] then
        self[command](self, player, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
    else
        print("Unknown command: " .. command) -- Todo better logging
    end
end

function WL_ClientServerBase:savePrivateData()
    if isClient() then
        print("Only the server can save private data") -- Todo better logging
    end

    ModData.add(self.systemName .. ":private", self.privateData)
end

-- Function to recursively duplicate a table
local function duplicateTable(original, seenTables)
    if type(original) ~= "table" then
        return original
    end
    seenTables = seenTables or {}
    if seenTables[original] then
        return seenTables[original]
    end

    local currentCopy = {}
    seenTables[original] = currentCopy
    for key, value in pairs(original) do
        if type(value) == "table" then
            currentCopy[key] = duplicateTable(value, seenTables)
        else
            currentCopy[key] = value
        end
    end

    return currentCopy
end

local function getDiff(newData, oldData)
    if type(newData) ~= "table" or type(oldData) ~= "table" then
        return newData
    end

    local diff = {}
    for key, value in pairs(newData) do
        if oldData[key] == nil then
            diff[key] = {1, value}
        elseif oldData[key] ~= value then
            if type(value) == "table" and type(oldData[key]) == "table" then
                diff[key] = {2, getDiff(value, oldData[key])}
            else
                diff[key] = {1, value}
            end
        end
    end
    for key, _ in pairs(oldData) do
        if newData[key] == nil then
            diff[key] = {3}
        end
    end
    return diff
end

--- Function to apply a set of differences to a data table
local function applyDiff(data, diff)
    for key, change in pairs(diff) do
        if change[1] == 1 then
            data[key] = change[2]
        elseif change[1] == 2 then
            if type(data[key]) ~= "table" then
                data[key] = {}
            end
            data[key] = applyDiff(data[key], change[2])
        elseif change[1] == 3 then
            data[key] = nil
        end
    end
end

function WL_ClientServerBase:savePublicData(transmit)
    if isClient() then
        print("Only the server can save public data") -- Todo better logging
    end

    ModData.add(self.systemName .. ":public", self.publicData)
    if transmit == nil or transmit == true then
        if isServer() then
            if not self.enablePartialTransmit then
                ModData.transmit(self.systemName .. ":public", self.publicData)
            else
                local diff = getDiff(self.publicData, self.lastPublicData)
                self:sendToAllClients("receivePublicDataDiff", diff)
            end
            self.lastPublicData = duplicateTable(self.publicData)
        else
            self:onPublicDataUpdated()
        end
    end
end

function WL_ClientServerBase:receivePublicDataDiff(player, diff)
    if isServer() then
        print("Only the client can receive client data") -- Todo better logging
    else
        applyDiff(self.publicData, diff)
        self:onPublicDataUpdated()
    end
end

function WL_ClientServerBase:receivePublicData(data)
    if isServer() then
        print("Only the client can receive client data") -- Todo better logging
    else
        self.publicData = data
        self:onPublicDataUpdated()
    end
end

function WL_ClientServerBase:modDataInit()
    if isClient() then
        if self.needsPublicData then
            ModData.request(self.systemName .. ":public")
        end
    else
        if self.needsPrivateData then
            self.privateData = ModData.getOrCreate(self.systemName .. ":private")
            if self.privateData == nil then
                self.privateData = self.defaultPrivateData or {}
            end
        end
        if self.needsPublicData then
            self.publicData = ModData.getOrCreate(self.systemName .. ":public")
            if self.publicData == nil then
                self.publicData = self.defaultPublicData or {}
            end
        end
        self:onModDataInit()
    end
end

local function showMessagePopup(message)
    local player = getPlayer()
    local w = 300
    local h = 100
    local x = getPlayerScreenLeft(player) + getPlayerScreenWidth(player) / 2 - w / 2
    local y = getPlayerScreenTop(player) + getPlayerScreenHeight(player) / 2 - h / 2
    local popup = ISModalDialog:new(x, y, w, h, message, false)
    popup:initialise()
    popup:addToUIManager()
end

function WL_ClientServerBase:writeLog(message)
    writeLog(self.systemName, message)
end

function WL_ClientServerBase:logInfo(message)
    self:writeLog("[INFO]: " .. tostring(message))
end

function WL_ClientServerBase:logError(message)
    self:writeLog("[ERROR]: " .. tostring(message))
end

function WL_ClientServerBase:showPlayerError(player, message)
    if isServer() then
        self:sendToClient(player, "logErrorPlayer", message)
    else
        showMessagePopup(message)
    end
end

Events.OnReceiveGlobalModData.Add(function (key, data)
    for _, system in pairs(WL_ClientServerBase.registeredSystems) do
        if key == system.systemName .. ":public" then
            system:receivePublicData(data)
        end
    end
end)

Events.OnInitGlobalModData.Add(function()
    for _, system in pairs(WL_ClientServerBase.registeredSystems) do
        system:modDataInit()
    end
end)

Events.OnClientCommand.Add(function(systemName, command, player, args)
    if WL_ClientServerBase.registeredSystems[systemName] then
        if args and #args then
            WL_ClientServerBase.registeredSystems[systemName]:receiveFromClient(player, command, unpack(args))
        else
            WL_ClientServerBase.registeredSystems[systemName]:receiveFromClient(player, command)
        end
    end
end)

Events.OnServerCommand.Add(function(systemName, command, args)
    local player = getPlayer()
    if WL_ClientServerBase.registeredSystems[systemName] then
        if args and #args then
            WL_ClientServerBase.registeredSystems[systemName]:receiveFromServer(player, command, unpack(args))
        else
            WL_ClientServerBase.registeredSystems[systemName]:receiveFromServer(player, command)
        end
    end
end)