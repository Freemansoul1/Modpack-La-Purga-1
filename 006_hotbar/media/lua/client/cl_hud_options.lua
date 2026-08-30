local hud = require('cl_hud')

local blhud = _G.BLHUD
blhud.options = blhud.options or {}

local fields = {}
local options = {
    mod_id="blhud",
    mod_shortname="Alt Crosshair",
    mod_fullname="Alternative Crosshair",
    options_data={}
}
local function getPrefixedKey(name)
    return "blhud_" .. name 
end
local function getPrefixedText(name)
    return "IGUI_CUI_Display_" .. name 
end
local function getPrefixedTable(name, type)
    local pname = getPrefixedText(name)
    return {
        name = pname,
        tooltip = pname .. "_Tooltip"
    }
end
local function addMultiOptions(name, ...) 
    local tbl = getPrefixedTable(name)
    tbl.default = 1
    for k, v in ipairs({...}) do
        tbl[k] = v
    end
    options.options_data[getPrefixedKey(name)] = tbl
    table.insert(fields, getPrefixedKey(name))
end
local function addSwitch(name, default) 
    local tbl = getPrefixedTable(name)
    tbl.default = type(default) == "boolean" and default or false
    options.options_data[getPrefixedKey(name)] = tbl
    table.insert(fields, getPrefixedKey(name))
end

function blhud:getOptionData(key)
    return options.options_data[getPrefixedKey(key)]
end

addSwitch("EnableAmmoCounter", true) 
addSwitch("LimitMeleeDistance", true) 
addSwitch("ShowLimitDistanceCursor", true) 

addMultiOptions(
    "RenderTypeRanged",
    "Generic",
    "Quake",
    "Dot",
    "IsoCursorOpaque",
    "IsoCursorFade",
    "IsoCursorSqaure"
)

addMultiOptions(
    "RenderTypeMelee",
    "IsoCursorOpaque",
    "IsoCursorFade",
    "IsoCursorSqaure",
    "Generic",
    "Quake",
    "Dot"
)

addMultiOptions(
    "GenericCrosshairGap",
    "32 (Default)",
    "16",
    "20",
    "24",
    "28",
    "30"
)

addMultiOptions(
    "GenericCrosshairMaxGap",
    "32 (Default)",
    "16",
    "20",
    "24",
    "28",
    "30"
)


addMultiOptions(
    "GenericCrosshairLength",
    "8 (Default)",
    "2",
    "4",
    "10",
    "16"
)
addMultiOptions(
    "GenericCrosshairWidth",
    "2 (Default)",
    "0.5",
    "1",
    "4",
    "8",
    "10",
    "16"
)



addMultiOptions(
    "AmmoCounterFont",
    "Default",
    "Half-Life:Opposing Force",
    "Counter-Strike 1.6"
)

local settings
local function initialize()
    if ModOptions and ModOptions.getInstance then
        print("Utilizing mod option for Inventory Rendering Configurations")
        settings = ModOptions:getInstance(options)
        function settings:OnApply()
            blhud:applyOption(self)
        end
        function settings:OnApplyInGame()
            blhud:applyOption(self)
        end
        ModOptions:loadFile()
    end
end
Events.OnGameStart.Add(function()
    if ModOptions and settings then 
        ModOptions:loadFile()
        settings:OnApply() 
    end
end)
-- todo: complete configuration options
initialize()