local nvctrl = require "NVAPI/ctrl/instance"

Events.OnKeyPressed.Add( function(key)
  if key == 21 then
    nvctrl:toggle()
  end
end )