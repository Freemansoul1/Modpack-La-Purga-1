Knockout = Knockout or {}
local Commands = {}

function Commands.knockOtherPlayerOut(onlineID)
	local player = getPlayer()
	Knockout.setUnconscious(player)
end

function Commands.wakeOtherPlayerUp(onlineID)
	local player = getPlayer()
	local playerIndex = player:getPlayerNum()

	ISTimedActionQueue.clear(player)
	player:setBlockMovement(false)
	Knockout.disabler(player, false) --Enable player controls
	UIManager.FadeIn(playerIndex, 1)
    player:getModData().Knockout_isKnockedout = false

    local moodle = MF.getMoodle("Knockedout");

    if moodle then
        moodle:setValue(0.5)
    end
end

function Commands.CheckKnockoutStatus(playerObjID)
	local player = getPlayer()

	local knockoutStatus = player:getModData().Knockout_isKnockedout

	if not knockoutStatus then
		knockoutStatus = false
	end


	local args = {playerObjID, knockoutStatus}
	sendClientCommand('RealKnockouts', 'CheckKnockoutStatusResponse', args)
end

function Commands.CheckKnockoutStatusResponse(response)
	local player = getPlayer()

	player:getModData().Knockout_CheckKnockoutStatusResponse = response
end

local function OnServerCommand(module, command, args)
    if module == 'RealKnockouts' then
        Commands[command](args[1])
    end
end

Events.OnServerCommand.Add(OnServerCommand)