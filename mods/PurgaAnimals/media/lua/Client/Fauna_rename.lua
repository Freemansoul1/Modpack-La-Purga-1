require "ISUI/ISInventoryPaneContextMenu"

local contextFN = {}

function contextFN.addRenameContext(player, context, items)
	for _, v in ipairs(items) do

		local item = v
		if not instanceof(v, "InventoryItem") then
			item = v.items[1]
		end

		if item:getDisplayCategory() == "Fauna" then

			local addOption = true
			if addOption==true then
				context:addOption(getText("IGUI_Rename"), item, contextFN.onRenameFauna, player)
				break
			end
		end
	end
end



function contextFN.onRenameFauna(Fauna, player)
	local modal = ISTextBox:new(0, 0, 280, 100, Fauna:getDisplayName()..":", Fauna:getName(), nil, contextFN.onRenameFaunaClick, player, getSpecificPlayer(player), Fauna)
	modal:initialise()
	modal:addToUIManager()
end



function contextFN:onRenameFaunaClick(button, player, item)
	if button.internal == "OK" and button.parent.entry:getText() and button.parent.entry:getText() ~= "" then
		local FaunaModData = item:getModData()

		item:setName(button.parent.entry:getText())
		local pdata = getPlayerData(player:getPlayerNum())
		if pdata then
			pdata.playerInventory:refreshBackpacks()
			pdata.lootInventory:refreshBackpacks()
		end
	end
end

Events.OnPreFillInventoryObjectContextMenu.Add(contextFN.addRenameContext)