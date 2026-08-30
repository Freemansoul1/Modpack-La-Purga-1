local CAMmod = CAMmod or {}
CAMmod.bodiesList = {}
CAMmod.bodiesFail = 0
local maxFail = 3
local maxCorpses = SandboxVars.CAMmod.maximumCorpsePile 
Events.OnGameStart.Add(function() maxCorpses = SandboxVars.CAMmod.maximumCorpsePile end)
--------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------
local ISWalkToTimedAction_update = ISWalkToTimedAction.update
function ISWalkToTimedAction:update()
	if CAMmod.started then
		if instanceof(self.character, "IsoPlayer") and
            (self.character:pressedMovement(false) or self.character:pressedCancelAction()) then
        	self:forceStop()
        	return
    	end
    	self.result = self.character:getPathFindBehavior2():update();

    	if self.result == BehaviorResult.Failed then
    		if #CAMmod.bodiesList > 0 then
    			local corpseHands = self.character:getInventory():contains("CorpseMale") or self.character:getInventory():contains("CorpseFemale")
    			if CAMmod.started then
    				if corpseHands then
    					CAMmod.bodiesList[1].toAttempt = CAMmod.bodiesList[1].toAttempt+1
    				else
    					CAMmod.bodiesList[1].fromAttempt = CAMmod.bodiesList[1].fromAttempt+1
    				end
    			end
    			if CAMmod.bodiesList[1].toAttempt >= maxFail or CAMmod.bodiesList[1].fromAttempt >= maxFail then
					table.remove(CAMmod.bodiesList,1)
					CAMmod.bodiesFail = CAMmod.bodiesFail+1
				end
			end
    	    self:forceStop();
    	    return;
    	end
    	if self.additionalTest ~= nil then
    	   if self.additionalTest(self.additionalContext) then
				self:forceComplete();
    	        return
    	   end
    	end
    	if self.result == BehaviorResult.Succeeded then
    	    self:forceComplete();
    	end
	else
		ISWalkToTimedAction_update(self)
	end
end
--------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------
function CAMmod.getHighlightedAreaRender(ui)
	if ui.selectStart then
	    local xx, yy = ISCoordConversion.ToWorld(getMouseXScaled(), getMouseYScaled(), ui.zPos)
	    local sq = getCell():getGridSquare(math.floor(xx), math.floor(yy), ui.zPos)
	    if sq and sq:getFloor() then sq:getFloor():setHighlighted(true);sq:getFloor():setHighlightColor(0.7,0.6,0.0,0.5) end
	elseif ui.selectEnd then
	    local xx, yy = ISCoordConversion.ToWorld(getMouseXScaled(), getMouseYScaled(), ui.zPos)
	    xx = math.floor(xx)
	    yy = math.floor(yy)
	    local cell = getCell()
	    local x1 = math.min(xx, ui.startPos.x)
	    local x2 = math.max(xx, ui.startPos.x)
	    local y1 = math.min(yy, ui.startPos.y)
	    local y2 = math.max(yy, ui.startPos.y)
	
	    for x = x1, x2 do
	        for y = y1, y2 do
	            local sq = cell:getGridSquare(x, y, ui.zPos)
	            if sq and sq:getFloor() then sq:getFloor():setHighlighted(true);sq:getFloor():setHighlightColor(0.6,0.5,0.0,0.2) end --not sq:isHighlighted()
	        end
	    end
	elseif ui.startPos ~= nil and ui.endPos ~= nil then
	    local cell = getCell()
	    local x1 = math.min(ui.startPos.x, ui.endPos.x)
	    local x2 = math.max(ui.startPos.x, ui.endPos.x)
	    local y1 = math.min(ui.startPos.y, ui.endPos.y)
	    local y2 = math.max(ui.startPos.y, ui.endPos.y)
	    for x = x1, x2 do
	        for y = y1, y2 do
	            local sq = cell:getGridSquare(x, y, ui.zPos)
	            if sq and sq:getFloor() then  sq:getFloor():setHighlighted(true,false);sq:getFloor():setHighlightColor(0.5,0.4,0.0,0.2) end --setOutlineHighlight(true)
	        end
	    end
	end
