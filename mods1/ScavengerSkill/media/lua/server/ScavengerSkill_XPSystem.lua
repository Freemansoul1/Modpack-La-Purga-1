
function addSkillBooks()

SkillBook["Scavenging"] = {};
SkillBook["Scavenging"].perk = Perks.Scavenging;
SkillBook["Scavenging"].maxMultiplier1 = 3;
SkillBook["Scavenging"].maxMultiplier2 = 5;
SkillBook["Scavenging"].maxMultiplier3 = 8;
SkillBook["Scavenging"].maxMultiplier4 = 12;
SkillBook["Scavenging"].maxMultiplier5 = 16;
end

Events.OnGameStart.Add(addSkillBooks);