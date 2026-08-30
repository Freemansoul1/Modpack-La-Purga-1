require "TimedActions/ISBaseTimedAction"

local ebanie_cordinati = { x = nil, y = nil, z = nil }

--Функция для изменения энергии
function ChangeEnergyLevelWithSync(playerObj, level)
    local Consumption = level * 15 * 4
    if playerObj:HasTrait("FastLearner") then
        Consumption = Consumption / 1.3
    end
    if playerObj:HasTrait("SlowLearner") then
        Consumption = Consumption / 0.7
    end
    playerObj:getXp():AddXP(Perks.MineEndurance, math.ceil(-Consumption));
    local tmpXP = playerObj:getXp():getXP(Perks.MineEndurance)
    if playerObj:HasTrait("FastLearner") then
        tmpXP = tmpXP / 1.3
    end
    if playerObj:HasTrait("SlowLearner") then
        tmpXP = tmpXP / 0.7
    end
    playerObj:getXp():setXPToLevel(Perks.MineEndurance, 0)
    playerObj:getXp():AddXP(Perks.MineEndurance, math.ceil(tmpXP * 4));
end

--ФУНКЦИЯ "РЫТЬСЯ НА СВАЛКЕ"
ISSearchTrash = ISBaseTimedAction:derive("ISSearchTrash");

function ISSearchTrash:isValid()
    return self.character:getXp():getXP(Perks.MineEndurance) >= 15 and self.character:getStats():getEndurance() >= 0.1 and self.character:getStats():getFatigue() <= 0.8
end

function ISSearchTrash:update()
    self.character:faceThisObjectAlt(self.item)
    if not self.character:getEmitter():isPlaying(self.sound) then
        self.sound = self.character:playSound("Trash_Searching")
    end
end

function ISSearchTrash:start()
    self:setActionAnim("Loot")
    self.character:SetVariable("LootPosition", "Low")
    self.sound = self.character:playSound("Trash_Searching")
end

function ISSearchTrash:stop()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    ISBaseTimedAction.stop(self);
end

