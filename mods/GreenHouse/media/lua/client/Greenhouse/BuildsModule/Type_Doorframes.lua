if not getGreenhouseInstance then
  require('Greenhouse/Greenhouse_Main')
end

local Greenhouse = getGreenhouseInstance()

Greenhouse.doorframesMenuBuilder = function(subMenu, player)
  local _sprite
  local _option
  local _tooltip
  local _name = ''

  Greenhouse.neededMaterials = {
    {
      Material = 'Base.Plank',
      Amount = 4
    },
    {
      Material = 'Base.Nails',
      Amount = 4
    }
  }

  Greenhouse.neededTools = {'Hammer'}

  local needSkills = {
    Woodwork = 4
  }

  local _doorframesData = Greenhouse.getdoorframesData()

  for _, _currentList in pairs(_doorframesData) do
    _sprite = {}
    _sprite.sprite = _currentList[2]
    _sprite.northSprite = _currentList[1]


    _name = _currentList[3]

    _option = subMenu:addOption(_name, nil, Greenhouse.onBuilddoorframes, _sprite, player, _name)

    _tooltip = Greenhouse.canBuildObject(needSkills, _option, player)
   
    _tooltip:setName(_name)
    _tooltip:setTexture(_sprite.sprite)
  end
end

Greenhouse.getdoorframesData = function()
  local _doorframesData = {
	{
      'walls_greenhouse_01_8',
	  'walls_greenhouse_01_9',
      getText('ContextMenu_White_Doorframe')
    },
	{
      'walls_greenhouse_01_10',
	  'walls_greenhouse_01_11',
      getText('ContextMenu_Brown_Doorframe')
    },
	{
      'walls_greenhouse_01_16',
	  'walls_greenhouse_01_17',
      getText('ContextMenu_Green_Doorframe')
    },
	{
      'walls_commercial_01_27',
	  'walls_commercial_01_26',
      getText('ContextMenu_Black_Doorframe')
    },
	{
      'walls_commercial_01_43',
	  'walls_commercial_01_42',
      getText('ContextMenu_WindowBlack_Doorframe')
    },
	{
      'walls_commercial_01_107',
	  'walls_commercial_01_106',
      getText('ContextMenu_Window_Doorframe')
    },
	
  }
  return _doorframesData
end


Greenhouse.onBuilddoorframes = function(ignoreThisArgument, sprite, player, name)
  local _doorFrame = ISWoodenDoorFrame:new(sprite.sprite, sprite.northSprite, sprite.corner)

  _doorFrame.modData['wallType'] = 'doorframe'
  _doorFrame.player = player
  _doorFrame.name = name

  _doorFrame.modData['need:Base.Plank'] = 2
  _doorFrame.modData['need:Base.Nails'] = 3
  _doorFrame.modData['xp:Woodwork'] = 5

  getCell():setDrag(_doorFrame, player)
end

