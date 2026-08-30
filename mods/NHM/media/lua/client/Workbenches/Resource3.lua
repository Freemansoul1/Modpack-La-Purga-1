require "ISUI/ISWorldObjectContextMenu"

function Work_Stations3(player, context, worldobjects, test)

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

	local Sparkle
	local Kioshi
	local Silk 
	local Nerd 
	local Aspirin
	local Hound
	local Trader
	local Cain
	local Abel

	local archive -- Демиург квест 1
	

	for i, v in ipairs(worldobjects) do
		
		if v:getSprite():getName() == nil then return; end
		local spriteName = v:getSprite():getName()
		x = v:getX();
		y = v:getY();
		if spriteName == "Sparkle_0"
		then
			Sparkle = v;
		elseif spriteName == "Kioshi_0"
		then
			Kioshi = v;
		elseif spriteName == "Silk_0"
		then
			Silk = v;
		elseif spriteName == "Nerd_0"
		then
			Nerd = v;
		elseif spriteName == "Aspirin_0"
		then
			Aspirin = v;
		elseif spriteName == "Hound_0"
		then
			Hound = v;
		elseif spriteName == "Trader_0"
		then
			Trader = v;
		elseif spriteName == "Cain_0"
		then
			Cain = v;
		elseif spriteName == "Abel_0"
		then
			Abel = v;
		end
	end
	
	local MineEnd = getPlayer():getXp():getXP(Perks.MineEndurance)
	local DocRep = getPlayer():getXp():getXP(Perks.RepDoc)
	local DocTaskTaken = getPlayer():HasTrait('task_start_med')
	local End = getPlayer():getStats():getEndurance()
	local Fatique = getPlayer():getStats():getFatigue()
	
