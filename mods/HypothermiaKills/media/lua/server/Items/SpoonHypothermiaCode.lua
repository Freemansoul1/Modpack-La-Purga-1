function AddHypothermiaDamage()
	for playerIndex = 0, getNumActivePlayers()-1 do
		local player = getSpecificPlayer(playerIndex);
		local AddHYPORoll = ZombRand(1,10);
		if not getPlayer() then return end
		if AddHYPORoll == 2 and player:getMoodles():getMoodleLevel(MoodleType.Hypothermia) > 3 then
        player:getBodyDamage():ReduceGeneralHealth(1);
		end
	end
end
Events.EveryTenMinutes.Add(AddHypothermiaDamage);