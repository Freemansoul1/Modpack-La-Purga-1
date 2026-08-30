Events.OnGameStart.Add(function()
	local ISInventoryTransferAction_start_origin = ISInventoryTransferAction.start
	function ISInventoryTransferAction:start()
		if self.srcContainer:getType() == "floor" then
			local worldItem = self.item:getWorldItem()
			if not worldItem or (worldItem and self.character:getVehicle()) then --:getSquare()
				self.character:StopAllActionQueue();
    			local queue = ISTimedActionQueue.getTimedActionQueue(self.character);
    			queue:clearQueue();
    			self.character:PlayAnim("Idle")
				return
    		end
    	end
		ISInventoryTransferAction_start_origin(self)
	end
end)