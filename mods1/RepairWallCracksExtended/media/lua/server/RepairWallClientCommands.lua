require('luautils');

local function onRepairWallCrackCommand(module, command, player, args)
    if module == 'RepairWallCrack' then
        if command == 'RepairWallCrackCommand' then
            local sq = getCell():getGridSquare(args.x, args.y, args.z)
            
            if not sq then return end
            
            for i = 0, sq:getObjects():size() - 1 do
                local object = sq:getObjects():get(i);
                local attached = object:getAttachedAnimSprite()
                if attached then
                    for n = attached:size(), 1, -1 do
                        local sprite = attached:get(n - 1)
                        print(sprite:getParentSprite():getName())
                        if sprite and sprite:getParentSprite() and sprite:getParentSprite():getName() and
                           (luautils.stringStarts(sprite:getParentSprite():getName(), "d_wallcrack") or
                            luautils.stringStarts(sprite:getParentSprite():getName(), "walls_house_blocks_01") or
                            luautils.stringStarts(sprite:getParentSprite():getName(), "walls_house_blocks_01_MIRRORED") or
                            luautils.stringStarts(sprite:getParentSprite():getName(), "walls_house_blocks_LIGHT_01") or
                            luautils.stringStarts(sprite:getParentSprite():getName(), "walls_house_blocks_LIGHT_01_MIRRORED") or
                            luautils.stringStarts(sprite:getParentSprite():getName(), "walls_house_brick_01") or
                            luautils.stringStarts(sprite:getParentSprite():getName(), "walls_house_brick_01_MIRRORED") or
                            luautils.stringStarts(sprite:getParentSprite():getName(), "walls_house_brick_LIGHT_01") or
                            luautils.stringStarts(sprite:getParentSprite():getName(), "walls_house_brick_LIGHT_01_MIRRORED") or
                            luautils.stringStarts(sprite:getParentSprite():getName(), "walls_house_clapboard_01") or
                            luautils.stringStarts(sprite:getParentSprite():getName(), "walls_house_clapboard_01_MIRRORED") or
                            luautils.stringStarts(sprite:getParentSprite():getName(), "walls_house_clapboard_LIGHT_01") or
                            luautils.stringStarts(sprite:getParentSprite():getName(), "walls_house_clapboard_LIGHT_01_MIRRORED") or
                            luautils.stringStarts(sprite:getParentSprite():getName(), "walls_house_flatstone_01") or
                            luautils.stringStarts(sprite:getParentSprite():getName(), "walls_house_flatstone_01_MIRRORED") or
                            luautils.stringStarts(sprite:getParentSprite():getName(), "walls_house_smooth_01") or
                            luautils.stringStarts(sprite:getParentSprite():getName(), "walls_house_smooth_01_MIRRORED") or
                            luautils.stringStarts(sprite:getParentSprite():getName(), "walls_house_stone_01") or
                            luautils.stringStarts(sprite:getParentSprite():getName(), "walls_house_stone_01_MIRRORED") or
                            luautils.stringStarts(sprite:getParentSprite():getName(), "walls_house_trailer_01") or
                            luautils.stringStarts(sprite:getParentSprite():getName(), "walls_house_trailer_01_MIRRORED") or
                            luautils.stringStarts(sprite:getParentSprite():getName(), "walls_house_wood_01") or
                            luautils.stringStarts(sprite:getParentSprite():getName(), "walls_house_wood_01_MIRRORED")
                           ) then
                            object:RemoveAttachedAnim(n - 1)
                            object:transmitUpdatedSpriteToClients()
                            object:getSquare():disableErosion()
                            if isClient() then object:transmitUpdatedSpriteToServer() end
                        end
                    end
                end
            end
        end
    end
end

Events.OnClientCommand.Add(onRepairWallCrackCommand)
