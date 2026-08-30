require "ISUI/ISCollapsableWindow"
require "ISUI/ISPanelJoypad"

ISCheckList = ISCollapsableWindow:derive("ISCheckList");

local FONT_HGT_M = getTextManager():getFontHeight(UIFont.Medium)

local toDO = require('toDO')
local toDOU = require('toDOutils')
local dateCount = 0

function ISCheckList:initialise()
  ISCollapsableWindow.initialise(self);

  self.panel = ISImage:new(0, self:titleBarHeight(), self.width-3, self.height-self:titleBarHeight(), getTexture("media/textures/listbackground.png"));
  self.panel:initialise();
  self.panel:instantiate();
  self.panel.target = self;
  self:addChild(self.panel);
  
  --self.panel = ISPanel:new(0, self:titleBarHeight(), self.width-3, self.height-self:titleBarHeight());
  --self.panel.backgroundColor = {r=0.98, g=0.953, b=0.882, a=1};
	--self.panel.borderColor = {r=0, g=0, b=0, a=1};
  --self:addChild(self.panel)

  local tx = getTextManager():MeasureStringX(UIFont.Medium, getText("UI_TitleList"))
  self.listName = ISLabel:new(self.width / 2 - tx / 2, (self:titleBarHeight()+(self.height*0.05))-(getTextManager():getFontHeight(UIFont.Medium)), getTextManager():getFontHeight(UIFont.Medium), getText("UI_TitleList"), 0, 0, 0, 1, UIFont.Medium, true)
  self.panel:addChild(self.listName)

  self.listbox = ISScrollingCheckListBox:new(0, self:titleBarHeight()+(self.height*0.1), (self.width-3), self.height-self:titleBarHeight()-(self.height*0.15));
  self.listbox:initialise();
  self.listbox:instantiate();
  self.listbox:setFont(UIFont.NewSmall, 2);
  --self.listbox.backgroundColor = {r=1, g=1, b=1, a=1};
  self.listbox.drawBorder = true;
  self.listbox.itemheight = 32
  --self.listbox.doDrawItem = ISCheckList.doDrawItemIcon;
  self.listbox:setVisible(false)
  self.panel:addChild(self.listbox);
  local ldate = nil;

  if #toDOU.getFindModData(toDO.playerObj) < 1 then
    local ttx = getTextManager():MeasureStringX(UIFont.Medium, getText("UI_noList"))
    self.notList = ISLabel:new((self.width / 2) - (ttx / 2), (self.height / 2) - (getTextManager():getFontHeight(UIFont.Medium) / 2), getTextManager():getFontHeight(UIFont.Medium), getText("UI_noList"), 0, 0, 0, 1, UIFont.Medium, true)
    self:addChild(self.notList)
    else
    self.listbox:setVisible(true)
    for i,v in ipairs(toDOU.getFindModData(toDO.playerObj)) do
      local sepIndex = string.find(v.text, "|")
      local date = string.sub(v.text, 1, sepIndex - 1)
      local text = string.sub(v.text, sepIndex + 1)

      if ldate ~= date then
        self.listbox:addItem(date, "date")
        dateCount = dateCount+1;
        self.listbox.dateCount = dateCount
        ldate = date
      end

      self.listbox:addItem(text, v.id)
    end
  end

  local b3 = ((self.width*0.09)*3) + 10
  local b2 = ((self.width*0.09)*2) + 10
  self.deleteButton = ISButton:new(self.width / 2 - b3 / 2, self.listName:getBottom() + 15, self.width*0.09, self.width*0.09, "", self, ISCheckList.onClick);
  self.deleteButton.internal = "DELETE";
  self.deleteButton:initialise();
  self.deleteButton.borderColor = {r=0, g=0, b=0, a=0};
  self.deleteButton.backgroundColor = {r=0.753, g=0.753, b=0.753, a=0};
  self.deleteButton.backgroundColorMouseOver.a = 1;
  self.deleteButton:setImage(getTexture("media/textures/delete.png"));
  self.deleteButton:forceImageSize(self.width*0.08, self.width*0.08);
  self.deleteButton.textColor.a = 0;
  self.deleteButton:setVisible(false)
  local bright = self.width / 2 - b2 / 2
  if isAdmin() or not isClient() then 
    self.deleteButton:setVisible(true) 
    bright = self.deleteButton:getRight()+5
  end
  self:addChild(self.deleteButton);

  self.checkButton = ISButton:new(bright, self.deleteButton:getY(), self.deleteButton.width, self.deleteButton.height, "", self, ISCheckList.onClick);
  self.checkButton.internal = "CHECK";
  self.checkButton:initialise();
  self.checkButton.borderColor = {r=0, g=0, b=0, a=0};
  self.checkButton.backgroundColor = {r=0.753, g=0.753, b=0.753, a=0};
  self.checkButton.backgroundColorMouseOver.a = 1;
  self.checkButton:setImage(getTexture("media/textures/check.png"));
  self.checkButton:forceImageSize(self.width*0.08, self.width*0.08);
  self.checkButton.textColor.a = 0;
  self:addChild(self.checkButton);

  self.writeButton = ISButton:new(self.checkButton:getRight()+5, self.deleteButton:getY(), self.deleteButton.width, self.deleteButton.height, "", self, ISCheckList.onClick);
  self.writeButton.internal = "WRITE";
  self.writeButton:initialise();
  self.writeButton.borderColor = {r=0, g=0, b=0, a=0};
  self.writeButton.backgroundColor = {r=0.753, g=0.753, b=0.753, a=0};
  self.writeButton.backgroundColorMouseOver.a = 1;
  self.writeButton:setImage(getTexture("media/textures/write.png"));
  self.writeButton:forceImageSize(self.width*0.08, self.width*0.08);
  self.writeButton.textColor.a = 0;
  self:addChild(self.writeButton);
  --[[
  self.sq = {}
  local y = 30
  for i = 1, 30 do
    self.sq[i] = ISImage:new(10, y, 20, 20, getTexture("media/textures/sq.png"));
    self.sq[i]:initialise();
    self.sq[i]:instantiate();
    self.sq[i].target = self;
    self.sq[i]:setColor(0,0,0)
    self:addChild(self.sq[i])
    y = y + 50
    if y > self.height then break end
  end]]
