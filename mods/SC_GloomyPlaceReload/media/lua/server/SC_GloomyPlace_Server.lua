-- By 🆂🅲🆁🅸🅱🅻
-- Discord: scribl

-- Я не против если вы будете исследовать мои модификации. Не копируйте модификацию!
-- I don't mind if you explore my modifications. Do not copy the modification!

if not isServer() then return; end

SC_GloomyPlaceReload = SC_GloomyPlaceReload or require("SC_GloomyPlace_Class"):new();
Events.OnClientCommand.Add(function(module, command, player, args) SC_GloomyPlaceReload:OnClientCommand(module, command, player, args); end);