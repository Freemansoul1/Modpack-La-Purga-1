
function getRandomBodyPart(player)
	
	local parttohurt;
	local r = ZombRand(11);
	if(r == 0) then
	parttohurt = BodyPartType.LowerLeg_L;
	elseif(r == 1) then
	parttohurt = BodyPartType.LowerLeg_R;
	elseif(r == 2) then
	parttohurt = BodyPartType.UpperLeg_R;
	elseif(r == 3) then
	parttohurt = BodyPartType.UpperLeg_L;
	elseif(r == 4) then
	parttohurt = BodyPartType.UpperArm_R;
	elseif(r == 5) then
	parttohurt = BodyPartType.UpperArm_L;
	elseif(r == 6) then
	parttohurt = BodyPartType.Head;
	elseif(r == 7) then
	parttohurt = BodyPartType.Torso_Lower;
	elseif(r == 8) then
	parttohurt = BodyPartType.Torso_Upper;
	elseif(r == 9) then
	parttohurt = BodyPartType.ForeArm_L;
	else
	parttohurt = BodyPartType.ForeArm_R;
	end
	
	return player:getBodyDamage():getBodyPart(parttohurt);


end

function SetTrapDown(items, result, player)
local theTraptoSet;
	for i=0, items:size()-1 do
		theTraptoSet = items:get(i);
	end
	
	local AlreadyTrapOnSquare = false;
	if (player:getCurrentSquare():getModData().isTrapSet == true) then
			local Objs = player:getCurrentSquare():getObjects();
		
		for i=0, Objs:size()-1 do
			if (Objs:get(i):getWorldObjectIndex() ~= -1) then
				if(Objs:get(i):getItem() ~= nil) and (Objs:get(i):getItem():getModData().isSet == true or Objs:get(i):getModData().isSet == true) then
					AlreadyTrapOnSquare = true;					
				end
			end
		end
	end
	
	if(AlreadyTrapOnSquare == false) then

		player:getCurrentSquare():getModData().isTrapSet = true;
		player:getCurrentSquare():transmitModdata();
		player:getInventory():Remove(theTraptoSet);
		theTraptoSet = player:getCurrentSquare():AddWorldInventoryItem(theTraptoSet,0.5,0.5,0);
		player:getModData().immuneToTrap = true;
		theTraptoSet:getModData().isSet = true;
		theTraptoSet:getWorldItem():getModData().isSet = true;
		theTraptoSet:getWorldItem():transmitModData();
		sendClientCommand(player, "Trap", "SetTrap", {x = player:getX(),y = player:getY(),z = player:getZ(),trapid = theTraptoSet:getWorldItem():getKeyId()});
		
	else
		player:Say("Already a trap on this square");
		sendClientCommand(player, "Trap", "Say", {saythis = "Already a trap on this square"});
	end
	
end

function getTextureFor(name)

	--getPlayer():Say(name);
	local temp = getPlayer():getInventory():AddItem(name);
	--local temp = InventoryItem.new('Base',name,name,name);
	--getPlayer():Say(temp:getType());
	local texture = temp:getTexture();
	getPlayer():getInventory():Remove(temp);
	return texture;

end

