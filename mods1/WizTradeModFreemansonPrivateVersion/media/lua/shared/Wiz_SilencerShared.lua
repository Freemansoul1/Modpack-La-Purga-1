-- Silencer API for multiple guns and supressor attachments

Events.OnGameBoot.Add(function()
	local sm = ScriptManager.instance
	if sm then
		local guns = {
			
			'Pistol',
			'Pistol2',
			'Pistol3',
			'AssaultRifle',
			'Wiz_WaltherPPK',
			'Wiz_Mp5',
			'Wiz_BarretM82',
			
		}
		for _,gun in ipairs(guns) do
			local item = sm:getItem("Base." .. gun)
			if item and item.DoParam then
				  --item:DoParam("ModelWeaponPart = Base.Wiz_Van_pistolsuppressor Base.Wiz_Van_pistolsuppressor wizsuppressor wizsuppressor")
				  --item:DoParam("ModelWeaponPart = Base.Wiz_Van_riflesuppressor Base.Wiz_Van_riflesuppressor wizsuppressor wizsuppressor")
				  item:DoParam("ModelWeaponPart = Base.Wiz_SmallPistol_Suppressor Base.Wiz_SmallPistol_Suppressor wizsmalpistolsilencer wizsmalpistolsilencer")
				  item:DoParam("ModelWeaponPart = Base.Wiz_SMG_Suppressor Base.Wiz_SMG_Suppressor wizsmgsilencer wizsmgsilencer")
				  item:DoParam("ModelWeaponPart = Base.Wiz_SilencerLarge Base.Wiz_SilencerLarge wizlargesilencer wizlargesilencer")
				--item:DoParam("ModelWeaponPart = Base.Wiz_Van_pistolsuppressor Base." .. gun .. "Wiz_Van_pistolsuppressor")
			end
		end
	end
end)

local stats = {
	--Wiz_Van_pistolsuppressor = { div = 15, snd = "silencershot_pistol" },
	--Wiz_Van_riflesuppressor = { div = 10, snd = "silencershot_rifle" },
	Wiz_SmallPistol_Suppressor = { div = 15, snd = "ppk_silencer" },
	Wiz_SMG_Suppressor = { div = 15, snd = "ppk_silencer" },
	Wiz_SilencerLarge = { div = 10, snd = "silencershot_rifle" },
	
}
local guns = {}

local function Silencer(gun)
	local part = gun.getCanon and gun:getCanon()
	local settings = part and stats[part:getType()]
	local gunName = gun:getName()
	guns[gunName] = guns[gunName] or {}
	local defaults = guns[gunName]
	defaults.sndVol = defaults.sndVol or gun:getSoundVolume()
	defaults.sndRad = defaults.sndRad or gun:getSoundRadius()
	defaults.swnSnd = defaults.swnSnd or gun:getSwingSound()
	gun:setSoundVolume(settings and defaults.sndVol / settings.div or defaults.sndVol)
	gun:setSoundRadius(settings and defaults.sndRad / settings.div or defaults.sndRad)
	gun:setSwingSound(settings and settings.snd or defaults.swnSnd)
end

local function HandItem(_, item)
	if item and item.getSoundVolume then
		Silencer(item)
	end
end

Events.OnEquipPrimary.Add(HandItem)
--Events.OnEquipSecondary.Add(HandItem) -- you know, in case they ever add dual-wielding.

Events.OnGameStart.Add(function()
	local player = getPlayer()
	HandItem(nil, player:getPrimaryHandItem())
	HandItem(nil, player:getSecondaryHandItem())
end)
