local ISOpenCloseVehicleWindow_start_orig = ISOpenCloseVehicleWindow.start;

--function ISOpenCloseVehicleWindow:start()
--
--	ISOpenCloseVehicleWindow_start_orig(self);
--	--print("ISOpenCloseVehicleWindow:start == " .. self.open)
--
--	if self.open then
--		self.vehicle:playPartAnim(self.part, "ClosedToOpen")
--	else
--		self.vehicle:playPartAnim(self.part, "OpenToClosed")
--	end
--end
