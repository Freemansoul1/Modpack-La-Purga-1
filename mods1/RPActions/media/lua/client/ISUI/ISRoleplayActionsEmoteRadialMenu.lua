-------------------------------------------------------------------------------------------------------------------------------
--                    don't edit this code without asking fuu (me) or i will hunt you down like a dog                        --
--               don't bundle this mod into other mods (such as server assets) or i will hunt you down like a dog            --
--     i don't update this mod very often, and when i do, updates are reserved for important or major changes or additions   --
--                                                                                                                           --
--      please reach out to me on discord: @fuu.exe if you'd like to ask a question. i don't check steam comments often      --
-------------------------------------------------------------------------------------------------------------------------------

require 'ISUI/ISEmoteRadialMenu'

function subStand(menu)
    --stand
    menu:addSlice(getText("IGUI_RPAEmote_ArmsCrossed"), getTexture("media/ui/rpanormal/BobRPA_ArmsCrossed.png"), doEmote, "BobRPA_ArmsCrossed")
    menu:addSlice(getText("IGUI_RPAEmote_AtEase"), getTexture("media/ui/rpanormal/BobRPA_AtEase.png"), doEmote, "BobRPA_AtEase")
    menu:addSlice(getText("IGUI_RPAEmote_DoItToEm"), getTexture("media/ui/rpanormal/BobRPA_DoItToEm.png"), doEmote, "BobRPA_DoItToEm")
    menu:addSlice(getText("IGUI_RPAEmote_HandsAtWaist"), getTexture("media/ui/rpanormal/BobRPA_HandsAtWaist.png"), doEmote, "BobRPA_HandsAtWaist")
    menu:addSlice(getText("IGUI_RPAEmote_CIA"), getTexture("media/ui/rpanormal/BobRPA_CIA.png"), doEmote, "BobRPA_CIA")
    menu:addSlice(getText("IGUI_RPAEmote_HandOnHip"), getTexture("media/ui/rpanormal/BobRPA_HandOnHip.png"), doEmote, "BobRPA_HandOnHip")
    menu:addSlice(getText("IGUI_RPAEmote_HandsOnHips"), getTexture("media/ui/rpanormal/BobRPA_HandsOnHips.png"), doEmote, "BobRPA_HandsOnHips")
    menu:addSlice(getText("IGUI_RPAEmote_HandsBehindBack"), getTexture("media/ui/rpanormal/BobRPA_HandsBehindBack.png"), doEmote, "BobRPA_HandsBehindBack")
    menu:addSlice(getText("IGUI_RPAEmote_HandsInPockets"), getTexture("media/ui/rpanormal/BobRPA_HandsInPockets.png"), doEmote, "BobRPA_HandsInPockets")
    menu:addSlice(getText("IGUI_RPAEmote_HoldArmFront"), getTexture("media/ui/rpanormal/BobRPA_HoldArmFront.png"), doEmote, "BobRPA_HoldArmFront")
    --leans
    menu:addSlice(getText("IGUI_RPAEmote_LeanBack"), getTexture("media/ui/rpanormal/BobRPA_LeanBack.png"), doEmote, "BobRPA_LeanBack")
    menu:addSlice(getText("IGUI_RPAEmote_LeanForward"), getTexture("media/ui/rpanormal/BobRPA_LeanForward.png"), doEmote, "BobRPA_LeanForward")
    menu:addSlice(getText("IGUI_RPAEmote_LeanSide_r"), getTexture("media/ui/rpanormal/BobRPA_LeanSide_r.png"), doEmote, "BobRPA_LeanSide_r")
    menu:addSlice(getText("IGUI_RPAEmote_LeanSide"), getTexture("media/ui/rpanormal/BobRPA_LeanSide.png"), doEmote, "BobRPA_LeanSide")
    --held emotes, like surrender
    menu:addSlice(getText("IGUI_RPAEmote_Injured"), getTexture("media/ui/rpanormal/BobRPA_Injured.png"), doEmote, "BobRPA_Injured")
end

