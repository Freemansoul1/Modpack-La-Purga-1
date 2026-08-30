require "ISUI/ISToolTipInv"

local isFood = nil;
local LeGourmetMod = nil;

local FishData = {};
local PX_LETTER = 8;

if LGBaseGameCharacterDetails then
    LeGourmetMod = true;
end

if ISToolTipInv.loaded ~= nil then
    print('INFO: Custom tooltips already loaded, skipping...');
    return
else
    ISToolTipInv.loaded = 1
end

local function getStateText(item)
    --local a = {};
    local r = 1;
    local g = 1;
    local b = 1;
    local total = item:getScriptItem():getDaysTotallyRotten();
    local left = total - item:getAge();
    local bar_length = PX_LETTER * 20;
    local percent = left * 100 / total;
    local portions = "";
    if total > 1000 or not total or total == nil or item:getAge() == nil or tostring(item:getAge()) == "nan" then
        b = 0.4; -- if not rotten, gold color
        --table.insert(a, string.format("%s", getText("UI_mod_fdxpr_state_nonperish")));
    elseif percent <= 100 and percent >= 80 then
        r = 0.0; --Si se encuentra entre 80 y 100, perfecto estado color Celeste
        g = 0.8;
        b = 0.8;
        portions = getText("UI_status_VERYGOOD");
        --table.insert(a, string.format("%s", getText("UI_mod_fdxpr_state_nonperish")));
    elseif percent < 80 and percent >= 60 then
        r = 0.0; --Si se encuentra entre 60 y 80, Buen estado color verde
        g = 0.8;
        b = 0.0;
        portions = getText("UI_status_GOOD");
    elseif percent < 60 and percent >= 40 then
        r = 0.4; --Si se encuentra entre 40 y 60, Normal color verde claro
        g = 0.8;
        b = 0.0;
        portions = getText("UI_status_NORMAL");
    elseif percent < 40 and percent >= 20 then
        r = 0.8; --Si se encuentra entre 20 y 40, Un poco pasado color amarillo
        g = 0.8;
        b = 0.0;
        portions = getText("UI_status_LITTLEROTTEN");
    elseif percent < 20 and percent > 0 then
        r = 0.8; --Si se encuentra entre 1 y 20, Muy pasado color naranja
        g = 0.4;
        b = 0.0;
        portions = getText("UI_status_LITTLEMOREROTTEN");
    else
        g = 0.0; --Si se encuentra en 0, Podrido color rojo
        b = 0.0;
        portions = getText("UI_status_ROTTEN");
    end
    local percentbar = 1 - (item:getAge() / total)--bar_length * percent / 100;
    return portions, r, g, b, total, percent, percentbar;
end

function ISToolTipInv:MakeFishState(item, lh, tw, th, tooltip)
    local data = item:getModData();
    local label_pos = tooltip:getHeight() + lh * 0.2;
    local text2 = "??";
    local r = 1;
    local g = 1;
    local b = 1;
    if not data.alive then
        data.alive = 0;
    end
    if item:isFrozen() then
        data.alive = 0;
    end
    self:makeWindow(th, tw, item, lh)
    if data.alive and data.alive == 1 then
        if data.catchingmin and data.mtodie then
            local actualhours = (getGameTime():getWorldAgeHours() * 60) - data.catchingmin;
            if actualhours > data.mtodie then
                data.alive = 0;
                text2 = getText("IGUI_Dead");
                r = 0.8;
                g = 0;
                b = 0;
                if data.namechange and data.namechange == 1 then
                    if data.origname then

                        item:setName(data.origname .. " " .. getText("IGUI_Dead2"));
                    end
                    data.namechange = 0;
                end
            else
                text2 = getText("IGUI_Alive");
                r = 0;
                g = 0.8;
                b = 0;
                if not data.namechange then
                    if not data.origname then
                        data.origname = getItemText(item:getDisplayName());
                    end
                    data.namechange = 1;
                    item:setName(getItemText(item:getDisplayName()) .. " " .. getText("IGUI_Alive2"));
                end
            end
        end
    else
        text2 = getText("IGUI_Dead");
        r = 0.8;
        g = 0;
        b = 0;
    end
    local text = getText("IGUI_FishState");
    tooltip:DrawText(tooltip:getFont(), text .. ":", 5, label_pos, 1, 1, 0.8, self.borderColor.a);
    local x_shift = (string.len(text) + 3) * PX_LETTER;
    tooltip:DrawText(tooltip:getFont(), text2, x_shift, label_pos, r, g, b, self.borderColor.a);
end

