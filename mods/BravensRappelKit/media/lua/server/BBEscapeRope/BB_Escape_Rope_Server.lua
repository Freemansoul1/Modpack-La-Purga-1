--***********************************************************
--**                       BitBraven                       **
--***********************************************************

local sprites = BB_Escape_Rope.Sprites

local getPlayerAngle = function(dir)
    if (dir == IsoDirections.N) then return "S"
    elseif (dir == IsoDirections.NE) then return "W"
    elseif (dir == IsoDirections.E) then return "W"
    elseif (dir == IsoDirections.SE) then return "N"
    elseif (dir == IsoDirections.S) then return "N"
    elseif (dir == IsoDirections.SW) then return "N"
    elseif (dir == IsoDirections.W) then return "E"
    elseif (dir == IsoDirections.NW) then return "S"
    end
end

local spawnRope = function(playerObj, playerDir, clickedSquare, targetSquare, objType)

    local cell = playerObj:getCell()
    local squareX = targetSquare:getX()
    local squareY = targetSquare:getY()
    local ropeStartSq = clickedSquare
    local spriteType = "top"
    local spriteDirection = getPlayerAngle(playerDir)
    local availableFloors = targetSquare:getZ() - 1

    if objType == "Window" or objType == "Frame" then
        spriteType = "topRaised"
        ropeStartSq = targetSquare
    else
        local ropeStartDecor = IsoObject.new(cell, targetSquare, sprites["topDecor"][spriteDirection])
        targetSquare:AddSpecialObject(ropeStartDecor)
        ropeStartDecor:getModData().isEscapeRope = true
        ropeStartDecor:transmitCompleteItemToClients()
        ropeStartDecor:transmitModData()
    end

    local ropeStart = IsoObject.new(cell, ropeStartSq, sprites[spriteType][spriteDirection])
    if not ropeStart then return end
    ropeStartSq:AddSpecialObject(ropeStart)
    targetSquare:getModData().hasEscapeRope = true
    ropeStart:getModData().isEscapeRope = true
    ropeStart:transmitCompleteItemToClients()
    ropeStart:transmitModData()
    targetSquare:transmitModdata()

    spriteType = "center"
    for i = availableFloors, 0, - 1 do
        local groundSq = cell:getGridSquare(squareX, squareY, i)
        if groundSq then
            local isGroundFloor = groundSq:isSolidFloor()
            local sqRope = IsoObject.new(cell, groundSq, sprites[spriteType][spriteDirection])

            groundSq:AddSpecialObject(sqRope)
            sqRope:getModData().isEscapeRope = true
            if isGroundFloor then sqRope:getModData().isGroundFloor = true end
            sqRope:transmitCompleteItemToClients()
            sqRope:transmitModData()

            if isGroundFloor then
                spriteType = "bottom"
                local sqRopeEnd = IsoObject.new(cell, groundSq, sprites[spriteType][spriteDirection])
                groundSq:AddSpecialObject(sqRopeEnd)
                sqRopeEnd:getModData().isEscapeRope = true
                sqRopeEnd:transmitCompleteItemToClients()
                sqRopeEnd:transmitModData()

                if SandboxVars.RappelKit.WorksBothWays == true then
                    local safeSquare = clickedSquare
                    if not safeSquare:isSolidFloor() then
                        local safeSqX = safeSquare:getX()
                        local safeSqY = safeSquare:getY()
                        local safeSqZ = safeSquare:getZ()
                        local possibleSqCoords = {
                            N0 = { x = safeSqX + 1, y = safeSqY },
                            N1 = { x = safeSqX - 1, y = safeSqY },
                            N2 = { x = safeSqX, y = safeSqY + 1 },
                            N3 = { x = safeSqX, y = safeSqY - 1 },
                        }

                        for n = 0, 3 do
                            local sqCoords = possibleSqCoords["N"..n]
                            local sq = cell:getGridSquare(sqCoords.x, sqCoords.y, safeSqZ)
                            if sq and sq:isSolidFloor() then
                                safeSquare = sq
                            end
                        end
                    end

                    groundSq:getModData().isERGroundFloor = true
                    groundSq:getModData().EscapeRopeSize = safeSquare:getZ() - groundSq:getZ()
                    groundSq:getModData().targetSquareX = safeSquare:getX()
                    groundSq:getModData().targetSquareY = safeSquare:getY()
                    groundSq:transmitModdata()
                end
                break
            end
        end
    end
end

local addRope = function(playerObj, args)
    local cell = playerObj:getCell()
	local sq = cell:getGridSquare(args.square.x, args.square.y, args.square.z)

	if sq and args.index >= 0 and args.index < sq:getObjects():size() then
		local entity = sq:getObjects():get(args.index)
        local objType = "Square"

		if instanceof(entity, 'IsoWindow') or instanceof(entity, 'IsoThumpable') then
            objType = "Window"
		elseif IsoWindowFrame.isWindowFrame(entity) then
			objType = "Frame"
		end

        local emptySq = cell:getGridSquare(args.emptySquare.x, args.emptySquare.y, args.emptySquare.z)
        if emptySq then
            spawnRope(playerObj, args.playerDir, sq, emptySq, objType)
        end
	end
end

local deleteRopeTiles = function(sq)
    local objs = sq:getObjects()
    for n = objs:size() -1, 0, -1 do
        local obj = objs:get(n)
        if instanceof(obj, "IsoObject") and obj:getModData().isEscapeRope then
            sledgeDestroy(obj)
            sq:transmitRemoveItemFromSquare(obj)
        end
    end
end

