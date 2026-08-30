require "GravyUI"

if WAT_EventsHelper then
    Events.OnTick.Remove(WAT_EventsHelper.onTickFollowMe)
end

WAT_EventsHelper = WAT_EventsHelper or ISCollapsableWindow:derive("WAT_EventsHelper")

function WAT_EventsHelper:display()
    if WAT_EventsHelper.instance ~= nil then
        return
    end
    local md = getPlayer():getModData()
    md.WAT_EventsHelper_Hidden = false

    local buttons = {
        {type="single", id="invisibleButton", short="IV", tooltip="Toggle invisiblity / Ghost Mode", func=self.toggleInivisible},
        {type="single", id="godModeButton", short="GM", tooltip="Toggle God Mode", func=self.toggleGodMode},
        {type="single", id="movingButton", short="FM", tooltip="Toggle Fast Move / No Clip", func=self.toggleMoving},
        {type="single", id="seePlayersButton", short="SP", tooltip="Toggle See All Players", func=self.toggleSeePlayers},
        {type="single", id="zombiesFollowButton", short="ZF", tooltip="Toggle Zombies Follow Me", func=self.toggleZombiesFollow},
        {type="increaseDecrese", tooltip="Zombie Follow Range: ", property="zombieFollowRange", min=5, max=30},
        {type="single", id="moveHordeButton", short="MH", tooltip="Move Horde to Position", func=self.moveHorde},
        {type="increaseDecrese", tooltip="Move Horde Range: ", property="moveHordeRange", min=5, max=30},
        {type="single", id="quickHordeButton", short="QH", tooltip="Quick Horde Spawn", func=self.startQuickHorde},
        {type="increaseDecrese", tooltip="Quick Horde Size: ", property="quickHordeSize", min=1, max=100},
        {type="single", id="sucideButton", short="SC", tooltip="Instant Sucide", func=self.sucide},
        {type="single", id="soundboardButton", short="SB", tooltip="Open Soundboard", func=self.soundboard},
        {type="single", id="itemPickerButton", short="IP", tooltip="Item Picker", func=self.openItemPicker},
        {type="single", id="tilePickerButton", short="TL", tooltip="Tile Picker", func=self.openTilePicker},
        {type="single", id="makeFire", short="FU", tooltip="Fire UI", func=self.makeFire},
        {type="single", id="massFactionButton", short="MF", tooltip="Mass Faction", func=self.massFaction},
        {type="single", id="clearCorpseButton", short="CC", tooltip="Clear Corpses", func=self.clearCorpses},
        {type="single", id="clearBloodButton", short="CB", tooltip="Clear Blood", func=self.clearBlood},
        {type="increaseDecrese", tooltip="Clear Size: ", property="clearSize", min=1, max=50},
    }

    local numBtns = #buttons
    local height = numBtns * 18 + 25
    local x = md.WAT_EventsHelperX or getCore():getScreenWidth() - 40
    local y = md.WAT_EventsHelperY or getCore():getScreenHeight() / 2 - height / 2
    local o = ISCollapsableWindow:new(x, y, 40, height)
	setmetatable(o, self)
	self.__index = self
    o.title = ""
    o.resizable = false
    o.pin = false
    o.buttons = buttons
    o.numBtns = numBtns
    o:initialise()
    WAT_EventsHelper.instance = o
end

function WAT_EventsHelper:initialise()
    ISCollapsableWindow.initialise(self)

    self.zombiesFollowMe = false
    self.tickDelay = 0
    self.selectingSquare = false

    self.zombieFollowRange = 15
    self.moveHordeRange = 15
    self.quickHordeSize = 10
    self.clearSize = 50

    self:addToUIManager()
    self:setAlwaysOnTop(true)
    self.moveWithMouse = true
    self.borderColor = {r=0.4, g=0.4, b=0.4, a=1}
    self.backgroundColor = {r=0, g=0, b=0, a=1}

    local window = GravyUI.Node(self.width, self.height):pad(5, 20, 5, 5)
    local slots = {window:rows(self.numBtns, 3)}

    for idx, btnDef in ipairs(self.buttons) do
        if btnDef.type == "single" then
            local btn = slots[idx]:makeButton(btnDef.short, self, btnDef.func)
            btn:setWidth(window.width or 20)
            btn.tooltip = btnDef.tooltip
            self:addChild(btn)
            self[btnDef.id] = btn
        elseif btnDef.type == "increaseDecrese" then
            local left, right = slots[idx]:cols(2)

            local decreaseBtn = left:makeButton("-", self, self.adjustValue, {btnDef, -1})
            decreaseBtn:setWidth(left.width or 10)
            decreaseBtn.tooltip = btnDef.tooltip..self[btnDef.property].." <LINE>Hold Shift to decrement by 5"
            self:addChild(decreaseBtn)
            self[btnDef.property.."DecreaseButton"] = decreaseBtn

            local increaseBtn = right:makeButton("+", self, self.adjustValue, {btnDef, 1})
            increaseBtn:setWidth(right.width or 10)
            increaseBtn.tooltip = btnDef.tooltip..self[btnDef.property].." <LINE>Hold Shift to increment by 5"
            self:addChild(increaseBtn)
            self[btnDef.property.."IncreaseButton"] = increaseBtn
        end
    end

    self:updateButtons()
