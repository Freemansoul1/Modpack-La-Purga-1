-- By 🆂🅲🆁🅸🅱🅻
-- Discord: scribl

-- Я не против если вы будете исследовать мои модификации. Не копируйте модификацию!
-- I don't mind if you explore my modifications. Do not copy the modification!

local SC_GloomyPlaceObject = {}

--[[ EVENTS ]]

function SC_GloomyPlaceObject:LoadGridsquare(sq)
    --[[if sq:getModData()[self.moduleName] ~= nil then 
        local GPR_ModData = sq:getModData()[self.moduleName];
        if not self.markers[GPR_ModData.gprid] and GPR_ModData.isMarker then
            self:addMarker(GPR_ModData.gprid, sq, GPR_ModData.marker);
        end
    end]]--
    local GPR_ModData = sq:getModData()[self.moduleName];
    local gprid = sq:getX()..sq:getY()..sq:getZ();
    if self.markers[gprid] then
        getIsoMarkers():removeIsoMarker(self.markers[gprid]:getID());
        self.markers[gprid] = nil;
    end
    if GPR_ModData and GPR_ModData.isMarker then
        self:addMarker(gprid, sq, GPR_ModData.marker);
    end
end

function SC_GloomyPlaceObject:OnClientCommand(module, cmd, playerObj, args) -- Server
    if module ~= self.moduleName then return; end
    self.character = playerObj;
    if cmd == "logSuc" then
        self:Logger(string.format("teleported from %s, %s, %s to %s, %s, %s", args.x, args.y, args.z, args.toX, args.toY, args.toZ));
        return;
    end
    if cmd == "logErr" then
        self:Logger(string.format("[ERROR] at %s, %s, %s to %s, %s, %s", args.x, args.y, args.z, args.toX, args.toY, args.toZ));
        return;
    end
    if cmd == "setTeleport" then
        self:setTeleport(args.params, args.isRemove);
        return;
    end
end

function SC_GloomyPlaceObject:Logger(msg)
    writeLog("gloomyplace", "[ "..self.character:getUsername().." ] "..msg);
end

function SC_GloomyPlaceObject:onLoadModDataFromServer(sq)
    local GPR_ModData = sq:getModData()[self.moduleName];
    local gprid = sq:getX()..sq:getY()..sq:getZ();
    if self.markers[gprid] then
        getIsoMarkers():removeIsoMarker(self.markers[gprid]:getID());
        self.markers[gprid] = nil;
    end
    if GPR_ModData and GPR_ModData.isMarker then
        self:addMarker(gprid, sq, GPR_ModData.marker);
    end
    --[[if GPR_ModData then
        if not self.markers[gprid] and GPR_ModData.isMarker then
            self:addMarker(gprid, sq, GPR_ModData.marker);
        end
    else
        self.markers[gprid] = nil;
        if self.markers[gprid] then
            getIsoMarkers():removeIsoMarker(self.markers[gprid]:getID());
        end
    end]]--
end

--[[ END EVENTS ]]

function SC_GloomyPlaceObject:sendLogs(isError, coords)
    if not isClient() then return; end
    if not SandboxVars.SCGloomyPlaceReload.LoggerEnterExit then return; end
    if isError then
        sendClientCommand(getPlayer(), self.moduleName, "logErr", coords);
        return;
    end
    sendClientCommand(getPlayer(), self.moduleName, "logSuc", coords);
end

function SC_GloomyPlaceObject:setTeleport(params, isRemove)
    -- params = { x, y, z, toX, toY, toZ, anode, akey, avar, sound, marker, isAnim, isSound, isMarker, toOne, timedaction, isPayToGo, costPassage }
    if isClient() then
        sendClientCommand(getPlayer(), self.moduleName, "setTeleport", { params = params, isRemove = isRemove });
        return;
    end
    local sq = getCell():getGridSquare(params.x, params.y, params.z);
    if not sq then return; end
    if isRemove then
        sq:getModData()[self.moduleName] = nil;
        sq:transmitModdata();
        self:Logger(string.format("remove teleport %s, %s, %s", params.x, params.y, params.z));
        return;
    end
    sq:getModData()[self.moduleName] = params;
    sq:transmitModdata();
    self:Logger(string.format("create teleport %s, %s, %s", params.x, params.y, params.z));
end

function SC_GloomyPlaceObject:addMarker(gprid, sq, markerType)
    if sq == nil then return; end
    if not SandboxVars.SCGloomyPlaceReload.Enable then return; end
    self.markers[gprid] = getIsoMarkers():addIsoMarker({}, { "media/ui/markers/SC_GP_Marker"..markerType..".png" }, sq, 1, 1, 1, false, false);
    self.markers[gprid]:setDoAlpha(false);
    self.markers[gprid]:setAlphaMin(0.5);
    self.markers[gprid]:setAlpha(1.0);
end

function SC_GloomyPlaceObject:new()
    local o = {};
    o.points = {};
    o.markers =  {};    
    o.character = {};
    o.moduleName = "SCGPlaceReload";

    setmetatable(o, self)
    self.__index = self;
    self.__metatable = "SCGPlaceReload";
    return o;
end

return SC_GloomyPlaceObject;