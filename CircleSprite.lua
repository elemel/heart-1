local CircleSprite = {}
CircleSprite.__index = CircleSprite

function CircleSprite.new(config)
    local sprite = {}
    setmetatable(sprite, CircleSprite)

    config = config or {}
    sprite._position = config.position or {0, 0}
    sprite._radius = config.radius or 1
    sprite._angle = config.angle or 0
    sprite._fillColor = config.fillColor or {255, 255, 255, 255}
    sprite._lineColor = config.lineColor or {0, 0, 0, 0}
    sprite._segments = config.segments or 32

    return sprite
end

function CircleSprite:getPosition()
    return unpack(self._position)
end

function CircleSprite:setPosition(x, y)
    self._position = {x, y}
end

function CircleSprite:getAngle()
    return self._angle
end

function CircleSprite:setAngle(angle)
    self._angle = angle
end

function CircleSprite:getFillColor()
    return unpack(self._fillColor)
end

function CircleSprite:setFillColor(r, g, b, a)
    self._fillColor = {r, g, b, a}
end

function CircleSprite:getLineColor()
    return unpack(self._lineColor)
end

function CircleSprite:setLineColor(r, g, b, a)
    self._lineColor = {r, g, b, a}
end

function CircleSprite:draw()
    local fillRed, fillGreen, fillBlue, fillAlpha = unpack(self._fillColor)
    local lineRed, lineGreen, lineBlue, lineAlpha = unpack(self._lineColor)
    if fillAlpha > 0 or lineAlpha > 0 then
        local x, y = unpack(self._position)
        local ax, ay = math.cos(self._angle), math.sin(self._angle)
        local radius = self._radius
        local x1, y1 = x - ax * radius, y - ay * radius
        local x2, y2 = x + ax * radius, y + ay * radius

        if fillAlpha > 0 then
            love.graphics.setColor(fillRed, fillGreen, fillBlue, fillAlpha)
            love.graphics.circle("fill", x, y, radius, self._segments)
        end

        if lineAlpha > 0 then
            love.graphics.setColor(lineRed, lineGreen, lineBlue, lineAlpha)
            love.graphics.circle("line", x, y, radius, self._segments)
            love.graphics.line(x1, y1, x2, y2)
        end
    end
end

return CircleSprite
