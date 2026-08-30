-- Music for the End of the World Support

-- Prevents a bug where MFTEOTW attempts to spawn an item from a
-- nil variable without making sure that the variable exists, 
-- because it is assumed that it should exist. 

-- May also prevent bugs in other mods. Calls to AddItem and 
-- addItemOnServer that do not provide an item will throw Javaside 
-- errors in vanilla Project Zomboid. This simply returns nil back 
-- to Lua in the case where nil is provided instead of an item.

-- This may simply "move" an error, so-to-speak, or it may entirely
-- prevent certain code from throwing errors; it depends entirely
-- on what the code tries to do with the item usually returned
-- by AddItem after it receives nil instead of an item.

-- Thanks again for sharing this ever useful trick, Tyrir.

-- Code by Burryaga, maintained lovingly by theharber.

local NeverAddNullItem = {}

NeverAddNullItem.patchLuaJavaClassMethod = function(class, methodName, createPatch)
    local metatable = __classmetatables[class]

    if not metatable then
        error("Unable to find metatable for class " .. tostring(class))
    end

    local metatableIndex = metatable.__index

    if not metatableIndex then
        error("Unable to find __index in metatable for class " .. tostring(class))
    end

    local originalMethod = metatableIndex[methodName]

    metatableIndex[methodName] = createPatch(originalMethod)
end

NeverAddNullItem.patchItemContainerAddNullItem = function()
    NeverAddNullItem.patchLuaJavaClassMethod(zombie.inventory.ItemContainer.class, "AddItem", 
        function(metatableMethod)
            return function(self, item)
                -- Before
                if not item then return nil end

                -- Proceed
                return metatableMethod(self, item)
            end
        end
    )
    NeverAddNullItem.patchLuaJavaClassMethod(zombie.inventory.ItemContainer.class, "addItemOnServer", 
        function(metatableMethod)
            return function(self, item)
                -- Before
                if not item then return nil end

                -- Proceed
                return metatableMethod(self, item)
            end
        end
    )
end

NeverAddNullItem.patchItemContainerAddNullItem()

return NeverAddNullItem
