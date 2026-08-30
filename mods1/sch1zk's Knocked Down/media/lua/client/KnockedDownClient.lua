-- +================================================================+
-- |                                                                |
-- |                        /##         /##             /##         |
-- |                       | ##       /####            | ##         |
-- |     /#######  /#######| ####### |_  ##   /########| ##   /##   |
-- |    /##_____/ /##_____/| ##__  ##  | ##  |____ /##/| ##  /##/   |
-- |   |  ###### | ##      | ##  \ ##  | ##     /####/ | ######/    |
-- |    \____  ##| ##      | ##  | ##  | ##    /##__/  | ##_  ##    |
-- |    /#######/|  #######| ##  | ## /###### /########| ## \  ##   |
-- |   |_______/  \_______/|__/  |__/|______/|________/|__/  \__/   |
-- |                                                                |
-- +================================================================+

SKnockedDown = SKnockedDown or {}

local ISTimedActionQueueAdd = ISTimedActionQueue.add
ISTimedActionQueue.add = function(action)
	if action.bodyPart or action.handler and action.handler.bodyPart then
		action.maxTime = action.maxTime * 2;
	elseif not (action.item and (instanceof(action.item, "IsoWindow") or instanceof(action.item, "IsoDoor") or instanceof(action.item, "IsoCurtain"))) then
		if getPlayer():getVariableBoolean("knockedd") or getPlayer():getVariableBoolean("knockedd_fall") then return end
	end
	ISTimedActionQueueAdd(action);
end

local ISWorldObjectContextMenuOnSitOnGround = ISWorldObjectContextMenu.onSitOnGround
ISWorldObjectContextMenu.onSitOnGround = function(player)
	if getPlayer():getVariableBoolean("knockedd") or getPlayer():getVariableBoolean("knockedd_fall") then return end
	ISWorldObjectContextMenuOnSitOnGround(player);
end

function SKnockedDown.KnockPlayer(player)
	if isClient() then
		local args = { state = "fall" };
		sendClientCommand(player, 'knockedd', 'update', args);
	end

	player:setVariable("knockedd_fall", true)

	if SandboxVars.KnockedDown.DropHandItemsWhileKnocked then
		player:dropHandItems();
	else
		player:setPrimaryHandItem(nil);
		player:setSecondaryHandItem(nil);
	end

	player:setIsAiming(false);
	player:setBannedAttacking(true);
	player:setIgnoreAimingInput(true);

    local sm = getSearchMode();
    local psm = sm:getSearchModeForPlayer(0);
	local blur = psm:getBlur();
    local dark = psm:getDarkness();
	local desat = psm:getDesat();
	local gwidth = psm:getGradientWidth();
    local radius = psm:getRadius();

	blur:set(blur:getExterior(), 0.25, blur:getInterior(), 0.25);
	dark:set(dark:getExterior(), 0, dark:getInterior(), 0);
	desat:set(desat:getExterior(), 0.25, desat:getInterior(), 0.25);
	gwidth:set(gwidth:getExterior(), 0, gwidth:getInterior(), 0);
    radius:set(radius:getExterior(), 0, radius:getInterior(), 0);

    getSearchMode():setEnabled(0, true);
    -- getSearchMode():setOverride(0, true);
end

function SKnockedDown.GetUpPlayer(player)
	if isClient() then
		local args = { state = "getup" };
		sendClientCommand(player, 'knockedd', 'update', args);
	end
	player:setVariable("knockedd_getup", true)
	player:setBannedAttacking(false);
	player:setIgnoreAimingInput(false);

    getSearchMode():setEnabled(0, false);
    getSearchMode():setOverride(0, false);
end

