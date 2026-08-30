

--NOTE: World times are relative to in-game hours played/simulated. It is not calculated when SetMonth, SetDay, or SetYear are used.

local debugOff = true;

function STS_OnEveryDays ()

    local AvgMonthsInYear = 30.437; --Used for formula to determine how often to skip days in a month
    local currentYear = getGameTime():getYear();
    local nightsSurvived = getGameTime():getNightsSurvived();

    --[[ Debug Testing
    STS_DEBUG("nightsSurvived = " .. tostring(nightsSurvived));
    print("nightsSurvived = "..tostring(nightsSurvived));
    --]]

    STS_DEBUG("currentYear = " .. tostring(currentYear));
    --print("currentYear = "..tostring(currentYear));
    

    --Grab sandbox variables
    local scaleErosion = SandboxVars.sts.ScaleErosion;
    local maxDaysInMonth = SandboxVars.sts.MaxDaysInMonth;
    maxDaysInMonth = round(maxDaysInMonth,0);

    local daysToSkip = (round((AvgMonthsInYear / maxDaysInMonth), 0) - 1); --Determine days to skip, subtract 1
    STS_DEBUG("daysToSkip = " .. tostring(daysToSkip));
    --print("daysToSkip = "..tostring(daysToSkip));
    local currentDay = getGameTime():getDay();
    STS_DEBUG("currentDay = " .. tostring(currentDay));
    --print("currentDay = "..tostring(currentDay));
    local newDay = ((currentDay + daysToSkip) + 1); --Add 1 to newDay for condition check near month end.
    STS_DEBUG("newDay = " .. tostring(newDay));
    --print("newDay = "..tostring(newDay));

    STS_DEBUG("scaleErosion = " .. tostring(scaleErosion));
    --print("scaleErosion = "..tostring(scaleErosion));
    --if (scaleErosion) then
      --  SandboxVars.ErosionDays = (SandboxVars.ErosionDays * (1 - (maxDaysInMonth / AvgMonthsInYear)))

    --end;

    --Get zomboids standard number of days in the current month.
    local zDaysInMonth = getGameTime():daysInMonth(getGameTime():getYear(), getGameTime():getMonth()); 
    
    STS_DEBUG("zDaysInMonth = " .. tostring(zDaysInMonth));
    --print("zDaysInMonth = "..tostring(zDaysInMonth));

    --Check if we are going to set the day beyond the max amount of days in this month to prevent this bug
    if (newDay > zDaysInMonth) then

        local currentMonth = getGameTime():getMonth();
        local newMonth = currentMonth + 1;
        
        if (newMonth > 11) then
            newMonth = 0;
        end;

        --Debug Testing
        STS_DEBUG("currentMonth = " .. tostring(currentMonth));
        --print("currentMonth = "..tostring(currentMonth));
        STS_DEBUG("newMonth = " .. tostring(newMonth));
        --print("newMonth = "..tostring(newMonth));
        
        local dayCarryOver = (newDay - zDaysInMonth);
        if dayCarryOver < 0 then dayCarryOver = 0 end; 
        STS_DEBUG("dayCarryOver = " .. tostring(dayCarryOver));
        --print("dayCarryOver = "..tostring(dayCarryOver));
        getGameTime():setMonth(newMonth);
        if newMonth == 0 then getGameTime():setYear(currentYear + 1) end; --Set new year on new cycle
        if dayCarryOver == 0 then 
            getGameTime():setDay(dayCarryOver);
        else
            getGameTime():setDay(dayCarryOver - 1);
        end;


    else
        getGameTime():setDay(newDay - 1);
    end;

end;


Events.EveryDays.Add(STS_OnEveryDays);


function STS_DEBUG (debugMsg)

    if (debugOff == true) then return; end;

    --Only log as string
    if (type(debugMsg) ~= "string") then
        debugMsg = tostring(debugMsg);
    end;

    --Write to log file in C:\Users\<username>\Zomboid\Lua
	local fileWriterObj = getFileWriter("STSDebug.log", true, true);

	fileWriterObj:write("STS Mod - " .. debugMsg .."\r\n");

	fileWriterObj:close();
end;