end

function ISCheckList:onClick(button)
	if button.internal == "CLOSE" then 
   self:setVisible(false)
   self:removeFromUIManager()
   toDO.CheckList = nil
  end

  if button.internal == "WRITE" then 
    local w = self.width * 0.5
    local h = self.height * 0.5
    local modal = ISCheckDialog:new(self:getX()+self.width/2 - w/2, self:getY()+self.height/ 2 - h/2, w, h, getText("IGUI_Map_AddNote"), true, self)
    modal:initialise()
    modal:setX(self:getX()+self.width/2 - modal.width/2)
    --self:addChild(modal)
    modal:addToUIManager()
  end

  if button.internal == "DELETE" then 
    local w = self.width * 0.5
    local h = self.height * 0.3
    local modal = ISModalDialog:new(self:getX()+self.width/2 - w/2, self:getY()+self.height/ 2 - h/2, w, h, getText("UI_worldscreen_deletesave"), true, self, ISCheckList.onClickDelete)
		modal:initialise()
    modal:setX(self:getX()+self.width/2 - modal.width/2)
		modal:addToUIManager()
  end

  if button.internal == "CHECK" then 
    local w = self.width * 0.5
    local h = self.height * 0.3
    local modal = ISModalDialog:new(self:getX()+self.width/2 - w/2, self:getY()+self.height/ 2 - h/2, w, h, getText("UI_worldscreen_deletesave"), true, self, ISCheckList.onClickCheck)
		modal:initialise()
    modal:setX(self:getX()+self.width/2 - modal.width/2)
		modal:addToUIManager()
  end

	if self.onclick ~= nil then
		button.player = self.player;
		self.onclick(self.target, button, self.max);
	end