function ISSearchTrash:perform()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    ISBaseTimedAction.perform(self);
    local r = ZombRand(100)
    local x = ZombRand(8)
    local bc = ZombRand(5)
    local dt = ZombRand(8)
    local nail = ZombRand(5)
    local screw = ZombRand(5)
    local plastic = ZombRand(3)
    local rope = ZombRand(10)
    local rubber = ZombRand(4)
    local silicon = ZombRand(4)
    local glass = ZombRand(3)
    local grncrd = ZombRand(30)
    local trshr = ZombRand(200)
    if r <= 50 then
        self.character:getInventory():AddItem("Base.ScrapMetal");
    end
    if x == 5 or x == 4 then
        self.character:getInventory():AddItems("Base.UnusableMetal", 3);
    elseif x == 3 or x == 2 then
        self.character:getInventory():AddItems("Base.UnusableMetal", 2);
    elseif  x == 2 or x == 1 or x == 0 then
        self.character:getInventory():AddItem("Base.UnusableMetal");
    end
    if bc == 4 then
        self.character:getInventory():AddItems("NHM.BulletCasing", 2);
    elseif bc == 3 or bc == 2 then
        self.character:getInventory():AddItem("NHM.BulletCasing");
    end
    if dt == 0 then
        self.character:getInventory():AddItem("Base.DuctTape");
    elseif dt == 1 then
        self.character:getInventory():AddItem("Base.Glue");
    elseif dt == 2 then
        self.character:getInventory():AddItem("Base.Woodglue");
    elseif dt == 3 then
        self.character:getInventory():AddItem("Base.Scotchtape");
    end
    if nail == 2 or nail == 3 then
        self.character:getInventory():AddItem("Base.Nails");
    end
    if screw == 2 then
        self.character:getInventory():AddItems("Base.Screws", 2);
    end
    if plastic == 2 then
        self.character:getInventory():AddItem("NHM.Plastic");
    end
    if rope == 9 then
        self.character:getInventory():AddItem("Base.Rope");
    end
    if rubber == 3 then
        self.character:getInventory():AddItem("NHM.Rubber");
    end
    if silicon == 1 then
        self.character:getInventory():AddItem("NHM.SiliconOre");
    end
    if glass == 2 then
        self.character:getInventory():AddItem("NHM.Glass");
    end
    if grncrd == 9 then
        self.character:getInventory():AddItem("NHM.GreenCard");
    end
    if self.character:HasTrait('trasher') then
        if trshr >= 0 and trshr <= 1 then
            self.character:getInventory():AddItem("Base.Battery");
        elseif trshr >= 2 and trshr <= 3 then
            self.character:getInventory():AddItem("Base.Wallet");
        elseif trshr == 10 then
            self.character:getInventory():AddItem("NHM.QuestConicalFlask");
        elseif trshr == 11 then
            self.character:getInventory():AddItem("NHM.QuestSlicker");
        elseif trshr == 12 then
            self.character:getInventory():AddItem("NHM.QuestPCB");
        elseif trshr >= 13 and trshr <= 15 then
            self.character:getInventory():AddItem("Base.Stone");
        elseif trshr >= 16 and trshr <= 18 then
            self.character:getInventory():AddItem("Base.Ring_Right_MiddleFinger_Gold");
        elseif trshr >= 19 and trshr <= 21 then
            self.character:getInventory():AddItem("Base.WristWatch_Left_DigitalBlack");
        elseif trshr >= 22 and trshr <= 24 then
            self.character:getInventory():AddItem("Base.CannedPineapple");
        elseif trshr >= 25 and trshr <= 27 then
            self.character:getInventory():AddItem("Base.DeadRat");
        elseif trshr >= 28 and trshr <= 30 then
            self.character:getInventory():AddItem("Base.Cockroach");
        elseif trshr >= 31 and trshr <= 33 then
            self.character:getInventory():AddItem("Base.Worm");
        elseif trshr >= 34 and trshr <= 36 then
            self.character:getInventory():AddItem("Base.Newspaper");
        elseif trshr >= 37 and trshr <= 39 then
            self.character:getInventory():AddItem("Base.Magazine");
        elseif trshr >= 40 and trshr <= 42 then
            self.character:getInventory():AddItem("Base.MintCandy");
        elseif trshr >= 43 and trshr <= 45 then
            self.character:getInventory():AddItem("Base.Matches");
        elseif trshr >= 46 and trshr <= 48 then
            self.character:getInventory():AddItem("Base.Pop");
        elseif trshr == 49 then
            self.character:getInventory():AddItem("Base.Underpants_AnimalPrint");
        elseif trshr == 50 then
            self.character:getInventory():AddItem("Base.GuitarAcoustic");
        elseif trshr >= 51 and trshr <= 53 then
            self.character:getInventory():AddItem("Base.TrapMouse");
        elseif trshr == 54 and trshr <= 56 then
            self.character:getInventory():AddItem("Base.Saucepan");
        elseif trshr == 57 and trshr <= 59 then
            self.character:getInventory():AddItem("Base.Bandage");
        elseif trshr >= 60 and trshr <= 62 then
            self.character:getInventory():AddItem("Base.Needle");
        elseif trshr >= 63 and trshr <= 65 then
            self.character:getInventory():AddItem("Base.Wire");
        elseif trshr >= 66 and trshr <= 67 then
            self.character:getInventory():AddItem("Base.Money");
        elseif trshr == 68 then
            self.character:getInventory():AddItem("Base.Spiffo");
        elseif trshr >= 69 and trshr <= 72 then
            self.character:getInventory():AddItem("Base.ScrapMetal");
        elseif trshr >= 73 and trshr <= 76 then
            self.character:getInventory():AddItem("Base.UnusableMetal");
        elseif trshr >= 77 and trshr <= 80 then
            self.character:getInventory():AddItem("Base.SheetMetal");
        elseif trshr >= 81 and trshr <= 84 then
            self.character:getInventory():AddItem("Base.Bucket");
        elseif trshr >= 85 and trshr <= 88 then
            self.character:getInventory():AddItem("Base.BeetBottle");
        elseif trshr >= 89 and trshr <= 92 then
            self.character:getInventory():AddItem("Base.Fork");
        elseif trshr >= 93 and trshr <= 96 then
            self.character:getInventory():AddItem("Base.Spoon");
        elseif trshr >= 97 and trshr <= 98 then
            self.character:getInventory():AddItem("Base.Wrench");
        elseif trshr >= 99 and trshr <= 102 then
            self.character:getInventory():AddItem("Base.KitchenKnife");
        elseif trshr >= 103 and trshr <= 106 then
            self.character:getInventory():AddItem("Base.Soap");
        elseif trshr >= 107 and trshr <= 110 then
            self.character:getInventory():AddItem("Radio.WalkieTalkie2");
        elseif trshr >= 111 and trshr <= 114 then
            self.character:getInventory():AddItem("Base.CordlessPhone");
        elseif trshr >= 115 and trshr <= 118 then
            self.character:getInventory():AddItem("Base.EmptySandbag");
        elseif trshr >= 119 and trshr <= 122 then
            self.character:getInventory():AddItem("Base.SmallSheetMetal");
        elseif trshr >= 123 and trshr <= 126 then
            self.character:getInventory():AddItem("Base.Garbagebag");
        elseif trshr >= 127 and trshr <= 130 then
            self.character:getInventory():AddItem("NHM.ChemicalFlask");
        elseif trshr >= 131 and trshr <= 135 then
            self.character:getInventory():AddItem("NHM.Coal");
        elseif trshr >= 136 and trshr <= 140 then
            self.character:getInventory():AddItem("Base.WeldingRods");
        elseif trshr >= 141 and trshr <= 145 then
            self.character:getInventory():AddItem("Base.Pot");
        elseif trshr >= 146 and trshr <= 150 then
            self.character:getInventory():AddItem("Base.PropaneTorch");
        end
    end

    ChangeEnergyLevelWithSync(self.character, 1)
    self.character:getStats():setEndurance(self.character:getStats():getEndurance() - 0.15);
