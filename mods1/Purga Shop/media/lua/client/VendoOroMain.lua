require "ISUI/ISWorldObjectContextMenu"

function VendoOro(player, context, worldobjects, test)

	if test and ISWorldObjectContextMenu.Test then return true end
	
	if getCore():getGameMode()=="LastStand" then
		return;
	end
	
	if test then return ISWorldObjectContextMenu.setTest() end

	scavengeZone = nil;
	local playerObj = getSpecificPlayer(player)
	local x1 = getPlayer():getX();
	local y1 = getPlayer():getY();
	local z1 = getPlayer():getZ();
	
	if playerObj:getVehicle() then return; end

	local ATMVendoOro

	local archive

	for i, v in ipairs(worldobjects) do
		
		if v:getSprite():getName() == nil then return; end
		local spriteName = v:getSprite():getName()
		x = v:getX();
		y = v:getY();
		if spriteName == "purga_01_0"
		then
			ATMVendoOro = v;
		end
	end

    if ATMVendoOro and getPlayer():DistToSquared(x, y) <= 6 then
		local option_ATMVendoOro_exchange = context:addOption(getText("ContextMenu_ATMVendoOroExchange"), worldobjects, nil)
		local subMenu = ISContextMenu:getNew(context);
		context:addSubMenu(option_ATMVendoOro_exchange, subMenu);

        --1 x 1
		local option_ATMVendoOro_exchange1 = subMenu:addOption(getText("ContextMenu_ATMVendoOroExchange1"), worldobjects, ATMVendoOroExchange1, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_ATMVendoOro_exchange1.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_ATMVendoOroExchange1"));
		toolTip:setTexture("purga_01_0");
		toolTip.description = getText("Tooltip_ATMVendoOroExchange1");
		if not (getPlayer():getInventory():contains("IngotSilver") and getPlayer():getInventory():getItemCount("IngotSilver") >= 1) then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_ATMVendoOroNotEnoughRes");
			option_ATMVendoOro_exchange1.notAvailable = true;
		end

        -- 5 x 5
		local option_ATMVendoOro_exchange1 = subMenu:addOption(getText("ContextMenu_ATMVendoOroExchange2"), worldobjects, ATMVendoOroExchange2, player)
		local toolTip = ISToolTip:new();
		toolTip:initialise();
		toolTip:setVisible(false);
		option_ATMVendoOro_exchange1.toolTip = toolTip;
		toolTip:setName(getText("ContextMenu_ATMVendoOroExchange2"));
		toolTip:setTexture("purga_01_0");
		toolTip.description = getText("Tooltip_ATMVendoOroExchange2");
		if not (getPlayer():getInventory():contains("IngotSilver") and getPlayer():getInventory():getItemCount("IngotSilver") >= 5) then
			toolTip.description = toolTip.description .. "\n <RGB:1,0,0>" .. getText("Tooltip_ATMVendoOroNotEnoughRes");
			option_ATMVendoOro_exchange1.notAvailable = true;
		end
    end
end


ATMVendoOroExchange1 = function()
	
	getPlayer():getInventory():Remove("IngotSilver");
	getPlayer():getInventory():AddItem("NHM.IngotGold")
    local soundEmitter = getWorld():getFreeEmitter(x, y, 0)
    soundEmitter:playSound("goldingots", x, y, 0)

end

ATMVendoOroExchange2 = function()
	
	getPlayer():getInventory():Remove("IngotSilver");
    getPlayer():getInventory():Remove("IngotSilver");
    getPlayer():getInventory():Remove("IngotSilver");
    getPlayer():getInventory():Remove("IngotSilver");
    getPlayer():getInventory():Remove("IngotSilver");
	getPlayer():getInventory():AddItem("NHM.IngotGold");
    getPlayer():getInventory():AddItem("NHM.IngotGold");
    getPlayer():getInventory():AddItem("NHM.IngotGold");
    getPlayer():getInventory():AddItem("NHM.IngotGold");
    getPlayer():getInventory():AddItem("NHM.IngotGold");
    local soundEmitter = getWorld():getFreeEmitter(x, y, 0)
    soundEmitter:playSound("goldingots", x, y, 0)

end

Events.OnFillWorldObjectContextMenu.Add(VendoOro);