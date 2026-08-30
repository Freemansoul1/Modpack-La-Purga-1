if not getGreenhouseInstance then
  require('Greenhouse/Greenhouse_Main')
end

local Greenhouse = getGreenhouseInstance()

Greenhouse.roofMenuBuilder = function(subMenu, player)
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
      Amount = 2
    },
    {
      Material = 'ImprovisedGlass.GlassPane',
      Amount = 1
    }
  }

  Greenhouse.neededTools = {'Hammer'}

  local needSkills = {
    Woodwork = 2
  }
 
			_sprite = {}
			_sprite.sprite = 'roofs_greenhouse_01_0'
			_sprite.northSprite = 'roofs_greenhouse_01_5'
			_sprite.eastSprite = 'roofs_greenhouse_01_0'
			_sprite.southSprite = 'roofs_greenhouse_01_5'

			_name = getText 'ContextMenu_WhiteRoof1'

			_option = subMenu:addOption(_name, nil, Greenhouse.onBuildRoof, _sprite, player, _name)

		    _tooltip = Greenhouse.canBuildObject(needSkills, _option, player)
			_tooltip:setName(_name)
			_tooltip:setTexture(_sprite.sprite)
			
			--*******************************************************
			_sprite = {}
			_sprite.sprite = 'roofs_greenhouse_01_1'
			_sprite.northSprite = 'roofs_greenhouse_01_4'
			_sprite.eastSprite = 'roofs_greenhouse_01_1'
			_sprite.southSprite = 'roofs_greenhouse_01_4'

			_name = getText 'ContextMenu_WhiteRoof2'

			_option = subMenu:addOption(_name, nil, Greenhouse.onBuildRoof, _sprite, player, _name)

		    _tooltip = Greenhouse.canBuildObject(needSkills, _option, player)
			_tooltip:setName(_name)
			_tooltip:setTexture(_sprite.sprite)
			--*******************************************************
			_sprite = {}
			_sprite.sprite = 'roofs_greenhouse_01_2'
			_sprite.northSprite = 'roofs_greenhouse_01_3'
			_sprite.eastSprite = 'roofs_greenhouse_01_2'
			_sprite.southSprite = 'roofs_greenhouse_01_3'

			_name = getText 'ContextMenu_WhiteRoof3'

			_option = subMenu:addOption(_name, nil, Greenhouse.onBuildRoof, _sprite, player, _name)

		    _tooltip = Greenhouse.canBuildObject(needSkills, _option, player)
			_tooltip:setName(_name)
			_tooltip:setTexture(_sprite.sprite)
			--*******************************************************
			_sprite = {}
			_sprite.sprite = 'roofs_greenhouse_01_6'
			_sprite.northSprite = 'roofs_greenhouse_01_7'
			_sprite.eastSprite = 'roofs_greenhouse_01_14'
			_sprite.southSprite = 'roofs_greenhouse_01_15'

			_name = getText 'ContextMenu_WhiteRoofHalf'

			_option = subMenu:addOption(_name, nil, Greenhouse.onBuildRoof, _sprite, player, _name)

		    _tooltip = Greenhouse.canBuildObject(needSkills, _option, player)
			_tooltip:setName(_name)
			_tooltip:setTexture(_sprite.sprite)
			
			--*******************************************************
			_sprite = {}
			_sprite.sprite = 'roofs_greenhouse_01_16'
			_sprite.northSprite = 'roofs_greenhouse_01_21'
			_sprite.eastSprite = 'roofs_greenhouse_01_16'
			_sprite.southSprite = 'roofs_greenhouse_01_21'

			_name = getText 'ContextMenu_BrownRoof1'

			_option = subMenu:addOption(_name, nil, Greenhouse.onBuildRoof, _sprite, player, _name)

		    _tooltip = Greenhouse.canBuildObject(needSkills, _option, player)
			_tooltip:setName(_name)
			_tooltip:setTexture(_sprite.sprite)
			--*******************************************************
			_sprite = {}
			_sprite.sprite = 'roofs_greenhouse_01_17'
			_sprite.northSprite = 'roofs_greenhouse_01_20'
			_sprite.eastSprite = 'roofs_greenhouse_01_17'
			_sprite.southSprite = 'roofs_greenhouse_01_20'

			_name = getText 'ContextMenu_BrownRoof2'

			_option = subMenu:addOption(_name, nil, Greenhouse.onBuildRoof, _sprite, player, _name)

		    _tooltip = Greenhouse.canBuildObject(needSkills, _option, player)
			_tooltip:setName(_name)
			_tooltip:setTexture(_sprite.sprite)
			--*******************************************************
			_sprite = {}
			_sprite.sprite = 'roofs_greenhouse_01_18'
			_sprite.northSprite = 'roofs_greenhouse_01_19'
			_sprite.eastSprite = 'roofs_greenhouse_01_18'
			_sprite.southSprite = 'roofs_greenhouse_01_19'

			_name = getText 'ContextMenu_BrownRoof3'

			_option = subMenu:addOption(_name, nil, Greenhouse.onBuildRoof, _sprite, player, _name)

		    _tooltip = Greenhouse.canBuildObject(needSkills, _option, player)
			_tooltip:setName(_name)
			_tooltip:setTexture(_sprite.sprite)
			--*******************************************************
			_sprite = {}
			_sprite.sprite = 'roofs_greenhouse_01_22'
			_sprite.northSprite = 'roofs_greenhouse_01_23'
			_sprite.eastSprite = 'roofs_greenhouse_01_30'
			_sprite.southSprite = 'roofs_greenhouse_01_31'

			_name = getText 'ContextMenu_BrownRoofHalf'

			_option = subMenu:addOption(_name, nil, Greenhouse.onBuildRoof, _sprite, player, _name)

		    _tooltip = Greenhouse.canBuildObject(needSkills, _option, player)
			_tooltip:setName(_name)
			_tooltip:setTexture(_sprite.sprite)
			--*******************************************************
			_sprite = {}
			_sprite.sprite = 'roofs_greenhouse_01_32'
			_sprite.northSprite = 'roofs_greenhouse_01_37'
			_sprite.eastSprite = 'roofs_greenhouse_01_32'
			_sprite.southSprite = 'roofs_greenhouse_01_37'

			_name = getText 'ContextMenu_GreenRoof1'

			_option = subMenu:addOption(_name, nil, Greenhouse.onBuildRoof, _sprite, player, _name)

		    _tooltip = Greenhouse.canBuildObject(needSkills, _option, player)
			_tooltip:setName(_name)
			_tooltip:setTexture(_sprite.sprite)
			--*******************************************************
			_sprite = {}
			_sprite.sprite = 'roofs_greenhouse_01_33'
			_sprite.northSprite = 'roofs_greenhouse_01_36'
			_sprite.eastSprite = 'roofs_greenhouse_01_33'
			_sprite.southSprite = 'roofs_greenhouse_01_36'

			_name = getText 'ContextMenu_GreenRoof2'

			_option = subMenu:addOption(_name, nil, Greenhouse.onBuildRoof, _sprite, player, _name)

		    _tooltip = Greenhouse.canBuildObject(needSkills, _option, player)
			_tooltip:setName(_name)
			_tooltip:setTexture(_sprite.sprite)
			--*******************************************************
			_sprite = {}
			_sprite.sprite = 'roofs_greenhouse_01_34'
			_sprite.northSprite = 'roofs_greenhouse_01_35'
			_sprite.eastSprite = 'roofs_greenhouse_01_34'
			_sprite.southSprite = 'roofs_greenhouse_01_35'

			_name = getText 'ContextMenu_GreenRoof3'

			_option = subMenu:addOption(_name, nil, Greenhouse.onBuildRoof, _sprite, player, _name)

		    _tooltip = Greenhouse.canBuildObject(needSkills, _option, player)
			_tooltip:setName(_name)
			_tooltip:setTexture(_sprite.sprite)
			--*******************************************************
			_sprite = {}
			_sprite.sprite = 'roofs_greenhouse_01_38'
			_sprite.northSprite = 'roofs_greenhouse_01_39'
			_sprite.eastSprite = 'roofs_greenhouse_01_46'
			_sprite.southSprite = 'roofs_greenhouse_01_47'

			_name = getText 'ContextMenu_GreenRoofHalf'

			_option = subMenu:addOption(_name, nil, Greenhouse.onBuildRoof, _sprite, player, _name)

		    _tooltip = Greenhouse.canBuildObject(needSkills, _option, player)
			_tooltip:setName(_name)
			_tooltip:setTexture(_sprite.sprite)
						
						
			--*******************************************************
			_sprite = {}
			_sprite.sprite = 'roofs_02_32'
			_sprite.northSprite = 'roofs_02_37'
			_sprite.eastSprite = 'roofs_02_32'
			_sprite.southSprite = 'roofs_02_37'

			_name = getText 'ContextMenu_BlackRoof1'

			_option = subMenu:addOption(_name, nil, Greenhouse.onBuildRoof, _sprite, player, _name)

		    _tooltip = Greenhouse.canBuildObject(needSkills, _option, player)
			_tooltip:setName(_name)
			_tooltip:setTexture(_sprite.sprite)
			--*******************************************************
			_sprite = {}
			_sprite.sprite = 'roofs_02_33'
			_sprite.northSprite = 'roofs_02_36'
			_sprite.eastSprite = 'roofs_02_33'
			_sprite.southSprite = 'roofs_02_36'

			_name = getText 'ContextMenu_BlackRoof2'

			_option = subMenu:addOption(_name, nil, Greenhouse.onBuildRoof, _sprite, player, _name)

		    _tooltip = Greenhouse.canBuildObject(needSkills, _option, player)
			_tooltip:setName(_name)
			_tooltip:setTexture(_sprite.sprite)
			--*******************************************************
			_sprite = {}
			_sprite.sprite = 'roofs_02_34'
			_sprite.northSprite = 'roofs_02_35'
			_sprite.eastSprite = 'roofs_02_34'
			_sprite.southSprite = 'roofs_02_35'

			_name = getText 'ContextMenu_BlackRoof3'

			_option = subMenu:addOption(_name, nil, Greenhouse.onBuildRoof, _sprite, player, _name)

		    _tooltip = Greenhouse.canBuildObject(needSkills, _option, player)
			_tooltip:setName(_name)
			_tooltip:setTexture(_sprite.sprite)
			--*******************************************************
			_sprite = {}
			_sprite.sprite = 'roofs_02_47'
			_sprite.northSprite = 'roofs_02_46'
			_sprite.eastSprite = 'roofs_02_78'
			_sprite.southSprite = 'roofs_02_79'

			_name = getText 'ContextMenu_BlackRoofHalf'

			_option = subMenu:addOption(_name, nil, Greenhouse.onBuildRoof, _sprite, player, _name)

		    _tooltip = Greenhouse.canBuildObject(needSkills, _option, player)
			_tooltip:setName(_name)
			_tooltip:setTexture(_sprite.sprite)
			
  
	Greenhouse.neededMaterials = {
		{
		  Material = 'Base.Plank',
		  Amount = 1
		},
		{
		  Material = 'Base.Nails',
		  Amount = 2
		},
		{
		  Material = 'ImprovisedGlass.GlassPane',
		  Amount = 1
		}
	}

  Greenhouse.neededTools = {'Hammer'}

  local needSkills = {
    Woodwork = 2
  }

  			_sprite = {}
			_sprite.sprite = 'roofs_greenhouse_01_8'
			_sprite.northSprite = 'roofs_greenhouse_01_11'

			_name = getText 'ContextMenu_WhiteRoofFlat'

			_option = subMenu:addOption(_name, nil, Greenhouse.onBuildFlatRoof, _sprite, player, _name)

		    _tooltip = Greenhouse.canBuildObject(needSkills, _option, player)
			_tooltip:setName(_name)
			_tooltip:setTexture(_sprite.sprite)
			--*******************************************************
			_sprite = {}
			_sprite.sprite = 'roofs_greenhouse_01_9'
			_sprite.northSprite = 'roofs_greenhouse_01_12'

			_name = getText 'ContextMenu_BrownRoofFlat'

			_option = subMenu:addOption(_name, nil, Greenhouse.onBuildFlatRoof, _sprite, player, _name)

		    _tooltip = Greenhouse.canBuildObject(needSkills, _option, player)
			_tooltip:setName(_name)
			_tooltip:setTexture(_sprite.sprite)
			--*******************************************************
			_sprite = {}
			_sprite.sprite = 'roofs_greenhouse_01_10'
			_sprite.northSprite = 'roofs_greenhouse_01_13'

			_name = getText 'ContextMenu_GreenRoofFlat'

			_option = subMenu:addOption(_name, nil, Greenhouse.onBuildFlatRoof, _sprite, player, _name)

		    _tooltip = Greenhouse.canBuildObject(needSkills, _option, player)
			_tooltip:setName(_name)
			_tooltip:setTexture(_sprite.sprite)
			--*******************************************************
			_sprite = {}
			_sprite.sprite = 'roofs_02_54'
			_sprite.northSprite = 'roofs_02_50'

			_name = getText 'ContextMenu_BlackRoofFlat'

			_option = subMenu:addOption(_name, nil, Greenhouse.onBuildFlatRoof, _sprite, player, _name)

		    _tooltip = Greenhouse.canBuildObject(needSkills, _option, player)
			_tooltip:setName(_name)
			_tooltip:setTexture(_sprite.sprite)

  
  
  
