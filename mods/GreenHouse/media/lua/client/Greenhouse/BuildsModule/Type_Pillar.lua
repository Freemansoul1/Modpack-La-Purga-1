if not getGreenhouseInstance then
  require('Greenhouse/Greenhouse_Main')
end

local Greenhouse = getGreenhouseInstance()

Greenhouse.pillarsMenuBuilder = function(subMenu, player)
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
    Woodwork = Greenhouse.skillLevel.wallObject
  }

  local _pillarsData = Greenhouse.getpillarsData()

  for _, _currentList in pairs(_pillarsData) do
    _sprite = {}
    _sprite.sprite = _currentList[1]
    _sprite.northSprite = _currentList[2]


    _name = _currentList[3]

    _option = subMenu:addOption(_name, nil, Greenhouse.onBuildpillars, _sprite, player, _name)

    _tooltip = Greenhouse.canBuildObject(needSkills, _option, player)
    --_tooltip.description = _currentList[6] .. _tooltip.description
    _tooltip:setName(_name)
    _tooltip:setTexture(_sprite.sprite)
  end
end

Greenhouse.getpillarsData = function()
  local _pillarsData = {

	{
      'walls_exterior_house_01_35',
      'walls_exterior_house_01_35',
      getText('ContextMenu_White_Pillar')
    },
	{
      'walls_exterior_house_01_51',
      'walls_exterior_house_01_51',
      getText('ContextMenu_Brown_Pillar')
    },
	{
      'location_shop_greenes_01_12',
      'location_shop_greenes_01_12',
      getText('ContextMenu_Green_Pillar')
    },	
	{
      'walls_commercial_01_19',
      'walls_commercial_01_19',
      getText('ContextMenu_Black_Pillar')
    },
	{
      'walls_greenhouse_01_28',
      'walls_greenhouse_01_28',
      getText('ContextMenu_Small_Pillar')
    },
	
	
	

	
  }
  return _pillarsData
end


Greenhouse.onBuildpillars = function(ignoreThisArgument, sprite, player, name)
  local _pillar = ISWoodenWall:new(sprite.sprite, sprite.northSprite, nil)

  _pillar.canPassThrough = true
  _pillar.canBarricade = false
  _pillar.isCorner = true
  _pillar.player = player
  _pillar.name = name

  _pillar.modData['need:Base.Plank'] = 2
  _pillar.modData['need:Base.Nails'] = 3
  _pillar.modData['xp:Woodwork'] = 5
  _pillar.modData['wallType'] = 'pillar'

  function _pillar:getHealth()
    return Greenhouse.healthLevel.stoneWall + buildUtil.getWoodHealth(self)
  end

  Greenhouse.equipToolPrimary(_pillar, player, 'Hammer')

  getCell():setDrag(_pillar, player)
end