function HandleTrap(player, trap)

	local player        = getPlayer()
	local desc          = player:getDescriptor()

	if(trap:getType() == "BearTrap") and (trap:getModData().isSet == true or trap:getWorldItem():getModData().isSet == true) then
		local BP;

		BP = player:getBodyDamage():getBodyPart(BodyPartType.Foot_L );
		BP:generateDeepWound();
		BP = player:getBodyDamage():getBodyPart(BodyPartType.Foot_R );
		BP:generateDeepWound();

		BP:AddDamage(ZombRand(50) + 40);
		
		trap:getModData().isSet = false;
		trap:getWorldItem():getModData().isSet = false;
		player:getCurrentSquare():getModData().isTrapSet = false;
		player:getCurrentSquare():transmitModdata();
		player:getCurrentSquare():transmitRemoveItemFromSquare(trap:getWorldItem());
		trap:getWorldItem():removeFromSquare();				
		
		local newtrap = player:getInventory():AddItem("traps."..trap:getType().."Closed");
		player:getCurrentSquare():AddWorldInventoryItem(newtrap,0.5,0.5,0);
		player:getInventory():Remove(newtrap);
		
		getSoundManager():PlayWorldSound("beartrap", false, getPlayer():getCurrentSquare(), 0.2, 60, 0.2, false)
		local cri = ZombRand(1,4)

		if desc:isFemale() == false then


			if cri == 1 then

				getSoundManager():PlayWorldSound("distscream1", false, getPlayer():getCurrentSquare(), 0.5, 300, 0.7, false) ;

			elseif cri == 2 then

				getSoundManager():PlayWorldSound("distscream8", false, getPlayer():getCurrentSquare(), 0.5, 300, 0.7, false) ;

			elseif cri == 3 then

				getSoundManager():PlayWorldSound("distscream6", false, getPlayer():getCurrentSquare(), 0.5, 300, 0.7, false) ;

			elseif cri == 4 then

				getSoundManager():PlayWorldSound("distscream7", false, getPlayer():getCurrentSquare(), 0.5, 300, 0.7, false) ;

			end

		else

			if cri == 1 then

				getSoundManager():PlayWorldSound("distscream2", false, getPlayer():getCurrentSquare(), 0.5, 300, 0.7, false) ;

			elseif cri == 2 then

				getSoundManager():PlayWorldSound("distscream3", false, getPlayer():getCurrentSquare(), 0.5, 300, 0.7, false) ;

			elseif cri == 3 then

				getSoundManager():PlayWorldSound("distscream4", false, getPlayer():getCurrentSquare(), 0.5, 300, 0.7, false) ;

			elseif cri == 4 then

				getSoundManager():PlayWorldSound("distscream5", false, getPlayer():getCurrentSquare(), 0.5, 300, 0.7, false) ;

			end


		end

		addSound(player, player:getX(), player:getY(), player:getZ(), 150, 50);

	elseif(trap:getType() == "BearTrapN4") or (trap:getType() == "BearTrapN1") or (trap:getType() == "BearTrapN2") or (trap:getType() == "BearTrapN3") and (trap:getModData().isSet == true or trap:getWorldItem():getModData().isSet == true) then
		local BP;

		BP = player:getBodyDamage():getBodyPart(BodyPartType.Foot_L );
		BP:generateDeepWound();
		BP = player:getBodyDamage():getBodyPart(BodyPartType.Foot_R );
		BP:generateDeepWound();


		BP:AddDamage(ZombRand(40) + 40);

		trap:getModData().isSet = false;
		trap:getWorldItem():getModData().isSet = false;
		player:getCurrentSquare():getModData().isTrapSet = false;
		player:getCurrentSquare():transmitModdata();
		player:getCurrentSquare():transmitRemoveItemFromSquare(trap:getWorldItem());
		trap:getWorldItem():removeFromSquare();

		local newtrap = player:getInventory():AddItem("traps.BearTrapClosed");
		player:getCurrentSquare():AddWorldInventoryItem(newtrap,0.5,0.5,0);
		player:getInventory():Remove(newtrap);

		getSoundManager():PlayWorldSound("beartrap", false, getPlayer():getCurrentSquare(), 0.2, 60, 0.2, false) ;
		local cri = ZombRand(1,4)

		if desc:isFemale() == false then


			if cri == 1 then

				getSoundManager():PlayWorldSound("distscream1", false, getPlayer():getCurrentSquare(), 0.5, 300, 0.7, false) ;

			elseif cri == 2 then

				getSoundManager():PlayWorldSound("distscream8", false, getPlayer():getCurrentSquare(), 0.5, 300, 0.7, false) ;

			elseif cri == 3 then

				getSoundManager():PlayWorldSound("distscream6", false, getPlayer():getCurrentSquare(), 0.5, 300, 0.7, false) ;

			elseif cri == 4 then

				getSoundManager():PlayWorldSound("distscream7", false, getPlayer():getCurrentSquare(), 0.5, 300, 0.7, false) ;

			end

		else

			if cri == 1 then

				getSoundManager():PlayWorldSound("distscream2", false, getPlayer():getCurrentSquare(), 0.5, 300, 0.7, false) ;

			elseif cri == 2 then

				getSoundManager():PlayWorldSound("distscream3", false, getPlayer():getCurrentSquare(), 0.5, 300, 0.7, false) ;

			elseif cri == 3 then

				getSoundManager():PlayWorldSound("distscream4", false, getPlayer():getCurrentSquare(), 0.5, 300, 0.7, false) ;

			elseif cri == 4 then

				getSoundManager():PlayWorldSound("distscream5", false, getPlayer():getCurrentSquare(), 0.5, 300, 0.7, false) ;

			end


		end

		addSound(player, player:getX(), player:getY(), player:getZ(), 150, 50);

	elseif(trap:getType() == "WoodPlankTrap") or (trap:getType() == "WoodPlankTrapN1") or (trap:getType() == "WoodPlankTrapN2") or (trap:getType() == "WoodPlankTrapN3") or (trap:getType() == "WoodPlankTrapN4") and (trap:getModData().isSet == true or trap:getWorldItem():getModData().isSet == true) then
		local BP;

		if ZombRand(1,5) == 1 then
			BP = player:getBodyDamage():getBodyPart(BodyPartType.Foot_L );
			BP:generateDeepWound();
			BP = player:getBodyDamage():getBodyPart(BodyPartType.Foot_R );
			BP:generateDeepWound();
		else
			BP = player:getBodyDamage():getBodyPart(BodyPartType.Foot_L );
			BP = player:getBodyDamage():getBodyPart(BodyPartType.Foot_R );
		end


		BP:AddDamage(ZombRand(40) + 40);

		trap:getModData().isSet = false;
		trap:getWorldItem():getModData().isSet = false;
		player:getCurrentSquare():getModData().isTrapSet = false;
		player:getCurrentSquare():transmitModdata();
		player:getCurrentSquare():transmitRemoveItemFromSquare(trap:getWorldItem());
		trap:getWorldItem():removeFromSquare();

		local newtrap = player:getInventory():AddItem("traps.WoodPlankTrapBroken");
		player:getCurrentSquare():AddWorldInventoryItem(newtrap,0.5,0.5,0);
		player:getInventory():Remove(newtrap);

		getSoundManager():PlayWorldSound("beartrap", false, getPlayer():getCurrentSquare(), 0.2, 60, 0.2, false) ;
		local cri = ZombRand(1,4)

		if desc:isFemale() == false then


			if cri == 1 then

				getSoundManager():PlayWorldSound("distscream1", false, getPlayer():getCurrentSquare(), 0.5, 300, 0.7, false) ;

			elseif cri == 2 then

				getSoundManager():PlayWorldSound("distscream8", false, getPlayer():getCurrentSquare(), 0.5, 300, 0.7, false) ;

			elseif cri == 3 then

				getSoundManager():PlayWorldSound("distscream6", false, getPlayer():getCurrentSquare(), 0.5, 300, 0.7, false) ;

			elseif cri == 4 then

				getSoundManager():PlayWorldSound("distscream7", false, getPlayer():getCurrentSquare(), 0.5, 300, 0.7, false) ;

			end

		else

			if cri == 1 then

				getSoundManager():PlayWorldSound("distscream2", false, getPlayer():getCurrentSquare(), 0.5, 300, 0.7, false) ;

			elseif cri == 2 then

				getSoundManager():PlayWorldSound("distscream3", false, getPlayer():getCurrentSquare(), 0.5, 300, 0.7, false) ;

			elseif cri == 3 then

				getSoundManager():PlayWorldSound("distscream4", false, getPlayer():getCurrentSquare(), 0.5, 300, 0.7, false) ;

			elseif cri == 4 then

				getSoundManager():PlayWorldSound("distscream5", false, getPlayer():getCurrentSquare(), 0.5, 300, 0.7, false) ;

			end


		end

		addSound(player, player:getX(), player:getY(), player:getZ(), 150, 50);


	elseif(trap:getType() == "TripwireTrap") and (trap:getModData().isSet == true or trap:getWorldItem():getModData().isSet == true) then


		trap:getModData().isSet = false;
		trap:getWorldItem():getModData().isSet = false;
		player:getCurrentSquare():getModData().isTrapSet = false;
		player:getCurrentSquare():transmitModdata();
		player:getCurrentSquare():transmitRemoveItemFromSquare(trap:getWorldItem());
		trap:getWorldItem():removeFromSquare();

		local newtrap = player:getInventory():AddItem("traps.TripwireTrapBroken");
		player:getCurrentSquare():AddWorldInventoryItem(newtrap,0.5,0.5,0);
		player:getInventory():Remove(newtrap);

		getSoundManager():PlayWorldSound("beartrap", false, getPlayer():getCurrentSquare(), 0.5, 80, 0.5, false) ;

	elseif(trap:getType() == "TripwireAlarmTrap") and (trap:getModData().isSet == true or trap:getWorldItem():getModData().isSet == true) then

		trap:getModData().isSet = false;
		trap:getWorldItem():getModData().isSet = false;
		player:getCurrentSquare():getModData().isTrapSet = false;
		player:getCurrentSquare():transmitModdata();
		player:getCurrentSquare():transmitRemoveItemFromSquare(trap:getWorldItem());
		trap:getWorldItem():removeFromSquare();

		local newtrap = player:getInventory():AddItem("traps.TripwireAlarmTrapBroken");
		player:getCurrentSquare():AddWorldInventoryItem(newtrap,0.5,0.5,0);
		player:getInventory():Remove(newtrap);

		getSoundManager():PlayWorldSound("tripwirealarm", false, getPlayer():getCurrentSquare(), 0.5, 130, 0.5, false) ;
		addSound(player, player:getX(), player:getY(), player:getZ(), 130, 50);
		
	elseif (trap:getType() == "SpikeTrap") and (trap:getModData().isSet == true) then
	
		local BP;

		if ZombRand(1,2) == 1 then
			BP = player:getBodyDamage():getBodyPart(BodyPartType.Foot_L );
			BP:generateDeepWound();
			BP = player:getBodyDamage():getBodyPart(BodyPartType.Foot_R );
			BP:generateDeepWound();
		else
			BP = player:getBodyDamage():getBodyPart(BodyPartType.Foot_L );
			BP = player:getBodyDamage():getBodyPart(BodyPartType.Foot_R );
		end

	
		BP:AddDamage(ZombRand(50) + 40);
		
		trap:getModData().isSet = false;
		trap:getWorldItem():getModData().isSet = false;
		player:getCurrentSquare():getModData().isTrapSet = false;
		player:getCurrentSquare():transmitModdata();
		
		player:getCurrentSquare():transmitRemoveItemFromSquare(trap:getWorldItem());
		trap:getWorldItem():removeFromSquare();		
		
		local newtrap = player:getInventory():AddItem("traps."..trap:getType().."Closed");
		player:getCurrentSquare():AddWorldInventoryItem(newtrap,0.5,0.5,0);
		player:getInventory():Remove(newtrap);
		
		getSoundManager():PlayWorldSound("stabbing", false, getPlayer():getCurrentSquare(), 0.5, 80, 0.5, false) ;
		local cri = ZombRand(1,4)

		if desc:isFemale() == false then


			if cri == 1 then

				getSoundManager():PlayWorldSound("distscream1", false, getPlayer():getCurrentSquare(), 0.5, 300, 0.7, false) ;

			elseif cri == 2 then

				getSoundManager():PlayWorldSound("distscream8", false, getPlayer():getCurrentSquare(), 0.5, 300, 0.7, false) ;

			elseif cri == 3 then

				getSoundManager():PlayWorldSound("distscream6", false, getPlayer():getCurrentSquare(), 0.5, 300, 0.7, false) ;

			elseif cri == 4 then

				getSoundManager():PlayWorldSound("distscream7", false, getPlayer():getCurrentSquare(), 0.5, 300, 0.7, false) ;

			end

		else

			if cri == 1 then

				getSoundManager():PlayWorldSound("distscream2", false, getPlayer():getCurrentSquare(), 0.5, 300, 0.7, false) ;

			elseif cri == 2 then

				getSoundManager():PlayWorldSound("distscream3", false, getPlayer():getCurrentSquare(), 0.5, 300, 0.7, false) ;

			elseif cri == 3 then

				getSoundManager():PlayWorldSound("distscream4", false, getPlayer():getCurrentSquare(), 0.5, 300, 0.7, false) ;

			elseif cri == 4 then

				getSoundManager():PlayWorldSound("distscream5", false, getPlayer():getCurrentSquare(), 0.5, 300, 0.7, false) ;

			end


		end

		addSound(player, player:getX(), player:getY(), player:getZ(), 150, 50);

	end



end

function CheckForTrap(player)
	if(player:getCurrentSquare() ~= nil) then
		if (player:getCurrentSquare():getModData().isTrapSet == true) and (player:getModData().immuneToTrap ~= true) then
				local Objs = player:getCurrentSquare():getObjects();
			
			for i=0, Objs:size()-1 do
				if (Objs:get(i):getWorldObjectIndex() ~= -1) then -- (Objs:get(i):getName() == "Spike Trap (Set)") then
					if(Objs:get(i):getItem() ~= nil) and (Objs:get(i):getItem():getModData().isSet == true or Objs:get(i):getModData().isSet == false) then
						HandleTrap(player,Objs:get(i):getItem());
					end
				end
			end
			
			
		elseif (player:getCurrentSquare():getModData().isTrapSet == nil) or (player:getCurrentSquare():getModData().isTrapSet == false) or (player:getModData().immuneToTrap == nil) then
			player:getModData().immuneToTrap = false; 
		end
	end
end

function TrapupdateThePlayer(player)

	if(player:getVehicle() == nil) then
		CheckForTrap(player);
		player:getInventory():Remove("Nothing");
	end

end



Events.OnPlayerUpdate.Add(TrapupdateThePlayer);