end
function CAMmod.removeArea(startPos,endPos,zPos)
	local cell = getCell()
	local x1 = math.min(startPos.x,endPos.x)
	local x2 = math.max(startPos.x,endPos.x)
	local y1 = math.min(startPos.y,endPos.y)
	local y2 = math.max(startPos.y,endPos.y)
	for x = x1, x2 do
	    for y = y1, y2 do
	        local sq = cell:getGridSquare(x,y,zPos)
	        if sq and sq:getFloor() then sq:getFloor():setHighlighted(false) end --setOutlineHighlight(true)
	    end
	end
end
function CAMmod.getWayInList(player)
	if #CAMmod.bodiesList > 1 then
		for _,v in ipairs(CAMmod.bodiesList)do
			if v.to then return v.to end
		end
	end
end
function CAMmod.initializeList(list)
	if #list > 0 then
		for i,v in ipairs(list)do
			if v.to == v.from then table.remove(list,i) end
		end
	end
	return list
end
function CAMmod.isSelectedSquare(square)
	for _,v in ipairs(CAMmod.bodiesList)do
		if v.from == square then return v.from end
	end
end
function CAMmod.removeList()
	CAMmod.bodiesList = {}
end
function CAMmod.isAllreadySaved(square)
	for i,v in ipairs(CAMmod.bodiesList)do
		if v.from == square then return true end
	end
end
function CAMmod.sortListByDistanceFromCorpse(player,list)
	local sortedList = {} 
	if #list > 0 then
		local refSquare = player:getSquare()
		for i=1,#list do
			table.sort(list, function(a, b)
				return a.from:getZ() <= b.from:getZ() and refSquare:DistToProper(a.from)<=refSquare:DistToProper(b.from)
			end);
			if list[1].from then 
				refSquare = list[1].from
				table.insert(sortedList,list[1])
			end
			table.remove(list,1)
		end
	end
	return sortedList
end
function CAMmod.sortListByDistanceFromPlayer(player,list)
	local refSquare = player:getSquare()
	table.sort(list, function(a, b)
		return a.from:getZ() <= b.from:getZ() and refSquare:DistToProper(a.from)<=refSquare:DistToProper(b.from)
	end);
	return list
end
function CAMmod.sortListByDistanceFromRef(square,listedSquare)
	table.sort(listedSquare, function(a, b)
		return a:getZ() <= b:getZ() and square:DistToProper(a)<=square:DistToProper(b)
	end)
	return listedSquare
end
function CAMmod.isItemCorpse(item)
    return item:getType() == "CorpseMale" or item:getType() == "CorpseFemale";
end
function CAMmod.isNotBlocked(square,player)
	return square and not square:Is(IsoFlagType.burning) and not square:getVehicleContainer() --and not square:isBlockedTo(player:getSquare()) --and not square:isSomethingTo(player:getSquare()) --not square:isBlockedTo(player:getSquare()) --<< last added
						and not square:Is(IsoFlagType.water) and not square:Is(IsoFlagType.solidtrans) and not square:Is(IsoFlagType.solid) --<< last added
											
end
--------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------
function CAMmod.getCleanSurface(ui)
	CAMmod.bodiesFail = 0
	local list = CAMmod.bodiesList
	if ui.cursorType == "zone" or ui.cursorType == "place" then
		local radius = ui:getRadius("zone")
		local floor = ui:getFloor()
		local bodies = CAMmod.getCorpsesByRadius(ui.chr,ui.zoneX,ui.zoneY,ui.zoneZ,radius,floor)
		local toSquare = getSquare(ui.placeX,ui.placeY,ui.placeZ)
		for i,bodie in ipairs(bodies)do
			local fromSquare = bodie:getSquare()
			local allReady
			for _,v in ipairs(list)do
				if v.from and v.from == fromSquare then 
					list[_].to = toSquare
					list[_].type = "zone"  
					allReady = true 
					break 
				end
			end
			if not allReady then table.insert(list,{from = fromSquare,to = toSquare,type = "zone"}) end
		end
		list = CAMmod.sortListByDistanceFromPlayer(ui.chr,list)--floor
	elseif  ui.cursorType == "area" then
		if ui.startPos and ui.endPos then
			local bodies = CAMmod.getCorpsesByArea(ui.chr,ui.startPos,ui.endPos)
			if #bodies <= 0 then ui:removeArea() return end
        	for i,bodie in ipairs(bodies)do
        		local fromSquare = bodie:getSquare()
        		local toSquare = CAMmod.getOutArea(ui.chr,ui.startPos,ui.endPos,fromSquare)
        		local allReady
				for _,v in ipairs(list)do
					if v.from and v.from == fromSquare then 
						list[_].to = ToSquare
						list[_].type = "area" 
						allReady = true 
						break 
					end
				end
				if not allReady then table.insert(list,{from = fromSquare,to = toSquare,type = "area"}) end
			end
			list = CAMmod.sortListByDistanceFromCorpse(ui.chr,list)
		end
	end
	if #list > 0 then 
		list[1].fromAttempt = 0
		list[1].toAttempt = 0
	end
	ISTimedActionQueue.clear(ui.chr) -->> last added
	CAMmod.bodiesList = list
