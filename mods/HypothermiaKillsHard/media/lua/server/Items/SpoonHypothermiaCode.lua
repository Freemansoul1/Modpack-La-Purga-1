function AddHypothermiaDamage(player)
	for playerIndex = 0, getNumActivePlayers()-1 do
		local player = getSpecificPlayer(playerIndex);
		local AddHYPORoll = ZombRand(1,10);
		if not getPlayer() then return end
		if AddHYPORoll == 2 and player:getMoodles():getMoodleLevel(MoodleType.Hypothermia) > 2 and player:getBodyDamage():getOverallBodyHealth() < 15 then
        player:getBodyDamage():ReduceGeneralHealth(2);
		elseif AddHYPORoll == 4 and player:getMoodles():getMoodleLevel(MoodleType.Hypothermia) > 2 and player:getBodyDamage():getOverallBodyHealth() < 15 then
        player:getBodyDamage():ReduceGeneralHealth(4);
		elseif AddHYPORoll == 6 and player:getMoodles():getMoodleLevel(MoodleType.Hypothermia) > 2 and player:getBodyDamage():getOverallBodyHealth() < 15 then
        player:getBodyDamage():ReduceGeneralHealth(6);
		end
	end
end
Events.EveryTenMinutes.Add(AddHypothermiaDamage);