function subSit(menu)
    --kneels
    menu:addSlice(getText("IGUI_RPAEmote_Kneel"), getTexture("media/ui/rpanormal/BobRPA_Kneel.png"), doEmote, "BobRPA_Kneel")
    menu:addSlice(getText("IGUI_RPAEmote_Squat"), getTexture("media/ui/rpanormal/BobRPA_Squat.png"), doEmote, "BobRPA_Squat")
    --chairs
    menu:addSlice(getText("IGUI_RPAEmote_SitChair1"), getTexture("media/ui/rpanormal/BobRPA_SitChair1.png"), doEmote, "BobRPA_SitChair1")
    menu:addSlice(getText("IGUI_RPAEmote_SitChairPrim"), getTexture("media/ui/rpanormal/BobRPA_SitChairPrim.png"), doEmote, "BobRPA_SitChairPrim")
    menu:addSlice(getText("IGUI_RPAEmote_SitChairPrimAlt"), getTexture("media/ui/rpanormal/BobRPA_SitChairPrimAlt.png"), doEmote, "BobRPA_SitChairPrim2")
    menu:addSlice(getText("IGUI_RPAEmote_SitChairProper"), getTexture("media/ui/rpanormal/BobRPA_SitChairProper.png"), doEmote, "BobRPA_SitChairProper")
    menu:addSlice(getText("IGUI_RPAEmote_SitChairProperAlt"), getTexture("media/ui/rpanormal/BobRPA_SitChairProperAlt.png"), doEmote, "BobRPA_SitChairProper2")
    menu:addSlice(getText("IGUI_RPAEmote_SitChairSide"), getTexture("media/ui/rpanormal/BobRPA_SitChairSide.png"), doEmote, "BobRPA_SitChairSide")
    --ground
    menu:addSlice(getText("IGUI_RPAEmote_SitCrossedLegs"), getTexture("media/ui/rpanormal/BobRPA_SitCrossedLegs.png"), doEmote, "BobRPA_SitCrossedLegs")
    menu:addSlice(getText("IGUI_RPAEmote_SitKneesUp"), getTexture("media/ui/rpanormal/BobRPA_SitKneesUp.png"), doEmote, "BobRPA_SitKneesUp")
    menu:addSlice(getText("IGUI_RPAEmote_SitLounging"), getTexture("media/ui/rpanormal/BobRPA_SitLounging.png"), doEmote, "BobRPA_SitLounging")
    menu:addSlice(getText("IGUI_RPAEmote_SitOnKnees"), getTexture("media/ui/rpanormal/BobRPA_SitOnKnees.png"), doEmote, "BobRPA_SitOnKnees")
    menu:addSlice(getText("IGUI_RPAEmote_SitSideways"), getTexture("media/ui/rpanormal/BobRPA_SitSideways.png"), doEmote, "BobRPA_SitSideways")
end

function subLying(menu)
    menu:addSlice(getText("IGUI_RPAEmote_LieOnBack"), getTexture("media/ui/rpanormal/BobRPA_LieOnBack.png"), doEmote, "BobRPA_LieOnBack")
    menu:addSlice(getText("IGUI_RPAEmote_LieOnFloor"), getTexture("media/ui/rpanormal/BobRPA_LieOnFloor.png"), doEmote, "BobRPA_LieOnFloor")
    menu:addSlice(getText("IGUI_RPAEmote_LieOnSide"), getTexture("media/ui/rpanormal/BobRPA_LieOnSide.png"), doEmote, "BobRPA_LieOnSide")
end

function subActions(menu)
    menu:addSlice(getText("IGUI_RPAEmote_RPNutrition"), getTexture("media/ui/actions/RPNutrition.png"), ISRadialMenu.createSubMenu, menu, subFoodActions)
    menu:addSlice(getText("IGUI_RPAEmote_RPRecreation"), getTexture("media/ui/actions/RPRecreation.png"), ISRadialMenu.createSubMenu, menu, subRecActions)
    --menu:addSlice("Physical", getTexture("media/ui/actions/RPPhysical.png"), ISRadialMenu.createSubMenu, menu, subPhysActions)
end

function subRecActions(menu)
    menu:addSlice(getText("IGUI_RPAEmote_RPCigarette"), getTexture("media/ui/actions/RPCigarette.png"), doActions, "", "smoke")
    menu:addSlice(getText("IGUI_RPAEmote_RPRead"), getTexture("media/ui/actions/RPRead.png"), ISRadialMenu.createSubMenu, menu, subReadActions)
    menu:addSlice(getText("IGUI_RPAEmote_RPWrite"), getTexture("media/ui/actions/RPWrite.png"), ISRadialMenu.createSubMenu, menu, subWriteActions)
end

function subReadActions(menu)
    menu:addSlice(getText("IGUI_RPAEmote_RPBook"), getTexture("media/ui/actions/RPBook.png"), doActions, "Base.Book", "read")
    menu:addSlice(getText("IGUI_RPAEmote_RPJournal"), getTexture("media/ui/actions/RPJournal.png"), doActions, "Base.Journal", "read")
    menu:addSlice(getText("IGUI_RPAEmote_RPMagazine"), getTexture("media/ui/actions/RPMagazine.png"), doActions, "Base.Magazine", "read")
    menu:addSlice(getText("IGUI_RPAEmote_RPMap"), getTexture("media/ui/actions/RPMap.png"), doActions, "Base.MapInHand", "read")
    menu:addSlice(getText("IGUI_RPAEmote_RPNewspaper"), getTexture("media/ui/actions/RPNewspaper.png"), doActions, "Base.Newspaper", "read")
