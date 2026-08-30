if not isClient() then
    return
end

local vaccineEffect = require('Component/HealthPanel/Effect/VaccineEffect')

local commands = {}
commands.wantNoise = getDebug() or false

local noise = function(msg)
    if commands.wantNoise then
        print('New Hope Client Commands: ' .. msg)
    end
end

function commands.onLaceration(player, args)
    local bodyPart = BodyPartType.FromIndex(args.bodyPartIndex)
    player:getBodyDamage():getBodyPart(bodyPart):setCut(args.isToggled)
    player:getBodyDamage():getBodyPart(bodyPart):setCutTime(args.lacerationTime)
end

function commands.onUpdateInfectionTime(player, args)
    local bodyPart = BodyPartType.FromIndex(args.bodyPartIndex)
    local infectionMortalityDuration = player:getBodyDamage():getInfectionMortalityDuration()
    local infectionTime = player:getBodyDamage():getInfectionTime() + infectionMortalityDuration * args.modifier

    if player:getBodyDamage():getInfectionTime() >= 0 then
        player:getBodyDamage():setInfectionTime(infectionTime)
    end

    if not player:getBodyDamage():getBodyPart(bodyPart):IsInfected() then
        player:getBodyDamage():getBodyPart(bodyPart):SetInfected(true)
    end
end

function commands.onUpdateInfection(player, args)
    player:getBodyDamage():setInfected(false)
end

function commands.onVirusTest(player, args)
    if args.isInfected == nil then
        args.isInfected = player:getBodyDamage():isInfected()
        args.otherPlayerOnlineID = args.characterOnlineID
        args.characterOnlineID = player:getOnlineID()

        sendClientCommand(player, 'NewHope', 'onVirusTest', args)

        return
    end

    local tester = player:getInventory():FindAndReturn(args.itemFullType)
    local result = getText('UI_ContextMenu_Healthy')
    if args.isInfected then
        result = getText('UI_ContextMenu_Infected')
    end

    tester:setTooltip(result)
end

function commands.onTransfuse(player, args)
    player:getBodyDamage():AddGeneralHealth(100 * args.modifier)
end

function commands.onUpdateInfection(player, args)
    vaccineEffect.apply(player)
end

local onServerCommand = function(module, command, args)
    if module == 'NewHope' and commands[command] then
        noise('received ' .. module .. ' ' .. command)

        local otherPlayer = getPlayerByOnlineID(args.otherPlayerOnlineID)
        if not otherPlayer then
            return
        end

        commands[command](otherPlayer, args)
    end
end

Events.OnServerCommand.Add(onServerCommand)
