local function AddSoulToDeadBody(playerObj)
    ---print(playerObj:getFullName() .. " is DEAD")

    playerObj:getInventory():AddItem(PurgaSkills:getNewSoul(playerObj))

end

Events.OnPlayerDeath.Add(AddSoulToDeadBody)