local Sprite = {}
Sprite.__index = Sprite

function Sprite.new(config)
    local sprite = {}
    setmetatable(sprite, Sprite)

    config = config or {}
    sprite._vertices = config.vertices or {-1, -1, 1, -1, 1, 1, -1, 1}
    sprite._position = config.position or {0, 0}
    sprite._angle = config.angle or 0
    sprite._scale = config.scale or {1, 1}
    sprite._origin = config.origin or {0, 0}
    sprite._color = config.color or {255, 255, 255, 255}

    return sprite
end

function Sprite:getImage()
    return self._image
end

function Sprite:setImage(image)
    self._image = image
end

function Sprite:getShader()
    return self._shader
end

function Sprite:setShader(shader)
    self._shader = shader
end

function Sprite:getPosition()
    return unpack(self._position)
end

function Sprite:setPosition(x, y)
    self._position = {x, y}
end

function Sprite:getAngle()
    return self._angle
end

function Sprite:setAngle(angle)
    self._angle = angle
end

function Sprite:getScale()
    return unpack(self._scale)
end

function Sprite:setScale(scaleX, scaleY)
    self._scale = {scaleX, scaleY}
end

function Sprite:getOrigin()
    return unpack(self._origin)
end

function Sprite:setOrigin(originX, originY)
    self._origin = {originX, originY}
end

function Sprite:getColor()
    return unpack(self._color)
end

function Sprite:setColor(r, g, b, a)
    self._color = {r, g, b, a}
end

function Sprite:draw()
    if self._image then
        local cr, cg, cb, ca = unpack(self._color)
        if ca > 0 then
            local x, y = unpack(self._position)
            local r = self._angle
            local sx, sy = unpack(self._scale)
            local ox, oy = unpack(self._origin)

            love.graphics.setBlendMode("premultiplied")
            love.graphics.setShader(self._shader)
            if self._shader then
                self._shader:send("textureSize", {self._image:getDimensions()})
            end
            love.graphics.setColor(cr, cg, cb, ca)
            love.graphics.draw(self._image, x, y, r, sx, sy, ox, oy)
            love.graphics.setShader(nil)
            love.graphics.setBlendMode("alpha")
        end
    end
end

return Sprite
