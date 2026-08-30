-- TROWABLES and AMMO on the ground

-- function to have multiple objects in hand to trow
function WizReloadTrowable(wielder, weapon)
local player = getSpecificPlayer(0);
local inhand = player:getPrimaryHandItem();
	if inhand ~= nil then
		local name = inhand:getDisplayName();
		
		if name == "Flashman Star Darts" and player:getInventory():contains("Wiz_FlashmanBlueStar") then
		local count = tonumber(player:getInventory():getNumberOfItem("Wiz_FlashmanBlueStar"));
			if count > 1 then
			player:getInventory():Remove("Wiz_FlashmanBlueStar");
			else
			player:getInventory():Remove("Wiz_FlashmanBlueStar");
			player:setPrimaryHandItem(nil);
			end
			
		elseif name == "Shuriken" and player:getInventory():contains("Wiz_Shuriken") then
		local count = tonumber(player:getInventory():getNumberOfItem("Wiz_Shuriken"));
			if count > 1 then
			player:getInventory():Remove("Wiz_Shuriken");
			else
			player:getInventory():Remove("Wiz_Shuriken");
			player:setPrimaryHandItem(nil);
			end
			
		elseif name == "Ninja Smoke Bomb" and player:getInventory():contains("Wiz_NinjaSmokeBomb") then
		local count = tonumber(player:getInventory():getNumberOfItem("Wiz_NinjaSmokeBomb"));
			if count > 1 then
			player:getInventory():Remove("Wiz_NinjaSmokeBomb");
			else
			player:getInventory():Remove("Wiz_NinjaSmokeBomb");
			player:setPrimaryHandItem(nil);
			end
			
		elseif name == "Holy Water Flask" and player:getInventory():contains("Wiz_HolyWater") then
		local count = tonumber(player:getInventory():getNumberOfItem("Wiz_HolyWater"));
			if count > 1 then
			player:getInventory():Remove("Wiz_HolyWater");
			else
			player:getInventory():Remove("Wiz_HolyWater");
			player:setPrimaryHandItem(nil);
			end
			
		elseif name == "Acid Flask" and player:getInventory():contains("Wiz_AcidFlask") then
		local count = tonumber(player:getInventory():getNumberOfItem("Wiz_AcidFlask"));
			if count > 1 then
			player:getInventory():Remove("Wiz_AcidFlask");
			else
			player:getInventory():Remove("Wiz_AcidFlask");
			player:setPrimaryHandItem(nil);
			end
			
		elseif name == "Batarang" and player:getInventory():contains("Wiz_Batarang") then
		local count = tonumber(player:getInventory():getNumberOfItem("Wiz_Batarang"));
			if count > 1 then
			player:getInventory():Remove("Wiz_Batarang");
			else
			player:getInventory():Remove("Wiz_Batarang");
			player:setPrimaryHandItem(nil);
			end
		
		
		end
	end
end

-- Function to Recuperate Projectiles - shurikens, bolts, arrows and so
function WizTrowableHit(wielder, target, weapon)
local player = getSpecificPlayer(0);
local inhand = player:getPrimaryHandItem();

local ItemtoDropA = "Wiz_FlashmanBlueStar.Wiz_FlashmanBlueStar";
local ItemtoDropB = "Wiz_Shuriken.Wiz_Shuriken";
local ItemtoDropC = "Wiz_Bolt.Wiz_Bolt";
local ItemtoDropD = "Wiz_Batarang";

	if inhand ~= nil then
		local name = inhand:getDisplayName();
		
		if name == "Flashman Star Darts" then
			local count = tonumber(player:getInventory():getNumberOfItem("Wiz_FlashmanBlueStar"));
			if count >= 1 then
				ItemtoDropA = target:getCurrentSquare():AddWorldInventoryItem(ItemtoDropA,0.3,0.5,0);
				ItemtoDropA:getWorldItem():transmitModData();
			end
			
		elseif name == "Shuriken" then
			local count = tonumber(player:getInventory():getNumberOfItem("Wiz_Shuriken"));
			if count >= 1 then
				ItemtoDropB = target:getCurrentSquare():AddWorldInventoryItem(ItemtoDropB,0.3,0.5,0);
				ItemtoDropB:getWorldItem():transmitModData();
			end
			
		elseif name == "Modern Crossbow" then -- Crossbow bolts
			local count = tonumber(player:getInventory():getNumberOfItem("Wiz_Bolt"));
			if count >= 1 then
				ItemtoDropC = target:getCurrentSquare():AddWorldInventoryItem(ItemtoDropC,0.3,0.5,0);
				ItemtoDropC:getWorldItem():transmitModData();
			end
			
		elseif name == "Batarang" then
			local count = tonumber(player:getInventory():getNumberOfItem("Wiz_Batarang"));
			if count >= 1 then
				ItemtoDropD = target:getCurrentSquare():AddWorldInventoryItem(ItemtoDropD,0.3,0.5,0);
				ItemtoDropD:getWorldItem():transmitModData();
			end
			
		end
	end
end

Events.OnWeaponSwingHitPoint.Add(WizReloadTrowable);
Events.OnWeaponHitCharacter.Add(WizTrowableHit);