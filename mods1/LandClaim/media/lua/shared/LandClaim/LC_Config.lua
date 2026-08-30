LandClaimConfig = {}

LandClaimConfig.Validated = true

LandClaimConfig.LCItemType = 'fears_storage_tiles_8'
LandClaimConfig.LCItemFullType = 'Moveables.fears_storage_tiles_8'

-- Safehouses --
-- NOT USED
LandClaimConfig.BuildingDistance = 0

LandClaimConfig.MinimumSafehouseLevel = 1
LandClaimConfig.MaximumSafehouseLevel = 3

LandClaimConfig.SafehouseLevels = {
    [1] = {
        Cost = {}
    }, -- no cost because we can't upgrade to level 1   
    [2] = {
        Cost = {
            ['Base.Plank'] = 12,
            ['Base.Screws'] = 5,
            ['Base.SheetMetal'] = 5,
            ['Base.Aluminum'] = 2,
            ['Base.Nails'] = 50
        }
    },
    [3] = {
        Cost = {
            ['Base.Plank'] = 24,
            ['Base.Screws'] = 10,
            ['Base.SheetMetal'] = 10,
            ['Base.Aluminum'] = 5,
            ['Base.Nails'] = 100
        }
    }
}

-- Safehouse Member Ranks --
LandClaimConfig.RankStrings = {}
LandClaimConfig.RankStrings.Owner = "Owner"
LandClaimConfig.RankStrings.Lieutenant = "Lieutenant"
LandClaimConfig.RankStrings.Member = "Member"
LandClaimConfig.RankStrings.Recruit = "Recruit"

LandClaimConfig.RankStrings.Unauthorized = "Unauthorized"

LandClaimConfig.MinimumMemberRankLevel = 1
LandClaimConfig.MaximumMemberRankLevel = 3
LandClaimConfig.RankLevels = {
    [1] = LandClaimConfig.RankStrings.Recruit,
    [2] = LandClaimConfig.RankStrings.Member,
    [3] = LandClaimConfig.RankStrings.Lieutenant
}

LandClaimConfig.Ranks = {}

LandClaimConfig.Ranks[LandClaimConfig.RankStrings.Unauthorized] = {
    canDestroy = false,
    canDismantle = false,
    canPickup = false,
    canBuild = false,
    canLockDoors = false
}

LandClaimConfig.Ranks[LandClaimConfig.RankStrings.Recruit] = {
    canDestroy = false,
    canDismantle = false,
    canPickup = true,
    canBuild = false,
    canLockDoors = true
}
LandClaimConfig.Ranks[LandClaimConfig.RankStrings.Member] = {
    canDestroy = false,
    canDismantle = true,
    canPickup = true,
    canBuild = true,
    canLockDoors = true
}
LandClaimConfig.Ranks[LandClaimConfig.RankStrings.Lieutenant] = {
    canDestroy = true,
    canDismantle = true,
    canPickup = true,
    canBuild = true,
    canLockDoors = true
}
LandClaimConfig.Ranks[LandClaimConfig.RankStrings.Owner] = {
    canDestroy = true,
    canDismantle = true,
    canPickup = true,
    canBuild = true,
    canLockDoors = true
}