--ИСКРА ЭЛЕКТРИКА
	if Sparkle and getPlayer():DistToSquared(x, y) <= 6 then
		local option_sparkle_hello = context:addOption(getText("ContextMenu_Sparkle_Hello"), worldobjects, SparkleHello, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_sparkle_hello.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_Sparkle_Hello"));
		toolTip:setTexture("Sparkle_0");
		toolTip.description = getText("Tooltip_Sparkle_Hello");
	
		local option_sparkle_quests = context:addOption(getText("ContextMenu_Quests"), worldobjects, nil)
		local subMenu = ISContextMenu:getNew(context);
		context:addSubMenu(option_sparkle_quests, subMenu);

		--КВЕСТ 1 ПРИНЕСТИ ДЕТАЛИ
		local option_sparkle_quest1 = subMenu:addOption(getText("ContextMenu_SparkleQuest1"), worldobjects, SparkleQuest1, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_sparkle_quest1.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_SparkleQuest1"));
		toolTip:setTexture("Sparkle_0");
		toolTip.description = getText("Tooltip_SparkleQuest1");
		if getPlayer():HasTrait('task_start_artisan') or getPlayer():HasTrait('task_start_artisan2')
		or getPlayer():HasTrait('task_start_artisan3') or getPlayer():HasTrait('task_start_artisan4')
		then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_sparkle_quest1.notAvailable = true;
		end
		if getPlayer():HasTrait('quest_cd_sp') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_sparkle_quest1.notAvailable = true;
		end

		-- ЗАВЕРШИТЬ КВЕСТ 1 ДЕТАЛИ
		local option_sparkle_quest1_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, SparkleQuest1Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_sparkle_quest1_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Sparkle_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not getPlayer():HasTrait('task_start_artisan')
		or not (getPlayer():getInventory():contains("ElectronicsScrap") and getPlayer():getInventory():getItemCount("ElectronicsScrap") >= 5) then
			context:removeLastOption();
		end
		if getPlayer():HasTrait('quest_cd_sp') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_sparkle_quest1_complete.notAvailable = true;
		end

		--КВЕСТ 2 ПРИНЕСТИ ОТВЕРТКУ
		local option_sparkle_quest2 = subMenu:addOption(getText("ContextMenu_SparkleQuest2"), worldobjects, SparkleQuest2, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_sparkle_quest2.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_SparkleQuest2"));
		toolTip:setTexture("Sparkle_0");
		toolTip.description = getText("Tooltip_SparkleQuest2");
		if getPlayer():HasTrait('task_start_artisan') or getPlayer():HasTrait('task_start_artisan2')
		or getPlayer():HasTrait('task_start_artisan3') or getPlayer():HasTrait('task_start_artisan4')
		then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_sparkle_quest2.notAvailable = true;
		end
		if getPlayer():HasTrait('quest_cd_sp') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_sparkle_quest2.notAvailable = true;
		end
		if getPlayer():getPerkLevel(Perks.RepCrafts) < 1 then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestPerkLevel1");
			option_sparkle_quest2.notAvailable = true;
		end

		-- ЗАВЕРШИТЬ КВЕСТ 2 ПРИНЕСТИ ОТВЕРТКУ
		local option_sparkle_quest2_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, SparkleQuest2Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_sparkle_quest2_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Sparkle_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not getPlayer():HasTrait('task_start_artisan2')
		or not (getPlayer():getInventory():contains("Screwdriver") and getPlayer():getInventory():getItemCount("Screwdriver") >= 1) then
			context:removeLastOption();
		end
		if getPlayer():HasTrait('quest_cd_sp') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_sparkle_quest2_complete.notAvailable = true;
		end

		--КВЕСТ 3 ПРИНЕСТИ КРЕМНИЙ
		local option_sparkle_quest3 = subMenu:addOption(getText("ContextMenu_SparkleQuest3"), worldobjects, SparkleQuest3, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_sparkle_quest3.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_SparkleQuest3"));
		toolTip:setTexture("Sparkle_0");
		toolTip.description = getText("Tooltip_SparkleQuest3");
		if getPlayer():HasTrait('task_start_artisan') or getPlayer():HasTrait('task_start_artisan2')
		or getPlayer():HasTrait('task_start_artisan3') or getPlayer():HasTrait('task_start_artisan4')
		then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_sparkle_quest3.notAvailable = true;
		end
		if getPlayer():HasTrait('quest_cd_sp') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_sparkle_quest3.notAvailable = true;
		end
		if getPlayer():getPerkLevel(Perks.RepCrafts) < 2 then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestPerkLevel2");
			option_sparkle_quest3.notAvailable = true;
		end

		-- ЗАВЕРШИТЬ КВЕСТ 3 КРЕМНИЙ
		local option_sparkle_quest3_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, SparkleQuest3Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_sparkle_quest3_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Sparkle_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not getPlayer():HasTrait('task_start_artisan3') 
		or not (getPlayer():getInventory():contains("SiliconOre") and getPlayer():getInventory():getItemCount("SiliconOre") >= 3) then
			context:removeLastOption();
		end
		if getPlayer():HasTrait('quest_cd_sp') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_sparkle_quest3_complete.notAvailable = true;
		end

		--КВЕСТ 4 ПРИНЕСТИ РАЦИЮ
		local option_sparkle_quest4 = subMenu:addOption(getText("ContextMenu_SparkleQuest4"), worldobjects, SparkleQuest4, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_sparkle_quest4.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_SparkleQuest4"));
		toolTip:setTexture("Sparkle_0");
		toolTip.description = getText("Tooltip_SparkleQuest4");
		if getPlayer():HasTrait('task_start_artisan') or getPlayer():HasTrait('task_start_artisan2')
		or getPlayer():HasTrait('task_start_artisan3') or getPlayer():HasTrait('task_start_artisan4')
		then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_sparkle_quest4.notAvailable = true;
		end
		if getPlayer():HasTrait('quest_cd_sp') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_sparkle_quest4.notAvailable = true;
		end
		if getPlayer():getPerkLevel(Perks.RepCrafts) < 3 then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestPerkLevel3");
			option_sparkle_quest4.notAvailable = true;
		end

		-- ЗАВЕРШИТЬ КВЕСТ 4 РАЦИЮ
		local option_sparkle_quest4_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, SparkleQuest4Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_sparkle_quest4_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Sparkle_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not getPlayer():HasTrait('task_start_artisan4')
		or not (getPlayer():getInventory():contains("WalkieTalkie2") and getPlayer():getInventory():getItemCount("WalkieTalkie2") >= 2) then
			context:removeLastOption();
		end
		if getPlayer():HasTrait('quest_cd_sp') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_sparkle_quest4_complete.notAvailable = true;
		end

		local option_tutorial_sparkle = context:addOption(getText("ContextMenu_TutorialElectric"), worldobjects, TutorialElectric, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_tutorial_sparkle.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_TutorialElectric"));
		toolTip:setTexture("Sparkle_0");
		toolTip.description = getText("Tooltip_TutorialUp");

		--ШЕЛК ШИТЬЕ КОЖЕВНИК
	elseif Silk and getPlayer():DistToSquared(x, y) <= 6 then
		local option_silk_hello = context:addOption(getText("ContextMenu_Silk_Hello"), worldobjects, SilkHello, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_silk_hello.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_Silk_Hello"));
		toolTip:setTexture("Silk_0");
		toolTip.description = getText("Tooltip_Silk_Hello");
	
		local option_silk_quests = context:addOption(getText("ContextMenu_Quests"), worldobjects, nil)
		local subMenu = ISContextMenu:getNew(context);
		context:addSubMenu(option_silk_quests, subMenu);

		--КВЕСТ 1 ПРИНЕСТИ КОТОМКУ
		local option_silk_quest1 = subMenu:addOption(getText("ContextMenu_SilkQuest1"), worldobjects, SilkQuest1, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_silk_quest1.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_SilkQuest1"));
		toolTip:setTexture("Silk_0");
		toolTip.description = getText("Tooltip_SilkQuest1");
		if getPlayer():HasTrait('task_start_artisan5') or getPlayer():HasTrait('task_start_artisan6')
		or getPlayer():HasTrait('task_start_artisan7') or getPlayer():HasTrait('task_start_artisan8')
		then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_silk_quest1.notAvailable = true;
		end
		if getPlayer():HasTrait('quest_cd_si') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_silk_quest1.notAvailable = true;
		end

		-- ЗАВЕРШИТЬ КВЕСТ 1 КОТОМКА
		local option_silk_quest1_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, SilkQuest1Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_silk_quest1_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Silk_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not getPlayer():HasTrait('task_start_artisan5')
		or not (getPlayer():getInventory():contains("Kotomka") and getPlayer():getInventory():getItemCount("Kotomka") >= 1) then
			context:removeLastOption();
		end
		if getPlayer():HasTrait('quest_cd_si') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_silk_quest1_complete.notAvailable = true;
		end

		--КВЕСТ 2 ПРИНЕСТИ ВЕРЕВКУ
		local option_silk_quest2 = subMenu:addOption(getText("ContextMenu_SilkQuest2"), worldobjects, SilkQuest2, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_silk_quest2.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_SilkQuest2"));
		toolTip:setTexture("Silk_0");
		toolTip.description = getText("Tooltip_SilkQuest2");
		if getPlayer():HasTrait('task_start_artisan5') or getPlayer():HasTrait('task_start_artisan6')
		or getPlayer():HasTrait('task_start_artisan7') or getPlayer():HasTrait('task_start_artisan8')
		then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_silk_quest2.notAvailable = true;
		end
		if getPlayer():HasTrait('quest_cd_si') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_silk_quest2.notAvailable = true;
		end
		if getPlayer():getPerkLevel(Perks.RepCrafts) < 1 then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestPerkLevel1");
			option_silk_quest2.notAvailable = true;
		end

		-- ЗАВЕРШИТЬ КВЕСТ 2 ПРИНЕСТИ ВЕРЕВКУ
		local option_silk_quest2_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, SilkQuest2Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_silk_quest2_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Silk_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not getPlayer():HasTrait('task_start_artisan6')
		or not (getPlayer():getInventory():contains("Rope") and getPlayer():getInventory():getItemCount("Rope") >= 1) then
			context:removeLastOption();
		end
		if getPlayer():HasTrait('quest_cd_si') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_silk_quest2_complete.notAvailable = true;
		end

		--КВЕСТ 3 ПРИНЕСТИ ТОНКУЮ КОЖУ
		local option_silk_quest3 = subMenu:addOption(getText("ContextMenu_SilkQuest3"), worldobjects, SilkQuest3, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_silk_quest3.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_SilkQuest3"));
		toolTip:setTexture("Silk_0");
		toolTip.description = getText("Tooltip_SilkQuest3");
		if getPlayer():HasTrait('task_start_artisan5') or getPlayer():HasTrait('task_start_artisan6')
		or getPlayer():HasTrait('task_start_artisan7') or getPlayer():HasTrait('task_start_artisan8')
		then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_silk_quest3.notAvailable = true;
		end
		if getPlayer():HasTrait('quest_cd_si') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_silk_quest3.notAvailable = true;
		end
		if getPlayer():getPerkLevel(Perks.RepCrafts) < 2 then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestPerkLevel2");
			option_silk_quest3.notAvailable = true;
		end

		-- ЗАВЕРШИТЬ КВЕСТ 3 ПРИНЕСТИ ТОНКУЮ КОЖУ
		local option_silk_quest3_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, SilkQuest3Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_silk_quest3_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Silk_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not getPlayer():HasTrait('task_start_artisan7') 
		or not (getPlayer():getInventory():contains("ReadyThinLeather") and getPlayer():getInventory():getItemCount("ReadyThinLeather") >= 1) then
			context:removeLastOption();
		end
		if getPlayer():HasTrait('quest_cd_si') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_silk_quest3_complete.notAvailable = true;
		end

		--КВЕСТ 4 ПРИНЕСТИ РЮКЗАК
		local option_silk_quest4 = subMenu:addOption(getText("ContextMenu_SilkQuest4"), worldobjects, SilkQuest4, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_silk_quest4.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_SilkQuest4"));
		toolTip:setTexture("Silk_0");
		toolTip.description = getText("Tooltip_SilkQuest4");
		if getPlayer():HasTrait('task_start_artisan5') or getPlayer():HasTrait('task_start_artisan6')
		or getPlayer():HasTrait('task_start_artisan7') or getPlayer():HasTrait('task_start_artisan8')
		then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_silk_quest4.notAvailable = true;
		end
		if getPlayer():HasTrait('quest_cd_si') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_silk_quest4.notAvailable = true;
		end
		if getPlayer():getPerkLevel(Perks.RepCrafts) < 3 then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestPerkLevel3");
			option_silk_quest4.notAvailable = true;
		end

		-- ЗАВЕРШИТЬ КВЕСТ 4 РЮКЗАК
		local option_silk_quest4_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, SilkQuest4Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_silk_quest4_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Silk_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not getPlayer():HasTrait('task_start_artisan8') 
		or not (getPlayer():getInventory():contains("Bag_Schoolbag") and getPlayer():getInventory():getItemCount("Bag_Schoolbag") >= 1) then
			context:removeLastOption();
		end
		if getPlayer():HasTrait('quest_cd_si') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_silk_quest4_complete.notAvailable = true;
		end

		local option_tutorial_silk = context:addOption(getText("ContextMenu_TutorialLeather"), worldobjects, TutorialLeather, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_tutorial_silk.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_TutorialLeather"));
		toolTip:setTexture("Silk_0");
		toolTip.description = getText("Tooltip_TutorialUp");

		--БОТАН ХИМИК
	elseif Nerd and getPlayer():DistToSquared(x, y) <= 6 then
		local option_nerd_hello = context:addOption(getText("ContextMenu_Nerd_Hello"), worldobjects, NerdHello, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_nerd_hello.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_Nerd_Hello"));
		toolTip:setTexture("Nerd_0");
		toolTip.description = getText("Tooltip_Nerd_Hello");
	
		local option_nerd_quests = context:addOption(getText("ContextMenu_Quests"), worldobjects, nil)
		local subMenu = ISContextMenu:getNew(context);
		context:addSubMenu(option_nerd_quests, subMenu);

		--КВЕСТ 1 ПРИНЕСТИ КОЛБУ
		local option_nerd_quest1 = subMenu:addOption(getText("ContextMenu_NerdQuest1"), worldobjects, NerdQuest1, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_nerd_quest1.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_NerdQuest1"));
		toolTip:setTexture("Nerd_0");
		toolTip.description = getText("Tooltip_NerdQuest1");
		if getPlayer():HasTrait('task_start_artisan9') or getPlayer():HasTrait('task_start_artisan10')
		or getPlayer():HasTrait('task_start_artisan11') or getPlayer():HasTrait('task_start_artisan12')
		then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_nerd_quest1.notAvailable = true;
		end
		if getPlayer():HasTrait('quest_cd_ne') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_nerd_quest1.notAvailable = true;
		end

		-- ЗАВЕРШИТЬ КВЕСТ 1 ПРИНЕСТИ КОЛБУ
		local option_nerd_quest1_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, NerdQuest1Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_nerd_quest1_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Nerd_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not getPlayer():HasTrait('task_start_artisan9')
		or not (getPlayer():getInventory():contains("ChemicalFlask") and getPlayer():getInventory():getItemCount("ChemicalFlask") >= 1) then
			context:removeLastOption();
		end
		if getPlayer():HasTrait('quest_cd_ne') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_nerd_quest1_complete.notAvailable = true;
		end

		--КВЕСТ 2 ДОБЫТЬ БАЗОВЫЕ РЕСУРСЫ ХИМИЯ
		local option_nerd_quest2 = subMenu:addOption(getText("ContextMenu_NerdQuest2"), worldobjects, NerdQuest2, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_nerd_quest2.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_NerdQuest2"));
		toolTip:setTexture("Nerd_0");
		toolTip.description = getText("Tooltip_NerdQuest2");
		if getPlayer():HasTrait('task_start_artisan9') or getPlayer():HasTrait('task_start_artisan10')
		or getPlayer():HasTrait('task_start_artisan11') or getPlayer():HasTrait('task_start_artisan12')
		then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_nerd_quest2.notAvailable = true;
		end
		if getPlayer():HasTrait('quest_cd_ne') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_nerd_quest2.notAvailable = true;
		end
		if getPlayer():getPerkLevel(Perks.RepCrafts) < 1 then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestPerkLevel1");
			option_nerd_quest2.notAvailable = true;
		end

		-- ЗАВЕРШИТЬ КВЕСТ 2 БАЗОВЫЕ РЕСУРСЫ ХИМИЯ
		local option_nerd_quest2_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, NerdQuest2Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_nerd_quest2_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Nerd_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not getPlayer():HasTrait('task_start_artisan10')
		or not ((getPlayer():getInventory():contains("WoodAsh") and getPlayer():getInventory():getItemCount("WoodAsh") >= 2
		and getPlayer():getInventory():contains("SulfurPowder") and getPlayer():getInventory():getItemCount("SulfurPowder") >= 2
		and getPlayer():getInventory():contains("Limestone") and getPlayer():getInventory():getItemCount("Limestone") >= 2)) then
			context:removeLastOption();
		end
		if getPlayer():HasTrait('quest_cd_ne') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_nerd_quest2_complete.notAvailable = true;
		end

		--КВЕСТ 3 ПРИНЕСТИ АЗОТНУЮ КИСЛОТУ
		local option_nerd_quest3 = subMenu:addOption(getText("ContextMenu_NerdQuest3"), worldobjects, NerdQuest3, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_nerd_quest3.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_NerdQuest3"));
		toolTip:setTexture("Nerd_0");
		toolTip.description = getText("Tooltip_NerdQuest3");
		if getPlayer():HasTrait('task_start_artisan9') or getPlayer():HasTrait('task_start_artisan10')
		or getPlayer():HasTrait('task_start_artisan11') or getPlayer():HasTrait('task_start_artisan12')
		then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_nerd_quest3.notAvailable = true;
		end
		if getPlayer():HasTrait('quest_cd_ne') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_nerd_quest3.notAvailable = true;
		end
		if getPlayer():getPerkLevel(Perks.RepCrafts) < 2 then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestPerkLevel2");
			option_nerd_quest3.notAvailable = true;
		end

		-- ЗАВЕРШИТЬ КВЕСТ 3 АЗОТНАЯ КИСЛОТА
		local option_nerd_quest3_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, NerdQuest3Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_nerd_quest3_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Nerd_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not getPlayer():HasTrait('task_start_artisan11') 
		or not (getPlayer():getInventory():contains("FlaskNitrogen") and getPlayer():getInventory():getItemCount("FlaskNitrogen") >= 1) then
			context:removeLastOption();
		end
		if getPlayer():HasTrait('quest_cd_ne') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_nerd_quest3_complete.notAvailable = true;
		end

		--КВЕСТ 4 ПРИНЕСТИ ПОРОХ
		local option_nerd_quest4 = subMenu:addOption(getText("ContextMenu_NerdQuest4"), worldobjects, NerdQuest4, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_nerd_quest4.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_NerdQuest4"));
		toolTip:setTexture("Nerd_0");
		toolTip.description = getText("Tooltip_NerdQuest4");
		if getPlayer():HasTrait('task_start_artisan9') or getPlayer():HasTrait('task_start_artisan10')
		or getPlayer():HasTrait('task_start_artisan11') or getPlayer():HasTrait('task_start_artisan12')
		then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_nerd_quest4.notAvailable = true;
		end
		if getPlayer():HasTrait('quest_cd_ne') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_nerd_quest4.notAvailable = true;
		end
		if getPlayer():getPerkLevel(Perks.RepCrafts) < 3 then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestPerkLevel3");
			option_nerd_quest4.notAvailable = true;
		end

		-- ЗАВЕРШИТЬ КВЕСТ 4 ПОРОХ
		local option_nerd_quest4_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, NerdQuest4Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_nerd_quest4_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Nerd_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not getPlayer():HasTrait('task_start_artisan12')
		or not (getPlayer():getInventory():contains("Powder") and getPlayer():getInventory():getItemCount("Powder") >= 2) then
			context:removeLastOption();
		end
		if getPlayer():HasTrait('quest_cd_ne') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_nerd_quest4_complete.notAvailable = true;
		end

		local option_tutorial_nerd = context:addOption(getText("ContextMenu_TutorialChem"), worldobjects, TutorialChem, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_tutorial_nerd.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_TutorialChem"));
		toolTip:setTexture("Nerd_0");
		toolTip.description = getText("Tooltip_TutorialUp");

	--АСПИРИН МЕДИК
	elseif Aspirin and getPlayer():DistToSquared(x, y) <= 6 then
		local option_aspirin_hello = context:addOption(getText("ContextMenu_Aspirin_Hello"), worldobjects, AspirinHello, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_aspirin_hello.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_Aspirin_Hello"));
		toolTip:setTexture("Aspirin_0");
		toolTip.description = getText("Tooltip_Aspirin_Hello");

		local option_aspirin_quests = context:addOption(getText("ContextMenu_Quests"), worldobjects, nil)
		local subMenu = ISContextMenu:getNew(context);
		context:addSubMenu(option_aspirin_quests, subMenu);

		--КВЕСТ 1 ПРИНЕСТИ УГОЛЬНЫЕ ТАБЛЕТКИ
		local option_aspirin_quest1 = subMenu:addOption(getText("ContextMenu_AspirinQuest1"), worldobjects, AspirinQuest1, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_aspirin_quest1.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_AspirinQuest1"));
		toolTip:setTexture("Aspirin_0");
		toolTip.description = getText("Tooltip_AspirinQuest1");
		if getPlayer():HasTrait('task_start_artisan13') or getPlayer():HasTrait('task_start_artisan14')
		or getPlayer():HasTrait('task_start_artisan15') or getPlayer():HasTrait('task_start_artisan16')
		then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_aspirin_quest1.notAvailable = true;
		end
		if getPlayer():HasTrait('quest_cd_as') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_aspirin_quest1.notAvailable = true;
		end

		-- ЗАВЕРШИТЬ КВЕСТ 1 УГОЛЬНЫЕ ТАБЛЕТКИ
		local option_aspirin_quest1_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, AspirinQuest1Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_aspirin_quest1_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Aspirin_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not getPlayer():HasTrait('task_start_artisan13') 
		or not (getPlayer():getInventory():contains("CoalPills") and getPlayer():getInventory():getItemCount("CoalPills") >= 2) then
			context:removeLastOption();
		end
		if getPlayer():HasTrait('quest_cd_as') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_aspirin_quest1_complete.notAvailable = true;
		end

		--КВЕСТ 2 ДОБЫТЬ ОБРАЗЦЫ ЗАРАЖЕННОГО
		local option_aspirin_quest2 = subMenu:addOption(getText("ContextMenu_AspirinQuest2"), worldobjects, AspirinQuest2, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_aspirin_quest2.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_AspirinQuest2"));
		toolTip:setTexture("Aspirin_0");
		toolTip.description = getText("Tooltip_AspirinQuest2");
		if getPlayer():HasTrait('task_start_artisan13') or getPlayer():HasTrait('task_start_artisan14')
		or getPlayer():HasTrait('task_start_artisan15') or getPlayer():HasTrait('task_start_artisan16')
		then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_aspirin_quest2.notAvailable = true;
		end
		if getPlayer():HasTrait('quest_cd_as') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_aspirin_quest2.notAvailable = true;
		end
		if getPlayer():getPerkLevel(Perks.RepCrafts) < 1 then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestPerkLevel1");
			option_aspirin_quest2.notAvailable = true;
		end

		-- ЗАВЕРШИТЬ КВЕСТ 2 ДОБЫТЬ ОБРАЗЦЫ ЗАРАЖЕННОГО
		local option_aspirin_quest2_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, AspirinQuest2Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_aspirin_quest2_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Aspirin_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not getPlayer():HasTrait('task_start_artisan14')
		or not (getPlayer():getInventory():contains("InfectedSample") and getPlayer():getInventory():getItemCount("InfectedSample") >= 2) then
			context:removeLastOption();
		end
		if getPlayer():HasTrait('quest_cd_as') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_aspirin_quest2_complete.notAvailable = true;
		end

		--КВЕСТ 3 ПРИПАРКА ОКОПНИКА

		local option_aspirin_quest3 = subMenu:addOption(getText("ContextMenu_AspirinQuest3"), worldobjects, AspirinQuest3, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_aspirin_quest3.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_AspirinQuest3"));
		toolTip:setTexture("Aspirin_0");
		toolTip.description = getText("Tooltip_AspirinQuest3");
		if getPlayer():HasTrait('task_start_artisan13') or getPlayer():HasTrait('task_start_artisan14')
		or getPlayer():HasTrait('task_start_artisan15') or getPlayer():HasTrait('task_start_artisan16')
		then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_aspirin_quest3.notAvailable = true;
		end
		if getPlayer():HasTrait('quest_cd_as') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_aspirin_quest3.notAvailable = true;
		end
		if getPlayer():getPerkLevel(Perks.RepCrafts) < 2 then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestPerkLevel2");
			option_aspirin_quest3.notAvailable = true;
		end

		-- ЗАВЕРШИТЬ КВЕСТ 3 ПРИПАРКА
		local option_aspirin_quest3_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, AspirinQuest3Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_aspirin_quest3_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Aspirin_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not getPlayer():HasTrait('task_start_artisan15')
		or not (getPlayer():getInventory():contains("ComfreyCataplasm") and getPlayer():getInventory():getItemCount("ComfreyCataplasm") >= 1
		and getPlayer():getInventory():contains("PlantainCataplasm") and getPlayer():getInventory():getItemCount("PlantainCataplasm") >= 1
		and getPlayer():getInventory():contains("WildGarlicCataplasm") and getPlayer():getInventory():getItemCount("WildGarlicCataplasm") >= 1) then
			context:removeLastOption();
		end
		if getPlayer():HasTrait('quest_cd_as') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_aspirin_quest3_complete.notAvailable = true;
		end

		--КВЕСТ 4 ПРИНЕСТИ ВИТАМИНЫ
		local option_aspirin_quest4 = subMenu:addOption(getText("ContextMenu_AspirinQuest4"), worldobjects, AspirinQuest4, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_aspirin_quest4.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_AspirinQuest4"));
		toolTip:setTexture("Aspirin_0");
		toolTip.description = getText("Tooltip_AspirinQuest4");
		if getPlayer():HasTrait('task_start_artisan13') or getPlayer():HasTrait('task_start_artisan14')
		or getPlayer():HasTrait('task_start_artisan15') or getPlayer():HasTrait('task_start_artisan16')
		then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_aspirin_quest4.notAvailable = true;
		end
		if getPlayer():HasTrait('quest_cd_as') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_aspirin_quest4.notAvailable = true;
		end
		if getPlayer():getPerkLevel(Perks.RepCrafts) < 3 then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestPerkLevel3");
			option_aspirin_quest4.notAvailable = true;
		end

		-- ЗАВЕРШИТЬ КВЕСТ 4 ВИТАМИНЫ
		local option_aspirin_quest4_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, AspirinQuest4Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_aspirin_quest4_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Aspirin_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not getPlayer():HasTrait('task_start_artisan16')
		or not (getPlayer():getInventory():contains("PillsVitamins") and getPlayer():getInventory():getItemCount("PillsVitamins") >= 1) then
			context:removeLastOption();
		end
		if getPlayer():HasTrait('quest_cd_as') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_aspirin_quest4_complete.notAvailable = true;
		end

		local option_tutorial_aspirin = context:addOption(getText("ContextMenu_TutorialAid"), worldobjects, TutorialAid, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_tutorial_aspirin.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_TutorialAid"));
		toolTip:setTexture("Aspirin_0");
		toolTip.description = getText("Tooltip_TutorialUp");

		--КИОШИ ИНЖЕНЕР
	elseif Kioshi and getPlayer():DistToSquared(x, y) <= 6 then
		local option_kioshi_hello = context:addOption(getText("ContextMenu_Kioshi_Hello"), worldobjects, KioshiHello, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_kioshi_hello.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_Kioshi_Hello"));
		toolTip:setTexture("Kioshi_0");
		toolTip.description = getText("Tooltip_Kioshi_Hello");
	
		local option_kioshi_quests = context:addOption(getText("ContextMenu_Quests"), worldobjects, nil)
		local subMenu = ISContextMenu:getNew(context);
		context:addSubMenu(option_kioshi_quests, subMenu);

		--КВЕСТ 1 ПРИНЕСТИ СТРЕЛЫ
		local option_kioshi_quest1 = subMenu:addOption(getText("ContextMenu_KioshiQuest1"), worldobjects, KioshiQuest1, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_kioshi_quest1.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_KioshiQuest1"));
		toolTip:setTexture("Kioshi_0");
		toolTip.description = getText("Tooltip_KioshiQuest1");
		if getPlayer():HasTrait('task_start_artisan17') or getPlayer():HasTrait('task_start_artisan18')
		or getPlayer():HasTrait('task_start_artisan19') or getPlayer():HasTrait('task_start_artisan20')
		then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_kioshi_quest1.notAvailable = true;
		end
		if getPlayer():HasTrait('quest_cd_ki') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_kioshi_quest1.notAvailable = true;
		end

		-- ЗАВЕРШИТЬ КВЕСТ 1 СТРЕЛЫ
		local option_kioshi_quest1_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, KioshiQuest1Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_kioshi_quest1_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Kioshi_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not getPlayer():HasTrait('task_start_artisan17')
		or not (getPlayer():getInventory():contains("LightArrow") and getPlayer():getInventory():getItemCount("LightArrow") >= 4) then
			context:removeLastOption();
		end
		if getPlayer():HasTrait('quest_cd_ki') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_kioshi_quest1_complete.notAvailable = true;
		end

		--КВЕСТ 2 ДОБЫТЬ ГИЛЬЗЫ
		local option_kioshi_quest2 = subMenu:addOption(getText("ContextMenu_KioshiQuest2"), worldobjects, KioshiQuest2, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_kioshi_quest2.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_KioshiQuest2"));
		toolTip:setTexture("Kioshi_0");
		toolTip.description = getText("Tooltip_KioshiQuest2");
		if getPlayer():HasTrait('task_start_artisan17') or getPlayer():HasTrait('task_start_artisan18')
		or getPlayer():HasTrait('task_start_artisan19') or getPlayer():HasTrait('task_start_artisan20')
		then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_kioshi_quest2.notAvailable = true;
		end
		if getPlayer():HasTrait('quest_cd_ki') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_kioshi_quest2.notAvailable = true;
		end
		if getPlayer():getPerkLevel(Perks.RepCrafts) < 1 then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestPerkLevel1");
			option_kioshi_quest2.notAvailable = true;
		end

		-- ЗАВЕРШИТЬ КВЕСТ 2 ДОБЫТЬ ГИЛЬЗЫ
		local option_kioshi_quest2_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, KioshiQuest2Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_kioshi_quest2_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Kioshi_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not getPlayer():HasTrait('task_start_artisan18')
		or not (getPlayer():getInventory():contains("BulletCasing") and getPlayer():getInventory():getItemCount("BulletCasing") >= 4) then
			context:removeLastOption();
		end
		if getPlayer():HasTrait('quest_cd_ki') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_kioshi_quest2_complete.notAvailable = true;
		end

		--КВЕСТ 3 ПРУЖИНА
		local option_kioshi_quest3 = subMenu:addOption(getText("ContextMenu_KioshiQuest3"), worldobjects, KioshiQuest3, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_kioshi_quest3.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_KioshiQuest3"));
		toolTip:setTexture("Kioshi_0");
		toolTip.description = getText("Tooltip_KioshiQuest3");
		if getPlayer():HasTrait('task_start_artisan17') or getPlayer():HasTrait('task_start_artisan18')
		or getPlayer():HasTrait('task_start_artisan19') or getPlayer():HasTrait('task_start_artisan20')
		then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_kioshi_quest3.notAvailable = true;
		end
		if getPlayer():HasTrait('quest_cd_ki') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_kioshi_quest3.notAvailable = true;
		end
		if getPlayer():getPerkLevel(Perks.RepCrafts) < 2 then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestPerkLevel2");
			option_kioshi_quest3.notAvailable = true;
		end

		-- ЗАВЕРШИТЬ КВЕСТ 3 ПРУЖИНА
		local option_kioshi_quest3_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, KioshiQuest3Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_kioshi_quest3_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Kioshi_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not getPlayer():HasTrait('task_start_artisan19')
		or not (getPlayer():getInventory():contains("Spring") and getPlayer():getInventory():getItemCount("Spring") >= 1) then
			context:removeLastOption();
		end
		if getPlayer():HasTrait('quest_cd_ki') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_kioshi_quest3_complete.notAvailable = true;
		end

		--КВЕСТ 4 КОРПУС ПИСТОЛЕТА
			local option_kioshi_quest4 = subMenu:addOption(getText("ContextMenu_KioshiQuest4"), worldobjects, KioshiQuest4, player)
			local toolTip = ISToolTip:new();
			toolTip:initialise();
			toolTip:setVisible(false);
			option_kioshi_quest4.toolTip = toolTip;
			toolTip:setName(getText("ContextMenu_KioshiQuest4"));
			toolTip:setTexture("Kioshi_0");
			toolTip.description = getText("Tooltip_KioshiQuest4");
			if getPlayer():HasTrait('task_start_artisan17') or getPlayer():HasTrait('task_start_artisan18')
			or getPlayer():HasTrait('task_start_artisan19') or getPlayer():HasTrait('task_start_artisan20')
			then
				toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
				option_kioshi_quest4.notAvailable = true;
			end
			if getPlayer():HasTrait('quest_cd_ki') then
				toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
				option_kioshi_quest4.notAvailable = true;
			end
			if getPlayer():getPerkLevel(Perks.RepCrafts) < 3 then
				toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestPerkLevel3");
				option_kioshi_quest4.notAvailable = true;
			end
	
			-- ЗАВЕРШИТЬ КВЕСТ 4 КОРПУС ПИСТОЛЕТА
			local option_kioshi_quest4_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, KioshiQuest4Complete, player)
			local toolTip = ISToolTip:new();
			toolTip:initialise();
			toolTip:setVisible(false);
			option_kioshi_quest4_complete.toolTip = toolTip;
			toolTip:setName(getText("ContextMenu_CompleteQuest"));
			toolTip:setTexture("Kioshi_0");
			toolTip.description = getText("Tooltip_CompleteQuest");
			if not getPlayer():HasTrait('task_start_artisan20')
			or not (getPlayer():getInventory():contains("Pistolbody") and getPlayer():getInventory():getItemCount("Pistolbody") >= 1) then
				context:removeLastOption();
			end
			if getPlayer():HasTrait('quest_cd_ki') then
				toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
				option_kioshi_quest4_complete.notAvailable = true;
			end

		local option_tutorial_kioshi = context:addOption(getText("ContextMenu_TutorialEng"), worldobjects, TutorialEng, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_tutorial_kioshi.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_TutorialEng"));
		toolTip:setTexture("Kioshi_0");
		toolTip.description = getText("Tooltip_TutorialUp");

		--ИЩЕЙКА ОХОТНИК
	elseif Hound and getPlayer():DistToSquared(x, y) <= 6 then
		local option_hound_hello = context:addOption(getText("ContextMenu_Hound_Hello"), worldobjects, HoundHello, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_hound_hello.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_Hound_Hello"));
		toolTip:setTexture("Hound_0");
		toolTip.description = getText("Tooltip_Hound_Hello");
	
		local option_hound_quests = context:addOption(getText("ContextMenu_Quests"), worldobjects, nil)
		local subMenu = ISContextMenu:getNew(context);
		context:addSubMenu(option_hound_quests, subMenu);

		--КВЕСТ 1 ПРИНЕСТИ ПЕРЬЯ
		local option_hound_quest1 = subMenu:addOption(getText("ContextMenu_HoundQuest1"), worldobjects, HoundQuest1, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_hound_quest1.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_HoundQuest1"));
		toolTip:setTexture("Hound_0");
		toolTip.description = getText("Tooltip_HoundQuest1");
		if getPlayer():HasTrait('task_start_artisan21') or getPlayer():HasTrait('task_start_artisan22')
		or getPlayer():HasTrait('task_start_artisan23') or getPlayer():HasTrait('task_start_artisan24')
		then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_hound_quest1.notAvailable = true;
		end
		if getPlayer():HasTrait('quest_cd_ho') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_hound_quest1.notAvailable = true;
		end

		-- ЗАВЕРШИТЬ КВЕСТ 1 ПЕРЬЯ
		local option_hound_quest1_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, HoundQuest1Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_hound_quest1_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("hound_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not getPlayer():HasTrait('task_start_artisan21')
			or not (getPlayer():getInventory():contains("Feather") and getPlayer():getInventory():getItemCount("Feather") >= 3) then
			context:removeLastOption();
		end
		if getPlayer():HasTrait('quest_cd_ho') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_hound_quest1_complete.notAvailable = true;
		end

		--КВЕСТ 2 ДОБЫТЬ КОСТИ
		local option_hound_quest2 = subMenu:addOption(getText("ContextMenu_HoundQuest2"), worldobjects, HoundQuest2, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_hound_quest2.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_HoundQuest2"));
		toolTip:setTexture("Hound_0");
		toolTip.description = getText("Tooltip_HoundQuest2");
		if getPlayer():HasTrait('task_start_artisan21') or getPlayer():HasTrait('task_start_artisan22')
		or getPlayer():HasTrait('task_start_artisan23') or getPlayer():HasTrait('task_start_artisan24')
		then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_hound_quest2.notAvailable = true;
		end
		if getPlayer():HasTrait('quest_cd_ho') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_hound_quest2.notAvailable = true;
		end
		if getPlayer():getPerkLevel(Perks.RepCrafts) < 1 then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestPerkLevel1");
			option_hound_quest2.notAvailable = true;
		end

		-- ЗАВЕРШИТЬ КВЕСТ 2 КОСТИ
		local option_hound_quest2_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, HoundQuest2Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_hound_quest2_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Hound_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not getPlayer():HasTrait('task_start_artisan22')
			or not (getPlayer():getInventory():contains("Bone") and getPlayer():getInventory():getItemCount("Bone") >= 3) then
			context:removeLastOption();
		end
		if getPlayer():HasTrait('quest_cd_ho') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_hound_quest2_complete.notAvailable = true;
		end

		--КВЕСТ 3 МЫШЕЛОВКА
		local option_hound_quest3 = subMenu:addOption(getText("ContextMenu_HoundQuest3"), worldobjects, HoundQuest3, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_hound_quest3.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_HoundQuest3"));
		toolTip:setTexture("Hound_0");
		toolTip.description = getText("Tooltip_HoundQuest3");
		if getPlayer():HasTrait('task_start_artisan21') or getPlayer():HasTrait('task_start_artisan22')
		or getPlayer():HasTrait('task_start_artisan23') or getPlayer():HasTrait('task_start_artisan24')
		then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_hound_quest3.notAvailable = true;
		end
		if getPlayer():HasTrait('quest_cd_ho') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_hound_quest3.notAvailable = true;
		end
		if getPlayer():getPerkLevel(Perks.RepCrafts) < 2 then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestPerkLevel2");
			option_hound_quest3.notAvailable = true;
		end

		-- ЗАВЕРШИТЬ КВЕСТ 3 МЫШЕЛОВКА
		local option_hound_quest3_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, HoundQuest3Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_hound_quest3_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Hound_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not getPlayer():HasTrait('task_start_artisan23')
			or not (getPlayer():getInventory():contains("TrapMouse") and getPlayer():getInventory():getItemCount("TrapMouse") >= 1) then
			context:removeLastOption();
		end
		if getPlayer():HasTrait('quest_cd_ho') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
			option_hound_quest3_complete.notAvailable = true;
		end

		--КВЕСТ 4 ТУША ЗАЙЦА
			local option_hound_quest4 = subMenu:addOption(getText("ContextMenu_HoundQuest4"), worldobjects, HoundQuest4, player)
			local toolTip = ISToolTip:new();
			toolTip:initialise();
			toolTip:setVisible(false);
			option_hound_quest4.toolTip = toolTip;
			toolTip:setName(getText("ContextMenu_HoundQuest4"));
			toolTip:setTexture("Hound_0");
			toolTip.description = getText("Tooltip_HoundQuest4");
			if getPlayer():HasTrait('task_start_artisan21') or getPlayer():HasTrait('task_start_artisan22')
			or getPlayer():HasTrait('task_start_artisan23') or getPlayer():HasTrait('task_start_artisan24')
			then
				toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
				option_hound_quest4.notAvailable = true;
			end
			if getPlayer():HasTrait('quest_cd_ho') then
				toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
				option_hound_quest4.notAvailable = true;
			end
			if getPlayer():getPerkLevel(Perks.RepCrafts) < 3 then
				toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestPerkLevel3");
				option_hound_quest4.notAvailable = true;
			end
	
			-- ЗАВЕРШИТЬ КВЕСТ 4 ТУША ЗАЙЦА
			local option_hound_quest4_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, HoundQuest4Complete, player)
			local toolTip = ISToolTip:new();
			toolTip:initialise();
			toolTip:setVisible(false);
			option_hound_quest4_complete.toolTip = toolTip;
			toolTip:setName(getText("ContextMenu_CompleteQuest"));
			toolTip:setTexture("Hound_0");
			toolTip.description = getText("Tooltip_CompleteQuest");
			if not getPlayer():HasTrait('task_start_artisan24')
			or not (getPlayer():getInventory():contains("HareCarcass") and getPlayer():getInventory():getItemCount("HareCarcass") >= 1) then
				context:removeLastOption();
			end
			if getPlayer():HasTrait('quest_cd_ho') then
				toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_QuestCooldown");
				option_hound_quest4_complete.notAvailable = true;
			end

		local option_tutorial_hound = context:addOption(getText("ContextMenu_TutorialHunt"), worldobjects, TutorialHunt, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_tutorial_hound.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_TutorialHunt"));
		toolTip:setTexture("Hound_0");
		toolTip.description = getText("Tooltip_TutorialUp");


	elseif Trader and getPlayer():DistToSquared(x, y) <= 6 then
		local option_trader_hello = context:addOption(getText("ContextMenu_Trader_Hello"), worldobjects, TraderHello, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_trader_hello.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_Trader_Hello"));
		toolTip:setTexture("Trader_0");
		toolTip.description = getText("Tooltip_Trader_Hello");
	
		local option_trader_exchange = context:addOption(getText("ContextMenu_Exchange"), worldobjects, nil)
		local subMenu = ISContextMenu:getNew(context);
		context:addSubMenu(option_trader_exchange, subMenu);

		--ОБМЕН 10 СЕРЕБРЯНЫХ НАГГЕТОВ
		local option_trader_exchange1 = subMenu:addOption(getText("ContextMenu_TraderExchange1"), worldobjects, TraderExchange1, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_trader_exchange1.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_TraderExchange1"));
		toolTip:setTexture("Trader_0");
		toolTip.description = getText("Tooltip_TraderExchange1");
		if not (getPlayer():getInventory():contains("NuggetSilver") and getPlayer():getInventory():getItemCount("NuggetSilver") >= 10) then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_NotEnoughRes");
			option_trader_exchange1.notAvailable = true;
		end


		-- ОБМЕН 10 ЗОЛОТЫХ НАГГЕТОВ
		local option_trader_exchange2 = subMenu:addOption(getText("ContextMenu_TraderExchange2"), worldobjects, TraderExchange2, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_trader_exchange2.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_TraderExchange2"));
		toolTip:setTexture("Trader_0");
		toolTip.description = getText("Tooltip_TraderExchange2");
		if not (getPlayer():getInventory():contains("NuggetGold") and getPlayer():getInventory():getItemCount("NuggetGold") >= 10) then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_NotEnoughRes");
			option_trader_exchange2.notAvailable = true;
		end
		
		-- ОБМЕН 1 СЕРЕБРЯНЫЙ СЛИТОК
		local option_trader_exchange3 = subMenu:addOption(getText("ContextMenu_TraderExchange3"), worldobjects, TraderExchange3, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_trader_exchange3.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_TraderExchange3"));
		toolTip:setTexture("Trader_0");
		toolTip.description = getText("Tooltip_TraderExchange3");
		if not (getPlayer():getInventory():contains("IngotSilver") and getPlayer():getInventory():getItemCount("IngotSilver") >= 1) then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_NotEnoughRes");
			option_trader_exchange3.notAvailable = true;
		end
		
		-- ОБМЕН 1 ЗОЛОТОЙ СЛИТОК
		local option_trader_exchange4 = subMenu:addOption(getText("ContextMenu_TraderExchange4"), worldobjects, TraderExchange4, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_trader_exchange4.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_TraderExchange4"));
		toolTip:setTexture("Trader_0");
		toolTip.description = getText("Tooltip_TraderExchange4");
		if not (getPlayer():getInventory():contains("IngotGold") and getPlayer():getInventory():getItemCount("IngotGold") >= 1) then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_NotEnoughRes");
			option_trader_exchange4.notAvailable = true;
		end
		
		-- ОБУЧАЛКА ПО ТОРГОВЛЕ
		local option_tutorial_trader = context:addOption(getText("ContextMenu_TutorialTrade"), worldobjects, TutorialTrade, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_tutorial_trader.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_TutorialTrade"));
		toolTip:setTexture("Trader_0");
		toolTip.description = getText("Tooltip_TutorialUp");


end
end

SparkleHello = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Sparkle.png>" .."<LINE><LINE>".. getText("Tooltip_Sparkle_Dialogue_Hello") .."\n")
	QuestWindow:setVisible(true);
end

HoundHello = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Hound.png>" .."<LINE><LINE>".. getText("Tooltip_Hound_Dialogue_Hello") .."\n")
	QuestWindow:setVisible(true);
end

NerdHello = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Nerd.png>" .."<LINE><LINE>".. getText("Tooltip_Nerd_Dialogue_Hello") .."\n")
	QuestWindow:setVisible(true);
end

AspirinHello = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Aspirin.png>" .."<LINE><LINE>".. getText("Tooltip_Aspirin_Dialogue_Hello") .."\n")
	QuestWindow:setVisible(true);
end

KioshiHello = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Kioshi.png>" .."<LINE><LINE>".. getText("Tooltip_Kioshi_Dialogue_Hello") .."\n")
	QuestWindow:setVisible(true);
end

SilkHello = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Silk.png>" .."<LINE><LINE>".. getText("Tooltip_Silk_Dialogue_Hello") .."\n")
	QuestWindow:setVisible(true);
end

TraderHello = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Trader.png>" .."<LINE><LINE>".. getText("Tooltip_Trader_Dialogue_Hello") .."\n")
	QuestWindow:setVisible(true);
end

TutorialAid = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/NewHope.png>" .."<LINE><LINE>".. getText("Tooltip_TutorialAid") .."\n")
	QuestWindow:setVisible(true);
end

TutorialChem = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/NewHope.png>" .."<LINE><LINE>".. getText("Tooltip_TutorialChem") .."\n")
	QuestWindow:setVisible(true);
end

TutorialElectric = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/NewHope.png>" .."<LINE><LINE>".. getText("Tooltip_TutorialElectric") .."\n")
	QuestWindow:setVisible(true);
end

TutorialEng = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/NewHope.png>" .."<LINE><LINE>".. getText("Tooltip_TutorialEng") .."\n")
	QuestWindow:setVisible(true);
end

TutorialHunt = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/NewHope.png>" .."<LINE><LINE>".. getText("Tooltip_TutorialHunt") .."\n")
	QuestWindow:setVisible(true);
end

TutorialLeather = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/NewHope.png>" .."<LINE><LINE>".. getText("Tooltip_TutorialLeather") .."\n")
	QuestWindow:setVisible(true);
end

TutorialTrade = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/NewHope.png>" .."<LINE><LINE>".. getText("Tooltip_TutorialTrade") .."\n")
	QuestWindow:setVisible(true);
end

-- ИСКРА ЗАДАНИЕ 1
SparkleQuest1 = function()
	getPlayer():getTraits():add("task_start_artisan");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Sparkle.png>" .."<LINE><LINE>".. getText("Tooltip_SparkleQuest1_Take") .."\n")
	QuestWindow:setVisible(true);
end

SparkleQuest1Complete = function()
	getPlayer():getTraits():remove("task_start_artisan");

	getPlayer():getInventory():Remove("ElectronicsScrap");
	getPlayer():getInventory():Remove("ElectronicsScrap");
	getPlayer():getInventory():Remove("ElectronicsScrap");
	getPlayer():getInventory():Remove("ElectronicsScrap");
	getPlayer():getInventory():Remove("ElectronicsScrap");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Sparkle.png>" .."<LINE><LINE>".. getText("Tooltip_SparkleQuest1_Finish") .."\n")
	QuestWindow:setVisible(true);

	if getPlayer():HasTrait("FastLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (30 / 1.3)) 
	elseif getPlayer():HasTrait("SlowLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (30 / 0.7)) 
	else
		getPlayer():getXp():AddXP(Perks.RepCrafts, 30);
	end

	getPlayer():getTraits():add("quest_cd_sp");
	getPlayer():getInventory():AddItem("Base.BookElectrician1")
end

-- ИСКРА ЗАДАНИЕ 2
SparkleQuest2 = function()
	getPlayer():getTraits():add("task_start_artisan2");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Sparkle.png>" .."<LINE><LINE>".. getText("Tooltip_SparkleQuest2_Take") .."\n")
	QuestWindow:setVisible(true);
end

SparkleQuest2Complete = function()
	getPlayer():getTraits():remove("task_start_artisan2");
	
	getPlayer():getInventory():Remove("Screwdriver");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Sparkle.png>" .."<LINE><LINE>".. getText("Tooltip_SparkleQuest2_Finish") .."\n")
	QuestWindow:setVisible(true);

	if getPlayer():HasTrait("FastLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (60 / 1.3)) 
	elseif getPlayer():HasTrait("SlowLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (60 / 0.7)) 
	else
		getPlayer():getXp():AddXP(Perks.RepCrafts, 60);
	end

	getPlayer():getTraits():add("quest_cd_sp");
	getPlayer():getInventory():AddItem("Radio.ElectricWire")
end

-- ИСКРА ЗАДАНИЕ 3
SparkleQuest3 = function()
	getPlayer():getTraits():add("task_start_artisan3");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Sparkle.png>" .."<LINE><LINE>".. getText("Tooltip_SparkleQuest3_Take") .."\n")
	QuestWindow:setVisible(true);
end

SparkleQuest3Complete = function()
	getPlayer():getTraits():remove("task_start_artisan3");

	getPlayer():getInventory():Remove("SiliconOre");
	getPlayer():getInventory():Remove("SiliconOre");
	getPlayer():getInventory():Remove("SiliconOre");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Sparkle.png>" .."<LINE><LINE>".. getText("Tooltip_SparkleQuest3_Finish") .."\n")
	QuestWindow:setVisible(true);

	if getPlayer():HasTrait("FastLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (120 / 1.3)) 
	elseif getPlayer():HasTrait("SlowLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (120 / 0.7)) 
	else
		getPlayer():getXp():AddXP(Perks.RepCrafts, 120);
	end

	getPlayer():getTraits():add("quest_cd_sp");
	getPlayer():getInventory():AddItem("Base.DuctTape")
end

-- ИСКРА ЗАДАНИЕ 4
SparkleQuest4 = function()
	getPlayer():getTraits():add("task_start_artisan4");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Sparkle.png>" .."<LINE><LINE>".. getText("Tooltip_SparkleQuest4_Take") .."\n")
	QuestWindow:setVisible(true);
end


SparkleQuest4Complete = function()
	getPlayer():getTraits():remove("task_start_artisan4");

	getPlayer():getInventory():Remove("WalkieTalkie2");
	getPlayer():getInventory():Remove("WalkieTalkie2");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Sparkle.png>" .."<LINE><LINE>".. getText("Tooltip_SparkleQuest4_Finish") .."\n")
	QuestWindow:setVisible(true);

	if getPlayer():HasTrait("FastLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (300 / 1.3)) 
	elseif getPlayer():HasTrait("SlowLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (300 / 0.7)) 
	else
		getPlayer():getXp():AddXP(Perks.RepCrafts, 300);
	end

	getPlayer():getTraits():add("quest_cd_sp");
	getPlayer():getInventory():AddItem("NHM.QElectric")
end


-- ШЕЛК ЗАДАНИЕ 1
SilkQuest1 = function()
	getPlayer():getTraits():add("task_start_artisan5");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Silk.png>" .."<LINE><LINE>".. getText("Tooltip_SilkQuest1_Take") .."\n")
	QuestWindow:setVisible(true);
end

SilkQuest1Complete = function()
	getPlayer():getTraits():remove("task_start_artisan5");

	getPlayer():getInventory():Remove("Kotomka");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Silk.png>" .."<LINE><LINE>".. getText("Tooltip_SilkQuest1_Finish") .."\n")
	QuestWindow:setVisible(true);

	if getPlayer():HasTrait("FastLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (30 / 1.3)) 
	elseif getPlayer():HasTrait("SlowLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (30 / 0.7)) 
	else
		getPlayer():getXp():AddXP(Perks.RepCrafts, 30);
	end

	getPlayer():getTraits():add("quest_cd_si");
	getPlayer():getInventory():AddItem("Base.Scissors")
end

-- ШЕЛК ЗАДАНИЕ 2
SilkQuest2 = function()
	getPlayer():getTraits():add("task_start_artisan6");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Silk.png>" .."<LINE><LINE>".. getText("Tooltip_SilkQuest2_Take") .."\n")
	QuestWindow:setVisible(true);
end

SilkQuest2Complete = function()
	getPlayer():getTraits():remove("task_start_artisan6");
	
	getPlayer():getInventory():Remove("Rope");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Silk.png>" .."<LINE><LINE>".. getText("Tooltip_SilkQuest2_Finish") .."\n")
	QuestWindow:setVisible(true);

	if getPlayer():HasTrait("FastLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (60 / 1.3)) 
	elseif getPlayer():HasTrait("SlowLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (60 / 0.7)) 
	else
		getPlayer():getXp():AddXP(Perks.RepCrafts, 60);
	end

	getPlayer():getTraits():add("quest_cd_si");
	getPlayer():getInventory():AddItem("Base.Thread")
end

-- ШЕЛК ЗАДАНИЕ 3
SilkQuest3 = function()
	getPlayer():getTraits():add("task_start_artisan7");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Silk.png>" .."<LINE><LINE>".. getText("Tooltip_SilkQuest3_Take") .."\n")
	QuestWindow:setVisible(true);
end

SilkQuest3Complete = function()
	getPlayer():getTraits():remove("task_start_artisan7");
	
	getPlayer():getInventory():Remove("ReadyThinLeather");
	
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Silk.png>" .."<LINE><LINE>".. getText("Tooltip_SilkQuest3_Finish") .."\n")
	QuestWindow:setVisible(true);

	if getPlayer():HasTrait("FastLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (120 / 1.3)) 
	elseif getPlayer():HasTrait("SlowLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (120 / 0.7)) 
	else
		getPlayer():getXp():AddXP(Perks.RepCrafts, 120);
	end

	getPlayer():getTraits():add("quest_cd_si");
	getPlayer():getInventory():AddItem("Base.Tarp")
end

-- ШЕЛК ЗАДАНИЕ 4
SilkQuest4 = function()
	getPlayer():getTraits():add("task_start_artisan8");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Silk.png>" .."<LINE><LINE>".. getText("Tooltip_SilkQuest4_Take") .."\n")
	QuestWindow:setVisible(true);
end


SilkQuest4Complete = function()
	getPlayer():getTraits():remove("task_start_artisan8");

	getPlayer():getInventory():Remove("Bag_Schoolbag");
	
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Silk.png>" .."<LINE><LINE>".. getText("Tooltip_SilkQuest4_Finish") .."\n")
	QuestWindow:setVisible(true);

	getPlayer():getTraits():add("quest_cd_si");

	if getPlayer():HasTrait("FastLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (300 / 1.3)) 
	elseif getPlayer():HasTrait("SlowLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (300 / 0.7)) 
	else
		getPlayer():getXp():AddXP(Perks.RepCrafts, 300);
	end

	local x = ZombRand(1)
	if x == 0 then
	getPlayer():getInventory():AddItem("NHM.QLeatherworking")
	else 
	getPlayer():getInventory():AddItem("NHM.QTailoring")
	end
end

-- БОТАН ЗАДАНИЕ 1
NerdQuest1 = function()
	getPlayer():getTraits():add("task_start_artisan9");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Nerd.png>" .."<LINE><LINE>".. getText("Tooltip_NerdQuest1_Take") .."\n")
	QuestWindow:setVisible(true);
end

NerdQuest1Complete = function()
	getPlayer():getTraits():remove("task_start_artisan9");

	getPlayer():getInventory():Remove("ChemicalFlask");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Nerd.png>" .."<LINE><LINE>".. getText("Tooltip_NerdQuest1_Finish") .."\n")
	QuestWindow:setVisible(true);

	getPlayer():getTraits():add("quest_cd_ne");
	
	if getPlayer():HasTrait("FastLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (30 / 1.3)) 
	elseif getPlayer():HasTrait("SlowLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (30 / 0.7)) 
	else
		getPlayer():getXp():AddXP(Perks.RepCrafts, 30);
	end

	getPlayer():getInventory():AddItem("NHM.Plastic")
	getPlayer():getInventory():AddItem("NHM.Rubber")
end

-- БОТАН ЗАДАНИЕ 2
NerdQuest2 = function()
	getPlayer():getTraits():add("task_start_artisan10");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Nerd.png>" .."<LINE><LINE>".. getText("Tooltip_NerdQuest2_Take") .."\n")
	QuestWindow:setVisible(true);
end

NerdQuest2Complete = function()
	getPlayer():getTraits():remove("task_start_artisan10");

	getPlayer():getInventory():Remove("WoodAsh");
	getPlayer():getInventory():Remove("WoodAsh");
	getPlayer():getInventory():Remove("SulfurPowder");
	getPlayer():getInventory():Remove("SulfurPowder");
	getPlayer():getInventory():Remove("Limestone");
	getPlayer():getInventory():Remove("Limestone");
	
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Nerd.png>" .."<LINE><LINE>".. getText("Tooltip_NerdQuest2_Finish") .."\n")
	QuestWindow:setVisible(true);

	if getPlayer():HasTrait("FastLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (60 / 1.3)) 
	elseif getPlayer():HasTrait("SlowLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (60 / 0.7)) 
	else
		getPlayer():getXp():AddXP(Perks.RepCrafts, 60);
	end

	getPlayer():getTraits():add("quest_cd_ne");
	
	getPlayer():getInventory():AddItem("NHM.CokeCoal")
end

-- БОТАН ЗАДАНИЕ 3
NerdQuest3 = function()
	getPlayer():getTraits():add("task_start_artisan11");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Nerd.png>" .."<LINE><LINE>".. getText("Tooltip_NerdQuest3_Take") .."\n")
	QuestWindow:setVisible(true);
end

NerdQuest3Complete = function()
	getPlayer():getTraits():remove("task_start_artisan11");

	getPlayer():getInventory():Remove("FlaskNitrogen");
	getPlayer():getInventory():AddItem("NHM.ChemicalFlask");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Nerd.png>" .."<LINE><LINE>".. getText("Tooltip_NerdQuest3_Finish") .."\n")
	QuestWindow:setVisible(true);

	if getPlayer():HasTrait("FastLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (120 / 1.3)) 
	elseif getPlayer():HasTrait("SlowLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (120 / 0.7)) 
	else
		getPlayer():getXp():AddXP(Perks.RepCrafts, 120);
	end
	
	getPlayer():getTraits():add("quest_cd_ne");
	getPlayer():getInventory():AddItem("NHM.SaltPinch");
	getPlayer():getInventory():AddItem("NHM.SaltPinch");
end

-- БОТАН ЗАДАНИЕ 4
NerdQuest4 = function()
	getPlayer():getTraits():add("task_start_artisan12");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Nerd.png>" .."<LINE><LINE>".. getText("Tooltip_NerdQuest4_Take") .."\n")
	QuestWindow:setVisible(true);
end


NerdQuest4Complete = function()
	getPlayer():getTraits():remove("task_start_artisan12");
	
	getPlayer():getInventory():Remove("Powder");
	getPlayer():getInventory():Remove("Powder");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Nerd.png>" .."<LINE><LINE>".. getText("Tooltip_NerdQuest4_Finish") .."\n")
	QuestWindow:setVisible(true);

	if getPlayer():HasTrait("FastLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (300 / 1.3)) 
	elseif getPlayer():HasTrait("SlowLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (300 / 0.7)) 
	else
		getPlayer():getXp():AddXP(Perks.RepCrafts, 300);
	end

	getPlayer():getTraits():add("quest_cd_ne");
	getPlayer():getInventory():AddItem("NHM.QChemistry")
end


-- АСПИРИН ЗАДАНИЕ 1
AspirinQuest1 = function()
	getPlayer():getTraits():add("task_start_artisan13");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Aspirin.png>" .."<LINE><LINE>".. getText("Tooltip_AspirinQuest1_Take") .."\n")
	QuestWindow:setVisible(true);
end

AspirinQuest1Complete = function()
	getPlayer():getTraits():remove("task_start_artisan13");
	
	getPlayer():getInventory():Remove("CoalPills");
	getPlayer():getInventory():Remove("CoalPills");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Aspirin.png>" .."<LINE><LINE>".. getText("Tooltip_AspirinQuest1_Finish") .."\n")
	QuestWindow:setVisible(true);

	if getPlayer():HasTrait("FastLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (30 / 1.3)) 
	elseif getPlayer():HasTrait("SlowLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (30 / 0.7)) 
	else
		getPlayer():getXp():AddXP(Perks.RepCrafts, 30);
	end

	getPlayer():getTraits():add("quest_cd_as");
	getPlayer():getInventory():AddItem("Base.Soap2")
end

-- АСПИРИН ЗАДАНИЕ 2
AspirinQuest2 = function()
	getPlayer():getTraits():add("task_start_artisan14");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Aspirin.png>" .."<LINE><LINE>".. getText("Tooltip_AspirinQuest2_Take") .."\n")
	QuestWindow:setVisible(true);
end

AspirinQuest2Complete = function()
	getPlayer():getTraits():remove("task_start_artisan14");
	
	getPlayer():getInventory():Remove("InfectedSample");
	getPlayer():getInventory():Remove("InfectedSample");
	
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Aspirin.png>" .."<LINE><LINE>".. getText("Tooltip_AspirinQuest2_Finish") .."\n")
	QuestWindow:setVisible(true);

	if getPlayer():HasTrait("FastLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (60 / 1.3)) 
	elseif getPlayer():HasTrait("SlowLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (60 / 0.7)) 
	else
		getPlayer():getXp():AddXP(Perks.RepCrafts, 60);
	end

	getPlayer():getTraits():add("quest_cd_as");
	getPlayer():getInventory():AddItem("Base.Disinfectant")
end

-- АСПИРИН ЗАДАНИЕ 3
AspirinQuest3 = function()
	getPlayer():getTraits():add("task_start_artisan15");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Aspirin.png>" .."<LINE><LINE>".. getText("Tooltip_AspirinQuest3_Take") .."\n")
	QuestWindow:setVisible(true);
end

AspirinQuest3Complete = function()
	getPlayer():getTraits():remove("task_start_artisan15");
	
	getPlayer():getInventory():Remove("ComfreyCataplasm");
	getPlayer():getInventory():Remove("PlantainCataplasm");
	getPlayer():getInventory():Remove("WildGarlicCataplasm");
	
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Aspirin.png>" .."<LINE><LINE>".. getText("Tooltip_AspirinQuest3_Finish") .."\n")
	QuestWindow:setVisible(true);

	if getPlayer():HasTrait("FastLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (120 / 1.3)) 
	elseif getPlayer():HasTrait("SlowLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (120 / 0.7)) 
	else
		getPlayer():getXp():AddXP(Perks.RepCrafts, 120);
	end

	getPlayer():getTraits():add("quest_cd_as");
	getPlayer():getInventory():AddItem("Base.SutureNeedle")
end

-- АСПИРИН ЗАДАНИЕ 4
AspirinQuest4 = function()
	getPlayer():getTraits():add("task_start_artisan16");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Aspirin.png>" .."<LINE><LINE>".. getText("Tooltip_AspirinQuest4_Take") .."\n")
	QuestWindow:setVisible(true);
end


AspirinQuest4Complete = function()
	getPlayer():getTraits():remove("task_start_artisan16");

	getPlayer():getInventory():Remove("PillsVitamins");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Aspirin.png>" .."<LINE><LINE>".. getText("Tooltip_AspirinQuest4_Finish") .."\n")
	QuestWindow:setVisible(true);

	if getPlayer():HasTrait("FastLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (300 / 1.3)) 
	elseif getPlayer():HasTrait("SlowLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (300 / 0.7)) 
	else
		getPlayer():getXp():AddXP(Perks.RepCrafts, 300);
	end

	getPlayer():getTraits():add("quest_cd_as");
	getPlayer():getInventory():AddItem("NHM.QFirstAid")
end


-- КИОШИ ИНЖЕНЕР ЗАДАНИЕ 1
KioshiQuest1 = function()
	getPlayer():getTraits():add("task_start_artisan17");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Kioshi.png>" .."<LINE><LINE>".. getText("Tooltip_KioshiQuest1_Take") .."\n")
	QuestWindow:setVisible(true);
end

KioshiQuest1Complete = function()
	getPlayer():getTraits():remove("task_start_artisan17");

	getPlayer():getInventory():Remove("LightArrow");
	getPlayer():getInventory():Remove("LightArrow");
	getPlayer():getInventory():Remove("LightArrow");
	getPlayer():getInventory():Remove("LightArrow");
	
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Kioshi.png>" .."<LINE><LINE>".. getText("Tooltip_KioshiQuest1_Finish") .."\n")
	QuestWindow:setVisible(true);

	if getPlayer():HasTrait("FastLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (30 / 1.3)) 
	elseif getPlayer():HasTrait("SlowLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (30 / 0.7)) 
	else
		getPlayer():getXp():AddXP(Perks.RepCrafts, 30);
	end

	getPlayer():getTraits():add("quest_cd_ki");
	getPlayer():getInventory():AddItem("Base.Battery")
end

-- КИОШИ ИНЖЕНЕР ЗАДАНИЕ 2
KioshiQuest2 = function()
	getPlayer():getTraits():add("task_start_artisan18");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Kioshi.png>" .."<LINE><LINE>".. getText("Tooltip_KioshiQuest2_Take") .."\n")
	QuestWindow:setVisible(true);
end

KioshiQuest2Complete = function()
	getPlayer():getTraits():remove("task_start_artisan18");

	getPlayer():getInventory():Remove("BulletCasing");
	getPlayer():getInventory():Remove("BulletCasing");
	getPlayer():getInventory():Remove("BulletCasing");
	getPlayer():getInventory():Remove("BulletCasing");
	
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Kioshi.png>" .."<LINE><LINE>".. getText("Tooltip_KioshiQuest2_Finish") .."\n")
	QuestWindow:setVisible(true);

	if getPlayer():HasTrait("FastLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (60 / 1.3)) 
	elseif getPlayer():HasTrait("SlowLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (60 / 0.7)) 
	else
		getPlayer():getXp():AddXP(Perks.RepCrafts, 60);
	end

	getPlayer():getTraits():add("quest_cd_ki");
	getPlayer():getInventory():AddItem("Base.WeldingRods")
end

-- КИОШИ ИНЖЕНЕР ЗАДАНИЕ 3
KioshiQuest3 = function()
	getPlayer():getTraits():add("task_start_artisan19");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Kioshi.png>" .."<LINE><LINE>".. getText("Tooltip_KioshiQuest3_Take") .."\n")
	QuestWindow:setVisible(true);
end

KioshiQuest3Complete = function()
	getPlayer():getTraits():remove("task_start_artisan19");
	
	getPlayer():getInventory():Remove("Spring");
	
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Kioshi.png>" .."<LINE><LINE>".. getText("Tooltip_KioshiQuest3_Finish") .."\n")
	QuestWindow:setVisible(true);

	if getPlayer():HasTrait("FastLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (120 / 1.3)) 
	elseif getPlayer():HasTrait("SlowLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (120 / 0.7)) 
	else
		getPlayer():getXp():AddXP(Perks.RepCrafts, 120);
	end

	getPlayer():getTraits():add("quest_cd_ki");
	getPlayer():getInventory():AddItem("NHM.FoldingKnife")
end

-- КИОШИ ИНЖЕНЕР ЗАДАНИЕ 4
KioshiQuest4 = function()
	getPlayer():getTraits():add("task_start_artisan20");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Kioshi.png>" .."<LINE><LINE>".. getText("Tooltip_KioshiQuest4_Take") .."\n")
	QuestWindow:setVisible(true);
end


KioshiQuest4Complete = function()
	getPlayer():getTraits():remove("task_start_artisan20");
	
	getPlayer():getInventory():Remove("Pistolbody");
	
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Kioshi.png>" .."<LINE><LINE>".. getText("Tooltip_KioshiQuest4_Finish") .."\n")
	QuestWindow:setVisible(true);

	if getPlayer():HasTrait("FastLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (300 / 1.3)) 
	elseif getPlayer():HasTrait("SlowLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (300 / 0.7)) 
	else
		getPlayer():getXp():AddXP(Perks.RepCrafts, 300);
	end

	getPlayer():getTraits():add("quest_cd_ki");
	getPlayer():getInventory():AddItem("NHM.QEngineering")
end


-- ИЩЕЙКА ЗАДАНИЕ 1
HoundQuest1 = function()
	getPlayer():getTraits():add("task_start_artisan21");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Hound.png>" .."<LINE><LINE>".. getText("Tooltip_HoundQuest1_Take") .."\n")
	QuestWindow:setVisible(true);
end

HoundQuest1Complete = function()
	getPlayer():getTraits():remove("task_start_artisan21");

	getPlayer():getInventory():Remove("Feather");
	getPlayer():getInventory():Remove("Feather");
	getPlayer():getInventory():Remove("Feather");
	
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Hound.png>" .."<LINE><LINE>".. getText("Tooltip_HoundQuest1_Finish") .."\n")
	QuestWindow:setVisible(true);
	
	if getPlayer():HasTrait("FastLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (30 / 1.3)) 
	elseif getPlayer():HasTrait("SlowLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (30 / 0.7)) 
	else
		getPlayer():getXp():AddXP(Perks.RepCrafts, 30);
	end

	getPlayer():getTraits():add("quest_cd_ho");
	getPlayer():getInventory():AddItem("NHM.FurBoots")
end

-- ИЩЕЙКА ЗАДАНИЕ 2
HoundQuest2 = function()
	getPlayer():getTraits():add("task_start_artisan22");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Hound.png>" .."<LINE><LINE>".. getText("Tooltip_HoundQuest2_Take") .."\n")
	QuestWindow:setVisible(true);
	
end

HoundQuest2Complete = function()
	getPlayer():getTraits():remove("task_start_artisan22");
	
	getPlayer():getInventory():Remove("Bone");
	getPlayer():getInventory():Remove("Bone");
	getPlayer():getInventory():Remove("Bone");
	
	if getPlayer():HasTrait("FastLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (60 / 1.3)) 
	elseif getPlayer():HasTrait("SlowLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (60 / 0.7)) 
	else
		getPlayer():getXp():AddXP(Perks.RepCrafts, 60);
	end

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Hound.png>" .."<LINE><LINE>".. getText("Tooltip_HoundQuest2_Finish") .."\n")
	QuestWindow:setVisible(true);
	
	getPlayer():getTraits():add("quest_cd_ho");
	getPlayer():getInventory():AddItem("NHM.KojankaDOWN")
end

-- ИЩЕЙКА ЗАДАНИЕ 3
HoundQuest3 = function()
	getPlayer():getTraits():add("task_start_artisan23");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Hound.png>" .."<LINE><LINE>".. getText("Tooltip_HoundQuest3_Take") .."\n")
	QuestWindow:setVisible(true);
end

HoundQuest3Complete = function()
	getPlayer():getTraits():remove("task_start_artisan23");
	
	getPlayer():getInventory():Remove("TrapMouse");
	
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Hound.png>" .."<LINE><LINE>".. getText("Tooltip_HoundQuest3_Finish") .."\n")
	QuestWindow:setVisible(true);

	if getPlayer():HasTrait("FastLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (120 / 1.3)) 
	elseif getPlayer():HasTrait("SlowLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (120 / 0.7)) 
	else
		getPlayer():getXp():AddXP(Perks.RepCrafts, 120);
	end

	getPlayer():getTraits():add("quest_cd_ho");
	getPlayer():getInventory():AddItem("NHM.JacketLong_HM")
	getPlayer():getInventory():AddItem("NHM.Trousers_LeatherHM")
end

-- ИЩЕЙКА ЗАДАНИЕ 4
HoundQuest4 = function()
	getPlayer():getTraits():add("task_start_artisan24");

	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Hound.png>" .."<LINE><LINE>".. getText("Tooltip_HoundQuest4_Take") .."\n")
	QuestWindow:setVisible(true);
end


HoundQuest4Complete = function()
	getPlayer():getTraits():remove("task_start_artisan24");
	
	getPlayer():getInventory():Remove("HareCarcass");
	
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Hound.png>" .."<LINE><LINE>".. getText("Tooltip_HoundQuest4_Finish") .."\n")
	QuestWindow:setVisible(true);

	getPlayer():getTraits():add("quest_cd_ho");
	getPlayer():getInventory():AddItem("NHM.QHunting")

	if getPlayer():HasTrait("FastLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (300 / 1.3)) 
	elseif getPlayer():HasTrait("SlowLearner") then
		getPlayer():getXp():AddXP(Perks.RepCrafts, (300 / 0.7)) 
	else
		getPlayer():getXp():AddXP(Perks.RepCrafts, 300);
	end
end

TraderExchange1 = function()
	
	getPlayer():getInventory():Remove("NuggetSilver");
	getPlayer():getInventory():Remove("NuggetSilver");
	getPlayer():getInventory():Remove("NuggetSilver");
	getPlayer():getInventory():Remove("NuggetSilver");
	getPlayer():getInventory():Remove("NuggetSilver");
	getPlayer():getInventory():Remove("NuggetSilver");
	getPlayer():getInventory():Remove("NuggetSilver");
	getPlayer():getInventory():Remove("NuggetSilver");
	getPlayer():getInventory():Remove("NuggetSilver");
	getPlayer():getInventory():Remove("NuggetSilver");

	getPlayer():getInventory():AddItem("Base.Money")
	
end

TraderExchange2 = function()
	
	getPlayer():getInventory():Remove("NuggetGold");
	getPlayer():getInventory():Remove("NuggetGold");
	getPlayer():getInventory():Remove("NuggetGold");
	getPlayer():getInventory():Remove("NuggetGold");
	getPlayer():getInventory():Remove("NuggetGold");
	getPlayer():getInventory():Remove("NuggetGold");
	getPlayer():getInventory():Remove("NuggetGold");
	getPlayer():getInventory():Remove("NuggetGold");
	getPlayer():getInventory():Remove("NuggetGold");
	getPlayer():getInventory():Remove("NuggetGold");

	getPlayer():getInventory():AddItem("Base.Money")
	
end

TraderExchange3 = function()
	
	getPlayer():getInventory():Remove("IngotSilver");

	getPlayer():getInventory():AddItems("Base.Money", 10)
	
end

TraderExchange4 = function()
	
	getPlayer():getInventory():Remove("IngotGold");

	getPlayer():getInventory():AddItems("Base.Money", 10)
	
end

Events.OnFillWorldObjectContextMenu.Add(Work_Stations3);