end

function ISSearchTrash:new(character, item, time)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character;
    o.item = item;
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.maxTime = time;
    return o;
end

--ВХОД В ЛАБУ
ISLabAction = ISBaseTimedAction:derive("ISLabAction");

function ISLabAction:isValid()
    return true
end

function ISLabAction:waitToStart()
    if self.direction == "N" then
        self.character:facePosition(self.character:getX(), self.character:getY() - 1)
    elseif self.direction == "W" then
        self.character:facePosition(self.character:getX() - 1, self.character:getY())
    end
    return self.character:shouldBeTurning()
end

function ISLabAction:update()
    if self.item then
        self.item:setJobDelta(self:getJobDelta());
    end
end

function ISLabAction:start()
    self:setActionAnim("TakeGasFromPump")
    if self.item then
        self.item:setJobType(getText("ContextMenu_UseKeycard"));
        self.item:setJobDelta(0.0);
    end
    self.sound = self.character:playSound("CardAccess")
end

function ISLabAction:stop()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    if self.item then
        self.item:setJobDelta(0.0);
    end
    ISBaseTimedAction.stop(self);
end

function ISLabAction:perform()
    ISBaseTimedAction.perform(self);
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    if self.item then
        self.item:setJobDelta(0.0);

        if self.item:getDrainableUsesInt() ~= 50 then
            self.item:setUsedDelta(self.item:getUsedDelta() - 0.5);
        else
            self.character:removeFromHands(self.item)
            self.character:getInventory():removeItemWithIDRecurse(self.item:getID())
        end
    end
    ebanie_cordinati.x = self.x
    ebanie_cordinati.y = self.y
    ebanie_cordinati.z = self.z
    Events.OnTick.Add(pornuxa)
end

function ISLabAction:new(character, tile, item, x, y, z, direction)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character;
    o.tile = tile;
    o.item = item
    o.maxTime = 45
    o.x = x
    o.y = y
    o.z = z
    o.direction = direction
    return o;
end

--ФУНКЦИЯ "НАПОЛНИТЬ ГАЗОВУЮ ГОРЕЛКУ / БАЛЛОН С ПРОПАНОМ"
ISExtractGas = ISBaseTimedAction:derive("ISExtractGas");

function ISExtractGas:isValid()
    return self.character:getXp():getXP(Perks.MineEndurance) >= 15 * self.level and self.character:getStats():getEndurance() >= 0.1 and self.character:getStats():getFatigue() <= 0.8 and self.character:getPrimaryHandItem():getDrainableUsesInt() ~= 100
end

function ISExtractGas:waitToStart()
    self.character:faceLocation(self.tile:getSquare():getX(), self.tile:getSquare():getY())
    return self.character:shouldBeTurning()
end

function ISExtractGas:update()
    self.item:setJobDelta(self:getJobDelta());
    self.character:faceThisObjectAlt(self.tile)
    if not self.character:getEmitter():isPlaying(self.sound) then
        self.sound = self.character:playSound("Propane_Filling")
    end
end

function ISExtractGas:start()
    self.item:setJobType(getText("ContextMenu_TakeGasFromGasStation"));
    self.item:setJobDelta(0.0);

    self:setOverrideHandModels(self.item:getStaticModel(), nil)
    self:setActionAnim("TakeGasFromVehicle")
    self.sound = self.character:playSound("Propane_Filling")
end

function ISExtractGas:stop()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    self.item:setJobDelta(0.0);
    ISBaseTimedAction.stop(self);
end

function ISExtractGas:perform()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    ISBaseTimedAction.perform(self);
    self.item:setJobDelta(0.0);

    self.item:setDelta(1)

    ChangeEnergyLevelWithSync(self.character, self.level)
    self.character:getStats():setEndurance(self.character:getStats():getEndurance() - 0.2);
end

function ISExtractGas:new(character, tile, item, oldDelta, time, level)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character;
    o.tile = tile;
    o.item = item
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.maxTime = time * math.ceil((1 - oldDelta) * 10) / 10;
    o.level = level
    return o;
end


--ФУНКЦИЯ ДЛЯ ШАХТЫ
ISMineGeneral = ISBaseTimedAction:derive("ISMineGeneral");

function ISMineGeneral:isValid()
    return self.character:getXp():getXP(Perks.MineEndurance) >= 15 * self.level and self.character:getStats():getEndurance() >= 0.1 and self.character:getStats():getFatigue() <= 0.8
end

function ISMineGeneral:waitToStart()
    self.character:faceThisObjectAlt(self.item)
    return self.character:shouldBeTurning()
end

function ISMineGeneral:update()
    self.PickAxe:setJobDelta(self:getJobDelta());
    self.character:faceThisObjectAlt(self.item)
    if not self.character:getEmitter():isPlaying(self.sound) then
        self.sound = self.character:playSound("Mining_Pickaxe")
    end
end

function ISMineGeneral:start()
    self.PickAxe:setJobType(getText("ContextMenu_Mining"));
    self.PickAxe:setJobDelta(0.0);

    self:setActionAnim("Mining")
    self:setOverrideHandModels(self.PickAxe, nil)
    self.sound = self.character:playSound("Mining_Pickaxe")
