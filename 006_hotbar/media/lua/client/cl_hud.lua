require('cl_hud_font')

local hud = _G.BLHUD
local renderer = nil
local limRange = 63
local inaccOpacityMul = 0.5 * 0.4

local chtex = {
	[1] = nil,
	[2] = getTexture("media/ui/cbt/quake.png"),
	[3] = getTexture("media/ui/cbt/dot.png"),
	[4] = getTexture("media/ui/cbt/isoc2.png"),
	[5] = getTexture("media/ui/cbt/isoc.png"),
	[6] = getTexture("media/ui/cbt/isoc3.png")
}

local mchtex = {
	[1] = getTexture("media/ui/cbt/isoc2.png"),
	[2] = getTexture("media/ui/cbt/iso.png"),
	[3] = getTexture("media/ui/cbt/isoc3.png"),
	[4] = nil,
	[5] = getTexture("media/ui/cbt/quake.png"),
	[6] = getTexture("media/ui/cbt/dot.png")
}

local function renderText(tex, offset, x, y, mul, fct, fctb, jam)
	local lala = hud.fntdef[offset]
	if not lala then return end

	local a = lala.x + lala.width
	local b = lala.y + lala.height
	local xo, yo = lala.x / 512, lala.y / 512
	local xx, yy = a / 512, b / 512
	local lw = lala.width * mul
	local lh = lala.height * mul
	x = x - lw / 2 
	y = y - lh / 2
	local llw, llh = x + lw, y + lh

	local a, b = hud.jammedRenderNeg, hud.jammedRender
	renderer:renderPoly(
		hud.ftex[tex],
		x, y, llw, y,
		llw, llh, x, llh,
		1, a, a, ((tex == 1 and fctb or fct) + b),
		xo, yo, xx, yo,
		xx, yy, xo, yy
	)
	return (lala.xadvance+lala.width+lala.xoffset) * mul, lala.height * mul
end

local bts = {}
local btslen = 0
local function toBytes(str)
	bts = {}
	for i = 1, string.len(str) do
		bts[i] = string.byte(string.sub(str, i, i))
	end
	btslen = #bts
end

local function renderBytes(x, y, jam, sc, fct, fctb)
	local xof = 0
	for i = 1, btslen do
		local x, y, a = x + xof, y, 1 + sc * 0.7
		renderText(2, bts[i], x, y, a, fct, fctb, jam)
		xof = xof + renderText(1, bts[i], x, y, a, fct, fctb, jam) * 0.5
	end
end

local function outBounce(t, b, c, d)
	t = t / d
	if t < 1 / 2.75 then
		return c * (7.5625 * t * t) + b
	elseif t < 2 / 2.75 then
		t = t - (1.5 / 2.75)
		return c * (7.5625 * t * t + 0.75) + b
	elseif t < 2.5 / 2.75 then
		t = t - (2.25 / 2.75)
		return c * (7.5625 * t * t + 0.9375) + b
	else
		t = t - (2.625 / 2.75)
		return c * (7.5625 * t * t + 0.984375) + b
	end
end

local function inBounce(t, b, c, d)
	return c - outBounce(d - t, 0, c, d) + b
end

local function inOutBounce(t, b, c, d)
	if t < d / 2 then
		return inBounce(t * 2, 0, c, d) * 0.5 + b
	else
		return outBounce(t * 2 - d, 0, c, d) * 0.5 + c * .5 + b
	end
end

local function outInBounce(t, b, c, d)
	if t < d / 2 then
		return outBounce(t * 2, b, c / 2, d)
	else
		return inBounce((t * 2) - d, b + c / 2, c / 2, d)
	end
end

--print(getTexture("media/ui/isocursor.png"):setWidth(1))

hud.aimOpacity = 0
hud.opacityRate = 0.005
hud.deltaFactor = 0
hud.inaccuracyFactor = 0
hud.jammedRender = 0
hud.jammedRenderNeg = 1
hud.renderAim = false
hud.ranged = false
hud.recoil = {}
local lastAmmo = -1

local dir = {
	{ 1, 0 },
	{ 0, 1 },
	{ -1, 0 },
	{ 0, -1 },
}

