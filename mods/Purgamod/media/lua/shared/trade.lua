require "Scripting/MerchantManager"


MerchantManager.settings = {
    sellback = false;           -- if true, you'll be able to offer any item that merchant sells
    sellback_m = 0.5,           -- sets worth multiplier for sellback items
    sellback_ruleset = false,   -- sets ruleset that will be used for all sellback items
    buyback = false,             -- if true, you'll be able buy items you sold
    buyback_m = 1.05,           -- sets worth multiplier for buyback items
    reputation = false,          -- if true, having remainder from deals will be increasing player's reputation
    reputation_stat = "rep",    -- defines the name of reputation stat
    reputation_m = 0.01,        -- sets reputation increase multiplier for successful deals (1% of "remainder - cost * 0.75") 
    discount_m = 0.80           -- maximum discount (20%)
};

MerchantManager.calculateDiscount = function (reputation)     -- returns discount based on reputation
end

MerchantManager.calculateReputation = function (remainder, cost)   --returns reputation increase based on remainder that goes to merchant
end