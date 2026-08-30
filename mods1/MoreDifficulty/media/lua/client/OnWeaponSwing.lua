-----------------------------------------------------
--Visit Sunday Drivers for the latest and greatest!--
--mod by lect----------------------------------------
--Free to use with permission------------------------
-----------------------------------------------------

require "ZoneCheck"

local function initMeleeStats(modData, inventoryItem, character)
	if	modData.CriticalChance		== nil and
		modData.CritDmgMultiplier	== nil and
		modData.MinDamage			== nil and
		modData.MaxDamage			== nil and
		modData.Name				== nil then
		
		modData.CriticalChance		= inventoryItem:getCriticalChance()
		modData.CritDmgMultiplier	= inventoryItem:getCritDmgMultiplier()
		modData.MinDamage			= inventoryItem:getMinDamage()
		modData.MaxDamage			= inventoryItem:getMaxDamage()
		modData.Name				= character:getPrimaryHandItem():getName()
	end
end

local function initRangedStats(modData, inventoryItem, character)
	if 	modData.AimingPerkHitChanceModifier == nil and
		modData.AimingPerkCritModifier 		== nil and
		modData.AimingPerkRangeModifier 	== nil and
		modData.AimingTime 					== nil and
		--modData.ReloadTime 					== nil and
		--modData.RecoilDelay					== nil and
		modData.Name						== nil then
		
		modData.AimingPerkHitChanceModifier = inventoryItem:getAimingPerkHitChanceModifier()
		modData.AimingPerkCritModifier 		= inventoryItem:getAimingPerkCritModifier()
		modData.AimingPerkRangeModifier 	= inventoryItem:getAimingPerkRangeModifier()
		modData.AimingTime					= inventoryItem:getAimingTime()
		--modData.ReloadTime					= inventoryItem:getReloadTime()
		--modData.RecoilDelay					= inventoryItem:getRecoilDelay()
		modData.Name						= character:getPrimaryHandItem():getName()
	end
end

local function OnWeaponSwing(character, handWeapon)
	if character:getPrimaryHandItem() == nil then return end
	
	local tierzone = checkZone()
	
	local tiercritratemod	= {tonumber(SandboxVars.OnWeaponSwing.Tier1critrate), tonumber(SandboxVars.OnWeaponSwing.Tier2critrate), tonumber(SandboxVars.OnWeaponSwing.Tier3critrate), tonumber(SandboxVars.OnWeaponSwing.Tier4critrate)}
	local tiercritmultimod	= {tonumber(SandboxVars.OnWeaponSwing.Tier1critmulti), tonumber(SandboxVars.OnWeaponSwing.Tier2critmulti), tonumber(SandboxVars.OnWeaponSwing.Tier3critmulti), tonumber(SandboxVars.OnWeaponSwing.Tier4critmulti)}
	local tierdmgmod		= {tonumber(SandboxVars.OnWeaponSwing.Tier1dmg), tonumber(SandboxVars.OnWeaponSwing.Tier2dmg), tonumber(SandboxVars.OnWeaponSwing.Tier3dmg), tonumber(SandboxVars.OnWeaponSwing.Tier4dmg)}
	
	local localdmgmulti		= tierdmgmod[tierzone]
	local localcritrate		= tiercritratemod[tierzone]
	local localcritmulti	= tiercritmultimod[tierzone]
	
	local inventoryItem = handWeapon
	local modData = inventoryItem:getModData()
	
	if tierzone and not handWeapon:isRanged() then
		initMeleeStats(modData, inventoryItem, character)
		
		inventoryItem:setCriticalChance(modData.CriticalChance * localcritrate)
		inventoryItem:setCritDmgMultiplier(modData.CritDmgMultiplier * localcritmulti)
		inventoryItem:setMinDamage(modData.MinDamage * localdmgmulti)
		inventoryItem:setMaxDamage(modData.MaxDamage * localdmgmulti)
		inventoryItem:setName(modData.Name .. " [T" .. tostring(tierzone) .. "]")
	elseif tierzone and handWeapon:isRanged() then
		initRangedStats(modData, inventoryItem, character)
		local rangedmulti = 1.1
		
		if character:HasTrait("Brave")			then rangedmulti = rangedmulti - 0.125 end
		if character:HasTrait("Desensitized")	then rangedmulti = rangedmulti - 0.25 end
		if character:HasTrait("Cowardly")		then rangedmulti = rangedmulti + 0.15 end
		if character:HasTrait("ShortSighted")	then rangedmulti = rangedmulti + 0.1 end
		if character:HasTrait("EagleEyed")		then rangedmulti = rangedmulti - 0.1 end

		rangedmulti = rangedmulti - character:getPerkLevel(Perks.Aiming)/20
		
		inventoryItem:setAimingTime(modData.AimingTime * (localdmgmulti/tierzone) ^ rangedmulti)
		--inventoryItem:setReloadTime(modData.ReloadTime * localdmgmulti ^ rangedmulti)
		--inventoryItem:setRecoilDelay(modData.RecoilDelay * localdmgmulti ^ rangedmulti)
		inventoryItem:setAimingPerkHitChanceModifier(modData.AimingPerkHitChanceModifier * (localdmgmulti/tierzone) ^ rangedmulti)
		inventoryItem:setAimingPerkCritModifier(modData.AimingPerkCritModifier * (localdmgmulti/tierzone) ^ rangedmulti)
		inventoryItem:setAimingPerkRangeModifier(modData.AimingPerkRangeModifier * (localdmgmulti/tierzone) ^ rangedmulti)
		inventoryItem:setName(modData.Name .. " [T" .. tostring(tierzone) .. "]")
	end
end
Events.OnWeaponSwing.Add(OnWeaponSwing)

local function WeaponCheck(character, inventoryItem)
	if inventoryItem == nil then return end
	local modData = inventoryItem:getModData()
	if inventoryItem:IsWeapon() and not inventoryItem:isRanged() then
		initMeleeStats(modData, inventoryItem, character)
		
		inventoryItem:setCriticalChance(modData.CriticalChance)
		inventoryItem:setCritDmgMultiplier(modData.CritDmgMultiplier)
		inventoryItem:setMinDamage(modData.MinDamage)
		inventoryItem:setMaxDamage(modData.MaxDamage)
		inventoryItem:setName(modData.Name)
	elseif inventoryItem:IsWeapon() and inventoryItem:isRanged() then
		initRangedStats(modData, inventoryItem, character)
		
		inventoryItem:setAimingPerkHitChanceModifier(modData.AimingPerkHitChanceModifier)
		inventoryItem:setAimingPerkCritModifier(modData.AimingPerkCritModifier)
		inventoryItem:setAimingPerkRangeModifier(modData.AimingPerkRangeModifier)
		inventoryItem:setAimingTime(modData.AimingTime)
		--inventoryItem:setRecoilDelay(modData.RecoilDelay)
		--inventoryItem:setReloadTime(modData.ReloadTime)
		inventoryItem:setName(modData.Name)
	end
end

Events.OnEquipPrimary.Add(WeaponCheck)
