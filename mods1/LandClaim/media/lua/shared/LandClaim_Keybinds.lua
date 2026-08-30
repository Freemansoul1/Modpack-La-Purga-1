LandClaim_Bindings = {
    {
        name = '[LandClaimBindings]'
    },
    {
        value = 'LandClaimBindings_Destroy',
        key = Keyboard.KEY_U,

    }
}



local function InitKeybinds()
    if isServer() then return end

    for _, bind in ipairs(LandClaim_Bindings) do
        if bind.name then
            table.insert(keyBinding, { value = bind.name, key = nil })
        else
            if bind.key then
                table.insert(keyBinding, { value = bind.value, key = bind.key })
            end
        end
    end
end

InitKeybinds()