
------------------------      CLIENT         ---------------------------
if not isClient() then return end


DOTD={}

------------------------               ---------------------------
CastGlobalAudio_Menu = ISCollapsableWindow:derive("CastGlobalAudio_Menu");
CastGlobalAudio_Menu.cheat = true
CastGlobalAudio_Menu.instance = nil

function CastGlobalAudio_Menu.openPanel(playerObj)
    if CastGlobalAudio_Menu.instance == nil then
        local window = CastGlobalAudio_Menu:new(100, 950, 160, 130, playerObj)
        window:initialise()
        window:addToUIManager()
        CastGlobalAudio_Menu.instance = window
    end
end



--**************************            	   **************************
--							     header*
--**************************            	   **************************
local opTitles = {
    "CGA_explode",
    "CGA_firefight",
    "CGA_flyby",
    "CGA_gunfight",
    "CGA_helicopter",
    "CGA_nuclear",
    "CGA_overflight",
    "CGA_siren",
    --"CGA_sirenLoop",
}

function CastGlobalAudio_Menu:createChildren()
    ISCollapsableWindow.createChildren(self);
    local th = self:titleBarHeight()
    local buttonWid = 120
    local buttonHgt = 24
    local y = th + 10
    for i, title in ipairs(opTitles) do
        local button = ISButton:new(self:getWidth()/2 - buttonWid/2, y, buttonWid, buttonHgt, title, self, CastGlobalAudio_Menu.onClick);
        button.internal = title;
        button:initialise();
        button:instantiate();
        self:addChild(button);
        y = y + buttonHgt + 10
    end
end

--**************************            	   **************************
--								 body*
--**************************            	   **************************

function CastGlobalAudio_Menu:onClick(button)
    local player = self.character
    if button.internal then
        if player ~= getPlayer() then
            sendClientCommand(getPlayer(), "DOTD", "SendAudio", {audioSFX = button.internal})
        end
    end
end

--**************************            	   **************************
--								 footer*
--**************************            	   **************************

function CastGlobalAudio_Menu:close()
    CastGlobalAudio_Menu.instance = nil
    self:setVisible(false);
    self:removeFromUIManager()
end


function CastGlobalAudio_Menu:new(x, y, width, height, character)
    local o = ISCollapsableWindow.new(self, x, y, width, height);
    o:setResizable(true)
    o.title = "GlobalAudio"
    o.character = character
    o.height = 900
    return o
end


function CastGlobalAudio_Context(player, context, worldobjects, test)
	if not player then return end 
    if not (getCore():getDebug() or isAdmin()) then return; end 
    local DBGOption = context:addOptionOnTop("CGA_Debug:")
    local CGA_Debug = ISContextMenu:getNew(context)
    context:addSubMenu(DBGOption, CGA_Debug)
	CGA_Debug:addOption("CGA Menu", worldobjects, function() 	
        CastGlobalAudio_Menu.openPanel() 
	end)
end

Events.OnFillWorldObjectContextMenu.Add(CastGlobalAudio_Context)
------------------------         ---------------------------

-- This will be run ON EVERYONE! 
local Commands = {}
Commands.DOTD = {}
Commands.DOTD.ReceiveAudio = function(args)

    if isDebugEnabled() then print('Global Audio '.. tostring(args.audioSFX)) end     
    if getPlayer() then
        getSoundManager():PlayWorldSound(args.audioSFX, getPlayer():getSquare(), 0, 150, 3, false)
    end
end

--5* Client sided listener
Events.OnServerCommand.Add(function(module, command, args)
    if Commands[module] and Commands[module][command] then
        Commands[module][command](args)
    end
end)