function ISToolTipInv:MakeFoodInfo(item, lh, tw, th, tooltip)
    if item:getType() == "Cigarettes"
            or item:getType() == "Bleach"
            or item:getType() == "Worm"
            or item:getType() == "RedWorm"
            or item:getType() == "ZAWRawBrickPack"
            or item:getType() == "Sugarcane"
            or item:getType() == "SugarcanePile" then
        --nothing
    else
        local hasTrait = nil;
        local cookingLevel = getPlayer():getPerkLevel(Perks.Cooking);
        if getPlayer(0):HasTrait("foodexpiration") or getPlayer(0):HasTrait("foodexpiration2") then
            hasTrait = true;
        end
        if hasTrait ~= nil or cookingLevel >= 4 then
            local lblInfo = "";
            local portions, r, g, b, total, percent, percentbar = getStateText(item);
            local label = getText("UI_tooltip");
            local label_pos = tooltip:getHeight() + lh * 0.2;
            local x_shift = (string.len(label) + 3) * PX_LETTER;
            local bar_length = PX_LETTER * 20;
            local age;
            local y_shift = label_pos;

            if (total > 1000) or not total or total == nil or item:getAge() == nil or tostring(item:getAge()) == "nan" then
                lblInfo = string.format("%s\n", getText("UI_status_NOROTTEN"));
            else
                --construcción de texto informativo para los alimentos
                local element_ext = "%s (%.1f %s %d)";
                local element = "%s";
                age = string.format("%.1f", item:getAge());
                if (hasTrait ~= nil) or cookingLevel >= 6 then
                    lblInfo = lblInfo .. string.format(element_ext, portions, age, getText("UI_have_daysoff"), total);
                elseif cookingLevel >= 4 and cookingLevel < 6 then
                    lblInfo = lblInfo .. string.format(element, portions);
                end
            end
            local extrah = 0;
            
            if item:getType() == "BaitFish"
                    or item:getType() == "Crab"
                    or item:getType() == "Crayfish"
                    or item:getType() == "Dentudo"
                    or item:getType() == "Anguila"
                    or item:getType() == "Palometa"
                    or item:getType() == "Piranha"
                    or item:getType() == "Crappie"
                    or item:getType() == "Panfish"
                    or item:getType() == "Payara"
                    or item:getType() == "Carp"
                    or item:getType() == "Peje"
                    or item:getType() == "Waterturtle"
                    or item:getType() == "Perch"
                    or item:getType() == "Bass"
                    or item:getType() == "Trout"
                    or item:getType() == "Catfish"
                    or item:getType() == "Dorado"
                    or item:getType() == "Tucunare"
                    or item:getType() == "Pacu"
                    or item:getType() == "Tararira"
                    or item:getType() == "Walleye"
                    or item:getType() == "Pati"
                    or item:getType() == "Snakehead"
                    or item:getType() == "Pike"
                    or item:getType() == "Arowana"
                    or item:getType() == "FSalmon"
                    or item:getType() == "RainbowTrout"
                    or item:getType() == "Tarpon"
                    or item:getType() == "Surubi"
                    or item:getType() == "Piraiba"
                    or item:getType() == "Rtcatfish"
                    or item:getType() == "Arapaima"
                    or item:getType() == "Ray" then
                local modData = item:getModData()
                if not modData.alive then
                    self:makeWindow(th, tw, item, lh)
                else
                    extrah = lh;
                end
            else
                self:makeWindow(th, tw, item, lh)
            end
			tooltip:DrawText(tooltip:getFont(), label, 5, label_pos + extrah, 1, 1, 0.8, self.borderColor.a);
			tooltip:DrawText(tooltip:getFont(), lblInfo, x_shift, y_shift + extrah, r, g, b, self.borderColor.a);
            if total < 1000 and (item:getAge() ~= nil and tostring(item:getAge()) ~= "nan") and (hasTrait ~= nil or cookingLevel >= 6) then
                if percent < 0 then
                    percent = 0;
                end
                tooltip:DrawProgressBar(x_shift, (label_pos + lh + (lh / 2) + extrah), bar_length, 2, percentbar, r, g, b, 1);
            end
        else
        end
    end
end

