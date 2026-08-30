-- By 🆂🅲🆁🅸🅱🅻
-- Discord: scribl

-- Я не против если вы будете исследовать мои модификации. Не копируйте модификацию!
-- I don't mind if you explore my modifications. Do not copy the modification!

--AntiCheatProtectionType2 - Teleports
--AntiCheatProtectionType12 - Ghost Mode

if isServer() then return; end

SC_GloomyPlaceReload = SC_GloomyPlaceReload or require("SC_GloomyPlace_Class"):new();
SC_GloomyPlaceReload.Backup = SC_GloomyPlaceReload.Backup or {};
SC_GloomyPlaceReload.isTeleportActive = false;
SC_GloomyPlaceReload.ShopsAndTraders_Utils = nil;

LuaEventManager.AddEvent('SCGPROnTeleportFailedReturnWallets');
LuaEventManager.AddEvent('SCGPROnTeleportSetVisibility');

Events.LoadGridsquare.Add(function(sq) SC_GloomyPlaceReload:LoadGridsquare(sq); end);
Events.onLoadModDataFromServer.Add(function(sq) SC_GloomyPlaceReload:onLoadModDataFromServer(sq); end);

function SC_GloomyPlaceReload.SCGPROnTeleportFailedReturnWallets()
    if not SandboxVars.SCGloomyPlaceReload.ShopAndTraderIntergration then return; end
    if not SC_GloomyPlaceReload.Backup.payFromInventory and SandboxVars.ShopsAndTraders.PlayerWallets then
        sendClientCommand("shop", "transferFunds", {playerWalletID=getPlayer():getModData().wallet_UUID, amount = SC_GloomyPlaceReload.Backup.costPassage})
        return;
    end
    local moneyTypes = SC_GloomyPlaceReload.ShopsAndTraders_Utils.getMoneyTypes();
    local moneyItem = InventoryItemFactory.CreateItem(moneyTypes[ZombRand(#moneyTypes)+1])
    SC_GloomyPlaceReload.ShopsAndTraders_Utils.generateMoneyValue_clientWorkAround(money, SC_GloomyPlaceReload.Backup.costPassage, true)
    getPlayer():getInventory():AddItem(money)
    SC_GloomyPlaceReload.Backup.costPassage = 0;
    SC_GloomyPlaceReload.Backup.payFromInventory = nil
end
Events.SCGPROnTeleportFailedReturnWallets.Add(SC_GloomyPlaceReload.SCGPROnTeleportFailedReturnWallets);

function SC_GloomyPlaceReload.SCGPROnTeleportSetVisibility(character, value)
    if not SandboxVars.SCGloomyPlaceReload.EnableGhostMode then return; end
    character:setGhostMode(value);
    character:setInvincible(value);
end
Events.SCGPROnTeleportSetVisibility.Add(SC_GloomyPlaceReload.SCGPROnTeleportSetVisibility);

function SC_GloomyPlaceReload.onConfirmRemoveBoard(sthis, btn, sq)
    if btn.internal ~= "YES" then return; end
    SC_GloomyPlaceReload.Modal = nil;
    local GPR_ModData = sq:getModData()[SC_GloomyPlaceReload.moduleName];
    local p = getPlayer();
    local point_one = { x = GPR_ModData.toX, y = GPR_ModData.toY, z = GPR_ModData.toZ };
    local point_two = { x = GPR_ModData.x, y = GPR_ModData.y, z = GPR_ModData.z };
    SC_GloomyPlaceReload.BackupCoords();
    SC_GloomyPlaceReload.TeleportTo(p, point_one);
    local ticks = 0;
    local function DELAY_DST()
        if ticks < SandboxVars.SCGloomyPlaceReload.DelayAdminCreate then ticks = ticks + 1; return; end
        SC_GloomyPlaceReload:setTeleport(point_one, true);
        Events.OnTick.Remove(DELAY_DST);
        SC_GloomyPlaceReload.TeleportTo(p, point_two);
        local ticks = 0;
        local function DELAY_SRC()
            if ticks < SandboxVars.SCGloomyPlaceReload.DelayAdminCreate then ticks = ticks + 1; return; end
            SC_GloomyPlaceReload:setTeleport(point_two, true);
            Events.OnTick.Remove(DELAY_SRC);
            SC_GloomyPlaceReload.TeleportTo(p, SC_GloomyPlaceReload.Backup);
        end
        Events.OnTick.Add(DELAY_SRC);
    end
    Events.OnTick.Add(DELAY_DST);
end

function SC_GloomyPlaceReload.BackupCoords(coords)
    if not coords then
        local p = getPlayer();
        SC_GloomyPlaceReload.Backup.x = p:getX();
        SC_GloomyPlaceReload.Backup.y = p:getY();
        SC_GloomyPlaceReload.Backup.z = p:getZ();
        return;
    end
    SC_GloomyPlaceReload.Backup.x = coords.x;
    SC_GloomyPlaceReload.Backup.y = coords.y;
    SC_GloomyPlaceReload.Backup.z = coords.z;
end

function SC_GloomyPlaceReload.RemoveDialog(worldobjects,player, sq)
    SC_GloomyPlaceReload.Modal = ISModalDialog:new(getCore():getScreenWidth() / 2 - 350/2,getCore():getScreenHeight() / 2 - 75, 350, 150, getText("UI_GPRConfirmRemove"), true, self, SC_GloomyPlaceReload.onConfirmRemoveBoard, player, sq);
    SC_GloomyPlaceReload.Modal:initialise();
    SC_GloomyPlaceReload.Modal:addToUIManager();
end

function SC_GloomyPlaceReload.EditTeleport(worldobjects,player, GPR_ModData)
    SC_GloomyPlaceReload.Edit = ISGloomyPlaceEdit:new(GPR_ModData);
    SC_GloomyPlaceReload.Edit:initialise();
    SC_GloomyPlaceReload.Edit:addToUIManager();
end

function SC_GloomyPlaceReload.TeleportTo(p, coords)
    p:setX(coords.x + 0.5);
    p:setY(coords.y + 0.5);
    p:setZ(coords.z);
    p:setLx(coords.x + 0.5);
    p:setLy(coords.y + 0.5);
    p:setLz(coords.z);
end

function SC_GloomyPlaceReload.Delete(WorldObjects, sq)
    sq:getModData()[SC_GloomyPlaceReload.moduleName] = nil;
    sq:transmitModdata();
end

function SC_GloomyPlaceReload.TimedAction(WorldObjects, playerIndex, sq, costPassage)
    local GPR_ModData = sq:getModData()[SC_GloomyPlaceReload.moduleName];
    local player = getSpecificPlayer(playerIndex)
    
    
    SC_GloomyPlaceReload.BackupCoords(GPR_ModData);
    if costPassage then
        SC_GloomyPlaceReload.Backup.costPassage = costPassage;
        local moneyTypes = SC_GloomyPlaceReload.ShopsAndTraders_Utils.getMoneyTypes();
        local playerInv = player:getInventory();
        local isMoneyInInvetory = true;
        local isTookMoney = false;
        --[[for _, val in pairs(moneyTypes) do
            local itemCheakMoney = InventoryItemFactory.CreateItem(val)
            if playerInv:contains(itemCheakMoney) then
                isMoneyInInvetory = true;
                break;
            end
        end
        isMoneyInInvetory = true;]]--
        if isMoneyInInvetory then
            for i = 0, playerInv:getItems():size() - 1, 1 do
                local item = playerInv:getItems():get(i);
                if item and SC_GloomyPlaceReload.ShopsAndTraders_Utils.isMoneyType(item:getFullType()) and item:getModData() and item:getModData().value > costPassage then
                    local newValue = item:getModData().value - costPassage;
                    if newValue > 0 then
                        generateMoneyValue(item, newValue, true);
                        --item:getModData().value = newValue;
                        --item:setName(SC_GloomyPlaceReload.ShopsAndTraders_Utils.numToCurrency(newValue));
                    else
                        item:getContainer():Remove(item);
                    end
                    isTookMoney = true;
                    SC_GloomyPlaceReload.Backup.payFromInventory = true;
                end
            end
        end
        if SandboxVars.ShopsAndTraders.PlayerWallets and not isTookMoney then
            local wallet, walletBalance = getWallet(player), -1;
            if wallet then walletBalance = wallet.amount; end
            walletBalance = walletBalance - costPassage;
            if walletBalance < 0 then
                player:Say(getText("UI_GPRPaidNoMoney"));
                return;
            end
            isTookMoney = true;
            SC_GloomyPlaceReload.Backup.payFromInventory = false;
            sendClientCommand("shop", "transferFunds", {playerWalletID=player:getModData().wallet_UUID, amount=(0-costPassage)})
        end

        if not isTookMoney then
            player:Say(getText("UI_GPRPaidNoMoney"));
            return;
        end
    end
    
    if luautils.walkAdj(player, sq) then
        -- (character, coords, anode, akey, avar, sound, isAnim, isSound)
        ISTimedActionQueue.add(ISGloomyPlaceSignIn:new(player, { x = GPR_ModData.toX, y = GPR_ModData.toY, z = GPR_ModData.toZ }, GPR_ModData.anode, GPR_ModData.akey, GPR_ModData.avar, GPR_ModData.sound, GPR_ModData.isAnim, GPR_ModData.isSound, GPR_ModData.timedaction ));
    end
end

function SC_GloomyPlaceReload.SignIn(coords)
    local p = getPlayer();
    if SandboxVars.SCGloomyPlaceReload.SayStatus then
        p:Say(getText("UI_GPRStatusStartAction"));
    end
    SC_GloomyPlaceReload.isTeleportActive = true;
    SC_GloomyPlaceReload.isGhostMode = p:isGhostMode();
    local ticks = 0;
    local subTicks = 0;

    triggerEvent("SCGPROnTeleportSetVisibility", p, true)
    
    local function onTickSignIn()
        if ticks < 2 then
            ticks = ticks + 1;
            return;
        end
        Events.OnTick.Remove(onTickSignIn);

        SC_GloomyPlaceReload.TeleportTo(p, coords);
        ticks = 0;
        local function IsTreatAsSolidFloor()
            ticks = ticks + 1
            if ticks < SandboxVars.SCGloomyPlaceReload.DelayIsTreatAsSolidFloor then return; end
            local square = getSquare(coords.x, coords.y, coords.z);
            if not square or not square:TreatAsSolidFloor() then
                SC_GloomyPlaceReload.TeleportTo(p, SC_GloomyPlaceReload.Backup);
                SC_GloomyPlaceReload:sendLogs(true, { x = SC_GloomyPlaceReload.Backup.x, y = SC_GloomyPlaceReload.Backup.y, z = SC_GloomyPlaceReload.Backup.z, toX = coords.x, toY = coords.y, toZ = coords.z });
                p:Say(getText("UI_GPRErrorLoadSQLevel"));
                triggerEvent("SCGPROnTeleportFailedReturnWallets");
                triggerEvent("SCGPROnTeleportSetVisibility", p, SC_GloomyPlaceReload.isGhostMode)
                SC_GloomyPlaceReload.isTeleportActive = false;
                Events.OnTick.Remove(IsTreatAsSolidFloor);
                return;
            end
            Events.OnTick.Remove(IsTreatAsSolidFloor);
            SC_GloomyPlaceReload:sendLogs(false, { x = SC_GloomyPlaceReload.Backup.x, y = SC_GloomyPlaceReload.Backup.y, z = SC_GloomyPlaceReload.Backup.z, toX = coords.x, toY = coords.y, toZ = coords.z });
            local function onTickDelayGhostMode()
                if subTicks < SandboxVars.SCGloomyPlaceReload.DelayGhostMode then
                    subTicks = subTicks + 1;
                    return;
                end
                Events.OnTick.Remove(onTickDelayGhostMode);
                SC_GloomyPlaceReload.isTeleportActive = false;
                if SandboxVars.SCGloomyPlaceReload.SayStatus then p:Say(getText("UI_GPRStatusEndAction")); end
                triggerEvent("SCGPROnTeleportSetVisibility", p, SC_GloomyPlaceReload.isGhostMode)
            end
            Events.OnTick.Add(onTickDelayGhostMode);
        end

        local function IsForceZPosition()
            ticks = ticks + 1
            if ticks < SandboxVars.SCGloomyPlaceReload.DelayDifferentHeights then
                p:setZ(coords.z);
                p:setbFalling(false);
                p:setFallTime(0);
                p:setLastFallSpeed(0);
            else
                local sq = getSquare(coords.x, coords.y, coords.z);
                if not sq or not sq:TreatAsSolidFloor() then
                    SC_GloomyPlaceReload.TeleportTo(p, SC_GloomyPlaceReload.Backup);
                    SC_GloomyPlaceReload:sendLogs(true, { x = SC_GloomyPlaceReload.Backup.x, y = SC_GloomyPlaceReload.Backup.y, z = SC_GloomyPlaceReload.Backup.z, toX = coords.x, toY = coords.y, toZ = coords.z });
                    p:Say(getText("UI_GPRErrorLoadLevel"));
                    triggerEvent("SCGPROnTeleportFailedReturnWallets");
                    triggerEvent("SCGPROnTeleportSetVisibility", p, SC_GloomyPlaceReload.isGhostMode)
                    SC_GloomyPlaceReload.isTeleportActive = false;
                    Events.OnTick.Remove(IsForceZPosition);
                    return;
                end
                Events.OnTick.Remove(IsForceZPosition);
                SC_GloomyPlaceReload:sendLogs(false, { x = SC_GloomyPlaceReload.Backup.x, y = SC_GloomyPlaceReload.Backup.y, z = SC_GloomyPlaceReload.Backup.z, toX = coords.x, toY = coords.y, toZ = coords.z });
                local function onTickDelayGhostMode()
                    if subTicks < SandboxVars.SCGloomyPlaceReload.DelayGhostMode then
                        subTicks = subTicks + 1;
                        return;
                    end
                    Events.OnTick.Remove(onTickDelayGhostMode);
                    SC_GloomyPlaceReload.isTeleportActive = false;
                    if SandboxVars.SCGloomyPlaceReload.SayStatus then p:Say(getText("UI_GPRStatusEndAction")); end
                    triggerEvent("SCGPROnTeleportSetVisibility", p, SC_GloomyPlaceReload.isGhostMode)
                end
                Events.OnTick.Add(onTickDelayGhostMode);
            end
        end
        if coords.z >= 1 then
            Events.OnTick.Add(IsForceZPosition);
            return;
        end
        Events.OnTick.Add(IsTreatAsSolidFloor);
    end
    Events.OnTick.Add(onTickSignIn);
end


function SC_GloomyPlaceReload.ShowCreateMenu()
    SC_GloomyPlaceReload.UI = ISGloomyPlaceCreate:new();
    SC_GloomyPlaceReload.UI:initialise();
    SC_GloomyPlaceReload.UI:show();
end

function SC_GloomyPlaceReload.ContextMenu(playerIndex, Context, WorldObjects, test)
    if not SandboxVars.SCGloomyPlaceReload.Enable then return; end
    local sq, teleportsSubMenu, teleportsOptions = nil, nil, nil;
    for i,v in ipairs(WorldObjects) do
        sq = v:getSquare();
        if sq then
            break;
        end
    end
    local GPR_ModData = sq:getModData()[SC_GloomyPlaceReload.moduleName];
    if isAdmin() then
        teleportsOptions = Context:addOption(getText("ContextMenu_SCGPRMenu"), WorldObjects, nil)
        teleportsOptions.iconTexture = getTexture("media/ui/SC_GloomyPlace_ContextMenu.png");
        teleportsSubMenu = Context:getNew(Context)
        Context:addSubMenu(teleportsOptions, teleportsSubMenu);
        local create = teleportsSubMenu:addOption(getText("ContextMenu_SCGPRCreate"), WorldObjects, SC_GloomyPlaceReload.ShowCreateMenu);
        create.iconTexture = getTexture("media/ui/SC_GloomyPlace_ContextMenu.png");
    end
    if GPR_ModData then
        local text = "";
        if not SandboxVars.SCGloomyPlaceReload.DistinguishBetweenEntrancesAndExits then
            text = getText("ContextMenu_SCGPRSharedEE");
        else
            if GPR_ModData.isEnter then
                text = getText("ContextMenu_SCGPREnter");
            else
                text = getText("ContextMenu_SCGPRExit");
            end
        end
        if not SC_GloomyPlaceReload.isTeleportActive then
            if GPR_ModData.isPayToGo and SandboxVars.SCGloomyPlaceReload.ShopAndTraderIntergration then
                SC_GloomyPlaceReload.ShopsAndTraders_Utils = SC_GloomyPlaceReload.ShopsAndTraders_Utils or require "shop-shared";
                text = text.." [ "..SC_GloomyPlaceReload.ShopsAndTraders_Utils.numToCurrency(GPR_ModData.costPassage).. "]";
                local useTeleport = Context:addOption(text, WorldObjects, SC_GloomyPlaceReload.TimedAction, playerIndex, sq, GPR_ModData.costPassage);
                useTeleport.iconTexture = getTexture("media/ui/SC_GloomyPlace_ContextMenu.png");
            else
                local useTeleport = Context:addOption(text, WorldObjects, SC_GloomyPlaceReload.TimedAction, playerIndex, sq);
                useTeleport.iconTexture = getTexture("media/ui/SC_GloomyPlace_ContextMenu.png");
            end
        end
        if isAdmin() then
            local edit = teleportsSubMenu:addOption(getText("ContextMenu_SCGPREdit"), WorldObjects, SC_GloomyPlaceReload.EditTeleport, playerIndex, GPR_ModData);
            edit.iconTexture = getTexture("media/ui/SC_GloomyPlace_ContextMenu.png");
            local delete = teleportsSubMenu:addOption(getText("ContextMenu_SCGPRRemove"), WorldObjects, SC_GloomyPlaceReload.RemoveDialog, playerIndex, sq);
            delete.iconTexture = getTexture("media/ui/SC_GloomyPlace_ContextMenu.png");
            --for _key,val in pairs(GPR_ModData) do
            --    print(" GPR_ = ",_key,val)
            --end
        end
    end


end

Events.OnFillWorldObjectContextMenu.Add(SC_GloomyPlaceReload.ContextMenu);