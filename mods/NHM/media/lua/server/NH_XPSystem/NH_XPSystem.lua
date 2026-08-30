
function addSkillBooks()

SkillBook["Chemistry"] = {};
SkillBook["Chemistry"].perk = Perks.Chemistry;
SkillBook["Chemistry"].maxMultiplier1 = 3;
SkillBook["Chemistry"].maxMultiplier2 = 5;
SkillBook["Chemistry"].maxMultiplier3 = 8;
SkillBook["Chemistry"].maxMultiplier4 = 12;
SkillBook["Chemistry"].maxMultiplier5 = 16;
end

Events.OnGameStart.Add(addSkillBooks);