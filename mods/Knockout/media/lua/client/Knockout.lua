require "MF_ISMoodle"
MF.createMoodle("Knockedout");

Knockout = Knockout or {}

function Knockout.knockoutCheck(player)
	if isServer() then return end
	for playerIndex = 0, getNumActivePlayers()-1 do
		local playerObj = getSpecificPlayer(playerIndex)	--Get Player Object

		if playerObj:getModData().Knockout_isKnockedout then
			ISTimedActionQueue.clear(playerObj)
			ISTimedActionQueue.add(Knockout_TimedAction:new(playerObj, playerIndex))
        end
    end
end

function Knockout.onPlayerDeath(player)
	if isServer() then return end
	if player:getModData().Knockout_isKnockedout then
		local playerNum = player:getPlayerNum()

		ISTimedActionQueue.clear(player)
		Knockout.disabler(player, false) --Enable player controls

    	UIManager.FadeIn(playerNum, 1)
    	player:getModData().Knockout_isKnockedout = false

    	local moodle = MF.getMoodle("Knockedout");

    	if moodle then
        	moodle:setValue(0.5)
    	end
    end
end

Events.OnPlayerDeath.Add(Knockout.onPlayerDeath)
Events.OnCreatePlayer.Add(Knockout.knockoutCheck);