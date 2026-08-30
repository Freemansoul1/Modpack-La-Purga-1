local original_ISInventoryTransferAction_isValid = ISInventoryTransferAction.isValid
function ISInventoryTransferAction:isValid()
	--print(self.destContainer:getType())
	--print(self.item:getType())
	--print(self.item:getAttachmentType())
	--print("TYPE:" .. self.item:getType())
	--print("CATEGORY:" .. self.item:getCategory())
	--if self.item:getDisplayCategory() then print("DISPLAY CATEGORY:" .. self.item:getDisplayCategory()) end
	if self.destContainer:getType()=="keycabinet" or self.destContainer:getType()=="keyrack"  then
		if self.item:getDisplayCategory()
		and self.item:getDisplayCategory() ~= "Key" 
		and self.item:getCategory() ~= "Key"
		and self.item:getType() ~= "KeyRing" then
			return false
		end
		if self.item:getCategory() ~= "Key"
		and self.item:getType() ~= "KeyRing" then
			return false
		end
	end

    return original_ISInventoryTransferAction_isValid(self);
    
end