local onWoodenChevalDeFrise = function(worldobjects, sprite, player)
    local defense = ISDoubleTileDefense:new("WoodenChevalDeFrise", sprite.sprite, sprite.sprite2, sprite.northSprite, sprite.northSprite2)
	defense:setSprite(sprite.sprite)
	defense:setNorthSprite(sprite.northSprite)
    defense.modData["xp:Woodwork"] = 2
    defense.modData["need:Base.Plank"] = "9" 
    local sheets = ISBuildMenu.countMaterial(player, "Base.RippedSheets");
	local sheetsDirty = ISBuildMenu.countMaterial(player, "Base.RippedSheetsDirty");
	if sheets >= 4 then sheets = 4; sheetsDirty = 0 end
	if sheetsDirty >= 4 then sheetsDirty = 4; sheets = 0 end
	if sheets < 4 and sheetsDirty > 0 then sheetsDirty = 4 - sheets; end
    if sheets + sheetsDirty >= 4 then
		if sheets > 0 then defense.modData["need:Base.RippedSheets"] = tostring(sheets); end
		if sheetsDirty > 0 then defense.modData["need:Base.RippedSheetsDirty"] = tostring(sheetsDirty); end 
    end
    defense.player = player
    defense.completionSound = "BuildWoodenStructureLarge"
    defense.modData.BarricadeDamageMultiplier = SandboxVars.ChevalDeFrise.WoodDamage
    getCell():setDrag(defense, player)
end

-- Display ObjectDefense tooltip and if buildable  
local WoodenChevalDeFrise = function(subMenu, sprite, player)
	local option_name = getText("ContextMenu_WoodenChevalDeFrise")
	WoodenChevalDeFriseOption = subMenu:addOption(option_name, worldobjects, onWoodenChevalDeFrise, sprite, player)
	-- create a new tooltip
	local tooltip = ISBuildMenu.addToolTip()
	WoodenChevalDeFriseOption.toolTip = tooltip
	local result = true
	tooltip.description = "<LINE> <LINE>" .. getText("Tooltip_craft_Needs") .. ": <LINE>"
	-- check for material count
	local plank = ISBuildMenu.countMaterial(player, "Base.Plank")
	local plank_required = 9
	if plank < plank_required then
		tooltip.description = tooltip.description .. " <RGB:1,0,0> " .. getItemNameFromFullType("Base.Plank") .. " " .. plank .. "/" .. plank_required .. " <LINE>";
		result = false
	elseif plank > 0 then
		tooltip.description = tooltip.description .. " <RGB:0,1,0> " .. getItemNameFromFullType("Base.Plank") .. " " .. plank .. "/" .. plank_required .. " <LINE>";
	end
	local sheets = ISBuildMenu.countMaterial(player, "Base.RippedSheets") + ISBuildMenu.countMaterial(player, "Base.RippedSheetsDirty")
	local sheets_required = 4
	if sheets < sheets_required then
		tooltip.description = tooltip.description .. " <RGB:1,0,0> " .. getItemNameFromFullType("Base.RippedSheets") .. " " .. sheets .. "/" .. sheets_required .. " <LINE>";
		result = false 
	elseif sheets > 0 then
		tooltip.description = tooltip.description .. " <RGB:0,1,0> " .. getItemNameFromFullType("Base.RippedSheets") .. " " .. sheets .. "/" .. sheets_required .. " <LINE>";
	end
	
	-- check for specific skill
	local carpentry_skill = getSpecificPlayer(player):getPerkLevel(Perks.Woodwork) 
	local carpentry_skill_required = 3
	if carpentry_skill < carpentry_skill_required then
		tooltip.description = tooltip.description .. " <RGB:1,0,0> " .. getText("IGUI_perks_Carpentry") .. " " .. carpentry_skill .. "/" .. carpentry_skill_required .. " <LINE>";
		result = false
	elseif carpentry_skill > 0 then
		tooltip.description = tooltip.description .. " <RGB:0,1,0> " .. getText("IGUI_perks_Carpentry") .. " " .. carpentry_skill .. "/" .. carpentry_skill_required .. " <LINE>";
	end 
	if not result and not ISBuildMenu.cheat then
		WoodenChevalDeFriseOption.onSelect = nil
		WoodenChevalDeFriseOption.notAvailable = true
	end
	tooltip.description = " " .. tooltip.description .. " "
	tooltip:setName(option_name)
	tooltip.description = getText("Tooltip_WoodenChevalDeFrise") .. tooltip.description
	tooltip:setTexture(sprite.sprite)
	ISBuildMenu.requireHammer(WoodenChevalDeFriseOption)
end

local function doBuildDefensesMenu(player, context, worldobjects)
	local buildMenu = context:getOptionFromName(getText("ContextMenu_Build"))
    if buildMenu then
		local subMenu = context:getSubMenu(buildMenu.subOption)
	-- Add our menu after vanilla one
		-- Add Wooden cheval de frise option
		sprite = {sprite="defenses_01_2", sprite2= "defenses_01_1",  northSprite= "defenses_01_4",  northSprite2= "defenses_01_3"}
		WoodenChevalDeFrise(subMenu, sprite, player)
	end
end

Events.OnFillWorldObjectContextMenu.Add(doBuildDefensesMenu)
