if not getGreenhouseInstance then
  require('Greenhouse/Greenhouse_Main')
end

local Greenhouse = getGreenhouseInstance()

Greenhouse.wallsWhiteMenuBuilder = function(subMenu, player)
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

  local _wallsWhiteData = Greenhouse.getwallsWhiteData()

  for _, _currentList in pairs(_wallsWhiteData) do
    _sprite = {}
    _sprite.sprite = _currentList[2]
    _sprite.northSprite = _currentList[1]


    _name = _currentList[3]

    _option = subMenu:addOption(_name, nil, Greenhouse.onBuildwallsWhite, _sprite, player, _name)

    _tooltip = Greenhouse.canBuildObject(needSkills, _option, player)
    --_tooltip.description = _currentList[6] .. _tooltip.description
    _tooltip:setName(_name)
    _tooltip:setTexture(_sprite.sprite)
  end
end

Greenhouse.getwallsWhiteData = function()
  local _wallsWhiteData = {

	{
      'walls_commercial_02_48',
      'walls_commercial_02_51',
      getText('ContextMenu_Left_Side')
    },
	{
      'walls_commercial_02_49',
      'walls_commercial_02_52',
      getText('ContextMenu_Center')
    },
	{
      'walls_commercial_02_50',
      'walls_commercial_02_53',
      getText('ContextMenu_Right_Side')
    },
	{
      'walls_commercial_02_54',
      'walls_commercial_02_55',
      getText('ContextMenu_Single')	  
    },



	
  }
  return _wallsWhiteData
end


Greenhouse.onBuildwallsWhite = function(ignoreThisArgument, sprite, player, name)
  local _window = ISWindowWallObj:new(sprite.sprite, sprite.northSprite, getSpecificPlayer(player))

  _window.player = player
  _window.name = name

  _window.modData['need:Base.Plank'] = 4  
  _window.modData['need:ImprovisedGlass.GlassPane'] = 1
  _window.modData['need:Base.Screws'] = 4
  _window.modData['xp:Woodwork'] = 15

  getCell():setDrag(_window, player)
end