function ISToolTipInv:makeWindow(th, tw, item, lh)
    local cheese = false;
    local food = false;
    local number1 = 0;
    local number2 = 0;
    local tolal = 0;
    local hasTrait = nil;
    local cookingLevel = getSpecificPlayer(0):getPerkLevel(Perks.Cooking);

    if item:getType() == "BaitFish"
            or item:getType() == "Crab"
            or item:getType() == "Crayfish"
            or item:getType() == "Dentudo"
            or item:getType() == "Anguila"
            or item:getType() == "Palometa"
            or item:getType() == "Piranha"
            or item:getType() == "Crappie"
            or item:getType() == "Panfish"
            or item:getType() == "Payara"
            or item:getType() == "Carp"
            or item:getType() == "Peje"
            or item:getType() == "Waterturtle"
            or item:getType() == "Perch"
            or item:getType() == "Bass"
            or item:getType() == "Trout"
            or item:getType() == "Catfish"
            or item:getType() == "Dorado"
            or item:getType() == "Tucunare"
            or item:getType() == "Pacu"
            or item:getType() == "Tararira"
            or item:getType() == "Walleye"
            or item:getType() == "Pati"
            or item:getType() == "Snakehead"
            or item:getType() == "Pike"
            or item:getType() == "Arowana"
            or item:getType() == "FSalmon"
            or item:getType() == "RainbowTrout"
            or item:getType() == "Tarpon"
            or item:getType() == "Surubi"
            or item:getType() == "Piraiba"
            or item:getType() == "Rtcatfish"
            or item:getType() == "Arapaima"
            or item:getType() == "Ray" then
        local modData = item:getModData()
        if not modData.alive then
        else
            cheese = true;
            number1 = lh * 1.5;
        end
    end
end

function ISToolTipInv:MakeFishInfo(fish)
    local hasProf = nil;
    local fishtxt = getText("IGUI_?_Fish_" .. fish);
    if getPlayer(0):getDescriptor():getProfession() == "fisherman" then
        hasProf = true;
    end
    local recipes = getPlayer():getKnownRecipes();
    if recipes:contains("Attract" .. fish) or hasProf ~= nil then
        fishtxt = getText("IGUI_Fish_LG_" .. fish)
    end
    return fishtxt;
end

function ISToolTipInv:Color(fish, c)
    local hasProf = nil;
    local r = 1.0;
    local g = 1.0;
    local b = 1.0;
    if getPlayer(0):getDescriptor():getProfession() == "fisherman" then
        hasProf = true;
    end
    local recipes = getPlayer():getKnownRecipes();
    if recipes:contains("Attract" .. fish) or hasProf ~= nil then
        r = 0.4;
        g = 0.8;
        b = 0.0;
    end
    if c == "r" then
        return r
    elseif c == "g" then
        return g
    elseif c == "b" then
        return b
    end
end

