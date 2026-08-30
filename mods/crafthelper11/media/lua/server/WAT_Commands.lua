local function WAT_moveHordeToPosition(x, y, z, d)
    local sx = math.floor(x) - d
    local sy = math.floor(y) - d
    local ex = sx + d*2
    local ey = sy + d*2
    for cx = sx,ex do for cy = sy,ey do for cz = 0,7 do
        local square = getCell():getGridSquare(cx, cy, cz)
        if square then
            local movingEntities = square:getMovingObjects()
            for i=0,movingEntities:size()-1 do
                local movingEntity = movingEntities:get(i)
                if instanceof(movingEntity, "IsoZombie") then
                    movingEntity:pathToLocationF(x, y, z)
                end
            end
        end
    end end end
end

local BasementData = {}
local CopyPasteData = {}
local function WAT_FinishBasement(args)
    BasementData[args.key] = args
    ModData.add("WAT_Basements", BasementData)
    ModData.transmit("WAT_Basements")
end
local function WAT_RemoveBasement(args)
    BasementData[args.key] = nil
    ModData.add("WAT_Basements", BasementData)
    ModData.transmit("WAT_Basements")
end
local function WAT_AddCopyPaste(args)
    CopyPasteData[args.name] = args.data
    ModData.add("WAT_CopyPaste", CopyPasteData)
end
local function WAT_RemoveCopyPaste(args)
    CopyPasteData[args.name] = nil
    ModData.add("WAT_CopyPaste", CopyPasteData)
end

Events.OnClientCommand.Add(function (module, command, player, args)
    if module ~= "WAT" then return end
    if command == "reboot" then
        PzWebStats.RequestReboot("", "medium")
    end
    if command == "simpleRepair" then
        WAT_simpleRepair(args.vehicle)
    end
    if command == "moveHordeToPosition" then
        WAT_moveHordeToPosition(args.x, args.y, args.z, args.d)
    end
    if command == "finishBasement" then
        WAT_FinishBasement(args)
    end
    if command == "removeBasement" then
        WAT_RemoveBasement(args)
    end
    if command == "addCopyPaste" then
        WAT_AddCopyPaste(args)
    end
    if command == "removeCopyPaste" then
        WAT_RemoveCopyPaste(args)
    end
end)

Events.OnInitGlobalModData.Add(function()
    BasementData = ModData.getOrCreate("WAT_Basements") or {}
    CopyPasteData = ModData.getOrCreate("WAT_CopyPaste") or {}
end)