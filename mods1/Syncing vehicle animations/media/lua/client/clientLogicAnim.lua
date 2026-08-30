local function onServerCommand(module, command, args)
  if module == 'vehicle' then
    if command == 'setDoorAnim' then
      local vehicle = getVehicleById(args.vehicle)
      if vehicle then
        local part = vehicle:getPartById(args.part)
        if getPlayer():getUsername() ~= args.username then
          if args.open then
            vehicle:playPartAnim(part, "Opened")
          else
            vehicle:playPartAnim(part, "Closed")
          end
        end
      end
    end
  end
end

Events.OnServerCommand.Add(onServerCommand)