end
local counter = 10
function CAMmod.getUpdate(player)
	if CAMmod.started and instanceof(player, "IsoPlayer") and (player:pressedMovement(false) or player:pressedCancelAction()) then
		CAMmod.started = nil
		if #CAMmod.bodiesList > 0 then
			CAMmod.bodiesList[1].toAttempt = 0
			CAMmod.bodiesList[1].fromAttempt = 0
		end
    end
	local actionQueue = ISTimedActionQueue.getTimedActionQueue(player)
	local currentAction = actionQueue.queue[1]
	if CAMmod.started and not currentAction then
		CAMmod.action(player)
	elseif currentAction and counter <= 0 then
		CAMmod.checkDestination(player)
		counter = 10
	end
	
    counter = counter -1
end
function CAMmod.checkDestination(player)
	if #CAMmod.bodiesList > 0 then
		local fromSquare = CAMmod.bodiesList[1].from
		local toSquare = CAMmod.bodiesList[1].to
		local corpseHands = player:getInventory():contains("CorpseMale") or player:getInventory():contains("CorpseFemale")
		if not corpseHands and not CAMmod.isCorpsesOnSquare(fromSquare,player) then
			ISTimedActionQueue.clear(player) 
			return
		end
	end	
end
function CAMmod.getActionType(square)
	--local bodies = CAMmod.isCorpsesOnSquare(square,player)
	local bodies = CAMmod.getCountOnSquare(square)
	local list = CAMmod.bodiesList
	local actionType
	local color = {r=0.2,g=0.2,b=0.2,o=0.3}
	local isKeyDown = isKeyDown(Keyboard.KEY_X)--isKeyDown(42)
	if not isKeyDown and #list > 0 and list[#list].from and not list[#list].to then
		actionType = "placeTo"
		color = {r=0.8,g=0.5,b=0}
	elseif isKeyDown and #list > 0 and list[#list].to then --and list[#list].from
		actionType = "placeTo"
		color = {r=0.8,g=0.5,b=0}
		 
	elseif #list == 0 and bodies <= 0 then
		actionType = "moveTo"
		--ISTimedActionQueue.clear(player) 
	elseif bodies > 0 and not CAMmod.isAllreadySaved(square) then
		actionType = "getFrom"
		if bodies >= maxCorpses then
			color = {r=0,g=0.8,b=0.1,o=0.8}
		else
			color = {r=0.5,g=0.5,b=0.5,o=0.8}
		end
	end
	return actionType, color
