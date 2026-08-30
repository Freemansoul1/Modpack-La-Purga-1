if not getGreenhouseInstance then
  require('Greenhouse/Greenhouse_Main')
end

local Greenhouse = getGreenhouseInstance()

Greenhouse.wallsRoofMenuBuilder = function(subMenu, player)
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

  local _wallsRoofData = Greenhouse.getwallsRoofData()

  for _, _currentList in pairs(_wallsRoofData) do
    _sprite = {}
    _sprite.sprite = _currentList[1]
    _sprite.northSprite = _currentList[2]
    _sprite.eastSprite = _currentList[3]
    _sprite.southSprite = _currentList[4]
    _name = _currentList[5]

    _option = subMenu:addOption(_name, nil, Greenhouse.onBuildwallsRoof, _sprite, player, _name)

    _tooltip = Greenhouse.canBuildObject(needSkills, _option, player)
    _tooltip:setName(_name)
    _tooltip:setTexture(_sprite.sprite)
  end
end


Greenhouse.getwallsRoofData = function()
  local _wallsRoofData = {

    {
      'roof_walls_greenhouse_01_0',
      'roof_walls_greenhouse_01_8',
      'roof_walls_greenhouse_01_5',
      'roof_walls_greenhouse_01_13',
      getText 'ContextMenu_WhiteRoofWall1',
    },
    {
      'roof_walls_greenhouse_01_1',
      'roof_walls_greenhouse_01_9',
      'roof_walls_greenhouse_01_4',
      'roof_walls_greenhouse_01_12',
      getText 'ContextMenu_WhiteRoofWall2',
    },
    {
	  'roof_walls_greenhouse_01_2',
      'roof_walls_greenhouse_01_10',
      'roof_walls_greenhouse_01_3',
      'roof_walls_greenhouse_01_11',
      getText 'ContextMenu_WhiteRoofWall3',
    },
    {
      'roof_walls_greenhouse_01_6',
      'roof_walls_greenhouse_01_7',
      'roof_walls_greenhouse_01_14',
      'roof_walls_greenhouse_01_15',
      getText 'ContextMenu_WhiteRoofWallMid',
    },
    {
      'roof_walls_greenhouse_01_16',
      'roof_walls_greenhouse_01_24',
      'roof_walls_greenhouse_01_21',
      'roof_walls_greenhouse_01_29',
      getText 'ContextMenu_BrownRoofWall1',
    },
    {
      'roof_walls_greenhouse_01_17',
      'roof_walls_greenhouse_01_25',
      'roof_walls_greenhouse_01_20',
      'roof_walls_greenhouse_01_28',
      getText 'ContextMenu_BrownRoofWall2',
    },
    {
	  'roof_walls_greenhouse_01_18',
      'roof_walls_greenhouse_01_26',
      'roof_walls_greenhouse_01_19',
      'roof_walls_greenhouse_01_27',
      getText 'ContextMenu_BrownRoofWall3',
    },
    {
      'roof_walls_greenhouse_01_22',
      'roof_walls_greenhouse_01_23',
      'roof_walls_greenhouse_01_30',
      'roof_walls_greenhouse_01_31',
      getText 'ContextMenu_BrownRoofWallMid',
    },
        {
      'roof_walls_greenhouse_01_32',
      'roof_walls_greenhouse_01_40',
      'roof_walls_greenhouse_01_37',
      'roof_walls_greenhouse_01_45',
      getText 'ContextMenu_GreenRoofWall1',
    },
    {
      'roof_walls_greenhouse_01_33',
      'roof_walls_greenhouse_01_41',
      'roof_walls_greenhouse_01_36',
      'roof_walls_greenhouse_01_44',
      getText 'ContextMenu_GreenRoofWall2',
    },
    {
	  'roof_walls_greenhouse_01_34',
      'roof_walls_greenhouse_01_42',
      'roof_walls_greenhouse_01_35',
      'roof_walls_greenhouse_01_43',
      getText 'ContextMenu_GreenRoofWall3',
    },
    {
      'roof_walls_greenhouse_01_38',
      'roof_walls_greenhouse_01_39',
      'roof_walls_greenhouse_01_46',
      'roof_walls_greenhouse_01_47',
      getText 'ContextMenu_GreenRoofWallMid',
    },        
	
	{
      'roof_walls_greenhouse_01_48',
      'roof_walls_greenhouse_01_56',
      'roof_walls_greenhouse_01_53',
      'roof_walls_greenhouse_01_61',
      getText 'ContextMenu_BlackRoofWall1',
    },
    {
      'roof_walls_greenhouse_01_49',
      'roof_walls_greenhouse_01_57',
      'roof_walls_greenhouse_01_52',
      'roof_walls_greenhouse_01_60',
      getText 'ContextMenu_BlackRoofWall2',
    },
    {
      'roof_walls_greenhouse_01_50',
      'roof_walls_greenhouse_01_58',
      'roof_walls_greenhouse_01_51',
      'roof_walls_greenhouse_01_59',
      getText 'ContextMenu_BlackRoofWall3',
    },
    {
      'roof_walls_greenhouse_01_54',
      'roof_walls_greenhouse_01_55',
      'roof_walls_greenhouse_01_62',
      'roof_walls_greenhouse_01_63',
      getText 'ContextMenu_BlackRoofWallMid',
    },
    
	
  }
  return _wallsRoofData
end


Greenhouse.onBuildwallsRoof = function(ignoreThisArgument, sprite, player, name)
  local _sign = ISSimpleFurniture:new(name, sprite.sprite, sprite.northSprite)

  _sign.player = player
  _sign.name = name
  _sign.eastSprite = sprite.eastSprite
  _sign.southSprite = sprite.southSprite
  _sign.northSprite = sprite.northSprite
  _sign.canPassThrough = false
  _sign.blockAllTheSquare = false
  _sign.isCorner = true
  _sign.renderFloorHelper = false

  _sign.modData['need:Base.Plank'] = 4
  _sign.modData['need:Base.Nails'] = 4
  _sign.modData['xp:Woodwork'] = 4

  getCell():setDrag(_sign, player)
end

