local path = (...):match(".+%.") or ""

local colors = require(path .. "colors")

local CircleSprite = {}
CircleSprite.__index = CircleSprite

function CircleSprite.new(config)
    local sprite = {}
    setmetatable(sprite, CircleSprite)

    config = config or {}
    sprite._center = config.center or {0, 0}
    sprite._radius = config.radius or 1
    sprite._angle = config.angle or 0
    sprite._color = config.color or {1, 1, 1, 1}
    sprite._segments = config.segments or 16

    return sprite
end

function CircleSprite:getCenter()
    return unpack(self._center)
end

function CircleSprite:setCenter(x, y)
    self._center = {x, y}
end

function CircleSprite:getAngle()
    return self._angle
end

function CircleSprite:setAngle(angle)
    self._angle = angle
end

function CircleSprite:draw()
    local r, g, b, a = unpack(self._color)
    local x, y = unpack(self._center)
    local ax, ay = math.cos(self._angle), math.sin(self._angle)
    local radius = self._radius
    local x1, y1 = x - ax * radius, y - ay * radius
    local x2, y2 = x + ax * radius, y + ay * radius

    love.graphics.setColor(colors.toByteColor(r, g, b, a))
    love.graphics.circle("fill", x, y, radius, self._segments)

    love.graphics.setColor(colors.toByteColor(0.5 * r, 0.5 * g, 0.5 * b, a))
    love.graphics.circle("line", x, y, radius, self._segments)
    love.graphics.line(x1, y1, x2, y2)
end

function CircleSprite:getColor()
    return unpack(self._color)
end

function CircleSprite:setColor(r, g, b, a)
    self._color = {r, g, b, a}
end

return CircleSprite
