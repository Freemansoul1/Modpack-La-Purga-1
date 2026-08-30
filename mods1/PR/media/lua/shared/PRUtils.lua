-- ╔════════════════════════════════════════════════════════════════════════════╗ --
-- ║                                                                            ║ --
-- ║                        ██████╗  ███████╗ ██╗      ██╗                      ║ --
-- ║                        ██╔══██╗ ██╔════╝ ██║      ██║                      ║ --
-- ║                        ██║  ██║ █████╗   ██║      ██║                      ║ --
-- ║                        ██║  ██║ ██╔══╝   ██║      ██║                      ║ --
-- ║                        ██████╔╝ ███████╗ ███████╗ ██║                      ║ --
-- ║                        ╚═════╝  ╚══════╝ ╚══════╝ ╚═╝                      ║ --
-- ║    ═══════════════════════════════════════════════════════════════════     ║ --
-- ║     All rights reserved. This content is protected by © Copyright law.     ║ --
-- ║      Reproduction, distribution, or modification without the express       ║ --
-- ║            authorization of the author is strictly prohibited.             ║ --
-- ╚════════════════════════════════════════════════════════════════════════════╝ --

PurgaRaidsUtils = {}

PurgaRaidsUtils.GetSafeHouse = function (x, y, x2, y2)
    local safehouseList = SafeHouse.getSafehouseList()
    for i=0, safehouseList:size() - 1, 1 do
        local safehouse =  safehouseList:get(i)
        local SFx1,SFy1,SFx2,SFy2 = safehouse:getX(), safehouse:getY(), safehouse:getX2(), safehouse:getY2()

        if x == SFx1 and y == SFy1 and x2 == SFx2 and y2 == SFy2 then
            return safehouse
        end
    end
end