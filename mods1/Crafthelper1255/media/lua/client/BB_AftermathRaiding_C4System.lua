-- ************************************************************************
-- **        ██████  ██████   █████  ██    ██ ███████ ███    ██          **
-- **        ██   ██ ██   ██ ██   ██ ██    ██ ██      ████   ██          **
-- **        ██████  ██████  ███████ ██    ██ █████   ██ ██  ██          **
-- **        ██   ██ ██   ██ ██   ██  ██  ██  ██      ██  ██ ██          **
-- **        ██████  ██   ██ ██   ██   ████   ███████ ██   ████          **
-- ************************************************************************
-- ** All rights reserved. This content is protected by © Copyright law. **
-- ************************************************************************

local function explodeC4(playerObj, x, y, z)
    BB_AFTMRaid_Utils.DelayFunction(function()
        local radius = SandboxVars.crafthelper1255.C4ExplosionRadius
        local squareCoordinates = {}

        for dx = -radius, radius do
            for dy = -radius, radius do
                if math.abs(dx) <= radius and math.abs(dy) <= radius then
                    local coordX = x + dx
                    local coordY = y + dy
                    local sq = getCell():getGridSquare(coordX, coordY, z)
                    if sq then
                        table.insert(squareCoordinates, { X = coordX, Y = coordY })
                    end
                end
            end
        end

        local args = {
            squares = squareCoordinates,
            playerZ = z,
        }

        sendClientCommand(playerObj, "crafthelper1255", "TryExplodeThump", args)

        BB_AFTMRaid_Utils.DelayFunction(function()
            playerObj:getEmitter():stopSoundByName("C4_Detonate")
        end, 60)

    end, 360)

    BB_AFTMRaid_Utils.DelayFunction(function()
        playerObj:getEmitter():playSound("C4_Detonate")
    end, 60)
end

local function onWeaponSwing(character, weapon)
	if character ~= getPlayer() then return end
    if weapon:getType() ~= "RaidC4" then return end

    local playerNum = character:getPlayerNum()
    local z = character:getZ()
    local x = math.floor(screenToIsoX(playerNum, getMouseX(), getMouseY(), z))  + 2
    local y = math.floor(screenToIsoY(playerNum, getMouseX(), getMouseY(), z))  + 2

    explodeC4(character, x, y, z)
end

Events.OnWeaponSwing.Add(onWeaponSwing)