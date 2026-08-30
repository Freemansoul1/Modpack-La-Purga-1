

ISBuildMenu.onWoodenFloorUnderWater = function(worldobjects, square, sprite, player)
    -- sprite, northSprite
    local foor = ISWoodenFloorUnderWater:new(sprite.sprite, sprite.northSprite)
    foor.modData["need:Base.Log"] = "0";
    foor.modData["need:Base.Plank"] = "0";
    foor.modData["need:Base.Nails"] = "0";
    foor.modData["need:Aquatsar.TireTube"] = "0";
    foor.modData["xp:Woodwork"] = 1;
    foor.player = player
    getCell():setDrag(foor, player);
end

ISBuildMenu.newCanBuild = function(logNb, plankNb, nailsNb, tireTubeNb, carpentrySkill, option, player)
    -- create a new tooltip
    local tooltip = ISBuildMenu.addToolTip();
    -- add it to our current option
    option.toolTip = tooltip;
    local result = true;
    tooltip.description = "<LINE> <LINE>" .. getText("Tooltip_craft_Needs") .. ": <LINE>";
    ISBuildMenu.log = ISBuildMenu.countMaterial(player, "Base.Log")
    ISBuildMenu.tireTube = ISBuildMenu.countMaterial(player, "Aquatsar.TireTube")
    
    -- now we gonna test all the needed material, if we don't have it, they'll be in red into our toolip
    
    if ISBuildMenu.log < logNb then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemNameFromFullType("Base.Log") .. " " .. ISBuildMenu.log .. "/" .. logNb .. " <LINE>";
        result = false;
    elseif logNb > 0 then
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemNameFromFullType("Base.Log") .. " " .. ISBuildMenu.log .. "/" .. logNb .. " <LINE>";
    end

    if ISBuildMenu.planks < plankNb then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemNameFromFullType("Base.Plank") .. " " .. ISBuildMenu.planks .. "/" .. plankNb .. " <LINE>";
        result = false;
    elseif plankNb > 0 then
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemNameFromFullType("Base.Plank") .. " " .. ISBuildMenu.planks .. "/" .. plankNb .. " <LINE>";
    end
    
    if ISBuildMenu.nails < nailsNb then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemNameFromFullType("Base.Nails") .. " " .. ISBuildMenu.nails .. "/" .. nailsNb .. " <LINE>";
        result = false;
    elseif nailsNb > 0 then
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemNameFromFullType("Base.Nails") .. " " .. ISBuildMenu.nails .. "/" .. nailsNb .. " <LINE>";
    end
    
    if ISBuildMenu.tireTube < tireTubeNb then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemNameFromFullType("Aquatsar.TireTube") .. " " .. ISBuildMenu.tireTube .. "/" .. tireTubeNb .. " <LINE>";
        result = false;
    elseif tireTubeNb > 0 then
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemNameFromFullType("Aquatsar.TireTube") .. " " .. ISBuildMenu.tireTube .. "/" .. tireTubeNb .. " <LINE>";
    end
    
    if getSpecificPlayer(player):getPerkLevel(Perks.Woodwork) < carpentrySkill then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getText("IGUI_perks_Carpentry") .. " " .. getSpecificPlayer(player):getPerkLevel(Perks.Woodwork) .. "/" .. carpentrySkill .. " <LINE>";
        result = false;
    elseif carpentrySkill > 0 then
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getText("IGUI_perks_Carpentry") .. " " .. getSpecificPlayer(player):getPerkLevel(Perks.Woodwork) .. "/" .. carpentrySkill .. " <LINE>";
    end
    if ISBuildMenu.cheat then
        return tooltip;
    end
    if not result then
        option.onSelect = nil;
        option.notAvailable = true;
    end
    tooltip.description = " " .. tooltip.description .. " "
    return tooltip;
end