end

function ISMineGeneral:stop()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    self.PickAxe:setJobDelta(0.0);
    ISBaseTimedAction.stop(self);
end

function ISMineGeneral:perform()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    ISBaseTimedAction.perform(self);
    self.PickAxe:setJobDelta(0.0);

    --copper
    if self.OreSpriteName == "NHCopper_0" then
        local minecop = ZombRand(5)
        self.character:getXp():AddXP(Perks.MetalWelding, 5);
        if minecop == 3 or (minecop == 2 and self.character:HasTrait('miner')) or (minecop == 1 and self.character:HasTrait('miner')) then
            self.character:getInventory():AddItems("NHM.CopperOre", 2);
        else
            self.character:getInventory():AddItem("NHM.CopperOre");
        end
    end

    --tin
    if self.OreSpriteName == "NHTin_0" then
        local minetin = ZombRand(5)
        self.character:getXp():AddXP(Perks.MetalWelding, 5);
        if minetin == 3 or (minetin == 2 and self.character:HasTrait('miner')) or (minetin == 1 and self.character:HasTrait('miner')) then
            self.character:getInventory():AddItems("NHM.TinOre", 2);
        else
            self.character:getInventory():AddItem("NHM.TinOre");
        end
    end

    --iron
    if self.OreSpriteName == "NHIron_0" then
        local mineiron = ZombRand(5)
        self.character:getXp():AddXP(Perks.MetalWelding, 10);
        if mineiron == 4 or (mineiron == 2 and self.character:HasTrait('miner')) or (mineiron == 1 and self.character:HasTrait('miner')) then
            self.character:getInventory():AddItems("NHM.IronOre", 2);
        else
            self.character:getInventory():AddItem("NHM.IronOre");
        end
        self.character:getInventory():AddItems("Base.Stone", 1);
    end

    --lead
    if self.OreSpriteName == "NHLead_0" then
        local minelead = ZombRand(5)
        self.character:getXp():AddXP(Perks.MetalWelding, 10);
        if minelead == 4 or (minelead == 2 and self.character:HasTrait('miner')) or (minelead == 1 and self.character:HasTrait('miner')) then
            self.character:getInventory():AddItems("NHM.GalenaOre", 2);
        else
            self.character:getInventory():AddItem("NHM.GalenaOre");
        end
        self.character:getInventory():AddItems("Base.Stone", 1);
    end

    --nickel
    if self.OreSpriteName == "NHNickel_0" then
        local minenkl = ZombRand(5)
        self.character:getXp():AddXP(Perks.MetalWelding, 15);
        if minenkl == 4 or (minenkl == 2 and self.character:HasTrait('miner')) or (minenkl == 1 and self.character:HasTrait('miner')) then
            self.character:getInventory():AddItems("NHM.NickelOre", 2);
        else
            self.character:getInventory():AddItem("NHM.NickelOre");
        end
        self.character:getInventory():AddItems("Base.Stone", 2);
    end

    --chromium
    if self.OreSpriteName == "NHChromium_0" then
        local minechr = ZombRand(5)
        self.character:getXp():AddXP(Perks.MetalWelding, 15);
        if minechr == 4 or (minechr == 2 and self.character:HasTrait('miner')) or (minechr == 1 and self.character:HasTrait('miner')) then
            self.character:getInventory():AddItems("NHM.ChromiumOre", 2);
        else
            self.character:getInventory():AddItem("NHM.ChromiumOre");
        end
        self.character:getInventory():AddItems("Base.Stone", 2);
    end

    --sulfur
    if self.OreSpriteName == "NHSulfur_0" then
        local mineslfr = ZombRand(5)
        self.character:getXp():AddXP(Perks.MetalWelding, 6);
        if mineslfr == 4 or (mineslfr == 2 and self.character:HasTrait('miner')) or (mineslfr == 1 and self.character:HasTrait('miner')) then
            self.character:getInventory():AddItems("NHM.SulfurOre", 3);
        else
            self.character:getInventory():AddItems("NHM.SulfurOre", 2);
        end
    end

    --limestone
    if self.OreSpriteName == "NHLimestone_0" then
        local minelmst = ZombRand(5)
        self.character:getXp():AddXP(Perks.MetalWelding, 3);
        if minelmst == 4 or (minelmst == 2 and self.character:HasTrait('miner')) or (minelmst == 1 and self.character:HasTrait('miner')) then
            self.character:getInventory():AddItems("NHM.Limestone", 2);
        else
            self.character:getInventory():AddItem("NHM.Limestone");
        end
    end

    --coal
    if self.OreSpriteName == "NHCoal_0" then
        local minecl = ZombRand(5)
        self.character:getXp():AddXP(Perks.MetalWelding, 3);
        if minecl == 4 or (minecl == 2 and self.character:HasTrait('miner')) or (minecl == 1 and self.character:HasTrait('miner')) then
            self.character:getInventory():AddItems("NHM.Coal", 5);
        else
            self.character:getInventory():AddItems("NHM.Coal", 3);
        end
    end

    --stone
    if self.OreSpriteName == "NHStone_1_0" or self.OreSpriteName == "NHStone_2_0" then
        local minestn = ZombRand(5)
        self.character:getXp():AddXP(Perks.MetalWelding, 6);
        if minestn == 4 or (minestn == 2 and self.character:HasTrait('miner')) or (minestn == 1 and self.character:HasTrait('miner')) then
            self.character:getInventory():AddItems("Base.Stone", 5);
        else
            self.character:getInventory():AddItems("Base.Stone", 3);
        end
    end

    --salt
    if self.OreSpriteName == "NHSalt_1_0" or self.OreSpriteName == "NHSalt_2_0" then
        local mineslt = ZombRand(5)
        self.character:getXp():AddXP(Perks.MetalWelding, 3);
        if mineslt == 4 or (mineslt == 2 and self.character:HasTrait('miner')) or (mineslt == 1 and self.character:HasTrait('miner')) then
            self.character:getInventory():AddItems("NHM.SaltPinch", 4);
        else
            self.character:getInventory():AddItems("NHM.SaltPinch", 2);
        end
    end

    ChangeEnergyLevelWithSync(self.character, self.level)
    self.character:getStats():setEndurance(self.character:getStats():getEndurance() - self.endurance);