function ISToolTipInv:MakeLureInfo(item, lh, tw, th, tooltip)
    local hasProf = nil;
    if getPlayer(0):getDescriptor():getProfession() == "fisherman" then
        hasProf = true;
    end
    local FishingLevel = getPlayer(0):getPerkLevel(Perks.Fishing);
    local recipes = getPlayer():getKnownRecipes();
    local label = getText("UI_fishingtooltip");
    local label_pos = tooltip:getHeight() + lh * 0.2;

    local linemultiplier = 1;
    local tn = nil;
    if self.item:getType() == "StormFlutterstick" then
        tn = true;
        linemultiplier = 13;
    elseif self.item:getType() == "SpoonLure2" then
        tn = true;
        linemultiplier = 12;
    elseif self.item:getType() == "RattlinRap" or self.item:getType() == "SpoonLure1" or self.item:getType() == "Crankbait" or self.item:getType() == "SwimShad" or self.item:getType() == "Spinnerbait" then
        tn = true;
        linemultiplier = 9;
    elseif self.item:getType() == "SpoonLure3" or self.item:getType() == "Alfers" then
        tn = true;
        linemultiplier = 8;
    elseif self.item:getType() == "SwimJig2" or self.item:getType() == "SwimJig3" then
        tn = true;
        linemultiplier = 7;
    elseif self.item:getType() == "SwimJig" or self.item:getType() == "GTPopper" or self.item:getType() == "JitterBug" then
        tn = true;
        linemultiplier = 6;
    else
        return
    end
    --Mas espacio si se tiene el rasgo o nivel necesario.
    local tth;
    if tn ~= nil then
        tth = (lh * 1.1) * linemultiplier;
    else
        tth = th;
    end

    self:drawRect(0, th, tw + 11, tth, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
    self:drawRectBorder(0, th, tw + 11, tth, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);

    tooltip:DrawTextCentre(tooltip:getFont(), getText("UI_fishingproperties"), tw / 2, label_pos, 1, 1, 0.4, self.borderColor.a);
    tooltip:DrawText(tooltip:getFont(), label, 5, label_pos + lh, 1, 1, 0.8, self.borderColor.a);
    local font = tooltip:getFont();
    if item:getType() == "StormFlutterstick" then
        tooltip:DrawText(font, self:MakeFishInfo("Dorado"), 5, label_pos + (lh * 2), self:Color("Dorado", "r"), self:Color("Dorado", "g"), self:Color("Dorado", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Piranha"), 5, label_pos + (lh * 3), self:Color("Piranha", "r"), self:Color("Piranha", "g"), self:Color("Piranha", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Palometa"), 5, label_pos + (lh * 4), self:Color("Palometa", "r"), self:Color("Palometa", "g"), self:Color("Palometa", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Payara"), 5, label_pos + (lh * 5), self:Color("Payara", "r"), self:Color("Payara", "g"), self:Color("Payara", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Tararira"), 5, label_pos + (lh * 6), self:Color("Tararira", "r"), self:Color("Tararira", "g"), self:Color("Tararira", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Tucunare"), 5, label_pos + (lh * 7), self:Color("Tucunare", "r"), self:Color("Tucunare", "g"), self:Color("Tucunare", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Snakehead"), 5, label_pos + (lh * 8), self:Color("Snakehead", "r"), self:Color("Snakehead", "g"), self:Color("Snakehead", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Arowana"), 5, label_pos + (lh * 9), self:Color("Arowana", "r"), self:Color("Arowana", "g"), self:Color("Arowana", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Bass"), 5, label_pos + (lh * 10), self:Color("Bass", "r"), self:Color("Bass", "g"), self:Color("Bass", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Crappie"), 5, label_pos + (lh * 11), self:Color("Crappie", "r"), self:Color("Crappie", "g"), self:Color("Crappie", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Perch"), 5, label_pos + (lh * 12), self:Color("Perch", "r"), self:Color("Perch", "g"), self:Color("Perch", "b"), self.borderColor.a);
    elseif item:getType() == "RattlinRap" then
        tooltip:DrawText(font, self:MakeFishInfo("Dorado"), 5, label_pos + (lh * 2), self:Color("Dorado", "r"), self:Color("Dorado", "g"), self:Color("Dorado", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Piranha"), 5, label_pos + (lh * 3), self:Color("Piranha", "r"), self:Color("Piranha", "g"), self:Color("Piranha", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Palometa"), 5, label_pos + (lh * 4), self:Color("Palometa", "r"), self:Color("Palometa", "g"), self:Color("Palometa", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Payara"), 5, label_pos + (lh * 5), self:Color("Payara", "r"), self:Color("Payara", "g"), self:Color("Payara", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Tararira"), 5, label_pos + (lh * 6), self:Color("Tararira", "r"), self:Color("Tararira", "g"), self:Color("Tararira", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Tucunare"), 5, label_pos + (lh * 7), self:Color("Tucunare", "r"), self:Color("Tucunare", "g"), self:Color("Tucunare", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Snakehead"), 5, label_pos + (lh * 8), self:Color("Snakehead", "r"), self:Color("Snakehead", "g"), self:Color("Snakehead", "b"), self.borderColor.a);
    elseif item:getType() == "SwimJig" then
        tooltip:DrawText(font, self:MakeFishInfo("Piranha"), 5, label_pos + (lh * 2), self:Color("Piranha", "r"), self:Color("Piranha", "g"), self:Color("Piranha", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Palometa"), 5, label_pos + (lh * 3), self:Color("Palometa", "r"), self:Color("Palometa", "g"), self:Color("Palometa", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Catfish"), 5, label_pos + (lh * 4), self:Color("Catfish", "r"), self:Color("Catfish", "g"), self:Color("Catfish", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Walleye"), 5, label_pos + (lh * 5), self:Color("Walleye", "r"), self:Color("Walleye", "g"), self:Color("Walleye", "b"), self.borderColor.a);
    elseif item:getType() == "SwimJig2" then
        tooltip:DrawText(font, self:MakeFishInfo("Piranha"), 5, label_pos + (lh * 2), self:Color("Piranha", "r"), self:Color("Piranha", "g"), self:Color("Piranha", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Palometa"), 5, label_pos + (lh * 3), self:Color("Palometa", "r"), self:Color("Palometa", "g"), self:Color("Palometa", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Tararira"), 5, label_pos + (lh * 4), self:Color("Tararira", "r"), self:Color("Tararira", "g"), self:Color("Tararira", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Catfish"), 5, label_pos + (lh * 5), self:Color("Catfish", "r"), self:Color("Catfish", "g"), self:Color("Catfish", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Walleye"), 5, label_pos + (lh * 6), self:Color("Walleye", "r"), self:Color("Walleye", "g"), self:Color("Walleye", "b"), self.borderColor.a);
    elseif item:getType() == "SwimJig3" then
        tooltip:DrawText(font, self:MakeFishInfo("Piranha"), 5, label_pos + (lh * 2), self:Color("Piranha", "r"), self:Color("Piranha", "g"), self:Color("Piranha", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Palometa"), 5, label_pos + (lh * 3), self:Color("Palometa", "r"), self:Color("Palometa", "g"), self:Color("Palometa", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Bass"), 5, label_pos + (lh * 4), self:Color("Bass", "r"), self:Color("Bass", "g"), self:Color("Bass", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Catfish"), 5, label_pos + (lh * 5), self:Color("Catfish", "r"), self:Color("Catfish", "g"), self:Color("Catfish", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Walleye"), 5, label_pos + (lh * 6), self:Color("Walleye", "r"), self:Color("Walleye", "g"), self:Color("Walleye", "b"), self.borderColor.a);
    elseif item:getType() == "GTPopper" then
        tooltip:DrawText(font, self:MakeFishInfo("Tararira"), 5, label_pos + (lh * 2), self:Color("Tararira", "r"), self:Color("Tararira", "g"), self:Color("Tararira", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Arowana"), 5, label_pos + (lh * 3), self:Color("Arowana", "r"), self:Color("Arowana", "g"), self:Color("Arowana", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Bass"), 5, label_pos + (lh * 4), self:Color("Bass", "r"), self:Color("Bass", "g"), self:Color("Bass", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Perch"), 5, label_pos + (lh * 5), self:Color("Perch", "r"), self:Color("Perch", "g"), self:Color("Perch", "b"), self.borderColor.a);
    elseif item:getType() == "SpoonLure1" then
        tooltip:DrawText(font, self:MakeFishInfo("Piranha"), 5, label_pos + (lh * 2), self:Color("Piranha", "r"), self:Color("Piranha", "g"), self:Color("Piranha", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Palometa"), 5, label_pos + (lh * 3), self:Color("Palometa", "r"), self:Color("Palometa", "g"), self:Color("Palometa", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Payara"), 5, label_pos + (lh * 4), self:Color("Payara", "r"), self:Color("Payara", "g"), self:Color("Payara", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Rainbowtrout"), 5, label_pos + (lh * 5), self:Color("Rainbowtrout", "r"), self:Color("Rainbowtrout", "g"), self:Color("Rainbowtrout", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Salmon"), 5, label_pos + (lh * 6), self:Color("Salmon", "r"), self:Color("Salmon", "g"), self:Color("Salmon", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Trout"), 5, label_pos + (lh * 7), self:Color("Trout", "r"), self:Color("Trout", "g"), self:Color("Trout", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Bass"), 5, label_pos + (lh * 8), self:Color("Bass", "r"), self:Color("Bass", "g"), self:Color("Bass", "b"), self.borderColor.a);
    elseif item:getType() == "SpoonLure2" then
        tooltip:DrawText(font, self:MakeFishInfo("Dorado"), 5, label_pos + (lh * 2), self:Color("Dorado", "r"), self:Color("Dorado", "g"), self:Color("Dorado", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Piranha"), 5, label_pos + (lh * 3), self:Color("Piranha", "r"), self:Color("Piranha", "g"), self:Color("Piranha", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Palometa"), 5, label_pos + (lh * 4), self:Color("Palometa", "r"), self:Color("Palometa", "g"), self:Color("Palometa", "b"), self.borderColor.a)
        tooltip:DrawText(font, self:MakeFishInfo("Rainbowtrout"), 5, label_pos + (lh * 5), self:Color("Rainbowtrout", "r"), self:Color("Rainbowtrout", "g"), self:Color("Rainbowtrout", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Salmon"), 5, label_pos + (lh * 6), self:Color("Salmon", "r"), self:Color("Salmon", "g"), self:Color("Salmon", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Tararira"), 5, label_pos + (lh * 7), self:Color("Tararira", "r"), self:Color("Tararira", "g"), self:Color("Tararira", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Tucunare"), 5, label_pos + (lh * 8), self:Color("Tucunare", "r"), self:Color("Tucunare", "g"), self:Color("Tucunare", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Snakehead"), 5, label_pos + (lh * 9), self:Color("Snakehead", "r"), self:Color("Snakehead", "g"), self:Color("Snakehead", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Trout"), 5, label_pos + (lh * 10), self:Color("Trout", "r"), self:Color("Trout", "g"), self:Color("Trout", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Perch"), 5, label_pos + (lh * 11), self:Color("Perch", "r"), self:Color("Perch", "g"), self:Color("Perch", "b"), self.borderColor.a);
    elseif item:getType() == "SpoonLure3" then
        tooltip:DrawText(font, self:MakeFishInfo("Piranha"), 5, label_pos + (lh * 2), self:Color("Piranha", "r"), self:Color("Piranha", "g"), self:Color("Piranha", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Palometa"), 5, label_pos + (lh * 3), self:Color("Palometa", "r"), self:Color("Palometa", "g"), self:Color("Palometa", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Payara"), 5, label_pos + (lh * 4), self:Color("Payara", "r"), self:Color("Payara", "g"), self:Color("Payara", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Rainbowtrout"), 5, label_pos + (lh * 5), self:Color("Rainbowtrout", "r"), self:Color("Rainbowtrout", "g"), self:Color("Rainbowtrout", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Salmon"), 5, label_pos + (lh * 6), self:Color("Salmon", "r"), self:Color("Salmon", "g"), self:Color("Salmon", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Trout"), 5, label_pos + (lh * 7), self:Color("Trout", "r"), self:Color("Trout", "g"), self:Color("Trout", "b"), self.borderColor.a);
    elseif item:getType() == "JitterBug" then
        tooltip:DrawText(font, self:MakeFishInfo("Tararira"), 5, label_pos + (lh * 2), self:Color("Tararira", "r"), self:Color("Tararira", "g"), self:Color("Tararira", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Pike"), 5, label_pos + (lh * 3), self:Color("Pike", "r"), self:Color("Pike", "g"), self:Color("Pike", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Bass"), 5, label_pos + (lh * 4), self:Color("Bass", "r"), self:Color("Bass", "g"), self:Color("Bass", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Crappie"), 5, label_pos + (lh * 5), self:Color("Crappie", "r"), self:Color("Crappie", "g"), self:Color("Crappie", "b"), self.borderColor.a);
    elseif item:getType() == "Crankbait" then
        tooltip:DrawText(font, self:MakeFishInfo("Piranha"), 5, label_pos + (lh * 2), self:Color("Piranha", "r"), self:Color("Piranha", "g"), self:Color("Piranha", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Palometa"), 5, label_pos + (lh * 3), self:Color("Palometa", "r"), self:Color("Palometa", "g"), self:Color("Palometa", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Payara"), 5, label_pos + (lh * 4), self:Color("Payara", "r"), self:Color("Payara", "g"), self:Color("Payara", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Surubi"), 5, label_pos + (lh * 5), self:Color("Surubi", "r"), self:Color("Surubi", "g"), self:Color("Surubi", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Bass"), 5, label_pos + (lh * 6), self:Color("Bass", "r"), self:Color("Bass", "g"), self:Color("Bass", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Perch"), 5, label_pos + (lh * 7), self:Color("Perch", "r"), self:Color("Perch", "g"), self:Color("Perch", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Walleye"), 5, label_pos + (lh * 8), self:Color("Walleye", "r"), self:Color("Walleye", "g"), self:Color("Walleye", "b"), self.borderColor.a);
    elseif item:getType() == "SwimShad" then
        tooltip:DrawText(font, self:MakeFishInfo("Piranha"), 5, label_pos + (lh * 2), self:Color("Piranha", "r"), self:Color("Piranha", "g"), self:Color("Piranha", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Palometa"), 5, label_pos + (lh * 3), self:Color("Palometa", "r"), self:Color("Palometa", "g"), self:Color("Palometa", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Surubi"), 5, label_pos + (lh * 4), self:Color("Surubi", "r"), self:Color("Surubi", "g"), self:Color("Surubi", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Pike"), 5, label_pos + (lh * 5), self:Color("Pike", "r"), self:Color("Pike", "g"), self:Color("Pike", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Bass"), 5, label_pos + (lh * 6), self:Color("Bass", "r"), self:Color("Bass", "g"), self:Color("Bass", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Catfish"), 5, label_pos + (lh * 7), self:Color("Catfish", "r"), self:Color("Catfish", "g"), self:Color("Catfish", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Crappie"), 5, label_pos + (lh * 8), self:Color("Crappie", "r"), self:Color("Crappie", "g"), self:Color("Crappie", "b"), self.borderColor.a);
    elseif item:getType() == "Alfers" then
        tooltip:DrawText(font, self:MakeFishInfo("Piranha"), 5, label_pos + (lh * 2), self:Color("Piranha", "r"), self:Color("Piranha", "g"), self:Color("Piranha", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Palometa"), 5, label_pos + (lh * 3), self:Color("Palometa", "r"), self:Color("Palometa", "g"), self:Color("Palometa", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Payara"), 5, label_pos + (lh * 4), self:Color("Payara", "r"), self:Color("Payara", "g"), self:Color("Payara", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Arowana"), 5, label_pos + (lh * 5), self:Color("Arowana", "r"), self:Color("Arowana", "g"), self:Color("Arowana", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Pike"), 5, label_pos + (lh * 6), self:Color("Pike", "r"), self:Color("Pike", "g"), self:Color("Pike", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Walleye"), 5, label_pos + (lh * 7), self:Color("Walleye", "r"), self:Color("Walleye", "g"), self:Color("Walleye", "b"), self.borderColor.a);
    elseif item:getType() == "Spinnerbait" then
        tooltip:DrawText(font, self:MakeFishInfo("Dorado"), 5, label_pos + (lh * 2), self:Color("Dorado", "r"), self:Color("Dorado", "g"), self:Color("Dorado", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Rainbowtrout"), 5, label_pos + (lh * 3), self:Color("Rainbowtrout", "r"), self:Color("Rainbowtrout", "g"), self:Color("Rainbowtrout", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Salmon"), 5, label_pos + (lh * 4), self:Color("Salmon", "r"), self:Color("Salmon", "g"), self:Color("Salmon", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Tararira"), 5, label_pos + (lh * 5), self:Color("Tararira", "r"), self:Color("Tararira", "g"), self:Color("Tararira", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Tucunare"), 5, label_pos + (lh * 6), self:Color("Tucunare", "r"), self:Color("Tucunare", "g"), self:Color("Tucunare", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Snakehead"), 5, label_pos + (lh * 7), self:Color("Snakehead", "r"), self:Color("Snakehead", "g"), self:Color("Snakehead", "b"), self.borderColor.a);
        tooltip:DrawText(font, self:MakeFishInfo("Trout"), 5, label_pos + (lh * 8), self:Color("Trout", "r"), self:Color("Trout", "g"), self:Color("Trout", "b"), self.borderColor.a);
    end
end

function len(T)
    local c = 0
    for _ in pairs(T) do
        c = c + 1
    end
    return c
end


local vanillaRender = ISToolTipInv.render
function ISToolTipInv:render()
    vanillaRender(self)
    -- we render the tool tip for inventory item only if there's no context menu showed
    if not ISContextMenu.instance or not ISContextMenu.instance.visibleCheck then

        local mx = getMouseX() + 24;
        local my = getMouseY() + 24;
        if not self.followMouse then
            mx = self:getX()
            my = self:getY()
            if self.anchorBottomLeft then
                mx = self.anchorBottomLeft.x
                my = self.anchorBottomLeft.y
            end
        end

        self.tooltip:setX(mx + 11);
        self.tooltip:setY(my);

        self.tooltip:setWidth(50)
        self.tooltip:setMeasureOnly(true)
        self.item:DoTooltip(self.tooltip);
        self.tooltip:setMeasureOnly(false)

        local myCore = getCore();
        local maxX = myCore:getScreenWidth();
        local maxY = myCore:getScreenHeight();

        local font_name = UIFont.Medium;
        local font_size = getCore():getOptionTooltipFont();

        if font_size == "Large" then
            PX_LETTER = 9;
            font_name = UIFont.Large;
        elseif font_size == "Small" then
            PX_LETTER = 6;
            font_name = UIFont.Small;
        elseif font_size == "Medium" then
            PX_LETTER = 8;
            font_name = UIFont.Medium;
        end

        local lh = getTextManager():getFontFromEnum(font_name):getLineHeight(); --height dimesion of one line

        local tw = self.tooltip:getWidth();
        local th = self.tooltip:getHeight();
        if LeGourmetMod ~= nil then
            --+++++ Mostrar el tipo de indumentaria ++++++--
            --if self.item:getCategory() == "Clothing" then
            --	self.tooltip:DrawText(self.tooltip:getFont(), self.item:getType(), 5, (self.tooltip:getHeight() + lh * 0.2), 1,1,0.8,self.borderColor.a);
            --end
            --if self.item and instanceof(self.item, "Moveable") and self.item:getCustomNameFull() then
            --	self.tooltip:DrawText(self.tooltip:getFont(), self.item:getCustomNameFull(), 5, (self.tooltip:getHeight() + lh * 0.2), 1,1,0.8,self.borderColor.a);
            --end
            --if self.item and instanceof(self.item, "Moveable") and self.item:getTexture() and self.item:getTexture():getName() then
            --	self.tooltip:DrawText(self.tooltip:getFont(), self.item:getTexture():getName(), 5, (self.tooltip:getHeight() + lh * 0.2), 1,1,0.8,self.borderColor.a);
            --end


            if self.item:getCategory() == "Food" then
                if self.item:getType() == "Cigarettes"
                        or self.item:getType() == "Bleach"
                        or self.item:getType() == "Worm"
                        or self.item:getType() == "RedWorm"
                        or self.item:getType() == "ZAWRawBrickPack"
                        or self.item:getType() == "Sugarcane"
                        or self.item:getType() == "SugarcanePile" then
                    --nothing
                else
                    local hasTrait = nil;
                    local cookingLevel = getPlayer():getPerkLevel(Perks.Cooking);
                    if getPlayer(0):HasTrait("foodexpiration") or getPlayer(0):HasTrait("foodexpiration2") then
                        hasTrait = true;
                    end
                    if cookingLevel >= 4 and cookingLevel < 6 then
                        if font_size == "Small" then
                            -- nothing
                        elseif font_size == "Large" then
                            if tw < 230 then
                                local calc = 230 - tw;
                                tw = tw + calc;
                            end
                        else
                            if tw < 200 then
                                local calc = 200 - tw;
                                tw = tw + calc;
                            end
                        end
                    elseif hasTrait ~= nil or cookingLevel >= 6 then
                        local total = self.item:getScriptItem():getDaysTotallyRotten();
                        if total > 1000 or self.item:getAge() == nil or tostring(self.item:getAge()) == "nan" then
                            if font_size == "Small" then
                                -- nothing
                            elseif font_size == "Large" then
                                if tw < 230 then
                                    local calc = 230 - tw;
                                    tw = tw + calc;
                                end
                            else
                                if tw < 200 then
                                    local calc = 200 - tw;
                                    tw = tw + calc;
                                end
                            end                            --nothing
                        else
                            --getPlayer():Say(tostring(tw))
                            if font_size == "Small" then
                                if tw < 230 then
                                    local calc = 230 - tw;
                                    tw = tw + calc;
                                end
                            elseif font_size == "Large" then
                                if tw < 350 then
                                    local calc = 350 - tw;
                                    tw = tw + calc;
                                end
                            else
                                if tw < 310 then
                                    local calc = 310 - tw;
                                    tw = tw + calc;
                                end
                            end
                        end
                    else
                        tw = tw;
                        th = th;
                    end
                end
            end

            if self.item:getType() == "Stone" then
                local modData = self.item:getModData();
                if not modData.durability then

                else
                    if font_size == "Small" then
                        -- nothing
                    elseif font_size == "Large" then
                        if tw < 180 then
                            local calc = 180 - tw;
                            tw = tw + calc;
                        end
                    else
                        if tw < 160 then
                            local calc = 160 - tw;
                            tw = tw + calc;
                        end
                    end
                    --tw = tw + lh;
                end
            end
        end

        if LeGourmetMod ~= nil then

            if self.item:getType() == "BaitFish"
                    or self.item:getType() == "Crab"
                    or self.item:getType() == "Crayfish"
                    or self.item:getType() == "Dentudo"
                    or self.item:getType() == "Anguila"
                    or self.item:getType() == "Palometa"
                    or self.item:getType() == "Piranha"
                    or self.item:getType() == "Crappie"
                    or self.item:getType() == "Panfish"
                    or self.item:getType() == "Payara"
                    or self.item:getType() == "Carp"
                    or self.item:getType() == "Peje"
                    or self.item:getType() == "Waterturtle"
                    or self.item:getType() == "Perch"
                    or self.item:getType() == "Bass"
                    or self.item:getType() == "Trout"
                    or self.item:getType() == "Catfish"
                    or self.item:getType() == "Dorado"
                    or self.item:getType() == "Tucunare"
                    or self.item:getType() == "Pacu"
                    or self.item:getType() == "Tararira"
                    or self.item:getType() == "Walleye"
                    or self.item:getType() == "Pati"
                    or self.item:getType() == "Snakehead"
                    or self.item:getType() == "Pike"
                    or self.item:getType() == "Arowana"
                    or self.item:getType() == "FSalmon"
                    or self.item:getType() == "RainbowTrout"
                    or self.item:getType() == "Tarpon"
                    or self.item:getType() == "Surubi"
                    or self.item:getType() == "Piraiba"
                    or self.item:getType() == "Rtcatfish"
                    or self.item:getType() == "Arapaima"
                    or self.item:getType() == "Ray" then
                self:MakeFishState(self.item, lh, tw, th, self.tooltip);
            end

            if self.item:isFishingLure() then
                self:MakeLureInfo(self.item, lh, tw, th, self.tooltip);
            end

            if self.item:getCategory() == "Food" then
                self:MakeFoodInfo(self.item, lh, tw, th, self.tooltip);
            end

            --if self.item:getType() == "Stone" then
                --self:DoStoneInfo(self.item, lh, tw, th, self.tooltip);
            --end

        end
        
        self.item:DoTooltip(self.tooltip);
    end
end

function ISToolTipInv:round2(num, idp)
    return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end