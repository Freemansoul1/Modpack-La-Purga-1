require'ISUI/Maps/ISMapDefinitions'

local function overlayPNG(mapUI, x, y, scale, layerName, tex, alpha)
    local texture = getTexture(tex)
    if not texture then return end
    local mapAPI = mapUI.javaObject:getAPIv1()
    local styleAPI = mapAPI:getStyleAPI()
    local layer = styleAPI:newTextureLayer(layerName)
    layer:setMinZoom(0)
    layer:addFill(0, 255, 255, 255, (alpha or 1.0) * 255)
    layer:addTexture(0, tex)
    layer:setBoundsInSquares(x, y, x + texture:getWidth() * scale, y + texture:getHeight() * scale)
end

LootMaps.Init.PISTAS_PistaLaboratorio = function(mapUI)

    local mapAPI = mapUI.javaObject:getAPIv1()
    MapUtils.initDirectoryMapData(mapUI, 'media/maps/Muldraugh, KY')
    mapAPI:setBoundsInSquares(10, 0, 1233, 925)
    overlayPNG(mapUI, 10, 0, 1.0, "PISTAS_PistaLaboratorio", "media/ui/LootableMaps/PistaLaboratorio.png", 1.0)
end

LootMaps.Init.PISTAS_PistaPandora = function(mapUI)

    local mapAPI = mapUI.javaObject:getAPIv1()
    MapUtils.initDirectoryMapData(mapUI, 'media/maps/Muldraugh, KY')
    mapAPI:setBoundsInSquares(10, 0, 1566, 624)
    overlayPNG(mapUI, 10, 0, 1.0, "PISTAS_PistaPandora", "media/ui/LootableMaps/PistaPandora2.png", 1.0)

end

