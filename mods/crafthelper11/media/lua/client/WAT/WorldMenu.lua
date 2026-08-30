require "WAT/ItemAudit"
require "WAT/GroundCleaner"
require "WAT/Coords"
require "WL_Utils"

local WAT_WorldMenu = {}

function WAT_WorldMenu.doMenu(playerIdx, context)
    if isClient() and not WL_Utils.isStaff(getPlayer()) then return end

    local submenu = WL_ContextMenuUtils.getOrCreateSubMenu(context, "WL Admin")

    if WL_Utils.canModerate(getPlayer()) then
        local auditsSubmenu = WL_ContextMenuUtils.getOrCreateSubMenu(submenu, "Audits")

        auditsSubmenu:addOption("Item Audit" , nil, WAT_WorldMenu.showItemAuditWindow)
        auditsSubmenu:addOption("Ground Cleaner" , nil, WAT_WorldMenu.showGroundCleanerWindow)

    end

    local spawnerSubmenu = WL_ContextMenuUtils.getOrCreateSubMenu(submenu, "Spawn:")
    spawnerSubmenu:addOption("Metal Barrel [Silver]", "crafted_01_24", WAT_WorldMenu.spawnMetalBarrel)
    spawnerSubmenu:addOption("Metal Barrel [Copper]", "crafted_01_28", WAT_WorldMenu.spawnMetalBarrel)
    spawnerSubmenu:addOption("Corpse (Male)", "Base.CorpseMale", WAT_WorldMenu.spawnCorpse)
    spawnerSubmenu:addOption("Corpse (Female)", "Base.CorpseFemale", WAT_WorldMenu.spawnCorpse)
    spawnerSubmenu:addOption("Trees", WAT_TreeSpawner, WAT_TreeSpawner.display)

    if WAT_ShowCoords then
        local coordsSubmenu = WL_ContextMenuUtils.getOrCreateSubMenu(submenu, "Coords")
        coordsSubmenu:addOption("Hide Coords" , nil, WAT_WorldMenu.toggleCoords)
        coordsSubmenu:addOption("Move To Top Left", "topleft", WAT_WorldMenu.moveCoords)
        coordsSubmenu:addOption("Move To Top Right", "topright", WAT_WorldMenu.moveCoords)
        coordsSubmenu:addOption("Move To Bottom Left", "bottomleft", WAT_WorldMenu.moveCoords)
        coordsSubmenu:addOption("Move To Bottom Right", "bottomright", WAT_WorldMenu.moveCoords)
        if WAT_CoordsCell then
            coordsSubmenu:addOption("Hide Cell", nil, WAT_WorldMenu.toggleCell)
        else
            coordsSubmenu:addOption("Show Cell", nil, WAT_WorldMenu.toggleCell)
        end
    else
        submenu:addOption("Show Coords" , nil, WAT_WorldMenu.toggleCoords)
    end

    submenu:addOption("Events Helper", WAT_EventsHelper, WAT_EventsHelper.display)
    submenu:addOption("Copy/Paste", WAT_CopyPaste, WAT_CopyPaste.display)

    --[[if isAdmin() then
        submenu:addOption("Reboot Server", nil, function()
            sendClientCommand(getPlayer(), "WAT", "reboot", {})
        end)
    end]]

    local vehicle = IsoObjectPicker.Instance:PickVehicle(getMouseXScaled(), getMouseYScaled())
    if vehicle then
        local toolsMenu = WL_ContextMenuUtils.getOrCreateSubMenu(context, "Tools")
        local vehicleMenu = WL_ContextMenuUtils.getOrCreateSubMenu(toolsMenu, "Vehicle:")
        if not getCore():getDebug() then
		    vehicleMenu:addOption("Vehicle Angles UI", vehicle, debugVehicleAngles)
        end
        vehicleMenu:addOption("Simple Repair", vehicle, WAT_WorldMenu.simpleRepair)
    end


end

function WAT_WorldMenu.showItemAuditWindow()
    WAT_ItemAudit:display()
end

function WAT_WorldMenu.showGroundCleanerWindow()
    WAT_GroundCleaner:display()
end

function WAT_WorldMenu.toggleCoords()
    WAT_ShowCoords = not WAT_ShowCoords
    getPlayer():getModData().WAT_ShowCoords = WAT_ShowCoords
end

function WAT_WorldMenu.moveCoords(pos)
    WAT_CoordsPos = pos
end

function WAT_WorldMenu.toggleCell()
    WAT_CoordsCell = not WAT_CoordsCell
    getPlayer():getModData().WAT_CoordsCell = WAT_CoordsCell
end

function WAT_WorldMenu.simpleRepair(vehicle)
	sendClientCommand(getPlayer(), "WAT", "simpleRepair", { vehicle = vehicle:getId() })
end

function WAT_WorldMenu.spawnMetalBarrel(sprite)
    ISBlacksmithMenu.onMetalDrum({}, 0, sprite)
end

function WAT_WorldMenu.spawnCorpse(corpseType)
    local player = getPlayer()
    local x = player:getX()
    local y = player:getY()
    local z = player:getZ()
    local sq = getCell():getGridSquare(x, y, z)
    if not sq then return end
    local corpse = InventoryItemFactory.CreateItem(corpseType)
    sq:AddWorldInventoryItem(corpse, 0, 0, 0)
end

Events.OnFillWorldObjectContextMenu.Add(WAT_WorldMenu.doMenu)