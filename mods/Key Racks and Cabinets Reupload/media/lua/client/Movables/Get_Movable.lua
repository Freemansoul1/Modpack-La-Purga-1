require "Movables/ISMoveableSpriteProps"

-- local old_ISMoveableSpriteProps_canPickUpMoveable = ISMoveableSpriteProps.canPickUpMoveable

-- function ISMoveableSpriteProps:canPickUpMoveable( _character, _square, _object )
	-- local name = _object:getSprite():getName()
	-- if name:contains("WindowBars") then
		-- return false
	-- end
	
	
	-- if name and (ame:contains("keyrack") or name:contains("keycabinet")) then
		-- --print("false!!!")
		-- return false
	-- end
	
	-- print(tostring(_object:getSprite():getName()))
	-- old_ISMoveableSpriteProps_canPickUpMoveable ( self, _character, _square, _object )

-- end
local old_ISMoveableSpriteProps_canPickUpMoveable = ISMoveableSpriteProps.canPickUpMoveable

function ISMoveableSpriteProps:canPickUpMoveable( _character, _square, _object )
    --print("MultiSprite movable CanPickUp test")
	local name = nil
	if _object and _object:getSprite() and _object:getSprite():getName() then
		name = _object:getSprite():getName()
	end
	--print("NAME: " .. tostring(name))
	if name and (name:contains("WindowBars")) then
		--print("false!!!")
		return false
	end
	local safehouse = SafeHouse.getSafeHouse(_square)
	if name and safehouse and (name:contains("keyrack") or name:contains("keycabinet")) then
		--print("false!!!")
		return false
	end
	return old_ISMoveableSpriteProps_canPickUpMoveable(self, _character, _square, _object )
	-- if ISMoveableDefinitions.cheat then
		-- self.yOffsetCursor = _object and _object:getRenderYOffset() or 0;
		-- return true;
	-- end
    -- if self.isMoveable and self.isMultiSprite then
        -- local sgrid = self:getSpriteGridInfo(_square, true);
        -- if not sgrid then return false; end
        -- --print("take 2")
        -- for _,gridMember in ipairs(sgrid) do
            -- if not self:canPickUpMoveableInternal( _character, gridMember.square, not gridMember.sprInstance and gridMember.object or nil, true ) then
                -- return false;
            -- end
        -- end
        -- --print("returning true")
        -- return true;
    -- else
        -- return self:canPickUpMoveableInternal( _character, _square, _object, false );
    -- end
end


-- function ISMoveableSpriteProps:canPickUpMoveable( _character, _square, _object )
    -- --print("MultiSprite movable CanPickUp test")
	-- if ISMoveableDefinitions.cheat then
		-- self.yOffsetCursor = _object and _object:getRenderYOffset() or 0;
		-- return true;
	-- end
    -- if self.isMoveable and self.isMultiSprite then
        -- local sgrid = self:getSpriteGridInfo(_square, true);
        -- if not sgrid then return false; end
        -- --print("take 2")
        -- for _,gridMember in ipairs(sgrid) do
            -- if not self:canPickUpMoveableInternal( _character, gridMember.square, not gridMember.sprInstance and gridMember.object or nil, true ) then
                -- return false;
            -- end
        -- end
        -- --print("returning true")
        -- return true;
    -- else
        -- return self:canPickUpMoveableInternal( _character, _square, _object, false );
    -- end
-- end