end

function ISMineGeneral:new(character, item, PickAxe, time, OreSpriteName, level, endurance)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character;
    o.item = item;
    o.PickAxe = PickAxe;
    o.OreSpriteName = OreSpriteName
    o.level = level
    o.endurance = endurance
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.maxTime = time;
    if character:HasTrait("miner") then
        o.maxTime = time / 1.5
    end
    if character:HasTrait("Claustrophobic") then
        o.maxTime = time * 1.3
    end
    if character:isTimedActionInstant() then
        o.maxTime = 1;
    end
    return o;
end


--ФУНКЦИЯ ДОБЫТЬ АКТИВНОЕ ВЕЩЕСТВО
ISActiveComp = ISBaseTimedAction:derive("ISActiveComp");

function ISActiveComp:isValid()
    return self.character:getXp():getXP(Perks.MineEndurance) >= 60 and self.character:getStats():getEndurance() >= 0.1 and self.character:getStats():getFatigue() <= 0.8
end

function ISActiveComp:update()
    self.character:faceThisObjectAlt(self.item)
    if not self.character:getEmitter():isPlaying(self.sound) then
        self.sound = self.character:playSound("ActiveComponent")
    end
end

function ISActiveComp:start()
    self:setActionAnim("Craft")
    self.sound = self.character:playSound("ActiveComponent")
end

function ISActiveComp:stop()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    ISBaseTimedAction.stop(self);
end

function ISActiveComp:perform()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    ISBaseTimedAction.perform(self);
    self.character:removeFromHands(self.Flask)
    self.character:getInventory():Remove("ChemicalFlask");
    self.character:getInventory():AddItem("NHM.FlaskActiveComp");
    ChangeEnergyLevelWithSync(self.character, 4)
end

function ISActiveComp:new(character, item, time, Flask)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character;
    o.item = item;
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.maxTime = time;
    o.Flask = Flask
    return o;
end

--ФУНКЦИЯ НАПОЛНИТЬ КАНИСТРУ БЕНЗИНОМ
ISExtractPetrol = ISBaseTimedAction:derive("ISExtractPetrol");

function ISExtractPetrol:isValid()
    return self.character:getXp():getXP(Perks.MineEndurance) >= 15 * self.level and self.character:getStats():getEndurance() >= 0.1 and self.character:getStats():getFatigue() <= 0.8
end

function ISExtractPetrol:waitToStart()
    self.character:faceLocation(self.tile:getSquare():getX(), self.tile:getSquare():getY())
    return self.character:shouldBeTurning()
end

function ISExtractPetrol:update()
    self.item:setJobDelta(self:getJobDelta());
    self.character:faceThisObjectAlt(self.tile)
    if not self.character:getEmitter():isPlaying(self.sound) then
        self.sound = self.character:playSound("CanisterAddFuelFromGasPump")
    end
end

function ISExtractPetrol:start()
    self.item:setJobType(getText("ContextMenu_TakeGasFromPump"));
    self.item:setJobDelta(0.0);

    self:setOverrideHandModels(nil, self.item:getStaticModel())
    self:setActionAnim("TakeGasFromPump")
    self.sound = self.character:playSound("CanisterAddFuelFromGasPump")
end

function ISExtractPetrol:stop()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    self.item:setJobDelta(0.0);
    ISBaseTimedAction.stop(self);
end

