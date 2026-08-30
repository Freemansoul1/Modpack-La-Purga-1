function CTags:contextFunction(player, context, worldobjects, test)
	local player = getPlayer();
	local playerNumber = player:getPlayerNum();
	local psquare = player:getSquare();
	local tagData = ModData.getOrCreate("ContainerTagData");
	if not tagData.tags then tagData.tags = {} end;
	-- local containers = {};

	-- Not in vehicle
	if player:getVehicle() then return end
	if CTags.mode == 0 then return end

	for i, v in ipairs(worldobjects) do
		-- Limit search
		if i >= 25 then break end
		local spriteName = v:getSprite():getName();
		local square = v:getSquare();
		local container = v:getContainer();

		if container then
			local squareID = "" .. square:getX() .. "." .. square:getY() .. "." .. square:getZ();
			thisContext = context:addOptionOnTop(getText("ContextMenu_SetContainerTag"), v, function()
				local x = isoToScreenX(playerNumber, square:getX(), square:getY(), square:getZ());
				local y = isoToScreenY(playerNumber, square:getX(), square:getY(), square:getZ());					
				CTagsUI.makeWindow(x + 10, y + 10, square, squareID)
			end);
			thisContext.iconTexture = getTexture("media/textures/note.png");

			break
		end
	end	
end 