end

function ISCheckList:onClickDelete(button)
	if button.internal == "YES" then 
    ModData.remove("SharedTDL")
    ModData.transmit("SharedTDL")
    self.listbox:clear()
    if self.notList then 
      self.notList:setVisible(false)
      self.notList:removeFromUIManager()
    end
    self.listbox:setVisible(false)
    local ttx = getTextManager():MeasureStringX(UIFont.Medium, getText("UI_noList"))
    self.notList = ISLabel:new((self.width / 2) - (ttx / 2), (self.height / 2) - (getTextManager():getFontHeight(UIFont.Medium) / 2), getTextManager():getFontHeight(UIFont.Medium), getText("UI_noList"), 0, 0, 0, 1, UIFont.Medium, true)
    self:addChild(self.notList)
    toDOU.delete(toDO.playerObj)
  end
end

function ISCheckList:onClickCheck(button)
	if button.internal == "YES" then 
    for i=self.listbox.count, 1, -1 do
      local idx = toDOU.findItemByIndex(toDOU.getFindModData(toDO.playerObj), self.listbox.items[i].item)
      if idx ~= 0 and toDOU.getFindModData(toDO.playerObj) and toDOU.getFindModData(toDO.playerObj)[idx].check then
          local sepIndex = string.find(toDOU.getFindModData(toDO.playerObj)[idx].text, " : ")
          local UserName = string.sub(toDOU.getFindModData(toDO.playerObj)[idx].text, 1, sepIndex - 1)

          local sepIndex2 = string.find(UserName, "|")
          local UserName2 = string.sub(UserName, sepIndex2 + 1)
          local characterName = toDOU.getPlayerName(toDO.playerObj)

          if UserName2 == characterName or isAdmin() then
            self.listbox:removeItemId(toDOU.getFindModData(toDO.playerObj)[idx].check)
            toDOU.removeItemById(toDOU.getFindModData(toDO.playerObj), toDOU.getFindModData(toDO.playerObj)[idx].check)
          end
      end
    end
    ModData.transmit("SharedTDL")
    toDOU.refresh(toDO.playerObj, "false")
  end
end

function ISCheckList:doDrawItemIcon(y, itemlist, alt)
  if y + self:getYScroll() + self.itemheight < 0 or y + self:getYScroll() >= self.height then
    return y + self.itemheight
  end

  local r,g,b = 0,0,0;
  if self.selected == itemlist.index then
    self:drawRect(0, (y), self:getWidth(), itemlist.height-1, 0.3, 0.7, 0.35, 0.15);
  end

	self:drawRectBorder(0, (y), self:getWidth(), itemlist.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
	local itemPadY = self.itemPadY or (itemlist.height - self.fontHgt) / 2
  local fontY = 26 - (getTextManager():getFontHeight(UIFont.Medium)/2)
	self:drawText(itemlist.text, 62, (y+fontY), r, g, b, 1, UIFont.Medium);
  local tex = getTexture("media/textures/cicon.png")

  if tex then 
    self:drawTextureScaledAspect(tex, 10, (y+10), 32, 32,  1, 1, 1, 1); 
  end

  return y + self.itemheight;
end

function ISCheckList:new(x, y, width, height, playerNum)
	local o = ISCollapsableWindow.new(self, x, y, width, height);
  setmetatable(o, self);
  self.__index = self;
  self.listName = {}
  self.TickBox = {}
  o.showBackground = true;
	o.showBorder = true;
	o.backgroundColor = {r=0, g=0, b=0, a=1};
	o.borderColor = {r=0.4, g=0.4, b=0.4, a=0};
  --o.title = "TO DO LIST";
  o.playerNum = playerNum;
  o.moveWithMouse = true;
  o:setResizable(false);
	o:setDrawFrame(true);
  ISCheckList.instance = o;
return o;
end