end

function subWriteActions(menu)
    menu:addSlice(getText("IGUI_RPAEmote_RPBookWrite"), getTexture("media/ui/actions/RPBookWrite.png"), doActions, "Base.Book", "write")
    menu:addSlice(getText("IGUI_RPAEmote_RPJournalWrite"), getTexture("media/ui/actions/RPJournalWrite.png"), doActions, "Base.Journal", "write")
    menu:addSlice(getText("IGUI_RPAEmote_RPMagazineWrite"), getTexture("media/ui/actions/RPMagazineWrite.png"), doActions, "Base.Magazine", "write")
    menu:addSlice(getText("IGUI_RPAEmote_RPMapWrite"), getTexture("media/ui/actions/RPMapWrite.png"), doActions, "Base.MapInHand", "write")
    menu:addSlice(getText("IGUI_RPAEmote_RPNewspaperWrite"), getTexture("media/ui/actions/RPNewspaperWrite.png"), doActions, "Base.Newspaper", "write")
end

function subFoodActions(menu)
    menu:addSlice(getText("IGUI_RPAEmote_RPDrink"), getTexture("media/ui/actions/RPDrink.png"), ISRadialMenu.createSubMenu, menu, subDrinkActions)
    menu:addSlice(getText("IGUI_RPAEmote_RPEat"), getTexture("media/ui/actions/RPEat.png"), ISRadialMenu.createSubMenu, menu, subEatActions)
end

function subDrinkActions(menu)
    menu:addSlice(getText("IGUI_RPAEmote_RPDrinkWater"), getTexture("media/ui/actions/RPDrinkWater.png"), doFoodActions, nil, "Base.WaterBottle", "drink", "drink")
    menu:addSlice(getText("IGUI_RPAEmote_RPDrinkSoda"), getTexture("media/ui/actions/RPDrinkSoda.png"), doFoodActions, nil, "Base.PopCanFizz", "drink", "drink")
    menu:addSlice(getText("IGUI_RPAEmote_RPDrinkSodaBottle"), getTexture("media/ui/actions/RPDrinkSodaBottle.png"), doFoodActions, nil, "Base.PopBottle", "drink", "drink")
    menu:addSlice(getText("IGUI_RPAEmote_RPDrinkBeerCan"), getTexture("media/ui/actions/RPDrinkBeerCan.png"), doFoodActions, nil, "Base.BeerCan", "drink", "drink")
    menu:addSlice(getText("IGUI_RPAEmote_RPDrinkBeerBottle"), getTexture("media/ui/actions/RPDrinkBeerBottle.png"), doFoodActions, nil, "Base.BeerBottle", "drink", "drink")
    menu:addSlice(getText("IGUI_RPAEmote_RPDrinkRWine"), getTexture("media/ui/actions/RPDrinkRWine.png"), doFoodActions, nil, "Base.RedWineBottle", "drink", "drink")
    menu:addSlice(getText("IGUI_RPAEmote_RPDrinkWWine"), getTexture("media/ui/actions/RPDrinkWWine.png"), doFoodActions, nil, "Base.WhiteWineBottle", "drink", "drink")
    menu:addSlice(getText("IGUI_RPAEmote_RPDrinkMug"), getTexture("media/ui/actions/RPDrinkMug.png"), doFoodActions, nil, "Base.MugWhite", "drink", "drink")
    menu:addSlice(getText("IGUI_RPAEmote_RPDrinkBowl"), getTexture("media/ui/actions/RPDrinkBowl.png"), doFoodActions, nil, "Base.Bowl", "drink", "drink")
    menu:addSlice(getText("IGUI_RPAEmote_RPDrinkCan"), getTexture("media/ui/actions/RPDrinkCan.png"), doFoodActions, nil, "Base.TinCanEmpty_Ground", "drink", "drink")
end

