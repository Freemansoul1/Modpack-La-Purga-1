if not getGreenhouseInstance then
  require('Greenhouse/Greenhouse_Main')
end

local Greenhouse = getGreenhouseInstance()

Greenhouse.wallsBlackMenuBuilder = function(subMenu, player)
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

  local _wallsBlackData = Greenhouse.getwallsBlackData()

  for _, _currentList in pairs(_wallsBlackData) do
    _sprite = {}
    _sprite.sprite = _currentList[1]
    _sprite.northSprite = _currentList[2]


    _name = _currentList[3]

    _option = subMenu:addOption(_name, nil, Greenhouse.onBuildwallsBlack, _sprite, player, _name)

    _tooltip = Greenhouse.canBuildObject(needSkills, _option, player)
    --_tooltip.description = _currentList[6] .. _tooltip.description
    _tooltip:setName(_name)
    _tooltip:setTexture(_sprite.sprite)
  end
end

Greenhouse.getwallsBlackData = function()
  local _wallsBlackData = {

	{
      'walls_commercial_01_32',
      'walls_commercial_01_33',
      getText('ContextMenu_BlackMosaicWindow')
    },
	{
      'walls_commercial_01_16',
      'walls_commercial_01_17',
      getText('ContextMenu_BlackFullWindow')
    },
	
	{
      'walls_commercial_01_96',
      'walls_commercial_01_97',
      getText('ContextMenu_FullTransparent')
    },
	
	{
      'walls_commercial_01_112',
      'walls_commercial_01_113',
      getText('ContextMenu_HalfBlack')
    },
	
  }
  return _wallsBlackData
end


Greenhouse.onBuildwallsBlack = function(ignoreThisArgument, sprite, player, name)
  local _window = ISWindowWallObj:new(sprite.sprite, sprite.northSprite, getSpecificPlayer(player))

  _window.player = player
  _window.name = name

  _window.modData['need:Base.Plank'] = 4  
  _window.modData['need:ImprovisedGlass.GlassPane'] = 1
  _window.modData['need:Base.Screws'] = 4
  _window.modData['xp:Woodwork'] = 15

  getCell():setDrag(_window, player)
end