local removeRope = function(playerObj, args)
    local cell = playerObj:getCell()

    if args.isReversed == false then
        local emptySq = cell:getGridSquare(args.emptySquare.x, args.emptySquare.y, args.emptySquare.z)
        if not emptySq then return end

        local emptySqX = args.emptySquare.x
        local emptySqY = args.emptySquare.y
        local emptySqZ = args.emptySquare.z

        local availableFloors = args.emptySquare.z
        for i = availableFloors, 0, - 1 do
            local sq = cell:getGridSquare(emptySqX, emptySqY, i)
            if sq then deleteRopeTiles(sq) end
        end

        if emptySq and emptySq:getModData().hasEscapeRope ~= nil then
            emptySq:getModData().hasEscapeRope = nil
            emptySq:transmitModdata()
        end

        local possibleSqCoords = {
            N0 = { x = emptySqX, y = emptySqY - 1, z = emptySqZ },
            N1 = { x = emptySqX + 1, y = emptySqY - 1, z = emptySqZ },
            N2 = { x = emptySqX + 1, y = emptySqY, z = emptySqZ },
            N3 = { x = emptySqX + 1, y = emptySqY + 1, z = emptySqZ },
            N4 = { x = emptySqX, y = emptySqY + 1, z = emptySqZ },
            N5 = { x = emptySqX - 1, y = emptySqY + 1, z = emptySqZ },
            N6 = { x = emptySqX - 1, y = emptySqY, z = emptySqZ },
            N7 = { x = emptySqX - 1, y = emptySqY - 1, z = emptySqZ },
        }

        for i = 0, 7 do
            local sqCoords = possibleSqCoords["N"..i]
            local sq = cell:getGridSquare(sqCoords.x, sqCoords.y, sqCoords.z)
            if sq then deleteRopeTiles(sq) end
        end
    else
        local groundSq = cell:getGridSquare(args.emptySquare.x, args.emptySquare.y, args.emptySquare.z)
        if not groundSq then return end

        if groundSq:getModData().isERGroundFloor ~= nil then
            groundSq:getModData().isERGroundFloor = nil
            groundSq:transmitModdata()
        end

        local groundSqX = args.emptySquare.x
        local groundSqY = args.emptySquare.y
        local groundSqZ = args.emptySquare.z
        local topFloor = groundSqZ + groundSq:getModData().EscapeRopeSize

        for i = topFloor, groundSqZ, - 1 do
            local sq = cell:getGridSquare(groundSqX, groundSqY, i)
            if sq then deleteRopeTiles(sq) end
        end

        local possibleSqCoords = {
            N0 = { x = groundSqX, y = groundSqY },
            N1 = { x = groundSqX, y = groundSqY - 1 },
            N2 = { x = groundSqX + 1, y = groundSqY - 1 },
            N3 = { x = groundSqX + 1, y = groundSqY },
            N4 = { x = groundSqX + 1, y = groundSqY + 1 },
            N5 = { x = groundSqX, y = groundSqY + 1 },
            N6 = { x = groundSqX - 1, y = groundSqY + 1},
            N7 = { x = groundSqX - 1, y = groundSqY },
            N8 = { x = groundSqX - 1, y = groundSqY - 1},
        }

        for i = 0, 8 do
            local sqCoords = possibleSqCoords["N"..i]
            local sq = cell:getGridSquare(sqCoords.x, sqCoords.y, topFloor)
            if sq then
                if sq:getModData().hasEscapeRope ~= nil then
                    sq:getModData().hasEscapeRope = nil
                    sq:transmitModdata()
                end
                deleteRopeTiles(sq)
            end
        end
    end
end

local rescuePlayer = function(playerObj, args)
    local cell = playerObj:getCell()
	local emptySq = cell:getGridSquare(args.emptySquare.x, args.emptySquare.y, args.emptySquare.z)
    if not emptySq then return end

    local emptySqX = args.emptySquare.x
    local emptySqY = args.emptySquare.y

    local availableFloors = args.emptySquare.z
    for i = availableFloors, 0, -1 do
        local sq = cell:getGridSquare(emptySqX, emptySqY, i)
        if sq then
            local objs = sq:getObjects()
            for n = objs:size() -1, 0, -1 do
                local obj = objs:get(n)
                if instanceof(obj, "IsoObject") and obj:getModData().isGroundFloor then

                    if getWorld():getGameMode() == "Multiplayer" then
                        if emptySq:getModData().isERGroundFloor == nil then
                            local pArgs = {x = sq:getX(), y = sq:getY(), z = sq:getZ()}
                            sendServerCommand(playerObj, "EscapeRope", "RescuePlayer", pArgs)
                        else
                            local sqData = emptySq:getModData()
                            local pArgs = {x = sqData.targetSquareX, y = sqData.targetSquareY, z = sq:getZ() + sqData.EscapeRopeSize}
                            sendServerCommand(playerObj, "EscapeRope", "RescuePlayer", pArgs)
                        end
                    else
                        if emptySq:getModData().isERGroundFloor == nil then
                            BB_Escape_Rope.RescuePlayer(playerObj, sq:getX(), sq:getY(), sq:getZ())
                        else
                            local sqData = emptySq:getModData()
                            BB_Escape_Rope.RescuePlayer(playerObj, sqData.targetSquareX, sqData.targetSquareY, sq:getZ() + sqData.EscapeRopeSize)
                        end
                    end

                    if SandboxVars.RappelKit.DeleteOnUse == true then
                        removeRope(playerObj, args)
                    end
                end
            end
        end
    end
end

local function onClientCommand(module, command, playerObj, args)
    if module ~= "EscapeRope" then return end

    if command == "RescuePlayer" then
        rescuePlayer(playerObj, args)
    end

    if command == "AddRope" then
        addRope(playerObj, args)
    end

    if command == "RemoveRope" then
        removeRope(playerObj, args)
    end
end

Events.OnClientCommand.Add(onClientCommand)