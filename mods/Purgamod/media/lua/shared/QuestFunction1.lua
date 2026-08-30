require "Scripting/Objects/Command"
require "Quests/Task"
require "Scripting/QuestCreator"


function isUserInWhitelist()
    local whitelist = SandboxVars.NPCQuest.Whitelist or ""
    local usernames = {}
    for username in whitelist:gmatch("[^,]+") do
        table.insert(usernames, username:lower())
    end
    local usernameCheck = getPlayer():getUsername()
    local lowerUsernameToCheck = usernameCheck:lower()
    for i, username in ipairs(usernames) do
        if username == lowerUsernameToCheck then
            return true
        end
    end

    return false
end



