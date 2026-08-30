require "MF_ISMoodle"
require "TimedActions/ISCutLimb"

--Initiate a table
Knockout = Knockout or {}

--Function to be called when the player gets damage
function Knockout.onPlayerGetDamage(character, damageType, damage)
    --if target is not a zombie or not local player, then return
    if not instanceof(character, "IsoPlayer") or not character:isLocalPlayer() then return end

    if character:getModData().Knockout_isKnockedout then return end   --Ensure that the player can only get knocked out if he's not already knocked out

    if damageType == "CARCRASHDAMAGE" then                            --Check if damage is caused by a car crash
        if getActivatedMods():contains("WorkingSeatbelt1") and SandboxVars.Knockout.seatbeltPreventKnockout and character:getModData().Seatbelt_sbStatus then return end
        if damage >= SandboxVars.Knockout.carCrashDamage then         --Check if the amount of damage is more than or equal to the sandbox specified value
            local chanceSetting = SandboxVars.Knockout.chanceCarCrash --Get the sandbox chance value
            if chanceSetting > 0 then                                 --Make sure the option isn't turned off
                local chance = ZombRand(chanceSetting)                --Generate a random number between 0 and the sandbox option chance
                if chance <= chanceSetting then                       --Player will get knocked out only if he meets the chance specified in the sandbox options
                    Knockout.setUnconscious(character)                --Knock the player out
                end
            end
        end
    elseif damageType == "WEAPONHIT" then                                                                                                            --Check if the damage is caused by a weapon hit
        if damage >= SandboxVars.Knockout.weaponHitDamage and character:getBodyDamage():getHealth() <= SandboxVars.Knockout.weaponHitBodyDamage then --Check if the amounts of hit damage and body damage meet the criteria specified in sandbox option
            local chanceSetting = SandboxVars.Knockout.chanceWeaponHit                                                                               --Get the sandbox chance value
            if chanceSetting > 0 then                                                                                                                --Make sure the option isn't turned off
                local chance = ZombRand(chanceSetting)                                                                                               --Generate a random number between 0 and the sandbox option chance
                if chance <= chanceSetting then                                                                                                      --Player will get knocked out only if he meets the chance specified in the sandbox options
                    Knockout.setUnconscious(character)                                                                                               --Knock the player out
                end
            end
        end
    elseif damageType == "BLEEDING" then                                                                                                           --Check if the damage is caused by bleeding
        if damage >= SandboxVars.Knockout.bleedingDamage and character:getBodyDamage():getHealth() <= SandboxVars.Knockout.bleedingBodyDamage then --Check if the amounts of bleeding damage and body damage meet the criteria specified in sandbox option
            local chanceSetting = SandboxVars.Knockout.chanceBleeding                                                                              --Get the sandbox chance value
            if chanceSetting > 0 then                                                                                                              --Make sure the option isn't turned off
                if character:getModData().lastBleedKnockout and getGameTime():getDay() ~= character:getModData().lastBleedKnockout then            --Make sure that the player wasn't knocked out once before today due to bleeding
                    local chance = ZombRand(chanceSetting)                                                                                         --Generate a random number between 0 and the sandbox option chance
                    if chance <= chanceSetting then                                                                                                --Player will get knocked out only if he meets the chance specified in the sandbox options
                        Knockout.setUnconscious(character)                                                                                         --Knock the player out
                        character:getModData().lastBleedKnockout = getGameTime():getDay()                                                          --Set the last time player was knocked out due to bleeding to current game day
                    end
                end
            end
        end
    end
end

if getActivatedMods():contains("Amputation1") then    --If the Only Cure mod is on
    local old_ISCutLimb_perform = ISCutLimb.perform; --Store the original function

    --Hook the ISCutLimb function to edit it
    function ISCutLimb:perform(...)
        old_ISCutLimb_perform(self, ...)                            --Call the original function

        local chanceSetting = SandboxVars.Knockout.chanceAmputation --Get the sandbox chance value
        if chanceSetting > 0 then                                   --Make sure the option isn't turned off
            local chance = ZombRand(chanceSetting)                  --Generate a random number between 0 and the sandbox option chance
            if chance <= chanceSetting then                         --Player will get knocked out only if he meets the chance specified in the sandbox options
                if self.patient ~= self.surgeon and isClient() then --If there is a surgeon operating on another player, then knock the patient out
                    local onlineID = self.patient:getOnlineID()
                    sendClientCommand('RealKnockouts', 'knockOtherPlayerOut', { onlineID })
                else
                    Knockout.setUnconscious(self.patient) --Knock the player out
                end
            end
        end
    end
end


--Add the function to event
Events.OnPlayerGetDamage.Add(Knockout.onPlayerGetDamage)