local dirmv = {
	{ 0, 0.5 },
	{ 0.5, 0 },
	{ 1, 0.5 },
	{ 0.5, 1 },
}

local diro = {
	{ false, true },
	{ true, false },
	{ false, true },
	{ true, false },
}



local gapValues = {
	32,
	16,
	20,
	24,
	28,
	30
}
local lengthValues = {
	8,2,4,10,16
}
local widthValues = {
	2, 0.5, 1, 4,8,10,16
}
local optionValues = {
	blhud_EnableAmmoCounter = true,
	blhud_LimitMeleeDistance = true,
	blhud_ShowLimitDistanceCursor = true,
	blhud_RenderTypeRanged = 1,
	blhud_RenderTypeMelee = 1,
	blhud_AmmoCounterFont = 1,
	blhud_GenericCrosshairGap = 1,
	blhud_GenericCrosshairMaxGap = 1,
	blhud_GenericCrosshairLength = 1,
	blhud_GenericCrosshairWidth = 1,
}
hud.chBaseOffset = 32
hud.chMaxOffset = 32
hud.chWidth = 2
hud.chLength = 8
function hud:applyOption(settings)
	for k, v in pairs(settings.options) do
		optionValues[k] = v
	end
	local opt = optionValues.blhud_AmmoCounterFont
	local ft = hud.fnts[opt]
	if ft then
		hud.ftex = ft.glyphs
		hud.fntdef = ft.defs
	end
	hud.chBaseOffset  = gapValues[optionValues.blhud_GenericCrosshairGap]
	hud.chMaxOffset  = gapValues[optionValues.blhud_GenericCrosshairMaxGap]
	hud.chLength  = lengthValues[optionValues.blhud_GenericCrosshairLength]
	hud.chWidth  = widthValues[optionValues.blhud_GenericCrosshairWidth]
end

local opt = 1
hud.ftex = hud.fnts[opt].glyphs
hud.fntdef = hud.fnts[opt].defs

local function drawCrosshairs(x, y, w, h, baseoff, off, inacc, r,g,b,a)
	-- renderer:render(nil, x-1, y-1, 2, 2, r, g, b, a, nil)
	for i = 1, 4 do
		local xm, xy= dirmv[i][1], dirmv[i][2]
		local sw, sh = diro[i][1] and w or h, diro[i][2] and w or h
		local xoff, yoff = dir[i][1] * (baseoff + off * inacc), dir[i][2] * (baseoff + off * inacc)
		local rx, ry = x + xoff - sw * xm+xm, y + yoff - sh * xy+xy

		renderer:render(nil, rx - 1, ry - 1, sw + 2, sh + 2, 0.2, 0.2, 0.2, a, nil)
		renderer:render(nil, rx, ry, sw, sh, r, g, b, a, nil)
	end
end

