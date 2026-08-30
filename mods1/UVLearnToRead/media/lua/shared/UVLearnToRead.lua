local function hasTV(square)
    local square = square
    if square then
        for i=1,square:getObjects():size() do
            local thisObject = square:getObjects():get(i-1)
                    if thisObject:getObjectName() == "Television" then
                        if thisObject:getSayLine() ~= nil and thisObject:getSayLine() ~= "<fzzt>" and thisObject:getSayLine() ~= "<wzzt>" and thisObject:getSayLine() ~= "<szzt>" and thisObject:getSayLine() ~= "<bzzt>" then
                            local player = getPlayer(1)
                            return true
                        end
                    end
                end
            end
        end

local function isListening(player,playerdata)
    if player:HasTrait("illiterate") then
		local x = math.floor(player:getX())
		local y = math.floor(player:getY())
        local dist = 5
        for i = -dist,dist do
            local b = -dist
            while b < dist do
				local square = getCell():getGridSquare(player:getX() + b, player:getY() + i, player:getZ());
				if square ~= nil then
					if hasTV(square) == true then
						local hasTVNearby = true
                        player:getXp():AddXP(Perks.LearningReading, 4)
					end
				end
				b = b + 1
			end
        end
    end
    
end
local function isReadingNow(player)
    if player:isReading() then
        player:getXp():AddXP(Perks.LearningReading, 0.25+1*player:getPerkLevel(Perks.LearningReading))
    end
end
local function canReadNow(player,playerdata)
    if player:HasTrait("illiterate") and player:getPerkLevel(Perks.LearningReading) ==3 then
        player:Say("I've finally learned how to read. Better late than never.")
        player:getTraits():remove('illiterate')
        player:getTraits():add('SlowReader')
    elseif player:HasTrait("SlowReader") and player:getPerkLevel(Perks.LearningReading) ==5 then
        player:Say("Now I can read somewhat fast.")
        player:getTraits():remove("SlowReader")
    elseif not player:HasTrait("FastReader") and player:getPerkLevel(Perks.LearningReading) ==8 then
        player:Say("I can read even faster now !")
        player:getTraits():add("FastReader")
    end
end
function EveryOneMinute()
	local player = getPlayer(1);
    if player~=nil then
	    local playerdata = player:getModData();
	    isListening(player, playerdata);
        canReadNow(player,playerdata)
        isReadingNow(player)
    end
end

Events.EveryOneMinute.Add(EveryOneMinute);