SKnockedDown.wasHelped = false
SKnockedDown.requestedStates = false
function SKnockedDown.OnPlayerUpdate(player)
	if isClient() then
		if not SKnockedDown.GetSync(player) then return end
		if not SKnockedDown.requestedStates then
			local args = { id = player:getOnlineID() };
			sendClientCommand(player, 'knockedd', 'requestknockedstates', args);
			SKnockedDown.requestedStates = true;
		end
	end

	local bodyDamage = player:getBodyDamage();
	local modData = player:getModData();

	if bodyDamage:getOverallBodyHealth() < SandboxVars.KnockedDown.HealthThreshold then
		if SKnockedDown.wasHelped then
			if player:getVariableBoolean("knockedd") and not player:getVariableBoolean("knockedd_getup") then
				SKnockedDown.GetUpPlayer(player);
			end
		else
			if not player:getVariableBoolean("knockedd") and not player:getVariableBoolean("knockedd_fall") then
				SKnockedDown.KnockPlayer(player);
			end

			if bodyDamage:getOverallBodyHealth() < modData.lastHealth then
				local healthReduce = modData.lastHealth - bodyDamage:getOverallBodyHealth();
				local multiplier = 0;

				if player:isMoving() then
					multiplier = multiplier + 0.1;
				end
				if player:isRunning() then
					multiplier = multiplier + 0.2;
				end
				if player:isSprinting() then
					multiplier = multiplier + 0.3;
				end

				if bodyDamage:IsInfected() then
					multiplier = 1;
				end
				if multiplier > 0 then
					bodyDamage:ReduceGeneralHealth(healthReduce * multiplier);
				end
			end
	
			if not player:isMoving() and bodyDamage:getOverallBodyHealth() > modData.lastHealth then
				if SandboxVars.KnockedDown.HealthIncreaseMult > 0.0 then
					local healthIncrease = bodyDamage:getOverallBodyHealth() - modData.lastHealth;
					bodyDamage:AddGeneralHealth(healthIncrease * SandboxVars.KnockedDown.HealthIncreaseMult);
				end
			end
		end
	else
		if SKnockedDown.wasHelped then
			SKnockedDown.wasHelped = false;
		end
		if player:getVariableBoolean("knockedd") and not player:getVariableBoolean("knockedd_getup") then
			SKnockedDown.GetUpPlayer(player);
		end
		if player:getVariableBoolean("knockedd_fall") then
			player:setVariable("knockedd_fall", false);
			getSearchMode():setEnabled(0, false);
			getSearchMode():setOverride(0, false);
		end
	end

	if player:getVariableBoolean("knockedd_fall") or player:getVariableBoolean("knockedd_getup") then
		player:setBlockMovement(true);
	else
		player:setBlockMovement(false);
	end

	if player:getVariableBoolean("knockedd") then
		if player:isSneaking() then
			player:setSneaking(false);
		end
	end
	modData.lastHealth = bodyDamage:getOverallBodyHealth();
end

function SKnockedDown.OnTick(numberTicks)
    local player = getPlayer();
    local onlinePlayers = getOnlinePlayers();
    if onlinePlayers then
        for i=1,onlinePlayers:size() do
            local p = onlinePlayers:get(i-1)
            if p and p ~= player then
                if p:getX() >= player:getX() - 50 and p:getX() < player:getX() + 50 and p:getY() >= player:getY() - 50 and p:getY() < player:getY() + 50 then
                    if not p:getModData().knockedd then
                        p:getModData().knockedd = {}
                    end
					if p:getModData().knockedd.state then
						if p:getModData().knockedd.state == "fall" and not p:getVariableBoolean("knockedd_fall") then
							p:setVariable("knockedd_fall", true);
							p:getModData().knockedd.state = "knocked";
						elseif p:getModData().knockedd.state == "getup" and not p:getVariableBoolean("knockedd_getup") then
							p:setVariable("knockedd_getup", true);
							p:getModData().knockedd.state = nil;
						end
					else
						if p:getVariableBoolean("knockedd") then
							p:setVariable("knockedd", false);
						end
					end
				end
			end
		end
	end
end

SKnockedDown.isSynced = false;
function SKnockedDown.GetSync(player)
	if SKnockedDown.isSynced then return true end
	local args = { ts = getTimestampMs() };
	sendClientCommand(player, 'knockedd', 'getsync', args);
	return false
end

