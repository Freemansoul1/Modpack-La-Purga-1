if not getGreenhouseInstance then
  require('Greenhouse/Greenhouse_Main')
end

local Greenhouse = getGreenhouseInstance()

Greenhouse.wallsDetailMenuBuilder = function(subMenu, player)
	local _sprite
	local _option
	local _tooltip
	local _name = ''

  Greenhouse.neededMaterials = {
    {
      Material = 'Base.Plank',
      Amount = 1
    },
    {
      Material = 'Base.Nails',
      Amount = 1
    }
  }

  Greenhouse.neededTools = {'Hammer'}

  local needSkills = {
    Woodwork = 2
  }

  local _wallsDetailData = Greenhouse.getWallsDetailData()

  for _, _currentList in pairs(_wallsDetailData) do
    _sprite = {}
    _sprite.sprite = _currentList[1]
    _sprite.northSprite = _currentList[2]
	_sprite.eastSprite = _currentList[3]
	_sprite.southSprite = _currentList[4]
    _name = _currentList[5]

    _option = subMenu:addOption(_name, nil, Greenhouse.onBuildWallsDetail, _sprite, player, _name)

    _tooltip = Greenhouse.canBuildObject(needSkills, _option, player)
    _tooltip:setName(_name)
    _tooltip:setTexture(_sprite.sprite)
  end
end

Greenhouse.getWallsDetailData = function()
  local _wallsDetailData = {

	{
      'walls_greenhouse_01_27',
      'walls_greenhouse_01_26',
	  'walls_greenhouse_01_28',
      'walls_greenhouse_01_28',
      getText('ContextMenu_NarrowCurb')
    },	
	{
      'walls_greenhouse_01_64',
      'walls_greenhouse_01_65',
	  'walls_greenhouse_01_66',
      'walls_greenhouse_01_67',
      getText('ContextMenu_HighCurbWood')
    },	
	{
      'walls_greenhouse_01_68',
      'walls_greenhouse_01_69',
	  'walls_greenhouse_01_70',
      'walls_greenhouse_01_71',
      getText('ContextMenu_HighCurbWhite')
    },	
	{
      'walls_greenhouse_01_72',
      'walls_greenhouse_01_73',
	  'walls_greenhouse_01_74',
      'walls_greenhouse_01_75',
      getText('ContextMenu_HighCurbGreen')
    },	
	{
      'walls_greenhouse_01_76',
      'walls_greenhouse_01_77',
	  'walls_greenhouse_01_78',
      'walls_greenhouse_01_79',
      getText('ContextMenu_HighCurbBrown')
    },	
	{
      'location_community_park_01_28',
      'location_community_park_01_29',
	  'location_community_park_01_36',
      'location_community_park_01_37',
      getText('ContextMenu_Curb')
    },
	{
      'location_community_park_01_24',
      'location_community_park_01_25',
	  'location_community_park_01_27',
      'location_community_park_01_26',
      getText('ContextMenu_WoodCornerCurb')
    },
	{
      'location_community_park_01_32',
      'location_community_park_01_33',
	  'location_community_park_01_34',
      'location_community_park_01_35',
      getText('ContextMenu_WhiteCornerCurb')
    },

	
  }
  return _wallsDetailData
end


Greenhouse.onBuildWallsDetail = function(ignoreThisArgument, sprite, player, name)
local _sign = ISSimpleFurniture:new(name, sprite.sprite, sprite.northSprite)

  _sign.player = player
  _sign.name = name
  _sign.eastSprite = sprite.eastSprite
  _sign.southSprite = sprite.southSprite
  _sign.northSprite = sprite.northSprite
  _sign.canPassThrough = false
  _sign.blockAllTheSquare = false
  _sign.isCorner = true

  _sign.modData['need:Base.Plank'] = 1
  _sign.modData['need:Base.Nails'] = 1
  _sign.modData['xp:Woodwork'] = 7.5

  getCell():setDrag(_sign, player)
end
