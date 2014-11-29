local Scene = {}
Scene.__index = Scene

function Scene.new()
    local scene = {}
    setmetatable(scene, Scene)

    scene._layers = {}
    scene._layersByName = {}

    return scene
end

function Scene:addLayer(layer)
    table.insert(self._layers, layer)
    local name = layer:getName()
    if name then
        self._layersByName[name] = layer
    end
end

function Scene:getLayerByName(name)
    return self._layersByName[name]
end

function Scene:draw()
    for i, layer in ipairs(self._layers) do
        layer:draw()
    end
end

return Scene
