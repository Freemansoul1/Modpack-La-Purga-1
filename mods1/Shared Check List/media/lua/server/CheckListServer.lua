
local function CheckListonServerReceiveGlobalModData(module, packet)
    if not string.find(module, "SharedTDL") or not packet then
        return
    end

    if not isServer() then
        return
    end

    --if ModData.get(module) then ModData.remove(module) end

    ModData.add(module, packet)

    ModData.transmit(module)
end
Events.OnReceiveGlobalModData.Add(CheckListonServerReceiveGlobalModData);

function CheckList_OnClientCommand(module, command, player, args)
    if module ~= "SharedTDL" then         
      return
    end
 
    if command == "REFRESH" then
      local otherPlayer = getPlayerByOnlineID(args["id"])
	    if otherPlayer then
		     sendServerCommand(otherPlayer, "SharedTDL", "REFRESH", args)
	    end
    end

    if command == "DELETE" then
        local otherPlayer = getPlayerByOnlineID(args["id"])
          if otherPlayer then
               sendServerCommand(otherPlayer, "SharedTDL", "DELETE", args)
          end
    end

 end
 Events.OnClientCommand.Add(CheckList_OnClientCommand);