function ISExtractPetrol:perform()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    ISBaseTimedAction.perform(self);
    self.item:setJobDelta(0.0);

    if self.item:getType() == "EmptyPetrolCan" then
        local emptyCan = self.item
        self.item = self.character:getInventory():AddItem("Base.PetrolCan")
        if self.character:getPrimaryHandItem() == emptyCan then
            self.character:setPrimaryHandItem(self.item)
        end
        if self.character:getSecondaryHandItem() == emptyCan then
            self.character:setSecondaryHandItem(self.item)
        end
        self.character:getInventory():Remove(emptyCan)
    else
        self.item:setDelta(1)
    end

    ChangeEnergyLevelWithSync(self.character, self.level)
    self.character:getStats():setEndurance(self.character:getStats():getEndurance() - 0.5);
end

function ISExtractPetrol:new(character, item, tile, level, time, oldDelta)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character;
    o.item = item;
    o.tile = tile
    o.level = level
    o.stopOnWalk = true;
    o.stopOnRun = true;
    if oldDelta then
        o.maxTime = time * math.ceil((1 - oldDelta) * 10) / 10;
    else
        o.maxTime = time
    end
    return o;
end

--ФУНКЦИЯ ДОБЫТЬ ДЕТАЛИ ОРУЖИЯ
ISExtractWeaponpart = ISBaseTimedAction:derive("ISExtractWeaponpart");

function ISExtractWeaponpart:isValid()
    return true;
end

function ISExtractWeaponpart:update()
end

function ISExtractWeaponpart:start()
    self.sound = self.character:playSound("Things_Searching");
    local radius = 20
    addSound(self.character, self.character:getX(), self.character:getY(), self.character:getZ(), radius, radius)
end

function ISExtractWeaponpart:stop()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    ISBaseTimedAction.stop(self);
end

function ISExtractWeaponpart:perform()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    ISBaseTimedAction.perform(self);
    local wp = ZombRand(30)
    if wp == 0 or wp == 1 then
        self.character:getInventory():AddItem("NHM.Laser2");
    elseif wp == 2 or wp == 3 then
        self.character:getInventory():AddItem("NHM.Foregrip3");
    elseif wp == 4 or wp == 5 then
        self.character:getInventory():AddItem("NHM.Foregrip4");
    elseif wp == 6 or wp == 7 then
        self.character:getInventory():AddItem("NHM.Bipod2");
    elseif wp == 8 or wp == 9 then
        self.character:getInventory():AddItem("NHM.Scope262");
    elseif wp == 10 or wp == 11 then
        self.character:getInventory():AddItem("NHM.Holosight2");
    elseif wp == 12 or wp == 13 then
        self.character:getInventory():AddItem("NHM.Holosight3");
    elseif wp == 14 or wp == 15 then
        self.character:getInventory():AddItem("NHM.Compensator1");
    elseif wp == 16 or wp == 17 then
        self.character:getInventory():AddItem("NHM.Supressor3");
    elseif wp == 18 or wp == 19 then
        self.character:getInventory():AddItem("NHM.Supressor4");
    end
end

function ISExtractWeaponpart:new(character, item, time)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character;
    o.item = item;
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.maxTime = 950;
    return o;
end

--ФУНКЦИЯ КАЧАТЬ БЕГ
ISTrainRun = ISBaseTimedAction:derive("ISTrainRun");

function ISTrainRun:isValid()
    return true;
end

function ISTrainRun:update()
end

function ISTrainRun:start()
    local radius = 20
    addSound(self.character, self.character:getX(), self.character:getY(), self.character:getZ(), radius, radius)
end

function ISTrainRun:stop()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    ISBaseTimedAction.stop(self);
end

function ISTrainRun:perform()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    ISBaseTimedAction.perform(self);
    local g = getPlayer():getPerkLevel(Perks.Sprinting);
    getPlayer():getXp():AddXP(Perks.Sprinting, 7.5 * (1 + g));
end

function ISTrainRun:new(character, item, time)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character;
    o.item = item;
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.maxTime = time;
    return o;
end

--ФУНКЦИЯ КАЧАТЬ ЛЕГКИЙ ШАГ
ISTrainLightfoot = ISBaseTimedAction:derive("ISTrainLightfoot");

function ISTrainLightfoot:isValid()
    return true;
end

function ISTrainLightfoot:update()
end

function ISTrainLightfoot:start()
    local radius = 20
    addSound(self.character, self.character:getX(), self.character:getY(), self.character:getZ(), radius, radius)
end

function ISTrainLightfoot:stop()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    ISBaseTimedAction.stop(self);
end

function ISTrainLightfoot:perform()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    ISBaseTimedAction.perform(self);
    local g = getPlayer():getPerkLevel(Perks.Lightfoot);
    getPlayer():getXp():AddXP(Perks.Lightfoot, 7.5 * (1 + g));
end

function ISTrainLightfoot:new(character, item, time)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character;
    o.item = item;
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.maxTime = time;
    return o;
end

--ФУНКЦИЯ КАЧАТЬ ПРОВОРНОСТЬ
ISTrainNimble = ISBaseTimedAction:derive("ISTrainNimble");

function ISTrainNimble:isValid()
    return true;
end

function ISTrainNimble:update()
end

function ISTrainNimble:start()
    local radius = 20
    addSound(self.character, self.character:getX(), self.character:getY(), self.character:getZ(), radius, radius)
end

