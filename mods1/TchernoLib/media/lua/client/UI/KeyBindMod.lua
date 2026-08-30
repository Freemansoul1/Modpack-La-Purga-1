
KBM = KBM or {}
KBM.memo = {}--this is only a transient memo. don't use it directly from outside


-------- User interface, client side -----------
--- Requires :
--require 'UI/KeyBindMod'
---KBM.addKeyBinding is supposed to be called at file load time.

---category (string): expected within brackets, e.g '[UI]'.
---nameValue (string):
---     used as keyword for access from the rest of the model.
---     used as keyword (suffix) for translation, e.g 'Auto_Loot_Config' -> matches translation of 'UI_optionscreen_binding_Auto_Loot_Config'.
---defaultKey (Key / integer): see Keyboard definition. if nil, Keyboard.KEY_NONE wil be used.
function KBM.addKeyBinding(category,nameValue,defaultKey)
    if not defaultKey then defaultKey = Keyboard.KEY_NONE end

    local catKeys = KBM.memo[category]
    if not catKeys then
        KBM.memo[category] = {};
        catKeys = KBM.memo[category]
    end

    table.insert(catKeys,{value=nameValue, key=defaultKey})--there can be duplicates
end


--------- Internals --------------

--hook just before keys are loaded
KBM.loadKeys = MainOptions.loadKeys--upper layer, probably vanilla
KBM.moddedKeysInserted = false
function MainOptions.loadKeys()
    if not KBM.moddedKeysInserted then
        KBM.insertModdedKeys()
        KBM.moddedKeysInserted = true
    end
    
    KBM.loadKeys()
end


--insert keys (time consuming)
function KBM.insertModdedKeys()
    local newKeyBind = {}
    local moddedCategory = nil
    for i=1, #keyBinding do
        local binding = keyBinding[i]
        if not binding.key and binding.value then
            if moddedCategory then
                --we reached the end of previous category, time to insert modded keybinds into vanilla categories
                for modKBIt=1, #moddedCategory do
                    table.insert(newKeyBind,moddedCategory[modKBIt])
                end
            end
            table.insert(newKeyBind,binding)
            moddedCategory = KBM.memo[binding.value]--store for next. set to nil if no key to insert ion that category.
            if moddedCategory then
                KBM.memo[binding.value] = nil--consume it
            end
        else
            table.insert(newKeyBind,binding)
        end
    end
    if moddedCategory then
        --we reached the end of last category, time to insert modded keybinds
        for modKBIt=1, #moddedCategory do
            table.insert(newKeyBind,moddedCategory[modKBIt])
        end
        moddedCategory = nil--OCD
    end
    
    --time to add modded categories (only non consumed are remaining)
    for category, moddedKeyBinds in pairs(KBM.memo) do
        table.insert(newKeyBind,{value=moddedKeyBinds.value})
        for modKBIt=1, #moddedKeyBinds do
            table.insert(newKeyBind,moddedKeyBinds[modKBIt])
        end
    end
    KBM.memo = {}--it is partially consumed anyway
    
    --replace keybinding with the augmented one
    keyBinding = newKeyBind
end



