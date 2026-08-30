local scriptItem = getScriptManager():getItem("Base.PropaneTank")
if scriptItem then
    scriptItem:DoParam("StaticModel = PropaneTankHand")
    scriptItem:DoParam("primaryAnimMask = HoldingTorchRight")
    scriptItem:DoParam("secondaryAnimMask = HoldingTorchLeft")
end