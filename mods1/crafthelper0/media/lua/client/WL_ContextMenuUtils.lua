---
--- WL_ContextMenuUtils.lua
--- 18/10/2023
---

WL_ContextMenuUtils = {}

--- Gets a submenu for the context menu if it exists, otherwise creates it
--- Allows multiple mods to share the same submenu, the first one to use the function makes it for the next ones.
function WL_ContextMenuUtils.getOrCreateSubMenu(context, name)
	local option = context:getOptionFromName(name)
	if not option then -- Needs to be created
		option = context:addOption(name, nil, nil)
		local submenu = ISContextMenu:getNew(context)
		context:addSubMenu(option, submenu)
		return submenu
	else -- already exists
		return context:getSubMenu(option.subOption)
	end
end