function SKnockedDown.ClientOnCreatePlayer(playerIndex, player)
	if player ~= getPlayer() then return end
	player:setBlockMovement(false);
	player:setBannedAttacking(false)
	player:setIgnoreAimingInput(false)
	player:setVariable("knockedd_fall", false);
	player:setVariable("knockedd", false);
	player:setVariable("knockedd_getup", false);

    getSearchMode():setEnabled(0, false);
    getSearchMode():setOverride(0, false);
end

function SKnockedDown.onHelpUpKnockedContext(worldobjects, player, clickedPlayer)
	if luautils.walkAdj(player, clickedPlayer:getCurrentSquare()) then
		ISTimedActionQueue.add(ISHelpUpKnocked:new(player, clickedPlayer))
	end
end

function SKnockedDown.OnFillWorldObjectContextMenu(playerIndex, context, worldObjects)
	if not isClient() then return end

    local player = getSpecificPlayer(playerIndex);
    local clickedPlayer;
	local square;
    for _, v in ipairs(worldObjects) do
        square = v:getSquare();
		if square then break end
    end

	if square then
		for x=square:getX()-1,square:getX()+1 do
			for y=square:getY()-1,square:getY()+1 do
				local sq = getCell():getGridSquare(x,y,square:getZ());
				if sq then
					for i=0,sq:getMovingObjects():size()-1 do
						local o = sq:getMovingObjects():get(i)
						if instanceof(o, "IsoPlayer") and (o ~= player) then
							clickedPlayer = o
						end
					end
				end
			end
		end
	end

	if clickedPlayer then
		print(clickedPlayer)
		if math.abs(player:getX() - clickedPlayer:getX()) > 2 or math.abs(player:getY() - clickedPlayer:getY()) > 2 then return end
		if not clickedPlayer:getModData().knockedd or clickedPlayer:getModData().knockedd.state ~= "knocked" then return end
		context:addOption(getText("ContextMenu_HelpUpKnocked", clickedPlayer:getDisplayName()), worldObjects, SKnockedDown.onHelpUpKnockedContext, player, clickedPlayer)
	end
end

function SKnockedDown.OnWeaponHitCharacter(wielder, character, handWeapon, damage)
	if character == getPlayer() and SKnockedDown.wasHelped then SKnockedDown.wasHelped = false end
end

local Commands = {}
Commands.knockedd = {}
Commands.knockedd.update = function(args)
    local otherPlayer = getPlayerByOnlineID(args.id);
    if otherPlayer then
		if args.state == "fall" then
			otherPlayer:getModData().knockedd.state = "fall"
		elseif args.state == "getup" then
			otherPlayer:getModData().knockedd.state = "getup"
		end
    end
end

Commands.knockedd.helpupknocked = function(args)
	local player = getPlayer();
	if player:getBodyDamage():getOverallBodyHealth() < SandboxVars.KnockedDown.HealthThreshold then
		SKnockedDown.wasHelped = true
	end
end

Commands.knockedd.getsync = function(args)
	if args.ts and args.lastts then
		print("Client > getsync in "..args.ts - args.lastts);
	end
	SKnockedDown.isSynced = true;
end

local function OnServerCommand(module, command, args)
    if Commands[module] and Commands[module][command] then
        local argStr = ''
        for k,v in pairs(args) do argStr = argStr..' '..k..'='..tostring(v) end
        print('received '..module..' '..command..' '..argStr)
        Commands[module][command](args)
    end
end

Events.OnWeaponHitCharacter.Add(SKnockedDown.OnWeaponHitCharacter)
Events.OnFillWorldObjectContextMenu.Add(SKnockedDown.OnFillWorldObjectContextMenu)
Events.OnCreatePlayer.Add(SKnockedDown.ClientOnCreatePlayer)
Events.OnServerCommand.Add(OnServerCommand)
Events.OnPlayerUpdate.Add(SKnockedDown.OnPlayerUpdate)

if isClient() then
	Events.OnTick.Add(SKnockedDown.OnTick)
end