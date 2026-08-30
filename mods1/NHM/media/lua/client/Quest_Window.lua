QuestWindow = ISCollapsableWindow:derive("QuestWindow");
QuestWindow.compassLines = {}

function QuestWindow:initialise()
	ISCollapsableWindow.initialise(self);
end

function QuestWindow:new(x, y, width, height)
	local o = {};
	o = ISCollapsableWindow:new(x, y, width, height);
	setmetatable(o, self);
	self.__index = self;
	o.title = getText("UI_QuestWindow");
	o.pin = false;
	o:noBackground();
	o.anchorLeft = true;
	return o;
end

function QuestWindow:setText(newText)
	QuestWindow.HomeWindow.text = newText;
	QuestWindow.HomeWindow:paginate();
end

function QuestWindow:createChildren()
	ISCollapsableWindow.createChildren(self);
	self.HomeWindow = ISRichTextPanel:new(0, 16, 500, 600);
	self.HomeWindow:initialise();
	self.HomeWindow.autosetheight = false;
	self.HomeWindow:ignoreHeightChange()
	self:addChild(self.HomeWindow)
end

function CreateQuestWindow()
	QuestWindow = QuestWindow:new(100, 100, 500, 600)
	QuestWindow:addToUIManager();
	QuestWindow:setVisible(false);
	QuestWindow.pin = true;
	QuestWindow.autosetheight = true;
	QuestWindow.resizable = false;
end


Events.OnGameStart.Add(CreateQuestWindow);