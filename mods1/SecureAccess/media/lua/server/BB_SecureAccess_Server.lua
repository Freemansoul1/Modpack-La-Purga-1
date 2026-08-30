-- ************************************************************************
-- **        ██████  ██████   █████  ██    ██ ███████ ███    ██          **
-- **        ██   ██ ██   ██ ██   ██ ██    ██ ██      ████   ██          **
-- **        ██████  ██████  ███████ ██    ██ █████   ██ ██  ██          **
-- **        ██   ██ ██   ██ ██   ██  ██  ██  ██      ██  ██ ██          **
-- **        ██████  ██   ██ ██   ██   ████   ███████ ██   ████          **
-- ************************************************************************
-- ** All rights reserved. This content is protected by © Copyright law. **
-- ************************************************************************

local doorMapping = {
    -- Doors (Closed)
    SWCB = "Minou_security_doors_01_2",
    SNCB = "Minou_security_doors_01_3",
    OWCB = "Minou_security_doors_01_6",
    ONCB = "Minou_security_doors_01_7",
    SWCC = "Minou_security_doors_01_10",
    SNCC = "Minou_security_doors_01_11",
    OWCC = "Minou_security_doors_01_14",
    ONCC = "Minou_security_doors_01_15",
    SWCG = "Minou_security_doors_01_18",
    SNCG = "Minou_security_doors_01_19",
    OWCG = "Minou_security_doors_01_22",
    ONCG = "Minou_security_doors_01_23",
    SWCO = "Minou_security_doors_01_26",
    SNCO = "Minou_security_doors_01_27",
    OWCO = "Minou_security_doors_01_30",
    ONCO = "Minou_security_doors_01_31",
    SWCP = "Minou_security_doors_01_34",
    SNCP = "Minou_security_doors_01_35",
    OWCP = "Minou_security_doors_01_38",
    ONCP = "Minou_security_doors_01_39",
    SWCR = "Minou_security_doors_01_42",
    SNCR = "Minou_security_doors_01_43",
    OWCR = "Minou_security_doors_01_46",
    ONCR = "Minou_security_doors_01_47",
    SWCW = "Minou_security_doors_01_50",
    SNCW = "Minou_security_doors_01_51",
    OWCW = "Minou_security_doors_01_54",
    ONCW = "Minou_security_doors_01_55",
    SWCY = "Minou_security_doors_01_58",
    SNCY = "Minou_security_doors_01_59",
    OWCY = "Minou_security_doors_01_62",
    ONCY = "Minou_security_doors_01_63",

    -- Garages (Closed)
    GWCLB = "Minou_security_garage_01_8",
    GWCMB = "Minou_security_garage_01_9",
    GWCRB = "Minou_security_garage_01_10",
    GNCLB = "Minou_security_garage_01_11",
    GNCMB = "Minou_security_garage_01_12",
    GNCRB = "Minou_security_garage_01_13",
    GWCLC = "Minou_security_garage_01_24",
    GWCMC = "Minou_security_garage_01_25",
    GWCRC = "Minou_security_garage_01_26",
    GNCLC = "Minou_security_garage_01_27",
    GNCMC = "Minou_security_garage_01_28",
    GNCRC = "Minou_security_garage_01_29",
    GWCLG = "Minou_security_garage_01_40",
    GWCMG = "Minou_security_garage_01_41",
    GWCRG = "Minou_security_garage_01_42",
    GNCLG = "Minou_security_garage_01_43",
    GNCMG = "Minou_security_garage_01_44",
    GNCRG = "Minou_security_garage_01_45",
    GWCLO = "Minou_security_garage_01_56",
    GWCMO = "Minou_security_garage_01_57",
    GWCRO = "Minou_security_garage_01_58",
    GNCLO = "Minou_security_garage_01_59",
    GNCMO = "Minou_security_garage_01_60",
    GNCRO = "Minou_security_garage_01_61",
    GWCLP = "Minou_security_garage_02_8",
    GWCMP = "Minou_security_garage_02_9",
    GWCRP = "Minou_security_garage_02_10",
    GNCLP = "Minou_security_garage_02_11",
    GNCMP = "Minou_security_garage_02_12",
    GNCRP = "Minou_security_garage_02_13",
    GWCLR = "Minou_security_garage_02_24",
    GWCMR = "Minou_security_garage_02_25",
    GWCRR = "Minou_security_garage_02_26",
    GNCLR = "Minou_security_garage_02_27",
    GNCMR = "Minou_security_garage_02_28",
    GNCRR = "Minou_security_garage_02_29",
    GWCLW = "Minou_security_garage_02_40",
    GWCMW = "Minou_security_garage_02_41",
    GWCRW = "Minou_security_garage_02_42",
    GNCLW = "Minou_security_garage_02_43",
    GNCMW = "Minou_security_garage_02_44",
    GNCRW = "Minou_security_garage_02_45",
    GWCLY = "Minou_security_garage_02_56",
    GWCMY = "Minou_security_garage_02_57",
    GWCRY = "Minou_security_garage_02_58",
    GNCLY = "Minou_security_garage_02_59",
    GNCMY = "Minou_security_garage_02_60",
    GNCRY = "Minou_security_garage_02_61",

    -- Doors (Open)
    SWOB = "Minou_security_doors_01_0",
    SNOB = "Minou_security_doors_01_1",
    OWOB = "Minou_security_doors_01_4",
    ONOB = "Minou_security_doors_01_5",
    SWOC = "Minou_security_doors_01_8",
    SNOC = "Minou_security_doors_01_9",
    OWOC = "Minou_security_doors_01_12",
    ONOC = "Minou_security_doors_01_13",
    SWOG = "Minou_security_doors_01_16",
    SNOG = "Minou_security_doors_01_17",
    OWOG = "Minou_security_doors_01_20",
    ONOG = "Minou_security_doors_01_21",
    SWOO = "Minou_security_doors_01_24",
    SNOO = "Minou_security_doors_01_25",
    OWOO = "Minou_security_doors_01_28",
    ONOO = "Minou_security_doors_01_29",
    SWOP = "Minou_security_doors_01_32",
    SNOP = "Minou_security_doors_01_33",
    OWOP = "Minou_security_doors_01_36",
    ONOP = "Minou_security_doors_01_37",
    SWOR = "Minou_security_doors_01_40",
    SNOR = "Minou_security_doors_01_41",
    OWOR = "Minou_security_doors_01_44",
    ONOR = "Minou_security_doors_01_45",
    SWOW = "Minou_security_doors_01_48",
    SNOW = "Minou_security_doors_01_49",
    OWOW = "Minou_security_doors_01_52",
    ONOW = "Minou_security_doors_01_53",
    SWOY = "Minou_security_doors_01_56",
    SNOY = "Minou_security_doors_01_57",
    OWOY = "Minou_security_doors_01_60",
    ONOY = "Minou_security_doors_01_61",

    -- Garages (Open)
    GWOLB = "Minou_security_garage_01_0",
    GWOMB = "Minou_security_garage_01_1",
    GWORB = "Minou_security_garage_01_2",
    GNOLB = "Minou_security_garage_01_3",
    GNOMB = "Minou_security_garage_01_4",
    GNORB = "Minou_security_garage_01_5",
    GWOLC = "Minou_security_garage_01_16",
    GWOMC = "Minou_security_garage_01_17",
    GWORC = "Minou_security_garage_01_18",
    GNOLC = "Minou_security_garage_01_19",
    GNOMC = "Minou_security_garage_01_20",
    GNORC = "Minou_security_garage_01_21",
    GWOLG = "Minou_security_garage_01_32",
    GWOMG = "Minou_security_garage_01_33",
    GWORG = "Minou_security_garage_01_34",
    GNOLG = "Minou_security_garage_01_35",
    GNOMG = "Minou_security_garage_01_36",
    GNORG = "Minou_security_garage_01_37",
    GWOLO = "Minou_security_garage_01_48",
    GWOMO = "Minou_security_garage_01_49",
    GWORO = "Minou_security_garage_01_50",
    GNOLO = "Minou_security_garage_01_51",
    GNOMO = "Minou_security_garage_01_52",
    GNORO = "Minou_security_garage_01_53",
    GWOLP = "Minou_security_garage_02_0",
    GWOMP = "Minou_security_garage_02_1",
    GWORP = "Minou_security_garage_02_2",
    GNOLP = "Minou_security_garage_02_3",
    GNOMP = "Minou_security_garage_02_4",
    GNORP = "Minou_security_garage_02_5",
    GWOLR = "Minou_security_garage_02_16",
    GWOMR = "Minou_security_garage_02_17",
    GWORR = "Minou_security_garage_02_18",
    GNOLR = "Minou_security_garage_02_19",
    GNOMR = "Minou_security_garage_02_20",
    GNORR = "Minou_security_garage_02_21",
    GWOLW = "Minou_security_garage_02_32",
    GWOMW = "Minou_security_garage_02_33",
    GWORW = "Minou_security_garage_02_34",
    GNOLW = "Minou_security_garage_02_35",
    GNOMW = "Minou_security_garage_02_36",
    GNORW = "Minou_security_garage_02_37",
    GWOLY = "Minou_security_garage_02_48",
    GWOMY = "Minou_security_garage_02_49",
    GWORY = "Minou_security_garage_02_50",
    GNOLY = "Minou_security_garage_02_51",
    GNOMY = "Minou_security_garage_02_52",
    GNORY = "Minou_security_garage_02_53",
}

