require "Scripting/Objects/Command"
require "Quests/Task"
require "Scripting/QuestCreator"


function quests_getSeason()
    local season = ClimateManager.getInstance():getSeasonName();
    return season
end



