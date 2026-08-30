STAR_MODS = STAR_MODS or {}
STAR_MODS.ReadWalking = STAR_MODS.ReadWalking or {}


SearchModeAPI.Register('read_walking',10)


local READWALK = SandboxVars.ReadWalking
if not READWALK then
	print('ERROR (read while walking): No sandbox file found!')
	READWALK = {
		FogDarkness = 1,
		ReadSpeed = 1,
	}
end


----------- fog ---------------


local function EnableFog(player, mode)
	SearchModeAPI.Lock('read_walking')
	local sm = ISSearchManager.getManager(player)
	local num = player:getPlayerNum()
	SearchModeAPI.Activate('read_walking')
	getSearchMode():setEnabled(num,true)
	--local mode = getSearchMode():getSearchModeForPlayer(num);
	mode:getBlur():setTargets(0.5, 0.5); --0.5
	mode:getDesat():setTargets(0, 0); --0.5
	mode:getRadius():setTargets(6, 6); --3
	mode:getDarkness():setTargets(READWALK.FogDarkness, READWALK.FogDarkness); --0.9
	SearchModeAPI.Deactivate('read_walking')
end

local function DisableFog(player)
	local sm = ISSearchManager.getManager(player)
	if not sm.isSearchMode then
		SearchModeAPI.Activate('read_walking')
		getSearchMode():setEnabled(player:getPlayerNum(),false)
		SearchModeAPI.Deactivate('read_walking')
	end
	SearchModeAPI.Unlock('read_walking')
end


local function lerp(a, b, t)
	return a + (b - a) * t
end

local function SetNewRadius(self)
	local f = self.search_p_stats:getFatigue() -- 0.6 0.7 0.8 0.9
	local r = 6
	if f >= 0.9 then
		r = 2
	elseif f > 0.5 then
		r = lerp(6, 2, (f - 0.5) * 2.5) -- same as / 0.4
	end
	local new_r = math.floor(r*10)
	if new_r ~= self.search_radius then
		self.search_radius = new_r
		r = new_r * 0.1
		SearchModeAPI.Activate('read_walking')
		self.search_mode:getRadius():setTargets(r, r);
		SearchModeAPI.Deactivate('read_walking')
	end
end

Events.OnGameStart.Add(function()

	local old_update = ISReadABook.update
	function ISReadABook:update()
		old_update(self)
		SetNewRadius(self)
	end


	local old_start = ISReadABook.start
	function ISReadABook:start()
		old_start(self);
		self.search_mode = getSearchMode():getSearchModeForPlayer(self.character:getPlayerNum())
		self.search_radius = 60
		self.search_p_stats = self.character:getStats()
		EnableFog(self.character, self.search_mode)
		SetNewRadius(self)
	end

	local old_perform = ISReadABook.perform
	function ISReadABook:perform()
		old_perform(self);
		DisableFog(self.character)
	end


---------- Read while walking-------

	--[[local function GetVanillaBookTime(character, item, time)
		if not (character and item) then --foolproof
			return time or 150
		end
		local numPages, minutesPerPage
		if item:getNumberOfPages() > 0 then
			ISReadABook.checkLevel(character, item)
			item:setAlreadyReadPages(character:getAlreadyReadPages(item:getFullType()))
			local startPage = item:getAlreadyReadPages()
			numPages = item:getNumberOfPages()
		else
			numPages = 5
		end
		if isClient() then
			minutesPerPage = getServerOptions():getFloat("MinutesPerPage") or 1.0
			if minutesPerPage < 0.0 then minutesPerPage = 1.0 end
		else
			minutesPerPage = 2.0
		end
		local f = 1 / getGameTime():getMinutesPerDay() / 2
		time = numPages * minutesPerPage / f

		if(character:HasTrait("FastReader")) then
			time = time * 0.7;
		end
		if(character:HasTrait("SlowReader")) then
			time = time * 1.3;
		end
		return time
	end]]


	local old_fn = ISReadABook.new
	function ISReadABook.new(self, character, item, time, ...)
		--[[local result, maxTime = pcall(GetVanillaBookTime, character, item, time)
		--print('deafult ', maxTime)
		if not result then
			maxTime = 220 * 2 * 60 * 2 -- should be dead code
		end]]
		local o = old_fn(self, character, item, time, ...)
		--print('modded ',o.maxTime)
		o.stopOnWalk = false;
		if o.maxTime ~= 1 then
			o.maxTime = o.maxTime / READWALK.ReadSpeed
		end
		--print('overwritten ',o.maxTime)
		local sm = ISSearchManager.getManager(o.character)
		if sm.isSearchMode then -- stop searching while reading
			sm:toggleSearchMode()
			--o.ignoreAction = true -- need R again
		end
		return o
	end
end)

local function TryStopReading(player)
	local q = ISTimedActionQueue.getTimedActionQueue(player)
	local current = q and q.queue[1]
	if current and current.Type == "ISReadABook" then
		current:forceStop()
		return true -- success
	end
	return false
end

--stop reading if searching is started
Events.onEnableSearchMode.Add(TryStopReading)



----------Save stopped book  -----------
local READ_NOW_ID = nil