end

function WAT_EventsHelper:adjustValue(btn, btnDef, direction)
    local amount = direction
    if isKeyDown(Keyboard.KEY_LSHIFT) then
        amount = amount * 5
    end
    self[btnDef.property] = math.min(math.max(self[btnDef.property] + amount, btnDef.min), btnDef.max)
    self[btnDef.property.."DecreaseButton"].tooltip = btnDef.tooltip..self[btnDef.property].." <LINE>Hold Shift to decrement by 5"
    self[btnDef.property.."IncreaseButton"].tooltip = btnDef.tooltip..self[btnDef.property].." <LINE>Hold Shift to increment by 5"
    self:updateButtons()
end

local greenButtonColor = {r=0, g=0.7, b=0, a=1}
local redButtonColor = {r=0.7, g=0, b=0, a=1}
function WAT_EventsHelper:updateButtons()
    local player = getPlayer()

    self.invisibleButton.backgroundColor = player:isInvisible() and greenButtonColor or redButtonColor
    self.godModeButton.backgroundColor = player:isGodMod() and greenButtonColor or redButtonColor
    self.movingButton.backgroundColor = ISFastTeleportMove.cheat and greenButtonColor or redButtonColor
    self.seePlayersButton.backgroundColor = player:isCanSeeAll() and greenButtonColor or redButtonColor
    self.zombiesFollowButton.backgroundColor = self.zombiesFollowMe and greenButtonColor or redButtonColor

    -- min 5, max 30
    if self.zombieFollowRangeDecreaseButton.enabled and self.zombieFollowRange <= 5 then
        self.zombieFollowRangeDecreaseButton:setEnable(false)
    elseif not self.zombieFollowRangeDecreaseButton.enabled and self.zombieFollowRange > 5 then
        self.zombieFollowRangeDecreaseButton:setEnable(true)
    end
    if self.zombieFollowRangeIncreaseButton.enabled and self.zombieFollowRange >= 30 then
        self.zombieFollowRangeIncreaseButton:setEnable(false)
    elseif not self.zombieFollowRangeIncreaseButton.enabled and self.zombieFollowRange < 30 then
        self.zombieFollowRangeIncreaseButton:setEnable(true)
    end

    -- min 5, max 30
    if self.moveHordeRangeDecreaseButton.enabled and self.moveHordeRange <= 5 then
        self.moveHordeRangeDecreaseButton:setEnable(false)
    elseif not self.moveHordeRangeDecreaseButton.enabled and self.moveHordeRange > 5 then
        self.moveHordeRangeDecreaseButton:setEnable(true)
    end
    if self.moveHordeRangeIncreaseButton.enabled and self.moveHordeRange >= 30 then
        self.moveHordeRangeIncreaseButton:setEnable(false)
    elseif not self.moveHordeRangeIncreaseButton.enabled and self.moveHordeRange < 30 then
        self.moveHordeRangeIncreaseButton:setEnable(true)
    end

    -- min 1, max 100
    if self.quickHordeSizeDecreaseButton.enabled and self.quickHordeSize <= 1 then
        self.quickHordeSizeDecreaseButton:setEnable(false)
    elseif not self.quickHordeSizeDecreaseButton.enabled and self.quickHordeSize > 1 then
        self.quickHordeSizeDecreaseButton:setEnable(true)
    end
    if self.quickHordeSizeIncreaseButton.enabled and self.quickHordeSize >= 100 then
        self.quickHordeSizeIncreaseButton:setEnable(false)
    elseif not self.quickHordeSizeIncreaseButton.enabled and self.quickHordeSize < 100 then
        self.quickHordeSizeIncreaseButton:setEnable(true)
    end

end

function WAT_EventsHelper:toggleInivisible()
    local player = getPlayer()
    if player:isInvisible() then
        player:setInvisible(false)
    else
        player:setInvisible(true)
    end
    self:updateButtons()
    sendPlayerExtraInfo(player)
end

function WAT_EventsHelper:toggleGodMode()
    local player = getPlayer()
    if player:isGodMod() then
        player:setGodMod(false)
    else
        player:setGodMod(true)
    end
    self:updateButtons()
    sendPlayerExtraInfo(player)
