local path = (...):match(".+%.") or ""

local colors = require(path .. "colors")

local PolygonSprite = {}
PolygonSprite.__index = PolygonSprite

function PolygonSprite.new(config)
    local sprite = {}
    setmetatable(sprite, PolygonSprite)

    config = config or {}
    sprite._vertices = config.vertices or {-1, -1, 1, -1, 1, 1, -1, 1}
    sprite._position = config.position or {0, 0}
    sprite._angle = config.angle or 0
    sprite._color = config.color or {1, 1, 1, 1}

    return sprite
end

function PolygonSprite:getPosition()
    return unpack(self._position)
end

function PolygonSprite:setPosition(x, y)
    self._position = {x, y}
end

function PolygonSprite:getAngle()
    return self._angle
end

function PolygonSprite:setAngle(angle)
    self._angle = angle
end

function PolygonSprite:getColor()
    return unpack(self._color)
end

function PolygonSprite:setColor(r, g, b, a)
    self._color = {r, g, b, a}
end

function PolygonSprite:draw()
    local r, g, b, a = unpack(self._color)
    local x, y = unpack(self._position)

    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(self._angle)

    love.graphics.setColor(colors.toByteColor(r, g, b, a))
    love.graphics.polygon("fill", self._vertices)

    love.graphics.setColor(colors.toByteColor(0.5 * r, 0.5 * g, 0.5 * b, a))
    love.graphics.polygon("line", self._vertices)

    love.graphics.pop()
end

return PolygonSprite
