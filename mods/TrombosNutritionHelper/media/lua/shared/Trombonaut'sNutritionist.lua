Tbn = {};

local UI;

local nutrition;
local thermo;

local lastCals = 0;
local lastWeight = 0;
local lastCarbs = 0;
local lastFat = 0;
local lastProt = 0;

local lowText = " (Low)";
local highText = " (High)";

function Tbn.setReferences()
    if(not UI) then return; end;

    nutrition = getPlayer():getNutrition();
    thermo = getPlayer():getBodyDamage():getThermoregulator();    
end

-- Create the UI with all element exept image and image button
local function onCreateUI()
	UI = NewUI();
    Tbn.setReferences();
    UI:setWidthPercent(0.10);

    UI:setTitle("Nutrition Information")

    UI:addText("", "Calories:", _, "Center");
    UI:addText("calories", "0", _, "Center");
    UI:nextLine();

    UI:addText("", "Metabolism:", _, "Center");
    UI:addText("metabolism", "0", _, "Center");
    UI:nextLine();

    UI:addText("", "Weight:", _, "Center");
    UI:addText("weight", "0", _, "Center");
    --UI:addProgressBar("weight", 80, 25, 160);
    UI:nextLine();

    UI:addText("", "Carbs:", _, "Center");
    UI:addText("carbs", "0", _, "Center");
    --UI:addProgressBar("carbs", 0, -500, 1000);
    UI:nextLine();

    UI:addText("", "Fat:", _, "Center");
    UI:addText("fat", "0", _, "Center");
    --UI:addProgressBar("fat", 0, -500, 1000);
    UI:nextLine();

    UI:addText("", "Protein:", _, "Center");
    UI:addText("protein", "0", _, "Center");
    --UI:addProgressBar("protein", 0, -500, 500);
    UI:nextLine();

    UI:setBorderToAllElements(true);                  
    UI:saveLayout();                             
end

local function everyMinute()
    if not UI then return false end
    --if not localPlayer then return false end
    UI["calories"]:setText(""..math.floor(nutrition:getCalories()));
    --UI["calories"]:setColor(1, 0.2, 0.8, 0.2)
    local value = math.floor(thermo:getEnergyMultiplier() * 1000)/1000;
    UI["metabolism"]:setText(""..value);
    
    local uiText = UI["weight"];
    local value = nutrition:getWeight();
    --pbar:setValue(math.min(value, 135));
    if(value > 100) then
        Tbn.setPBarVeryBad(uiText);
        uiText:setText(""..math.floor(value)..highText);
    elseif(value < 50) then
        Tbn.setPBarVeryBad(uiText);
        uiText:setText(""..math.floor(value)..lowText);
    elseif(value > 85) then
        Tbn.setPBarBad(uiText);
        uiText:setText(""..math.floor(value)..highText);
    elseif(value < 75) then
        Tbn.setPBarBad(uiText);
        uiText:setText(""..math.floor(value)..lowText);
    else
        Tbn.setPBarGood(uiText);
        uiText:setText(""..math.floor(value));
    end

    uiText = UI["carbs"];
    value = nutrition:getCarbohydrates();
    --pbar:setValue(value);
    if (value > 700) then 
        Tbn.setPBarVeryBad(uiText);
        uiText:setText(""..math.floor(value)..highText);
    elseif(value > 400) then
        Tbn.setPBarBad(uiText);
        uiText:setText(""..math.floor(value)..highText);
    else
        Tbn.setPBarGood(uiText);
        uiText:setText(""..math.floor(value));
    end

    uiText = UI["fat"];
    value = nutrition:getLipids();
    --pbar:setValue(value);
    if(value > 700) then
        Tbn.setPBarVeryBad(uiText);
        uiText:setText(""..math.floor(value)..highText);
    elseif(value > 400) then 
        Tbn.setPBarBad(uiText);
        uiText:setText(""..math.floor(value)..highText);
    -- elseif(value < -1500) then
    --     setPBarVeryBad(pbar);
    -- elseif(value < -1000) then
    --     setPBarBad(pbar);
    else
        Tbn.setPBarGood(uiText);
        uiText:setText(""..math.floor(value));
    end

    uiText = UI["protein"];
    value = nutrition:getProteins();
    --pbar:setValue(value);
    if(value > 300) then
        Tbn.setPBarBad(uiText);
        uiText:setText(""..math.floor(value)..highText);
    elseif(value > 50) then
        Tbn.setPBarVeryGood(uiText);
        uiText:setText(""..math.floor(value));
    elseif(value < -300) then 
        Tbn.setPBarBad(uiText);
        uiText:setText(""..math.floor(value)..lowText);
    else
        Tbn.setPBarGood(uiText);
        uiText:setText(""..math.floor(value));
    end

    UI:toggle();
    UI:toggle();
end

function Tbn.setPBarGood(pbar)
    pbar:setColor(1, 0.2, 0.8, 0.2)
end

function Tbn.setPBarVeryGood(pbar)
    pbar:setColor(1, 0, 0.6, 0.2)
end

function Tbn.setPBarBad(pbar)
    pbar:setColor(1, 1, 0.31373, 0.31373)
end

function Tbn.setPBarVeryBad(pbar)
    pbar:setColor(1, 0.8, 0, 0)
end


local function ShowNutritionButton(player, context, items)
    if(UI.isUIVisible) then return end;

    local function ShowNutrition()
        UI:toggle();
    end

    context:addOption("Show Nutrition", nil, ShowNutrition, player);
end


local function PrintStatChange()
    if(not isDebugEnabled()) then return end;

    local weightChange = nutrition:getWeight() - lastWeight;
    local calChange = nutrition:getCalories() - lastCals;
    local carbChange = nutrition:getCarbohydrates() - lastCarbs;
    local fatChange = nutrition:getLipids() - lastFat;
    local protchange = nutrition:getProteins() - lastProt;

    lastWeight = nutrition:getWeight();
    lastCals = nutrition:getCalories();
    lastCarbs = nutrition:getCarbohydrates();
    lastFat = nutrition:getLipids();
    lastProt = nutrition:getProteins();

    print("weight:"..weightChange);
    print("calories:"..calChange);
    print("carbs:"..carbChange);
    print("fat:"..fatChange);
    print("protein:"..protchange);
end

local function TryAssignToNewCharacter()
    if(nutrition) then
        if(nutrition ~= getPlayer():getNutrition()) then
            Tbn.setReferences();    
        end
    end
end

Events.OnCreateUI.Add(onCreateUI)
Events.OnCreateSurvivor.Add(Tbn.setReferences);

Events.EveryOneMinute.Add(everyMinute)

Events.OnFillWorldObjectContextMenu.Add(ShowNutritionButton);

Events.EveryTenMinutes.Add(PrintStatChange);
Events.EveryTenMinutes.Add(TryAssignToNewCharacter);