end
function CAMmod.setMoveAction(player,square,actionType)
	local list = CAMmod.bodiesList or {}
	local action = "move"
	CAMmod.started = true
	if actionType == "getFrom"  then
		table.insert(list,{from = square,type = action})
	elseif actionType == "placeTo"  then 
		if player:isPlayerMoving() then ISTimedActionQueue.clear(player) end
		list[#list].to = square
		list[#list].type = action
	elseif actionType == "moveTo" then
		if player:isPlayerMoving() then ISTimedActionQueue.clear(player) end
		list[1] = {to = square, type = action}
	end
	CAMmod.bodiesList = list
end
--------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------
function CAMmod.CheckCorpsesOnFromSquare(player,fromSquare,toSquare)
	if not CAMmod.isCorpsesOnSquare(fromSquare,player) or fromSquare == toSquare then return nil
	else return fromSquare end
end
function CAMmod.action(player)
	local list = CAMmod.bodiesList
	if not list then return end 
	if #list > 0 then
		list[1].fromAttempt = list[1].fromAttempt or 0
		list[1].toAttempt = list[1].toAttempt or 0
		local playerSq = player:getCurrentSquare()
		local fromSquare = list[1].from
		local toSquare = list[1].to or CAMmod.getWayInList(player)
		local destType = list[1].type
		local corpseInv = player:getInventory():getFirstEvalRecurse(CAMmod.isItemCorpse)
		local justWalk = not corpseInv and not fromSquare
		
		if (corpseInv or justWalk) and toSquare then			
			toSquare,list = CAMmod.getGoodSquareIfNeed(player,toSquare,"toAdj",list)
			list[1].from = CAMmod.CheckCorpsesOnFromSquare(player,fromSquare,toSquare)
			if toSquare and playerSq ~= toSquare then	-->> last added			
				ISTimedActionQueue.add(ISWalkToTimedAction:new(player, toSquare))
				--print("action toSquare ISWalkToTimedAction")
			end
			if toSquare and corpseInv then 	
				CAMmod.unequipCorspe(player)
			else 
				--print("action toSquare remove")
				table.remove(list,1) 
			end 
		elseif toSquare == fromSquare then
			--print("action remove")
			if corpseInv then 
				CAMmod.unequipCorspe(player) 
			end
			table.remove(list,1)
		elseif not corpseInv and fromSquare then 
			local corpses = CAMmod.getCorpsesOnSquare(fromSquare,player)
   			if #corpses > 0 and (destType ~= "zone" or #corpses < maxCorpses) and fromSquare ~= toSquare then
				if list[1].fromAdj then
					if #list[1].fromAdj > 0 then
						--print("action fromSquare ISGrabCorpseAction fromAdj "..#list[1].fromAdj)
						if not AdjacentFreeTileFinder.isTileOrAdjacent(playerSq, list[1].fromAdj[1]) then -->> last added playerSq ~= list[1].fromAdj[1] and 
							ISTimedActionQueue.add(ISWalkToTimedAction:new(player, list[1].fromAdj[1]))
						end
						--print("action fromSquare ISGrabCorpseAction")
						ISTimedActionQueue.add(ISGrabCorpseAction:new(player, corpses[1], 50))
						if list[1].fromAttempt > 0 then list[1].fromAttempt = 0 ; table.remove(list[1].fromAdj,1) end --print("action fromSquare ISGrabCorpseAction fromAttempt > 0") ; 
					else
						table.remove(list,1)
						CAMmod.bodiesFail = CAMmod.bodiesFail+1
					end
				else
					--print("action fromSquare onGrabCorpseItem")
					list = CAMmod.onGrabCorpseItem(corpses[1], player:getPlayerNum(),list);
				end
			else
				if corpseInv and not toSquare then 
					CAMmod.unequipCorspe(player) 
				end
				table.remove(list,1)
				--print("action fromSquare remove")
			end	
		else			
			CAMmod.UI:stopAction()
		end
		if #list > 0 then
			local remove = false
			if list[1].fromAttempt and list[1].fromAttempt >= maxFail then
				remove = true
				--print("stop and remove fromAttempt")
			end
			if list[1].toAttempt and list[1].toAttempt >= maxFail then
				remove = true
				--print("stop and remove toAttempt")
			end
			if remove then 
				table.remove(list,1) 
				CAMmod.bodiesFail = CAMmod.bodiesFail+1
			end
		end
    end
    CAMmod.bodiesList = list
end
--------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------
CAMmod.onGrabCorpseItem = function(WItem, player, list)
	local playerObj = getSpecificPlayer(player)
	local WItemSquare = WItem:getSquare()
	local WItemSquare,list = CAMmod.getGoodSquareIfNeed(playerObj,WItemSquare,"fromAdj",list)
	if WItemSquare and luautils.walkAdj(playerObj, WItemSquare) then
		if playerObj:getPrimaryHandItem() then
			ISTimedActionQueue.add(ISUnequipAction:new(playerObj, playerObj:getPrimaryHandItem(), 50));
		end
		if playerObj:getSecondaryHandItem() and playerObj:getSecondaryHandItem() ~= playerObj:getPrimaryHandItem() then
			ISTimedActionQueue.add(ISUnequipAction:new(playerObj, playerObj:getSecondaryHandItem(), 50));
		end
		ISTimedActionQueue.add(ISGrabCorpseAction:new(playerObj, WItem, 50))
	else
		--print("onGrabCorpseItem list[1].fromAttempt+1")
		list[1].fromAttempt = list[1].fromAttempt+1
	end
	return list
end
function CAMmod.unequipCorspe(player)			-->> last added																	
	if not player:getPrimaryHandItem() then
		local corpse = player:getInventory():getFirstEvalRecurse(CAMmod.isItemCorpse);
		ISWorldObjectContextMenu.equip(player, player:getPrimaryHandItem(), corpse, true, true);
	else
		ISTimedActionQueue.add(ISUnequipAction:new(player, player:getPrimaryHandItem(), 50)) 
	end
end
--------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------
function CAMmod.getGoodSquareIfNeed(player,square,dest,list)
	if not square then return end
	if dest == "toAdj" then
		if list[1].toAdj then
			if #list[1].toAdj > 0 then
				if list[1].toAttempt > 0 then 
					list[1].toAttempt = 0
					table.remove(list[1].toAdj,1) 
				end
				square = list[1].toAdj[1]
				for i,v in ipairs(list)do
					if v.to and v.to == square then list[i].to = square end
				end
			else
				square = nil
			end
			return square,list
		elseif CAMmod.getCountOnSquare(square) < maxCorpses and CAMmod.isNotBlocked(square,player) then 
			--print("getGoodSquareIfNeed toAttempt < 1") 
			return square,list  
		end
	elseif dest == "fromAdj" then
		if list[1].fromAttempt < 1 then 
			--print("getGoodSquareIfNeed fromAttempt < 1")  
			return square,list 
		end
	end
	local adjacent
	local allowed = true-- (not player:getCurrentSquare():getRoom() and not square:getRoom()) --or not player:getCurrentSquare():isBlockedTo(square) print(tostring(getPlayer():getSquare():getRoom()))
	if allowed then
		local listedSquares = CAMmod.getNotBlockedSquaresByRadius(player,square,dest) --
		if #listedSquares > 0 then
			--print("getGoodSquareIfNeed adjacent "..dest)
			list[1][dest] = listedSquares
		 	adjacent = list[1][dest][1]
		 	if dest == "fromAdj" then
		 		list[1].fromAttempt = 0
		 	elseif dest == "toAdj" then
		 		list[1].toAttempt = 0
		 	end
		end
	else
		list[1].fromAttempt = maxFail
		list[1].toAttempt = maxFail
	end
	return adjacent, list
end
function CAMmod.getNotBlockedSquaresByRadius(player,square,dest)
	local room = square:getRoom()
	local x,y,z = square:getX(),square:getY(),square:getZ()
	local cell = getCell()
	local listedSquares = {}
	local area = CAMmod.getArea()
	for xx = x-4, x+4 do
        for yy = y-4, y+4 do
        	local sq = cell:getGridSquare(xx,yy,z)
        	if CAMmod.isNotBlocked(sq,player) and sq:getRoom() == room  then
        		local test = dest == "fromAdj" or (dest == "toAdj" and CAMmod.getCountOnSquare(sq) < maxCorpses and CAMmod.getGoodSquareForArea(sq,area))      		
        		if test then
        			table.insert(listedSquares,sq) 
        		end
        	end
        end
    end    
    return CAMmod.sortListByDistanceFromRef(square,listedSquares)
end
function CAMmod.getGoodSquareForArea(sq,area) 
    if not area then return true end
	--print("getGoodSquareForArea area")
	if #area > 0 then
		local x,y,z = sq:getX(),sq:getY(),sq:getZ()
		local x1 = area[1]
    	local x2 = area[2]
    	local y1 = area[3]
    	local y2 = area[4]
    	if (x < x1 or x > x2) or (y < y1 or y > y2) then return true end
    end
end
function  CAMmod.getArea()
	local area
	if CAMmod.bodiesList[1].type == "area" then 
		local startPos = CAMmod.startPos
		local endPos = CAMmod.endPos
		--print("getArea area")
		area = {}
		if startPos and endPos then
			local x1 = math.min(startPos.x, endPos.x)
    		local x2 = math.max(startPos.x, endPos.x)
    		local y1 = math.min(startPos.y, endPos.y)
    		local y2 = math.max(startPos.y, endPos.y)
    		area = {x1,x2,y1,y2}
		end
	end
	return area
end
--------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------
function CAMmod.getCountOnSquare(square)
	local count = 0
	for i=0, square:getStaticMovingObjects():size()-1 do
		local obj = square:getStaticMovingObjects():get(i)
		if instanceof(obj, "IsoDeadBody") then
			count = count+1
		end
	end
	return count
end
function CAMmod.isCorpsesOnSquare(square,player)
	if square and square:getStaticMovingObjects() then
		for i=0, square:getStaticMovingObjects():size()-1 do
			local obj = square:getStaticMovingObjects():get(i)
			if instanceof(obj, "IsoDeadBody") then
				return true
			end
		end
	end
	return false
end
function CAMmod.getCorpsesOnSquare(square,player)
	local bodies = {}
	if square then
		if square:getStaticMovingObjects() then
			for i=0, square:getStaticMovingObjects():size()-1 do
				local obj = square:getStaticMovingObjects():get(i)
				if instanceof(obj, "IsoDeadBody") then
					table.insert(bodies, obj)
				end
			end
		end
	end
	return bodies
end
function CAMmod.getCorpsesByArea(player,startPos,endPos)
	local cell = getCell()
	local x1 = math.min(startPos.x, endPos.x)
    local x2 = math.max(startPos.x, endPos.x)
    local y1 = math.min(startPos.y, endPos.y)
    local y2 = math.max(startPos.y, endPos.y)
	local z = player:getZ()
	local bodies = {}
	for x = x1,x2 do
        for y = y1,y2 do
			local sq = cell:getGridSquare(x,y,z)
			if sq and sq:getStaticMovingObjects() then
				for i=0, sq:getStaticMovingObjects():size()-1 do
					if instanceof(sq:getStaticMovingObjects():get(i), "IsoDeadBody") then
						table.insert(bodies, sq:getStaticMovingObjects():get(i))
						break
					end
				end
			end
		end
	end
	return bodies
end
function CAMmod.getOutArea(player,startPos,endPos,fromSquare)
	local cell = getCell()
	local x1 = math.min(startPos.x, endPos.x)
    local x2 = math.max(startPos.x, endPos.x)
    local y1 = math.min(startPos.y, endPos.y)
    local y2 = math.max(startPos.y, endPos.y)
	local z = player:getZ()
	local square
	for x = x1-1,x2+1 do
        for y = y1-1,y2+1 do
			if (x < x1 or x > x2) or (y < y1 or y > y2) then
				local sq = cell:getGridSquare(x,y,z)
				if sq then
					local dist = sq:DistToProper(fromSquare) -- IsoUtils.DistanceTo(x,y, fromSquare:getX(), fromSquare:getY())
					if not square or dist < square:DistToProper(fromSquare) then--IsoUtils.DistanceTo(square:getX(),square:getY(),fromSquare:getX(),fromSquare:getY()) then
						square = sq
					end
				end
			end
		end
	end
	return square
end
function CAMmod.getCorpsesByRadius(player,selectX,selectY,selectZ,radius,floor)
	local cell = getCell()
	local minX,maxX = selectX-radius,selectX+radius
	local minY,maxY = selectY-radius,selectY+radius
	local minZ,maxZ = selectZ-floor,selectZ+floor
	local bodies = {}
	for x = minX,maxX do
		for y = minY,maxY do
			for z = minZ,maxZ do
				local sq = cell:getGridSquare(x,y,z)
				if sq and sq:getStaticMovingObjects() then
					for i=0, sq:getStaticMovingObjects():size()-1 do
						if instanceof(sq:getStaticMovingObjects():get(i), "IsoDeadBody") and CAMmod.getCountOnSquare(sq) < maxCorpses then
							table.insert(bodies, sq:getStaticMovingObjects():get(i))
							break
						end
					end
				end
			end
		end
	end
	return bodies
end

return CAMmod