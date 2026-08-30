OutWithIt = OutWithIt or {}
OutWithIt.Options = OutWithIt.Options or {}

OutWithIt.Options.damageItemsOnFall = true
OutWithIt.Options.allowQuickEquippedItemsThrow = true

if ModOptions and ModOptions.getInstance then
    local function onModOptionsApply(optionValues)
        OutWithIt.Options.damageItemsOnFall = optionValues.settings.options.damageItemsOnFall
        OutWithIt.Options.allowQuickEquippedItemsThrow = optionValues.settings.options.allowQuickEquippedItemsThrow
    end

    local SETTINGS = {
        options_data = {
            damageItemsOnFall = {
                name = "UI_ModOptions_DamageItemsOnFall_Name",
                tooltip = "UI_ModOptions_DamageItemsOnFall_Tooltip",
                default = true,
                OnApplyMainMenu = onModOptionsApply,
                OnApplyInGame = onModOptionsApply,
            },
            allowQuickEquippedItemsThrow = {
                name = "UI_ModOptions_AllowQuickEquippedItemsThrow_Name",
                tooltip = "UI_ModOptions_AllowQuickEquippedItemsThrow_Tooltip",
                default = true,
                OnApplyMainMenu = onModOptionsApply,
                OnApplyInGame = onModOptionsApply,
            },
        },

        mod_id = 'Out With It',
        mod_shortname = 'Out With It',
        mod_fullname = 'Out With It',
    }

    local optionsInstance = ModOptions:getInstance(SETTINGS)
    ModOptions:loadFile()

    local damageItemsOnFall = optionsInstance:getData("damageItemsOnFall")
    function damageItemsOnFall:onUpdate(newValue)
        OutWithIt.Options.damageItemsOnFall = newValue
    end

    local allowQuickEquippedItemsThrow = optionsInstance:getData("allowQuickEquippedItemsThrow")
    function allowQuickEquippedItemsThrow:onUpdate(newValue)
        OutWithIt.Options.allowQuickEquippedItemsThrow = newValue
    end

    Events.OnPreMapLoad.Add(function() onModOptionsApply({ settings = SETTINGS }) end)
end