end


Greenhouse.onBuildRoof = function(ignoreThisArgument, sprite, player, name)
	  local _sign = ISSimpleFurniture:new(name, sprite.sprite, sprite.northSprite)

	  _sign.player = player
	  _sign.name = name
	  _sign.eastSprite = sprite.eastSprite
	  _sign.southSprite = sprite.southSprite
	  _sign.northSprite = sprite.northSprite
	  _sign.canPassThrough = true
	  _sign.blockAllTheSquare = false
	  _sign.isCorner = true
	  _sign.renderFloorHelper = true

	  _sign.modData['need:Base.Plank'] = 1
	  _sign.modData['need:Base.Nails'] = 2
	  _sign.modData['need:ImprovisedGlass.GlassPane'] = 1
	  _sign.modData['xp:Woodwork'] = 5

	  getCell():setDrag(_sign, player)
end

Greenhouse.onBuildFlatRoof = function(ignoreThisArgument, sprite, player, name)
	  local _floor = ISWoodenFloor:new(sprite.sprite, sprite.northSprite)

	  _floor.player = player
	  _floor.name = name

	  _floor.modData['need:Base.Plank'] = 1
	  _floor.modData['need:Base.Nails'] = 2
	  _floor.modData['need:ImprovisedGlass.GlassPane'] = 1
	  _floor.modData['xp:Woodwork'] = 5

	  getCell():setDrag(_floor, player)
end
