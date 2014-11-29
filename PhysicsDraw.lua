local PhysicsDraw = {}
PhysicsDraw.__index = PhysicsDraw

function PhysicsDraw.new(world, callback)
    draw = {}
    setmetatable(draw, PhysicsDraw)

    draw._world = world
    draw._callback = callback

    return draw
end

function PhysicsDraw:draw()
    local bodies = self._world:getBodyList()
    for i, body in pairs(bodies) do
        if callback and callback.beginBody then
            callback:beginBody(body)
        end

        for i, fixture in pairs(body:getFixtureList()) do
            if callback and callback.beginFixture then
                callback:beginFixture(fixture)
            end

            local shape = fixture:getShape()
            if shape:getType() == "chain" then
                love.graphics.line(body:getWorldPoints(shape:getPoints()))

                if callback and callback.getNeighbors then
                    local x0, y0, x3, y3 = callback:getNeighbors(fixture)
                    local x1, y1 = shape:getPoint(1)
                    local x2, y2 = shape:getPoint(shape:getVertexCount())
                    love.graphics.line(body:getWorldPoints(x0, y0, x1, y1))
                    love.graphics.line(body:getWorldPoints(x2, y2, x3, y3))
                end
            elseif shape:getType() == "circle" then
                local x, y = body:getWorldPoints(shape:getPoint())
                local directionX, directionY = body:getWorldVector(1, 0)
                local radius = shape:getRadius()
                love.graphics.circle("line", x, y, shape:getRadius(), 16)
                love.graphics.line(x, y, x + radius * directionX, y + radius * directionY)
            elseif shape:getType() == "edge" then
                love.graphics.line(body:getWorldPoints(shape:getPoints()))
            elseif shape:getType() == "polygon" then
                love.graphics.polygon("line", body:getWorldPoints(shape:getPoints()))
            end

            if callback and callback.endFixture then
                callback:endFixture(fixture)
            end
        end

        if callback and callback.endBody then
            callback:endBody(body)
        end
    end
end

return PhysicsDraw
