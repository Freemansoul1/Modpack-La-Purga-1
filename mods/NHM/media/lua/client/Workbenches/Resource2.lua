require "ISUI/ISWorldObjectContextMenu"

function Work_Stations2(player, context, worldobjects, test)

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

	local Sentry
	local Demiurge
	local Nurse 
	local Ghost 
	local Hermit
	local Cleaner
	local Assistant
	local Cook
	local Pharmacist
	local Head

	local archive -- Демиург квест 1
	local morgue -- Демиург квест 2
	local elevator_dirt -- Уборщица квест 1
	local laundry -- Уборщица квест 2
	local computer -- Сестра квест 1
	local violetliquid -- Сестра квест 2
	local microscope -- Ассистент квест 1
	local stars -- Ассистент квест 2
	local sink -- Кухарка квест 1
	local beer -- Кухарка квест 2
	local firecup -- Заведующий квест 1
	local blood -- Заведующий квест 2
	local tablets -- Фармацевт квест 1
	local lovenote -- Фармацевт квест 2

	for i, v in ipairs(worldobjects) do
		
		if v:getSprite():getName() == nil then return; end
		local spriteName = v:getSprite():getName()
		x = v:getX();
		y = v:getY();
		if spriteName == "Demiurge_0"
		then
			Demiurge = v;
		elseif spriteName == "Nurse_0"
		then
			Nurse = v;
		elseif spriteName == "Sentry_0"
		then
			Sentry = v;
		elseif spriteName == "Ghost_0"
		then
			Ghost = v;
		elseif spriteName == "Hermit_0"
		then
			Hermit = v;
		elseif spriteName == "Pharmacist_0"
		then
			Pharmacist = v;
		elseif spriteName == "Cleaner_0"
		then
			Cleaner = v;
		elseif spriteName == "Cook_0"
		then
			Cook = v;
		elseif spriteName == "Head_0"
		then
			Head = v;
		elseif spriteName == "Assistant_0"
		then
			Assistant = v;
		elseif spriteName == "location_community_medical_01_67"
		then
			morgue = v;
		elseif spriteName == "overlay_grime_floor_01_17" or spriteName == "overlay_grime_floor_01_16"  
		or spriteName == "floors_interior_tilesandwood_01_28"  or spriteName == "floors_interior_tilesandwood_01_29" 
		then
			elevator_dirt = v;
		elseif spriteName == "location_business_office_generic_01_33" or spriteName == "location_business_office_generic_01_34"
		then
			archive = v;
		elseif spriteName == "appliances_laundry_01_0" or spriteName == "appliances_laundry_01_01"
		then
			laundry = v;
		elseif spriteName == "appliances_com_01_77" or spriteName == "appliances_com_01_76"
		or spriteName == "appliances_com_01_72" or spriteName == "appliances_com_01_73"
		or spriteName == "appliances_com_01_74" or spriteName == "appliances_com_01_75"
		or spriteName == "appliances_com_01_78" or spriteName == "appliances_com_01_79"
		then
			computer = v;
		elseif spriteName == "location_community_medical_01_65" or spriteName == "location_community_medical_01_64"
		then
			violetliquid = v;
		elseif spriteName == "DylansRandomFurniture03_5" or spriteName == "DylansRandomFurniture03_0"
		or spriteName == "DylansRandomFurniture03_1" or spriteName == "DylansRandomFurniture03_4"
		or spriteName == "DylansRandomFurniture03_6" or spriteName == "DylansRandomFurniture03_7"
		then
			microscope = v;
		elseif spriteName == "DylansRandomFurniture03_8" or spriteName == "DylansRandomFurniture03_9"
		then
			stars = v;
		elseif spriteName == "fixtures_sinks_01_9" or spriteName == "fixtures_sinks_01_8"
		or spriteName == "fixtures_sinks_01_13" or spriteName == "fixtures_sinks_01_14"
		or spriteName == "fixtures_sinks_01_12" or spriteName == "fixtures_sinks_01_15"
		or spriteName == "fixtures_sinks_01_0" or spriteName == "fixtures_sinks_01_1"
		or spriteName == "fixtures_sinks_01_2" or spriteName == "fixtures_sinks_01_3"
		or spriteName == "fixtures_sinks_01_4" or spriteName == "fixtures_sinks_01_5"
		or spriteName == "fixtures_sinks_01_6" or spriteName == "fixtures_sinks_01_7"
		or spriteName == "fixtures_sinks_01_10" or spriteName == "fixtures_sinks_01_11"
		or spriteName == "fixtures_sinks_01_16" or spriteName == "fixtures_sinks_01_17"
		or spriteName == "fixtures_sinks_01_18" or spriteName == "fixtures_sinks_01_19"
		or spriteName == "fixtures_sinks_01_20" or spriteName == "fixtures_sinks_01_21"
		or spriteName == "fixtures_sinks_01_22" or spriteName == "fixtures_sinks_01_23"
		or spriteName == "fixtures_sinks_01_24" or spriteName == "fixtures_sinks_01_25"
		then
			sink = v;
		elseif spriteName == "A1 decor_container_2" or spriteName == "A1 decor_container_3"
		then
			beer = v;
		elseif spriteName == "A1 decor_sr_35"
		then
			firecup = v;
		elseif spriteName == "A1 decor_med_8" or spriteName == "A1 decor_med_10"
		then
			blood = v;
		elseif spriteName == "A1 decor_med_55"
		then
			tablets = v;
		end
	end
	
	local MineEnd = getPlayer():getXp():getXP(Perks.MineEndurance)
	local DocRep = getPlayer():getXp():getXP(Perks.RepDoc)
	local DocTaskTaken = getPlayer():HasTrait('task_start_med')
	local End = getPlayer():getStats():getEndurance()
	local Fatique = getPlayer():getStats():getFatigue()
	
