local IFP = IndustrialFuelPumps or {}
IFP.isThump = true
IFP.soundChance = 3
IFP.addSoundMax = 8
--IFP.removeChance = 90

IFP.gridTiles = {
    industry_02_64 = {0,1},
    industry_02_65 = {1,1},
    industry_02_66 = {2,1},
    industry_02_67 = {3,1},
    industry_02_68 = {0,0},
    industry_02_69 = {1,0},
    industry_02_70 = {2,0},
    industry_02_71 = {3,0},
}

function IFP.OnInitWorld()
    local vals = IsoWorld.PropertyValueMap:get("fuelAmount") or ArrayList.new()
    if not vals:contains("5000") then vals:add("5000") end
    IsoWorld.PropertyValueMap:put("PickUpLevel",vals)
end

function IFP.OnLoadedTileDefinitions(manager)
    manager:getSprite("industry_02_68"):getProperties():Set("fuelAmount","5000",false)
    manager:getSprite("industry_02_67"):getProperties():Set("fuelAmount","5000",false)

    local grid = IsoSpriteGrid.new(4,2)
    for k,v in pairs(IFP.gridTiles) do
        local sprite = manager:getSprite(k)
        grid:setSprite(v[1],v[2],sprite)
        sprite:setSpriteGrid(grid)
    end
end

Events.OnInitWorld.Add(IFP.OnInitWorld)
Events.OnLoadedTileDefinitions.Add(IFP.OnLoadedTileDefinitions)

IndustrialFuelPumps = IFP