local core = nil
function hud.drawCrosshair()
	if not hud.renderAim then return end
	local playerIndex = 0 -- what if i have to support god damn splitscreen?
	local attacker = getSpecificPlayer(playerIndex)
	if not attacker then return end
	renderer = renderer or getRenderer()
	core = core or getCore()

	local zm = core:getZoom(0)
	local ts = 1 / zm
	local mx, my = getMouseX(), getMouseY()
	local inacc = hud.inaccuracyFactor
	local o = hud.aimOpacity - inacc * inaccOpacityMul

	if hud.aimOpacity > 0 then
		local ja, jb = hud.jammedRender, hud.jammedRenderNeg

		if hud.ranged then
			local rtex = chtex[optionValues.blhud_RenderTypeRanged]
			local offset = 32*ts

			if optionValues.blhud_RenderTypeRanged == 1 then
				drawCrosshairs(mx, my + offset, hud.chWidth, hud.chLength, hud.chBaseOffset, hud.chMaxOffset, inacc, 1, jb, jb, o )
			elseif optionValues.blhud_RenderTypeRanged == 2 then
				local os = 50 + 18 * inacc
				local s, sh = os, (os / 2)
				renderer:render(rtex, mx - sh, my + offset - sh, s, s, 1, jb, jb, o * 0.8, nil)
			elseif optionValues.blhud_RenderTypeRanged == 3 then
				local os = 6 + 1 * inacc
				local s, sh = os, (os / 2)
				renderer:render(rtex, mx - sh, my + offset - sh, s, s, 1, jb, jb, o * 0.8, nil)
			elseif optionValues.blhud_RenderTypeRanged >= 4 then
				local w, h = 64 * ts, 128 * ts
				renderer:render(rtex, mx - w / 2, my, w, h, 1, jb, jb, o, nil)
			end
		else
			local dtx, dty = 0, 0

			local w, h = 64 * ts, 128 * ts

			if optionValues.blhud_LimitMeleeDistance then
				if optionValues.blhud_ShowLimitDistanceCursor then
					-- for guidance.
					local cs, ch = 16, 8
					renderer:render(hud.ctex, mx - ch, my - ch, cs, cs, 1, jb, jb, o, nil)
				end

				local x, y, z = attacker:getX(), attacker:getY(), attacker:getZ()
				local ax, ay = ISCoordConversion.ToScreen(x, y, z)
				ax, ay = ax * ts, ay * ts - h

				local dx, dy = mx - ax, my - ay
				local dxy = math.abs(math.sqrt(dx * dx + dy * dy))
				dx, dy = dx / dxy, dy / dxy
				-- limit range based on the zoom
				dxy = dxy * zm
				dxy = dxy > limRange and limRange or dxy

				dtx, dty = ax + dx * ts * dxy, ay + dy * ts * dxy
			else
				dtx, dty = mx, my
			end

			local rtex = mchtex[optionValues.blhud_RenderTypeMelee]
			-- local y = my + 32 * ts
			if optionValues.blhud_RenderTypeMelee <= 3 then
				renderer:render(rtex, dtx-w/2, dty, w, h, 1, jb, jb, o, nil)
			elseif optionValues.blhud_RenderTypeMelee == 5 then 
				local os = 50 + 18 * inacc
				local s, sh = os, (os / 2)
				renderer:render(rtex, dtx-sh, dty-sh+32*ts, s, s, 1, jb, jb, o * 0.8, nil)
			elseif optionValues.blhud_RenderTypeMelee == 6 then
				local os = 6 + 1 * inacc
				local s, sh = os, (os / 2)
				renderer:render(rtex, dtx-sh, dty-sh+32*ts, s, s, 1, jb, jb, o * 0.8, nil)
			elseif optionValues.blhud_RenderTypeMelee == 4 then
				drawCrosshairs(dtx, dty + 32*ts, hud.chWidth, hud.chLength, hud.chBaseOffset, hud.chMaxOffset, inacc, 1, jb, jb, o )
			end
		end

		if hud.ranged and optionValues.blhud_EnableAmmoCounter then
			local y = my + 32 * ts
			renderBytes(mx + 30, y + 30, hud.jammed,
				inOutBounce(hud.deltaFactor, 0, 1, 1),
				hud.aimOpacity * (hud.deltaFactor * 100), o * 2)
		end
	end
end

local defaultRecoilDelay = 600
function hud.onSwing(player, weapon)
	if not player or not player:isLocalPlayer() or player:isDead() or not weapon or not weapon:isRanged() then return end
	local index = player:getPlayerNum()
	local hr, tt = hud.recoil[index] or 0, getTimeInMillis()

	if (weapon:getCurrentAmmoCount() <= 0 and not weapon:isRoundChambered()) or weapon:isJammed() then
		hud.recoil[index] = (hr > tt) and hr + 150 or tt + 100
	elseif (player:getVariableString("FireMode") == "Auto") then
		local div = player:getVariableFloat("autoShootVarX", 1)
		local rec = (1 - div)
		rec = rec > 1 and 1 or rec
		hud.recoil[index] = tt + 150 + defaultRecoilDelay * rec
	else
		local wd = weapon:getRecoilDelay()
		hud.recoil[index] = tt + (wd <= 0.001 and 10 or wd) * 30
	end
end

