local AffineTransformation2 = require "heart.AffineTransformation2"

local Camera = {}
Camera.__index = Camera

local function sign(x)
    return x < 0 and -1 or 1
end

function Camera.new(args)
    local camera = {}
    setmetatable(camera, Camera)

    camera._viewport = {-1, -1, 1, 1}
    camera._position = {0, 0}
    camera._scale = 1
    camera._angle = 0

    if args then
        if args.viewport then
            camera:setViewport(unpack(args.viewport))
        end
        if args.position then
            camera:setPosition(unpack(args.position))
        end
        if args.scale then
            camera:setScale(args.scale)
        end
        if args.angle then
            camera:setAngle(args.angle)
        end
    end

    return camera
end

function Camera:draw()
    local viewportX, viewportY = self:getViewportCenter()
    local viewportScaleX, viewportScaleY = self:getViewportScale()
    love.graphics.translate(viewportX, viewportY)
    love.graphics.scale(viewportScaleX, viewportScaleY)

    local x, y = unpack(self._position)
    love.graphics.scale(self._scale)
    love.graphics.rotate(-self._angle)
    love.graphics.translate(-x, -y)
end

function Camera:getViewport()
    return unpack(self._viewport)
end

function Camera:setViewport(x1, y1, x2, y2)
    self._viewport = {x1, y1, x2, y2}
end

function Camera:getPosition()
    return unpack(self._position)
end

function Camera:setPosition(x, y)
    self._position = {x, y}
end

function Camera:getScale(scale)
    return self._scale
end

function Camera:setScale(scale)
    self._scale = scale
end

function Camera:getAngle()
    return self._angle
end

function Camera:setAngle(angle)
    self._angle = angle
end

function Camera:getViewportCenter()
    local x1, y1, x2, y2 = unpack(self._viewport)
    return 0.5 * (x1 + x2), 0.5 * (y1 + y2)
end

function Camera:getViewportScale()
    local x1, y1, x2, y2 = unpack(self._viewport)
    local width, height = math.abs(x2 - x1), math.abs(y2 - y1)
    local minSize = math.min(width, height)
    local signX, signY = sign(x2 - x1), sign(y2 - y1)
    return 0.5 * signX * minSize, 0.5 * signY * minSize
end

function Camera:getPixelWorldSize()
    local scaleX, scaleY = self:getViewportScale()
    return 0.5 / self._scale / math.min(math.abs(scaleX), math.abs(scaleY))
end

function Camera:getTransformation()
    local viewportX, viewportY = self:getViewportCenter()
    local viewportScaleX, viewportScaleY = self:getViewportScale()
    local x, y = unpack(self._position)

    local transformation = AffineTransformation2.new()
    transformation:translate(viewportX, viewportY)
    transformation:scale(viewportScaleX, viewportScaleY)

    transformation:scale(self._scale, self._scale)
    transformation:rotate(self._angle)
    transformation:translate(-x, -y)

    return transformation
end

function Camera:getInverseTransformation()
    local transformation = self:getTransformation()
    transformation:invert()
    return transformation
end

return Camera