--ЧАСОВОЙ			
	if Sentry and getPlayer():DistToSquared(x, y) <= 6 then
		local option_sentry_hello = context:addOption(getText("ContextMenu_Sentry_Hello"), worldobjects, SentryHello, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_sentry_hello.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_Sentry_Hello"));
		toolTip:setTexture("Sentry_0");
		toolTip.description = getText("Tooltip_Sentry_Hello");
	
		local option_sentry_exit = context:addOption(getText("ContextMenu_Sentry_Exit"), worldobjects, SentryExit, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_sentry_exit.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_Sentry_Exit"));
		toolTip:setTexture("Sentry_0");
		toolTip.description = getText("Tooltip_Sentry_Exit");
		if DocTaskTaken then 
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocRep");
			option_sentry_exit.notAvailable = true;
		end
	
		local option_tutorial_8 = context:addOption(getText("ContextMenu_Tutorial8"), worldobjects, Tutorial8, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_tutorial_8.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_Tutorial8"));
		toolTip:setTexture("Sentry_0");
		toolTip.description = getText("Tooltip_Tutorial");
	
	--ОТШЕЛЬНИК
	elseif Hermit and getPlayer():DistToSquared(x, y) <= 4 then
		local option_hermit_hello = context:addOption(getText("ContextMenu_Hermit_Hello"), worldobjects, HermitHello, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_hermit_hello.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_Hermit_Hello"));
		toolTip:setTexture("Hermit_0");
		toolTip.description = getText("Tooltip_Hermit_Hello");
	
		local option_hermit_humour = context:addOption(getText("ContextMenu_Hermit_Humour"), worldobjects, HermitHumour, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_hermit_humour.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_Hermit_Humour"));
		toolTip:setTexture("Hermit_0");
		toolTip.description = getText("Tooltip_Hermit_Humour");
	
	
	--БАБА ГАЛЯ
	elseif Cleaner and getPlayer():DistToSquared(x, y) <= 4 then
		local option_cleaner_hello = context:addOption(getText("ContextMenu_Cleaner_Hello"), worldobjects, CleanerHello, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_cleaner_hello.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_Cleaner_Hello"));
		toolTip:setTexture("Cleaner_0");
		toolTip.description = getText("Tooltip_Cleaner_Hello");
	--САБМЕНЮ КВЕСТЫ
		local option_cleaner_quests = context:addOption(getText("ContextMenu_Quests"), worldobjects, nil)
		local subMenu = ISContextMenu:getNew(context);
		context:addSubMenu(option_cleaner_quests, subMenu);
	--КВЕСТ 1 ОТМЫТЬ ПОЛ
		local option_cleaner_quest1 = subMenu:addOption(getText("ContextMenu_CleanerQuest1"), worldobjects, CleanerQuest1, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_cleaner_quest1.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CleanerQuest1"));
		toolTip:setTexture("floors_interior_tilesandwood_01_28");
		toolTip.description = getText("Tooltip_CleanerQuest1");
		if DocTaskTaken then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_cleaner_quest1.notAvailable = true;
		end
	-- ЗАВЕРШИТЬ КВЕСТ 1 ОТМЫТЬ ПОЛ
		local option_cleaner_quest1_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, CleanerQuest1Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_cleaner_quest1_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Cleaner_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not (DocTaskTaken and getPlayer():getInventory():contains("QuestHBroomDirty") and getPlayer():getInventory():contains("QuestHBucketDirty")) then
			context:removeLastOption();
		end
	--КВЕСТ 2 ОТСТИРАТЬ РУБАШКУ
		local option_cleaner_quest2 = subMenu:addOption(getText("ContextMenu_CleanerQuest2"), worldobjects, CleanerQuest2, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_cleaner_quest2.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CleanerQuest2"));
		toolTip:setTexture("appliances_laundry_01_0");
		toolTip.description = getText("Tooltip_CleanerQuest2");
		if DocTaskTaken then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_cleaner_quest2.notAvailable = true;
		end
	-- ЗАВЕРШИТЬ КВЕСТ 2 ОТСТИРАТЬ РУБАШКУ
		local option_cleaner_quest2_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, CleanerQuest2Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_cleaner_quest2_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Cleaner_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not (DocTaskTaken and getPlayer():getInventory():contains("QuestHCleanCloth")) then
			context:removeLastOption();
		end
	
		local option_tutorial_1 = context:addOption(getText("ContextMenu_Tutorial1"), worldobjects, Tutorial1, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_tutorial_1.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_Tutorial1"));
		toolTip:setTexture("Cleaner_0");
		toolTip.description = getText("Tooltip_Tutorial");
	
	--ДЕМИУРГ
	elseif Demiurge and getPlayer():DistToSquared(x, y) <= 4 then
		local option_demiurge_hello = context:addOption(getText("ContextMenu_Demiurge_Hello"), worldobjects, DemiurgeHello, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_demiurge_hello.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_Demiurge_Hello"));
		toolTip:setTexture("Demiurge_0");
		toolTip.description = getText("Tooltip_Demiurge_Hello");
	
		local option_demiurge_quests = context:addOption(getText("ContextMenu_Quests"), worldobjects, nil)
		local subMenu = ISContextMenu:getNew(context);
		context:addSubMenu(option_demiurge_quests, subMenu);
	
		--КВЕСТ 1 АРХИВ
		local option_demiurge_quest1 = subMenu:addOption(getText("ContextMenu_DemiurgeQuest1"), worldobjects, DemiurgeQuest1, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_demiurge_quest1.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_DemiurgeQuest1"));
		toolTip:setTexture("location_business_office_generic_01_33");
		toolTip.description = getText("Tooltip_DemiurgeQuest1");
		if DocTaskTaken then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_demiurge_quest1.notAvailable = true;
		end
	-- ЗАВЕРШИТЬ КВЕСТ 1 АРХИВ
		local option_demiurge_quest1_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, DemiurgeQuest1Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_demiurge_quest1_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Demiurge_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not (DocTaskTaken and getPlayer():getInventory():contains("QuestHArchive")) then
			context:removeLastOption();
		end
		--КВЕСТ 2 МОРГ
		local option_demiurge_quest2 = subMenu:addOption(getText("ContextMenu_DemiurgeQuest2"), worldobjects, DemiurgeQuest2, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_demiurge_quest2.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_DemiurgeQuest2"));
		toolTip:setTexture("location_community_medical_01_67");
		toolTip.description = getText("Tooltip_DemiurgeQuest2");
		if DocTaskTaken then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_demiurge_quest2.notAvailable = true;
		end
	-- ЗАВЕРШИТЬ КВЕСТ 2 МОРГ
		local option_demiurge_quest2_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, DemiurgeQuest2Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_demiurge_quest2_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Demiurge_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not (DocTaskTaken and getPlayer():getInventory():contains("QuestHDeadSaw")) then
			context:removeLastOption();
		end
	
		local option_tutorial_2 = context:addOption(getText("ContextMenu_Tutorial2"), worldobjects, Tutorial2, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_tutorial_2.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_Tutorial2"));
		toolTip:setTexture("Demiurge_0");
		toolTip.description = getText("Tooltip_Tutorial");
	
--СЕСТРА
	elseif Nurse and getPlayer():DistToSquared(x, y) <= 4 then
		local option_nurse_hello = context:addOption(getText("ContextMenu_Nurse_Hello"), worldobjects, NurseHello, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_nurse_hello.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_Nurse_Hello"));
		toolTip:setTexture("Nurse_0");
		toolTip.description = getText("Tooltip_Nurse_Hello");
	
		local option_nurse_quests = context:addOption(getText("ContextMenu_Quests"), worldobjects, nil)
		local subMenu = ISContextMenu:getNew(context);
		context:addSubMenu(option_nurse_quests, subMenu);
	
--КВЕСТ 1 ДИСКЕТА
		local option_nurse_quest1 = subMenu:addOption(getText("ContextMenu_NurseQuest1"), worldobjects, NurseQuest1, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_nurse_quest1.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_NurseQuest1"));
		toolTip:setTexture("appliances_com_01_77");
		toolTip.description = getText("Tooltip_NurseQuest1");
		if DocTaskTaken then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_nurse_quest1.notAvailable = true;
		end
-- ЗАВЕРШИТЬ КВЕСТ 1 ДИСКЕТА
		local option_nurse_quest1_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, NurseQuest1Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_nurse_quest1_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Nurse_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not (DocTaskTaken and getPlayer():getInventory():contains("QuestHFullDisk")) then
			context:removeLastOption();
		end
	
	--КВЕСТ 2 КОЛБА
	local option_nurse_quest2 = subMenu:addOption(getText("ContextMenu_NurseQuest2"), worldobjects, NurseQuest2, player)
	local toolTip = ISToolTip:new();
	toolTip:initialise();
	toolTip:setVisible(false);
	option_nurse_quest2.toolTip = toolTip;
	toolTip:setName(getText("ContextMenu_NurseQuest2"));
	toolTip:setTexture("location_community_medical_01_65");
	toolTip.description = getText("Tooltip_NurseQuest2");
	if DocTaskTaken then
		toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
		option_nurse_quest2.notAvailable = true;
	end
	
	-- ЗАВЕРШИТЬ КВЕСТ 2 КОЛБА
	local option_nurse_quest2_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, NurseQuest2Complete, player)
	local toolTip = ISToolTip:new();
	toolTip:initialise();
	toolTip:setVisible(false);
	option_nurse_quest2_complete.toolTip = toolTip;
	toolTip:setName(getText("ContextMenu_CompleteQuest"));
	toolTip:setTexture("Nurse_0");
	toolTip.description = getText("Tooltip_CompleteQuest");
	if not (DocTaskTaken and getPlayer():getInventory():contains("QuestHFullFlask")) then
		context:removeLastOption();
	end
	
		local option_tutorial_3 = context:addOption(getText("ContextMenu_Tutorial3"), worldobjects, Tutorial3, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_tutorial_3.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_Tutorial3"));
		toolTip:setTexture("Nurse_0");
		toolTip.description = getText("Tooltip_Tutorial");
	--ЗАВЕДУЮЩИЙ
	elseif Head and getPlayer():DistToSquared(x, y) <= 4 then
		local option_head_hello = context:addOption(getText("ContextMenu_Head_Hello"), worldobjects, HeadHello, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_head_hello.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_Head_Hello"));
		toolTip:setTexture("Head_0");
		toolTip.description = getText("Tooltip_Head_Hello");
	
		local option_head_quests = context:addOption(getText("ContextMenu_Quests"), worldobjects, nil)
		local subMenu = ISContextMenu:getNew(context);
		context:addSubMenu(option_head_quests, subMenu);
	
		--КВЕСТ 1 ОГНЕТУШИТЕЛЬ
		local option_head_quest1 = subMenu:addOption(getText("ContextMenu_HeadQuest1"), worldobjects, HeadQuest1, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_head_quest1.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_HeadQuest1"));
		toolTip:setTexture("A1 decor_sr_35");
		toolTip.description = getText("Tooltip_HeadQuest1");
		if DocTaskTaken then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_head_quest1.notAvailable = true;
		end
		-- ЗАВЕРШИТЬ КВЕСТ 1 ОГНЕТУШИТЕЛЬ
		local option_head_quest1_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, HeadQuest1Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_head_quest1_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Head_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not (DocTaskTaken and getPlayer():getInventory():contains("QuestHFireEx")) then
			context:removeLastOption();
		end

		--КВЕСТ 2 ПАКЕТ КРОВИ
		local option_head_quest2 = subMenu:addOption(getText("ContextMenu_HeadQuest2"), worldobjects, HeadQuest2, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_head_quest2.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_HeadQuest2"));
		toolTip:setTexture("A1 decor_med_8");
		toolTip.description = getText("Tooltip_HeadQuest2");
		if DocTaskTaken then
		toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
		option_head_quest2.notAvailable = true;
		end

		-- ЗАВЕРШИТЬ КВЕСТ 2 ПАКЕТ КРОВИ
		local option_head_quest2_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, HeadQuest2Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_head_quest2_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Head_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not (DocTaskTaken and getPlayer():getInventory():contains("QuestHFullBloodBag")) then
		context:removeLastOption();
		end

		local option_tutorial_4 = context:addOption(getText("ContextMenu_Tutorial4"), worldobjects, Tutorial4, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_tutorial_4.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_Tutorial4"));
		toolTip:setTexture("Head_0");
		toolTip.description = getText("Tooltip_Tutorial");

		local option_pharmacistquest2_do = context:addOption(getText("ContextMenu_PharmacistQuest2"), worldobjects, Lovenote, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_pharmacistquest2_do.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_PharmacistQuest2"));
		toolTip:setTexture("Pharmacist_0");
		if not DocTaskTaken then 
			context:removeLastOption();
		end
		if not getPlayer():getInventory():contains("QuestHLoveNote") then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_PharmacistQuest2NotTaken") .. "\n";
			option_pharmacistquest2_do.notAvailable = true;
		end
	
		--АССИСТЕНТ
	elseif Assistant and getPlayer():DistToSquared(x, y) <= 4 then
		local option_assistant_hello = context:addOption(getText("ContextMenu_Assistant_Hello"), worldobjects, AssistantHello, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_assistant_hello.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_Assistant_Hello"));
		toolTip:setTexture("Assistant_0");
		toolTip.description = getText("Tooltip_Assistant_Hello");
	
		local option_assistant_quests = context:addOption(getText("ContextMenu_Quests"), worldobjects, nil)
		local subMenu = ISContextMenu:getNew(context);
		context:addSubMenu(option_assistant_quests, subMenu);

		--КВЕСТ 2 ТЕЛЕСКОП
		local option_assistant_quest2 = subMenu:addOption(getText("ContextMenu_AssistantQuest2"), worldobjects, AssistantQuest2, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_assistant_quest2.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_AssistantQuest2"));
		toolTip:setTexture("DylansRandomFurniture03_8");
		toolTip.description = getText("Tooltip_AssistantQuest2");
		if DocTaskTaken then
		toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
		option_assistant_quest2.notAvailable = true;
		end

		-- ЗАВЕРШИТЬ КВЕСТ 2 ТЕЛЕСКОП
		local option_assistant_quest2_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, AssistantQuest2Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_assistant_quest2_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Assistant_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not (DocTaskTaken and getPlayer():getInventory():contains("QuestHStars")) then
		context:removeLastOption();
		end

		local option_tutorial_5 = context:addOption(getText("ContextMenu_Tutorial5"), worldobjects, Tutorial5, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_tutorial_5.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_Tutorial5"));
		toolTip:setTexture("Assistant_0");
		toolTip.description = getText("Tooltip_Tutorial");
	-- ФАРМАЦЕВТ
	elseif Pharmacist and getPlayer():DistToSquared(x, y) <= 4 then
		local option_pharmacist_hello = context:addOption(getText("ContextMenu_Pharmacist_Hello"), worldobjects, PharmacistHello, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_pharmacist_hello.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_Pharmacist_Hello"));
		toolTip:setTexture("Pharmacist_0");
		toolTip.description = getText("Tooltip_Pharmacist_Hello");
	
		local option_pharmacist_quests = context:addOption(getText("ContextMenu_Quests"), worldobjects, nil)
		local subMenu = ISContextMenu:getNew(context);
		context:addSubMenu(option_pharmacist_quests, subMenu);
	
		--КВЕСТ 1 ТАБЛЕТКИ
		local option_pharmacist_quest1 = subMenu:addOption(getText("ContextMenu_PharmacistQuest1"), worldobjects, PharmacistQuest1, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_pharmacist_quest1.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_PharmacistQuest1"));
		toolTip:setTexture("A1 decor_med_55");
		toolTip.description = getText("Tooltip_PharmacistQuest1");
		if DocTaskTaken then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
			option_pharmacist_quest1.notAvailable = true;
		end
		-- ЗАВЕРШИТЬ КВЕСТ 1 ТАБЛЕТКИ
		local option_pharmacist_quest1_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, PharmacistQuest1Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_pharmacist_quest1_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Pharmacist_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not (DocTaskTaken and getPlayer():getInventory():contains("QuestHTablets")) then
			context:removeLastOption();
		end

		--КВЕСТ 2 ЛЮБОВНАЯ ЗАПИСКА
		local option_pharmacist_quest2 = subMenu:addOption(getText("ContextMenu_PharmacistQuest2"), worldobjects, PharmacistQuest2, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_pharmacist_quest2.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_PharmacistQuest2"));
		toolTip:setTexture("Head_0");
		toolTip.description = getText("Tooltip_PharmacistQuest2");
		if DocTaskTaken then
		toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
		option_pharmacist_quest2.notAvailable = true;
		end

		-- ЗАВЕРШИТЬ КВЕСТ 2 ЛЮБОВНАЯ ЗАПИСКА
		local option_pharmacist_quest2_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, PharmacistQuest2Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_pharmacist_quest2_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Pharmacist_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not (DocTaskTaken and getPlayer():getInventory():contains("QuestHLoveNoteBack")) then
		context:removeLastOption();
		end

		local option_tutorial_6 = context:addOption(getText("ContextMenu_Tutorial6"), worldobjects, Tutorial6, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_tutorial_6.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_Tutorial6"));
		toolTip:setTexture("Pharmacist_0");
		toolTip.description = getText("Tooltip_Tutorial");
	
	--КУХАРКА
	elseif Cook and getPlayer():DistToSquared(x, y) <= 4 then
		local option_cook_hello = context:addOption(getText("ContextMenu_Cook_Hello"), worldobjects, CookHello, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_cook_hello.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_Cook_Hello"));
		toolTip:setTexture("Cook_0");
		toolTip.description = getText("Tooltip_Cook_Hello");
	
		local option_cook_quests = context:addOption(getText("ContextMenu_Quests"), worldobjects, nil)
		local subMenu = ISContextMenu:getNew(context);
		context:addSubMenu(option_cook_quests, subMenu);

		--КВЕСТ 2 БОЧОНОК ПИВА
		local option_cook_quest2 = subMenu:addOption(getText("ContextMenu_CookQuest2"), worldobjects, CookQuest2, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_cook_quest2.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CookQuest2"));
		toolTip:setTexture("A1 decor_container_2");
		toolTip.description = getText("Tooltip_CookQuest2");
		if DocTaskTaken then
		toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DocTaskTaken");
		option_cook_quest2.notAvailable = true;
		end

		-- ЗАВЕРШИТЬ КВЕСТ 2 БОЧОНОК ПИВА
		local option_cook_quest2_complete = context:addOption(getText("ContextMenu_CompleteQuest"), worldobjects, CookQuest2Complete, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_cook_quest2_complete.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CompleteQuest"));
		toolTip:setTexture("Cook_0");
		toolTip.description = getText("Tooltip_CompleteQuest");
		if not (DocTaskTaken and getPlayer():getInventory():contains("QuestHBeer")) then
		context:removeLastOption();
		end

		local option_dailyfood = context:addOption(getText("ContextMenu_DailyFood"), worldobjects, DailyFood, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_dailyfood.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_DailyFood"));
		toolTip:setTexture("Cook_0");
		toolTip.description = getText("Tooltip_DailyFood");
		if food_cd > 0 then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_FoodCooldown");
			option_dailyfood.notAvailable = true;
			end

		local option_tutorial_7 = context:addOption(getText("ContextMenu_Tutorial7"), worldobjects, Tutorial7, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_tutorial_7.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_Tutorial7"));
		toolTip:setTexture("Cook_0");
		toolTip.description = getText("Tooltip_Tutorial");

	elseif Ghost and getPlayer():DistToSquared(x, y) <= 4 then
		local option_ghost_hello = context:addOption(getText("ContextMenu_Ghost_Hello"), worldobjects, GhostHello, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_ghost_hello.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_Ghost_Hello"));
		toolTip:setTexture("Ghost_0");
		toolTip.description = getText("Tooltip_Ghost_Hello");
	
		local option_ghost_quests = context:addOption(getText("ContextMenu_Quests"), worldobjects, nil)
		local subMenu = ISContextMenu:getNew(context);
		context:addSubMenu(option_ghost_quests, subMenu);
	
		--КВЕСТ схрон
		local option_ghost_quest1 = subMenu:addOption(getText("ContextMenu_GhostQuest1"), worldobjects, GhostQuest1, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_ghost_quest1.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_GhostQuest1"));
		toolTip:setTexture("Ghost_0");
		toolTip.description = getText("Tooltip_GhostQuest1");
		if getPlayer():HasTrait('quest_cd1') then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_GhostCooldown");
			option_ghost_quest1.notAvailable = true;
		end
		if not (getPlayer():getInventory():contains("Money") and getPlayer():getInventory():getItemCount("Money") >= 25) then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_NotEnoughMoney_Ghost");
			option_ghost_quest1.notAvailable = true;
		end

	elseif elevator_dirt and getPlayer():DistToSquared(x, y) <= 6 then 
		local option_cleanerquest1_do = context:addOption(getText("ContextMenu_CleanerQuest1"), worldobjects, ElevatorDirt, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_cleanerquest1_do.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CleanerQuest1"));
		toolTip:setTexture("floors_interior_tilesandwood_01_28");
		if not DocTaskTaken then 
			context:removeLastOption();
		end
		if not getPlayer():getInventory():contains("QuestHBroom") and not getPlayer():getInventory():contains("QuestHBucket") then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_CleanerQuest1NotTaken") .. "\n";
			option_cleanerquest1_do.notAvailable = true;
		end
	
	elseif archive and getPlayer():DistToSquared(x, y) <= 6 then 
		local option_demiurgequest1_do = context:addOption(getText("ContextMenu_DemiurgeQuest1"), worldobjects, Archive, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_demiurgequest1_do.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_DemiurgeQuest1"));
		toolTip:setTexture("location_business_office_generic_01_33");
		if not DocTaskTaken then 
			context:removeLastOption();
		end
		if not getPlayer():getInventory():contains("QuestHTip") then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DemiurgeQuest1NotTaken") .. "\n";
			option_demiurgequest1_do.notAvailable = true;
		end
	
	elseif morgue and getPlayer():DistToSquared(x, y) <= 6 then 
		local option_demiurgequest2_do = context:addOption(getText("ContextMenu_DemiurgeQuest2"), worldobjects, Morgue, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_demiurgequest2_do.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_DemiurgeQuest2"));
		toolTip:setTexture("location_community_medical_01_67");
		if not DocTaskTaken then 
			context:removeLastOption();
		end
		if not getPlayer():getInventory():contains("QuestHTweezers") then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_DemiurgeQuest2NotTaken") .. "\n";
			option_demiurgequest2_do.notAvailable = true;
		end
		
	elseif laundry and getPlayer():DistToSquared(x, y) <= 6 then 
		local option_cleanerquest2_do = context:addOption(getText("ContextMenu_CleanerQuest2"), worldobjects, Laundry, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_cleanerquest2_do.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CleanerQuest2"));
		toolTip:setTexture("appliances_laundry_01_0");
		if not DocTaskTaken then 
			context:removeLastOption();
		end
		if not getPlayer():getInventory():contains("QuestHDirtyCloth") then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_CleanerQuest2NotTaken") .. "\n";
			option_cleanerquest2_do.notAvailable = true;
		end
	
	elseif computer and getPlayer():DistToSquared(x, y) <= 6 then 
		local option_nursequest1_do = context:addOption(getText("ContextMenu_NurseQuest1"), worldobjects, Computer, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_nursequest1_do.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_NurseQuest1"));
		toolTip:setTexture("appliances_com_01_77");
		if not DocTaskTaken then 
			context:removeLastOption();
		end
		if not getPlayer():getInventory():contains("QuestHDisk") then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_NurseQuest1NotTaken") .. "\n";
			option_nursequest1_do.notAvailable = true;
		end
	
	elseif violetliquid and getPlayer():DistToSquared(x, y) <= 6 then 
		local option_nursequest2_do = context:addOption(getText("ContextMenu_NurseQuest2"), worldobjects, VioletLiquid, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_nursequest2_do.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_NurseQuest2"));
		toolTip:setTexture("location_community_medical_01_65");
		if not DocTaskTaken then 
			context:removeLastOption();
		end
		if not getPlayer():getInventory():contains("QuestHEmptyFlask") then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_NurseQuest2NotTaken") .. "\n";
			option_nursequest2_do.notAvailable = true;
		end

	elseif stars and getPlayer():DistToSquared(x, y) <= 6 then 
		local option_assistantquest2_do = context:addOption(getText("ContextMenu_AssistantQuest2"), worldobjects, Stars, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_assistantquest2_do.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_AssistantQuest2"));
		toolTip:setTexture("DylansRandomFurniture03_8");
		if not DocTaskTaken then 
			context:removeLastOption();
		end
		if not getPlayer():getInventory():contains("QuestHEmptyStars") then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_AssistantQuest2NotTaken") .. "\n";
			option_assistantquest2_do.notAvailable = true;
		end

	elseif beer and getPlayer():DistToSquared(x, y) <= 6 then 
		local option_cookquest2_do = context:addOption(getText("ContextMenu_CookQuest2"), worldobjects, Beer, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_cookquest2_do.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_CookQuest2"));
		toolTip:setTexture("A1 decor_container_3");
		if not DocTaskTaken then 
			context:removeLastOption();
		end
		if not getPlayer():getInventory():contains("QuestHEmptyBeer") then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_CookQuest2NotTaken") .. "\n";
			option_cookquest2_do.notAvailable = true;
		end

	elseif firecup and getPlayer():DistToSquared(x, y) <= 6 then 
	local option_headquest1_do = context:addOption(getText("ContextMenu_HeadQuest1"), worldobjects, Firecup, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_headquest1_do.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_HeadQuest1"));
		toolTip:setTexture("A1 decor_sr_35");
		if not DocTaskTaken then 
			context:removeLastOption();
		end
		if not getPlayer():getInventory():contains("QuestHKey") then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_HeadQuest1NotTaken") .. "\n";
			option_headquest1_do.notAvailable = true;
		end

	elseif blood and getPlayer():DistToSquared(x, y) <= 6 then 
	local option_headquest2_do = context:addOption(getText("ContextMenu_HeadQuest2"), worldobjects, Blood, player);
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_headquest2_do.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_HeadQuest2"));
		toolTip:setTexture("A1 decor_med_8");
		if not DocTaskTaken then 
			context:removeLastOption();
		end
		if not getPlayer():getInventory():contains("QuestHBloodBag") then
			toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_HeadQuest2NotTaken") .. "\n";
			option_headquest2_do.notAvailable = true;
		end

	elseif tablets and getPlayer():DistToSquared(x, y) <= 6 then 
		local option_pharmacistquest1_do = context:addOption(getText("ContextMenu_PharmacistQuest1"), worldobjects, Tablets, player);
			local toolTip = ISToolTip:new();
			toolTip:initialise();
			toolTip:setVisible(false);
			option_pharmacistquest1_do.toolTip = toolTip;
			toolTip:setName(getText("ContextMenu_PharmacistQuest1"));
			toolTip:setTexture("A1 decor_med_55");
			if not DocTaskTaken then 
				context:removeLastOption();
			end
			if not getPlayer():getInventory():contains("QuestHMortPest") then
				toolTip.description = toolTip.description .. "\n<RGB:1,0,0>" .. getText("Tooltip_PharmacistQuest1NotTaken") .. "\n";
				option_pharmacistquest1_do.notAvailable = true;
			end
end
end


SentryHello = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Sentry.png>" .."<LINE><LINE>".. getText("Tooltip_Sentry_Dialogue_Hello") .."\n")
	QuestWindow:setVisible(true);
end

SentryExit = function(worldobjects, player, item)
	local playerObj = getSpecificPlayer(player)
	playerObj:setX(11539);
	playerObj:setY(7604);
	playerObj:setZ(0);
	playerObj:setLx(playerObj:getX());
	playerObj:setLy(playerObj:getY());
	playerObj:setLz(playerObj:getZ());
	while 
		(getPlayer():getInventory():contains("QuestHDailyFood") and getPlayer():getInventory():getItemCount("QuestHDailyFood") > 1)
	do 
		getPlayer():getInventory():Remove("QuestHDailyFood");
	end
	while
		(getPlayer():getInventory():contains("QuestHDailyWater") and getPlayer():getInventory():getItemCount("QuestHDailyWater") > 1)
	do
		getPlayer():getInventory():Remove("QuestHDailyWater");
	end
end

HermitHello = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Hermit.png>" .."<LINE><LINE>".. getText("Tooltip_Hermit_Dialogue_Hello") .."\n")
	QuestWindow:setVisible(true);
end

HermitHumour = function()
	local x = ZombRand(12)
	if x==0 then 
		QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Hermit.png>" .."<LINE><LINE>".. getText("Tooltip_Hermit_Humour0") .."\n")
		QuestWindow:setVisible(true);
	elseif x==1 then 
		QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Hermit.png>" .."<LINE><LINE>".. getText("Tooltip_Hermit_Humour1") .."\n")
		QuestWindow:setVisible(true);
	elseif x==2 then 
		QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Hermit.png>" .."<LINE><LINE>".. getText("Tooltip_Hermit_Humour2") .."\n")
		QuestWindow:setVisible(true);
	elseif x==3 then 
		QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Hermit.png>" .."<LINE><LINE>".. getText("Tooltip_Hermit_Humour3") .."\n")
		QuestWindow:setVisible(true);
	elseif x==4 then 
		QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Hermit.png>" .."<LINE><LINE>".. getText("Tooltip_Hermit_Humour4") .."\n")
		QuestWindow:setVisible(true);
	elseif x==5 then 
		QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Hermit.png>" .."<LINE><LINE>".. getText("Tooltip_Hermit_Humour5") .."\n")
		QuestWindow:setVisible(true);
	elseif x==6 then 
		QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Hermit.png>" .."<LINE><LINE>".. getText("Tooltip_Hermit_Humour6") .."\n")
		QuestWindow:setVisible(true);
	elseif x==7 then 
		QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Hermit.png>" .."<LINE><LINE>".. getText("Tooltip_Hermit_Humour7") .."\n")
		QuestWindow:setVisible(true);
	elseif x==8 then 
		QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Hermit.png>" .."<LINE><LINE>".. getText("Tooltip_Hermit_Humour8") .."\n")
		QuestWindow:setVisible(true);
	elseif x==9 then 
		QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Hermit.png>" .."<LINE><LINE>".. getText("Tooltip_Hermit_Humour9") .."\n")
		QuestWindow:setVisible(true);
	elseif x==10 then 
		QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Hermit.png>" .."<LINE><LINE>".. getText("Tooltip_Hermit_Humour10") .."\n")
		QuestWindow:setVisible(true);
	elseif x==11 then 
		QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Hermit.png>" .."<LINE><LINE>".. getText("Tooltip_Hermit_Humour11") .."\n")
		QuestWindow:setVisible(true);
	end
end

CleanerHello = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Cleaner.png>" .."<LINE><LINE>".. getText("Tooltip_Cleaner_Dialogue_Hello") .."\n")
	QuestWindow:setVisible(true);
end

DemiurgeHello = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Demiurge.png>" .."<LINE><LINE>".. getText("Tooltip_Demiurge_Dialogue_Hello") .."\n")
	QuestWindow:setVisible(true);
end

NurseHello = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Nurse.png>" .."<LINE><LINE>".. getText("Tooltip_Nurse_Dialogue_Hello") .."\n")
	QuestWindow:setVisible(true);
end

HeadHello = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Head.png>" .."<LINE><LINE>".. getText("Tooltip_Head_Dialogue_Hello") .."\n")
	QuestWindow:setVisible(true);
end

PharmacistHello = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Pharmacist.png>" .."<LINE><LINE>".. getText("Tooltip_Pharmacist_Dialogue_Hello") .."\n")
	QuestWindow:setVisible(true);
end

AssistantHello = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Assistant.png>" .."<LINE><LINE>".. getText("Tooltip_Assistant_Dialogue_Hello") .."\n")
	QuestWindow:setVisible(true);
end

CookHello = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Cook.png>" .."<LINE><LINE>".. getText("Tooltip_Cook_Dialogue_Hello") .."\n")
	QuestWindow:setVisible(true);
end

GhostHello = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Ghost.png>" .."<LINE><LINE>".. getText("Tooltip_Ghost_Dialogue_Hello") .."\n")
	QuestWindow:setVisible(true);
end

Tutorial1 = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/NewHope.png>" .."<LINE><LINE>".. getText("Tooltip_Tutorial1") .."\n")
	QuestWindow:setVisible(true);
end

Tutorial2 = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/NewHope.png>" .."<LINE><LINE>".. getText("Tooltip_Tutorial2") .."\n")
	QuestWindow:setVisible(true);
end

Tutorial3 = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/NewHope.png>" .."<LINE><LINE>".. getText("Tooltip_Tutorial3") .."\n")
	QuestWindow:setVisible(true);
end

Tutorial4 = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/NewHope.png>" .."<LINE><LINE>".. getText("Tooltip_Tutorial4") .."\n")
	QuestWindow:setVisible(true);
end

Tutorial5 = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/NewHope.png>" .."<LINE><LINE>".. getText("Tooltip_Tutorial5") .."\n")
	QuestWindow:setVisible(true);
end

Tutorial6 = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/NewHope.png>" .."<LINE><LINE>".. getText("Tooltip_Tutorial6") .."\n")
	QuestWindow:setVisible(true);
end

Tutorial7 = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/NewHope.png>" .."<LINE><LINE>".. getText("Tooltip_Tutorial7") .."\n")
	QuestWindow:setVisible(true);
end

Tutorial8 = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/NewHope.png>" .."<LINE><LINE>".. getText("Tooltip_Tutorial8") .."\n")
	QuestWindow:setVisible(true);
end

-- УБОРЩИЦА ЗАДАНИЕ 1
CleanerQuest1 = function()
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Cleaner.png>" .."<LINE><LINE>".. getText("Tooltip_CleanerQuest1_Take") .."\n")
	QuestWindow:setVisible(true);
	getPlayer():getTraits():add("task_start_med");
	getPlayer():getInventory():AddItem("NHM.QuestHBroom");
	getPlayer():getInventory():AddItem("NHM.QuestHBucket");
	
end

ElevatorDirt = function(worldobjects, player, item)
	local playerObj = getSpecificPlayer(player)
	ISTimedActionQueue.add(ISElevatorDirt:new(playerObj, item, 1000));
end

CleanerQuest1Complete = function()
	getPlayer():getTraits():remove("task_start_med");
	getPlayer():getInventory():Remove("QuestHBroomDirty");
	getPlayer():getInventory():Remove("QuestHBucketDirty");
	if getPlayer():getPerkLevel(Perks.RepDoc) < 1 then	
		if getPlayer():HasTrait("FastLearner") then
			getPlayer():getXp():AddXP(Perks.RepDoc, (12 / 1.3)) 
		elseif getPlayer():HasTrait("SlowLearner") then
			getPlayer():getXp():AddXP(Perks.RepDoc, (12 / 0.7)) 
		else
			getPlayer():getXp():AddXP(Perks.RepDoc, 12);
		end
	else
	end
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Cleaner.png>" .."<LINE><LINE>".. getText("Tooltip_CleanerQuest1_Finish") .."\n")
	QuestWindow:setVisible(true);
end

-- УБОРЩИЦА ЗАДАНИЕ 2
CleanerQuest2 = function()
	getPlayer():getTraits():add("task_start_med");
	getPlayer():getInventory():AddItem("NHM.QuestHDirtyCloth");
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Cleaner.png>" .."<LINE><LINE>".. getText("Tooltip_CleanerQuest2_Take") .."\n")
	QuestWindow:setVisible(true);
end

Laundry = function(worldobjects, player, item)
	local playerObj = getSpecificPlayer(player)
	ISTimedActionQueue.add(ISLaundry:new(playerObj, item, 1000));
end

CleanerQuest2Complete = function()
	getPlayer():getTraits():remove("task_start_med");
	getPlayer():getInventory():Remove("QuestHCleanCloth");
	if getPlayer():getPerkLevel(Perks.RepDoc) < 1 then	
		if getPlayer():HasTrait("FastLearner") then
				getPlayer():getXp():AddXP(Perks.RepDoc, (12 / 1.3)) 
			elseif getPlayer():HasTrait("SlowLearner") then
				getPlayer():getXp():AddXP(Perks.RepDoc, (12 / 0.7)) 
			else
				getPlayer():getXp():AddXP(Perks.RepDoc, 12);
			end
		else
		end
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Cleaner.png>" .."<LINE><LINE>".. getText("Tooltip_CleanerQuest2_Finish") .."\n")
	QuestWindow:setVisible(true);
end

--ДЕМИУРГ ЗАДАНИЕ 1
DemiurgeQuest1 = function()
	getPlayer():getTraits():add("task_start_med");
	getPlayer():getInventory():AddItem("NHM.QuestHTip");
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Demiurge.png>" .."<LINE><LINE>".. getText("Tooltip_DemiurgeQuest1_Take") .."\n")
	QuestWindow:setVisible(true);
end

Archive = function(worldobjects, player, item)
	local playerObj = getSpecificPlayer(player)
	ISTimedActionQueue.add(ISArchive:new(playerObj, item, 1000));
end

DemiurgeQuest1Complete = function()
	getPlayer():getTraits():remove("task_start_med");
	getPlayer():getInventory():Remove("QuestHArchive");
	if getPlayer():getPerkLevel(Perks.RepDoc) < 1 then	
		if getPlayer():HasTrait("FastLearner") then
				getPlayer():getXp():AddXP(Perks.RepDoc, (12 / 1.3)) 
			elseif getPlayer():HasTrait("SlowLearner") then
				getPlayer():getXp():AddXP(Perks.RepDoc, (12 / 0.7)) 
			else
				getPlayer():getXp():AddXP(Perks.RepDoc, 12);
			end
		else
		end
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Demiurge.png>" .."<LINE><LINE>".. getText("Tooltip_DemiurgeQuest1_Finish") .."\n")
	QuestWindow:setVisible(true);
end

--ДЕМИУРГ ЗАДАНИЕ 2
DemiurgeQuest2 = function()
	getPlayer():getTraits():add("task_start_med");
	getPlayer():getInventory():AddItem("NHM.QuestHTweezers");
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Demiurge.png>" .."<LINE><LINE>".. getText("Tooltip_DemiurgeQuest2_Take") .."\n")
	QuestWindow:setVisible(true);
end

Morgue = function(worldobjects, player, item)
	local playerObj = getSpecificPlayer(player)
	ISTimedActionQueue.add(ISMorgue:new(playerObj, item, 1000));
end

DemiurgeQuest2Complete = function()
	getPlayer():getTraits():remove("task_start_med");
	getPlayer():getInventory():Remove("QuestHDeadSaw");
	if getPlayer():getPerkLevel(Perks.RepDoc) < 1 then	
		if getPlayer():HasTrait("FastLearner") then
				getPlayer():getXp():AddXP(Perks.RepDoc, (12 / 1.3)) 
			elseif getPlayer():HasTrait("SlowLearner") then
				getPlayer():getXp():AddXP(Perks.RepDoc, (12 / 0.7)) 
			else
				getPlayer():getXp():AddXP(Perks.RepDoc, 12);
			end
		else
		end
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Demiurge.png>" .."<LINE><LINE>".. getText("Tooltip_DemiurgeQuest2_Finish") .."\n")
	QuestWindow:setVisible(true);
end

--СЕСТРА ЗАДАНИЕ 1
NurseQuest1 = function()
	getPlayer():getTraits():add("task_start_med");
	getPlayer():getInventory():AddItem("NHM.QuestHDisk");
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Nurse.png>" .."<LINE><LINE>".. getText("Tooltip_NurseQuest1_Take") .."\n")
	QuestWindow:setVisible(true);
end

Computer = function(worldobjects, player, item)
	local playerObj = getSpecificPlayer(player)
	ISTimedActionQueue.add(ISComputer:new(playerObj, item, 1000));
end

NurseQuest1Complete = function()
	getPlayer():getTraits():remove("task_start_med");
	getPlayer():getInventory():Remove("QuestHFullDisk");
	if getPlayer():getPerkLevel(Perks.RepDoc) < 1 then	
		if getPlayer():HasTrait("FastLearner") then
				getPlayer():getXp():AddXP(Perks.RepDoc, (12 / 1.3)) 
			elseif getPlayer():HasTrait("SlowLearner") then
				getPlayer():getXp():AddXP(Perks.RepDoc, (12 / 0.7)) 
			else
				getPlayer():getXp():AddXP(Perks.RepDoc, 12);
			end
		else
		end
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Nurse.png>" .."<LINE><LINE>".. getText("Tooltip_NurseQuest1_Finish") .."\n")
	QuestWindow:setVisible(true);
end

--СЕСТРА ЗАДАНИЕ 2
NurseQuest2 = function()
	getPlayer():getTraits():add("task_start_med");
	getPlayer():getInventory():AddItem("NHM.QuestHEmptyFlask");
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Nurse.png>" .."<LINE><LINE>".. getText("Tooltip_NurseQuest2_Take") .."\n")
	QuestWindow:setVisible(true);
end

VioletLiquid = function(worldobjects, player, item)
	local playerObj = getSpecificPlayer(player)
	ISTimedActionQueue.add(ISVioletLiquid:new(playerObj, item, 1000));
end

NurseQuest2Complete = function()
	getPlayer():getTraits():remove("task_start_med");
	getPlayer():getInventory():Remove("QuestHFullFlask");
	if getPlayer():getPerkLevel(Perks.RepDoc) < 1 then	
		if getPlayer():HasTrait("FastLearner") then
				getPlayer():getXp():AddXP(Perks.RepDoc, (12 / 1.3)) 
			elseif getPlayer():HasTrait("SlowLearner") then
				getPlayer():getXp():AddXP(Perks.RepDoc, (12 / 0.7)) 
			else
				getPlayer():getXp():AddXP(Perks.RepDoc, 12);
			end
		else
		end
		QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Nurse.png>" .."<LINE><LINE>".. getText("Tooltip_NurseQuest2_Finish") .."\n")
		QuestWindow:setVisible(true);
end


--АССИСТЕНТ ЗАДАНИЕ 2
AssistantQuest2 = function()
	getPlayer():getTraits():add("task_start_med");
	getPlayer():getInventory():AddItem("NHM.QuestHEmptyStars");
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Assistant.png>" .."<LINE><LINE>".. getText("Tooltip_AssistantQuest2_Take") .."\n")
	QuestWindow:setVisible(true);
end

Stars = function(worldobjects, player, item)
	local playerObj = getSpecificPlayer(player)
	ISTimedActionQueue.add(ISStars:new(playerObj, item, 1000));
end

AssistantQuest2Complete = function()
	getPlayer():getTraits():remove("task_start_med");
	getPlayer():getInventory():Remove("QuestHStars");
	if getPlayer():getPerkLevel(Perks.RepDoc) < 1 then	
		if getPlayer():HasTrait("FastLearner") then
				getPlayer():getXp():AddXP(Perks.RepDoc, (12 / 1.3)) 
			elseif getPlayer():HasTrait("SlowLearner") then
				getPlayer():getXp():AddXP(Perks.RepDoc, (12 / 0.7)) 
			else
				getPlayer():getXp():AddXP(Perks.RepDoc, 12);
			end
		else
		end
		QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Assistant.png>" .."<LINE><LINE>".. getText("Tooltip_AssistantQuest2_Finish") .."\n")
		QuestWindow:setVisible(true);
end

--КУХАРКА ЗАДАНИЕ 2
CookQuest2 = function()
	getPlayer():getTraits():add("task_start_med");
	getPlayer():getInventory():AddItem("NHM.QuestHEmptyBeer");
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Cook.png>" .."<LINE><LINE>".. getText("Tooltip_CookQuest2_Take") .."\n")
	QuestWindow:setVisible(true);
end

Beer = function(worldobjects, player, item)
	local playerObj = getSpecificPlayer(player)
	ISTimedActionQueue.add(ISBeer:new(playerObj, item, 1000));
end

CookQuest2Complete = function()
	getPlayer():getTraits():remove("task_start_med");
	getPlayer():getInventory():Remove("QuestHBeer");
	if getPlayer():getPerkLevel(Perks.RepDoc) < 1 then	
		if getPlayer():HasTrait("FastLearner") then
				getPlayer():getXp():AddXP(Perks.RepDoc, (12 / 1.3)) 
			elseif getPlayer():HasTrait("SlowLearner") then
				getPlayer():getXp():AddXP(Perks.RepDoc, (12 / 0.7)) 
			else
				getPlayer():getXp():AddXP(Perks.RepDoc, 12);
			end
		else
		end
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Cook.png>" .."<LINE><LINE>".. getText("Tooltip_CookQuest2_Finish") .."\n")
	QuestWindow:setVisible(true);
end



--ЗАВЕДУЮЩИЙ ЗАДАНИЕ 1
HeadQuest1 = function()
	getSpecificPlayer(0):getTraits():add("task_start_med");
	getSpecificPlayer(0):getInventory():AddItem("NHM.QuestHKey");
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Head.png>" .."<LINE><LINE>".. getText("Tooltip_HeadQuest1_Take") .."\n")
	QuestWindow:setVisible(true);
end

Firecup = function(worldobjects, player, item)
	local playerObj = getSpecificPlayer(player)
	ISTimedActionQueue.add(ISFirecup:new(playerObj, item, 1000));
end

HeadQuest1Complete = function()
	getPlayer():getTraits():remove("task_start_med");
	getPlayer():getInventory():Remove("QuestHFireEx");
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Head.png>" .."<LINE><LINE>".. getText("Tooltip_HeadQuest1_Finish") .."\n")
	QuestWindow:setVisible(true);
	if getPlayer():getPerkLevel(Perks.RepDoc) < 1 then	
		if getPlayer():HasTrait("FastLearner") then
				getPlayer():getXp():AddXP(Perks.RepDoc, (12 / 1.3)) 
			elseif getPlayer():HasTrait("SlowLearner") then
				getPlayer():getXp():AddXP(Perks.RepDoc, (12 / 0.7)) 
			else
				getPlayer():getXp():AddXP(Perks.RepDoc, 12);
			end
		else
		end
end

--ЗАВЕДУЮЩИЙ ЗАДАНИЕ 2
HeadQuest2 = function()
	getPlayer():getTraits():add("task_start_med");
	getPlayer():getInventory():AddItem("NHM.QuestHBloodBag");
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Head.png>" .."<LINE><LINE>".. getText("Tooltip_HeadQuest2_Take") .."\n")
	QuestWindow:setVisible(true);
end

Blood = function(worldobjects, player, item)
	local playerObj = getSpecificPlayer(player)
	ISTimedActionQueue.add(ISBlood:new(playerObj, item, 1000));
end

HeadQuest2Complete = function()
	getPlayer():getTraits():remove("task_start_med");
	getPlayer():getInventory():Remove("QuestHFullBloodBag");
	if getPlayer():getPerkLevel(Perks.RepDoc) < 1 then	
		if getPlayer():HasTrait("FastLearner") then
				getPlayer():getXp():AddXP(Perks.RepDoc, (12 / 1.3)) 
			elseif getPlayer():HasTrait("SlowLearner") then
				getPlayer():getXp():AddXP(Perks.RepDoc, (12 / 0.7)) 
			else
				getPlayer():getXp():AddXP(Perks.RepDoc, 12);
			end
		else
		end
		QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Head.png>" .."<LINE><LINE>".. getText("Tooltip_HeadQuest2_Finish") .."\n")
		QuestWindow:setVisible(true);
end

--ФАРМАЦЕВТ ЗАДАНИЕ 1
PharmacistQuest1 = function()
	getPlayer():getTraits():add("task_start_med");
	getPlayer():getInventory():AddItem("NHM.QuestHMortPest");
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Pharmacist.png>" .."<LINE><LINE>".. getText("Tooltip_PharmacistQuest1_Take") .."\n")
	QuestWindow:setVisible(true);
end

Tablets = function(worldobjects, player, item)
	local playerObj = getSpecificPlayer(player)
	ISTimedActionQueue.add(ISTablets:new(playerObj, item, 1000));
end

PharmacistQuest1Complete = function()
	getPlayer():getTraits():remove("task_start_med");
	getPlayer():getInventory():Remove("QuestHTablets");
	if getPlayer():getPerkLevel(Perks.RepDoc) < 1 then	
		if getPlayer():HasTrait("FastLearner") then
				getPlayer():getXp():AddXP(Perks.RepDoc, (12 / 1.3)) 
			elseif getPlayer():HasTrait("SlowLearner") then
				getPlayer():getXp():AddXP(Perks.RepDoc, (12 / 0.7)) 
			else
				getPlayer():getXp():AddXP(Perks.RepDoc, 12);
			end
		else
		end
		QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Pharmacist.png>" .."<LINE><LINE>".. getText("Tooltip_PharmacistQuest1_Finish") .."\n")
		QuestWindow:setVisible(true);
end

--ФАРМАЦЕВТ ЗАДАНИЕ 2
PharmacistQuest2 = function()
	getPlayer():getTraits():add("task_start_med");
	getPlayer():getInventory():AddItem("NHM.QuestHLoveNote");
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Pharmacist.png>" .."<LINE><LINE>".. getText("Tooltip_PharmacistQuest2_Take") .."\n")
	QuestWindow:setVisible(true);
end

Lovenote = function()
	getPlayer():getInventory():Remove("QuestHLoveNote");
	getPlayer():getInventory():AddItem("NHM.QuestHLoveNoteBack");
	QuestWindow:setText("<IMAGECENTRE:media/textures/Quests/Lovenote.png>" .."<LINE><LINE>".. getText("Tooltip_PharmacistQuest2_Perform") .."\n")
	QuestWindow:setVisible(true);
end

PharmacistQuest2Complete = function()
	getPlayer():getTraits():remove("task_start_med");
	getPlayer():getInventory():Remove("QuestHLoveNoteBack");
	if getPlayer():getPerkLevel(Perks.RepDoc) < 1 then	
		if getPlayer():HasTrait("FastLearner") then
				getPlayer():getXp():AddXP(Perks.RepDoc, (12 / 1.3)) 
			elseif getPlayer():HasTrait("SlowLearner") then
				getPlayer():getXp():AddXP(Perks.RepDoc, (12 / 0.7)) 
			else
				getPlayer():getXp():AddXP(Perks.RepDoc, 12);
			end
		else
		end
		QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Pharmacist.png>" .."<LINE><LINE>".. getText("Tooltip_PharmacistQuest2_Finish") .."\n")
		QuestWindow:setVisible(true);
end

--ПРИЗРАК КВЕСТ НА СХРОН

GhostQuest1 = function()
local x = ZombRand(30)
if x == 0 then
getPlayer():getInventory():AddItem("NHM.GhostQuest1");
elseif x == 1 then 
getPlayer():getInventory():AddItem("NHM.GhostQuest2");
elseif x == 2 then 
getPlayer():getInventory():AddItem("NHM.GhostQuest3");
elseif x == 3 then 
getPlayer():getInventory():AddItem("NHM.GhostQuest4");
elseif x == 4 then 
getPlayer():getInventory():AddItem("NHM.GhostQuest5");
elseif x == 5 then 
getPlayer():getInventory():AddItem("NHM.GhostQuest6");
elseif x == 6 then 
getPlayer():getInventory():AddItem("NHM.GhostQuest7");
elseif x == 7 then 
getPlayer():getInventory():AddItem("NHM.GhostQuest8");
elseif x == 8 then 
getPlayer():getInventory():AddItem("NHM.GhostQuest9");
elseif x == 9 then 
getPlayer():getInventory():AddItem("NHM.GhostQuest10");
elseif x == 10 then 
getPlayer():getInventory():AddItem("NHM.GhostQuest11");
elseif x == 11 then 
getPlayer():getInventory():AddItem("NHM.GhostQuest12");
elseif x == 12 then 
getPlayer():getInventory():AddItem("NHM.GhostQuest13");
elseif x == 13 then 
getPlayer():getInventory():AddItem("NHM.GhostQuest14");
elseif x == 14 then 
getPlayer():getInventory():AddItem("NHM.GhostQuest15");
elseif x == 15 then 
getPlayer():getInventory():AddItem("NHM.GhostQuest16");
elseif x == 16 then 
getPlayer():getInventory():AddItem("NHM.GhostQuest17");
elseif x == 17 then 
getPlayer():getInventory():AddItem("NHM.GhostQuest18");
elseif x == 18 then 
getPlayer():getInventory():AddItem("NHM.GhostQuest19");
elseif x == 19 then 
getPlayer():getInventory():AddItem("NHM.GhostQuest20");
elseif x == 20 then 
getPlayer():getInventory():AddItem("NHM.GhostQuest21");
elseif x == 21 then 
getPlayer():getInventory():AddItem("NHM.GhostQuest22");
elseif x == 22 then 
getPlayer():getInventory():AddItem("NHM.GhostQuest23");
elseif x == 23 then 
getPlayer():getInventory():AddItem("NHM.GhostQuest24");
elseif x == 24 then 
getPlayer():getInventory():AddItem("NHM.GhostQuest25");
elseif x == 25 then 
getPlayer():getInventory():AddItem("NHM.GhostQuest26");
elseif x == 26 then 
getPlayer():getInventory():AddItem("NHM.GhostQuest27");
elseif x == 27 then 
getPlayer():getInventory():AddItem("NHM.GhostQuest28");
elseif x == 28 then 
getPlayer():getInventory():AddItem("NHM.GhostQuest29");
elseif x == 29 then 
getPlayer():getInventory():AddItem("NHM.GhostQuest30");
end
	
	QuestWindow:setText("<IMAGECENTRE:media/textures/NPC/Ghost.png>" .."<LINE><LINE>".. getText("Tooltip_GhostQuest1_Take") .."\n")
	QuestWindow:setVisible(true);
	
	getPlayer():getTraits():add("quest_cd1");
end

food_cd=0;
DailyFood = function()
	getPlayer():getInventory():AddItem("NHM.QuestHDailyFood");
	getPlayer():getInventory():AddItem("NHM.QuestHDailyWater");
	food_cd = 6;
end

function food_tick()
	if food_cd > 0 then
		food_cd = food_cd - 1;
	end
end

Events.EveryHours.Add(food_tick);
Events.OnFillWorldObjectContextMenu.Add(Work_Stations2);