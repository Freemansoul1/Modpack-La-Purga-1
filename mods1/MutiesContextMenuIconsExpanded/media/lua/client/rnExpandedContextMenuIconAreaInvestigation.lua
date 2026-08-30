local originalInvestigateAreaMenu = ISSearchWindow.OnFillWorldObjectContextMenu;

function ISSearchWindow.OnFillWorldObjectContextMenu(player, context)
    if not context then return context end
    if type(context) ~= "table" then return context end
    local showOption = context:getOptionFromName(getText("UI_investigate_area_window_show"));
    if showOption then
        showOption.iconTexture = getTexture(getExpandedIconPath("InvestigateArea.png"));
    end
    
    local hideOption = context:getOptionFromName(getText("UI_investigate_area_window_hide"));
    if hideOption then
        hideOption.iconTexture = getTexture(getExpandedIconPath("StopInvestigateArea.png"));
    end
end

--[[
local originalStopInvestigateAreaMenu = ISWorldObjectContextMenu.createMenu;

function ISWorldObjectContextMenu.createMenu(player, isInPlayerInventory, items, x, y, origin)
    local context = originalStopInvestigateAreaMenu(player, isInPlayerInventory, items, x, y, origin);
    if not context then return context end
    if type(context) ~= "table" then return context end
    local option = context:getOptionFromName(getText("UI_investigate_area_window_hide"));
    if not option then return context end
    option.iconTexture = getTexture("media/ui/icons/Expanded/StopInvestigateArea.png");
    return context;
end

local originalInvestigateAreaMenu = ISSearchWindow.OnFillWorldObjectContextMenu;

function ISSearchWindow.OnFillWorldObjectContextMenu(player, context)
    if not context then return context end
    if type(context) ~= "table" then return context end
    local option = context:getOptionFromName(getText("UI_investigate_area_window_show"));
    if not option then return context end
    option.iconTexture = getTexture("media/ui/icons/Expanded/InvestigateArea.png");
    return context;
end

     ⣤⢶⣻⣿⣻⣿⣿⣿⣿⣿⣿⣦⣤⣀
⠀⠀⠀⣼⣺⢷⣻⣽⣾⣿⢿⣿⣷⣿⣿⢿⣿⣿⣿⣇
⠀⠠⡍⢾⣺⢽⡳⣻⡺⣽⢝⢗⢯⣻⢽⣻⣿⣿⣿⢿⡄
⡨⣖⢹⠜⢅⢫⢊⢎⠜⢌⠣⢑⠡⣹⡸⣜⣯⣿⢿⣻⣷
⢜⢔⡹⡭⣪⢼⠽⠷⠧⣳⢘⢔⡝⠾⠽⢿⣷⣿⣟⢷⣟
⢸⢘⢼⠿⠟⠁⠀⠀⠀⡀⠃⠑⡌⠀⠀⠀⠈⠙⠿⣷⢽⣻
⢌⠂⠅⠀⠀⠀⠀⠀⠀⡀⣲⣢⢂⠀⠀⠀⠀⠀⠀⠈⣯⠏
⠐⠨⡂⠀⠀⠀⠀⠀⡀⡔⠋⢻⣤⡀⠀⠀⠀⠀⠀⢸⣯⠇
⠈⣕⠝⠒⠀⠀⠒⢉⠪⠀⠀⠀⢿⠜⠑⠢⠠⡒⡺⣿⠖
⠀⠐⠅⠁⡀⠀⠐⢔⠁⠀⠀⠀⢀⢇⢌⠀⠀⠀⠸⠕
⠀⠀⠂⠀⠀⠨⣔⡝⠼⡄⠂⣦⡆⣿⣲⠐⠑⠁⠀⠃
⠀⠀⠀⠀⠀⠀⠃⢫⢛⣙⡊⣜⣏⡝⣝⠆
⠀⠀⠀⠀⠀⠀⠀⠈⠈⠁⠁⠁⠈⠈⠊
--]]