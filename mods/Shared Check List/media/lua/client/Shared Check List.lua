local toDO = require('toDO')
local toDOU = require('toDOutils')

local function CheckList_OnPlayerUpdate(character)
    if character and not toDO.CheckListIcon and ISEquippedItem.instance then 
        toDO.playerObj = character 
        local x = ISEquippedItem.instance:getX() + 5
        local y = ISEquippedItem.instance:getHeight() + 25;
        local CheckListIcon = getTexture("media/textures/checkListIcon.png");
        if isAdmin() then y = y + CheckListIcon:getHeightOrig() end
        toDO.CheckListIcon = ISImage:new(x, y, CheckListIcon:getWidthOrig(), CheckListIcon:getHeightOrig(), CheckListIcon);
        toDO.CheckListIcon:initialise();
        toDO.CheckListIcon:instantiate();
        toDO.CheckListIcon.onclick = CheckList_onDownCheckListIcon;
        toDO.CheckListIcon.target = self;
        toDO.CheckListIcon:addToUIManager()
    end
    if isKeyPressed(Keyboard.KEY_A) then
      if character then print(getSteamProfileNameFromUsername(character:getUsername())) end
    end
end

Events.OnPlayerUpdate.Add(CheckList_OnPlayerUpdate)


function CheckList_onDownCheckListIcon()
    if toDO.playerObj then
        if not toDO.CheckList then
          ModData.request("SharedTDL")
          if not ModData.exists("SharedTDL") then
            ModData.add("SharedTDL", {
                notFaction = {},
                Faction = {}
            })
            ModData.transmit("SharedTDL")
          end
          toDOU.playOpenSound()
          local w = 230
          local h = 360
          local x = (getCore():getScreenWidth() / 2) - (w / 2)
          local y = (getCore():getScreenHeight() / 2) - (h / 2)
          --ModData.remove("SharedTDL")
          --ModData.transmit("SharedTDL")
          toDO.CheckList = ISCheckList:new(x, y, w, h, toDO.playerObj:getPlayerNum())
          toDO.CheckList:initialise()
          toDO.CheckList:addToUIManager()
          else
            toDO.CheckList:setVisible(false)
            toDO.CheckList:removeFromUIManager()
            toDO.CheckList = nil
        end
    end
end


local function CheckList_onReceiveGlobalModData(module, packet)
    if not string.find(module, "SharedTDL") or not packet then
      return
    end
    if not isClient() then
      return
    end
    ModData.add(module, packet)
end

Events.OnReceiveGlobalModData.Add(CheckList_onReceiveGlobalModData);


function CheckList_OnServerCommand(module, command, args)
  if not isClient() then return end
  if module ~= "SharedTDL" then         
      return
  end

  if command == "DELETE" and toDO.CheckList and toDO.CheckList:isVisible() then
    ModData.remove("SharedTDL")
    ModData.transmit("SharedTDL")
    toDO.CheckList.listbox:clear()
    if toDO.CheckList.notList then 
      toDO.CheckList.notList:setVisible(false)
      toDO.CheckList.notList:removeFromUIManager()
    end
    toDO.CheckList.listbox:setVisible(false)
    local ttx = getTextManager():MeasureStringX(UIFont.Medium, getText("UI_noList"))
    toDO.CheckList.notList = ISLabel:new((toDO.CheckList.width / 2) - (ttx / 2), (toDO.CheckList.height / 2) - (getTextManager():getFontHeight(UIFont.Medium) / 2), getTextManager():getFontHeight(UIFont.Medium), getText("UI_noList"), 0, 0, 0, 1, UIFont.Medium, true)
    toDO.CheckList:addChild(toDO.CheckList.notList)
  end

  if command == "REFRESH" and toDO.CheckList and toDO.CheckList:isVisible() then
    if ModData.exists("SharedTDL") then
      ModData.request("SharedTDL")
      if args["check"] == "true" then return end
      toDO.CheckList.listbox:clear()
      if #toDOU.getFindModData(toDO.playerObj) > 0 then
        toDO.CheckList.listbox:setVisible(true)
       else toDO.CheckList.listbox:setVisible(false)
      end
      local ldate = nil
      for i,v in ipairs(toDOU.getFindModData(toDO.playerObj)) do
        local sepIndex = string.find(v.text, "|")
        local date = string.sub(v.text, 1, sepIndex - 1)
        local text = string.sub(v.text, sepIndex + 1)
  
        if ldate ~= date then
          toDO.CheckList.listbox:addItem(date, "date")
          toDO.CheckList.listbox.dateCount = toDO.CheckList.listbox.dateCount+1;
          ldate = date
        end
  
        toDO.CheckList.listbox:addItem(text, v.id)
      end
    end
  end

end

Events.OnServerCommand.Add(CheckList_OnServerCommand)


local function CheckList_onLoad()
  ModData.request("SharedTDL")
end
 
 Events.OnLoad.Add(CheckList_onLoad);