-- the update should be separate
-- also this is a bad code.
function hud.updatePlayer(player)
	if not player or not player:isLocalPlayer() then
		return
	end
	
	if player:isDead() then 
		hud.renderAim = false
		return 
	end

	local weapon = player and player:getPrimaryHandItem() or nil

	if weapon and instanceof(weapon, "HandWeapon") then
		local gm, tm = UIManager.getMillisSinceLastRender(), getTimeInMillis()
		hud.deltaFactor = hud.deltaFactor <= 0 and 0 or hud.deltaFactor - 0.007 * gm

		if weapon:isRanged() then
			hud.ranged = true
			if player:isAiming() then
				hud.renderAim = true

				hud.aimOpacity = hud.aimOpacity >= 1 and 1 or hud.aimOpacity + hud.opacityRate * gm
				local chamber = weapon:isRoundChambered()
				local ammo = weapon:getCurrentAmmoCount()
				if chamber then
					ammo = ammo + 1
				end
				if lastAmmo ~= ammo then
					hud.deltaFactor = 1
					toBytes(tostring(ammo))
				end
				lastAmmo = ammo

				hud.recoilFactor = (hud.recoil[0] or 0) - tm
				hud.recoilFactor = (hud.recoilFactor < 0 and 0 or hud.recoilFactor) / 600

				local vm = weapon:getAimingTime()
				hud.inaccuracyFactor = math.abs(player:getDeferredAngleDelta()) + (player:getVariableFloat("beenmovingfor", 0) - vm) / 70 + hud.recoilFactor
				hud.inaccuracyFactor = hud.inaccuracyFactor > 2 and 2 or hud.inaccuracyFactor
				hud.jammed = weapon:isJammed()
				hud.jammedRender = hud.jammed and 0.6 + math.abs(math.sin(tm / 200)) * 0.2 or 0
				hud.jammedRenderNeg = 1 - hud.jammedRender
			else
				hud.renderAim = false
				hud.aimOpacity = hud.aimOpacity <= 0 and 0 or hud.aimOpacity - hud.opacityRate * gm
			end
		else
			hud.ranged = false
			if hud.jammed then
				hud.jammed = false
				hud.jammedRender = 0
				hud.jammedRenderNeg = 1
			end
			hud.aimOpacity = (hud.aimOpacity and hud.aimOpacity or 0)
			if player:isAiming() then
				hud.renderAim = true
				hud.aimOpacity = hud.aimOpacity >= 1 and 1 or hud.aimOpacity + hud.opacityRate * gm
				hud.inaccuracyFactor = math.abs(player:getDeferredAngleDelta())
				hud.inaccuracyFactor = hud.inaccuracyFactor > 2 and 2 or hud.inaccuracyFactor
			else
				hud.renderAim = false
				hud.aimOpacity = hud.aimOpacity <= 0 and 0 or hud.aimOpacity - hud.opacityRate * gm
			end
		end
	else
		local gm = UIManager.getMillisSinceLastRender()
		hud.ranged = false
		if hud.jammed then
			hud.jammed = false
			hud.jammedRender = 0
			hud.jammedRenderNeg = 1
		end
		
		hud.aimOpacity = (hud.aimOpacity and hud.aimOpacity or 0)

		if player:isAiming() then
			hud.renderAim = true
			hud.aimOpacity = hud.aimOpacity >= 1 and 1 or hud.aimOpacity + hud.opacityRate * gm
			hud.inaccuracyFactor = math.abs(player:getDeferredAngleDelta())
			hud.inaccuracyFactor = hud.inaccuracyFactor > 2 and 2 or hud.inaccuracyFactor
		else
			hud.renderAim = false
			hud.aimOpacity = hud.aimOpacity <= 0 and 0 or hud.aimOpacity - hud.opacityRate * gm
		end
	end
end

if not hud.initHook then
	hud.initHook = true
	Events.OnPlayerUpdate.Add(function(...)
		_G.BLHUD.updatePlayer(...)
	end)
	Events.OnPreUIDraw.Add(function()
		_G.BLHUD.drawCrosshair()
	end)
	Events.OnWeaponSwing.Add(function(...)
		_G.BLHUD.onSwing(...)
	end)
end
