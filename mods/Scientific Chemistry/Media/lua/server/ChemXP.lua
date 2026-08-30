function Jet_XP(_item, result, player)
	local xpAdd = 25;

	player:getXp():AddXP(Perks.Doctor, xpAdd);
end

function Stimpack_XP(_item, result, player)
	local xpAdd = 65;
	
	player:getXp():AddXP(Perks.Doctor, xpAdd);
end

function Psycho_XP(_item, result, player)
	local xpAdd = 95;
	player:getXp():AddXP(Perks.Doctor, xpAdd);
end

function MedX_XP(_item, result, player)
	local xpAdd = 45;

	player:getXp():AddXP(Perks.Doctor, xpAdd);
end