function ISTrainNimble:stop()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    ISBaseTimedAction.stop(self);
end

function ISTrainNimble:perform()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    ISBaseTimedAction.perform(self);
    local g = getPlayer():getPerkLevel(Perks.Nimble);
    getPlayer():getXp():AddXP(Perks.Nimble, 7.5 * (1 + g));
end

function ISTrainNimble:new(character, item, time)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character;
    o.item = item;
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.maxTime = time;
    return o;
end

--ФУНКЦИЯ КАЧАТЬ СКРЫТНОСТЬ
ISTrainSneak = ISBaseTimedAction:derive("ISTrainSneak");

function ISTrainSneak:isValid()
    return true;
end

function ISTrainSneak:update()
end

function ISTrainSneak:start()
    local radius = 20
    addSound(self.character, self.character:getX(), self.character:getY(), self.character:getZ(), radius, radius)
end

function ISTrainSneak:stop()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    ISBaseTimedAction.stop(self);
end

function ISTrainSneak:perform()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    ISBaseTimedAction.perform(self);
    local g = getPlayer():getPerkLevel(Perks.Sneak);
    getPlayer():getXp():AddXP(Perks.Sneak, 7.5 * (1 + g));
end

function ISTrainSneak:new(character, item, time)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character;
    o.item = item;
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.maxTime = time;
    return o;
end

--ФУНКЦИЯ ВЗЛОМАТЬ БАНКОМАТ
ISRobBank = ISBaseTimedAction:derive("ISRobBank");

function ISRobBank:isValid()
    return true;
end

function ISRobBank:update()
end

function ISRobBank:start()
    self.sound = self.character:playSound("TrashSearch");
    local radius = 20
    addSound(self.character, self.character:getX(), self.character:getY(), self.character:getZ(), radius, radius)
end

function ISRobBank:stop()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    ISBaseTimedAction.stop(self);
end

function ISRobBank:perform()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    ISBaseTimedAction.perform(self);
    local hackmoney = ZombRand(5)
    self.character:getInventory():Remove("CreditCard");
    if hackmoney == 4 then
        self.character:getInventory():AddItems("Base.Money", 10);
    elseif hackmoney == 3 or hackmoney == 2 then
        self.character:getInventory():AddItems("Base.Money", 7);
    else
        self.character:getInventory():AddItems("Base.Money", 5);
    end
end

function ISRobBank:new(character, item, time)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character;
    o.item = item;
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.maxTime = 950;
    return o;
end

--ПОИСК МИКРОСХЕМ
ISSearchChip = ISBaseTimedAction:derive("ISSearchChip");

function ISSearchChip:isValid()
    return self.character:getXp():getXP(Perks.MineEndurance) >= 45 and self.character:getStats():getEndurance() >= 0.1 and self.character:getStats():getFatigue() <= 0.8
end

function ISSearchChip:update()
    self.character:faceThisObjectAlt(self.item)
    if not self.character:getEmitter():isPlaying(self.sound) then
        self.sound = self.character:playSound("Things_Searching")
    end
end

function ISSearchChip:start()
    self:setActionAnim("Loot")
    self.character:SetVariable("LootPosition", "Low")
    self.sound = self.character:playSound("Things_Searching")
end

function ISSearchChip:stop()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    ISBaseTimedAction.stop(self);
end

function ISSearchChip:perform()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    ISBaseTimedAction.perform(self);
    self.character:getInventory():AddItem("NHM.Microchip");
    ChangeEnergyLevelWithSync(self.character, 3)
    self.character:getStats():setEndurance(self.character:getStats():getEndurance() - 0.15);
end

function ISSearchChip:new(character, item, time)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character;
    o.item = item;
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.maxTime = time;
    return o;
end

--ПОИСК ОБВЕСОВ
ISSearchObvjesy = ISBaseTimedAction:derive("ISSearchObvjesy");

function ISSearchObvjesy:isValid()
    return self.character:getXp():getXP(Perks.MineEndurance) >= 45 and self.character:getStats():getEndurance() >= 0.1 and self.character:getStats():getFatigue() <= 0.8
end

function ISSearchObvjesy:update()
    self.character:faceThisObjectAlt(self.item)
    if not self.character:getEmitter():isPlaying(self.sound) then
        self.sound = self.character:playSound("Things_Searching")
    end
end

function ISSearchObvjesy:start()
    self:setActionAnim("Loot")
    self.character:SetVariable("LootPosition", "")
    self.sound = self.character:playSound("Things_Searching")
end

function ISSearchObvjesy:stop()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    ISBaseTimedAction.stop(self);
end

