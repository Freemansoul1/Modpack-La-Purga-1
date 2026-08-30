---made for v41, sandbox not always loaded on Distributions merge

local Distributions = {}

function Distributions.addLootItem(item,chance,dist)
    if dist ~= nil and dist.items ~= nil then
        table.insert(dist.items,item)
        table.insert(dist.items,chance)
    end
end

function Distributions.addLoot()
    local dist = ProceduralDistributions.list
    local item = "DFM.DryFish"
    Distributions.addLootItem( item, 1, dist["GigamartCannedFood"] )
end

function Distributions.addCraftingMagazines()
    local dist = ProceduralDistributions.list
    local item = "DFM.DryFishModCraftMagazine"

    Distributions.addLootItem( item, 0.2    , dist["BookstoreMisc"] )
    Distributions.addLootItem( item, 8      , dist["CampingStoreBooks"] )
    Distributions.addLootItem( item, 1      , dist["CampingStoreBooks"] )
    Distributions.addLootItem( item, 2      , dist["CampingStoreBooks"].junk )
    Distributions.addLootItem( item, 1.2    , dist["CrateMagazines"] )
    Distributions.addLootItem( item, 0.01   , dist["LivingRoomSideTable"] )
    Distributions.addLootItem( item, 0.2    , dist["LibraryBooks"] )
    Distributions.addLootItem( item, 0.2    , dist["MagazineRackMixed"] )
    Distributions.addLootItem( item, 0.5    , dist["PostOfficeMagazines"] )
    Distributions.addLootItem( item, 1      , dist["SurvivalGear"] )
    Distributions.addLootItem( item, 0.2    , dist["SurvivalGear"] )

    ItemPickerJava.doParse = true
end

function Distributions.OnInitGlobalModData()
    if SandboxVars.DryFishMod.CraftingMagazine then
        Distributions.addCraftingMagazines()
    end
end

function Distributions.OnLoadedMapZones()
    if ItemPickerJava.doParse then
        ItemPickerJava.doParse = nil
        ItemPickerJava.Parse()
    end
end

Events.OnPreDistributionMerge.Add(Distributions.addLootItem)
Events.OnInitGlobalModData.Add(Distributions.OnInitGlobalModData)
Events.OnLoadedMapZones.Add(Distributions.OnLoadedMapZones)

DryFishMod.Distributions = Distributions
