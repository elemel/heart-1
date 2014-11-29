local path = (...):match(".+%.") or ""

local LinkedSet = require(path .. "LinkedSet")

local SpriteLayer = {}
SpriteLayer.__index = SpriteLayer

function SpriteLayer.new(name)
    local layer = {}
    setmetatable(layer, SpriteLayer)

    layer._name = name
    layer._sprites = LinkedSet.new()

    return layer
end

function SpriteLayer:getName()
    return self._name
end

function SpriteLayer:addSprite(sprite)
    self._sprites:addLast(sprite)
end

function SpriteLayer:removeSprite(sprite)
    self._sprites:remove(sprite)
end

function SpriteLayer:draw()
    for sprite in self._sprites:iterate() do
        sprite:draw()
    end
end

return SpriteLayer