end

function WAT_EventsHelper:toggleMoving()
    local player = getPlayer()
    ISFastTeleportMove.cheat = not ISFastTeleportMove.cheat
    player:setNoClip(ISFastTeleportMove.cheat)
    self:updateButtons()
    sendPlayerExtraInfo(player)
end

function WAT_EventsHelper:toggleSeePlayers()
    local player = getPlayer()
    if player:isCanSeeAll() then
        player:setCanSeeAll(false)
    else
        player:setCanSeeAll(true)
    end
    self:updateButtons()
    sendPlayerExtraInfo(player)
end

function WAT_EventsHelper:toggleZombiesFollow()
    self.zombiesFollowMe = not self.zombiesFollowMe
    self:updateButtons()
    if self.zombiesFollowMe then
        Events.OnTick.Add(WAT_EventsHelper.onTickFollowMe)
    else
        Events.OnTick.Remove(WAT_EventsHelper.onTickFollowMe)
    end
end

function WAT_EventsHelper:startQuickHorde()
    self.selectingSquare = "quickHorde"
end

function WAT_EventsHelper:spawnQuickHorde(x, y, z)
    SendCommandToServer(string.format("/createhorde2 -x %d -y %d -z %d -count %d -radius %d -crawler %s -isFallOnFront %s -isFakeDead %s -knockedDown %s -health %s -outfit %s ", x, y, z, self.quickHordeSize, 1, "false", "false", "false", "false", 1.0, ""))
end

function WAT_EventsHelper:sucide()
    local x = getCore():getScreenWidth() / 2 - 100
    local y = getCore():getScreenHeight() / 2 - 25
    local modal = ISModalDialog:new(x, y, 200, 50, "Suicide?", true, nil, function(_, b)
        if b.internal == "YES" then
            getPlayer():setHealth(0)
        end
    end)
    modal:initialise()
    modal:addToUIManager()
end

function WAT_EventsHelper:soundboard()
    if WSB_SoundboardWindow then
        WSB_SoundboardWindow.show()
    end
end

function WAT_EventsHelper:moveHorde()
    self.selectingSquare = "moveHorde"
end

function WAT_EventsHelper:makeFire()
    local x = getCore():getScreenWidth() / 2 - 100
    local y = getCore():getScreenHeight() / 2 - 200
    FireBrushUI.openPanel(x, y, getPlayer())
end

function WAT_EventsHelper:massFaction()
    local x = getCore():getScreenWidth() / 2 - 100
    local y = getCore():getScreenHeight() / 2 - 25
    local s = self
    local modal = ISModalDialog:new(x, y, 200, 50, "Create mass faction?", true, nil, function(_, b)
        if b.internal == "YES" then
            s:doCreateMassFaction()
        end
    end)
    modal:initialise()
    modal:addToUIManager()
end

function WAT_EventsHelper:doCreateMassFaction()
    local me = getPlayer()
    local faction = Faction.getFaction("Temporary Event Faction")
    if faction then
        local players = faction:getPlayers()
        for i=0,players:size()-1 do
            faction:removePlayer(players:get(i))
        end
        faction:setOwner(me:getUsername())
    else
        faction = Faction.createFaction("Temporary Event Faction", me:getUsername())
        faction:setTag("TEF")
    end
    if not faction then
        WL_Utils.addErrorToChat("Something went wrong making the temporary event faction")
        return
    end
    -- Get all nearby players
    local players = getOnlinePlayers()
    -- Add all players to the faction
    for i=0,players:size()-1 do
        local player = players:get(i)
        if player:getDistanceSq(me) < 50*50 then
            if not WL_Utils.isStaff(player) then
                local currentFaction = Faction.getPlayerFaction(player:getUsername())
                if currentFaction then
                    currentFaction:removePlayer(player:getUsername())
                    if currentFaction:getOwner() == player:getUsername() then
                        currentFaction:removeFaction()
                    end
                    currentFaction:syncFaction()
                end
                faction:addPlayer(player:getUsername())
            end
        end
    end
    faction:syncFaction()
    local modal = ISFactionUI:new(getCore():getScreenWidth() / 2 - 250, getCore():getScreenHeight() / 2 - 225, 500, 450, faction, me)
    modal:initialise()
    modal:addToUIManager()
    WL_Utils.addInfoToChat("Temporary event faction created. Make sure to disband the faction after the event.")
end

function WAT_EventsHelper:openItemPicker()
    if ISItemsListViewer.instance then
        ISItemsListViewer.instance:close()
    end
    local modal = ISItemsListViewer:new(50, 200, 850, 650, getPlayer())
    modal:initialise()
    modal:addToUIManager()
end

