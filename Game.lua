local Scene = require "heart.Scene"
local WorldView = require "heart.WorldView"

local Game = {}
Game.__index = Game

function Game.new(config)
    local game = {}
    setmetatable(game, Game)

    config = config or {}

    game._time = 0
    game._fixedTime = 0
    game._fixedDt = config.fixedDt
    game._dt = 0

    game._scene = Scene.new()

    game._entityFactories = {}
    game._entities = heart.collection.newLinkedSet()
    game._entitiesByType = {}

    game._images = {}
    game._shaders = {}
    game._sounds = {}

    game._updatePasses = config.updatePasses or {"default"}
    game._updateSchedule = {}
    for i, pass in ipairs(game._updatePasses) do
        game._updateSchedule[pass] = {}
    end

    game._drawPasses = config.drawPasses or {"default"}
    game._drawSchedule = {}
    for i, pass in ipairs(game._drawPasses) do
        game._drawSchedule[pass] = {}
    end

    return game
end

function Game:update(dt)
    self._time = self._time + dt
    self._dt = dt

    if self._fixedDt then
        if self._fixedTime + self._fixedDt < self._time then
            self._fixedTime = self._fixedTime + self._fixedDt
            self:_updateHandlers(self._fixedDt)
        end
    else
        self._fixedTime = self._time
        self:_updateHandlers(dt)
    end
end

function Game:_updateHandlers(dt)
    for i, passName in ipairs(self._updatePasses) do
        for entity, handler in pairs(self._updateSchedule[passName]) do
            handler(entity, dt)
        end
    end
end

function Game:draw()
    for i, passName in ipairs(self._drawPasses) do
        for entity, handler in pairs(self._drawSchedule[passName]) do
            handler(entity)
        end
    end

    self._scene:draw()
end

function Game:getTime()
    return self._time
end

function Game:getDt()
    return self._dt
end

function Game:getFixedTime()
    return self._fixedTime
end

function Game:getFixedDt()
    return self._fixedDt
end

function Game:getFixedTimeFraction()
    if self._fixedDt then
        return (self._time - self._fixedTime) / self._fixedDt
    else
        return 1
    end
end

function Game:getScene()
    return self._scene
end

function Game:getEntityFactory(type_)
    return self._entityFactories[type_]
end

function Game:setEntityFactory(type_, factory)
    self._entityFactories[type_] = factory
end

function Game:addEntity(entity)
    self._entities:addLast(entity)

    local type_ = entity:getType()
    if not self._entitiesByType[type_] then
        self._entitiesByType[type_] = {}
    end
    self._entitiesByType[type_][entity] = true
end

function Game:removeEntity(entity)
    self._entities:remove(entity)

    local type_ = entity:getType()
    self._entitiesByType[type_][entity] = nil
    if not next(self._entitiesByType[type_]) then
        self._entitiesByType[type_] = nil
    end
end

function Game:getEntityByType(type_)
    local entities = self._entitiesByType[type_]
    local entity = entities and next(entities)
    return entity
end

function Game:getEntityCountByType(type_)
    local entities = self._entitiesByType[type_]
    if not entities then
        return 0
    end

    local count = 0
    for entity, _ in pairs(entities) do
        count = count + 1
    end
    return count
end

function Game:getEntitiesByType(type_)
    return self._entitiesByType[type_]
end

function Game:getCamera()
    return self._camera
end

function Game:getImage(name)
    return self._images[name]
end

function Game:setImage(name, image)
    self._images[name] = image
end

function Game:getShader(name)
    return self._shaders[name]
end

function Game:setShader(name, shader)
    self._shaders[name] = shader
end

function Game:getSound(name)
    return self._sounds[name]
end

function Game:setSound(name, sound)
    self._sounds[name] = sound
end

function Game:playSound(name, x, y)
    x = x or 0
    y = y or 0

    local sound = self._sounds[name]
    if sound then
        local clonedSound = sound:clone()
        clonedSound:setPosition(x, y)
        clonedSound:setAttenuationDistances(1, 50)
        love.audio.play(clonedSound)
    end
end

function Game:scheduleUpdate(pass, entity, handler)
    self._updateSchedule[pass][entity] = handler or entity.update
end

function Game:unscheduleUpdate(pass, entity)
    self._updateSchedule[pass][entity] = nil
end

function Game:scheduleDraw(pass, entity, handler)
    self._drawSchedule[pass][entity] = handler or entity.draw
end

function Game:unscheduleDraw(pass, entity)
    self._drawSchedule[pass][entity] = nil
end

return Game
