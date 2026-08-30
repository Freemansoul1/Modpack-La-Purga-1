require "ISUI/ISWorldObjectContextMenu"

function Work_Stations4(player, context, worldobjects, test)

	if test and ISWorldObjectContextMenu.Test then return true end
	
	if getCore():getGameMode()=="LastStand" then
		return;
	end
	
	if test then return ISWorldObjectContextMenu.setTest() end

	scavengeZone = nil;
	local playerObj = getSpecificPlayer(player)
	local x1 = getPlayer():getX();
	local y1 = getPlayer():getY();
	local z1 = getPlayer():getZ();
	
	if playerObj:getVehicle() then return; end


	local Cain
	local Abel

	local computer2 -- комп

	

	for i, v in ipairs(worldobjects) do
		
		if v:getSprite():getName() == nil then return; end
		local spriteName = v:getSprite():getName()
		x = v:getX();
		y = v:getY();
		if spriteName == "Cain_0"
		then
			Cain = v;
		elseif spriteName == "Abel_0"
		then
			Abel = v;
		elseif spriteName == "appliances_com_01_77" or spriteName == "appliances_com_01_76"
		or spriteName == "appliances_com_01_72" or spriteName == "appliances_com_01_73"
		or spriteName == "appliances_com_01_74" or spriteName == "appliances_com_01_75"
		or spriteName == "appliances_com_01_78" or spriteName == "appliances_com_01_79"
		then
			computer2 = v;
		end
	end
	
	local MineEnd = getPlayer():getXp():getXP(Perks.MineEndurance)
	local DocRep = getPlayer():getXp():getXP(Perks.RepDoc)
	local DocTaskTaken = getPlayer():HasTrait('task_start_med')
	local End = getPlayer():getStats():getEndurance()
	local Fatique = getPlayer():getStats():getFatigue()
	
