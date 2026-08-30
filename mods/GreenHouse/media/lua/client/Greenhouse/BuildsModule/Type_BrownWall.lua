if not getGreenhouseInstance then
  require('Greenhouse/Greenhouse_Main')
end

local Greenhouse = getGreenhouseInstance()

Greenhouse.wallsBrownMenuBuilder = function(subMenu, player)
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

  local _wallsBrownData = Greenhouse.getwallsBrownData()

  for _, _currentList in pairs(_wallsBrownData) do
    _sprite = {}
    _sprite.sprite = _currentList[1]
    _sprite.northSprite = _currentList[2]


    _name = _currentList[3]

    _option = subMenu:addOption(_name, nil, Greenhouse.onBuildwallsBrown, _sprite, player, _name)

    _tooltip = Greenhouse.canBuildObject(needSkills, _option, player)
    --_tooltip.description = _currentList[6] .. _tooltip.description
    _tooltip:setName(_name)
    _tooltip:setTexture(_sprite.sprite)
  end
end

Greenhouse.getwallsBrownData = function()
  local _wallsBrownData = {

	{
      'walls_greenhouse_01_3',
      'walls_greenhouse_01_0',
      getText('ContextMenu_Left_Side')
    },
	{
      'walls_greenhouse_01_4',
      'walls_greenhouse_01_1',
      getText('ContextMenu_Center')
    },
	{
      'walls_greenhouse_01_5',
      'walls_greenhouse_01_2',
      getText('ContextMenu_Right_Side')
    },
	{
      'walls_greenhouse_01_7',
      'walls_greenhouse_01_6',
      getText('ContextMenu_Single') 
    },


	
  }
  return _wallsBrownData
end


Greenhouse.onBuildwallsBrown = function(ignoreThisArgument, sprite, player, name)
  local _window = ISWindowWallObj:new(sprite.sprite, sprite.northSprite, getSpecificPlayer(player))

  _window.player = player
  _window.name = name

  _window.modData['need:Base.Plank'] = 4  
  _window.modData['need:ImprovisedGlass.GlassPane'] = 1
  _window.modData['need:Base.Screws'] = 4
  _window.modData['xp:Woodwork'] = 15

  getCell():setDrag(_window, player)
end

