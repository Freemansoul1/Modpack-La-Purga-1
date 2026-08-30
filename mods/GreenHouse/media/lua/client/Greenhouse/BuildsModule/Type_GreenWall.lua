if not getGreenhouseInstance then
  require('Greenhouse/Greenhouse_Main')
end

local Greenhouse = getGreenhouseInstance()

Greenhouse.wallsGreenMenuBuilder = function(subMenu, player)
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
      Material = 'Base.Screws',
      Amount = 4
    },
    {
      Material = 'ImprovisedGlass.GlassPane',
      Amount = 1
    }
  }

  Greenhouse.neededTools = {'Hammer'}

local needSkills = {
    Woodwork = Greenhouse.skillLevel.wallObject
  }

  local _wallsGreenData = Greenhouse.getwallsGreenData()

  for _, _currentList in pairs(_wallsGreenData) do
    _sprite = {}
    _sprite.sprite = _currentList[1]
    _sprite.northSprite = _currentList[2]


    _name = _currentList[3]

    _option = subMenu:addOption(_name, nil, Greenhouse.onBuildwallsGreen, _sprite, player, _name)

    _tooltip = Greenhouse.canBuildObject(needSkills, _option, player)
    --_tooltip.description = _currentList[6] .. _tooltip.description
    _tooltip:setName(_name)
    _tooltip:setTexture(_sprite.sprite)
  end
end

Greenhouse.getwallsGreenData = function()
  local _wallsGreenData = {

	{
      'walls_greenhouse_01_21',
      'walls_greenhouse_01_18',
      getText('ContextMenu_Left_Side')
    },
	{
      'walls_greenhouse_01_22',
      'walls_greenhouse_01_19',
      getText('ContextMenu_Center')
    },
	{
      'walls_greenhouse_01_23',
      'walls_greenhouse_01_20',
      getText('ContextMenu_Right_Side')
    },
	{
      'walls_greenhouse_01_25',
      'walls_greenhouse_01_24',
      getText('ContextMenu_Single')	  
    },

	
  }
  return _wallsGreenData
end


Greenhouse.onBuildwallsGreen = function(ignoreThisArgument, sprite, player, name)
  local _window = ISWindowWallObj:new(sprite.sprite, sprite.northSprite, getSpecificPlayer(player))

  _window.player = player
  _window.name = name

  _window.modData['need:Base.Plank'] = 4  
  _window.modData['need:ImprovisedGlass.GlassPane'] = 1
  _window.modData['need:Base.Screws'] = 4
  _window.modData['xp:Woodwork'] = 15

  getCell():setDrag(_window, player)
end