function ISSearchObvjesy:perform()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    ISBaseTimedAction.perform(self);

    local isLoot = ZombRand(4)
    if isLoot ~= 1 then
        local loot = ZombRand(14)
        if loot == 1 then
            local loot_ = ZombRand(2)
            if loot_ == 1 then
                self.character:getInventory():AddItem("NHM.HandguardAR5");
            else
                self.character:getInventory():AddItem("NHM.HandguardAR6");
            end
        elseif loot == 2 then
            local loot_ = ZombRand(2)
            if loot_ == 1 then
                self.character:getInventory():AddItem("NHM.HandguardAK5");
            else
                self.character:getInventory():AddItem("NHM.HandguardAK6");
            end
        elseif loot == 3 then
            local loot_ = ZombRand(2)
            if loot_ == 1 then
                self.character:getInventory():AddItem("NHM.HandguardDSA5");
            else
                self.character:getInventory():AddItem("NHM.HandguardDSA6");
            end
        elseif loot == 4 then
            local loot_ = ZombRand(2)
            if loot_ == 1 then
                self.character:getInventory():AddItem("NHM.HandguardMK5");
            else
                self.character:getInventory():AddItem("NHM.HandguardMK6");
            end
        elseif loot == 5 then
            local loot_ = ZombRand(2)
            if loot_ == 1 then
                self.character:getInventory():AddItem("NHM.StockAR5");
            else
                self.character:getInventory():AddItem("NHM.StockAR6");
            end
        elseif loot == 6 then
            local loot_ = ZombRand(2)
            if loot_ == 1 then
                self.character:getInventory():AddItem("NHM.StockAK5");
            else
                self.character:getInventory():AddItem("NHM.StockAK6");
            end
        elseif loot == 7 then
            local loot_ = ZombRand(2)
            if loot_ == 1 then
                self.character:getInventory():AddItem("NHM.StockDSA5");
            else
                self.character:getInventory():AddItem("NHM.StockDSA6");
            end
        elseif loot == 8 then
            local loot_ = ZombRand(2)
            if loot_ == 1 then
                self.character:getInventory():AddItem("NHM.StockMK5");
            else
                self.character:getInventory():AddItem("NHM.StockMK6");
            end
        elseif loot == 9 then
            local loot_ = ZombRand(2)
            if loot_ == 1 then
                self.character:getInventory():AddItem("NHM.HandguardM1A3");
            else
                self.character:getInventory():AddItem("NHM.HandguardM1A4");
            end
        elseif loot == 10 then
            local loot_ = ZombRand(2)
            if loot_ == 1 then
                self.character:getInventory():AddItem("NHM.StockM1A3");
            else
                self.character:getInventory():AddItem("NHM.StockM1A4");
            end
        elseif loot == 11 then
            local loot_ = ZombRand(2)
            if loot_ == 1 then
                self.character:getInventory():AddItem("NHM.HandguardSVD3");
            else
                self.character:getInventory():AddItem("NHM.HandguardSVD4");
            end
        elseif loot == 12 then
            local loot_ = ZombRand(2)
            if loot_ == 1 then
                self.character:getInventory():AddItem("NHM.StockSVD3");
            else
                self.character:getInventory():AddItem("NHM.StockSVD4");
            end
        elseif loot == 13 then
            local loot_ = ZombRand(2)
            if loot_ == 1 then
                self.character:getInventory():AddItem("NHM.ForearmMOS3");
            else
                self.character:getInventory():AddItem("NHM.ForearmMOS4");
            end
        elseif loot == 14 then
            local loot_ = ZombRand(2)
            if loot_ == 1 then
                self.character:getInventory():AddItem("NHM.Forearm700M3");
            else
                self.character:getInventory():AddItem("NHM.Forearm700M4");
            end
        end
    end

    ChangeEnergyLevelWithSync(self.character, 5)
    self.character:getStats():setEndurance(self.character:getStats():getEndurance() - 0.15);
end

function ISSearchObvjesy:new(character, item, time)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character;
    o.item = item;
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.maxTime = time;
    return o;
end

--ЛАЗИТЬ КАНАЛИЗАЦИЯ
ISLuk = ISBaseTimedAction:derive("ISLuk");

function ISLuk:isValid()
    return true
end

function ISLuk:update()
    self.character:faceThisObjectAlt(self.tile)
end

function ISLuk:start()
end

function ISLuk:stop()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    ISBaseTimedAction.stop(self);
end

function ISLuk:perform()
    if self.sound then
        self.character:getEmitter():stopSound(self.sound)
        self.sound = nil
    end
    ISBaseTimedAction.perform(self);
    ebanie_cordinati.x = self.x
    ebanie_cordinati.y = self.y
    ebanie_cordinati.z = self.z
    Events.OnTick.Add(pornuxa)
end

function ISLuk:new(character, tile, x, y, z)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character;
    o.tile = tile;
    o.x = x
    o.y = y
    o.z = z
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.maxTime = 25;
    return o;
end

function pornuxa()
    print('goin ' .. ebanie_cordinati.x .. " " .. ebanie_cordinati.y .. " " .. ebanie_cordinati.z)
    getPlayer():setX(ebanie_cordinati.x)
    getPlayer():setY(ebanie_cordinati.y)
    getPlayer():setZ(ebanie_cordinati.z)
    getPlayer():setLx(ebanie_cordinati.x)
    getPlayer():setLy(ebanie_cordinati.y)
    getPlayer():setLz(ebanie_cordinati.z)
    Events.OnTick.Remove(pornuxa)
end