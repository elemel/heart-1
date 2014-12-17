local PolygonSprite = {}
PolygonSprite.__index = PolygonSprite

function PolygonSprite.new(config)
    local sprite = {}
    setmetatable(sprite, PolygonSprite)

    config = config or {}
    sprite._vertices = config.vertices or {-1, -1, 1, -1, 1, 1, -1, 1}
    sprite._position = config.position or {0, 0}
    sprite._angle = config.angle or 0
    sprite._fillColor = config.fillColor or config.color or {255, 255, 255, 255}
    sprite._lineColor = config.lineColor or config.color or {255, 255, 255, 255}

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

function PolygonSprite:getFillColor()
    return unpack(self._fillColor)
end

function PolygonSprite:setFillColor(r, g, b, a)
    self._fillColor = {r, g, b, a}
end

function PolygonSprite:getLineColor()
    return unpack(self._lineColor)
end

function PolygonSprite:setLineColor(r, g, b, a)
    self._lineColor = {r, g, b, a}
end

function PolygonSprite:draw()
    local fillRed, fillGreen, fillBlue, fillAlpha = unpack(self._fillColor)
    local lineRed, lineGreen, lineBlue, lineAlpha = unpack(self._lineColor)
    if fillAlpha > 0 or lineAlpha > 0 then
        local x, y = unpack(self._position)

        love.graphics.push()
        love.graphics.translate(x, y)
        love.graphics.rotate(self._angle)

        if fillAlpha > 0 then
            love.graphics.setColor(fillRed, fillGreen, fillBlue, fillAlpha)
            love.graphics.polygon("fill", self._vertices)
        end

        if lineAlpha > 0 then
            love.graphics.setColor(lineRed, lineGreen, lineBlue, lineAlpha)
            love.graphics.polygon("line", self._vertices)
        end

        love.graphics.pop()
    end
end

return PolygonSprite
