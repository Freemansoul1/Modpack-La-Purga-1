----------- SEARCH MODE API -------------

if not SearchModeAPI then -- version 1.0
	--function TestSM()
	--getSearchMode():getSearchModeForPlayer(0):getBlur()
	local sm = getSearchMode()
	local sm_m = getmetatable(sm).__index
	local sav_setEnabled = nil
	local old_setEnabled = sm_m.setEnabled

	local mode = sm:getSearchModeForPlayer(0)
	local mode_blur = mode:getBlur()

	local SUPPORT_INJECT = { -- player_0
		[mode_blur] = 'getBlur',
		[mode:getDesat()] = 'getDesat',
		[mode:getRadius()] = 'getRadius',
		[mode:getDarkness()] = 'getDarkness',
	}
	local CHECK_FN = {}
	for k,v in pairs(SUPPORT_INJECT) do
		CHECK_FN[v] = k
	end

	local mode_blur_m = getmetatable(mode_blur).__index
	local old_setTargets = mode_blur_m.setTargets


	local DEFAULT_PRIORITY = -100
	local db = {} -- database of all modules
	local db_arr = {} -- the same but in priority order
	local stack = {}
	local priority_now = DEFAULT_PRIORITY
	local rec_now = nil
	local m_idx = {setTargets=function()end}
	local now = os.time
	local function _UpdateSearchMode()
		-- search for the current ruler
		priority_now = DEFAULT_PRIORITY
		local found = nil
		for i,v in ipairs(db_arr) do
			if v.is_locked then
				found = i
				break
			end
		end
		--if not found then -- impossible
		--	found = #db_arr
		--end
		priority_now = db_arr[found].priority
		--print('RULER priority = ',priority_now)
		local resume = {}
		local resume_tm = {}
		local tm0=0
		local val_enabled=nil
		if found then -- always true
			for j=found,1,-1 do
				local v = db_arr[j]
				if v.is_locked then
					if v.enabled_tm >= tm0 then
						tm0 = v.enabled_tm
						val_enabled = v.enabled
					end
					--v.enabled_tm = -1
					for k,tm in pairs(v.cache_tm) do
						if resume_tm[k] == nil or tm >= resume_tm[k] then
							resume_tm[k] = tm
							resume[k] = v.cache[k]
						end
					end
				end
				--table.wipe(v.cache_tm)
			end
		end
		--print('restore')
		if val_enabled then
			old_setEnabled(unpack(val_enabled))
		else
			old_setEnabled(sm, 0, false) -- off by default
			--return
		end
		for k,v in pairs(resume) do
			old_setTargets(unpack(v))
		end
	end
	
	local _active_cache = {}
	SearchModeAPI = { --global
		Debug = function()
			print('priority_now = ',priority_now)
			print('rec_now = ',rec_now and rec_now.name)
			return rec_now
		end,
		old_setEnabled = old_setEnabled,
		old_setTargets = old_setTargets,
		SUPPORT_INJECT = SUPPORT_INJECT,
		CHECK_FN = CHECK_FN,
	
		Register = function(name, priority)
			name = name or 'unknown'
			priority = tonumber(priority) or DEFAULT_PRIORITY
			local data = db[name]
			if not data then
				data = {
					name = name,
					priority = priority,
					is_locked = false,
					enabled = nil,
					enabled_tm = -1,
					--[[blur = nil,
					desat = nil,
					radius = nil,
					darkness = nil,
					blur_tm = nil,
					desat_tm = nil,
					radius_tm = nil,
					darkness_tm = nil,--]]
					cache = {},
					cache_tm = {},
				};
				db[name] = data
				table.insert(db_arr, data)
				table.sort(db_arr, function(a,b) -- the first is highest
					return a.priority > b.priority
				end)
			end
			print('SearchModeAPI: registered a new mod with ID ',name)
			return data
		end,

		Update = _UpdateSearchMode,
		
		Lock = function(name)
			local data = db[name]
			if not data then
				data = SearchModeAPI.Register(name)
			end
			data.is_locked = true
			if priority_now < data.priority then
				priority_now = data.priority --print('LOCK priority_now = ',priority_now)
				_UpdateSearchMode()
			end
		end,
		
		Unlock = function(name)
			local data = db[name]
			if not data then
				data = SearchModeAPI.Register(name)
			end
			data.is_locked = false
			if priority_now > data.priority then
				return
			end
			-- search for the current ruler
			_UpdateSearchMode()
		end,
		
		Activate = function(name)
			if not name or _active_cache[name] then
				return
			end
			table.insert(stack, db[name])
			rec_now = stack[#stack]
			_active_cache[name] = true
		end,
		
		Deactivate = function(name)
			for i=#stack,2,-1 do
				if stack[i].name == name then
					table.remove(stack, i)
					rec_now = stack[#stack]
					break
				end
			end
			if name then
				_active_cache[name] = false
			end
		end,
		
		stack = stack,
		db = db,
		db_arr = db_arr,
		
		getInstance = function(name) -- for syntax sugar
			if not name then
				return print('SearchModeAPI ERROR: getInstance(nil)')
			end
			name = tostring(name)
			local t = {}
			--setmetatable(t, SearchModeAPI)
			return {
				Register = function(priority) SearchModeAPI.Register(name, priority) end,
				Lock = function() SearchModeAPI.Lock(name) end,
				Unlock = function() SearchModeAPI.Unlock(name) end,
				Activate = function() SearchModeAPI.Activate(name) end,
				Deactivate = function() SearchModeAPI.Deactivate(name) end,
			}
		end,
	}
	--SearchModeAPI.__index = SearchModeAPI
	
	SearchModeAPI.Register('unknown')
	SearchModeAPI.Activate('unknown')
	SearchModeAPI.Lock('unknown') -- forever
	
	sm_m.setEnabled = function(self, ...)
		rec_now.enabled = {self, ...}
		rec_now.enabled_tm = now()
		if rec_now.priority >= priority_now then --print('enabled passed')
			return old_setEnabled(self, ...)
		end
	end

	mode_blur_m.setTargets = function(blur, ...)
		rec_now.cache[blur] = {blur, ...}
		rec_now.cache_tm[blur] = now()
		if not SUPPORT_INJECT[blur] or rec_now.priority >= priority_now then --print('blur passed')
			return old_setTargets(blur, ...)
		end
	end
	

end