--КАИН ОРУЖЕЙНИК
	if Cain and getPlayer():DistToSquared(x, y) <= 6 then
		local option_cain_hello = context:addOption(getText("ContextMenu_Cain_Hello"), worldobjects, CainHello, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_cain_hello.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_Cain_Hello"));
		toolTip:setTexture("Cain_0");
		toolTip.description = getText("Tooltip_Cain_Hello");
	
		local option_cain_quests = context:addOption(getText("ContextMenu_Quests"), worldobjects, nil)
		local subMenu = context:getNew(context);
		context:addSubMenu(option_cain_quests, subMenu);

		local option_cain_quests_ar = subMenu:addOption(getText("ContextMenu_ARQuests"), worldobjects, nil)
		local subsubMenu = subMenu:getNew(subMenu);
		context:addSubMenu(option_cain_quests_ar, subsubMenu);

		local option_cain_quests_r = subMenu:addOption(getText("ContextMenu_RQuests"), worldobjects, nil)
		local subsubMenu2 = subMenu:getNew(subMenu);
		context:addSubMenu(option_cain_quests_r, subsubMenu2);

		--КВЕСТ 1 АВТОМАТ
		local option_cain_quest1_ar = subsubMenu:addOption(getText("ContextMenu_CainQuest1AR"), worldobjects, CainQuest1AR, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_cain_quest1_ar.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CainQuest1AR"));
		toolTip:setTexture("Cain_0");
		toolTip.description = getText("Tooltip_CainQuest1AR");
		if getPlayer():HasTrait('task_start_army') or getPlayer():HasTrait('task_start_army2')
		or getPlayer():HasTrait('task_start_army3') or getPlayer():HasTrait('task_start_army4')
		or getPlayer():HasTrait('task_start_army5') or getPlayer():HasTrait('task_start_army6')
		or getPlayer():HasTrait('task_start_army7') or getPlayer():HasTrait('task_start_army8')
		or getPlayer():HasTrait('task_start_army9') or getPlayer():HasTrait('task_start_army10')
		or getPlayer():HasTrait('task_start_army11') or getPlayer():HasTrait('task_start_army12')
		then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_cain_quest1_ar.notAvailable = true;
		end
		if getPlayer():HasTrait('quest_cd') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_cain_quest1_ar.notAvailable = true;
		end

		-- ЗАВЕРШИТЬ КВЕСТ 1 АВТОМАТ
		local option_cain_quest1_ar_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, CainQuest1ARComplete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_cain_quest1_ar_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Cain_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not (getPlayer():HasTrait('task_start_army'))
		or not (getPlayer():getInventory():contains("QuestAEmptyFlash"))
		then
			context:removeLastOption();
		end
		if getPlayer():HasTrait('quest_cd') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_cain_quest1_ar_complete.notAvailable = true;
		end

		--КВЕСТ 2 АВТОМАТ
		local option_cain_quest2_ar = subsubMenu:addOption(getText("ContextMenu_CainQuest2AR"), worldobjects, CainQuest2AR, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_cain_quest2_ar.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CainQuest2AR"));
		toolTip:setTexture("Cain_0");
		toolTip.description = getText("Tooltip_CainQuest2AR");
		if getPlayer():HasTrait('task_start_army') or getPlayer():HasTrait('task_start_army2')
		or getPlayer():HasTrait('task_start_army3') or getPlayer():HasTrait('task_start_army4')
		or getPlayer():HasTrait('task_start_army5') or getPlayer():HasTrait('task_start_army6')
		or getPlayer():HasTrait('task_start_army7') or getPlayer():HasTrait('task_start_army8')
		or getPlayer():HasTrait('task_start_army9') or getPlayer():HasTrait('task_start_army10')
		or getPlayer():HasTrait('task_start_army11') or getPlayer():HasTrait('task_start_army12')
		then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_cain_quest2_ar.notAvailable = true;
		end
		if getPlayer():HasTrait('quest_cd') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_cain_quest2_ar.notAvailable = true;
		end

		-- ЗАВЕРШИТЬ КВЕСТ 2 АВТОМАТ
		local option_cain_quest2_ar_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, CainQuest2ARComplete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_cain_quest2_ar_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Cain_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not (getPlayer():HasTrait('task_start_army2'))
		or not (getPlayer():getInventory():contains("QuestAFullDisk"))
		then
			context:removeLastOption();
		end
		if getPlayer():HasTrait('quest_cd') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_cain_quest2_ar_complete.notAvailable = true;
		end

		--КВЕСТ 1 ВИНТОВКА
		local option_cain_quest1_r = subsubMenu2:addOption(getText("ContextMenu_CainQuest1R"), worldobjects, CainQuest1R, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_cain_quest1_r.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CainQuest1R"));
		toolTip:setTexture("Cain_0");
		toolTip.description = getText("Tooltip_CainQuest1R");
		if getPlayer():HasTrait('task_start_army') or getPlayer():HasTrait('task_start_army2')
		or getPlayer():HasTrait('task_start_army3') or getPlayer():HasTrait('task_start_army4')
		or getPlayer():HasTrait('task_start_army5') or getPlayer():HasTrait('task_start_army6')
		or getPlayer():HasTrait('task_start_army7') or getPlayer():HasTrait('task_start_army8')
		or getPlayer():HasTrait('task_start_army9') or getPlayer():HasTrait('task_start_army10')
		or getPlayer():HasTrait('task_start_army11') or getPlayer():HasTrait('task_start_army12') 
		then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_cain_quest1_r.notAvailable = true;
		end
		if getPlayer():HasTrait('quest_cd') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_cain_quest1_r.notAvailable = true;
		end

		-- ЗАВЕРШИТЬ КВЕСТ 1 ВИНТОВКА
		local option_cain_quest1_r_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, CainQuest1RComplete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_cain_quest1_r_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Cain_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not (getPlayer():HasTrait('task_start_army3'))
		or not (getPlayer():getInventory():contains("QuestAToken") and getPlayer():getInventory():getItemCount("QuestAToken") >= 20)
		then
			context:removeLastOption();
		end
		if getPlayer():HasTrait('quest_cd') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_cain_quest1_r_complete.notAvailable = true;
		end

		--КВЕСТ 2 ВИНТОВКА
		local option_cain_quest2_r = subsubMenu2:addOption(getText("ContextMenu_CainQuest2R"), worldobjects, CainQuest2R, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_cain_quest2_r.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CainQuest2R"));
		toolTip:setTexture("Cain_0");
		toolTip.description = getText("Tooltip_CainQuest2R");
		if getPlayer():HasTrait('task_start_army') or getPlayer():HasTrait('task_start_army2')
		or getPlayer():HasTrait('task_start_army3') or getPlayer():HasTrait('task_start_army4')
		or getPlayer():HasTrait('task_start_army5') or getPlayer():HasTrait('task_start_army6')
		or getPlayer():HasTrait('task_start_army7') or getPlayer():HasTrait('task_start_army8')
		or getPlayer():HasTrait('task_start_army9') or getPlayer():HasTrait('task_start_army10')
		or getPlayer():HasTrait('task_start_army11') or getPlayer():HasTrait('task_start_army12') 
		then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_cain_quest2_r.notAvailable = true;
		end
		if getPlayer():HasTrait('quest_cd') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_cain_quest2_r.notAvailable = true;
		end

		-- ЗАВЕРШИТЬ КВЕСТ 2 ВИНТОВКА
		local option_cain_quest2_r_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, CainQuest2RComplete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_cain_quest2_r_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Cain_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not (getPlayer():HasTrait('task_start_army4'))
		or not (getPlayer():getInventory():contains("QuestAToken") and getPlayer():getInventory():getItemCount("QuestAToken") >= 40)
		then
			context:removeLastOption();
		end
		if getPlayer():HasTrait('quest_cd') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_cain_quest2_r_complete.notAvailable = true;
		end


	-- АВЕЛЬ ОРУЖЕЙНИК
elseif Abel and getPlayer():DistToSquared(x, y) <= 6 then
	local option_abel_hello = context:addOption(getText("ContextMenu_Abel_Hello"), worldobjects, AbelHello, player);
	local toolTip = ISToolTip:new();
	toolTip:initialise();
	toolTip:setVisible(false);
	option_abel_hello.toolTip = toolTip;
	toolTip:setName(getText("ContextMenu_Abel_Hello"));
	toolTip:setTexture("Abel_0");
	toolTip.description = getText("Tooltip_Abel_Hello");

	local option_abel_quests = context:addOption(getText("ContextMenu_Quests"), worldobjects, nil)
	local subMenu = context:getNew(context);
	context:addSubMenu(option_abel_quests, subMenu);

	local option_abel_quests_p = subMenu:addOption(getText("ContextMenu_PQuests"), worldobjects, nil)
	local subsubMenu = subMenu:getNew(subMenu);
	context:addSubMenu(option_abel_quests_p, subsubMenu);

	local option_abel_quests_s = subMenu:addOption(getText("ContextMenu_SQuests"), worldobjects, nil)
	local subsubMenu2 = subMenu:getNew(subMenu);
	context:addSubMenu(option_abel_quests_s, subsubMenu2);

	local option_abel_quests_smg = subMenu:addOption(getText("ContextMenu_SMGQuests"), worldobjects, nil)
	local subsubMenu3 = subMenu:getNew(subMenu);
	context:addSubMenu(option_abel_quests_smg, subsubMenu3);

	--КВЕСТ 1 ПИСТОЛЕТ
	local option_abel_quest1_p = subsubMenu:addOption(getText("ContextMenu_AbelQuest1P"), worldobjects, AbelQuest1P, player)
	local toolTip = ISToolTip:new();
	toolTip:initialise();
	toolTip:setVisible(false);
	option_abel_quest1_p.toolTip = toolTip;
	toolTip:setName(getText("ContextMenu_AbelQuest1P"));
	toolTip:setTexture("Abel_0");
	toolTip.description = getText("Tooltip_AbelQuest1P");
	if getPlayer():HasTrait('task_start_army') or getPlayer():HasTrait('task_start_army2')
	or getPlayer():HasTrait('task_start_army3') or getPlayer():HasTrait('task_start_army4')
	or getPlayer():HasTrait('task_start_army5') or getPlayer():HasTrait('task_start_army6')
	or getPlayer():HasTrait('task_start_army7') or getPlayer():HasTrait('task_start_army8')
	or getPlayer():HasTrait('task_start_army9') or getPlayer():HasTrait('task_start_army10')
	or getPlayer():HasTrait('task_start_army11') or getPlayer():HasTrait('task_start_army12')
	then
		toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
		option_abel_quest1_p.notAvailable = true;
	end
	if getPlayer():HasTrait('quest_cd') then
		toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
		option_abel_quest1_p.notAvailable = true;
	end

	-- ЗАВЕРШИТЬ КВЕСТ 1 ПИСТОЛЕТ
	local option_abel_quest1_p_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, AbelQuest1PComplete, player)
	local toolTip = ISToolTip:new();
	toolTip:initialise();
	toolTip:setVisible(false);
	option_abel_quest1_p_complete.toolTip = toolTip;
	toolTip:setName(getText("ContextMenu_CompleteQuest"));
	toolTip:setTexture("Abel_0");
	toolTip.description = getText("Tooltip_CompleteQuest");
	if not (getPlayer():HasTrait('task_start_army5'))
		or not ((getPlayer():getInventory():contains("CannedPineapple") and getPlayer():getInventory():getItemCount("CannedPineapple") >= 5)
		or  (getPlayer():getInventory():contains("CannedBolognese") and getPlayer():getInventory():getItemCount("CannedBolognese") >= 5)
		or  (getPlayer():getInventory():contains("CannedPeas") and getPlayer():getInventory():getItemCount("CannedPeas") >= 5)
		or  (getPlayer():getInventory():contains("CannedMushroomSoup") and getPlayer():getInventory():getItemCount("CannedMushroomSoup") >= 5)
		or  (getPlayer():getInventory():contains("CannedPotato2") and getPlayer():getInventory():getItemCount("CannedPotato2") >= 5)
		or  (getPlayer():getInventory():contains("CannedCorn") and getPlayer():getInventory():getItemCount("CannedCorn") >= 5)
		or  (getPlayer():getInventory():contains("CannedCarrots2") and getPlayer():getInventory():getItemCount("CannedCarrots2") >= 5)
		or  (getPlayer():getInventory():contains("CannedChili") and getPlayer():getInventory():getItemCount("CannedChili") >= 5)
		or  (getPlayer():getInventory():contains("CannedPeaches") and getPlayer():getInventory():getItemCount("CannedPeaches") >= 5)
		or  (getPlayer():getInventory():contains("CannedSardines") and getPlayer():getInventory():getItemCount("CannedSardines") >= 5)
		or  (getPlayer():getInventory():contains("CannedCornedBeef") and getPlayer():getInventory():getItemCount("CannedCornedBeef") >= 5)
		or  (getPlayer():getInventory():contains("TinnedSoup") and getPlayer():getInventory():getItemCount("TinnedSoup") >= 5)
		or  (getPlayer():getInventory():contains("CannedTomato2") and getPlayer():getInventory():getItemCount("CannedTomato2") >= 5)
		or  (getPlayer():getInventory():contains("TunaTin") and getPlayer():getInventory():getItemCount("TunaTin") >= 5)
		or  (getPlayer():getInventory():contains("TinnedBeans") and getPlayer():getInventory():getItemCount("TinnedBeans") >= 5)
		or  (getPlayer():getInventory():contains("CannedFruitCocktail") and getPlayer():getInventory():getItemCount("CannedFruitCocktail") >= 5))
		then
			context:removeLastOption();
		end
		if getPlayer():HasTrait('quest_cd') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_abel_quest1_p_complete.notAvailable = true;
		end

	--КВЕСТ 1 ДРОБОВИК
	local option_abel_quest1_s = subsubMenu2:addOption(getText("ContextMenu_AbelQuest1S"), worldobjects, AbelQuest1S, player)
	local toolTip = ISToolTip:new();
	toolTip:initialise();
	toolTip:setVisible(false);
	option_abel_quest1_s.toolTip = toolTip;
	toolTip:setName(getText("ContextMenu_AbelQuest1S"));
	toolTip:setTexture("Abel_0");
	toolTip.description = getText("Tooltip_AbelQuest1S");
	if getPlayer():HasTrait('task_start_army') or getPlayer():HasTrait('task_start_army2')
	or getPlayer():HasTrait('task_start_army3') or getPlayer():HasTrait('task_start_army4')
	or getPlayer():HasTrait('task_start_army5') or getPlayer():HasTrait('task_start_army6')
	or getPlayer():HasTrait('task_start_army7') or getPlayer():HasTrait('task_start_army8')
	or getPlayer():HasTrait('task_start_army9') or getPlayer():HasTrait('task_start_army10')
	or getPlayer():HasTrait('task_start_army11') or getPlayer():HasTrait('task_start_army12')
	then
		toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
		option_abel_quest1_s.notAvailable = true;
	end
	if getPlayer():HasTrait('quest_cd') then
		toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
		option_abel_quest1_s.notAvailable = true;
	end

	-- ЗАВЕРШИТЬ КВЕСТ 1 ДРОБОВИК
	local option_abel_quest1_s_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, AbelQuest1SComplete, player)
	local toolTip = ISToolTip:new();
	toolTip:initialise();
	toolTip:setVisible(false);
	option_abel_quest1_s_complete.toolTip = toolTip;
	toolTip:setName(getText("ContextMenu_CompleteQuest"));
	toolTip:setTexture("Abel_0");
	toolTip.description = getText("Tooltip_CompleteQuest");
	if not (getPlayer():HasTrait('task_start_army6'))
		or not ((getPlayer():getInventory():contains("Jacket_ArmyCamoGreen") and getPlayer():getInventory():getItemCount("Jacket_ArmyCamoGreen") >= 2
		and getPlayer():getInventory():contains("Trousers_CamoGreen") and getPlayer():getInventory():getItemCount("Trousers_CamoGreen") >= 2
		and getPlayer():getInventory():contains("Shoes_ArmyBoots") and getPlayer():getInventory():getItemCount("Shoes_ArmyBoots") >= 2)
		or (getPlayer():getInventory():contains("Jacket_ArmyCamoDesert") and getPlayer():getInventory():getItemCount("Jacket_ArmyCamoDesert") >= 2
		and getPlayer():getInventory():contains("Trousers_CamoDesert") and getPlayer():getInventory():getItemCount("Trousers_CamoDesert") >= 2
		and getPlayer():getInventory():contains("Shoes_ArmyBootsDesert") and getPlayer():getInventory():getItemCount("Shoes_ArmyBootsDesert") >= 2))
		then
			context:removeLastOption();
		end
		if getPlayer():HasTrait('quest_cd') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_abel_quest1_s_complete.notAvailable = true;
		end

	--КВЕСТ 1 ПП
	local option_abel_quest1_smg = subsubMenu3:addOption(getText("ContextMenu_AbelQuest1SMG"), worldobjects, AbelQuest1SMG, player)
	local toolTip = ISToolTip:new();
	toolTip:initialise();
	toolTip:setVisible(false);
	option_abel_quest1_smg.toolTip = toolTip;
	toolTip:setName(getText("ContextMenu_AbelQuest1SMG"));
	toolTip:setTexture("Abel_0");
	toolTip.description = getText("Tooltip_AbelQuest1SMG");
	if getPlayer():HasTrait('task_start_army') or getPlayer():HasTrait('task_start_army2')
	or getPlayer():HasTrait('task_start_army3') or getPlayer():HasTrait('task_start_army4')
	or getPlayer():HasTrait('task_start_army5') or getPlayer():HasTrait('task_start_army6')
	or getPlayer():HasTrait('task_start_army7') or getPlayer():HasTrait('task_start_army8')
	or getPlayer():HasTrait('task_start_army9') or getPlayer():HasTrait('task_start_army10')
	or getPlayer():HasTrait('task_start_army11') or getPlayer():HasTrait('task_start_army12')
	then
		toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
		option_abel_quest1_smg.notAvailable = true;
	end
	if getPlayer():HasTrait('quest_cd') then
		toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
		option_abel_quest1_smg.notAvailable = true;
	end

	-- ЗАВЕРШИТЬ КВЕСТ 1 ПП
	local option_abel_quest1_smg_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, AbelQuest1SMGComplete, player)
	local toolTip = ISToolTip:new();
	toolTip:initialise();
	toolTip:setVisible(false);
	option_abel_quest1_smg_complete.toolTip = toolTip;
	toolTip:setName(getText("ContextMenu_CompleteQuest"));
	toolTip:setTexture("Abel_0");
	toolTip.description = getText("Tooltip_CompleteQuest");
	if not getPlayer():HasTrait('task_start_army7') or not (getPlayer():getInventory():contains("QuestAFullAirAnalyzer"))
		then
			context:removeLastOption();
		end
		if getPlayer():HasTrait('quest_cd') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_abel_quest1_smg_complete.notAvailable = true;
		end

	--КВЕСТ 2 ПП
	local option_abel_quest2_smg = subsubMenu3:addOption(getText("ContextMenu_AbelQuest2SMG"), worldobjects, AbelQuest2SMG, player)
	local toolTip = ISToolTip:new();
	toolTip:initialise();
	toolTip:setVisible(false);
	option_abel_quest2_smg.toolTip = toolTip;
	toolTip:setName(getText("ContextMenu_AbelQuest2SMG"));
	toolTip:setTexture("Abel_0");
	toolTip.description = getText("Tooltip_AbelQuest2SMG");
	if getPlayer():HasTrait('task_start_army') or getPlayer():HasTrait('task_start_army2')
	or getPlayer():HasTrait('task_start_army3') or getPlayer():HasTrait('task_start_army4')
	or getPlayer():HasTrait('task_start_army5') or getPlayer():HasTrait('task_start_army6')
	or getPlayer():HasTrait('task_start_army7') or getPlayer():HasTrait('task_start_army8')
	or getPlayer():HasTrait('task_start_army9') or getPlayer():HasTrait('task_start_army10')
	or getPlayer():HasTrait('task_start_army11') or getPlayer():HasTrait('task_start_army12') 
	then
		toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
		option_abel_quest2_smg.notAvailable = true;
	end
	if getPlayer():HasTrait('quest_cd') then
		toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
		option_abel_quest2_smg.notAvailable = true;
	end

	-- ЗАВЕРШИТЬ КВЕСТ 2 ПП
	local option_abel_quest2_smg_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, AbelQuest2SMGComplete, player)
	local toolTip = ISToolTip:new();
	toolTip:initialise();
	toolTip:setVisible(false);
	option_abel_quest2_smg_complete.toolTip = toolTip;
	toolTip:setName(getText("ContextMenu_CompleteQuest"));
	toolTip:setTexture("Abel_0");
	toolTip.description = getText("Tooltip_CompleteQuest");
	if not getPlayer():HasTrait('task_start_army8')	or not getPlayer():getInventory():contains("QuestAFullRadAnalyzer")
		then
			context:removeLastOption();
		end
		if getPlayer():HasTrait('quest_cd') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_abel_quest2_smg_complete.notAvailable = true;
		end


	elseif computer2 and getPlayer():DistToSquared(x, y) <= 6 and x1 >= 12162 and x1 <= 12216 and y1 >= 1363 and y1 <= 1417 and computer2:getSquare():haveElectricity() then 
		local option_cainquest2ar_do = context:addOption(getText("ContextMenu_CainQuest2AR"), worldobjects, Computer3, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_cainquest2ar_do.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CainQuest2AR"));
		toolTip:setTexture("appliances_com_01_77");
		if not getPlayer():HasTrait('task_start_army2') then 
			context:removeLastOption();
		end
		if not getPlayer():getInventory():contains("QuestADisk") then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_CainQuest2ARNotComplete") .. "\n";
			option_cainquest2ar_do.notAvailable = true;
		end

	elseif computer2 and getPlayer():DistToSquared(x, y) <= 6 and computer2:getSquare():haveElectricity() then
		local option_cainquest1ar_do = context:addOption(getText("ContextMenu_CainQuest1AR"), worldobjects, Computer2, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_cainquest1ar_do.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CainQuest1AR"));
		toolTip:setTexture("appliances_com_01_77");
		if not getPlayer():HasTrait('task_start_army') then 
			context:removeLastOption();
		end
		if not getPlayer():getInventory():contains("QuestAFlash") then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_CainQuest1ARNotComplete") .. "\n";
			option_cainquest1ar_do.notAvailable = true;
		end

		
end
end

CainHello = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Cain.png>" .."<LINE><LINE>".. getText("Tooltip_Cain_Dialogue_Hello") .."\n")
	QuestWindow:setVisible(true);
end

AbelHello = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Abel.png>" .."<LINE><LINE>".. getText("Tooltip_Abel_Dialogue_Hello") .."\n")
	QuestWindow:setVisible(true);
end

--КАИН ЗАДАНИЕ 1 АВТОМАТ
CainQuest1AR = function(worldobjects, player)
	getPlayer():getTraits():add("task_start_army");
	getPlayer():getInventory():AddItem("NHM.QuestAFlash");
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Cain.png>" .."<LINE><LINE>".. getText("Tooltip_CainQuest1AR_Take") .."\n")
	QuestWindow:setVisible(true);
end

Computer2 = function(worldobjects, player, item)
	local playerObj = getSpecificPlayer(player)
	ISTimedActionQueue.add(ISComputer2:new(playerObj, item, 1000));
end

CainQuest1ARComplete = function()
	getPlayer():getTraits():remove("task_start_army");
	getPlayer():getInventory():Remove("QuestAEmptyFlash");

	local x = ZombRand(2)
	if x == 0 then
	getPlayer():getInventory():AddItem("NHM.AssaultRifleM1RecipeShard");
	getPlayer():getInventory():AddItem("NHM.AssaultRifleAK1RecipeShard");
	elseif x == 1 then 
	getPlayer():getInventory():AddItem("NHM.AssaultRifleM1RecipeShard");
	getPlayer():getInventory():AddItem("NHM.AssaultRifleM1RecipeShard");
	elseif x == 2 then 
	getPlayer():getInventory():AddItem("NHM.AssaultRifleAK1RecipeShard");
	getPlayer():getInventory():AddItem("NHM.AssaultRifleAK1RecipeShard");
	end
			if getPlayer():HasTrait("FastLearner") then
				getPlayer():getXp():AddXP(Perks.RepArmy, (40 / 1.3)) 
			elseif getPlayer():HasTrait("SlowLearner") then
				getPlayer():getXp():AddXP(Perks.RepArmy, (40 / 0.7)) 
			else
				getPlayer():getXp():AddXP(Perks.RepArmy, 40);
			end
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Cain.png>" .."<LINE><LINE>".. getText("Tooltip_CainQuest1AR_Finish") .."\n")
	QuestWindow:setVisible(true);
	
	getPlayer():getTraits():add("quest_cd");
end

--КАИН ЗАДАНИЕ 2 АВТОМАТ
CainQuest2AR = function()
	getPlayer():getTraits():add("task_start_army2");
	getPlayer():getInventory():AddItem("NHM.QuestADisk");
	QuestWindow:setText("<IMAGECENTRE:media/textures/Quests/LouiComp.png>" .."<LINE><LINE>".. getText("Tooltip_CainQuest2AR_Take") .."\n")
	QuestWindow:setVisible(true);
end

Computer3 = function(worldobjects, player, item)
	local playerObj = getSpecificPlayer(player)
	ISTimedActionQueue.add(ISComputer3:new(playerObj, item, 1000));
end

CainQuest2ARComplete = function()
	getPlayer():getTraits():remove("task_start_army2");
	getPlayer():getInventory():Remove("QuestAFullDisk");

	local x = ZombRand(2)
	if x == 0 then
	getPlayer():getInventory():AddItem("NHM.AssaultRifleM2RecipeShard");
	getPlayer():getInventory():AddItem("NHM.AssaultRifleAK2RecipeShard");
	elseif x == 1 then 
	getPlayer():getInventory():AddItem("NHM.AssaultRifleM2RecipeShard");
	getPlayer():getInventory():AddItem("NHM.AssaultRifleM2RecipeShard");
	elseif x == 2 then 
	getPlayer():getInventory():AddItem("NHM.AssaultRifleAK2RecipeShard");
	getPlayer():getInventory():AddItem("NHM.AssaultRifleAK2RecipeShard");
	end
			if getPlayer():HasTrait("FastLearner") then
				getPlayer():getXp():AddXP(Perks.RepArmy, (80 / 1.3)) 
			elseif getPlayer():HasTrait("SlowLearner") then
				getPlayer():getXp():AddXP(Perks.RepArmy, (80 / 0.7)) 
			else
				getPlayer():getXp():AddXP(Perks.RepArmy, 80);
			end
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Cain.png>" .."<LINE><LINE>".. getText("Tooltip_CainQuest2AR_Finish") .."\n")
	QuestWindow:setVisible(true);
	
	getPlayer():getTraits():add("quest_cd");
end


--КАИН ЗАДАНИЕ 1 ВИНТОВКА
CainQuest1R = function()
	getPlayer():getTraits():add("task_start_army3");
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Cain.png>" .."<LINE><LINE>".. getText("Tooltip_CainQuest1R_Take") .."\n")
	QuestWindow:setVisible(true);
end

CainQuest1RComplete = function()
	getPlayer():getTraits():remove("task_start_army3");
	
	local removeitems = 20

	while removeitems > 0 do
	getPlayer():getInventory():Remove("QuestAToken");
	removeitems = removeitems - 1
	end

	local x = ZombRand(2)
	if x == 0 then
	getPlayer():getInventory():AddItem("NHM.RifleB1RecipeShard");
	getPlayer():getInventory():AddItem("NHM.RifleSA1RecipeShard");
	elseif x == 1 then 
	getPlayer():getInventory():AddItem("NHM.RifleB1RecipeShard");
	getPlayer():getInventory():AddItem("NHM.RifleB1RecipeShard");
	elseif x == 2 then 
	getPlayer():getInventory():AddItem("NHM.RifleSA1RecipeShard");
	getPlayer():getInventory():AddItem("NHM.RifleSA1RecipeShard");
	end
		if getPlayer():HasTrait("FastLearner") then
			getPlayer():getXp():AddXP(Perks.RepArmy, (60 / 1.3)) 
		elseif getPlayer():HasTrait("SlowLearner") then
			getPlayer():getXp():AddXP(Perks.RepArmy, (60 / 0.7)) 
		else
			getPlayer():getXp():AddXP(Perks.RepArmy, 60);
		end
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Cain.png>" .."<LINE><LINE>".. getText("Tooltip_CainQuest1R_Finish") .."\n")
	QuestWindow:setVisible(true);
	
	getPlayer():getTraits():add("quest_cd");
end

--КАИН ЗАДАНИЕ 2 ВИНТОВКА
CainQuest2R = function()
	getPlayer():getTraits():add("task_start_army4");
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Cain.png>" .."<LINE><LINE>".. getText("Tooltip_CainQuest2R_Take") .."\n")
	QuestWindow:setVisible(true);
end

CainQuest2RComplete = function()
	getPlayer():getTraits():remove("task_start_army4");

	local removeitems = 40

	while removeitems > 0 do
	getPlayer():getInventory():Remove("QuestAToken");
	removeitems = removeitems - 1
	end

	local x = ZombRand(2)
	if x == 0 then
	getPlayer():getInventory():AddItem("NHM.RifleB2RecipeShard");
	getPlayer():getInventory():AddItem("NHM.RifleSA2RecipeShard");
	elseif x == 1 then 
	getPlayer():getInventory():AddItem("NHM.RifleB2RecipeShard");
	getPlayer():getInventory():AddItem("NHM.RifleB2RecipeShard");
	elseif x == 2 then 
	getPlayer():getInventory():AddItem("NHM.RifleSA2RecipeShard");
	getPlayer():getInventory():AddItem("NHM.RifleSA2RecipeShard");
	end
		if getPlayer():HasTrait("FastLearner") then
			getPlayer():getXp():AddXP(Perks.RepArmy, (100 / 1.3)) 
		elseif getPlayer():HasTrait("SlowLearner") then
			getPlayer():getXp():AddXP(Perks.RepArmy, (100 / 0.7)) 
		else
			getPlayer():getXp():AddXP(Perks.RepArmy, 100);
		end
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Cain.png>" .."<LINE><LINE>".. getText("Tooltip_CainQuest2R_Finish") .."\n")
	QuestWindow:setVisible(true);
	
	getPlayer():getTraits():add("quest_cd");
end

--АВЕЛЬ ЗАДАНИЕ 1 ПИСТОЛЕТ

AbelQuest1P = function()
	getPlayer():getTraits():add("task_start_army5");
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Abel.png>" .."<LINE><LINE>".. getText("Tooltip_AbelQuest1P_Take") .."\n")
	QuestWindow:setVisible(true);
end


AbelQuest1PComplete = function()
	getPlayer():getTraits():remove("task_start_army5");
	
	if (getPlayer():getInventory():contains("CannedPineapple") and getPlayer():getInventory():getItemCount("CannedPineapple") >= 5)
	then 
		getPlayer():getInventory():Remove("CannedPineapple");
		getPlayer():getInventory():Remove("CannedPineapple");
		getPlayer():getInventory():Remove("CannedPineapple");
		getPlayer():getInventory():Remove("CannedPineapple");
		getPlayer():getInventory():Remove("CannedPineapple");
	elseif (getPlayer():getInventory():contains("CannedBolognese") and getPlayer():getInventory():getItemCount("CannedBolognese") >= 5)
	then
		getPlayer():getInventory():Remove("CannedBolognese");
		getPlayer():getInventory():Remove("CannedBolognese");
		getPlayer():getInventory():Remove("CannedBolognese");
		getPlayer():getInventory():Remove("CannedBolognese");
		getPlayer():getInventory():Remove("CannedBolognese");
	elseif (getPlayer():getInventory():contains("CannedPeas") and getPlayer():getInventory():getItemCount("CannedPeas") >= 5) 
	then 
		getPlayer():getInventory():Remove("CannedPeas");
		getPlayer():getInventory():Remove("CannedPeas");
		getPlayer():getInventory():Remove("CannedPeas");
		getPlayer():getInventory():Remove("CannedPeas");
		getPlayer():getInventory():Remove("CannedPeas");
	elseif (getPlayer():getInventory():contains("CannedMushroomSoup") and getPlayer():getInventory():getItemCount("CannedMushroomSoup") >= 5)
	then
		getPlayer():getInventory():Remove("CannedMushroomSoup");
		getPlayer():getInventory():Remove("CannedMushroomSoup");
		getPlayer():getInventory():Remove("CannedMushroomSoup");
		getPlayer():getInventory():Remove("CannedMushroomSoup");
		getPlayer():getInventory():Remove("CannedMushroomSoup");
	elseif (getPlayer():getInventory():contains("CannedPotato2") and getPlayer():getInventory():getItemCount("CannedPotato2") >= 5)
	then
		getPlayer():getInventory():Remove("CannedPotato2");
		getPlayer():getInventory():Remove("CannedPotato2");
		getPlayer():getInventory():Remove("CannedPotato2");
		getPlayer():getInventory():Remove("CannedPotato2");
		getPlayer():getInventory():Remove("CannedPotato2");
	elseif (getPlayer():getInventory():contains("CannedCorn") and getPlayer():getInventory():getItemCount("CannedCorn") >= 5)
	then
		getPlayer():getInventory():Remove("CannedCorn");
		getPlayer():getInventory():Remove("CannedCorn");
		getPlayer():getInventory():Remove("CannedCorn");
		getPlayer():getInventory():Remove("CannedCorn");
		getPlayer():getInventory():Remove("CannedCorn");
	elseif (getPlayer():getInventory():contains("CannedCarrots2") and getPlayer():getInventory():getItemCount("CannedCarrots2") >= 5)
	then
		getPlayer():getInventory():Remove("CannedCarrots2");
		getPlayer():getInventory():Remove("CannedCarrots2");
		getPlayer():getInventory():Remove("CannedCarrots2");
		getPlayer():getInventory():Remove("CannedCarrots2");
		getPlayer():getInventory():Remove("CannedCarrots2");
	elseif (getPlayer():getInventory():contains("CannedChili") and getPlayer():getInventory():getItemCount("CannedChili") >= 5)
	then
		getPlayer():getInventory():Remove("CannedChili");
		getPlayer():getInventory():Remove("CannedChili");
		getPlayer():getInventory():Remove("CannedChili");
		getPlayer():getInventory():Remove("CannedChili");
		getPlayer():getInventory():Remove("CannedChili");
	elseif (getPlayer():getInventory():contains("CannedPeaches") and getPlayer():getInventory():getItemCount("CannedPeaches") >= 5)
	then
		getPlayer():getInventory():Remove("CannedPeaches");
		getPlayer():getInventory():Remove("CannedPeaches");
		getPlayer():getInventory():Remove("CannedPeaches");
		getPlayer():getInventory():Remove("CannedPeaches");
		getPlayer():getInventory():Remove("CannedPeaches");
	elseif (getPlayer():getInventory():contains("CannedSardines") and getPlayer():getInventory():getItemCount("CannedSardines") >= 5)
	then 
		getPlayer():getInventory():Remove("CannedSardines");
		getPlayer():getInventory():Remove("CannedSardines");
		getPlayer():getInventory():Remove("CannedSardines");
		getPlayer():getInventory():Remove("CannedSardines");
		getPlayer():getInventory():Remove("CannedSardines");
	elseif (getPlayer():getInventory():contains("CannedCornedBeef") and getPlayer():getInventory():getItemCount("CannedCornedBeef") >= 5)
	then
		getPlayer():getInventory():Remove("CannedCornedBeef");
		getPlayer():getInventory():Remove("CannedCornedBeef");
		getPlayer():getInventory():Remove("CannedCornedBeef");
		getPlayer():getInventory():Remove("CannedCornedBeef");
		getPlayer():getInventory():Remove("CannedCornedBeef");
	elseif (getPlayer():getInventory():contains("TinnedSoup") and getPlayer():getInventory():getItemCount("TinnedSoup") >= 5)
	then
		getPlayer():getInventory():Remove("TinnedSoup");
		getPlayer():getInventory():Remove("TinnedSoup");
		getPlayer():getInventory():Remove("TinnedSoup");
		getPlayer():getInventory():Remove("TinnedSoup");
		getPlayer():getInventory():Remove("TinnedSoup");
	elseif (getPlayer():getInventory():contains("CannedTomato2") and getPlayer():getInventory():getItemCount("CannedTomato2") >= 5)
	then
		getPlayer():getInventory():Remove("CannedTomato2");
		getPlayer():getInventory():Remove("CannedTomato2");
		getPlayer():getInventory():Remove("CannedTomato2");
		getPlayer():getInventory():Remove("CannedTomato2");
		getPlayer():getInventory():Remove("CannedTomato2");
	elseif (getPlayer():getInventory():contains("TunaTin") and getPlayer():getInventory():getItemCount("TunaTin") >= 5)
	then
		getPlayer():getInventory():Remove("TunaTin");
		getPlayer():getInventory():Remove("TunaTin");
		getPlayer():getInventory():Remove("TunaTin");
		getPlayer():getInventory():Remove("TunaTin");
		getPlayer():getInventory():Remove("TunaTin");
	elseif (getPlayer():getInventory():contains("TinnedBeans") and getPlayer():getInventory():getItemCount("TinnedBeans") >= 5)
	then
		getPlayer():getInventory():Remove("TinnedBeans");
		getPlayer():getInventory():Remove("TinnedBeans");
		getPlayer():getInventory():Remove("TinnedBeans");
		getPlayer():getInventory():Remove("TinnedBeans");
		getPlayer():getInventory():Remove("TinnedBeans");
	elseif (getPlayer():getInventory():contains("CannedFruitCocktail") and getPlayer():getInventory():getItemCount("CannedFruitCocktail") >= 5)
	then
		getPlayer():getInventory():Remove("CannedFruitCocktail");
		getPlayer():getInventory():Remove("CannedFruitCocktail");
		getPlayer():getInventory():Remove("CannedFruitCocktail");
		getPlayer():getInventory():Remove("CannedFruitCocktail");
		getPlayer():getInventory():Remove("CannedFruitCocktail");
	end

	local x = ZombRand(2)
	if x == 0 then
	getPlayer():getInventory():AddItem("NHM.PistolB2RecipeShard");
	getPlayer():getInventory():AddItem("NHM.Revolver2RecipeShard");
	elseif x == 1 then 
	getPlayer():getInventory():AddItem("NHM.PistolB2RecipeShard");
	getPlayer():getInventory():AddItem("NHM.PistolB2RecipeShard");
	elseif x == 2 then 
	getPlayer():getInventory():AddItem("NHM.Revolver2RecipeShard");
	getPlayer():getInventory():AddItem("NHM.Revolver2RecipeShard");
	end

	if getPlayer():HasTrait("FastLearner") then
		getPlayer():getXp():AddXP(Perks.RepArmy, (60 / 1.3)) 
	elseif getPlayer():HasTrait("SlowLearner") then
		getPlayer():getXp():AddXP(Perks.RepArmy, (60 / 0.7)) 
	else
		getPlayer():getXp():AddXP(Perks.RepArmy, 60);
	end
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Abel.png>" .."<LINE><LINE>".. getText("Tooltip_AbelQuest1P_Finish") .."\n")
	QuestWindow:setVisible(true);
	
	getPlayer():getTraits():add("quest_cd");
end


--АВЕЛЬ ЗАДАНИЕ 1 ДРОБОВИК

AbelQuest1S = function()
	getPlayer():getTraits():add("task_start_army6");
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Abel.png>" .."<LINE><LINE>".. getText("Tooltip_AbelQuest1S_Take") .."\n")
	QuestWindow:setVisible(true);
end


AbelQuest1SComplete = function()
	getPlayer():getTraits():remove("task_start_army6");
	
	if getPlayer():getInventory():contains("Jacket_ArmyCamoGreen") and getPlayer():getInventory():getItemCount("Jacket_ArmyCamoGreen") >= 2
		and getPlayer():getInventory():contains("Trousers_CamoGreen") and getPlayer():getInventory():getItemCount("Trousers_CamoGreen") >= 2
		and getPlayer():getInventory():contains("Shoes_ArmyBoots") and getPlayer():getInventory():getItemCount("Shoes_ArmyBoots") >= 2
		then 
			getPlayer():getInventory():Remove("Jacket_ArmyCamoGreen");
			getPlayer():getInventory():Remove("Jacket_ArmyCamoGreen");
			getPlayer():getInventory():Remove("Trousers_CamoGreen");
			getPlayer():getInventory():Remove("Trousers_CamoGreen");
			getPlayer():getInventory():Remove("Shoes_ArmyBoots");
			getPlayer():getInventory():Remove("Shoes_ArmyBoots");
		elseif getPlayer():getInventory():contains("Jacket_ArmyCamoDesert") and getPlayer():getInventory():getItemCount("Jacket_ArmyCamoDesert") >= 2
		and getPlayer():getInventory():contains("Trousers_CamoDesert") and getPlayer():getInventory():getItemCount("Trousers_CamoDesert") >= 2
		and getPlayer():getInventory():contains("Shoes_ArmyBootsDesert") and getPlayer():getInventory():getItemCount("Shoes_ArmyBootsDesert") >= 2
		then
			getPlayer():getInventory():Remove("Jacket_ArmyCamoDesert");
			getPlayer():getInventory():Remove("Jacket_ArmyCamoDesert");
			getPlayer():getInventory():Remove("Trousers_CamoDesert");
			getPlayer():getInventory():Remove("Trousers_CamoDesert");
			getPlayer():getInventory():Remove("Shoes_ArmyBootsDesert");
			getPlayer():getInventory():Remove("Shoes_ArmyBootsDesert");
		end

		local x = ZombRand(3)
	if x == 0 then
	getPlayer():getInventory():AddItem("NHM.Shotgun1RecipeShard");
	getPlayer():getInventory():AddItem("NHM.Shotgun2RecipeShard");
	elseif x == 1 then 
	getPlayer():getInventory():AddItem("NHM.Shotgun1RecipeShard");
	getPlayer():getInventory():AddItem("NHM.Shotgun1RecipeShard");
	elseif x == 2 then 
	getPlayer():getInventory():AddItem("NHM.Shotgun2RecipeShard");
	getPlayer():getInventory():AddItem("NHM.Shotgun2RecipeShard");
	end

	if getPlayer():HasTrait("FastLearner") then
		getPlayer():getXp():AddXP(Perks.RepArmy, (60 / 1.3)) 
	elseif getPlayer():HasTrait("SlowLearner") then
		getPlayer():getXp():AddXP(Perks.RepArmy, (60 / 0.7)) 
	else
		getPlayer():getXp():AddXP(Perks.RepArmy, 60);
	end
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Abel.png>" .."<LINE><LINE>".. getText("Tooltip_AbelQuest1S_Finish") .."\n")
	QuestWindow:setVisible(true);
	getPlayer():getTraits():add("quest_cd");
end

--АВЕЛЬ ЗАДАНИЕ 1 ПП

AbelQuest1SMG = function()
	getPlayer():getTraits():add("task_start_army7");
	getPlayer():getInventory():AddItem("NHM.QuestAAirAnalyzer");
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Abel.png>" .."<LINE><LINE>".. getText("Tooltip_AbelQuest1SMG_Take") .."\n")
	QuestWindow:setVisible(true);
end


AbelQuest1SMGComplete = function()
	getPlayer():getTraits():remove("task_start_army7");

	getPlayer():getInventory():Remove("QuestAFullAirAnalyzer");

	local x = ZombRand(2)
	if x == 0 or x == 1 then
		getPlayer():getInventory():AddItem("NHM.SMG1RecipeShard");
		elseif x == 2 then 
		getPlayer():getInventory():AddItem("NHM.SMG1RecipeShard");
		getPlayer():getInventory():AddItem("NHM.SMG1RecipeShard");
		end
		if getPlayer():HasTrait("FastLearner") then
			getPlayer():getXp():AddXP(Perks.RepArmy, (60 / 1.3)) 
		elseif getPlayer():HasTrait("SlowLearner") then
			getPlayer():getXp():AddXP(Perks.RepArmy, (60 / 0.7)) 
		else
			getPlayer():getXp():AddXP(Perks.RepArmy, 60);
		end
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Abel.png>" .."<LINE><LINE>".. getText("Tooltip_AbelQuest1SMG_Finish") .."\n")
	QuestWindow:setVisible(true);
	getPlayer():getTraits():add("quest_cd");
end

-- АВЕЛЬ ЗАДАНИЕ 2 ПП
AbelQuest2SMG = function()
	getPlayer():getTraits():add("task_start_army8");
	getPlayer():getInventory():AddItem("NHM.QuestARadAnalyzer");
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Abel.png>" .."<LINE><LINE>".. getText("Tooltip_AbelQuest2SMG_Take") .."\n")
	QuestWindow:setVisible(true);
end


AbelQuest2SMGComplete = function()
	getPlayer():getTraits():remove("task_start_army8");
	getPlayer():getInventory():Remove("QuestAFullRadAnalyzer");

	local x = ZombRand(2)
	if x == 0 or x == 1 then
		getPlayer():getInventory():AddItem("NHM.SMG2RecipeShard");
		elseif x == 2 then 
		getPlayer():getInventory():AddItem("NHM.SMG2RecipeShard");
		getPlayer():getInventory():AddItem("NHM.SMG2RecipeShard");
		end
		if getPlayer():HasTrait("FastLearner") then
			getPlayer():getXp():AddXP(Perks.RepArmy, (80 / 1.3)) 
		elseif getPlayer():HasTrait("SlowLearner") then
			getPlayer():getXp():AddXP(Perks.RepArmy, (80 / 0.7)) 
		else
			getPlayer():getXp():AddXP(Perks.RepArmy, 80);
		end
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Abel.png>" .."<LINE><LINE>".. getText("Tooltip_AbelQuest2SMG_Finish") .."\n")
	QuestWindow:setVisible(true);
	
	getPlayer():getTraits():add("quest_cd");
end

quest_cd = 0;
quest_cd1 = 0;
quest_cd_sp = 0;
quest_cd_si = 0;
quest_cd_ne = 0;
quest_cd_as = 0;
quest_cd_ki = 0;
quest_cd_ho = 0;
function quest_tick()
	if quest_cd_sp < 6 and getPlayer():HasTrait('quest_cd_sp') then
		quest_cd_sp = quest_cd_sp + 1;
	end
	if quest_cd_sp == 6 and getPlayer():HasTrait('quest_cd_sp') then 
		getPlayer():getTraits():remove("quest_cd_sp");
		quest_cd_sp = 0;
	end
	if quest_cd_si < 6 and getPlayer():HasTrait('quest_cd_si') then
		quest_cd_si = quest_cd_si + 1;
	end
	if quest_cd_si == 6 and getPlayer():HasTrait('quest_cd_si') then 
		getPlayer():getTraits():remove("quest_cd_si");
		quest_cd_si = 0;
	end
	if quest_cd_ne < 6 and getPlayer():HasTrait('quest_cd_ne') then
		quest_cd_ne = quest_cd_ne + 1;
	end
	if quest_cd_ne == 6 and getPlayer():HasTrait('quest_cd_ne') then 
		getPlayer():getTraits():remove("quest_cd_ne");
		quest_cd_ne = 0;
	end
	if quest_cd_as < 6 and getPlayer():HasTrait('quest_cd_as') then
		quest_cd_as = quest_cd_as + 1;
	end
	if quest_cd_as == 6 and getPlayer():HasTrait('quest_cd_as') then 
		getPlayer():getTraits():remove("quest_cd_as");
		quest_cd_as = 0;
	end
	if quest_cd_ki < 6 and getPlayer():HasTrait('quest_cd_ki') then
		quest_cd_ki = quest_cd_ki + 1;
	end
	if quest_cd_ki == 6 and getPlayer():HasTrait('quest_cd_ki') then 
		getPlayer():getTraits():remove("quest_cd_ki");
		quest_cd_ki = 0;
	end
	if quest_cd_ho < 6 and getPlayer():HasTrait('quest_cd_ho') then
		quest_cd_ho = quest_cd_ho + 1;
	end
	if quest_cd_ho == 6 and getPlayer():HasTrait('quest_cd_ho') then 
		getPlayer():getTraits():remove("quest_cd_ho");
		quest_cd_ho = 0;
	end
	if quest_cd < 6 and getPlayer():HasTrait('quest_cd') then
		quest_cd = quest_cd + 1;
	end
	if quest_cd == 6 and getPlayer():HasTrait('quest_cd') then 
		getPlayer():getTraits():remove("quest_cd");
		quest_cd = 0;
	end
	if quest_cd1 < 6 and getPlayer():HasTrait('quest_cd1') then
		quest_cd1 = quest_cd1 + 1;
	end
	if quest_cd1 == 6 and getPlayer():HasTrait('quest_cd1') then 
	getPlayer():getTraits():remove("quest_cd1");
	getPlayer():getTraits():add("quest_cd1_r1");
	quest_cd1 = 0;
	end
	if quest_cd1 == 6 and getPlayer():HasTrait('quest_cd1_r1') then
	getPlayer():getTraits():remove("quest_cd1_r1");
	getPlayer():getTraits():add("quest_cd1_r2");
	quest_cd1 = 0;
	end
	if quest_cd1 == 6 and getPlayer():HasTrait('quest_cd1_r2') then 
	getPlayer():getTraits():remove("quest_cd1_r2");
	getPlayer():getTraits():add("quest_cd1_r3");
	quest_cd1 = 0;
	end
	if quest_cd1 == 6 and getPlayer():HasTrait('quest_cd1_r3') then 
	getPlayer():getTraits():remove("quest_cd1_r3");
	quest_cd1 = 0;
	end
end

Events.EveryHours.Add(quest_tick);
Events.OnFillWorldObjectContextMenu.Add(Work_Stations4);