local deleteDoorSprite = function(playerObj, sq, fetchName)

    if isServer() then
        playServerSound("SA_Door_Beep", sq)
        playServerSound("SA_Door_Slide", sq)
    else
        BB_SecureAccess_Utils.TryPlaySoundClip(playerObj, "SA_Door_Beep")
        BB_SecureAccess_Utils.TryPlaySoundClip(playerObj, "SA_Door_Slide")
    end

    local objs = sq:getObjects()
    for n = objs:size() -1, 0, -1 do
        local obj = objs:get(n)
        if instanceof(obj, "IsoObject") then
			local sprite = obj:getSprite()
			if sprite then
                local properties = sprite:getProperties()
                if properties:Is("CustomName") then
                    local name = properties:Val("CustomName")
                    if name then
                        local nameLength = string.len(name)
                        local namePrefix = name:sub(1, 1)
                        if (nameLength == 4 or nameLength == 5) and (namePrefix == "S" or namePrefix == "O" or namePrefix == "G") then
                            sledgeDestroy(obj)
                            sq:transmitRemoveItemFromSquare(obj)
                            if fetchName then
                                return name
                            end
                        end
                    end
                end
            end
        end
    end
end

local function reverseDoorSprite(cell, sq, spriteName)
    local newSprite = IsoObject.new(cell, sq, doorMapping[spriteName])
    if not newSprite then return end
    sq:AddSpecialObject(newSprite)
    newSprite:transmitCompleteItemToClients()
end

local function setDoor(playerObj, args)

    local cell = playerObj:getCell()
    local sqCoords = args.square
    local sq = cell:getGridSquare(sqCoords.x, sqCoords.y, sqCoords.z)
    if not sq then return end

    deleteDoorSprite(playerObj, sq)
    BB_SecureAccess_Utils.DelayFunction(function() reverseDoorSprite(cell, sq, args.properties.fullName) end, SandboxVars.SecureAccess.Delay, true)

    local prevSpriteName = nil
    BB_SecureAccess_Utils.DelayFunction(function() prevSpriteName = deleteDoorSprite(playerObj, sq, true) end, SandboxVars.SecureAccess.DoorTimer, true)
    BB_SecureAccess_Utils.DelayFunction(function() reverseDoorSprite(cell, sq, prevSpriteName) end, (SandboxVars.SecureAccess.DoorTimer + SandboxVars.SecureAccess.Delay), true)
end

local function onClientCommand(module, command, playerObj, args)
    if module ~= "SecureAccess" then return end

    if command == "SetDoor" then
        setDoor(playerObj, args)
    end
end

Events.OnClientCommand.Add(onClientCommand)