local function CheckBookIsNeeded(player, item) --print("Checking ",item:getType(),' ...')
	local num_pages = item:getNumberOfPages()
	if num_pages > 0 then
		local delta = num_pages - player:getAlreadyReadPages(item:getFullType())
		--print(num_pages,' ',player:getAlreadyReadPages(item:getFullType()),' ',delta)
		if delta > 0 then
			return item
		end
	end
	return nil
end

Events.OnGameStart.Add(function()
	local old_stop = ISReadABook.stop
	function ISReadABook:stop()
		old_stop(self);
		local book = CheckBookIsNeeded(self.character, self.item)
		if book then
			READ_NOW_ID = book:getFullType()
		else
			READ_NOW_ID = nil
		end
		DisableFog(self.character)
	end
end)


----------Find a book to read-------------
local PERKS = STAR_MODS.PERKS
if not PERKS then
	PERKS = {}
	for i=0,PerkFactory.PerkList:size()-1 do
		local perk=PerkFactory.PerkList:get(i)
		PERKS[perk:getId()] = perk
	end
	STAR_MODS.PERKS = PERKS
	--player:getPerkLevel(perk?) getType
end


local function getAllContainers(player) --in first, backpacks second, other containers third
	local inv = player:getInventory()
	local containers = {}
	table.insert(containers, player:getInventory())
	for i,v in ipairs(getPlayerInventory(0).inventoryPane.inventoryPage.backpacks) do
		if v.inventory ~= inv then
			table.insert(containers, v.inventory)
		end
	end
	local num_backpacks = #containers
	for i,v in ipairs(getPlayerLoot(0).inventoryPane.inventoryPage.backpacks) do
		table.insert(containers, v.inventory)
	end
	return containers, num_backpacks
end


local function findBookToRead(player) --print("recurse find")
	local found = nil --первая найденная
	local containers, num_good = getAllContainers(player)
	for i,inv in ipairs(containers) do
		if i > num_good and found then
			return found
		end
		local list = inv:getItemsFromCategory("Literature")
		--print("SIZE: ",list:size()," - ",inv)
		for i=0,list:size()-1 do
			local book = list:get(i)
			local data = SkillBook[book:getSkillTrained()]
			local typ = data and data.perk:getId()
			--print(typ, ' ',book:getFullType(),' - ',typ)
			if typ ~= "" then
				local perk = PERKS[typ]
				if perk then --print("perk = ",perk)
					local level = player:getPerkLevel(perk:getType()) --print('level: ', level, ' ',book:getLvlSkillTrained(), ' ',book:getMaxLevelTrained())
					if level >= book:getLvlSkillTrained()-1 and level <= book:getMaxLevelTrained()-1
						and CheckBookIsNeeded(player, book)
					then
						--print('Found: ',book:getType())
						--table.insert(books, book) -- for sorting
						if i <= num_good and book:isFavorite() then
							return book
						end
						found = found or book
					end
				end
			end
		end
	end
	return found
end



------------Bind a key--------------
local key_data = {
  key = Keyboard.KEY_R,  --default
  name = "RESUME_READ",  -- just id (user won't see this name)
}

local function checkReloadableGun(player, gun)
	return ReloadUtil:getReloadableWeapon(gun, player);
end

local function TryResumeReadingBook()
	--if READ_NOW_ID == nil then return end -- no book to resume
	local is_key_R = key_data.key == Keyboard.KEY_R
	local is_building_process = getCell():getDrag(0)
	if is_building_process and is_key_R then return end -- building... "R" should work as rotation
	if ISTimedActionQueue.isPlayerDoingAction(player) then return end -- not in action
	local player = getPlayer()
	if not player then return end -- player not initialized (error?)
	local item = player:getPrimaryHandItem()
	if item and item.isAimedFirearm and item:isAimedFirearm() and is_key_R then -- a gun
		--if checkReloadableGun(player, item) then
		--	return
		--end
		
		--local v = player:getPlayerMoveDir()
		--if v:getX() ~= 0 or v:getY() ~= 0 then return end
		return
	end
	--print('not failed')
	local book
	if READ_NOW_ID then
		book = player:getInventory():FindAndReturn(READ_NOW_ID)
		if book and not CheckBookIsNeeded(player, book) then --print('best is already read')
			book = nil
		end
	end
	if not book then
		book = findBookToRead(player)
	end
	if not book then return end
	ISInventoryPaneContextMenu.readItem(book, 0) --playerNum
	--ISInventoryPaneContextMenu.transferIfNeeded(player, book)
	--ISTimedActionQueue.add(ISReadABook:new(playerObj, item, 150));
end

-- read a book, loot it first if it's not in the player's inventory
ISInventoryPaneContextMenu.readItem = function(item, player)
	local playerObj = getSpecificPlayer(player)
	if item:getContainer() == nil then
		return
	end
	ISInventoryPaneContextMenu.transferIfNeeded(playerObj, item)
	-- read
	ISTimedActionQueue.add(ISReadABook:new(playerObj, item, 150));
end

if ModOptions and ModOptions.getInstance then
	local category = "[Player Control]";
	ModOptions:AddKeyBinding(category, key_data);
end

local function KeyUp(keynum)
	if not MainScreen.instance.inGame then
		return
	end
  if keynum == key_data.key then
		if TryStopReading(getSpecificPlayer(0)) then
			-- do nothing
		else
			TryResumeReadingBook()
		end
  end
end
Events.OnKeyPressed.Add(KeyUp)



---------------- fog when reading ------------------

