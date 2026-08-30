if not getGreenhouseInstance then
  require('Greenhouse/Greenhouse_Main')
end

local Greenhouse = getGreenhouseInstance()


Greenhouse.doorsMenuBuilder = function(subMenu, player)
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
    },
    {
      Material = 'Base.Doorknob',
      Amount = 1
    },
    {
      Material = 'Base.Hinge',
      Amount = 2
    }
  }

  Greenhouse.neededTools = {'Hammer'}

  local needSkills = {
    Woodwork = Greenhouse.skillLevel.doorObject
  }

  local _data = {
   	
	White_Single_door = 
	{
		sprites = {
			sprite = 'fixtures_doors_01_44',
			northSprite = 'fixtures_doors_01_45',
			openSprite = 'fixtures_doors_01_46',
			openNorthSprite = 'fixtures_doors_01_47',
		},
      action = Greenhouse.onBuildDoor,
    },
	
		Brown_Single_door = 
	{
		sprites = {
			sprite = 'fixtures_doors_02_4',
			northSprite = 'fixtures_doors_02_5',
			openSprite = 'fixtures_doors_02_6',
			openNorthSprite = 'fixtures_doors_02_7',
		},
      action = Greenhouse.onBuildDoor,
    },
	
		Green_Single_door = 
	{
		sprites = {
			sprite = 'walls_greenhouse_01_12',
			northSprite = 'walls_greenhouse_01_13',
			openSprite = 'walls_greenhouse_01_14',
			openNorthSprite = 'walls_greenhouse_01_15',
		},
      action = Greenhouse.onBuildDoor,
    },		
	Black_Glass_door = 
	{
		sprites = {
			sprite = 'fixtures_doors_01_40',
			northSprite = 'fixtures_doors_01_41',
			openSprite = 'fixtures_doors_01_42',
			openNorthSprite = 'fixtures_doors_01_43',
		},
      action = Greenhouse.onBuildDoor,
    },		
	
	Black_2Glass_door = 
	{
		sprites = {
			sprite = 'fixtures_doors_01_48',
			northSprite = 'fixtures_doors_01_49',
			openSprite = 'fixtures_doors_01_50',
			openNorthSprite = 'fixtures_doors_01_51',
		},
      action = Greenhouse.onBuildDoor,
    },

  }

  for key, data in pairs(_data) do
    _name = getText('ContextMenu_' .. key)
    _option = subMenu:addOption(_name, nil, data.action, data.sprites, player, _name)
    _tooltip = Greenhouse.canBuildObject(needSkills, _option, player)
    _tooltip:setName(_name)
    _tooltip:setTexture(data.sprites.sprite)
  end
end




Greenhouse.onBuildDoor = function(ignoreThisArgument, sprite, player, name)
  local _door = ISWoodenDoor:new(sprite.sprite, sprite.northSprite, sprite.openSprite, sprite.openNorthSprite)

  _door.player = player
  _door.name = name

  _door.modData['need:Base.Plank'] = 4
  _door.modData['need:Base.Nails'] = 4
  _door.modData['need:Base.Hinge'] = 2
  _door.modData['need:Base.Doorknob'] = 1
  _door.modData['xp:Woodwork'] = 5

  getCell():setDrag(_door, player)
end