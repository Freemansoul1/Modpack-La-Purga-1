function HandleTrapZombie(zombie, trap)
    if(trap:getType() == "BearTrapN4") or (trap:getType() == "BearTrap") or (trap:getType() == "BearTrapN1") or (trap:getType() == "BearTrapN2") or (trap:getType() == "BearTrapN3") and (trap:getModData().isSet == true or trap:getWorldItem():getModData().isSet == true) then


        trap:getModData().isSet = false;
        trap:getWorldItem():getModData().isSet = false;
        zombie:getCurrentSquare():getModData().isTrapSet = false;
        zombie:getCurrentSquare():transmitModdata();
        zombie:getCurrentSquare():transmitRemoveItemFromSquare(trap:getWorldItem());
        trap:getWorldItem():removeFromSquare();

        local newtrap = zombie:getInventory():AddItem("traps.BearTrapClosed");
        zombie:getCurrentSquare():AddWorldInventoryItem(newtrap,0.5,0.5,0);
        zombie:getInventory():Remove(newtrap);

        zombie:knockDown(true)
        zombie:setCanWalk(false)
        zombie:toggleCrawling()
        zombie:DoZombieStats()

        getSoundManager():PlayWorldSound("beartrap", false, zombie:getCurrentSquare(), 0.5, 80, 0.5, false) ;
    end

    if(trap:getType() == "TripwireAlarmTrap") and (trap:getModData().isSet == true or trap:getWorldItem():getModData().isSet == true) then

        trap:getModData().isSet = false;
        trap:getWorldItem():getModData().isSet = false;
        zombie:getCurrentSquare():getModData().isTrapSet = false;
        zombie:getCurrentSquare():transmitModdata();
        zombie:getCurrentSquare():transmitRemoveItemFromSquare(trap:getWorldItem());
        trap:getWorldItem():removeFromSquare();

        local newtrap = zombie:getInventory():AddItem("traps.TripwireAlarmTrapBroken");
        zombie:getCurrentSquare():AddWorldInventoryItem(newtrap,0.5,0.5,0);
        zombie:getInventory():Remove(newtrap);

        zombie:knockDown(true)

        getSoundManager():PlayWorldSound("tripwirealarm", false, zombie:getCurrentSquare(), 0.5, 130, 0.5, false) ;
        addSound(zombie, zombie:getX(), zombie:getY(), zombie:getZ(), 60, 60);
    end

    if(trap:getType() == "TripwireTrap") and (trap:getModData().isSet == true or trap:getWorldItem():getModData().isSet == true) then

        trap:getModData().isSet = false;
        trap:getWorldItem():getModData().isSet = false;
        zombie:getCurrentSquare():getModData().isTrapSet = false;
        zombie:getCurrentSquare():transmitModdata();
        zombie:getCurrentSquare():transmitRemoveItemFromSquare(trap:getWorldItem());
        trap:getWorldItem():removeFromSquare();

        local newtrap = zombie:getInventory():AddItem("traps.TripwireTrapBroken");
        zombie:getCurrentSquare():AddWorldInventoryItem(newtrap,0.5,0.5,0);
        zombie:getInventory():Remove(newtrap);

        zombie:knockDown(true)

        getSoundManager():PlayWorldSound("beartrap", false, zombie:getCurrentSquare(), 0.5, 80, 0.5, false)
    end


    if(trap:getType() == "WoodPlankTrap") or (trap:getType() == "WoodPlankTrapN1") or (trap:getType() == "WoodPlankTrapN2") or (trap:getType() == "WoodPlankTrapN3") or (trap:getType() == "WoodPlankTrapN4") and (trap:getModData().isSet == true or trap:getWorldItem():getModData().isSet == true)  then

        trap:getModData().isSet = false;
        trap:getWorldItem():getModData().isSet = false;
        zombie:getCurrentSquare():getModData().isTrapSet = false;
        zombie:getCurrentSquare():transmitModdata();
        zombie:getCurrentSquare():transmitRemoveItemFromSquare(trap:getWorldItem());
        trap:getWorldItem():removeFromSquare();

        local newtrap = zombie:getInventory():AddItem("traps.WoodPlankTrapBroken");
        zombie:getCurrentSquare():AddWorldInventoryItem(newtrap,0.5,0.5,0);
        zombie:getInventory():Remove(newtrap);

        zombie:knockDown(true)
        zombie:setCanWalk(false)
        zombie:toggleCrawling()
        zombie:DoZombieStats()

        getSoundManager():PlayWorldSound("stabbing", false, zombie:getCurrentSquare(), 0.5, 80, 0.5, false);
    end

    if(trap:getType() == "SpikeTrap") and (trap:getModData().isSet == true or trap:getWorldItem():getModData().isSet == true)  then

        trap:getModData().isSet = false;
        trap:getWorldItem():getModData().isSet = false;
        zombie:getCurrentSquare():getModData().isTrapSet = false;
        zombie:getCurrentSquare():transmitModdata();
        zombie:getCurrentSquare():transmitRemoveItemFromSquare(trap:getWorldItem());
        trap:getWorldItem():removeFromSquare();

        local newtrap = zombie:getInventory():AddItem("traps.SpikeTrapClosed");
        zombie:getCurrentSquare():AddWorldInventoryItem(newtrap,0.5,0.5,0);
        zombie:getInventory():Remove(newtrap);

        zombie:knockDown(true)
        zombie:setCanWalk(false)
        zombie:toggleCrawling()
        zombie:DoZombieStats()

        getSoundManager():PlayWorldSound("stabbing", false, zombie:getCurrentSquare(), 0.5, 80, 0.5, false);
    end


end

function CheckForTrapZombie(zombie)


    if(zombie:getCurrentSquare() ~= nil) then
        if (zombie:getCurrentSquare():getModData().isTrapSet == true) and (zombie:getModData().immuneToTrap ~= true) then
            local Objs = zombie:getCurrentSquare():getObjects();

            for i=0, Objs:size()-1 do
                if (Objs:get(i):getWorldObjectIndex() ~= -1) then -- (Objs:get(i):getName() == "Spike Trap (Set)") then
                    if(Objs:get(i):getItem() ~= nil) and (Objs:get(i):getItem():getModData().isSet == true or Objs:get(i):getModData().isSet == false) then
                        HandleTrapZombie(zombie,Objs:get(i):getItem());
                    end
                end
            end


        elseif (zombie:getCurrentSquare():getModData().isTrapSet == nil) or (zombie:getCurrentSquare():getModData().isTrapSet == false) or (zombie:getModData().immuneToTrap == nil) then
            zombie:getModData().immuneToTrap = false;
        end
    end
end


function TrapupdateTheZombie(zombie)

    CheckForTrapZombie(zombie);


end


Events.OnZombieUpdate.Add(TrapupdateTheZombie)