function subEatActions(menu)
    menu:addSlice(getText("IGUI_RPAEmote_RPEat1"), getTexture("media/ui/actions/RPEat1.png"), doFoodActions, nil, nil, "eat", "eat")
    menu:addSlice(getText("IGUI_RPAEmote_RPEat2"), getTexture("media/ui/actions/RPEat2.png"), doFoodActions, nil, nil, "2hand", "eat")
    menu:addSlice(getText("IGUI_RPAEmote_RPEatBowl"), getTexture("media/ui/actions/RPEatBowl.png"), doFoodActions, "Base.Spoon", "Base.Bowl", "2handbowl", "eat")
    menu:addSlice(getText("IGUI_RPAEmote_RPEatBowl2"), getTexture("media/ui/actions/RPEatBowl2.png"), doFoodActions, nil, "Base.Bowl", "2hand", "eat")
    menu:addSlice(getText("IGUI_RPAEmote_RPEatCan"), getTexture("media/ui/actions/RPEatCan.png"), doFoodActions, "Base.Spoon", "Base.TinCanEmpty_Ground", "2handbowl", "eat")
    menu:addSlice(getText("IGUI_RPAEmote_RPEatCan2"), getTexture("media/ui/actions/RPEatCan2.png"), doFoodActions, nil, "Base.TinCanEmpty_Ground", "2hand", "eat")
    menu:addSlice(getText("IGUI_RPAEmote_RPEatSandwich"), getTexture("media/ui/actions/RPEatSandwich.png"), doFoodActions, nil, "Base.Sandwich", "eat", "eat")
end

function doActions(item, action)
    local player = getSpecificPlayer(0)
    if action == "read" then
        ISTimedActionQueue.add(RPReadTimedAction:new(player, item))
    elseif action == "write" then
        ISTimedActionQueue.add(RPWriteTimedAction:new(player, item))
    elseif action == "smoke" then
        ISTimedActionQueue.add(RPSmokeTimedAction:new(player))
    end
end

function doFoodActions(item1, item2, action, type)
    local player = getSpecificPlayer(0)
    ISTimedActionQueue.add(RPFoodTimedAction:new(player, item1, item2, action, type))
end


--define special poses
SpecialPoses = {
    ["RPA.BobRPA_Dad_Twerk_card"] = "BobRPA_DadTwerk",
    ["RPA.BobRPA_Family_Guy_card"] = "BobRPA_FamilyGuy",
    ["RPA.BobRPA_JackO_card"] = "BobRPA_JackO",
}

function subSpecial(menu)
    --if playerItems has a pose card in the SpecialPoses table, add slice of that card + push that animation to doEmote
    local playerItems = getPlayer():getInventory():getItems()
    for i=1,playerItems:size() do
        local item = playerItems:get(i-1)
        if SpecialPoses[item:getFullType()] then
            menu:addSlice(SpecialPoses[item:getFullType()], getTexture('media/ui/rpaspecial/' .. SpecialPoses[item:getFullType()] .. '.png'), doEmote, SpecialPoses[item:getFullType()])
        end
    end
end


--the submenu with categories
function onSubmenu(menu, player)
    menu:addSlice(getText("IGUI_RPAEmote_Cancel"), getTexture("media/ui/UI_RPA_Cancel.png"), doEmote, "BobRPS_Cancel")
    menu:addSlice(getText("IGUI_RPAEmote_Standing"), getTexture("media/ui/standing.png"), ISRadialMenu.createSubMenu, menu, subStand)
    menu:addSlice(getText("IGUI_RPAEmote_Sitting"), getTexture("media/ui/sitting.png"), ISRadialMenu.createSubMenu, menu, subSit)
    menu:addSlice(getText("IGUI_RPAEmote_Lying"), getTexture("media/ui/lying.png"), ISRadialMenu.createSubMenu, menu, subLying)
    menu:addSlice(getText("IGUI_RPAEmote_Actions"), getTexture("media/ui/actions.png"), ISRadialMenu.createSubMenu, menu, subActions)

    local RPAspc = false;
    local playerItems = getPlayer():getInventory():getItems()
    --adds a submenu if you have a certain card in your inventory
    for i=1,playerItems:size() do
        local item = playerItems:get(i-1)
        if SpecialPoses[item:getFullType()] then
            if not RPAspc then
                RPAspc = true;
                menu:addSlice(getText("IGUI_RPAEmote_Special"), getTexture("media/ui/UI_RPAspc.png"), ISRadialMenu.createSubMenu, menu, subSpecial)
            end
        end
    end
end

--play animations
function doEmote(emote)
    if string.sub(emote,1,string.len('BobRPA'))=='BobRPA' then
        --remove equipped items from hand
        getPlayer():setPrimaryHandItem(nil)
        getPlayer():setSecondaryHandItem(nil)
    end
    if string.sub(emote,1,string.len('BobRPS'))=='BobRPS' then
        --do nothing for now, keep equipped items
    end
    getSpecificPlayer(0):playEmote(emote)
end

--add the main pose slice to the q menu
function poseMain(menu, player)
    menu:addSlice("Poses", getTexture("media/ui/UI_RPA.png"), ISRadialMenu.createSubMenu, menu, onSubmenu)
end

--registers the pose slice
EmoteMenuAPI.registerSlice("Poses", poseMain)