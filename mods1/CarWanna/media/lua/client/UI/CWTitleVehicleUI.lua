--[[
    CarWanna, Multiplayer car spawning library for Project Zomboid. 
    Copyright (C) 2022  Xyberviri, Chuckleberry Finn
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
    TLDR Version:
    https://tldrlegal.com/license/gnu-general-public-license-v3-(gpl-3)
    
                               //*,..       ..,*//                              
                      .*.                               .*.                     
   (@@@@@@@@@@@@@@#*       ,(%@@@@@@@@@@@@@@@@@@@@@%(,       *#@@@@@@@@@@@@@@#  
   (@@@@@@@@@@@/.     *%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%*.    ./@@@@@@@@@@@#  
   (@@@@@@@@/.    *&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*     /@@@@@@@@#  
   (@@@@@%,    *@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*    ,#@@@@@#  
   (@@@%,    %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%.   .%@@@#  
   (@&,   .%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%.   ,&@#  
   (/    #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#    /#  
   *   ,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,   *  
  *   *@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*   * 
 .   *@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/   .
 .  .@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.  .
*   %@@@@@#&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&(%@@@@@@&   
.  ,@@@@%.    /&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&/     *@@@@@@,  
   /@@@&.        ,&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*         (@@@@@(  
   (@@@#        .&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*        /@@@@@#  
   /@@@&,       .@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/        #@@@@@(  
.  ,@@@@&.       .&@@@@@@@@@* /&@@@@@@@@@@@@@@@@/ .&@@@@@@@@@/        #@@@@@@,  
*   %@@@@@(         ./(((,       .@@@@@@@@@@@,       ,((#(*         /@@@@@@@&   
 .  .@@@@@@@&*                 /&@@@@@@@@@@@@@@#,                *%@@@@@@@@@.  .
 .   *@@@@@@@@@@&%(/*,,,**#%@@@@@@@@@@@@@@@@@@@@@@@&%#/****/#%@@@@@@@@@@@@@/   .
  *   *@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*   * 
   *   ,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,   *  
   (/    #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#    /#  
   (@&,   .%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%.   ,&@#  
   (@@@%,    %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%.   .%@@@#  
   (@@@@@%,    *@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*    ,#@@@@@#  
   (@@@@@@@@/.    *&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*     /@@@@@@@@#  
   (@@@@@@@@@@@/.     *%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%*.    ./@@@@@@@@@@@#  
   (@@@@@@@@@@@@@@#*       ,(%@@@@@@@@@@@@@@@@@@@@@%(,       *#@@@@@@@@@@@@@@#  
                      .*.                               .*.                     
    Tips Accepted by not required Happy Modding..... 
    
    https://ko-fi.com/xyberviri
    https://www.paypal.me/xyberviri
--]]
require "ISUI/ISModalDialog"
require "luautils"

CWTitleVehicle = CWTitleVehicle or {}
CWTitleVehicle.UI = CWTitleVehicle.UI or {}
CWTitleVehicle.PartWhitelist = CWTitleVehicle.PartWhitelist or {}
CWTitleVehicle.VehicleBlacklist = CWTitleVehicle.VehicleBlacklist or {}
CWTitleVehicle.Trailerlist = CWTitleVehicle.Trailerlist or {}
CWTitleVehicle.knownTrailers = CWTitleVehicle.knownTrailers or {
"trailer",
"trailerTruck"
}
--[[
CWTitleVehicle.knownTrailers = CWTitleVehicle.knownTrailers or {
    { trailer="trailer", canAttach = "trailer", },                  --Vanilla and Normal modders
    { trailer="trailer", canAttach = "trailerfront",},              --Some Ki5 Military Vehicles (literally 6 mods)
    { trailer="trailerTruck", canAttach = "trailerTruck", },        --w900 semi mod, because rotators...
}
]]--
CWTitleVehicle.wantNoise = getDebug() or false
local noise = function(msg)
	if CWTitleVehicle.wantNoise then
		print('[CarWanna]: '..msg)
	end
end

local function IsVehicleTrailer(vehicle)
    if CWTitleVehicle.Trailerlist[vehicle:getScript():getFullName()] then return true end
    for i=1,#CWTitleVehicle.knownTrailers do
        local attachment = vehicle:getScript():getAttachmentById(CWTitleVehicle.knownTrailers[i])
        if attachment and attachment:getCanAttach() then
            return true
        end
    end
    return false
end
--[[
local function IsVehicleTrailer(vehicle)
    for i=1,#CWTitleVehicle.knownTrailers do
        local trailer = CWTitleVehicle.knownTrailers[i]
        print("Checking ",trailer.trailer," ",trailer.canAttach)
        local attachment = vehicle:getScript():getAttachmentById(trailer.trailer)
        if attachment and attachment:getCanAttach() then        
            print("\r\nThis is a trailer")
            --if attachment:getCanAttach()
            --and attachment:getCanAttach()[trailer.canAttach]
            return true
        end
    end
    return false
end
]]--
local function createVehicleTitle(player, button, vehicle)
    if button.internal == "NO" then return end
    if luautils.walkAdj(player, vehicle:getSquare()) then
        ISTimedActionQueue.add(CWCreateVehicleTitle:new(player, vehicle))
    end
end

local function confirmationDialog(player, vehicle)    
    local message = string.format(getText("IGUI_CW_Confirm"), getText("IGUI_VehicleName"..vehicle:getScript():getName()))
    local playerNum = player:getPlayerNum()
    local modal = ISModalDialog:new(0, 0, 300, 150, message, true, player, createVehicleTitle, playerNum, vehicle)
    modal:initialise();
    modal:addToUIManager();
end

function CWTitleVehicle.UI.addOptionToMenuOutsideVehicle(player, context, vehicle)
    if not SandboxVars.CarWanna.EnableRegistration then return end
    
    local vehicleName = string.lower(vehicle:getScriptName())
    if string.find(vehicleName, "burnt") or string.find(vehicleName, "smashed") then return end --yeah no

    --Check if player has registration form
    if SandboxVars.CarWanna.NeedForm and not player:getInventory():containsTypeRecurse("AutoForm") then return end
    
    local hasPassengers
    for i = 0, vehicle:getMaxPassengers() - 1 do
        if vehicle:getCharacter(i) then
            hasPassengers = true
            break
        end
    end
    if hasPassengers then return end
    

    local optionText = getText('ContextMenu_CW_CreateTitle')
    local option= context:addOption(optionText, player, confirmationDialog, vehicle)
    
    local toolTip = ISToolTip:new()
    toolTip:initialise()
    toolTip:setVisible(false)
    toolTip:setName(optionText)
    option.toolTip = toolTip
    
    local vehicleID = vehicle:getScript():getName()
    local text =  getText("IGUI_VehicleName"..vehicleID)
    noise("Vehicle: "..text)
    noise("Vehicle ID: "..vehicleID)    
    local notAvailable = false    

    if (Valhalla and Valhalla.VehicleClaims) then
        local ownerData = Valhalla.VehicleClaims:getOwner(vehicle)
        if ownerData then 
            text = text .. " <LINE> <LINE> <RGB:1,1,1> " .. getText("Tooltip_CW_Aegis") .. " <LINE> <RGB:1,0,0> " .. ownerData
            notAvailable = true
        end
    end
        
        local key = player:getInventory():haveThisKeyId(vehicle:getKeyId())
        text = text .. " <LINE> <LINE> <RGB:1,1,1> " .. getText("Tooltip_CW_Key")
        if not key then
            local ktcolor = "<RGB:1,1,0> "
            local endtext = getText("Tooltip_CW_KeyNo")
            
            if IsVehicleTrailer(vehicle) then
                ktcolor = "<RGB:0,1,0> "
                endtext = getText("Tooltip_CW_KeyTrailer")
            elseif SandboxVars.CarWanna.MustHaveKey then
                    notAvailable = true
                    ktcolor = "<RGB:1,0,0> "
                --end
            end            
            
            text = text .. " <LINE> ".. ktcolor .. endtext
        else
            text = text .. " <LINE> <RGB:0,1,0> " .. getText("Tooltip_CW_KeyYes")
        end
        
        if vehicle:isHotwired() then            
            if not SandboxVars.CarWanna.AllowHotwire then
                notAvailable = true
                text = text .. " <LINE> <RGB:1,0,0> "
            else
                text = text .. " <LINE> <RGB:1,1,0> "
            end
            text = text .. getText("Tooltip_CW_KeyHot")
        end

        local containerHasItems = {}
        local missingParts = {}
        local brokenParts = {}
        for i = 1, vehicle:getPartCount() do
            local part = vehicle:getPartByIndex(i - 1)            
            local partItem = part:getInventoryItem()            
            local partId   = part:getId()         
            
            --print(partId)--.." Item Type: "..partItem)--:getItemType()).."Is Empty: "..part:getItemType():isEmpty())
            --if partItem then
            --    print(partId, partItem:getType())
            --end
            --print(partId, part:getItemType())
            if CWTitleVehicle.wantNoise then
                if partItem then            
                    print("Part ID: "..partId)
                    print("Item Type: "..partItem:getFullType())
                    print("Item Name: "..partItem:getName())                              
                    if partItem:IsDrainable()  then
                        print("Drainable: "..partItem:getUsedDelta()) -- This is a battery --tostring(canDrain)
                    end
                    
                    --print("IsContainer: "..tostring(part:isContainer()))                
                    --print("MaxCapacity: "..partItem:getMaxCapacity())
                    local container = part:getItemContainer()
                    if container then
                        print("Container: "..container:getItems():size())  --This holds items
                    end
                    if not container and part:isContainer() then
                        print("Content: "..part:getContainerContentAmount()) --this holds fluids
                    end
                else
                    print("Part ID: "..partId)
                    if part:getItemType() and not part:getItemType():isEmpty() then
                        print("Item Type: MISSING")
                        print("Item Name: MISSING")
                    else
                        print("Item Type: nopart")
                        print("Item Name: nopart")
                    end                
                end
            end
            -- nodisplay parts cant be repaired.
            if part:getCategory() ~= "nodisplay" or (not SandboxVars.CarWanna.IgnoreNodisplay and part:getCategory() == "nodisplay") or (SandboxVars.CarWanna.ExperimentalTsarModSupport and ATA2TuningTable and ATA2TuningTable[vehicleID] and ATA2TuningTable[vehicleID].parts[partId]) then
                --"Real" Part, not installed            
                if part:getItemType() and not part:getItemType():isEmpty() and not partItem then
                    --if part:getItemType() then
                    if not CWTitleVehicle.PartWhitelist[partId] then
                        table.insert(missingParts, partId)
                    end
                    --end
                else
                    --Part with damage
                    if part:getCondition() < (SandboxVars.CarWanna.MinmumCondition) then
                        if not CWTitleVehicle.PartWhitelist[partId] then
                            table.insert(brokenParts, partId)
                        end
                    end
                    --Container not empty
                    local container = part:getItemContainer()
                    if container and not container:getItems():isEmpty() then
                        table.insert(containerHasItems, partId)
                    end
                    
                end
                
            end
            --end of loop though parts
        end

        if #missingParts > 0 then
            text = text .. " <LINE> <LINE> <RGB:1,1,1> " .. getText("Tooltip_CW_Install")
            for _, part in ipairs(missingParts) do
                text = text .. " <LINE> <RGB:1,0,0> " .. getText("IGUI_VehiclePart" .. part)
            end
            if SandboxVars.CarWanna.MustHaveAllParts then
                notAvailable = true
            end
        end
        if #brokenParts > 0 then
            text = text .. " <LINE> <LINE> <RGB:1,1,1> " .. getText("Tooltip_CW_Repair") .. (SandboxVars.CarWanna.MinmumCondition) .. "%"
            for _, part in ipairs(brokenParts) do
                text = text .. " <LINE> <RGB:1,0,0> " .. getText("IGUI_VehiclePart" .. part)
            end
                notAvailable = true
        end
        if #containerHasItems > 0 then
            text = text .. " <LINE> <LINE> <RGB:1,1,1> " .. getText("Tooltip_CW_HasItems")
            local ttcolor = "<RGB:1,1,0> "
            if SandboxVars.CarWanna.MustClearInventory then
                ttcolor = "<RGB:1,0,0> "
                notAvailable = true
            end
            
            for _, part in ipairs(containerHasItems) do
                text = text .. " <LINE> " .. ttcolor .. getText("IGUI_VehiclePart" .. part)
            end

        end
        
        local fulltype = vehicle:getScript():getFullName()
        if CWTitleVehicle.VehicleBlacklist[fulltype] then 
                text = text .. " <LINE> <LINE> <RGB:1,1,1> " .. getText("Tooltip_CW_BlackListed") .. " <LINE> <RGB:1,0,0> " .. fulltype
                notAvailable = true
        end

        if notAvailable and player:getAccessLevel() == "Admin" and SandboxVars.CarWanna.AdminOverride then
                text = text .. " <LINE> <LINE> <RGB:0,1,0> " .. getText("Tooltip_CW_AdminOverride")
                notAvailable = false
        end
        --Tooltip_CW_Inspection
        if not notAvailable then
            text = text .. " <LINE> <LINE> <RGB:1,1,1> " .. getText("Tooltip_CW_Inspection")
            text = text .. " <LINE> <RGB:0,1,0> " .. getText("Tooltip_CW_Pass")
        end
        
    --end of tool tips
    toolTip.description = text
    option.notAvailable = notAvailable
end

if not CWTitleVehicle.UI.defaultMenuOutsideVehicle then
    CWTitleVehicle.UI.defaultMenuOutsideVehicle = ISVehicleMenu.FillMenuOutsideVehicle
end

function ISVehicleMenu.FillMenuOutsideVehicle(player, context, vehicle, test)
    CWTitleVehicle.UI.defaultMenuOutsideVehicle(player, context, vehicle, test)
    CWTitleVehicle.UI.addOptionToMenuOutsideVehicle(getSpecificPlayer(player), context, vehicle)
end