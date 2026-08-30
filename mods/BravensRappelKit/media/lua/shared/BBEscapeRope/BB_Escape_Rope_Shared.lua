--***********************************************************
--**                       BitBraven                       **
--***********************************************************

BB_Escape_Rope = {}
BB_Escape_Rope.itemName = "EscapeRope"

-- N = E
-- S = W
-- W = N
-- E = S
BB_Escape_Rope.Sprites = {
    topRaised = { N = "pert_EscapeRopes_01_1", S = "pert_EscapeRopes_01_5", W = "pert_EscapeRopes_01_0", E = "pert_EscapeRopes_01_2" },
    top = { N = "pert_EscapeRopes_01_18", S = "pert_EscapeRopes_01_17", W = "pert_EscapeRopes_01_16", E = "pert_EscapeRopes_01_19" },
    topDecor = { N = "pert_EscapeRopes_01_26", S = "pert_EscapeRopes_01_25", W = "pert_EscapeRopes_01_24", E = "pert_EscapeRopes_01_27" },
    center = { N = "pert_EscapeRopes_01_9", S = "pert_EscapeRopes_01_13", W = "pert_EscapeRopes_01_8", E = "pert_EscapeRopes_01_10" },
    bottom = { N = "pert_EscapeRopes_01_11", S = "pert_EscapeRopes_01_12", W = "pert_EscapeRopes_01_11", E = "pert_EscapeRopes_01_12" },
}

BB_Escape_Rope.RescuePlayer = function (playerObj, x, y, z)
    playerObj:setX(x)
    playerObj:setLx(x)
    playerObj:setY(y)
    playerObj:setLy(y)
    playerObj:setZ(z)
    playerObj:setLz(z)
end