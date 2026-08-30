local PlunkDone = {}

PlunkDone.ghs = ' <RGB:' .. getCore():getGoodHighlitedColor():getR() .. ',' .. getCore():getGoodHighlitedColor():getG() .. ',' .. getCore():getGoodHighlitedColor():getB() .. '> '
PlunkDone.bhs = ' <RGB:' .. getCore():getBadHighlitedColor():getR() .. ',' .. getCore():getBadHighlitedColor():getG() .. ',' .. getCore():getBadHighlitedColor():getB() .. '> '
	
PlunkDone.ContextPlumbHelp = function(player, context, worldobjects)
	local playerObj = getSpecificPlayer(player)
	local inv = playerObj:getInventory();
	local wrench = inv:FindAndReturn("PipeWrench")	
	if wrench or ISBuildMenu.cheat then
		_FirstTier = context:addOption(getText('Tooltip_PlumbHelper'))
		_FirstTier.iconTexture = getTexture("ui/Item_PipeWrench")
		local _SecondTier = ISContextMenu:getNew(context)
		context:addSubMenu(_FirstTier, _SecondTier)
		PlunkDone.ContextPlumbHelp1(_SecondTier, player, context)
		PlunkDone.ContextPlumbHelp2(_SecondTier, player, context)
	end
end

PlunkDone.ContextPlumbHelp1 = function(subMenu, player, worldobjects)
	local playerObj = getSpecificPlayer(player)
	local tooltip = ISWorldObjectContextMenu.addToolTip()
	local option = subMenu:addOption(getText('Tooltip_PlumbHelper11'),worldobjects, PlunkDone.onPlumbHelp, player, name)
	option.toolTip = tooltip
	tooltip.description = getText('Tooltip_PlumbHelper2')
	tooltip.description = tooltip.description .. ' <LINE><LINE><LINE> ' .. getText('Tooltip_PlumbHelper3')
	tooltip.description = tooltip.description .. ' <LINE><RGB:1,.2,.2> ' .. getText('Tooltip_PlumbHelper4B')..' <LINE> '
	tooltip.description = tooltip.description .. ' <LINE><LINE><RGB:1,.2,.2> ' .. getText('Tooltip_PlumbHelper4')..' <LINE> '
	tooltip.description = tooltip.description .. ' <LINE><LINE><RGB:.8,.8,.2> ' .. getText('Tooltip_PlumbHelper5')..' <LINE> '
	tooltip.description = tooltip.description .. ' <LINE><LINE><RGB:.3,.5,.8> ' .. getText('Tooltip_PlumbHelper6')..' <LINE> '
	tooltip:setName('                        '..getText('Tooltip_PlumbHelper11', name)..'           ')
	option.iconTexture = getTexture("media/ui/Collector_Icon.png")
	if (SandboxVars.PlumbHelper.Utilities == true or ISBuildMenu.cheat) and (SandboxVars.WaterShutModifier > -1 and GameTime:getInstance():getNightsSurvived() < SandboxVars.WaterShutModifier) then
		tooltip:setTexture("media/ui/Helper_Icon2.png")
	else
		tooltip:setTexture("media/ui/Helper_Icon.png")
	end
	if playerObj:isOutside() then
		tooltip.description = tooltip.description .. ' <LINE><LINE> ' ..  PlunkDone.bhs .. getText('Tooltip_IsOutside')
	else
		tooltip.description = tooltip.description .. ' <LINE><LINE> ' ..  PlunkDone.ghs .. getText('Tooltip_IsInside')
	end
	if SandboxVars.PlumbHelper.Utilities == true or ISBuildMenu.cheat then
		if (SandboxVars.WaterShutModifier > -1 and GameTime:getInstance():getNightsSurvived() < SandboxVars.WaterShutModifier) then
			tooltip.description = tooltip.description  .. ' <LINE> ' ..  PlunkDone.ghs .. getText('Tooltip_WaterON')
			--tooltip.description = tooltip.description  .. ' <LINE><RGB:.8,.8,.2> ' .. getText('Tooltip_WaterONB')
		else
			tooltip.description = tooltip.description .. ' <LINE> ' ..  PlunkDone.bhs .. getText('Tooltip_WaterOFF')
		end
	end
end

PlunkDone.ContextPlumbHelp2 = function(subMenu, player, worldobjects)
	local playerObj = getSpecificPlayer(player)
	local tooltip = ISWorldObjectContextMenu.addToolTip()	
	local option = subMenu:addOption(getText('Tooltip_PlumbHelper10'),worldobjects, PlunkDone.onPlumbHelp2, player, name)
	option.toolTip = tooltip
	tooltip.description = getText('Tooltip_PlumbHelper9')
	tooltip.description = tooltip.description .. ' <LINE><LINE><LINE> ' .. getText('Tooltip_PlumbHelper3')..' <LINE> '
	tooltip.description = tooltip.description .. ' <RGB:0,.8,0> ' .. getText('Tooltip_PlumbHelper7')..' <LINE> '
	tooltip.description = tooltip.description .. ' <LINE><LINE><RGB:1,.2,.2> ' .. getText('Tooltip_PlumbHelper8')..' <LINE> '
	tooltip:setName('                       '..getText('Tooltip_PlumbHelper10', name))
	option.iconTexture = getTexture("media/ui/Sink_Icon.png")
	tooltip:setTexture("media/ui/Faucet_Icon.png")
end



PlunkDone.onPlumbHelp = function(worldobjects,player)
	local playerObj = getSpecificPlayer(player)
	local bo = ISPlumbHelperCursor:new("", "", playerObj)
	getCell():setDrag(bo, bo.player)
end
PlunkDone.onPlumbHelp2 = function(worldobjects,player)
	local playerObj = getSpecificPlayer(player)
	local bo = ISPlumbHelperCursor2:new("", "", playerObj)
	getCell():setDrag(bo, bo.player)
end


Events.OnFillWorldObjectContextMenu.Add(PlunkDone.ContextPlumbHelp)