function WAT_EventsHelper:openTilePicker()
    BrushToolChooseTileUI.openPanel((getCore():getScreenWidth()/2) - 411, (getCore():getScreenHeight()/2) - 330, getPlayer())
end

function WAT_EventsHelper:close()
    if self.gridSquareMarker then
        getWorldMarkers():removeGridSquareMarker(self.gridSquareMarker)
        self.gridSquareMarker = nil
    end
    local md = getPlayer():getModData()
    md.WAT_EventsHelperX = self:getX()
    md.WAT_EventsHelperY = self:getY()
    md.WAT_EventsHelper_Hidden = true
    self:setVisible(false)
    self:removeFromUIManager()
    WAT_EventsHelper.instance = nil
end

function WAT_EventsHelper:prerender()
    ISCollapsableWindow.prerender(self)
    if self.selectingSquare then
        local player = getPlayer()
        if not self.gridSquareMarker then
            local square = player:getCurrentSquare()
            self.gridSquareMarker = getWorldMarkers():addGridSquareMarker(square, 1, 0.5, 0.5, false, 1)
        end
        local sx = getMouseX()
        local sy = getMouseY()
        local z = player:getZ()
        local x = screenToIsoX(0, sx, sy, z)
        local y = screenToIsoY(0, sx, sy, z)
        self.gridSquareMarker:setPos(x, y, z)

        if isKeyDown(Keyboard.KEY_ESCAPE) then
            self.selectingSquare = false
            getWorldMarkers():removeGridSquareMarker(self.gridSquareMarker)
            self.gridSquareMarker = nil
        elseif isMouseButtonDown(0) then
            if self.selectingSquare == "moveHorde" then
                self:moveHordeToPosition(x, y, z, self.moveHordeRange)
            elseif self.selectingSquare == "quickHorde" then
                self:spawnQuickHorde(x, y, z)
            end
            self.selectingSquare = false
            getWorldMarkers():removeGridSquareMarker(self.gridSquareMarker)
            self.gridSquareMarker = nil
        end
    elseif self.gridSquareMarker then
        getWorldMarkers():removeGridSquareMarker(self.gridSquareMarker)
        self.gridSquareMarker = nil
    end
end

function WAT_EventsHelper.onTickFollowMe()
    local self = WAT_EventsHelper.instance
    if not self or not self.zombiesFollowMe then
        Events.OnTick.Remove(WAT_EventsHelper.onTickFollowMe)
        return
    end
    if self.tickDelay == 0 then
        self.tickDelay = 60
        self:makeNearbyZombiesMoveToMe()
    else
        self.tickDelay = self.tickDelay - 1
    end
end

function WAT_EventsHelper:makeNearbyZombiesMoveToMe()
    local player = getPlayer()
    local x = player:getX()
    local y = player:getY()
    local z = player:getZ()

    self:moveHordeToPosition(x, y, z, self.zombieFollowRange)
end

function WAT_EventsHelper:moveHordeToPosition(x, y, z, d)
    local sx = math.floor(x) - d
    local sy = math.floor(y) - d
    local ex = sx + d*2
    local ey = sy + d*2
    for cx = sx,ex do for cy = sy,ey do for cz = 0,7 do
        local square = getCell():getGridSquare(cx, cy, cz)
        if square then
            local movingEntities = square:getMovingObjects()
            for i=0,movingEntities:size()-1 do
                local movingEntity = movingEntities:get(i)
                if instanceof(movingEntity, "IsoZombie") then
                    movingEntity:pathToLocationF(x, y, z)
                end
            end
        end
    end end end
    sendClientCommand(getPlayer(), 'WAT', 'moveHordeToPosition', {x=x, y=y, z=z, d=d})
end

function WAT_EventsHelper:clearCorpses()
    local player = getPlayer()
    local x = math.floor(player:getX())
    local y = math.floor(player:getY())
    local sx = x - self.clearSize
    local sy = y - self.clearSize
    local ex = sx + self.clearSize*2
    local ey = sy + self.clearSize*2
    WL_Utils.clearCorpses(sx, sy, 0, ex, ey, 7)
end

function WAT_EventsHelper:clearBlood()
    local player = getPlayer()
    local x = math.floor(player:getX())
    local y = math.floor(player:getY())
    local sx = x - self.clearSize
    local sy = y - self.clearSize
    local ex = sx + self.clearSize*2
    local ey = sy + self.clearSize*2
    WL_Utils.removeBlood(sx, sy, 0, ex, ey, 7)
end

WL_PlayerReady.Add(function (playerIndex, player)
    local player = getPlayer()
    if WL_Utils.isAtLeastGM(player) and not player:getModData().WAT_EventsHelper_Hidden then
        WAT_EventsHelper:display()
    end
end)